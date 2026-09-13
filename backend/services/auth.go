package services

import (
	"context"

	"github.com/PatrickCalorioCarvalho/StrideClash/backend/auth"
	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthService struct {
	pb.UnimplementedAuthServiceServer
	GoogleClientID string
	Users          *repository.UserRepository
}

func (s *AuthService) Login(
	ctx context.Context,
	req *pb.LoginRequest,
) (*pb.LoginResponse, error) {

	googleUser, err := auth.VerifyGoogleToken(
		ctx,
		req.IdToken,
		s.GoogleClientID,
	)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "login inválido")
	}

	user, err := s.Users.FindByGoogleSub(googleUser.Sub)
	if err != nil {
		return nil, err
	}

	if user == nil {
		user, err = s.Users.Create(
			googleUser.Sub,
			googleUser.Email,
			googleUser.Name,
			googleUser.Picture,
		)
		if err != nil {
			return nil, err
		}
	} else if googleUser.Picture != user.Picture {
		if err := s.Users.UpdatePicture(user.ID, googleUser.Picture); err != nil {
			return nil, err
		}
		user.Picture = googleUser.Picture
	}

	return &pb.LoginResponse{
		UserId: user.ID,
		Email:  user.Email,
		Name:   user.Name,
	}, nil
}
