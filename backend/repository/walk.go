package repository

import (
	"database/sql"
	"time"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
)

type WalkRepository struct {
	DB *sql.DB
}

func NewWalkRepository(db *sql.DB) *WalkRepository {
	return &WalkRepository{DB: db}
}

// GetSyncState reports whether a walk (identified by the client-generated
// id) was already fully synced in an earlier attempt, so SyncWalk can be
// retried safely without double-processing it.
func (r *WalkRepository) GetSyncState(walkID string) (exists bool, finished bool, areaM2 float64, err error) {
	var area sql.NullFloat64
	var finishedAt sql.NullTime

	err = r.DB.QueryRow(`
		SELECT finished_at, area_m2 FROM walks WHERE id = $1
	`, walkID).Scan(&finishedAt, &area)

	if err == sql.ErrNoRows {
		return false, false, 0, nil
	}
	if err != nil {
		return false, false, 0, err
	}

	return true, finishedAt.Valid, area.Float64, nil
}

// EnsureCreated inserts the walk row if it doesn't exist yet. Safe to call
// again on a retried sync — an existing row is left untouched.
func (r *WalkRepository) EnsureCreated(
	walkID, userID string,
	championshipID *string,
	startedAt time.Time,
) error {
	_, err := r.DB.Exec(`
		INSERT INTO walks (id, user_id, championship_id, started_at)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (id) DO NOTHING
	`, walkID, userID, championshipID, startedAt)

	return err
}

// ReplacePoints discards any points left over from a previous failed sync
// attempt for this walk and stores the fresh ones the client just sent.
func (r *WalkRepository) ReplacePoints(walkID string, points []*pb.WalkPoint) error {
	tx, err := r.DB.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if _, err := tx.Exec(`DELETE FROM walk_points WHERE walk_id = $1`, walkID); err != nil {
		return err
	}

	stmt, err := tx.Prepare(`
		INSERT INTO walk_points (walk_id, lat, lng, speed, recorded_at)
		VALUES ($1, $2, $3, $4, $5)
	`)
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, p := range points {
		if _, err := stmt.Exec(walkID, p.Lat, p.Lng, p.Speed, p.Timestamp.AsTime()); err != nil {
			return err
		}
	}

	return tx.Commit()
}

// Finish closes the walk with its final polygon and returns the captured
// area in square meters. finishedAt is the client's own timestamp (when the
// walker actually stopped), not necessarily when the sync happened.
func (r *WalkRepository) Finish(walkID, polygonWKT string, finishedAt time.Time) (float64, error) {
	var areaM2 float64

	// ST_MakeValid repairs self-intersecting rings (a walked path that
	// crosses its own trail forms one) — without it, a self-intersecting
	// polygon's area is ambiguous/wrong, and later ST_Difference calls
	// against it fail outright with a GEOS TopologyException.
	err := r.DB.QueryRow(`
		UPDATE walks
		SET finished_at = $1,
			polygon = ST_MakeValid(ST_GeomFromText($2, 4326)),
			area_m2 = ST_Area(ST_MakeValid(ST_GeomFromText($2, 4326))::geography)
		WHERE id = $3
		RETURNING area_m2
	`, finishedAt, polygonWKT, walkID).Scan(&areaM2)

	return areaM2, err
}

// ClearPolygon discards a walk's captured geometry (e.g. GPS-noise loops too
// small to be a real capture) while keeping the walk and its raw points.
func (r *WalkRepository) ClearPolygon(walkID string) error {
	_, err := r.DB.Exec(`
		UPDATE walks
		SET polygon = NULL, area_m2 = 0
		WHERE id = $1
	`, walkID)

	return err
}

// ResolveOverlaps claims territory for a freshly-captured polygon: any
// earlier walk (anyone's) whose polygon overlaps it gets that overlapping
// sliver cut out via ST_Difference, with its area_m2 recomputed to match.
// Whichever walk syncs to the server later wins the overlap — there's no
// attempt to reconcile by the walker's actual clock, since an offline walk
// can sync well after a newer one already claimed the same ground.
func (r *WalkRepository) ResolveOverlaps(newWalkID, polygonWKT string) error {
	// Both sides go through ST_MakeValid: the incoming polygon just in
	// case, and the stored one because rows written before this repair
	// existed may still hold a self-intersecting ring.
	if _, err := r.DB.Exec(`
		UPDATE walks
		SET polygon = ST_Difference(ST_MakeValid(polygon), ST_MakeValid(ST_GeomFromText($1, 4326))),
			area_m2 = ST_Area(ST_Difference(ST_MakeValid(polygon), ST_MakeValid(ST_GeomFromText($1, 4326)))::geography)
		WHERE id != $2
		  AND finished_at IS NOT NULL
		  AND polygon IS NOT NULL
		  AND ST_Intersects(ST_MakeValid(polygon), ST_MakeValid(ST_GeomFromText($1, 4326)))
	`, polygonWKT, newWalkID); err != nil {
		return err
	}

	// A fully-consumed polygon becomes an empty geometry, not NULL — collapse
	// it to NULL/0 so the "still holds territory" checks elsewhere
	// (polygon IS NOT NULL) treat it consistently with every other
	// no-longer-valid capture.
	_, err := r.DB.Exec(`
		UPDATE walks
		SET polygon = NULL, area_m2 = 0
		WHERE polygon IS NOT NULL AND ST_IsEmpty(polygon)
	`)

	return err
}

// GetUserStats sums a user's captured area across every finished walk,
// championship or not — a personal lifetime total.
func (r *WalkRepository) GetUserStats(userID string) (totalAreaM2 float64, walkCount int, err error) {
	err = r.DB.QueryRow(`
		SELECT COALESCE(SUM(area_m2), 0), COUNT(*)
		FROM walks
		WHERE user_id = $1 AND finished_at IS NOT NULL AND polygon IS NOT NULL
	`, userID).Scan(&totalAreaM2, &walkCount)

	return totalAreaM2, walkCount, err
}
