-- ============================================================
--  AUTO REPAIR SHOP — PHYSICAL MODEL
--  Database: PostgreSQL
-- ============================================================
DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA public;

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

CREATE TYPE invoice_status AS ENUM (
    'issued',
    'paid',
    'overdue',
    'cancelled'
);

CREATE TYPE payment_method AS ENUM (
    'cash',
    'card',
    'bank_transfer'
);


-- ============================================================
--  НЕЗАВИСИМЫЕ ТАБЛИЦЫ
-- ============================================================

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

CREATE TABLE machinery_company (
    id   INTEGER      PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE supplier (
    id            INTEGER      PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(20),
    CONSTRAINT chk_phone_format CHECK (contact_phone ~ '^\+?[\d\s\(\)\-]{7,20}$')
);

CREATE TABLE detail (
    id          INTEGER      PRIMARY KEY,
    part_number VARCHAR(100) NOT NULL UNIQUE,
    name        VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE auto_repair_shop (
    id   INTEGER      PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


-- ============================================================
--  ПЕРВЫЙ УРОВЕНЬ ЗАВИСИМОСТЕЙ
-- ============================================================

CREATE TABLE vehicle_model (
    id         INTEGER      PRIMARY KEY,
    company_id INTEGER      NOT NULL REFERENCES machinery_company(id),
    name       VARCHAR(255) NOT NULL
);

CREATE TABLE vehicle (
    VIN           CHAR(17)    PRIMARY KEY,
    owner_id      CHAR(11)    NOT NULL REFERENCES person(id),
    model_id      INTEGER     NOT NULL REFERENCES vehicle_model(id),
    year          SMALLINT    NOT NULL CHECK (year >= 1886 AND year <= EXTRACT(YEAR FROM CURRENT_DATE)::SMALLINT),
    license_plate VARCHAR(20),
    CONSTRAINT chk_vin_format CHECK (VIN ~ '^[A-HJ-NPR-Z0-9]{17}$')
);

CREATE TABLE detail_compatibility (
    detail_id INTEGER NOT NULL REFERENCES detail(id),
    model_id  INTEGER NOT NULL REFERENCES vehicle_model(id),
    PRIMARY KEY (detail_id, model_id)
);

CREATE TABLE detail_supplier (
    detail_id   INTEGER        NOT NULL REFERENCES detail(id),
    supplier_id INTEGER        NOT NULL REFERENCES supplier(id),
    unit_price  NUMERIC(10, 2) NOT NULL CHECK (unit_price > 0),
    is_original BOOLEAN        NOT NULL DEFAULT FALSE,
    PRIMARY KEY (detail_id, supplier_id)
);

-- Филиал без manager_id — добавим после employee (цикл. зависимость)
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

CREATE TABLE employee (
    id                    INTEGER        PRIMARY KEY,
    person_id             CHAR(11)       NOT NULL REFERENCES person(id),
    branch_id             INTEGER        NOT NULL REFERENCES auto_repair_shop_branch(id),
    salary                NUMERIC(10, 2) NOT NULL CHECK (salary > 0),
    date_of_employment    DATE           NOT NULL,
    date_of_disemployment DATE,
    CHECK (date_of_disemployment IS NULL OR date_of_disemployment > date_of_employment)
);

ALTER TABLE auto_repair_shop_branch
    ADD COLUMN manager_id INTEGER REFERENCES employee(id);

CREATE TABLE mechanic (
    id        INTEGER      PRIMARY KEY REFERENCES employee(id),
    specialty VARCHAR(255) NOT NULL,
    rank      SMALLINT     NOT NULL CHECK (rank BETWEEN 1 AND 8)
);


-- ============================================================
--  КЛИЕНТ И СКЛАД
-- ============================================================

CREATE TABLE client (
    id                SERIAL   PRIMARY KEY,
    person_id         CHAR(11) NOT NULL REFERENCES person(id),
    registration_date DATE     NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT uq_client_person UNIQUE (person_id)
);

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

CREATE TABLE request (
    id           SERIAL         PRIMARY KEY,
    client_id    INTEGER        NOT NULL REFERENCES client(id),
    branch_id    INTEGER        NOT NULL REFERENCES auto_repair_shop_branch(id),
    VIN          CHAR(17)       NOT NULL REFERENCES vehicle(VIN),
    description  TEXT,
    request_date DATE           NOT NULL DEFAULT CURRENT_DATE,
    status       request_status NOT NULL DEFAULT 'pending'
);

CREATE TABLE work_order (
    id                 SERIAL  PRIMARY KEY,
    request_id         INTEGER NOT NULL REFERENCES request(id),
    date_of_assignment DATE    NOT NULL DEFAULT CURRENT_DATE,
    completion_date    DATE,
    CONSTRAINT chk_completion_date
        CHECK (completion_date IS NULL OR completion_date >= date_of_assignment)
);

CREATE TABLE service (
    id            SERIAL         PRIMARY KEY,
    work_order_id INTEGER        NOT NULL REFERENCES work_order(id),
    name          VARCHAR(255)   NOT NULL,
    price         NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE execution (
    mechanic_id INTEGER NOT NULL REFERENCES mechanic(id),
    service_id  INTEGER NOT NULL REFERENCES service(id),
    date_start  DATE    NOT NULL,
    date_end    DATE,
    CHECK (date_end IS NULL OR date_end >= date_start),
    PRIMARY KEY (mechanic_id, service_id)
);

CREATE TABLE detail_usage (
    service_id   INTEGER NOT NULL REFERENCES service(id),
    inventory_id INTEGER NOT NULL REFERENCES inventory(id),
    quantity     INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (service_id, inventory_id)
);


-- ============================================================
--  ФИНАНСЫ
-- ============================================================

-- Счёт клиенту (один на заявку, total_amount считается триггером)
CREATE TABLE invoice (
    id           SERIAL         PRIMARY KEY,
    request_id   INTEGER        NOT NULL UNIQUE REFERENCES request(id),
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    issued_date  DATE           NOT NULL DEFAULT CURRENT_DATE,
    due_date     DATE           NOT NULL,
    status       invoice_status NOT NULL DEFAULT 'issued',
    CONSTRAINT chk_due_date CHECK (due_date >= issued_date)
);

-- Платёж по счёту (может быть несколько — клиент платит частями)
CREATE TABLE payment (
    id             SERIAL         PRIMARY KEY,
    invoice_id     INTEGER        NOT NULL REFERENCES invoice(id),
    amount         NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    payment_date   DATE           NOT NULL DEFAULT CURRENT_DATE,
    payment_method payment_method NOT NULL
);

-- Бюджет филиала
CREATE TABLE branch_budget (
    branch_id INTEGER        PRIMARY KEY REFERENCES auto_repair_shop_branch(id),
    balance   NUMERIC(10, 2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0)
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
        WHERE detail_id  = NEW.detail_id
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
    FROM inventory WHERE id = NEW.inventory_id;

    SELECT v.model_id INTO v_model_id
    FROM service s
    JOIN work_order wo ON wo.id = s.work_order_id
    JOIN request r     ON r.id  = wo.request_id
    JOIN vehicle v     ON v.VIN = r.VIN
    WHERE s.id = NEW.service_id;

    IF NOT EXISTS (
        SELECT 1 FROM detail_compatibility
        WHERE detail_id = v_detail_id
          AND model_id  = v_model_id
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


-- ТРИГГЕР 6: Авто-расчёт total_amount при создании инвойса
CREATE OR REPLACE FUNCTION calculate_invoice_total()
RETURNS TRIGGER AS $$
BEGIN
    SELECT COALESCE(SUM(s.price), 0) INTO NEW.total_amount
    FROM work_order wo
    JOIN service s ON s.work_order_id = wo.id
    WHERE wo.request_id = NEW.request_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_invoice_total
BEFORE INSERT ON invoice
FOR EACH ROW EXECUTE FUNCTION calculate_invoice_total();


-- ТРИГГЕР 7: При оплате — пополняем бюджет филиала и обновляем статус инвойса
CREATE OR REPLACE FUNCTION process_payment()
RETURNS TRIGGER AS $$
DECLARE
    v_branch_id INTEGER;
    v_total     NUMERIC(10, 2);
    v_paid      NUMERIC(10, 2);
BEGIN
    -- находим филиал через payment → invoice → request
    SELECT r.branch_id INTO v_branch_id
    FROM invoice i
    JOIN request r ON r.id = i.request_id
    WHERE i.id = NEW.invoice_id;

    -- пополняем бюджет (upsert)
    INSERT INTO branch_budget (branch_id, balance)
    VALUES (v_branch_id, NEW.amount)
    ON CONFLICT (branch_id)
    DO UPDATE SET balance = branch_budget.balance + NEW.amount;

    -- если сумма всех платежей >= total_amount → помечаем как paid
    SELECT i.total_amount,
           COALESCE(SUM(p.amount), 0) + NEW.amount
    INTO v_total, v_paid
    FROM invoice i
    LEFT JOIN payment p ON p.invoice_id = i.id
    WHERE i.id = NEW.invoice_id
    GROUP BY i.total_amount;

    IF v_paid >= v_total THEN
        UPDATE invoice SET status = 'paid' WHERE id = NEW.invoice_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_process_payment
AFTER INSERT ON payment
FOR EACH ROW EXECUTE FUNCTION process_payment();


-- ТРИГГЕР 8: Проверка бюджета при подтверждении заказа деталей
CREATE OR REPLACE FUNCTION check_budget_on_order()
RETURNS TRIGGER AS $$
DECLARE
    v_order_cost NUMERIC(10, 2);
    v_balance    NUMERIC(10, 2);
BEGIN
    -- срабатывает только при переходе статуса в 'confirmed'
    IF NEW.status = 'confirmed' AND (OLD.status IS NULL OR OLD.status <> 'confirmed') THEN

        SELECT NEW.quantity * ds.unit_price INTO v_order_cost
        FROM detail_supplier ds
        WHERE ds.detail_id   = NEW.detail_id
          AND ds.supplier_id = NEW.supplier_id;

        SELECT COALESCE(balance, 0) INTO v_balance
        FROM branch_budget
        WHERE branch_id = NEW.branch_id;

        IF v_balance < v_order_cost THEN
            RAISE EXCEPTION
                'Недостаточно средств: баланс филиала %, стоимость заказа %',
                v_balance, v_order_cost;
        END IF;

        -- списываем стоимость с бюджета
        UPDATE branch_budget
        SET balance = balance - v_order_cost
        WHERE branch_id = NEW.branch_id;

    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_budget_on_order
BEFORE UPDATE OF status ON detail_order
FOR EACH ROW EXECUTE FUNCTION check_budget_on_order();