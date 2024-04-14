SELECT "salary","first_name", "last_name" FROM "players"
JOIN "salaries" ON "players"."id" = "salaries"."player_id"
WHERE "year" = 2001
ORDER BY "salary", "first_name", "last_name", "player_id" LIMIT  50;
