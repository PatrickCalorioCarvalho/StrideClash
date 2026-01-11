package auth

import (
	"context"
	"errors"

	"google.golang.org/api/idtoken"
)

type GoogleUser struct {
	Email string
	Name  string
	Sub   string
}

func VerifyGoogleToken(
	ctx context.Context,
	idToken string,
	clientID string,
) (*GoogleUser, error) {

	payload, err := idtoken.Validate(ctx, idToken, clientID)
	if err != nil {
		return nil, errors.New("token google inválido")
	}

	return &GoogleUser{
		Email: payload.Claims["email"].(string),
		Name:  payload.Claims["name"].(string),
		Sub:   payload.Subject,
	}, nil
}
