package main

import (
	"log"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	"github.com/PatrickCalorioCarvalho/StrideClash/backend/db"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/repository"
	"github.com/PatrickCalorioCarvalho/StrideClash/backend/services"
	pb "github.com/PatrickCalorioCarvalho/StrideClash/backend/proto"
)

func main() {
	dbConn := db.Connect()

	repo := repository.NewChampionshipRepository(dbConn)

	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatal(err)
	}

	grpcServer := grpc.NewServer()

	pb.RegisterChampionshipServiceServer(
		grpcServer,
		&services.ChampionshipService{
			Repo: repo,
		},
	)

	reflection.Register(grpcServer)
	
	log.Println("🚀 gRPC server running on :50051")
	grpcServer.Serve(lis)
}
