SELECT "city" , COUNT("id") AS "Number of public schools" FROM "schools" WHERE "type" = 'Public School'
GROUP BY "city"
ORDER BY "Number of public schools" DESC, "city" LIMIT 10;
