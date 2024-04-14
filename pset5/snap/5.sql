SELECT "id" FROM "users" WHERE "id" IN (
    SELECT "user_id" FROM "friends" WHERE "friend_id" =(
        SELECT "id" FROM "users" WHERE "username" = 'lovelytrust487'
    )
)
INTERSECT
SELECT "id" FROM "users" WHERE "id" IN (
    SELECT "user_id" FROM "friends" WHERE "friend_id" =(
        SELECT "id" FROM "users" WHERE "username" = 'exceptionalinspiration482'
    )
);
