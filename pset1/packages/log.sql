
-- *** The Lost Letter ***
SELECT "type", "address" FROM "addresses" WHERE "id" = (
    SELECT "address_id" FROM "scans" WHERE "action" = 'Drop' AND "package_id" = (
        SELECT "id" FROM "packages" WHERE "contents" = 'Congratulatory letter' AND "from_address_id" = (
            SELECT "id" FROM "addresses" WHERE "address" = '900 Somerville Avenue'
        )
    )
);


-- *** The Devious Delivery ***
SELECT "id", "contents" FROM "packages" WHERE "from_address_id" IS NULL;

SELECT "type" FROM "addresses" WHERE "id" = (
    SELECT "address_id" FROM "scans" WHERE "action" = 'Drop' AND "package_id" = (
        SELECT "id" FROM "packages" WHERE "from_address_id" IS NULL
    )
);


-- *** The Forgotten Gift ***
SELECT "contents" FROM "packages" WHERE "from_address_id" = (
    SELECT "id" FROM "addresses" WHERE "address" = '109 Tileston Street'
);


SELECT * FROM "scans"
JOIN "addresses" ON "scans"."address_id" = "addresses"."id"
WHERE "package_id" IN (
    SELECT "id" FROM "packages" WHERE "contents" = 'Flowers' AND "from_address_id" =(
        SELECT "id" FROM "addresses" WHERE "address" = '109 Tileston Street'
    )
) ORDER BY "timestamp"  DESC LIMIT 1;

SELECT "name" FROM "drivers" WHERE "id" = 17;
