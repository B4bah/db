SET search_path TO car_service;

-- =========================================================
-- COMBINED PIPELINE FUNCTION
-- =========================================================

CREATE OR REPLACE FUNCTION detail_usage_pipeline()
RETURNS TRIGGER AS $$
DECLARE
    current_qty INT;
    v_detail_id INT;
    v_model_id INT;
BEGIN
    -- 1. basic validation (redundant with CHECK, but explicit)
    IF NEW.quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be positive';
    END IF;

    -- 2. get inventory data
    SELECT quantity, detail_id
    INTO current_qty, v_detail_id
    FROM inventory
    WHERE id = NEW.inventory_id;

    IF current_qty IS NULL THEN
        RAISE EXCEPTION 'Inventory record not found';
    END IF;

    -- 3. check stock availability
    IF current_qty < NEW.quantity THEN
        RAISE EXCEPTION 'Not enough items in inventory';
    END IF;

    -- 4. get vehicle model through full chain
    SELECT v.model_id
    INTO v_model_id
    FROM service s
    JOIN work_order wo ON wo.id = s.work_order_id
    JOIN request r ON r.id = wo.request_id
    JOIN vehicle v ON v.VIN = r.VIN
    WHERE s.id = NEW.service_id;

    IF v_model_id IS NULL THEN
        RAISE EXCEPTION 'Cannot determine vehicle model';
    END IF;

    -- 5. check compatibility
    IF NOT EXISTS (
        SELECT 1
        FROM detail_compatibility dc
        WHERE dc.detail_id = v_detail_id
          AND dc.model_id = v_model_id
    ) THEN
        RAISE EXCEPTION 'Detail is not compatible with vehicle model';
    END IF;

    -- 6. update inventory (atomic with insert)
    UPDATE inventory
    SET quantity = quantity - NEW.quantity
    WHERE id = NEW.inventory_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================================
-- DROP OLD TRIGGERS (IMPORTANT)
-- =========================================================

DROP TRIGGER IF EXISTS trg_check_inventory_usage ON detail_usage;
DROP TRIGGER IF EXISTS trg_decrease_inventory ON detail_usage;
DROP TRIGGER IF EXISTS trg_check_detail_compatibility ON detail_usage;

-- =========================================================
-- CREATE SINGLE PIPELINE TRIGGER
-- =========================================================

CREATE TRIGGER trg_detail_usage_pipeline
BEFORE INSERT ON detail_usage
FOR EACH ROW
EXECUTE FUNCTION detail_usage_pipeline();