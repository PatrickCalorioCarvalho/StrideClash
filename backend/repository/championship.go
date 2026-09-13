package repository

import (
	"crypto/rand"
	"database/sql"
	"math/big"
	"sort"
	"time"

	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/lib/pq"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type ChampionshipRepository struct {
	DB *sql.DB
}

func NewChampionshipRepository(db *sql.DB) *ChampionshipRepository {
	return &ChampionshipRepository{DB: db}
}

// joinCodeAlphabet excludes visually ambiguous characters (0/O, 1/I) since
// codes are meant to be read aloud or retyped from a phone screen.
const joinCodeAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
const joinCodeLength = 6

func generateJoinCode() (string, error) {
	code := make([]byte, joinCodeLength)
	for i := range code {
		n, err := rand.Int(rand.Reader, big.NewInt(int64(len(joinCodeAlphabet))))
		if err != nil {
			return "", err
		}
		code[i] = joinCodeAlphabet[n.Int64()]
	}
	return string(code), nil
}

func isUniqueViolation(err error) bool {
	pqErr, ok := err.(*pq.Error)
	return ok && pqErr.Code == "23505"
}

// Create inserts a championship and auto-joins its creator as the first
// member. The join code is retried a few times on the astronomically
// unlikely chance of a collision with an existing one.
func (r *ChampionshipRepository) Create(
	id string,
	name string,
	startAt, endAt time.Time,
	createdBy string,
) (*pb.Championship, error) {

	const maxAttempts = 5

	for attempt := 0; attempt < maxAttempts; attempt++ {
		joinCode, err := generateJoinCode()
		if err != nil {
			return nil, err
		}

		tx, err := r.DB.Begin()
		if err != nil {
			return nil, err
		}

		_, err = tx.Exec(`
			INSERT INTO championships (id, name, start_at, end_at, created_by, join_code)
			VALUES ($1, $2, $3, $4, $5, $6)
		`, id, name, startAt, endAt, createdBy, joinCode)

		if err != nil {
			tx.Rollback()
			if isUniqueViolation(err) {
				continue
			}
			return nil, err
		}

		if _, err := tx.Exec(`
			INSERT INTO championship_members (championship_id, user_id)
			VALUES ($1, $2)
		`, id, createdBy); err != nil {
			tx.Rollback()
			return nil, err
		}

		if err := tx.Commit(); err != nil {
			return nil, err
		}

		return &pb.Championship{
			Id:        id,
			Name:      name,
			StartAt:   timestamppb.New(startAt),
			EndAt:     timestamppb.New(endAt),
			JoinCode:  joinCode,
			CreatedBy: createdBy,
		}, nil
	}

	return nil, sql.ErrTxDone
}

// ListForUser returns championships the user created or joined via join code.
func (r *ChampionshipRepository) ListForUser(userID string) ([]*pb.Championship, error) {
	rows, err := r.DB.Query(`
		SELECT c.id, c.name, c.start_at, c.end_at, c.join_code, COALESCE(c.created_by::text, '')
		FROM championships c
		JOIN championship_members m ON m.championship_id = c.id
		WHERE m.user_id = $1
		ORDER BY c.start_at DESC
	`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []*pb.Championship

	for rows.Next() {
		var id, name, joinCode, createdBy string
		var start, end time.Time

		if err := rows.Scan(&id, &name, &start, &end, &joinCode, &createdBy); err != nil {
			return nil, err
		}

		result = append(result, &pb.Championship{
			Id:        id,
			Name:      name,
			StartAt:   timestamppb.New(start),
			EndAt:     timestamppb.New(end),
			JoinCode:  joinCode,
			CreatedBy: createdBy,
		})
	}

	return result, nil
}

// Join adds a user to the championship identified by joinCode. Re-joining an
// already-joined championship is a harmless no-op.
func (r *ChampionshipRepository) Join(userID, joinCode string) (*pb.Championship, error) {
	var c pb.Championship
	var start, end time.Time
	var createdBy string

	err := r.DB.QueryRow(`
		SELECT id, name, start_at, end_at, COALESCE(created_by::text, '')
		FROM championships
		WHERE join_code = $1
	`, joinCode).Scan(&c.Id, &c.Name, &start, &end, &createdBy)

	if err != nil {
		return nil, err
	}

	if _, err := r.DB.Exec(`
		INSERT INTO championship_members (championship_id, user_id)
		VALUES ($1, $2)
		ON CONFLICT DO NOTHING
	`, c.Id, userID); err != nil {
		return nil, err
	}

	c.StartAt = timestamppb.New(start)
	c.EndAt = timestamppb.New(end)
	c.JoinCode = joinCode
	c.CreatedBy = createdBy

	return &c, nil
}

func (r *ChampionshipRepository) UpdateEndDate(
	id string,
	newEnd time.Time,
	userID string,
) (*pb.Championship, error) {

	var c pb.Championship
	var start, end time.Time
	var joinCode, createdBy string

	err := r.DB.QueryRow(`
		UPDATE championships
		SET end_at = $1
		WHERE id = $2 AND created_by = $3
		RETURNING id, name, start_at, end_at, join_code, COALESCE(created_by::text, '')
	`, newEnd, id, userID).Scan(
		&c.Id,
		&c.Name,
		&start,
		&end,
		&joinCode,
		&createdBy,
	)

	if err != nil {
		return nil, err
	}

	c.StartAt = timestamppb.New(start)
	c.EndAt = timestamppb.New(end)
	c.JoinCode = joinCode
	c.CreatedBy = createdBy

	return &c, nil
}

// RankingEntry aggregates a user's captured area and polygons within a championship.
type RankingEntry struct {
	UserID      string
	UserName    string
	UserPicture string
	TotalAreaM2 float64
	PolygonsWKT []string
}

// GetRanking returns each participant's total captured area and polygons for
// a championship, ordered from most to least area captured.
func (r *ChampionshipRepository) GetRanking(championshipID string) ([]*RankingEntry, error) {
	rows, err := r.DB.Query(`
		SELECT u.id, u.name, u.picture, w.area_m2, ST_AsText(w.polygon)
		FROM walks w
		JOIN users u ON u.id = w.user_id
		WHERE w.championship_id = $1
		  AND w.finished_at IS NOT NULL
		  AND w.polygon IS NOT NULL
		ORDER BY u.id
	`, championshipID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	entriesByUser := make(map[string]*RankingEntry)
	var order []string

	for rows.Next() {
		var userID, userName string
		var userPicture sql.NullString
		var areaM2 float64
		var polygonWKT string

		if err := rows.Scan(&userID, &userName, &userPicture, &areaM2, &polygonWKT); err != nil {
			return nil, err
		}

		entry, ok := entriesByUser[userID]
		if !ok {
			entry = &RankingEntry{
				UserID:      userID,
				UserName:    userName,
				UserPicture: userPicture.String,
			}
			entriesByUser[userID] = entry
			order = append(order, userID)
		}

		entry.TotalAreaM2 += areaM2
		entry.PolygonsWKT = append(entry.PolygonsWKT, polygonWKT)
	}

	result := make([]*RankingEntry, len(order))
	for i, userID := range order {
		result[i] = entriesByUser[userID]
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].TotalAreaM2 > result[j].TotalAreaM2
	})

	return result, nil
}

func (r *ChampionshipRepository) Delete(id string, userID string) (bool, error) {
	res, err := r.DB.Exec(`
		DELETE FROM championships
		WHERE id = $1 AND created_by = $2
	`, id, userID)

	if err != nil {
		return false, err
	}

	rows, _ := res.RowsAffected()
	return rows > 0, nil
}
