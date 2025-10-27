CREATE TABLE sets
(
    set_num VARCHAR(130) NOT NULL PRIMARY KEY,
    number INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    year INTEGER,
    theme VARCHAR(100),
    num_parts INTEGER
);
