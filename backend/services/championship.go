package services

import (
	"context"

	"github.com/google/uuid"
	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"
)

type ChampionshipService struct {
	pb.UnimplementedChampionshipServiceServer
	Repo *repository.ChampionshipRepository
}

func (s *ChampionshipService) CreateChampionship(
	ctx context.Context,
	req *pb.CreateChampionshipRequest,
) (*pb.ChampionshipResponse, error) {

	id := uuid.New().String()

	err := s.Repo.Create(
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
			Id:      id,
			Name:    req.Name,
			StartAt: req.StartAt,
			EndAt:   req.EndAt,
		},
	}, nil
}

func (s *ChampionshipService) ListChampionships(
	ctx context.Context,
	req *pb.ListChampionshipsRequest,
) (*pb.ListChampionshipsResponse, error) {

	championships, err := s.Repo.List()
	if err != nil {
		return nil, err
	}

	return &pb.ListChampionshipsResponse{
		Championships: championships,
	}, nil
}
