### Lista os serviços gRPC disponíveis no servidor em execução na porta 50051
#grpcurl -plaintext localhost:50051 list
### Exibe os métodos disponíveis para o serviço game.ChampionshipService
#grpcurl -plaintext localhost:50051 list game.ChampionshipService
### Chama o método CreateChampionship do serviço game.ChampionshipService com parâmetros de exemplo

grpcurl -plaintext -d '{"name": "Teste Centro","start_at": "2026-01-01T08:00:00Z","end_at": "2026-01-07T08:00:00Z"}' localhost:50051 game.ChampionshipService/CreateChampionship
