package services

import (
	"context"
	"fmt"
	"math"
	"strings"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// minPolygonPoints is the smallest ring that can enclose a non-zero area.
const minPolygonPoints = 3

// minValidAreaM2 filters out GPS-jitter loops: a phone standing still can
// still drift a few meters between fixes, closing a "polygon" with a
// non-zero but bogus area. Real captures cover much more than this.
const minValidAreaM2 = 25.0

// maxClosingGapMeters caps how far apart the walker's first and last real
// GPS fixes can be and still count as "closed the loop". Beyond this, the
// straight line closeRing draws between them isn't the walker's actual
// path — for an open route (there-and-back, a spiral, anything that
// doesn't return near its start) that invented edge can sweep a much
// bigger area than what was really walked, so it's better to capture
// nothing than to report a misleading number.
const maxClosingGapMeters = 50.0

// maxWalkingSpeedMps (~25 km/h, a hard sprint) caps how fast the walker can
// go between two consecutive GPS fixes and still count as being on foot.
// Standing still or pausing is never a problem here — it's specifically the
// distance/time ratio between fixes that's checked, so a long pause with no
// movement just reads as 0 m/s, not a violation. Sustained speeds above
// this look like a bike, motorcycle, or car instead.
const maxWalkingSpeedMps = 7.0

type WalkService struct {
	pb.UnimplementedWalkServiceServer
	Walks *repository.WalkRepository
}

// SyncWalk uploads a walk the client recorded entirely on its own — offline
// the whole time, or synced right away, it makes no difference here. Safe
// to retry: replaying an already-finished client_walk_id just returns the
// same result instead of reprocessing it.
func (s *WalkService) SyncWalk(
	ctx context.Context,
	req *pb.SyncWalkRequest,
) (*pb.SyncWalkResponse, error) {

	if len(req.Points) < minPolygonPoints {
		return nil, status.Errorf(
			codes.InvalidArgument,
			"são necessários pelo menos %d pontos para fechar um polígono",
			minPolygonPoints,
		)
	}

	_, finished, existingArea, err := s.Walks.GetSyncState(req.ClientWalkId)
	if err != nil {
		return nil, err
	}
	if finished {
		return &pb.SyncWalkResponse{AreaM2: existingArea}, nil
	}

	var championshipID *string
	if req.ChampionshipId != "" {
		championshipID = &req.ChampionshipId
	}

	if err := s.Walks.EnsureCreated(
		req.ClientWalkId, req.UserId, championshipID, req.StartedAt.AsTime(),
	); err != nil {
		return nil, err
	}

	if err := s.Walks.ReplacePoints(req.ClientWalkId, req.Points); err != nil {
		return nil, err
	}

	polygonWKT := buildPolygonWKT(closeRing(req.Points))

	areaM2, err := s.Walks.Finish(req.ClientWalkId, polygonWKT, req.FinishedAt.AsTime())
	if err != nil {
		return nil, err
	}

	first, last := req.Points[0], req.Points[len(req.Points)-1]
	closingGapM := haversineMeters(first.Lat, first.Lng, last.Lat, last.Lng)

	if areaM2 < minValidAreaM2 || closingGapM > maxClosingGapMeters || exceedsHumanSpeed(req.Points) {
		if err := s.Walks.ClearPolygon(req.ClientWalkId); err != nil {
			return nil, err
		}
		return &pb.SyncWalkResponse{PolygonWkt: "", AreaM2: 0}, nil
	}

	// A real capture — claim any territory it overlaps from earlier walks.
	if err := s.Walks.ResolveOverlaps(req.ClientWalkId, polygonWKT); err != nil {
		return nil, err
	}

	return &pb.SyncWalkResponse{
		PolygonWkt: polygonWKT,
		AreaM2:     areaM2,
	}, nil
}

func (s *WalkService) GetUserStats(
	ctx context.Context,
	req *pb.GetUserStatsRequest,
) (*pb.GetUserStatsResponse, error) {

	totalAreaM2, walkCount, err := s.Walks.GetUserStats(req.UserId)
	if err != nil {
		return nil, err
	}

	byChampionship, err := s.Walks.GetUserStatsByChampionship(req.UserId)
	if err != nil {
		return nil, err
	}

	stats := make([]*pb.ChampionshipStat, len(byChampionship))
	for i, s := range byChampionship {
		stats[i] = &pb.ChampionshipStat{
			ChampionshipId:   s.ChampionshipID,
			ChampionshipName: s.ChampionshipName,
			AreaM2:           s.AreaM2,
			WalkCount:        int32(s.WalkCount),
		}
	}

	return &pb.GetUserStatsResponse{
		TotalAreaM2:    totalAreaM2,
		WalkCount:      int32(walkCount),
		ByChampionship: stats,
	}, nil
}

// closeRing appends the starting point to the end of the trail if the walker
// didn't already return to it, so the trail forms a valid closed polygon ring.
func closeRing(points []*pb.WalkPoint) []*pb.WalkPoint {
	first, last := points[0], points[len(points)-1]
	if first.Lat == last.Lat && first.Lng == last.Lng {
		return points
	}

	ring := make([]*pb.WalkPoint, len(points), len(points)+1)
	copy(ring, points)
	return append(ring, first)
}

// buildPolygonWKT renders a closed ring as WKT ("POLYGON((lng lat, ...))"),
// the format PostGIS' ST_GeomFromText expects.
func buildPolygonWKT(ring []*pb.WalkPoint) string {
	coords := make([]string, len(ring))
	for i, p := range ring {
		coords[i] = fmt.Sprintf("%f %f", p.Lng, p.Lat)
	}

	return fmt.Sprintf("POLYGON((%s))", strings.Join(coords, ", "))
}

// exceedsHumanSpeed checks every consecutive pair of fixes for a speed no
// person walking or running could sustain. A long pause between two points
// just yields a small distance over a large time — near-zero speed, never
// flagged — so resting mid-walk is never mistaken for cheating.
func exceedsHumanSpeed(points []*pb.WalkPoint) bool {
	for i := 1; i < len(points); i++ {
		prev, cur := points[i-1], points[i]

		dt := cur.Timestamp.AsTime().Sub(prev.Timestamp.AsTime()).Seconds()
		if dt <= 0 {
			continue
		}

		dist := haversineMeters(prev.Lat, prev.Lng, cur.Lat, cur.Lng)
		if dist/dt > maxWalkingSpeedMps {
			return true
		}
	}

	return false
}

// haversineMeters is the great-circle distance between two lat/lng points,
// in meters — good enough at walking-route scale, no need for PostGIS here.
func haversineMeters(lat1, lng1, lat2, lng2 float64) float64 {
	const earthRadiusM = 6371000.0

	toRad := func(deg float64) float64 { return deg * math.Pi / 180 }
	dLat := toRad(lat2 - lat1)
	dLng := toRad(lng2 - lng1)

	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(toRad(lat1))*math.Cos(toRad(lat2))*math.Sin(dLng/2)*math.Sin(dLng/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	return earthRadiusM * c
}
