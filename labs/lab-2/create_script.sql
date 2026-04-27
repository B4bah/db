CREATE TABLE product
(
	model VARCHAR(20) PRIMARY KEY,
	maker VARCHAR(20),
	type VARCHAR(20)
)

CREATE TABLE pc
(
	code VARCHAR(20) PRIMARY KEY,
	model VARCHAR(20) REFERENCES product(model),
	speed INTEGER,
	ram INTEGER,
	hd INTEGER,
	cd VARCHAR(10),
	price INTEGER
)

CREATE TABLE laptop
(
	code VARCHAR(20) PRIMARY KEY,
	model VARCHAR(20) REFERENCES product(model),
	speed INTEGER,
	ram INTEGER,
	hd INTEGER,
	screen INTEGER,
	price INTEGER
)

CREATE TABLE printer
(
	code VARCHAR(20) PRIMARY KEY,
	model VARCHAR(20) REFERENCES product(model),
	color CHAR(1),
	type VARCHAR(10),
	price INTEGER
)