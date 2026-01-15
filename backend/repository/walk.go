package repository

import (
	"database/sql"
	"time"

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

func (r *WalkRepository) Create(userID, championshipID string) (*Walk, error) {
	id := uuid.New().String()
	now := time.Now()

	_, err := r.DB.Exec(`
		INSERT INTO walks (id, user_id, championship_id, started_at)
		VALUES ($1, $2, $3, $4)
	`, id, userID, championshipID, now)

	if err != nil {
		return nil, err
	}

	return &Walk{
		ID:             id,
		UserID:         userID,
		ChampionshipID: championshipID,
		StartedAt:      now,
	}, nil
}
