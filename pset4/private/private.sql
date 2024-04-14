CREATE TABLE "keys" (
    id INTEGER,
    sentence_id INTEGER,
    start_key INTEGER,
    end_key INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("sentence_id") REFERENCES "sentences"("id")
);

INSERT INTO "keys" ("sentence_id", "start_key", "end_key")
VALUES
(14, 98, 4),
(114, 3, 5),
(618, 72, 9),
(630, 7, 3),
(932, 12, 5),
(2230, 50, 7),
(2346, 44, 10),
(3041, 14, 5);


CREATE VIEW "message" AS
SELECT substr("sentence", "keys"."start_key", "keys"."end_key") AS "phrase"
FROM "sentences"
JOIN "keys" ON "sentences"."id" = "keys"."sentence_id"
WHERE "sentences"."id" IN (
    SELECT "sentence_id" FROM "keys"
);

