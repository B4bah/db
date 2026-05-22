-- ============================================================
--  AUTO REPAIR SHOP — PHYSICAL MODEL
--  Database: PostgreSQL
-- ============================================================


-- ============================================================
--  ENUMS
-- ============================================================

CREATE TYPE request_status AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'cancelled'
);

CREATE TYPE order_status AS ENUM (
    'pending',
    'confirmed',
    'shipped',
    'delivered',
    'cancelled'
);


-- ============================================================
--  НЕЗАВИСИМЫЕ ТАБЛИЦЫ
-- ============================================================

-- Личность (id = СНИЛС)
CREATE TABLE person (
    id          CHAR(11)     PRIMARY KEY,
    last_name   VARCHAR(100) NOT NULL,
    first_name  VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    birth_date  DATE,
    city        VARCHAR(100),
    district    VARCHAR(100),
    street      VARCHAR(255),
    building    VARCHAR(20),
    flat_number VARCHAR(10),
    CONSTRAINT chk_snils_format CHECK (id ~ '^\d{11}$')
);

-- Машиностроительная компания
CREATE TABLE machinery_company (
    id   INTEGER      PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Поставщик
CREATE TABLE supplier (
    id            INTEGER      PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(20),
    CONSTRAINT chk_phone_format CHECK (contact_phone ~ '^\+?[\d\s\(\)\-]{7,20}$')
);

-- Деталь
CREATE TABLE detail (
    id          INTEGER      PRIMARY KEY,
    part_number VARCHAR(100) NOT NULL UNIQUE,
    name        VARCHAR(255) NOT NULL,
    description TEXT
);

-- Автомастерская
CREATE TABLE auto_repair_shop (
    id   INTEGER      PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


-- ============================================================
--  ТАБЛИЦЫ ПЕРВОГО УРОВНЯ ЗАВИСИМОСТЕЙ
-- ============================================================

-- Модель автомобиля
CREATE TABLE vehicle_model (
    id         INTEGER      PRIMARY KEY,
    company_id INTEGER      NOT NULL REFERENCES machinery_company(id),
    name       VARCHAR(255) NOT NULL
);

-- Транспортное средство
CREATE TABLE vehicle (
    VIN           CHAR(17)    PRIMARY KEY,
    owner_id      CHAR(11)    NOT NULL REFERENCES person(id),
    model_id      INTEGER     NOT NULL REFERENCES vehicle_model(id),
    year          SMALLINT    NOT NULL CHECK (year >= 1886 AND year <= EXTRACT(YEAR FROM CURRENT_DATE)::SMALLINT),
    license_plate VARCHAR(20),
    CONSTRAINT chk_vin_format CHECK (VIN ~ '^[A-HJ-NPR-Z0-9]{17}$')
);

-- Совместимость детали с моделью
CREATE TABLE detail_compatibility (
    detail_id INTEGER NOT NULL REFERENCES detail(id),
    model_id  INTEGER NOT NULL REFERENCES vehicle_model(id),
    PRIMARY KEY (detail_id, model_id)
);

-- Поставщик детали
CREATE TABLE detail_supplier (
    detail_id   INTEGER        NOT NULL REFERENCES detail(id),
    supplier_id INTEGER        NOT NULL REFERENCES supplier(id),
    unit_price  NUMERIC(10, 2) NOT NULL CHECK (unit_price > 0),
    is_original BOOLEAN        NOT NULL DEFAULT FALSE,
    PRIMARY KEY (detail_id, supplier_id)
);

-- Филиал (создаём без manager_id из-за циклической зависимости с employee)
CREATE TABLE auto_repair_shop_branch (
    id            INTEGER      PRIMARY KEY,
    shop_id       INTEGER      NOT NULL REFERENCES auto_repair_shop(id),
    branch_number INTEGER      NOT NULL,
    city          VARCHAR(100) NOT NULL,
    district      VARCHAR(100),
    street        VARCHAR(255) NOT NULL,
    building      VARCHAR(20)  NOT NULL,
    CONSTRAINT chk_branch_number_positive CHECK (branch_number > 0),
    UNIQUE (shop_id, branch_number)
);


-- ============================================================
--  СОТРУДНИКИ
-- ============================================================

-- Сотрудник
CREATE TABLE employee (
    id                    INTEGER        PRIMARY KEY,
    person_id             CHAR(11)       NOT NULL REFERENCES person(id),
    branch_id             INTEGER        NOT NULL REFERENCES auto_repair_shop_branch(id),
    salary                NUMERIC(10, 2) NOT NULL CHECK (salary > 0),
    date_of_employment    DATE           NOT NULL,
    date_of_disemployment DATE,
    CHECK (date_of_disemployment IS NULL OR date_of_disemployment > date_of_employment)
);

-- Добавляем manager_id в филиал после создания employee
ALTER TABLE auto_repair_shop_branch
    ADD COLUMN manager_id INTEGER REFERENCES employee(id);

-- Механик (ISA от employee)
CREATE TABLE mechanic (
    id        INTEGER      PRIMARY KEY REFERENCES employee(id),
    specialty VARCHAR(255) NOT NULL,
    rank      SMALLINT     NOT NULL CHECK (rank BETWEEN 1 AND 8)
);


-- ============================================================
--  КЛИЕНТ И СКЛАД
-- ============================================================

-- Клиент
CREATE TABLE client (
    id                SERIAL   PRIMARY KEY,
    person_id         CHAR(11) NOT NULL REFERENCES person(id),
    registration_date DATE     NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT uq_client_person UNIQUE (person_id)
);

-- Склад (остаток детали на конкретном филиале)
CREATE TABLE inventory (
    id        SERIAL  PRIMARY KEY,
    branch_id INTEGER NOT NULL REFERENCES auto_repair_shop_branch(id),
    detail_id INTEGER NOT NULL REFERENCES detail(id),
    quantity  INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    UNIQUE (branch_id, detail_id)
);


-- ============================================================
--  ПРОЦЕСС РЕМОНТА
-- ============================================================

-- Заявка
CREATE TABLE request (
    id           SERIAL         PRIMARY KEY,
    client_id    INTEGER        NOT NULL REFERENCES client(id),
    branch_id    INTEGER        NOT NULL REFERENCES auto_repair_shop_branch(id),
    VIN          CHAR(17)       NOT NULL REFERENCES vehicle(VIN),
    description  TEXT,
    request_date DATE           NOT NULL DEFAULT CURRENT_DATE,
    status       request_status NOT NULL DEFAULT 'pending'
);

-- Наряд-заказ
CREATE TABLE work_order (
    id                 SERIAL  PRIMARY KEY,
    request_id         INTEGER NOT NULL REFERENCES request(id),
    date_of_assignment DATE    NOT NULL DEFAULT CURRENT_DATE,
    completion_date    DATE,
    CONSTRAINT chk_completion_date
        CHECK (completion_date IS NULL OR completion_date >= date_of_assignment)
);

-- Услуга
CREATE TABLE service (
    id            SERIAL         PRIMARY KEY,
    work_order_id INTEGER        NOT NULL REFERENCES work_order(id),
    name          VARCHAR(255)   NOT NULL,
    price         NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

-- Исполнение (механик → услуга)
CREATE TABLE execution (
    mechanic_id INTEGER NOT NULL REFERENCES mechanic(id),
    service_id  INTEGER NOT NULL REFERENCES service(id),
    date_start  DATE    NOT NULL,
    date_end    DATE,
    CHECK (date_end IS NULL OR date_end >= date_start),
    PRIMARY KEY (mechanic_id, service_id)
);

-- Использование детали в услуге
CREATE TABLE detail_usage (
    service_id   INTEGER NOT NULL REFERENCES service(id),
    inventory_id INTEGER NOT NULL REFERENCES inventory(id),
    quantity     INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (service_id, inventory_id)
);


-- ============================================================
--  ЗАКАЗ ДЕТАЛЕЙ
-- ============================================================

CREATE TABLE detail_order (
    id          SERIAL       PRIMARY KEY,
    branch_id   INTEGER      NOT NULL REFERENCES auto_repair_shop_branch(id),
    supplier_id INTEGER      NOT NULL REFERENCES supplier(id),
    detail_id   INTEGER      NOT NULL REFERENCES detail(id),
    quantity    INTEGER      NOT NULL CHECK (quantity > 0),
    order_date  DATE         NOT NULL DEFAULT CURRENT_DATE,
    status      order_status NOT NULL DEFAULT 'pending'
);


-- ============================================================
--  ТРИГГЕРЫ
-- ============================================================

-- ТРИГГЕР 1: Менеджер должен работать в своём филиале
CREATE OR REPLACE FUNCTION check_manager_branch()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.manager_id IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM employee
            WHERE id = NEW.manager_id
            AND branch_id = NEW.id
        ) THEN
            RAISE EXCEPTION
                'Менеджер (employee.id=%) не является сотрудником филиала (id=%)',
                NEW.manager_id, NEW.id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_manager_branch
BEFORE INSERT OR UPDATE OF manager_id
ON auto_repair_shop_branch
FOR EACH ROW EXECUTE FUNCTION check_manager_branch();


-- ТРИГГЕР 2: Остаток на складе не может уйти в минус
CREATE OR REPLACE FUNCTION check_inventory_quantity()
RETURNS TRIGGER AS $$
DECLARE
    available INTEGER;
BEGIN
    SELECT quantity INTO available
    FROM inventory
    WHERE id = NEW.inventory_id;

    IF available < NEW.quantity THEN
        RAISE EXCEPTION
            'Недостаточно деталей на складе: доступно %, запрошено %',
            available, NEW.quantity;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_inventory_quantity
BEFORE INSERT OR UPDATE OF quantity
ON detail_usage
FOR EACH ROW EXECUTE FUNCTION check_inventory_quantity();


-- ТРИГГЕР 3: Деталь в заказе должна быть у этого поставщика
CREATE OR REPLACE FUNCTION check_order_supplier()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM detail_supplier
        WHERE detail_id = NEW.detail_id
        AND supplier_id = NEW.supplier_id
    ) THEN
        RAISE EXCEPTION
            'Поставщик (id=%) не поставляет деталь (id=%)',
            NEW.supplier_id, NEW.detail_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_order_supplier
BEFORE INSERT OR UPDATE OF detail_id, supplier_id
ON detail_order
FOR EACH ROW EXECUTE FUNCTION check_order_supplier();


-- ТРИГГЕР 4: Механик не может выполнять две услуги одновременно
CREATE OR REPLACE FUNCTION check_mechanic_schedule()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM execution
        WHERE mechanic_id = NEW.mechanic_id
          AND NOT (mechanic_id = NEW.mechanic_id AND service_id = NEW.service_id)
          AND NEW.date_start <= COALESCE(date_end, 'infinity'::DATE)
          AND COALESCE(NEW.date_end, 'infinity'::DATE) >= date_start
    ) THEN
        RAISE EXCEPTION
            'Механик (id=%) уже занят в указанный период',
            NEW.mechanic_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_mechanic_schedule
BEFORE INSERT OR UPDATE OF date_start, date_end
ON execution
FOR EACH ROW EXECUTE FUNCTION check_mechanic_schedule();


-- ТРИГГЕР 5: Деталь должна быть совместима с моделью машины
CREATE OR REPLACE FUNCTION check_detail_compatibility()
RETURNS TRIGGER AS $$
DECLARE
    v_detail_id INTEGER;
    v_model_id  INTEGER;
BEGIN
    SELECT detail_id INTO v_detail_id
    FROM inventory
    WHERE id = NEW.inventory_id;

    SELECT v.model_id INTO v_model_id
    FROM service s
    JOIN work_order wo ON wo.id = s.work_order_id
    JOIN request r     ON r.id = wo.request_id
    JOIN vehicle v     ON v.VIN = r.VIN
    WHERE s.id = NEW.service_id;

    IF NOT EXISTS (
        SELECT 1 FROM detail_compatibility
        WHERE detail_id = v_detail_id
        AND model_id = v_model_id
    ) THEN
        RAISE EXCEPTION
            'Деталь (id=%) несовместима с моделью автомобиля (id=%)',
            v_detail_id, v_model_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_detail_compatibility
BEFORE INSERT OR UPDATE
ON detail_usage
FOR EACH ROW EXECUTE FUNCTION check_detail_compatibility();