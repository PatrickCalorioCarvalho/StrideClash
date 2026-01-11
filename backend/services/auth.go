package services

import (
	"context"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/auth"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthService struct {
	pb.UnimplementedAuthServiceServer
	GoogleClientID string
}

func (s *AuthService) Login(
	ctx context.Context,
	req *pb.LoginRequest,
) (*pb.LoginResponse, error) {

	user, err := auth.VerifyGoogleToken(
		ctx,
		req.IdToken,
		s.GoogleClientID,
	)

	if err != nil {
		return nil, status.Error(
			codes.Unauthenticated,
			"login inválido",
		)
	}

	return &pb.LoginResponse{
		UserId: user.Sub,
		Email:  user.Email,
		Name:   user.Name,
	}, nil
}
