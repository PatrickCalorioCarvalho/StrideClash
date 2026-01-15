package services

import (
	"context"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"

	"google.golang.org/protobuf/types/known/timestamppb"
)

type WalkService struct {
	pb.UnimplementedWalkServiceServer
	Walks *repository.WalkRepository
}

func (s *WalkService) StartWalk(
	ctx context.Context,
	req *pb.StartWalkRequest,
) (*pb.StartWalkResponse, error) {

	walk, err := s.Walks.Create(req.UserId, req.ChampionshipId)
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

	// Aqui depois você:
	// 1) salva os pontos
	// 2) fecha o polígono
	// 3) valida se voltou próximo do início

	polygonWKT := "POLYGON((...))"

	return &pb.FinishWalkResponse{
		PolygonWkt: polygonWKT,
	}, nil
}
