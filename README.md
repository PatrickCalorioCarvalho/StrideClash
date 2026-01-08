🏃‍♂️ StrideClash

> StrideClash é um game de caminhada baseado em geolocalização onde jogadores capturam território caminhando no mundo real.



Cada passo conta: ao caminhar e fechar um trajeto, você cria um polígono, conquista uma área e compete em campeonatos por maior território capturado.

Inspirado em ideias como Strava + jogos de território, StrideClash foca em estratégia, movimento real e competição saudável.


---

🎮 Conceito do Jogo

Jogadores caminham com o app aberto

O trajeto gera pontos GPS

Ao fechar um caminho, um polígono (área) é criado

A área válida é contabilizada no campeonato ativo

Ganha quem capturar mais área dentro do período


> 🚫 Sem carros, sem trapaça: o backend valida velocidade, tempo, distância e geometria.




---

🧠 Arquitetura

StrideClash foi pensado como um game engine backend-first, com foco em performance e regras confiáveis.

📱 Mobile (Flutter)
 ├─ GPS + Background Tracking
 ├─ Mapas (Mapbox / Google Maps)
 ├─ gRPC Client
 └─ Login Social (Google / GitHub)

🧠 Backend (Go)
 ├─ gRPC API (Game Engine)
 ├─ Regras de Jogo & Anti-cheat
 ├─ Ranking em tempo real
 └─ Serviços desacoplados

🗺️ PostgreSQL + PostGIS
 ├─ Áreas (Polígonos)
 ├─ Regiões de campeonato
 └─ Cálculo espacial real

🔥 Redis
 └─ Cache de ranking


---

🛠️ Stack Tecnológica

📱 Mobile

Flutter

gRPC (protobuf)

Background Location

Mapbox / Google Maps

Login com Google / GitHub


🧠 Backend

Go (Golang)

gRPC

PostgreSQL + PostGIS

Redis


🔐 Autenticação

Login social no mobile

Validação de JWT no backend

Sem senha, sem complexidade desnecessária



---

📡 Comunicação

gRPC para dados de jogo (caminhada, campeonatos, ranking)

WebSocket (futuro) para ranking em tempo real

REST opcional para admin/debug



---

🚶 Fluxo da Caminhada

Iniciar Caminhada
 → Captura GPS
 → Desenho do trajeto
 → Fechamento do polígono
 → Envio via gRPC
 → Validação (anti-cheat)
 → Cálculo da área (PostGIS)
 → Atualização do ranking


---

🏆 Campeonatos

Período definido (início / fim)

Região delimitada

Ranking por área total capturada

Suporte a múltiplos campeonatos

