
CREATE TABLE Person(
	id INTEGER PRIMARY KEY,
	name VARCHAR(20),
	last_name VARCHAR(20),
	middle_name VARCHAR(20),
	country VARCHAR(20),
	city VARCHAR(20),
	street VARCHAR(20),
	house VARCHAR(20),
	apartment VARCHAR(10)
)

CREATE TABLE Employee (
	id INTEGER PRIMARY KEY,
	person_id INTEGER references Person(id),
	salary MONEY,
	date_of_employment DATE,
	date_of_disemployment DATE
)

CREATE TABLE Manager (
	id INTEGER PRIMARY KEY references Employee(id),
	date_of_appointment DATE
)

CREATE TABLE Mechanic (
	id INTEGER PRIMARY KEY references Employee(id),
	specialty VARCHAR(20),
	rank INTEGER
)

CREATE TABLE Auto_repair_shop (
	
)