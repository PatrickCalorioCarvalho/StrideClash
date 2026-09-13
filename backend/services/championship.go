package services

import (
	"context"
	"database/sql"
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

	championship, err := s.Championships.Create(
		id,
		req.Name,
		req.StartAt.AsTime(),
		req.EndAt.AsTime(),
		req.UserId,
	)
	if err != nil {
		return nil, err
	}

	return &pb.ChampionshipResponse{
		Championship: championship,
	}, nil
}

func (s *ChampionshipService) ListChampionships(
	ctx context.Context,
	req *pb.ListChampionshipsRequest,
) (*pb.ListChampionshipsResponse, error) {

	championships, err := s.Championships.ListForUser(req.UserId)
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
		req.UserId,
	)

	if err == sql.ErrNoRows {
		return nil, status.Error(
			codes.PermissionDenied,
			"só quem criou o campeonato pode alterá-lo",
		)
	}
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

	ok, err := s.Championships.Delete(req.Id, req.UserId)
	if err != nil {
		return nil, err
	}

	if !ok {
		return nil, status.Error(
			codes.PermissionDenied,
			"só quem criou o campeonato pode excluí-lo",
		)
	}

	return &pb.DeleteChampionshipResponse{
		Success: ok,
	}, nil
}

func (s *ChampionshipService) JoinChampionship(
	ctx context.Context,
	req *pb.JoinChampionshipRequest,
) (*pb.JoinChampionshipResponse, error) {

	championship, err := s.Championships.Join(req.UserId, req.JoinCode)

	if err == sql.ErrNoRows {
		return nil, status.Error(codes.NotFound, "código inválido")
	}
	if err != nil {
		return nil, err
	}

	return &pb.JoinChampionshipResponse{
		Championship: championship,
	}, nil
}

func (s *ChampionshipService) GetChampionshipRanking(
	ctx context.Context,
	req *pb.GetChampionshipRankingRequest,
) (*pb.GetChampionshipRankingResponse, error) {

	ranking, err := s.Championships.GetRanking(req.ChampionshipId)
	if err != nil {
		return nil, err
	}

	entries := make([]*pb.ChampionshipRankingEntry, len(ranking))
	for i, r := range ranking {
		entries[i] = &pb.ChampionshipRankingEntry{
			UserId:         r.UserID,
			UserName:       r.UserName,
			UserPictureUrl: r.UserPicture,
			TotalAreaM2:    r.TotalAreaM2,
			PolygonsWkt:    r.PolygonsWKT,
		}
	}

	return &pb.GetChampionshipRankingResponse{
		Entries: entries,
	}, nil
}
