package repository

import (
	"database/sql"

	"github.com/google/uuid"
)

type User struct {
	ID        string
	GoogleSub string
	Email     string
	Name      string
}

type UserRepository struct {
	DB *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (r *UserRepository) FindByGoogleSub(sub string) (*User, error) {
	var u User

	err := r.DB.QueryRow(`
		SELECT id, google_sub, email, name
		FROM users
		WHERE google_sub = $1
	`, sub).Scan(
		&u.ID,
		&u.GoogleSub,
		&u.Email,
		&u.Name,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}

	if err != nil {
		return nil, err
	}

	return &u, nil
}

func (r *UserRepository) Create(
	sub string,
	email string,
	name string,
) (*User, error) {

	id := uuid.New()

	_, err := r.DB.Exec(`
		INSERT INTO users (id, google_sub, email, name)
		VALUES ($1, $2, $3, $4)
	`, id.String(), sub, email, name)

	if err != nil {
		return nil, err
	}

	return &User{
		ID:        id.String(),
		GoogleSub: sub,
		Email:     email,
		Name:      name,
	}, nil
}
