package main

import (
	"log"
	"net"
	"os"

	"github.com/joho/godotenv"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	"github.com/PatrickCalorioCarvalho/StrideClash/backend/db"
	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/services"
)

func main() {

	if err := godotenv.Load(); err != nil {
		log.Println("⚠️ .env não encontrado, usando variáveis do sistema")
	}

	dbConn := db.Connect()

	championship := repository.NewChampionshipRepository(dbConn)
	user := repository.NewUserRepository(dbConn)
	walk := repository.NewWalkRepository(dbConn)

	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatal(err)
	}

	grpcServer := grpc.NewServer()

	authService := &services.AuthService{
		GoogleClientID: os.Getenv("GOOGLE_CLIENT_ID"),
		Users:          user,
	}
	pb.RegisterAuthServiceServer(grpcServer, authService)

	pb.RegisterChampionshipServiceServer(
		grpcServer,
		&services.ChampionshipService{
			Championships: championship,
		},
	)

	pb.RegisterWalkServiceServer(
		grpcServer,
		&services.WalkService{
			Walks: walk,
		},
	)

	reflection.Register(grpcServer)

	log.Println("🚀 gRPC server running on :50051")
	grpcServer.Serve(lis)
}
