package db

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func Connect() *sql.DB {

	if err := godotenv.Load(); err != nil {
		log.Println("⚠️ .env não encontrado, usando variáveis do sistema")
	}

	user := os.Getenv("DB_USER")
	pass := os.Getenv("DB_PASSWORD")
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	name := os.Getenv("DB_NAME")
	ssl := os.Getenv("DB_SSLMODE")

	dsn := fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s?sslmode=%s",
		user, pass, host, port, name, ssl,
	)

	db, err := sql.Open(
		"postgres",
		dsn,
	)

	if err != nil {
		log.Fatal(err)
	}

	if err := db.Ping(); err != nil {
		log.Fatal(err)
	}

	runMigrations(db)

	return db
}

// runMigrations applies small, idempotent schema fixes to an already-running
// database — database/init/001_schema.sql only ever runs once, on first
// container init, so an existing Postgres volume never picks up changes made
// there after the fact.
func runMigrations(db *sql.DB) {
	// The polygon column used to be locked to GEOMETRY(Polygon, 4326), but
	// repairing a self-intersecting walk (ST_MakeValid) or splitting one via
	// ST_Difference can legitimately produce a MultiPolygon — relax the
	// column to accept any geometry type. Safe to run every startup: once
	// already relaxed, this is a no-op.
	if _, err := db.Exec(`
		ALTER TABLE walks ALTER COLUMN polygon TYPE geometry(Geometry, 4326)
	`); err != nil {
		log.Printf("⚠️ migração (relaxar tipo da coluna polygon) falhou: %v", err)
	}
}
