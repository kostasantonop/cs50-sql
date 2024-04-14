SELECT "first_name", "last_name", "salary","salaries"."year","HR" FROM "performances"
JOIN "players" ON "players"."id" = "performances"."player_id"
JOIN "salaries" ON "salaries"."player_id" = "performances"."player_id"
WHERE "performances"."year" = "salaries"."year"
ORDER BY "players"."id", "performances"."year" DESC, "HR" DESC, "salary" DESC;
