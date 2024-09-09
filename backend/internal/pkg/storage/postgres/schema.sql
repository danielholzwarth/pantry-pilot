BEGIN;

/*
-- Drop all tables
DROP TABLE IF EXISTS exercise_type, language, position, user_account, user_list, report, gym, user_account_gym, friendship, user_settings, plan, split, exercise, exercise_split, workout, set, best_lifts CASCADE;

or

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