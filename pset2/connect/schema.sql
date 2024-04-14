CREATE TABLE "users" (
    "id" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "schools" (
    "id" INTEGER NOT NULL,
    "type" TEXT NOT NULL
        CHECK ("type" IN ('Elementary School', 'Middle School', 'High School', 'Lower School', 'Upper School', 'College')),
    "location" TEXT NOT NULL,
    "year" INTEGER NOT NULL CHECK ("year" >= 0),
    PRIMARY KEY("id")
);

CREATE TABLE "companies"(
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "userConnections"(
    "user1_id" INTEGER,
    "user2_id" INTEGER,
    PRIMARY KEY ("user1_id", "user2_id"),
    FOREIGN KEY ("user1_id") REFERENCES "users"("id"),
    FOREIGN KEY ("user2_id") REFERENCES "users"("id")
);

CREATE TABLE "schoolConnections"(
    "user_id" INTEGER,
    "school_id" INTEGER,
    "date_start" NUMERIC NOT NULL,
    "date_end" NUMERIC NOT NULL,
    "type" TEXT NOT NULL
        CHECK ("type" IN ('BA', 'MA', 'PhD')),
    PRIMARY KEY ("user_id", "school_id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("school_id") REFERENCES "schools"("id")
);

CREATE TABLE "companyConnections" (
    "user_id" INTEGER,
    "company_id" INTEGER,
    "date_start" TEXT NOT NULL,
    "date_end" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    PRIMARY KEY ("user_id", "company_id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id")
);
