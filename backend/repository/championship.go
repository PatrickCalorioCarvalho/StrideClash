package repository

import (
	"database/sql"
	"time"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type ChampionshipRepository struct {
	DB *sql.DB
}

func NewChampionshipRepository(db *sql.DB) *ChampionshipRepository {
	return &ChampionshipRepository{DB: db}
}

func (r *ChampionshipRepository) Create(
	id string,
	name string,
	startAt, endAt time.Time,
) error {

	_, err := r.DB.Exec(`
		INSERT INTO championships (id, name, start_at, end_at)
		VALUES ($1, $2, $3, $4)
	`, id, name, startAt, endAt)

	return err
}

func (r *ChampionshipRepository) List() ([]*pb.Championship, error) {
	rows, err := r.DB.Query(`
		SELECT id, name, start_at, end_at
		FROM championships
		ORDER BY start_at DESC
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []*pb.Championship

	for rows.Next() {
		var id, name string
		var start, end time.Time

		if err := rows.Scan(&id, &name, &start, &end); err != nil {
			return nil, err
		}

		result = append(result, &pb.Championship{
			Id:      id,
			Name:    name,
			StartAt: timestamppb.New(start),
			EndAt:   timestamppb.New(end),
		})
	}

	return result, nil
}

func (r *ChampionshipRepository) UpdateEndDate(
	id string,
	newEnd time.Time,
) (*pb.Championship, error) {

	var c pb.Championship
	var start, end time.Time
	
	err := r.DB.QueryRow(`
		UPDATE championships
		SET end_at = $1
		WHERE id = $2
		RETURNING id, name, start_at, end_at
	`, newEnd, id).Scan(
		&c.Id,
		&c.Name,
		&start,
		&end,
	)

	if err != nil {
		return nil, err
	}

	c.StartAt = timestamppb.New(start)
	c.EndAt = timestamppb.New(end)

	return &c, nil
}

func (r *ChampionshipRepository) Delete(id string) (bool, error) {
	res, err := r.DB.Exec(`
		DELETE FROM championships
		WHERE id = $1
	`, id)

	if err != nil {
		return false, err
	}

	rows, _ := res.RowsAffected()
	return rows > 0, nil
}
