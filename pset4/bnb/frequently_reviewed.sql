CREATE VIEW "frequently_reviewed" AS
SELECT "listings"."id", "property_type", "host_name", COUNT("reviews"."id") as "number_of_reviews"
FROM "listings"
JOIN "reviews" ON "listings"."id" = "reviews"."listing_id"
GROUP BY "listings"."id"
ORDER BY "number_of_reviews" DESC, "property_type", "host_name" LIMIT 100;
