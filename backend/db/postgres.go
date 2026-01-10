package db
import (
	"database/sql"
	"log"


	_ "github.com/lib/pq"
)


func Connect() *sql.DB {
	db, err := sql.Open(
		"postgres",
		"postgres://postgres:*P4ssw0rd@localhost:5432/strideclash?sslmode=disable",
	)


	if err != nil {
		log.Fatal(err)
	}


	if err := db.Ping(); err != nil {
		log.Fatal(err)
	}


	return db
}