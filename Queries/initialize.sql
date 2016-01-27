CREATE TABLE IF NOT EXISTS "players" (
	`uuid`	TEXT PRIMARY KEY,
	`password` TEXT
);

CREATE TABLE IF NOT EXISTS "temptable" (
	`uuid` TEXT,
	`password` TEXT
);

INSERT INTO "temptable" SELECT DISTINCT(`uuid`), `password` FROM "players" GROUP BY `uuid`;

DROP TABLE "players";
CREATE TABLE IF NOT EXISTS "players" (
	`uuid`	TEXT PRIMARY KEY,
	`password` TEXT
);

INSERT INTO "players" SELECT * FROM "temptable";
DROP TABLE "temptable"

