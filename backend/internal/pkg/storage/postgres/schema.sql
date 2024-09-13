BEGIN;

/*
-- Drop all tables
DROP SCHEMA IF EXISTS public CASCADE;
*/

CREATE SCHEMA IF NOT EXISTS public;

CREATE TABLE blacklist (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    token VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE user_account (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    email VARCHAR(20) NOT NULL,
    password VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE storage (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    user_account_id BIGINT NOT NULL REFERENCES user_account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE item (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    storage_id BIGINT NOT NULL REFERENCES storage(id) ON DELETE CASCADE ON UPDATE CASCADE,
    name VARCHAR(50) NOT NULL,
    quantity DECIMAL NOT NULL,
    target_quantity DECIMAL,
    details VARCHAR,
    barCode VARCHAR
);

CREATE TABLE transaction (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    storage_id BIGINT NOT NULL REFERENCES storage(id) ON DELETE CASCADE ON UPDATE CASCADE,
    item_id BIGINT NOT NULL REFERENCES item(id),
    quantity DECIMAL NOT NULL,
    created_at TIMESTAMP NOT NULL
);

COMMIT;

--INSERTS
BEGIN;
Insert INTO "user_account" ("email", "password", "created_at") VALUES ('test', '$2a$10$LVE2S482Uwn.X8UEKmm3YemSYPwyWFqvp6aSDQRoHFPXoF/y/kgUe', now());
Insert INTO "user_account" ("email", "password", "created_at") VALUES ('daniel', '$2a$10$LVE2S482Uwn.X8UEKmm3YemSYPwyWFqvp6aSDQRoHFPXoF/y/kgUe', now());
Insert INTO "user_account" ("email", "password", "created_at") VALUES ('laura', '$2a$10$LVE2S482Uwn.X8UEKmm3YemSYPwyWFqvp6aSDQRoHFPXoF/y/kgUe', now());

Insert INTO "storage" ("name", "user_account_id", "created_at", "updated_at") VALUES ('Lager Links', 2, now(), now());
Insert INTO "storage" ("name", "user_account_id", "created_at", "updated_at") VALUES ('Lager Rechts', 2, now(), now());
Insert INTO "storage" ("name", "user_account_id", "created_at", "updated_at") VALUES ('Jupa', 2, now(), now());
Insert INTO "storage" ("name", "user_account_id", "created_at", "updated_at") VALUES ('Rathaus', 2, now(), now());

Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Korken', 32, 100, 'Kiste 1, Regalplatz 7D, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Rattan', 34, 30, 'Kiste 1, Regalplatz 7D, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Kronkorken', 12, 100, 'Kiste 2, Regalplatz 8A, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Acrylfarbe gelb ', 3, 3, 'Kiste 2, Regalplatz 8A, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Acrylfarbe grün', 4, 3, 'Kiste 2, Regalplatz 8A, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Schraubklemme', 23, 20, 'Kiste 11, Regalplatz 14B, Schreinerei', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Imbus - verschiedene ', 32, 8, 'Kiste 11, Regalplatz 14B, Schreinerei', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Schraubschlüssel', 4, 8, 'Kiste 11, Regalplatz 14B, Schreinerei', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Akkuborhrer', 56, 8, 'Kiste 12, Regalplatz 14C', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Schraubstock', 3, 8, 'Kiste 12, Regalplatz 14C', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (1, 'Akkuschrauber', 12, 5, 'Kiste 13, Regalplatz 13A', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (2, 'Nagelpistole', 8, 5, 'Kiste 1, Regalplatz 14B, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (2, 'Holztacker', 7, 5, 'Kiste 1, Regalplatz 14B, Basteln', '');
Insert INTO "item" ("storage_id", "name", "quantity", "target_quantity", "details", "barcode") VALUES (2, 'Holz- und Metallbohrer', 6, 10, 'Kiste 1, Regalplatz 14B, Basteln', '');

COMMIT;
