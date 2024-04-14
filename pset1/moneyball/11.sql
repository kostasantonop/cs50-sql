SELECT "first_name", "last_name", "salary" / "H" AS "dollars per hit" FROM "players"
JOIN "salaries" ON "players"."id" = "salaries"."player_id"
JOIN "performances" ON "players"."id" = "performances"."player_id"
WHERE "salaries"."year" = 2001 AND "performances"."year" = "salaries"."year" AND "H" !=0
ORDER BY "dollars per hit","first_name", "last_name" LIMIT 10;
