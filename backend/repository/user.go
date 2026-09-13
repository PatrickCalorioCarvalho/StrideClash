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
	Picture   string
}

type UserRepository struct {
	DB *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (r *UserRepository) FindByGoogleSub(sub string) (*User, error) {
	var u User
	var picture sql.NullString

	err := r.DB.QueryRow(`
		SELECT id, google_sub, email, name, picture
		FROM users
		WHERE google_sub = $1
	`, sub).Scan(
		&u.ID,
		&u.GoogleSub,
		&u.Email,
		&u.Name,
		&picture,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}

	if err != nil {
		return nil, err
	}

	u.Picture = picture.String
	return &u, nil
}

func (r *UserRepository) Create(
	sub string,
	email string,
	name string,
	picture string,
) (*User, error) {

	id := uuid.New()

	_, err := r.DB.Exec(`
		INSERT INTO users (id, google_sub, email, name, picture)
		VALUES ($1, $2, $3, $4, $5)
	`, id.String(), sub, email, name, picture)

	if err != nil {
		return nil, err
	}

	return &User{
		ID:        id.String(),
		GoogleSub: sub,
		Email:     email,
		Name:      name,
		Picture:   picture,
	}, nil
}

// UpdatePicture refreshes a user's avatar URL, e.g. when it changes on Google's side.
func (r *UserRepository) UpdatePicture(userID, picture string) error {
	_, err := r.DB.Exec(`
		UPDATE users SET picture = $1 WHERE id = $2
	`, picture, userID)

	return err
}
