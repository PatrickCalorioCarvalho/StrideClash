package repository

import (
	"database/sql"
	"time"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/google/uuid"
)

type Walk struct {
	ID             string
	UserID         string
	ChampionshipID string
	StartedAt      time.Time
	FinishedAt     *time.Time
}

type WalkRepository struct {
	DB *sql.DB
}

func NewWalkRepository(db *sql.DB) *WalkRepository {
	return &WalkRepository{DB: db}
}

func (r *WalkRepository) Create(userID string, championshipID *string) (*Walk, error) {
	id := uuid.New().String()
	now := time.Now()

	_, err := r.DB.Exec(`
		INSERT INTO walks (id, user_id, championship_id, started_at)
		VALUES ($1, $2, $3, $4)
	`, id, userID, championshipID, now)

	if err != nil {
		return nil, err
	}

	walk := &Walk{
		ID:        id,
		UserID:    userID,
		StartedAt: now,
	}
	if championshipID != nil {
		walk.ChampionshipID = *championshipID
	}

	return walk, nil
}

// AddPoints persists the raw GPS trail captured on the client for a walk.
func (r *WalkRepository) AddPoints(walkID string, points []*pb.WalkPoint) error {
	tx, err := r.DB.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

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

// Finish closes the walk with its final polygon and returns the captured area in square meters.
func (r *WalkRepository) Finish(walkID, polygonWKT string) (float64, error) {
	var areaM2 float64

	err := r.DB.QueryRow(`
		UPDATE walks
		SET finished_at = NOW(),
			polygon = ST_GeomFromText($1, 4326),
			area_m2 = ST_Area(ST_GeomFromText($1, 4326)::geography)
		WHERE id = $2
		RETURNING area_m2
	`, polygonWKT, walkID).Scan(&areaM2)

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
