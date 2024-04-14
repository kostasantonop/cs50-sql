CREATE TABLE "ingredients"(
    "id" INTEGER,
    "name" TEXT NOT NULL
        CHECK ("name" in ('flour', 'yeast', 'oil', 'butter', 'sugar')),
    "price_per_unit" NUMERIC NOT NULL,
    "unit" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "donuts"(
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "gluten_free" INTEGER
        CHECK("gluten_free" IN (0, 1)) DEFAULT 0,
    "price" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "orders"(
    "order_number" INTEGER,
    "customer_id" INTEGER,
    PRIMARY KEY("order_number"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);

CREATE TABLE "customers"(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "donutIngredients" (
    "ingredient_id" INTEGER,
    "donut_id" INTEGER,
    PRIMARY KEY("ingredient_id", "donut_id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id"),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id")
);

CREATE TABLE "donutOrders"(
    "order_id" INTEGER,
    "donut_id" INTEGER,
    PRIMARY KEY("order_id", "donut_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("order_number"),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id")
);

CREATE TABLE "customerOrders" (
    "order_id" INTEGER,
    "customer_id" INTEGER,
    PRIMARY KEY("order_id", "customer_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("order_number"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);
