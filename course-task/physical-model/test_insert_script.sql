-- Set the primary schema as car_service
SET search_path TO car_service;

-- PERSONS
INSERT INTO person VALUES
('1001','Ivanov','Ivan','Ivanovich','1990-05-10','Moscow','Lenina','10','5'),
('1002','Petrov','Petr',NULL,'1985-03-22','Moscow','Tverskaya','15','12'),
('1003','Sidorov','Alex',NULL,'1995-07-11','Kazan','Central','7','2'),
('1004','Smirnov','Dmitry',NULL,'1988-02-01','SPB','Nevsky','21','3'),
('1005','Volkov','Sergey',NULL,'1992-09-09','SPB','Liteiny','8','1');

-- CLIENTS
INSERT INTO client VALUES ('1001'), ('1002'), ('1004');

-- COMPANY + MODELS
INSERT INTO machinery_company (name) VALUES ('Toyota'), ('BMW');

INSERT INTO vehicle_model (company_id, name) VALUES
(1, 'Camry'),
(2, 'X5');

-- VEHICLES (6 cars)
INSERT INTO vehicle VALUES
('VIN1','1001',1,2015,'A111AA'),
('VIN2','1002',2,2018,'B222BB'),
('VIN3','1001',1,2017,'C333CC'),
('VIN4','1004',2,2016,'D444DD'),
('VIN5','1001',1,2019,'E555EE'),
('VIN6','1002',2,2020,'F666FF');

-- SUPPLIERS
INSERT INTO supplier (name) VALUES ('AutoParts'), ('MegaParts');

-- DETAILS
INSERT INTO detail (article, name) VALUES
('ENG-1','Engine'),
('BRK-1','Brake Pads');

-- COMPATIBILITY
INSERT INTO detail_compatibility VALUES
(1,1), -- engine → Camry
(2,1),
(2,2);

-- SUPPLIER LINKS
INSERT INTO detail_supplier VALUES
(1,1,50000,TRUE),
(2,1,3000,FALSE);

-- SHOP + BRANCH
INSERT INTO auto_repair_shop (name) VALUES ('FixIt');

INSERT INTO auto_repair_shop_branch (shop_id, branch_number, city, street, building)
VALUES (1,1,'Moscow','Lenina','1');

-- EMPLOYEE + MECHANIC
INSERT INTO employee (person_id, branch_id, salary, hire_date)
VALUES ('1003',1,60000,'2020-01-01');

INSERT INTO mechanic VALUES (1,'Engine repair',5);

-- SET MANAGER (valid)
UPDATE auto_repair_shop_branch
SET manager_id = 1
WHERE id = 1;

-- INVENTORY
INSERT INTO inventory (branch_id, detail_id, quantity) VALUES
(1,1,3),  -- engines
(1,2,10); -- brakes