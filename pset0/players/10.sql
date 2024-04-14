SELECT "first_name" AS "Name", "last_name" AS "surname" FROM "players"
WHERE "height" > (SELECT AVG("height") FROM "players")
ORDER BY "height", "first_name", "last_name";
