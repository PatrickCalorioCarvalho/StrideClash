package services

import (
	"context"
	"fmt"
	"strings"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// minPolygonPoints is the smallest ring that can enclose a non-zero area.
const minPolygonPoints = 3

// minValidAreaM2 filters out GPS-jitter loops: a phone standing still can
// still drift a few meters between fixes, closing a "polygon" with a
// non-zero but bogus area. Real captures cover much more than this.
const minValidAreaM2 = 25.0

type WalkService struct {
	pb.UnimplementedWalkServiceServer
	Walks *repository.WalkRepository
}

func (s *WalkService) StartWalk(
	ctx context.Context,
	req *pb.StartWalkRequest,
) (*pb.StartWalkResponse, error) {

	var championshipID *string
	if req.ChampionshipId != "" {
		championshipID = &req.ChampionshipId
	}

	walk, err := s.Walks.Create(req.UserId, championshipID)
	if err != nil {
		return nil, err
	}

	return &pb.StartWalkResponse{
		WalkId:    walk.ID,
		StartedAt: timestamppb.New(walk.StartedAt),
	}, nil
}

func (s *WalkService) FinishWalk(
	ctx context.Context,
	req *pb.FinishWalkRequest,
) (*pb.FinishWalkResponse, error) {

	if len(req.Points) < minPolygonPoints {
		return nil, status.Errorf(
			codes.InvalidArgument,
			"são necessários pelo menos %d pontos para fechar um polígono",
			minPolygonPoints,
		)
	}

	if err := s.Walks.AddPoints(req.WalkId, req.Points); err != nil {
		return nil, err
	}

	polygonWKT := buildPolygonWKT(closeRing(req.Points))

	areaM2, err := s.Walks.Finish(req.WalkId, polygonWKT)
	if err != nil {
		return nil, err
	}

	if areaM2 < minValidAreaM2 {
		if err := s.Walks.ClearPolygon(req.WalkId); err != nil {
			return nil, err
		}
		return &pb.FinishWalkResponse{PolygonWkt: "", AreaM2: 0}, nil
	}

	return &pb.FinishWalkResponse{
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

	return &pb.GetUserStatsResponse{
		TotalAreaM2: totalAreaM2,
		WalkCount:   int32(walkCount),
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
