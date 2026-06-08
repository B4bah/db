-- =========================================================
-- AUTO REPAIR SHOP DATABASE (FINAL CLEAN VERSION)
-- =========================================================

DROP SCHEMA IF EXISTS car_service CASCADE;
CREATE SCHEMA car_service;
SET search_path TO car_service;

-- =========================================================
-- 1. PERSON
-- =========================================================

CREATE TABLE person (
    id              VARCHAR(11) PRIMARY KEY,
    last_name       TEXT NOT NULL,
    first_name      TEXT NOT NULL,
    middle_name     TEXT,
    birth_date      DATE NOT NULL,
    city            TEXT NOT NULL,
    street          TEXT NOT NULL,
    building        TEXT NOT NULL,
    apartment       TEXT,

    CONSTRAINT chk_birth_date CHECK (birth_date < CURRENT_DATE)
);

-- =========================================================
-- 2. CLIENT
-- =========================================================

CREATE TABLE client (
    person_id VARCHAR(11) PRIMARY KEY,
    FOREIGN KEY (person_id)
        REFERENCES person(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================================
-- 3. COMPANY + MODEL
-- =========================================================

CREATE TABLE machinery_company (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE vehicle_model (
    id          SERIAL PRIMARY KEY,
    company_id  INT NOT NULL,
    name        TEXT NOT NULL,

    FOREIGN KEY (company_id)
        REFERENCES machinery_company(id)
        ON DELETE CASCADE
);

-- =========================================================
-- 4. VEHICLE
-- =========================================================

CREATE TABLE vehicle (
    VIN            VARCHAR(20) PRIMARY KEY,
    person_id      VARCHAR(11) NOT NULL,
    model_id       INT NOT NULL,
    year           INT NOT NULL,
    license_plate  TEXT NOT NULL UNIQUE,

    FOREIGN KEY (person_id)
        REFERENCES person(id)
        ON DELETE CASCADE,

    FOREIGN KEY (model_id)
        REFERENCES vehicle_model(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_year CHECK (
        year BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE)
    )
);

-- =========================================================
-- 5. SUPPLIER + DETAIL
-- =========================================================

CREATE TABLE supplier (
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    phone TEXT
);

CREATE TABLE detail (
    id          SERIAL PRIMARY KEY,
    article     TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    description TEXT
);

-- compatibility (M:N)
CREATE TABLE detail_compatibility (
    detail_id INT,
    model_id  INT,

    PRIMARY KEY (detail_id, model_id),

    FOREIGN KEY (detail_id)
        REFERENCES detail(id)
        ON DELETE CASCADE,

    FOREIGN KEY (model_id)
        REFERENCES vehicle_model(id)
        ON DELETE CASCADE
);

-- supplier catalog
CREATE TABLE detail_supplier (
    detail_id   INT,
    supplier_id INT,
    price       NUMERIC(10,2) NOT NULL,
    is_original BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (detail_id, supplier_id),

    FOREIGN KEY (detail_id)
        REFERENCES detail(id)
        ON DELETE CASCADE,

    FOREIGN KEY (supplier_id)
        REFERENCES supplier(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_price CHECK (price >= 0)
);

-- =========================================================
-- 6. REPAIR SHOP
-- =========================================================

CREATE TABLE auto_repair_shop (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE auto_repair_shop_branch (
    id              SERIAL PRIMARY KEY,
    shop_id         INT NOT NULL,
    branch_number   INT NOT NULL,
    city            TEXT NOT NULL,
    street          TEXT NOT NULL,
    building        TEXT NOT NULL,
    manager_id      INT,

    UNIQUE (shop_id, branch_number),

    FOREIGN KEY (shop_id)
        REFERENCES auto_repair_shop(id)
        ON DELETE CASCADE
);

-- =========================================================
-- 7. EMPLOYEE + MECHANIC
-- =========================================================

CREATE TABLE employee (
    id          SERIAL PRIMARY KEY,
    person_id   VARCHAR(11) NOT NULL,
    branch_id   INT NOT NULL,
    salary      NUMERIC(10,2) NOT NULL,
    hire_date   DATE NOT NULL,
    fire_date   DATE,

    FOREIGN KEY (person_id)
        REFERENCES person(id)
        ON DELETE CASCADE,

    FOREIGN KEY (branch_id)
        REFERENCES auto_repair_shop_branch(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_salary CHECK (salary > 0),
    CONSTRAINT chk_dates CHECK (fire_date IS NULL OR fire_date > hire_date)
);

-- now safe to add manager FK (no circular issue)
ALTER TABLE auto_repair_shop_branch
ADD CONSTRAINT fk_manager
FOREIGN KEY (manager_id)
REFERENCES employee(id)
ON DELETE SET NULL;

-- specialization
CREATE TABLE mechanic (
    id           INT PRIMARY KEY,
    specialization TEXT,
    experience     INT CHECK (experience >= 0),

    FOREIGN KEY (id)
        REFERENCES employee(id)
        ON DELETE CASCADE
);

-- =========================================================
-- 8. INVENTORY
-- =========================================================

CREATE TABLE inventory (
    id         SERIAL PRIMARY KEY,
    branch_id  INT NOT NULL,
    detail_id  INT NOT NULL,
    quantity   INT NOT NULL,

    UNIQUE (branch_id, detail_id),

    FOREIGN KEY (branch_id)
        REFERENCES auto_repair_shop_branch(id)
        ON DELETE CASCADE,

    FOREIGN KEY (detail_id)
        REFERENCES detail(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_quantity CHECK (quantity >= 0)
);

-- =========================================================
-- 9. REQUEST / WORKFLOW
-- =========================================================

CREATE TABLE request (
    id          SERIAL PRIMARY KEY,
    client_id   VARCHAR(11) NOT NULL,
    branch_id   INT NOT NULL,
    VIN         VARCHAR(20) NOT NULL,
    description TEXT,
    status      TEXT NOT NULL DEFAULT 'pending',
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id)
        REFERENCES client(person_id)
        ON DELETE CASCADE,

    FOREIGN KEY (branch_id)
        REFERENCES auto_repair_shop_branch(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (VIN)
        REFERENCES vehicle(VIN)
        ON DELETE CASCADE,

    CONSTRAINT chk_status CHECK (
        status IN ('pending', 'in_progress', 'completed')
    )
);

CREATE TABLE work_order (
    id               SERIAL PRIMARY KEY,
    request_id       INT UNIQUE NOT NULL,
    completion_date  DATE,

    FOREIGN KEY (request_id)
        REFERENCES request(id)
        ON DELETE CASCADE
);

CREATE TABLE service (
    id            SERIAL PRIMARY KEY,
    work_order_id INT NOT NULL,
    name          TEXT NOT NULL,
    price         NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (work_order_id)
        REFERENCES work_order(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_service_price CHECK (price >= 0)
);

CREATE TABLE execution (
    mechanic_id INT,
    service_id  INT,
    date_start  DATE NOT NULL,
    date_end    DATE,

    PRIMARY KEY (mechanic_id, service_id),

    FOREIGN KEY (mechanic_id)
        REFERENCES mechanic(id)
        ON DELETE CASCADE,

    FOREIGN KEY (service_id)
        REFERENCES service(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_exec_dates CHECK (date_end IS NULL OR date_end >= date_start)
);

CREATE TABLE detail_usage (
    service_id   INT,
    inventory_id INT,
    quantity     INT NOT NULL,

    PRIMARY KEY (service_id, inventory_id),

    FOREIGN KEY (service_id)
        REFERENCES service(id)
        ON DELETE CASCADE,

    FOREIGN KEY (inventory_id)
        REFERENCES inventory(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_usage_qty CHECK (quantity > 0)
);

-- =========================================================
-- END
-- =========================================================