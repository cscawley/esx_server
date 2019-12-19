CREATE TABLE IF NOT EXISTS armory
(
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    weapon     TEXT          NOT NULL,
    count      INT DEFAULT 0 NOT NULL,
    armory_job TEXT          NOT NULL,
    CONSTRAINT id
        UNIQUE (id)
);
