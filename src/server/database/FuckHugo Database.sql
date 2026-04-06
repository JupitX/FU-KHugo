CREATE SCHEMA "devices";

CREATE SCHEMA "dashboard";

CREATE SCHEMA "country";

CREATE SCHEMA "content";

CREATE TABLE "devices"."devices" (
  "computerID" SERIAL UNIQUE PRIMARY KEY NOT NULL,
  "hostname" varchar,
  "ip" varchar NOT NULL
);

CREATE TABLE "devices"."users" (
  "userID" uuid UNIQUE PRIMARY KEY NOT NULL,
  "username" varchar NOT NULL,
  "computerID" integer NOT NULL,
  "country" varchar
);

CREATE TABLE "dashboard"."users" (
  "userID" uuid UNIQUE PRIMARY KEY NOT NULL,
  "username" varchar NOT NULL,
  "password" text NOT NULL,
  "role" varchar,
  "created_at" timestamp
);

CREATE TABLE "dashboard"."sessions" (
  "id" uuid UNIQUE PRIMARY KEY NOT NULL,
  "userID" uuid NOT NULL,
  "tokenHash" text NOT NULL,
  "expires_at" timestamp NOT NULL,
  "created_at" timestamp NOT NULL
);

CREATE TABLE "country"."codes" (
  "code" varchar UNIQUE PRIMARY KEY NOT NULL,
  "country" varchar,
  "location" varchar
);

CREATE TABLE "content"."media" (
  "id" uuid UNIQUE PRIMARY KEY NOT NULL,
  "type" varchar NOT NULL,
  "mimeType" varchar NOT NULL,
  "filename" text NOT NULL,
  "filepath" text NOT NULL,
  "filesize" bigint NOT NULL,
  "width" int,
  "height" int,
  "duration" float,
  "checksum" char(64),
  "created_at" timestamp
);

ALTER TABLE "devices"."users" ADD CONSTRAINT "userDevices" FOREIGN KEY ("computerID") REFERENCES "devices"."devices" ("computerID");

ALTER TABLE "devices"."users" ADD CONSTRAINT "userCountries" FOREIGN KEY ("country") REFERENCES "country"."codes" ("country");

ALTER TABLE "dashboard"."sessions" ADD CONSTRAINT "userSessions" FOREIGN KEY ("userID") REFERENCES "dashboard"."users" ("userID");
