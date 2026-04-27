INSERT INTO P (pn, pname, color, weight, city) VALUES
	('P1', 'Asd', 'green', NULL, 'London'), 
	('P2', 'Cbd', 'black', 32, 'Moscow'),
	('P3', 'Wer', 'red', 60, 'Paris'),
	('P4', 'Bsd', 'red', 11, 'London'),
	('P5', 'Sas', 'white', 13, 'Petersburg'),
	('P6', 'Das', 'green', 5, 'Paris'),
	('P7', 'Qqq', 'red', 55, 'London'),
	('P8', 'ksdjh', 'kasj', 45, 'dljk');
	
INSERT INTO S (sn, sname, status, city) VALUES
	('S1', 'Dean', 15, 'Boston'),
	('S2', 'David', 20, 'London'),
	('S3', 'Lena', 25, 'Paris'),
	('S4', 'Nina', 40, 'London'),
	('S5', 'Mim', 25, 'Petersburg'),
	('S6', 'Soba', 40, 'London'),
	('S7', 'Goga', 35, 'Moscow'),
	('S8', 'Mio', 10, 'Moscow');
	
INSERT INTO J (jn, jname, city) VALUES
	('J1', 'Vera', 'Petersburg'),
	('J2', 'Dima', 'Moscow'),
	('J3', 'Olga', 'London'),
	('J4', 'Sasha', 'Paris'),
	('J5', 'Masha', 'London'),
	('J6', 'Pasha', 'Moscow'),
	('J7', 'Barbara', 'Paris'),
	('J8', 'Nick', 'London'),
	('J9', 'Lisa', 'Petersburg');

INSERT INTO SPJ (sn, pn, jn, qty) VALUES
	('S1', 'P1', 'J1', 33),
	('S1', 'P1', 'J3', 26),
	('S1', 'P3', 'J3', 20),
	('S1', 'P4', 'J3', 23),
	('S1', 'P5', 'J2', 37),
	('S1', 'P7', 'J6', 57),
	('S2', 'P7', 'J2', 31),
	('S3', 'P2', 'J6', 20),
	('S3', 'P4', 'J5', 50),
	('S4', 'P3', 'J1', 27),
	('S4', 'P4', 'J8', 46),
	('S5', 'P1', 'J3', 15),
	('S6', 'P5', 'J3', 29),
	('S7', 'P7', 'J7', 35);