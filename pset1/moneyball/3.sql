SELECT "year", "HR" FROM "performances"
JOIN "players" ON "performances"."player_id" = "players"."id"
WHERE  "first_name" = 'Ken' AND "last_name" LIKE 'Griffey%' AND "birth_year" = 1969
ORDER BY "year" DESC;
