#atualiza os arquivos .pb.go a partir dos arquivos .proto
protoc  --go_out=backend  --go-grpc_out=backend  --go_opt=paths=source_relative  --go-grpc_opt=paths=source_relative  proto/championship.proto
protoc  --go_out=backend  --go-grpc_out=backend  --go_opt=paths=source_relative  --go-grpc_opt=paths=source_relative  proto/auth.proto

#atualiza os arquivos .pb.dart a partir dos arquivos .proto
protoc -I proto --dart_out=grpc:mobile/lib/generated proto/championship.proto
protoc -I proto --dart_out=grpc:mobile/lib/generated proto/auth.proto