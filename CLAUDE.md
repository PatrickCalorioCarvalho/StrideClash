# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

StrideClash is a geolocation-based walking game (Portuguese-language codebase/README): players walk a route with the app open, GPS points form a closed polygon, and captured area counts toward an active championship's ranking. See [README.md](README.md) for the full game concept.

Three parts, in one repo, no shared build tooling between them:
- [backend/](backend/) — Go gRPC server (the "game engine": auth, rules, ranking)
- [mobile/](mobile/) — Flutter app (GPS tracking, map UI, gRPC client, social login)
- [proto/](proto/) — single source of truth for the gRPC API, consumed by both backend and mobile

## Commands

### Backend (Go)
Run from [backend/](backend/):
```
go run main.go          # starts gRPC server on :50051, loads backend/.env via godotenv
go build ./...
go vet ./...
```
There are currently no `_test.go` files in the backend.

### Mobile (Flutter)
Run from [mobile/](mobile/):
```
flutter pub get
flutter run
flutter analyze         # uses mobile/analysis_options.yaml (flutter_lints)
flutter test
```
No test files exist under `mobile/test` yet.

### Regenerating protobuf/gRPC code
Proto files in [proto/](proto/) are the source of truth. After editing a `.proto` file, regenerate both backend and mobile bindings with [AtualizarProto.ps1](AtualizarProto.ps1) (PowerShell, requires `protoc`, the Go plugins, and the Dart `protoc_plugin` on PATH):
```
./AtualizarProto.ps1
```
This regenerates `backend/proto/*.pb.go` / `*_grpc.pb.go` and `mobile/lib/generated/*.pb.dart` / `*.pbgrpc.dart` for `auth`, `walk`, and `championship`. Never hand-edit generated files in `backend/proto/` or `mobile/lib/generated/` — edit the `.proto` and regenerate instead.

### Database
Postgres with PostGIS runs via Docker Compose:
```
docker compose up -d postgres
```
Schema lives in [database/init/001_schema.sql](database/init/001_schema.sql) and is applied automatically on first container init (mounted to `/docker-entrypoint-initdb.d`). To reapply schema changes, the Postgres data volume (`postgres_data`) must be recreated — edits to the SQL file don't re-run against an existing volume.

### Environment
Both `backend/.env` and `mobile/.env` are required and gitignored-but-present locally. Backend needs `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_SSLMODE`, `GOOGLE_CLIENT_ID`. Mobile needs `GOOGLE_CLIENT_ID`, `GRPC_HOST`, `GRPC_PORT` (mobile's `.env` is bundled as a Flutter asset, see `pubspec.yaml`).

There's a separate root-level `.env` (see [.env.example](.env.example)) used only by Docker Compose — distinct from `backend/.env` (used for local `go run`). It's not the same file and isn't read by the Go binary directly.

### Deploying the backend
The backend is Dockerized ([backend/Dockerfile](backend/Dockerfile), multi-stage Go build) and wired into [docker-compose.yml](docker-compose.yml) alongside Postgres/PostGIS. The mobile app is **not** part of this deploy — it's a client that runs on a phone/emulator and just needs `GRPC_HOST`/`GRPC_PORT` pointed at wherever the backend ends up.

`deploy.ps1` (gitignored, environment-specific — same pattern as the sibling `CLKThingsManager` project) tars the repo (excluding `mobile/` and `.git`), scp's it to a remote host, and runs `docker compose up -d --build` there. It auto-detects `NGROK_AUTHTOKEN` in the root `.env` and, if present, layers in [docker-compose.ngrok.yml](docker-compose.ngrok.yml).

The ngrok overlay tunnels the backend with `ngrok http --app-protocol=http2` (not `ngrok tcp`) — since 2024 ngrok requires a verified payment card (no charge, just verification) for TCP/TLS endpoints even on the free plan, but HTTP endpoints don't need that. ngrok terminates TLS at its edge and forwards to the backend over cleartext HTTP/2 (h2c), which is what `grpc.NewServer()` already speaks with no `TransportCredentials`. The mobile client therefore needs `GRPC_USE_TLS=true` (see [mobile/lib/grpc_client.dart](mobile/lib/grpc_client.dart)) when pointed at the tunnel — `ChannelCredentials.secure()` vs `.insecure()` — even though the backend itself never runs TLS. `NGROK_URL` (optional, root `.env`) pins a free reserved static domain; without it the public address changes on every container restart.

## Architecture

### Backend: repository → service → gRPC
Standard three-layer split, one set of files per domain (`auth`, `championship`, `walk`):
- [backend/repository/](backend/repository/) — raw `database/sql` + `lib/pq` queries, one struct per table (`User`, `Walk`, `Championship`). No ORM.
- [backend/services/](backend/services/) — implements the generated `pb.*ServiceServer` interfaces, wraps repositories, returns/consumes protobuf types directly (uses `timestamppb` for time conversion).
- [backend/proto/](backend/proto/) — generated code from `proto/*.proto`.
- [backend/main.go](backend/main.go) wires everything by hand (no DI framework): loads `.env`, opens the DB connection, constructs repositories, registers each service on a single `grpc.Server` listening on `:50051`, with reflection enabled.

Auth flow: mobile does Google Sign-In and sends the ID token over gRPC (`AuthService.Login`); [backend/auth/google.go](backend/auth/google.go) verifies it server-side against `GOOGLE_CLIENT_ID` via `google.golang.org/api/idtoken`; on first login a `User` row is created keyed by `google_sub`. There is no backend-issued session token yet — the mobile client just persists the returned `user_id`/`email`/`name` locally (see below).

`WalkService.FinishWalk` ([backend/services/walk.go](backend/services/walk.go)) closes the walker's ring (auto-appending the start point if the trail didn't already return to it), persists every raw point to `walk_points`, and builds a `POLYGON((lng lat, ...))` WKT string that's stored via `ST_GeomFromText` and measured with `ST_Area(...::geography)` for a real square-meter figure — no anti-cheat/speed validation yet, that's still open. Requires ≥3 points or it returns `InvalidArgument`.

### Mobile: gRPC client + two independent local-storage layers
- [mobile/lib/grpc_client.dart](mobile/lib/grpc_client.dart) builds an insecure `ClientChannel` from `GRPC_HOST`/`GRPC_PORT` and exposes generated service clients (`AuthServiceClient`, `ChampionshipServiceClient`, `WalkServiceClient`).
- [mobile/lib/auth/auth_storage.dart](mobile/lib/auth/auth_storage.dart) persists the logged-in user (`userId`/`email`/`name`) in `flutter_secure_storage`; [mobile/lib/main.dart](mobile/lib/main.dart) checks this at startup to decide between `LoginPage` and `MainTabsPage`.
- [mobile/lib/services/walk_tracking_service.dart](mobile/lib/services/walk_tracking_service.dart) is the walk-tracking singleton actually wired to the backend: `startWalk()` calls `WalkService.StartWalk` (server is the source of truth for the walk id) before opening `Geolocator.getPositionStream`; `stopWalk()` sends the captured trail (lat/lng/speed/timestamp) to `WalkService.FinishWalk` and stores the returned `polygon_wkt`/`area_m2` back onto the local `walks.db` row. [mobile/lib/page/walk/walk_tracking_page.dart](mobile/lib/page/walk/walk_tracking_page.dart) draws the live trail as a `Polyline` while tracking, then swaps to a filled `PolygonLayer` (closed ring) with the captured area once `FinishWalk` returns.
- [mobile/lib/storage/walk_local_db.dart](mobile/lib/storage/walk_local_db.dart) is a **second, separate SQLite layer** (`strideclash.db`, its own `walks`/`walk_points` tables with a different column set incl. `status`/`championship_id`) that nothing currently wires up — it isn't used by `walk_tracking_service.dart` or any page. Don't assume the two share state; check which one a given piece of code actually touches.
- Generated protobuf/gRPC Dart code lives under [mobile/lib/generated/](mobile/lib/generated/) (mirrors `backend/proto/` but Dart-flavored); treat as build output.
- Pages are organized by feature under [mobile/lib/page/](mobile/lib/page/) (`auth/`, `championship/`, `profile/`, `tabs/`, `walk/`).

### Proto-first API design
All three `service`s (`AuthService`, `ChampionshipService`, `WalkService`) are defined in [proto/](proto/) and shared verbatim between backend and mobile via codegen — there is no REST layer currently implemented despite the README mentioning one as a future option. When adding/changing an RPC, edit the `.proto` first, regenerate via `AtualizarProto.ps1`, then implement the service method in `backend/services/` and call it from the relevant mobile page/service.
