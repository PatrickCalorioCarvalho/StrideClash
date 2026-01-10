package services


import (
	"context"
	"database/sql"

	"github.com/google/uuid"
	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
)


type ChampionshipService struct {
	pb.UnimplementedChampionshipServiceServer
	DB *sql.DB
}


func (s *ChampionshipService) CreateChampionship(
	ctx context.Context,
	req *pb.CreateChampionshipRequest,
) (*pb.ChampionshipResponse, error) {

	id := uuid.New()

	_, err := s.DB.Exec(`
		INSERT INTO championships (id, name, start_at, end_at)
		VALUES ($1, $2, $3, $4)
		`,
		id,
		req.Name,
		req.StartAt.AsTime(),
		req.EndAt.AsTime(),
	)


	if err != nil {
		return nil, err
	}


	return &pb.ChampionshipResponse{
		Championship: &pb.Championship{
		Id: id.String(),
		Name: req.Name,
		StartAt: req.StartAt,
		EndAt: req.EndAt,
		},
	}, nil
}