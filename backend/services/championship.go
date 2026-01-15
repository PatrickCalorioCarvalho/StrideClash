package services

import (
	"context"
	"time"

	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"
)

type ChampionshipService struct {
	pb.UnimplementedChampionshipServiceServer
	Championships *repository.ChampionshipRepository
}

func (s *ChampionshipService) CreateChampionship(
	ctx context.Context,
	req *pb.CreateChampionshipRequest,
) (*pb.ChampionshipResponse, error) {

	id := uuid.New().String()

	err := s.Championships.Create(
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

	championships, err := s.Championships.List()
	if err != nil {
		return nil, err
	}

	return &pb.ListChampionshipsResponse{
		Championships: championships,
	}, nil
}

func (s *ChampionshipService) UpdateChampionshipEndDate(
	ctx context.Context,
	req *pb.UpdateChampionshipEndDateRequest,
) (*pb.ChampionshipResponse, error) {

	if req.NewEndAt.AsTime().Before(time.Now()) {
		return nil, status.Error(
			codes.InvalidArgument,
			"nova data deve ser maior que hoje",
		)
	}

	c, err := s.Championships.UpdateEndDate(
		req.Id,
		req.NewEndAt.AsTime(),
	)

	if err != nil {
		return nil, err
	}

	return &pb.ChampionshipResponse{
		Championship: c,
	}, nil
}

func (s *ChampionshipService) DeleteChampionship(
	ctx context.Context,
	req *pb.DeleteChampionshipRequest,
) (*pb.DeleteChampionshipResponse, error) {

	ok, err := s.Championships.Delete(req.Id)
	if err != nil {
		return nil, err
	}

	return &pb.DeleteChampionshipResponse{
		Success: ok,
	}, nil
}
