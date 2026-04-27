CREATE TABLE P (
	pn VARCHAR(50) PRIMARY KEY,
	pname VARCHAR(50),
	color VARCHAR(50),
	WEIGHT INTEGER,
	city VARCHAR(50)
);

CREATE TABLE S (
	sn VARCHAR(50) PRIMARY KEY,
	sname VARCHAR(50),
	status INTEGER,
	city VARCHAR(50)
);

CREATE TABLE J (
	jn VARCHAR(50) PRIMARY KEY,
	jname VARCHAR(50),
	city VARCHAR(50)
);

CREATE TABLE SPJ (
	sn VARCHAR(50) references S(sn),
	pn VARCHAR(50) references P(pn),
	jn VARCHAR(50) references J(jn),
	qty INTEGER,
	PRIMARY KEY (sn, pn, jn)
);