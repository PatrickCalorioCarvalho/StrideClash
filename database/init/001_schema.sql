CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- USERS
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    google_sub TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    picture TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- CHAMPIONSHIPS
CREATE TABLE IF NOT EXISTS championships (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    start_at TIMESTAMP NOT NULL,
    end_at TIMESTAMP NOT NULL,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    join_code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- CHAMPIONSHIP MEMBERS (who created/joined which championship — the
-- "friends group" a championship's ranking and walks are scoped to)
CREATE TABLE IF NOT EXISTS championship_members (
    championship_id UUID NOT NULL REFERENCES championships(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (championship_id, user_id)
);

-- WALKS
CREATE TABLE IF NOT EXISTS walks (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    championship_id UUID REFERENCES championships(id) ON DELETE SET NULL,
    started_at TIMESTAMP NOT NULL,
    finished_at TIMESTAMP,
    -- Untyped geometry, not GEOMETRY(Polygon, 4326): repairing a
    -- self-intersecting walk (ST_MakeValid) or splitting one via
    -- ST_Difference can legitimately produce a MultiPolygon.
    polygon GEOMETRY(Geometry, 4326),
    area_m2 DOUBLE PRECISION
);

-- WALK POINTS
CREATE TABLE IF NOT EXISTS walk_points (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    walk_id UUID NOT NULL REFERENCES walks(id) ON DELETE CASCADE,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    speed DOUBLE PRECISION,
    recorded_at TIMESTAMP DEFAULT NOW()
);

-- INDEXES (importante para mapa)
CREATE INDEX IF NOT EXISTS idx_walk_points_walk_id
ON walk_points(walk_id);

CREATE INDEX IF NOT EXISTS idx_walk_points_time
ON walk_points(recorded_at);

CREATE INDEX IF NOT EXISTS idx_walks_user
ON walks(user_id);

CREATE INDEX IF NOT EXISTS idx_walks_polygon
ON walks USING GIST(polygon);