CREATE TABLE "meteorites" (
    "name" TEXT,
    "id" INTEGER,
    "class" TEXT,
    "mass" REAL,
    "discovery" TEXT CHECK ("discovery" IN ('Found', 'Fell')),
    "year" NUMERIC,
    "lat" REAL,
    "long" REAL,
    PRIMARY KEY("id")
);

.import --csv meteorites.csv temp

UPDATE "temp"
SET "mass" = NULL
WHERE "mass" LIKE '';

UPDATE "temp"
SET "mass" = ROUND("mass",2);

UPDATE "temp"
SET "year" = NULL
WHERE "year" LIKE '';

UPDATE "temp"
SET "lat" = NULL
WHERE "lat" LIKE '';

UPDATE "temp"
SET "lat" = ROUND("lat",2);

UPDATE "temp"
SET "long" = NULL
WHERE "long" LIKE '';

UPDATE "temp"
SET "long" = ROUND("long",2);

INSERT INTO "meteorites"
("name", "class", "mass", "discovery", "year", "lat", "long")
SELECT "name", "class", "mass", "discovery", "year", "lat", "long"
FROM "temp"
WHERE "nametype" != 'Relict'
ORDER BY "year", "name";
