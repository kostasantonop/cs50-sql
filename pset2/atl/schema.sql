CREATE TABLE "passengers" (
    "id" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "checkins" (
    "passenger_id" INTEGER
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "flight_number" INTEGER NOT NULL,
    FOREIGN KEY ("passenger_id")
        REFERENCES "passengers"("id"),
    FOREIGN KEY ("flight_number")
        REFERENCES  "flights"("number")
);

CREATE TABLE "airlines" (
    "name" TEXT NOT NULL,
    "concourse" TEXT NOT NULL
        CHECK ("concourse" IN ('A', 'B', 'C', 'D', 'E', 'F', 'T'))
);

CREATE TABLE "flights" (
    "number" INTEGER NOT NULL,
    "airline_name" TEXT NOT NULL,
    "departure_airport" TEXT NOT NULL,
    "arrival_airport" TEXT NOT NULL,
    "expected_departure_time" NUMERIC NOT NULL,
    "expected_arrival_time" NUMERIC NOT NULL,
    FOREIGN KEY ("airline_name") REFERENCES
        "airlines"("name")
);
