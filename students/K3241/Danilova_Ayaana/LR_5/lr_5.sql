--
-- PostgreSQL database dump
--

\restrict uAfJ3rmOr9XPX7dPj8fJqTQ61RnhchMnkSo91dLHHIZZKM8dQjpNBKxcL59j5Ip

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

-- Started on 2026-05-20 04:42:17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16418)
-- Name: v1; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA v1;


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA v1; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA v1 IS 'Schema v1: Core backend structures for the Restaurant Management System';


--
-- TOC entry 1012 (class 1247 OID 34182)
-- Name: batch_status_enum; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.batch_status_enum AS ENUM (
    'available',
    'quarantine',
    'reserved',
    'expired',
    'depleted',
    'written_off'
);


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 1012
-- Name: TYPE batch_status_enum; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.batch_status_enum IS 'Tracks warehouse batch lifecycles (e.g., available, quarantine, expired, depleted)';


--
-- TOC entry 1053 (class 1247 OID 41467)
-- Name: category_code_enum; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.category_code_enum AS ENUM (
    'kitchen',
    'floor',
    'management'
);


--
-- TOC entry 1035 (class 1247 OID 41148)
-- Name: employee_event_type; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.employee_event_type AS ENUM (
    'department_assign',
    'commendation',
    'reprimand',
    'salary_up',
    'salary_down',
    'bonus',
    'fine',
    'promotion',
    'demotion',
    'vacation',
    'sick_leave',
    'termination',
    'certification',
    'medical_check',
    'return_from_sick_leave',
    'return_from_vacation',
    'reinstatement'
);


--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 1035
-- Name: TYPE employee_event_type; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.employee_event_type IS 'Categories for human resource actions and employee career timeline logs';


--
-- TOC entry 1038 (class 1247 OID 41251)
-- Name: inventory_item_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.inventory_item_status AS ENUM (
    'available',
    'reserved',
    'expired',
    'damaged',
    'written_off'
);


--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 1038
-- Name: TYPE inventory_item_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.inventory_item_status IS 'Physical operational states of single inventory or storage assets';


--
-- TOC entry 1009 (class 1247 OID 34058)
-- Name: measure_unit; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.measure_unit AS ENUM (
    'kg',
    'l',
    'pcs',
    'g',
    'ml',
    'pkg'
);


--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 1009
-- Name: TYPE measure_unit; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.measure_unit IS 'Standard measurement units used across stock, recipes, and items';


--
-- TOC entry 1015 (class 1247 OID 34229)
-- Name: order_item_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.order_item_status AS ENUM (
    'pending',
    'cooking',
    'ready',
    'served',
    'returned',
    'cancelled'
);


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 1015
-- Name: TYPE order_item_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.order_item_status IS 'Production stages of an individual dish within a customer order';


--
-- TOC entry 1020 (class 1247 OID 41026)
-- Name: order_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.order_status AS ENUM (
    'closed',
    'cancelled',
    'open',
    'confirmed',
    'served',
    'pending',
    'paid'
);


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 1020
-- Name: TYPE order_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.order_status IS 'Overall operational and financial status of a client billing order';


--
-- TOC entry 1059 (class 1247 OID 41520)
-- Name: payment_type_enum; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.payment_type_enum AS ENUM (
    'salary',
    'hourly',
    'commission'
);


--
-- TOC entry 1023 (class 1247 OID 41042)
-- Name: pinning_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.pinning_status AS ENUM (
    'waiting',
    'active',
    'serviced'
);


--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 1023
-- Name: TYPE pinning_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.pinning_status IS 'Lifecycle of table allocation to specific waiting guests';


--
-- TOC entry 1056 (class 1247 OID 41476)
-- Name: position_code_enum; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.position_code_enum AS ENUM (
    'chef',
    'sous_chef',
    'sushist',
    'pastry_chef',
    'hot_dishes_cook',
    'butcher',
    'cold_dishes_cook',
    'kitchen_helper',
    'head_waiter',
    'bartender',
    'hostess',
    'cashier',
    'waiter',
    'runner',
    'trainee_waiter',
    'restaurant_manager',
    'administrator',
    'marketer',
    'accountant',
    'purchasing_manager',
    'hr_manager'
);


--
-- TOC entry 1041 (class 1247 OID 41286)
-- Name: shift_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.shift_status AS ENUM (
    'waiting',
    'cancelled',
    'in-progress',
    'closed',
    'ordered'
);


--
-- TOC entry 1006 (class 1247 OID 34022)
-- Name: shift_type; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.shift_type AS ENUM (
    'day',
    'night'
);


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 1006
-- Name: TYPE shift_type; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.shift_type IS 'Identifies the operational working hours block (e.g., day, night)';


--
-- TOC entry 1029 (class 1247 OID 41104)
-- Name: shipment_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.shipment_status AS ENUM (
    'ordered',
    'in_transit',
    'arrived',
    'accepted',
    'disputed',
    'returned'
);


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 1029
-- Name: TYPE shipment_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.shipment_status IS 'Logistics tracking states for raw supply shipments from external providers';


--
-- TOC entry 1032 (class 1247 OID 41119)
-- Name: storage_type; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.storage_type AS ENUM (
    'dry_storage',
    'fridge',
    'freezer',
    'bar_counter',
    'vegetable_prep'
);


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 1032
-- Name: TYPE storage_type; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TYPE v1.storage_type IS 'Categorization of storage environments depending on temperature or zone';


--
-- TOC entry 1062 (class 1247 OID 41528)
-- Name: work_format_enum; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.work_format_enum AS ENUM (
    'full_time',
    'part_time',
    'remote',
    'flexible'
);


--
-- TOC entry 318 (class 1255 OID 41350)
-- Name: add_new_med_book(integer, date, date); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.add_new_med_book(IN p_worker_id integer, IN p_issued_date date, IN p_expires_date date)
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
begin
    UPDATE v1.med_book
    SET is_active = false
    WHERE worker_id = p_worker_id AND is_active = true;

    INSERT INTO v1.med_book (worker_id, issued_date, expires_date, is_active)
    VALUES (p_worker_id, p_issued_date, p_expires_date, true);
    
    RAISE INFO 'INFO: Medical book for worker_id % has been successfully updated.', p_worker_id;
end;
$$;


--
-- TOC entry 313 (class 1255 OID 41146)
-- Name: apply_salary_upgrade(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.apply_salary_upgrade(IN p_worker_id integer)
    LANGUAGE plpgsql
    AS $$

DECLARE
    v_last_promotion date;
    v_last_salary_up date;
    v_cur_salary NUMERIC;
    v_new_salary NUMERIC;
BEGIN
	select salary
	into v_cur_salary
	from v1.worker
	where worker_id = p_worker_id
	for update;
	
	if not found then
	raise exception 'Worker % is not exist.', p_worker_id;
	end if;

    SELECT event_date INTO v_last_promotion
    FROM v1.career_log
    WHERE worker_id = p_worker_id AND event_type = 'promotion'
    ORDER BY event_date DESC LIMIT 1;

    SELECT event_date INTO v_last_salary_up
    FROM v1.career_log
    WHERE worker_id = p_worker_id AND event_type = 'salary_up'
    ORDER BY event_date DESC LIMIT 1;
	

    IF v_last_promotion IS NULL THEN
	RAISE EXCEPTION 'WARNING: Note about worker with ID % upgrading was not found.', p_worker_id;

    ELSIF v_last_salary_up IS NOT NULL AND v_last_salary_up > v_last_promotion THEN
        RAISE NOTICE 'WARNING: The employee with id % salary has already been increased after the last category promotion.', p_worker_id;

    ELSIF v_cur_salary IS NULL OR v_cur_salary <= 0 THEN
        RAISE EXCEPTION 'WARNING: The employee % initial salary is NULL or 0.', p_worker_id;

    ELSE
        v_new_salary := round(v_cur_salary * 1.30, 4);

        UPDATE v1.worker
        SET salary = v_new_salary
        WHERE worker_id = p_worker_id;

        INSERT INTO v1.career_log (worker_id, event_type, new_val, description)
        VALUES (
            p_worker_id,
            'salary_up',
            v_new_salary::text,
            'Automatic 30% salary increase due to category growth'
        );

        RAISE NOTICE 'INFO: Employee salary % has been increased to %.', p_worker_id, v_new_salary;
    END IF;
END;
$$;


--
-- TOC entry 314 (class 1255 OID 41274)
-- Name: apply_worker_deactive(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.apply_worker_deactive(IN p_worker_id integer)
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$

declare 
    v_is_active     boolean;
    v_term_date     timestamp;
    v_vac_date      timestamp;
    v_sick_date     timestamp;
    v_reinst_date   timestamp;
    v_ret_vac_date  timestamp;
    v_ret_sick_date timestamp;
begin

    select is_active into v_is_active
    from v1.worker where worker_id = p_worker_id 
    for update;

    if not found then
        raise exception 'ERROR: Worker with ID % not found', p_worker_id;
    end if;

    select 
        max(event_date) filter (where event_type = 'termination'),
        max(event_date) filter (where event_type = 'vacation'),
        max(event_date) filter (where event_type = 'sick_leave'),
        max(event_date) filter (where event_type = 'reinstatement'),
        max(event_date) filter (where event_type = 'return_from_vacation'),
        max(event_date) filter (where event_type = 'return_from_sick_leave')
    into 
        v_term_date, v_vac_date, v_sick_date,
        v_reinst_date, v_ret_vac_date, v_ret_sick_date
    from v1.career_log
    where worker_id = p_worker_id;

    if v_term_date is not null and v_term_date > coalesce(v_reinst_date, '1900-01-01') then
        if v_is_active then
            update v1.worker set is_active = false where worker_id = p_worker_id;
            raise notice 'INFO: Worker % deactivated (termination date: %)', p_worker_id, v_term_date;
        end if;
        return;
    end if;

    if v_vac_date is not null and v_vac_date > coalesce(v_ret_vac_date, '1900-01-01') then
        if v_is_active then
            update v1.worker set is_active = false where worker_id = p_worker_id;
            raise notice 'INFO: Worker % deactivated (vacation start date: %)', p_worker_id, v_vac_date;
        end if;
        return;
    end if;

    if v_sick_date is not null and v_sick_date > coalesce(v_ret_sick_date, '1900-01-01') then
        if v_is_active then
            update v1.worker set is_active = false where worker_id = p_worker_id;
            raise notice 'INFO: Worker % deactivated (sick leave start date: %)', p_worker_id, v_sick_date;
        end if;
        return;
    end if;

    if not v_is_active then
        update v1.worker set is_active = true where worker_id = p_worker_id;
        raise notice 'INFO: Worker % activated (all absence events are closed by return events)', p_worker_id;
    else
        raise notice 'WARNING: No changes required. Worker % is already active and has no open absence logs.', p_worker_id;
    end if;

end;
$$;


--
-- TOC entry 317 (class 1255 OID 41351)
-- Name: archive_med_book(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.archive_med_book(IN p_med_book_id integer)
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
declare
    v_is_active boolean;
begin
    SELECT is_active INTO v_is_active FROM v1.med_book WHERE med_book_id = p_med_book_id;
    
    if v_is_active IS NULL then
        RAISE EXCEPTION 'ERROR: Medical book record with ID % not found.', p_med_book_id;
    end if;

    UPDATE v1.med_book
    SET is_active = false
    WHERE med_book_id = p_med_book_id;

    RAISE INFO 'INFO: Medical book with ID % has been successfully archived.', p_med_book_id;
end;
$$;


--
-- TOC entry 316 (class 1255 OID 41335)
-- Name: fix_duplicate_med_books(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.fix_duplicate_med_books(IN p_worker_id integer)
    LANGUAGE plpgsql
    AS $$
begin
    update med_book
    set is_active = false
    where worker_id = p_worker_id
        and is_active = true
        and med_book_id != (
            select med_book_id from med_book
            where worker_id = p_worker_id
                and is_active = true
            order by issued_date desc
            limit 1
        );
end;
$$;


--
-- TOC entry 320 (class 1255 OID 41352)
-- Name: force_delete_med_book(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.force_delete_med_book(IN p_med_book_id integer)
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
declare
    v_is_active boolean;
begin
    SELECT is_active INTO v_is_active 
    FROM v1.med_book 
    WHERE med_book_id = p_med_book_id;

    if v_is_active IS NULL then
        RAISE EXCEPTION 'ERROR: Medical book record with ID % not found.', p_med_book_id;
    end if;

    if v_is_active = true then
        RAISE EXCEPTION 'ERROR: Cannot force delete an ACTIVE medical book. Archive it first using archive_med_book().'
            USING errcode = 'P0007';
    end if;

    UPDATE v1.med_book 
    SET is_active = false 
    WHERE med_book_id = p_med_book_id;

    DELETE FROM v1.med_book 
    WHERE med_book_id = p_med_book_id;

    RAISE INFO 'INFO: Medical book record with ID % has been physically deleted from the system.', p_med_book_id;
end;
$$;


--
-- TOC entry 283 (class 1255 OID 41144)
-- Name: get_order_total_cost(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.get_order_total_cost(IN p_order_id integer, OUT p_total_cost numeric)
    LANGUAGE plpgsql
    AS $$

BEGIN
    SELECT sum(row_total)
    INTO p_total_cost
    FROM v1.order_scoup
    WHERE order_id = p_order_id AND status != 'cancelled';

    IF p_total_cost IS NULL THEN
        RAISE NOTICE 'WARNING: Order % not found. Setting cost to 0.', p_order_id;
        p_total_cost := 0;
    END IF;
END;
$$;


--
-- TOC entry 282 (class 1255 OID 41138)
-- Name: get_waiter_orders_on_date(integer, date); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.get_waiter_orders_on_date(IN p_waiter_id integer, IN p_shift_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
    r RECORD;
    v_found BOOLEAN := FALSE;
BEGIN
    RAISE NOTICE '--- Checking orders for Waiter % on Date: % ---', p_waiter_id, p_shift_date;

    FOR r IN (
        SELECT 
            o.order_id,
            o.created_at::time as order_time,
            sum(os.dish_count) as dishes_count,
            array_agg(d.dish_name) as scoup_list,
            sum(os.row_total) as order_total_cost
        FROM worker w
        JOIN worker_shift ws ON w.worker_id = ws.worker_id
        JOIN shift s ON s.shift_id = ws.shift_id 
        JOIN pinned_table pt ON ws.ws_id = pt.ws_id
        JOIN "order" o ON o.pinning_id = pt.pinning_id
        JOIN order_scoup os ON os.order_id = o.order_id
        JOIN dish d on d.dish_id = os.dish_id
        WHERE w.worker_id = p_waiter_id
          AND s.shift_start::date = p_shift_date
        GROUP BY o.order_id, o.created_at
        ORDER BY o.created_at
    ) 
    LOOP
        v_found := TRUE;
        RAISE NOTICE 'Order %: Time: %, Dishes count: %, Scoup: %, Total cost: %', 
                     r.order_id, r.order_time, r.dishes_count, r.scoup_list, r.order_total_cost;
    END LOOP;

    IF NOT v_found THEN
        RAISE NOTICE 'Orders not found for this criteria.';
    END IF;
END;
$$;


--
-- TOC entry 293 (class 1255 OID 41139)
-- Name: get_waiter_orders_on_date_to_file(integer, date, text); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.get_waiter_orders_on_date_to_file(IN p_waiter_id integer, IN p_shift_date date, IN p_file_path text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Starting export for waiter % on date % to file %', p_waiter_id, p_shift_date, p_file_path;

    EXECUTE format('
        COPY (
            SELECT
                o.order_id,
                o.created_at::time as order_time,
                sum(os.dish_count) as total_dishes,
                array_agg(d.dish_name) as dishes_list,
                sum(os.row_total) as order_cost
            FROM worker w
            JOIN worker_shift ws ON w.worker_id = ws.worker_id
            JOIN shift s ON s.shift_id = ws.shift_id
            JOIN pinned_table pt ON ws.ws_id = pt.ws_id
            JOIN "order" o ON o.pinning_id = pt.pinning_id
            JOIN order_scoup os ON os.order_id = o.order_id
            JOIN dish d ON d.dish_id = os.dish_id
            WHERE w.worker_id = %L
              AND s.shift_start::date = %L
            GROUP BY o.order_id, o.created_at
            ORDER BY o.created_at
        ) TO %L WITH (FORMAT CSV, HEADER, ENCODING ''UTF8'')', 
        p_waiter_id, p_shift_date, p_file_path);

    RAISE NOTICE 'Export completed successfully.';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error during export: %', SQLERRM;
END;
$$;


--
-- TOC entry 315 (class 1255 OID 41275)
-- Name: refresh_ingredient_unit_cost(integer); Type: PROCEDURE; Schema: v1; Owner: -
--

CREATE PROCEDURE v1.refresh_ingredient_unit_cost(IN p_ingr_id integer)
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$

declare
    v_ingr_exists     boolean;
    v_batch_id        integer;
    v_unit_cost       numeric(19,4);
    v_exp_date        date;
    v_scoup_status    character varying(9);
    v_curr_qty        numeric(12,3);
begin
    select true into v_ingr_exists
    from v1.ingredient
    where ingredient_id = p_ingr_id
    for update;

    if not found then
        raise exception 'ERROR: Ingredient with ID % not found', p_ingr_id;
    end if;

    select
        b.batch_id,
        b.ingr_unit_cost,
        b.batch_exp_data,
        ss.st_sc_status,
        ss.st_sc_curr_qty
    into
        v_batch_id,
        v_unit_cost,
        v_exp_date,
        v_scoup_status,
        v_curr_qty
    from v1.batch b
    join v1.storage_scoup ss
        on ss.batch_id = b.batch_id
    where b.ingr_id = p_ingr_id
      and ss.st_sc_status = 'available'
      and ss.st_sc_curr_qty > 0
      and b.batch_exp_data >= current_date
    order by b.batch_exp_data asc
    limit 1
    for update of b, ss;

    if not found then
        raise notice 'WARNING: No active batches found for ingredient %. Resetting unit cost to 0.', p_ingr_id;

        update v1.ingredient
        set ingr_unit_cost = 0
        where ingredient_id = p_ingr_id;

        return;
    end if;

    raise notice
        'INFO: Ingredient %: active batch % found (expiration date: %, current qty: %, unit cost: %)',
        p_ingr_id, v_batch_id, v_exp_date, v_curr_qty, v_unit_cost;

    update v1.ingredient
    set ingr_unit_cost = v_unit_cost
    where ingredient_id = p_ingr_id;

exception
    when deadlock_detected then
        raise exception 'ERROR: Deadlock detected while processing ingredient %. Please retry transaction.', p_ingr_id;
    when lock_not_available then
        raise exception 'ERROR: Lock not available for ingredient %. Row is locked by another transaction.', p_ingr_id;
    when others then
        raise exception 'CRITICAL: Unexpected error while processing ingredient %: % (SQLSTATE: %)',
            p_ingr_id, sqlerrm, sqlstate;
end;
$$;


--
-- TOC entry 323 (class 1255 OID 41464)
-- Name: trg_category(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_category() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
DECLARE
    v_has_positions BOOLEAN;
BEGIN
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        NEW.name_en := TRIM(REGEXP_REPLACE(NEW.name_en, '\s+', ' ', 'g'));
        NEW.name_ru := TRIM(REGEXP_REPLACE(NEW.name_ru, '\s+', ' ', 'g'));
        RETURN NEW;
    END IF;

    IF TG_OP = 'DELETE' THEN
        SELECT EXISTS (SELECT 1 FROM v1.position WHERE category_id = OLD.category_id) INTO v_has_positions;
        IF v_has_positions THEN
            RAISE EXCEPTION 'ERROR: This category contains positions and cannot be deleted.' USING ERRCODE = 'P0202';
        END IF;
        RETURN OLD;
    END IF;
END;
$$;


--
-- TOC entry 267 (class 1255 OID 32906)
-- Name: trg_check_waiter_on_shift(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_check_waiter_on_shift() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM v1.worker_shift
        WHERE worker_id = NEW.waiter_id
          AND shift_id  = NEW.shift_id
    ) THEN
        RAISE EXCEPTION
            'Официант % не числится на смене %. '
            'Сначала добавьте его в worker_shift.',
            NEW.waiter_id, NEW.shift_id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 280 (class 1255 OID 33987)
-- Name: trg_enforce_single_active_record(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_enforce_single_active_record() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    active_count INT;
BEGIN
    -- Считаем, сколько уже есть активных записей для этого работника
    -- Исключаем саму текущую строку (при обновлении), чтобы не считать её саму
    SELECT COUNT(*) 
    INTO active_count
    FROM v1.med_book 
    WHERE worker_id = NEW.worker_id 
      AND is_active = true
      AND (TG_OP = 'INSERT' OR med_book_id != OLD.med_book_id);

    -- Если мы пытаемся вставить/обновить запись как активную (true)
    -- Но счетчик уже показал, что такая запись есть
    IF NEW.is_active = true AND active_count >= 1 THEN
        -- Вместо ошибки мы просто принудительно ставим false
        NEW.is_active := false;
        
        -- (Опционально) Можно вывести уведомление в консоль
        RAISE NOTICE 'У работника % уже есть активная запись. Новая запись сохранена как неактивная.', NEW.worker_id;
    END IF;

    RETURN NEW;
END;
$$;


--
-- TOC entry 326 (class 1255 OID 41554)
-- Name: trg_generic_audit(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_generic_audit() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    insert into v1.audit_logs (table_name, operation, row_id, old_data, new_data)
    values (
        TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
        TG_OP,
        -- TODO: After the planned refactoring and renaming of all primary keys 
        -- (position_id, category_id, etc.) to a unified "id" standard, 
        -- this block will shrink down to: (case when TG_OP = 'DELETE' then to_jsonb(old) else to_jsonb(new) end ->> 'id')::integer
        coalesce(
            (case when TG_OP = 'DELETE' then to_jsonb(old) else to_jsonb(new) end ->> 'position_id')::integer,
            (case when TG_OP = 'DELETE' then to_jsonb(old) else to_jsonb(new) end ->> 'id')::integer
        ),
        case when TG_OP in ('UPDATE', 'DELETE') then to_jsonb(old) else null end,
        case when TG_OP in ('INSERT', 'UPDATE') then to_jsonb(new) else null end
    );
    
    if TG_OP = 'DELETE' then return old; else return new; end if;
end;
$$;


--
-- TOC entry 319 (class 1255 OID 41308)
-- Name: trg_med_book(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_med_book() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
BEGIN

    IF TG_OP = 'INSERT' THEN

        IF NEW.issued_date > CURRENT_DATE THEN
            RAISE EXCEPTION 'ERROR: Document issue date cannot be in the future.'
                USING ERRCODE = 'P0011';
        END IF;

        IF NEW.is_active = true AND NEW.expires_date < CURRENT_DATE THEN
            RAISE EXCEPTION 'ERROR: Cannot activate an expired document.'
                USING ERRCODE = 'P0004';
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        IF NEW.issued_date != OLD.issued_date AND NEW.issued_date > CURRENT_DATE THEN
            RAISE EXCEPTION 'ERROR: Document issue date cannot be in the future.'
                USING ERRCODE = 'P0011';
        END IF;

        IF NEW.is_active = true THEN
            IF NEW.expires_date < CURRENT_DATE THEN
                RAISE EXCEPTION 'ERROR: Cannot activate an expired document.'
                    USING ERRCODE = 'P0004';
            END IF;
        END IF;

        IF OLD.is_active = true AND (NEW.issued_date != OLD.issued_date OR NEW.expires_date != OLD.expires_date) THEN
            IF NEW.expires_date < CURRENT_DATE THEN
                RAISE EXCEPTION 'ERROR: Cannot update dates of an active document to an expired period.'
                    USING ERRCODE = 'P0005';
            END IF;
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        IF OLD.is_active = true THEN
            RAISE EXCEPTION 'ERROR: Deletion of an active document is strictly prohibited.'
                USING ERRCODE = 'P0003';
        END IF;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$$;


--
-- TOC entry 321 (class 1255 OID 41353)
-- Name: trg_passport(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_passport() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$

begin



    if TG_OP in ('INSERT', 'UPDATE') then

        if new.passport_num is not null then

            new.passport_num = regexp_replace(new.passport_num, '\s+', '', 'g');

        end if;



        if new.passport_series is not null then

            new.passport_series = regexp_replace(new.passport_series, '\s+', '', 'g');

        end if;



        if new.dep_code is not null then

            new.dep_code = regexp_replace(new.dep_code, '\s+', '', 'g');

        end if;



        if new.issued_by is not null then

            new.issued_by = trim(regexp_replace(new.issued_by, '\s+', ' ', 'g'));

        end if;



        if new.reg_address is not null then

            new.reg_address = trim(regexp_replace(new.reg_address, '\s+', ' ', 'g'));

        end if;

    end if;



    if TG_OP = 'INSERT' then

        if new.is_active = true and new.expires_date < current_date then

            raise exception 'ERROR: Cannot insert an active passport that has already expired (Expires: %, Current date: %)',

                new.expires_date, current_date

                using errcode = 'P0004';

        end if;



        return new;



    elsif TG_OP = 'UPDATE' then

        if new.is_active = true then

            if new.expires_date < current_date then

                raise exception 'ERROR: Cannot activate an expired passport (Expires: %, Current date: %)',

                    new.expires_date, current_date

                    using errcode = 'P0004';

            end if;

        end if;



        if old.is_active = true and (new.issued_date != old.issued_date or new.expires_date != old.expires_date) then

            if new.expires_date < current_date then

                raise exception 'ERROR: Cannot update dates of an active passport to an expired period'

                    using errcode = 'P0005';

            end if;

        end if;



        return new;



    elsif TG_OP = 'DELETE' then

        if old.is_active = true then

            raise exception 'ERROR: Deletion of an active passport is strictly prohibited'

                using errcode = 'P0003';

        end if;



        return old;

    end if;



    return null;

end;

$$;


--
-- TOC entry 325 (class 1255 OID 41552)
-- Name: trg_position_delete_check(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_position_delete_check() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
DECLARE
    v_has_employees BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM worker WHERE position_id = OLD.position_id
    ) INTO v_has_employees;

    IF v_has_employees THEN
        RAISE EXCEPTION 'ERROR: This position is currently assigned to operational workers and cannot be deleted.' 
        USING ERRCODE = 'P0102';
    END IF;

    RETURN OLD;
END;
$$;


--
-- TOC entry 324 (class 1255 OID 41542)
-- Name: trg_position_hierarchy_check(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_position_hierarchy_check() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
BEGIN
    NEW.name_en := INITCAP(TRIM(REGEXP_REPLACE(NEW.name_en, '\s+', ' ', 'g'))); 
    NEW.name_ru := INITCAP(TRIM(REGEXP_REPLACE(NEW.name_ru, '\s+', ' ', 'g'))); 

    IF NEW.position_code IS NULL THEN
        RAISE EXCEPTION 'ERROR: position_code is required.' USING ERRCODE = 'P0104';
    END IF;
    IF TG_OP = 'UPDATE' AND OLD.position_code <> NEW.position_code THEN
        RAISE EXCEPTION 'ERROR: Changing immutable position_code is prohibited.' USING ERRCODE = 'P0105';
    END IF;
    IF NEW.base_salary <= 0 THEN
        RAISE EXCEPTION 'ERROR: Base salary must be greater than zero.' USING ERRCODE = 'P0101';
    END IF;
    IF NEW.rank_level <= 0 THEN
        RAISE EXCEPTION 'ERROR: Rank level must be a positive number.' USING ERRCODE = 'P0106';
    END IF;

    IF EXISTS (
        SELECT 1 FROM v1.position
        WHERE category_id = NEW.category_id
          AND position_id <> COALESCE(NEW.position_id, -1)
          AND rank_level < NEW.rank_level   
          AND base_salary > NEW.base_salary 
    ) THEN
        RAISE EXCEPTION 'ERROR: Financial hierarchy violation. Lower rank cannot have a higher salary.' USING ERRCODE = 'P0107';
    END IF;

    IF EXISTS (
        SELECT 1 FROM v1.position
        WHERE category_id = NEW.category_id
          AND position_id <> COALESCE(NEW.position_id, -1)
          AND rank_level > NEW.rank_level   
          AND base_salary < NEW.base_salary
    ) THEN
        RAISE EXCEPTION 'ERROR: Financial hierarchy violation. Higher rank cannot have a lower salary.' USING ERRCODE = 'P0108';
    END IF;

    RETURN NEW;
END;
$$;


--
-- TOC entry 322 (class 1255 OID 41460)
-- Name: trg_shift(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_shift() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'v1'
    AS $$
DECLARE
    v_start TIME WITHOUT TIME ZONE;
    v_interval INTERVAL;
    v_duration INTERVAL;
    v_fact_start_time TIME;
    v_is_deletable BOOLEAN;
    v_requires_time BOOLEAN;
    v_status_active BOOLEAN;
BEGIN
    IF TG_OP IN ('INSERT', 'UPDATE') THEN

        SELECT standard_start_time, allowed_start_window, duration
        INTO v_start, v_interval, v_duration
        FROM v1.shift_policy
        WHERE id = NEW.type_id AND is_active = true;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'ERROR: Policy identifier not found in configuration.'
            USING ERRCODE = 'P0006';
        END IF;

        v_fact_start_time := NEW.shift_start::time;

        IF v_fact_start_time < (v_start - v_interval) OR v_fact_start_time > (v_start + v_interval) THEN
            RAISE EXCEPTION 'ERROR: Shift start time is outside the allowed scheduling window.'
            USING ERRCODE = 'P0007';
        END IF;

        IF NEW.shift_end IS NULL THEN
            NEW.shift_end := NEW.shift_start + v_duration;
        END IF;

        SELECT requires_active_time, is_active 
        INTO v_requires_time, v_status_active
        FROM v1.shift_status_setting WHERE id = NEW.status_id;

        IF NOT FOUND OR v_status_active = false THEN
            RAISE EXCEPTION 'ERROR: Requested status change is blocked by lifecycle rules.'
            USING ERRCODE = 'P0008';
        END IF;

        IF TG_OP = 'UPDATE' AND OLD.status_id <> NEW.status_id THEN
            IF NOT EXISTS (
                SELECT 1 
                FROM v1.shift_status_setting 
                WHERE id = OLD.status_id AND NEW.status_id = ANY(allowed_next_status_ids)
            ) THEN
                RAISE EXCEPTION 'ERROR: Requested status change is blocked by lifecycle rules.'
                USING ERRCODE = 'P0008';
            END IF;
        END IF;

        IF v_requires_time AND NOT (CLOCK_TIMESTAMP() BETWEEN NEW.shift_start AND NEW.shift_end) THEN
            RAISE EXCEPTION 'ERROR: Cannot change status because current real time is outside shift boundaries.'
            USING ERRCODE = 'P0009';
        END IF;

        RETURN NEW;
    END IF;

    IF TG_OP = 'DELETE' THEN
        SELECT is_deletable INTO v_is_deletable
        FROM v1.shift_status_setting
        WHERE id = OLD.status_id;

        IF NOT COALESCE(v_is_deletable, false) THEN
            RAISE EXCEPTION 'ERROR: This shift status is locked and protected from deletion to preserve operational history.'
            USING ERRCODE = 'P0010';
        END IF;

        RETURN OLD;
    END IF;

END;
$$;


SET default_tablespace = '';

--
-- TOC entry 261 (class 1259 OID 41356)
-- Name: audit_logs; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.audit_logs (
    id bigint NOT NULL,
    table_name text NOT NULL,
    operation text NOT NULL,
    row_id integer,
    old_data jsonb,
    new_data jsonb,
    changed_by text DEFAULT CURRENT_USER,
    changed_at timestamp with time zone DEFAULT clock_timestamp()
);


--
-- TOC entry 260 (class 1259 OID 41355)
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 260
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.audit_logs_id_seq OWNED BY v1.audit_logs.id;


--
-- TOC entry 221 (class 1259 OID 16453)
-- Name: batch; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.batch (
    batch_id integer NOT NULL,
    shipment_id integer NOT NULL,
    ingr_id integer NOT NULL,
    ingr_unit_cost numeric(19,4) NOT NULL,
    ingr_count numeric(12,3) NOT NULL,
    batch_status v1.batch_status_enum NOT NULL,
    batch_exp_data date NOT NULL,
    ingr_unit_vol numeric(12,3) NOT NULL,
    total_batch_cost numeric(19,4) GENERATED ALWAYS AS ((ingr_unit_cost * ingr_count)) STORED
);


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE batch; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.batch IS 'Details of specific ingredient delivery batches received from suppliers';


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.batch_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.batch_id IS 'Unique identifier for the storage batch';


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.shipment_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.shipment_id IS 'Foreign key linking to the source procurement shipment';


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.ingr_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.ingr_id IS 'Foreign key linking to the master ingredient list';


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.ingr_unit_cost; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.ingr_unit_cost IS 'Cost price per single measure unit of the ingredient in this batch';


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.ingr_count; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.ingr_count IS 'Initial delivered quantity of the ingredient';


--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.batch_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.batch_status IS 'Current commercial accessibility or disposal state of the batch';


--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.batch_exp_data; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.batch_exp_data IS 'Expiration date of the products within this batch';


--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.ingr_unit_vol; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.ingr_unit_vol IS 'Physical mass or volume context per item container';


--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN batch.total_batch_cost; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.total_batch_cost IS 'Automatically calculated total financial valuation of the batch';


--
-- TOC entry 239 (class 1259 OID 16553)
-- Name: career_log; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.career_log (
    note_id integer NOT NULL,
    worker_id integer NOT NULL,
    event_type v1.employee_event_type NOT NULL,
    new_val character varying(100),
    description character varying(300),
    command_num integer,
    event_date timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE career_log; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.career_log IS 'Historical audit trail of all staff contract updates, promotions, and absences';


--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.note_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.note_id IS 'Unique serial code for the career log entry';


--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.worker_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.worker_id IS 'Foreign key linking to the affected employee';


--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.event_type; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.event_type IS 'The nature of the recorded HR action';


--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.new_val; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.new_val IS 'New textual value or state assigned during the event (e.g., new salary amount)';


--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.description; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.description IS 'Optional detailed textual context or reason behind the event';


--
-- TOC entry 5355 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.command_num; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.command_num IS 'Internal administrative order or contract number reference';


--
-- TOC entry 5356 (class 0 OID 0)
-- Dependencies: 239
-- Name: COLUMN career_log.event_date; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.career_log.event_date IS 'Timestamp when the event occurred or was registered';


--
-- TOC entry 238 (class 1259 OID 16552)
-- Name: career_log_note_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.career_log_note_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5357 (class 0 OID 0)
-- Dependencies: 238
-- Name: career_log_note_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.career_log_note_id_seq OWNED BY v1.career_log.note_id;


--
-- TOC entry 233 (class 1259 OID 16520)
-- Name: category; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.category (
    category_id integer NOT NULL,
    requires_med_book boolean DEFAULT false,
    category_code v1.category_code_enum NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ru character varying(100) NOT NULL
);


--
-- TOC entry 5358 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE category; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.category IS 'Restaurant organizational divisions and department groups';


--
-- TOC entry 5359 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN category.category_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.category.category_id IS 'Unique reference ID of the company department';


--
-- TOC entry 5360 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN category.requires_med_book; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.category.requires_med_book IS 'Flag indicating if personnel in this department legally require a valid health book';


--
-- TOC entry 232 (class 1259 OID 16519)
-- Name: category_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5361 (class 0 OID 0)
-- Dependencies: 232
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.category_id_seq OWNED BY v1.category.category_id;


--
-- TOC entry 220 (class 1259 OID 16452)
-- Name: delivery_scoup_batch_num_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.delivery_scoup_batch_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5362 (class 0 OID 0)
-- Dependencies: 220
-- Name: delivery_scoup_batch_num_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.delivery_scoup_batch_num_seq OWNED BY v1.batch.batch_id;


--
-- TOC entry 227 (class 1259 OID 16484)
-- Name: dish; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.dish (
    dish_id integer NOT NULL,
    dish_name character varying(100) NOT NULL,
    dish_price numeric(19,4) NOT NULL,
    dish_ccal integer NOT NULL,
    dish_weight numeric(8,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    category_id integer NOT NULL
);


--
-- TOC entry 5363 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE dish; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.dish IS 'Master register of food and beverage menu items available to customers';


--
-- TOC entry 5364 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.dish_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_id IS 'Unique identifying key for the menu item';


--
-- TOC entry 5365 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.dish_name; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_name IS 'Commercial name of the dish as printed on the menu';


--
-- TOC entry 5366 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.dish_price; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_price IS 'Current retail selling price charged to clients';


--
-- TOC entry 5367 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.dish_ccal; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_ccal IS 'Total caloric energy value per standard serving';


--
-- TOC entry 5368 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.dish_weight; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_weight IS 'Net weight or volume of the prepared serving';


--
-- TOC entry 5369 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.is_active; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.is_active IS 'Flag showing if the item is currently active and can be ordered';


--
-- TOC entry 5370 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dish.category_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.category_id IS 'Foreign key referencing the kitchen menu section category';


--
-- TOC entry 253 (class 1259 OID 32815)
-- Name: dish_category; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.dish_category (
    category_id integer NOT NULL,
    category_name character varying(30) NOT NULL
);


--
-- TOC entry 252 (class 1259 OID 32814)
-- Name: dish_category_category_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.dish_category_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5371 (class 0 OID 0)
-- Dependencies: 252
-- Name: dish_category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.dish_category_category_id_seq OWNED BY v1.dish_category.category_id;


--
-- TOC entry 226 (class 1259 OID 16483)
-- Name: dish_dish_code_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.dish_dish_code_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5372 (class 0 OID 0)
-- Dependencies: 226
-- Name: dish_dish_code_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.dish_dish_code_seq OWNED BY v1.dish.dish_id;


--
-- TOC entry 229 (class 1259 OID 16493)
-- Name: dish_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.dish_scoup (
    dish_sc_id integer NOT NULL,
    dish_id integer NOT NULL,
    ingr_id integer NOT NULL,
    ingr_vol numeric(12,3) NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 16492)
-- Name: dish_scoup_volume_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."dish_scoup_volume_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5373 (class 0 OID 0)
-- Dependencies: 228
-- Name: dish_scoup_volume_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."dish_scoup_volume_ID_seq" OWNED BY v1.dish_scoup.dish_sc_id;


--
-- TOC entry 249 (class 1259 OID 24661)
-- Name: ingredient; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.ingredient (
    ingredient_id integer NOT NULL,
    ingr_unit v1.measure_unit NOT NULL,
    ingr_proteins numeric(8,2) NOT NULL,
    ingr_fats numeric(8,2) NOT NULL,
    ingr_carb numeric(8,2) NOT NULL,
    ingr_ccal integer NOT NULL,
    ingr_min_qty numeric(10,3) NOT NULL,
    ingr_name character varying(100) NOT NULL,
    ingr_unit_cost numeric(19,4)
);


--
-- TOC entry 5374 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE ingredient; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.ingredient IS 'Raw food items, materials, and ingredients database inventory list';


--
-- TOC entry 5375 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingredient_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingredient_id IS 'Unique structural ID for the material asset';


--
-- TOC entry 5376 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_unit; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_unit IS 'Base measure scale (e.g., kg, l, pcs) for stocktaking transactions';


--
-- TOC entry 5377 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_proteins; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_proteins IS 'Nutritional protein content value per 100g/ml';


--
-- TOC entry 5378 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_fats; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_fats IS 'Nutritional fat content value per 100g/ml';


--
-- TOC entry 5379 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_carb; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_carb IS 'Nutritional carbohydrate content value per 100g/ml';


--
-- TOC entry 5380 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_ccal; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_ccal IS 'Energy density kilocalories score per 100g/ml';


--
-- TOC entry 5381 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_min_qty; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_min_qty IS 'Safety buffer minimum stock quantity threshold before reorder';


--
-- TOC entry 5382 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_name; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_name IS 'Standard common name of the raw material';


--
-- TOC entry 5383 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN ingredient.ingr_unit_cost; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_unit_cost IS 'Dynamically refreshed operational cost valuation based on latest active stock';


--
-- TOC entry 248 (class 1259 OID 24660)
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.ingredient_ingredient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5384 (class 0 OID 0)
-- Dependencies: 248
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.ingredient_ingredient_id_seq OWNED BY v1.ingredient.ingredient_id;


--
-- TOC entry 258 (class 1259 OID 32930)
-- Name: med_book; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.med_book (
    med_book_id integer NOT NULL,
    worker_id integer NOT NULL,
    issued_date date NOT NULL,
    expires_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    notes text,
    CONSTRAINT chk_date_interval CHECK ((expires_date < (issued_date + '2 years'::interval))),
    CONSTRAINT chk_med_book_dates CHECK ((expires_date > issued_date))
);


--
-- TOC entry 5385 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE med_book; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.med_book IS 'Health compliance and mandatory medical certification records for staff';


--
-- TOC entry 5386 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN med_book.med_book_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.med_book.med_book_id IS 'Unique identifier for the sanitary record file';


--
-- TOC entry 5387 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN med_book.worker_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.med_book.worker_id IS 'Foreign key referencing the examined employee';


--
-- TOC entry 5388 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN med_book.issued_date; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.med_book.issued_date IS 'Calendar date when the medical book was officially stamped';


--
-- TOC entry 5389 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN med_book.expires_date; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.med_book.expires_date IS 'Calendar date when the medical certification expires';


--
-- TOC entry 5390 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN med_book.is_active; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.med_book.is_active IS 'Flag to mark if this specific certificate is the primary active file';


--
-- TOC entry 5391 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN med_book.notes; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.med_book.notes IS 'Optional text annotations concerning medical check restrictions';


--
-- TOC entry 257 (class 1259 OID 32929)
-- Name: med_book_med_book_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.med_book_med_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5392 (class 0 OID 0)
-- Dependencies: 257
-- Name: med_book_med_book_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.med_book_med_book_id_seq OWNED BY v1.med_book.med_book_id;


--
-- TOC entry 243 (class 1259 OID 24599)
-- Name: order; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1."order" (
    order_id integer NOT NULL,
    pinning_id integer NOT NULL,
    order_wishes character varying(300),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    closed_at time with time zone,
    order_status v1.order_status
);


--
-- TOC entry 242 (class 1259 OID 24598)
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5393 (class 0 OID 0)
-- Dependencies: 242
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.order_order_id_seq OWNED BY v1."order".order_id;


--
-- TOC entry 251 (class 1259 OID 24684)
-- Name: order_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.order_scoup (
    order_sc_id integer NOT NULL,
    order_id integer NOT NULL,
    dish_id integer NOT NULL,
    dish_price_snapshot numeric(19,4) NOT NULL,
    dish_count integer NOT NULL,
    dish_wishes character varying(300),
    row_total numeric(19,4) GENERATED ALWAYS AS ((dish_price_snapshot * (dish_count)::numeric)) STORED,
    status v1.order_item_status DEFAULT 'pending'::v1.order_item_status NOT NULL,
    ws_id integer
);


--
-- TOC entry 5394 (class 0 OID 0)
-- Dependencies: 251
-- Name: COLUMN order_scoup.dish_price_snapshot; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.order_scoup.dish_price_snapshot IS 'Цена блюда на момент оформления заказа (снимок из dish.dish_price). Намеренно денормализована для исторической точности.';


--
-- TOC entry 5395 (class 0 OID 0)
-- Dependencies: 251
-- Name: COLUMN order_scoup.status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.order_scoup.status IS 'Текущий статус позиции в заказе: от ожидания до подачи или возврата';


--
-- TOC entry 250 (class 1259 OID 24683)
-- Name: order_scoup_order_sc_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.order_scoup_order_sc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5396 (class 0 OID 0)
-- Dependencies: 250
-- Name: order_scoup_order_sc_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.order_scoup_order_sc_id_seq OWNED BY v1.order_scoup.order_sc_id;


--
-- TOC entry 237 (class 1259 OID 16543)
-- Name: passport; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.passport (
    passport_id integer NOT NULL,
    worker_id integer NOT NULL,
    passport_num character varying(15) NOT NULL,
    passport_series character varying(10) NOT NULL,
    issued_by text NOT NULL,
    issued_date date NOT NULL,
    dep_code character varying(10) NOT NULL,
    reg_address text NOT NULL,
    expires_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    notes text,
    CONSTRAINT chk_department_code CHECK (((dep_code)::text ~ '^\d{3}-\d{3}$'::text)),
    CONSTRAINT chk_issued_before_expired_date CHECK ((issued_date < expires_date)),
    CONSTRAINT chk_passport_num CHECK (((passport_num)::text ~ '^\d{6}$'::text)),
    CONSTRAINT chk_passport_series CHECK (((passport_series)::text ~ '^\d{4}$'::text))
);


--
-- TOC entry 236 (class 1259 OID 16542)
-- Name: passport_passport_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.passport_passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5397 (class 0 OID 0)
-- Dependencies: 236
-- Name: passport_passport_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.passport_passport_id_seq OWNED BY v1.passport.passport_id;


--
-- TOC entry 247 (class 1259 OID 24628)
-- Name: pinned_table; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.pinned_table (
    pinning_id integer NOT NULL,
    pinning_status v1.pinning_status NOT NULL,
    table_id integer NOT NULL,
    ws_id integer NOT NULL,
    pinned_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_pin_table_status CHECK (((pinning_status)::text = ANY (ARRAY[('waiting'::character varying)::text, ('active'::character varying)::text, ('serviced'::character varying)::text])))
);


--
-- TOC entry 246 (class 1259 OID 24627)
-- Name: pinned_table_pinning_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.pinned_table_pinning_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5398 (class 0 OID 0)
-- Dependencies: 246
-- Name: pinned_table_pinning_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.pinned_table_pinning_id_seq OWNED BY v1.pinned_table.pinning_id;


--
-- TOC entry 235 (class 1259 OID 16528)
-- Name: position; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1."position" (
    position_id integer NOT NULL,
    category_id integer NOT NULL,
    payment_type v1.payment_type_enum NOT NULL,
    work_format v1.work_format_enum NOT NULL,
    base_salary numeric(19,4) NOT NULL,
    rank_level integer NOT NULL,
    position_code v1.position_code_enum NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ru character varying(100) NOT NULL
);


--
-- TOC entry 5399 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE "position"; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1."position" IS 'Job title definitions and structural payment frameworks';


--
-- TOC entry 5400 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "position".position_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1."position".position_id IS 'Unique reference for the corporate job role';


--
-- TOC entry 5401 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "position".category_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1."position".category_id IS 'Parent department category reference code';


--
-- TOC entry 5402 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "position".payment_type; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1."position".payment_type IS 'Salary distribution frequency model (e.g., Salary, Hourly)';


--
-- TOC entry 5403 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "position".work_format; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1."position".work_format IS 'Scheduling layout model (e.g., Full-time, Part-time)';


--
-- TOC entry 5404 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "position".base_salary; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1."position".base_salary IS 'Default basic starting wage baseline for the job';


--
-- TOC entry 5405 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN "position".rank_level; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1."position".rank_level IS 'Internal hierarchical seniority index';


--
-- TOC entry 234 (class 1259 OID 16527)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.position_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5406 (class 0 OID 0)
-- Dependencies: 234
-- Name: position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.position_position_id_seq OWNED BY v1."position".position_id;


--
-- TOC entry 217 (class 1259 OID 16419)
-- Name: provider; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.provider (
    provider_id integer NOT NULL,
    organization character varying(100) NOT NULL,
    contacts character varying(13) NOT NULL,
    CONSTRAINT check_phone_format CHECK (((contacts)::text ~ '^\+\d{1,3}\d{10}$'::text))
);


--
-- TOC entry 245 (class 1259 OID 24619)
-- Name: shift; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shift (
    shift_id integer NOT NULL,
    shift_start timestamp with time zone NOT NULL,
    shift_end timestamp with time zone,
    type_id integer NOT NULL,
    status_id integer NOT NULL,
    CONSTRAINT chk_shift_start_before_end CHECK ((shift_start < shift_end))
);


--
-- TOC entry 263 (class 1259 OID 41408)
-- Name: shift_policy; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shift_policy (
    id integer NOT NULL,
    type_code v1.shift_type NOT NULL,
    name_ru character varying(100) NOT NULL,
    standard_start_time time without time zone NOT NULL,
    allowed_start_window interval NOT NULL,
    duration interval NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT chk_policy_allowed_window_positive CHECK (((allowed_start_window >= '00:00:00'::interval) AND (allowed_start_window <= '05:00:00'::interval))),
    CONSTRAINT chk_policy_duration_reasonable CHECK (((duration > '00:00:00'::interval) AND (duration <= '24:00:00'::interval)))
);


--
-- TOC entry 262 (class 1259 OID 41407)
-- Name: shift_policy_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.shift_policy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5407 (class 0 OID 0)
-- Dependencies: 262
-- Name: shift_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.shift_policy_id_seq OWNED BY v1.shift_policy.id;


--
-- TOC entry 244 (class 1259 OID 24618)
-- Name: shift_shift_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.shift_shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5408 (class 0 OID 0)
-- Dependencies: 244
-- Name: shift_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.shift_shift_id_seq OWNED BY v1.shift.shift_id;


--
-- TOC entry 265 (class 1259 OID 41440)
-- Name: shift_status_setting; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shift_status_setting (
    id integer NOT NULL,
    status_code v1.shift_status NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ru character varying(100) NOT NULL,
    is_deletable boolean DEFAULT false NOT NULL,
    requires_active_time boolean DEFAULT false NOT NULL,
    allowed_next_status_ids integer[],
    is_active boolean DEFAULT true NOT NULL
);


--
-- TOC entry 5409 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE shift_status_setting; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.shift_status_setting IS 'Metadata dictionary table managing shift lifecycle state behaviors and the finite state machine (FSM) rules.';


--
-- TOC entry 5410 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.id IS 'Surrogate auto-incrementing primary key used for clean foreign key mapping in history logs.';


--
-- TOC entry 5411 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.status_code; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.status_code IS 'Strict domain ENUM token value identifying the state (e.g., ordered, waiting, in-progress, closed, cancelled).';


--
-- TOC entry 5412 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.name_en; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.name_en IS 'Human-readable localized display name in English for API endpoints and frontend rendering.';


--
-- TOC entry 5413 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.name_ru; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.name_ru IS 'Human-readable localized display name in Russian for internal dashboard interfaces.';


--
-- TOC entry 5414 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.is_deletable; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.is_deletable IS 'Security policy flag. If FALSE, prevents hard DELETE operations via database triggers to preserve operational history.';


--
-- TOC entry 5415 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.requires_active_time; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.requires_active_time IS 'Time-compliance validation flag. If TRUE, enforces that the clock timestamp must fall strictly between shift start and end bounds.';


--
-- TOC entry 5416 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN shift_status_setting.allowed_next_status_ids; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shift_status_setting.allowed_next_status_ids IS 'Array of destination shift_status_setting IDs mapping legal forward mutations for declarative state machine validation.';


--
-- TOC entry 264 (class 1259 OID 41439)
-- Name: shift_status_setting_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.shift_status_setting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5417 (class 0 OID 0)
-- Dependencies: 264
-- Name: shift_status_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.shift_status_setting_id_seq OWNED BY v1.shift_status_setting.id;


--
-- TOC entry 219 (class 1259 OID 16436)
-- Name: shipment; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shipment (
    shipment_id integer NOT NULL,
    ship_date date DEFAULT now() NOT NULL,
    ship_total_cost numeric(19,4) NOT NULL,
    provider_id integer NOT NULL,
    shipment_status v1.shipment_status DEFAULT 'ordered'::v1.shipment_status
);


--
-- TOC entry 5418 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN shipment.ship_total_cost; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shipment.ship_total_cost IS 'Итоговая стоимость поставки согласно накладной. Фиксируется на момент приёмки и может отличаться от SUM(batch.total_batch_cost) при частичных поставках.';


--
-- TOC entry 256 (class 1259 OID 32890)
-- Name: shipment_cost_check; Type: VIEW; Schema: v1; Owner: -
--

CREATE VIEW v1.shipment_cost_check AS
 SELECT s.shipment_id,
    s.ship_total_cost AS declared_cost,
    COALESCE(sum(b.total_batch_cost), (0)::numeric) AS computed_cost,
    (s.ship_total_cost - COALESCE(sum(b.total_batch_cost), (0)::numeric)) AS delta
   FROM (v1.shipment s
     LEFT JOIN v1.batch b ON ((b.shipment_id = s.shipment_id)))
  GROUP BY s.shipment_id, s.ship_total_cost;


--
-- TOC entry 5419 (class 0 OID 0)
-- Dependencies: 256
-- Name: VIEW shipment_cost_check; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON VIEW v1.shipment_cost_check IS 'Auditing interface comparing total declared wholesale bills against summed batch items costs';


--
-- TOC entry 218 (class 1259 OID 16435)
-- Name: shipments_shipment_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."shipments_shipment_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5420 (class 0 OID 0)
-- Dependencies: 218
-- Name: shipments_shipment_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."shipments_shipment_ID_seq" OWNED BY v1.shipment.shipment_id;


--
-- TOC entry 223 (class 1259 OID 16465)
-- Name: storage; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.storage (
    storage_id integer NOT NULL,
    stor_address character varying(100) NOT NULL,
    storage_type v1.storage_type
);


--
-- TOC entry 225 (class 1259 OID 16473)
-- Name: storage_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.storage_scoup (
    st_scoup_id integer NOT NULL,
    storage_id integer NOT NULL,
    batch_id integer NOT NULL,
    st_sc_status v1.inventory_item_status NOT NULL,
    st_sc_curr_qty numeric(12,3) NOT NULL
);


--
-- TOC entry 5421 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE storage_scoup; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.storage_scoup IS 'Inventory ledger tracking physical quantities of active supply batches across storage areas';


--
-- TOC entry 5422 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN storage_scoup.st_scoup_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.storage_scoup.st_scoup_id IS 'Unique row transaction ID for the location allocation record';


--
-- TOC entry 5423 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN storage_scoup.storage_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.storage_scoup.storage_id IS 'Foreign key indicating the target storage room or facility';


--
-- TOC entry 5424 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN storage_scoup.batch_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.storage_scoup.batch_id IS 'Foreign key identifying the allocated stock batch tracking source';


--
-- TOC entry 5425 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN storage_scoup.st_sc_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.storage_scoup.st_sc_status IS 'Physical usability state of the localized asset';


--
-- TOC entry 5426 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN storage_scoup.st_sc_curr_qty; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.storage_scoup.st_sc_curr_qty IS 'Current real-time remaining stock volume residing at this location';


--
-- TOC entry 224 (class 1259 OID 16472)
-- Name: storage_scoup_rest_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."storage_scoup_rest_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5427 (class 0 OID 0)
-- Dependencies: 224
-- Name: storage_scoup_rest_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."storage_scoup_rest_ID_seq" OWNED BY v1.storage_scoup.st_scoup_id;


--
-- TOC entry 222 (class 1259 OID 16464)
-- Name: storgage_ store_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."storgage_ store_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5428 (class 0 OID 0)
-- Dependencies: 222
-- Name: storgage_ store_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."storgage_ store_id_seq" OWNED BY v1.storage.storage_id;


--
-- TOC entry 241 (class 1259 OID 24591)
-- Name: table_unit; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.table_unit (
    table_id integer NOT NULL,
    table_code integer NOT NULL,
    capacity integer NOT NULL
);


--
-- TOC entry 5429 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN table_unit.table_code; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.table_unit.table_code IS 'реальный номер стола в зале ';


--
-- TOC entry 240 (class 1259 OID 24590)
-- Name: table_unit_table_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.table_unit_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5430 (class 0 OID 0)
-- Dependencies: 240
-- Name: table_unit_table_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.table_unit_table_id_seq OWNED BY v1.table_unit.table_id;


--
-- TOC entry 231 (class 1259 OID 16500)
-- Name: worker; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.worker (
    worker_id integer NOT NULL,
    full_name character varying(200) NOT NULL,
    timesheet_num integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    position_id integer NOT NULL,
    phone character varying(15) NOT NULL,
    email character varying NOT NULL,
    salary numeric(19,4) NOT NULL
);


--
-- TOC entry 5431 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE worker; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.worker IS 'Comprehensive register of active and historical restaurant personnel profiles';


--
-- TOC entry 5432 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.worker_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.worker_id IS 'Unique internal identifier for the staff member';


--
-- TOC entry 5433 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.full_name; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.full_name IS 'Complete name of the employee';


--
-- TOC entry 5434 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.timesheet_num; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.timesheet_num IS 'Unique payroll and shift roster timesheet code';


--
-- TOC entry 5435 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.is_active; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.is_active IS 'Boolean flag determining if the worker is presently active or on leave/terminated';


--
-- TOC entry 5436 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.position_id; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.position_id IS 'Foreign key indicating the current primary job description role';


--
-- TOC entry 5437 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.phone; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.phone IS 'Primary contact telephone number';


--
-- TOC entry 5438 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.email; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.email IS 'Official contact email address';


--
-- TOC entry 5439 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN worker.salary; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.salary IS 'Current basic financial remuneration rate';


--
-- TOC entry 255 (class 1259 OID 32844)
-- Name: worker_shift; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.worker_shift (
    ws_id integer NOT NULL,
    worker_id integer NOT NULL,
    shift_id integer NOT NULL,
    checked_in boolean DEFAULT false NOT NULL,
    position_in_shift integer
);


--
-- TOC entry 5440 (class 0 OID 0)
-- Dependencies: 255
-- Name: COLUMN worker_shift.checked_in; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker_shift.checked_in IS 'Факт явки на смену. FALSE = назначен, но ещё не отметился (или не пришёл).';


--
-- TOC entry 259 (class 1259 OID 41075)
-- Name: vw_chef_dishes_per_date; Type: VIEW; Schema: v1; Owner: -
--

CREATE VIEW v1.vw_chef_dishes_per_date AS
 SELECT (o.created_at)::date AS cook_date,
    w.worker_id AS chef_id,
    w.full_name AS chef_name,
    d.dish_id,
    d.dish_name,
    sum(os.dish_count) AS portions_cooked,
    count(DISTINCT os.order_id) AS orders_count
   FROM ((((v1.order_scoup os
     JOIN v1."order" o ON ((o.order_id = os.order_id)))
     JOIN v1.worker_shift ws ON ((ws.ws_id = os.ws_id)))
     JOIN v1.worker w ON ((w.worker_id = ws.worker_id)))
     JOIN v1.dish d ON ((d.dish_id = os.dish_id)))
  WHERE (os.status = ANY (ARRAY['ready'::v1.order_item_status, 'served'::v1.order_item_status]))
  GROUP BY ((o.created_at)::date), w.worker_id, w.full_name, d.dish_id, d.dish_name;


--
-- TOC entry 5441 (class 0 OID 0)
-- Dependencies: 259
-- Name: VIEW vw_chef_dishes_per_date; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON VIEW v1.vw_chef_dishes_per_date IS 'Performance metrics tracker aggregating daily dish preparation volumes completed per kitchen worker';


--
-- TOC entry 254 (class 1259 OID 32843)
-- Name: worker_shift_ws_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.worker_shift_ws_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5442 (class 0 OID 0)
-- Dependencies: 254
-- Name: worker_shift_ws_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.worker_shift_ws_id_seq OWNED BY v1.worker_shift.ws_id;


--
-- TOC entry 230 (class 1259 OID 16499)
-- Name: worker_worker_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."worker_worker_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5443 (class 0 OID 0)
-- Dependencies: 230
-- Name: worker_worker_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."worker_worker_ID_seq" OWNED BY v1.worker.worker_id;


--
-- TOC entry 4990 (class 2604 OID 41359)
-- Name: audit_logs id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.audit_logs ALTER COLUMN id SET DEFAULT nextval('v1.audit_logs_id_seq'::regclass);


--
-- TOC entry 4959 (class 2604 OID 16456)
-- Name: batch batch_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch ALTER COLUMN batch_id SET DEFAULT nextval('v1.delivery_scoup_batch_num_seq'::regclass);


--
-- TOC entry 4973 (class 2604 OID 16556)
-- Name: career_log note_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log ALTER COLUMN note_id SET DEFAULT nextval('v1.career_log_note_id_seq'::regclass);


--
-- TOC entry 4968 (class 2604 OID 16523)
-- Name: category category_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category ALTER COLUMN category_id SET DEFAULT nextval('v1.category_id_seq'::regclass);


--
-- TOC entry 4963 (class 2604 OID 16487)
-- Name: dish dish_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish ALTER COLUMN dish_id SET DEFAULT nextval('v1.dish_dish_code_seq'::regclass);


--
-- TOC entry 4985 (class 2604 OID 32818)
-- Name: dish_category category_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_category ALTER COLUMN category_id SET DEFAULT nextval('v1.dish_category_category_id_seq'::regclass);


--
-- TOC entry 4965 (class 2604 OID 16496)
-- Name: dish_scoup dish_sc_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup ALTER COLUMN dish_sc_id SET DEFAULT nextval('v1."dish_scoup_volume_ID_seq"'::regclass);


--
-- TOC entry 4981 (class 2604 OID 24664)
-- Name: ingredient ingredient_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient ALTER COLUMN ingredient_id SET DEFAULT nextval('v1.ingredient_ingredient_id_seq'::regclass);


--
-- TOC entry 4988 (class 2604 OID 32933)
-- Name: med_book med_book_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.med_book ALTER COLUMN med_book_id SET DEFAULT nextval('v1.med_book_med_book_id_seq'::regclass);


--
-- TOC entry 4976 (class 2604 OID 24602)
-- Name: order order_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order" ALTER COLUMN order_id SET DEFAULT nextval('v1.order_order_id_seq'::regclass);


--
-- TOC entry 4982 (class 2604 OID 24687)
-- Name: order_scoup order_sc_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup ALTER COLUMN order_sc_id SET DEFAULT nextval('v1.order_scoup_order_sc_id_seq'::regclass);


--
-- TOC entry 4971 (class 2604 OID 16546)
-- Name: passport passport_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport ALTER COLUMN passport_id SET DEFAULT nextval('v1.passport_passport_id_seq'::regclass);


--
-- TOC entry 4979 (class 2604 OID 24631)
-- Name: pinned_table pinning_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table ALTER COLUMN pinning_id SET DEFAULT nextval('v1.pinned_table_pinning_id_seq'::regclass);


--
-- TOC entry 4970 (class 2604 OID 16531)
-- Name: position position_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position" ALTER COLUMN position_id SET DEFAULT nextval('v1.position_position_id_seq'::regclass);


--
-- TOC entry 4978 (class 2604 OID 24622)
-- Name: shift shift_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift ALTER COLUMN shift_id SET DEFAULT nextval('v1.shift_shift_id_seq'::regclass);


--
-- TOC entry 4993 (class 2604 OID 41411)
-- Name: shift_policy id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift_policy ALTER COLUMN id SET DEFAULT nextval('v1.shift_policy_id_seq'::regclass);


--
-- TOC entry 4995 (class 2604 OID 41443)
-- Name: shift_status_setting id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift_status_setting ALTER COLUMN id SET DEFAULT nextval('v1.shift_status_setting_id_seq'::regclass);


--
-- TOC entry 4956 (class 2604 OID 16439)
-- Name: shipment shipment_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment ALTER COLUMN shipment_id SET DEFAULT nextval('v1."shipments_shipment_ID_seq"'::regclass);


--
-- TOC entry 4961 (class 2604 OID 16468)
-- Name: storage storage_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage ALTER COLUMN storage_id SET DEFAULT nextval('v1."storgage_ store_id_seq"'::regclass);


--
-- TOC entry 4962 (class 2604 OID 16476)
-- Name: storage_scoup st_scoup_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup ALTER COLUMN st_scoup_id SET DEFAULT nextval('v1."storage_scoup_rest_ID_seq"'::regclass);


--
-- TOC entry 4975 (class 2604 OID 24594)
-- Name: table_unit table_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.table_unit ALTER COLUMN table_id SET DEFAULT nextval('v1.table_unit_table_id_seq'::regclass);


--
-- TOC entry 4966 (class 2604 OID 16503)
-- Name: worker worker_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker ALTER COLUMN worker_id SET DEFAULT nextval('v1."worker_worker_ID_seq"'::regclass);


--
-- TOC entry 4986 (class 2604 OID 32847)
-- Name: worker_shift ws_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift ALTER COLUMN ws_id SET DEFAULT nextval('v1.worker_shift_ws_id_seq'::regclass);


--
-- TOC entry 5092 (class 2606 OID 41365)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5055 (class 2606 OID 16558)
-- Name: career_log career_log_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log
    ADD CONSTRAINT career_log_pkey PRIMARY KEY (note_id);


--
-- TOC entry 5017 (class 2606 OID 16424)
-- Name: provider check_id_unique; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.provider
    ADD CONSTRAINT check_id_unique PRIMARY KEY (provider_id);


--
-- TOC entry 5011 (class 2606 OID 24801)
-- Name: ingredient chk_ingr_min_qty ; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.ingredient
    ADD CONSTRAINT "chk_ingr_min_qty " CHECK ((ingr_min_qty > (0)::numeric)) NOT VALID;


--
-- TOC entry 5000 (class 2606 OID 24818)
-- Name: batch chk_ingr_vol; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.batch
    ADD CONSTRAINT chk_ingr_vol CHECK ((ingr_unit_vol > (0)::numeric)) NOT VALID;


--
-- TOC entry 5002 (class 2606 OID 34209)
-- Name: dish_scoup chk_ingr_vol; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.dish_scoup
    ADD CONSTRAINT chk_ingr_vol CHECK ((ingr_vol > (0)::numeric)) NOT VALID;


--
-- TOC entry 5467 (class 0 OID 0)
-- Dependencies: 5002
-- Name: CONSTRAINT chk_ingr_vol ON dish_scoup; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON CONSTRAINT chk_ingr_vol ON v1.dish_scoup IS 'checking the positive value of the ingredient volume in the dish';


--
-- TOC entry 5001 (class 2606 OID 24822)
-- Name: storage_scoup chk_st_sc_curr_qty; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.storage_scoup
    ADD CONSTRAINT chk_st_sc_curr_qty CHECK ((st_sc_curr_qty >= (0)::numeric)) NOT VALID;


--
-- TOC entry 5003 (class 2606 OID 24748)
-- Name: worker chk_worker_email; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.worker
    ADD CONSTRAINT chk_worker_email CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)) NOT VALID;


--
-- TOC entry 5004 (class 2606 OID 24747)
-- Name: worker chk_worker_phone; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.worker
    ADD CONSTRAINT chk_worker_phone CHECK (((phone)::text ~ '^\+?[0-9]{10,15}$'::text)) NOT VALID;


--
-- TOC entry 5077 (class 2606 OID 32823)
-- Name: dish_category dish_category_category_name_key; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_category
    ADD CONSTRAINT dish_category_category_name_key UNIQUE (category_name);


--
-- TOC entry 5079 (class 2606 OID 32821)
-- Name: dish_category dish_category_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_category
    ADD CONSTRAINT dish_category_pkey PRIMARY KEY (category_id);


--
-- TOC entry 5067 (class 2606 OID 24634)
-- Name: pinned_table pinned_table_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT pinned_table_pkey PRIMARY KEY (pinning_id);


--
-- TOC entry 5024 (class 2606 OID 16458)
-- Name: batch pk_batch; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch
    ADD CONSTRAINT pk_batch PRIMARY KEY (batch_id);


--
-- TOC entry 5043 (class 2606 OID 16526)
-- Name: category pk_category; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category
    ADD CONSTRAINT pk_category PRIMARY KEY (category_id);


--
-- TOC entry 5032 (class 2606 OID 16491)
-- Name: dish pk_dish; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish
    ADD CONSTRAINT pk_dish PRIMARY KEY (dish_id);


--
-- TOC entry 5034 (class 2606 OID 16498)
-- Name: dish_scoup pk_dish_scoup; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup
    ADD CONSTRAINT pk_dish_scoup PRIMARY KEY (dish_sc_id);


--
-- TOC entry 5069 (class 2606 OID 24668)
-- Name: ingredient pk_ingredient; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient
    ADD CONSTRAINT pk_ingredient PRIMARY KEY (ingredient_id);


--
-- TOC entry 5089 (class 2606 OID 32939)
-- Name: med_book pk_med_book; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.med_book
    ADD CONSTRAINT pk_med_book PRIMARY KEY (med_book_id);


--
-- TOC entry 5060 (class 2606 OID 24606)
-- Name: order pk_order; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order"
    ADD CONSTRAINT pk_order PRIMARY KEY (order_id);


--
-- TOC entry 5075 (class 2606 OID 24689)
-- Name: order_scoup pk_order_scoup; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT pk_order_scoup PRIMARY KEY (order_sc_id);


--
-- TOC entry 5052 (class 2606 OID 24850)
-- Name: passport pk_passport; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport
    ADD CONSTRAINT pk_passport PRIMARY KEY (passport_id);


--
-- TOC entry 5048 (class 2606 OID 16535)
-- Name: position pk_position; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position"
    ADD CONSTRAINT pk_position PRIMARY KEY (position_id);


--
-- TOC entry 5063 (class 2606 OID 24626)
-- Name: shift pk_shift; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift
    ADD CONSTRAINT pk_shift PRIMARY KEY (shift_id);


--
-- TOC entry 5020 (class 2606 OID 16443)
-- Name: shipment pk_shipment; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment
    ADD CONSTRAINT pk_shipment PRIMARY KEY (shipment_id);


--
-- TOC entry 5026 (class 2606 OID 16471)
-- Name: storage pk_storage; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage
    ADD CONSTRAINT pk_storage PRIMARY KEY (storage_id);


--
-- TOC entry 5028 (class 2606 OID 16482)
-- Name: storage_scoup pk_storage_scoup; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT pk_storage_scoup PRIMARY KEY (st_scoup_id);


--
-- TOC entry 5057 (class 2606 OID 24597)
-- Name: table_unit pk_table_unit; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.table_unit
    ADD CONSTRAINT pk_table_unit PRIMARY KEY (table_id);


--
-- TOC entry 5094 (class 2606 OID 41415)
-- Name: shift_policy shift_policy_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift_policy
    ADD CONSTRAINT shift_policy_pkey PRIMARY KEY (id);


--
-- TOC entry 5096 (class 2606 OID 41426)
-- Name: shift_policy shift_policy_shift_type_code_key; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift_policy
    ADD CONSTRAINT shift_policy_shift_type_code_key UNIQUE (type_code);


--
-- TOC entry 5098 (class 2606 OID 41449)
-- Name: shift_status_setting shift_status_setting_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift_status_setting
    ADD CONSTRAINT shift_status_setting_pkey PRIMARY KEY (id);


--
-- TOC entry 5022 (class 2606 OID 16445)
-- Name: shipment shipments_shipment_ID_shipment_ID1_key; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment
    ADD CONSTRAINT "shipments_shipment_ID_shipment_ID1_key" UNIQUE (shipment_id) INCLUDE (shipment_id);


--
-- TOC entry 5030 (class 2606 OID 24820)
-- Name: storage_scoup uq_batch_in_storage; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT uq_batch_in_storage UNIQUE (batch_id, storage_id);


--
-- TOC entry 5045 (class 2606 OID 41549)
-- Name: category uq_category_code; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category
    ADD CONSTRAINT uq_category_code UNIQUE (category_code);


--
-- TOC entry 5037 (class 2606 OID 24842)
-- Name: worker uq_email_and_phone; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT uq_email_and_phone UNIQUE (phone, email);


--
-- TOC entry 5071 (class 2606 OID 24825)
-- Name: ingredient uq_ingr_name; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient
    ADD CONSTRAINT uq_ingr_name UNIQUE (ingr_name);


--
-- TOC entry 5050 (class 2606 OID 41547)
-- Name: position uq_position_code; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position"
    ADD CONSTRAINT uq_position_code UNIQUE (position_code);


--
-- TOC entry 5039 (class 2606 OID 16508)
-- Name: worker uq_timesheet_num; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT uq_timesheet_num UNIQUE (timesheet_num);


--
-- TOC entry 5468 (class 0 OID 0)
-- Dependencies: 5039
-- Name: CONSTRAINT uq_timesheet_num ON worker; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON CONSTRAINT uq_timesheet_num ON v1.worker IS 'checking for the uniqueness of the service number';


--
-- TOC entry 5083 (class 2606 OID 32852)
-- Name: worker_shift uq_worker_per_shift; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift
    ADD CONSTRAINT uq_worker_per_shift UNIQUE (worker_id, shift_id);


--
-- TOC entry 5041 (class 2606 OID 16506)
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (worker_id);


--
-- TOC entry 5085 (class 2606 OID 32850)
-- Name: worker_shift worker_shift_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift
    ADD CONSTRAINT worker_shift_pkey PRIMARY KEY (ws_id);


--
-- TOC entry 5018 (class 1259 OID 16451)
-- Name: fki_provider_ID; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX "fki_provider_ID" ON v1.shipment USING btree (provider_id);


--
-- TOC entry 5086 (class 1259 OID 32946)
-- Name: idx_med_book_expires; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_med_book_expires ON v1.med_book USING btree (expires_date);


--
-- TOC entry 5087 (class 1259 OID 32945)
-- Name: idx_med_book_worker; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_med_book_worker ON v1.med_book USING btree (worker_id);


--
-- TOC entry 5058 (class 1259 OID 41067)
-- Name: idx_o_pinning_id; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_o_pinning_id ON v1."order" USING btree (pinning_id) WHERE (order_status = 'closed'::v1.order_status);


--
-- TOC entry 5072 (class 1259 OID 41066)
-- Name: idx_os_dish_id; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_os_dish_id ON v1.order_scoup USING btree (dish_id) WHERE (status = 'served'::v1.order_item_status);


--
-- TOC entry 5073 (class 1259 OID 41065)
-- Name: idx_os_order_id; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_os_order_id ON v1.order_scoup USING btree (order_id);


--
-- TOC entry 5046 (class 1259 OID 41241)
-- Name: idx_pos_rank_lvl; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_pos_rank_lvl ON v1."position" USING btree (rank_level);


--
-- TOC entry 5064 (class 1259 OID 41073)
-- Name: idx_pt_pinning_status; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_pt_pinning_status ON v1.pinned_table USING btree (pinning_status);


--
-- TOC entry 5065 (class 1259 OID 41064)
-- Name: idx_pt_ws_id; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_pt_ws_id ON v1.pinned_table USING btree (ws_id) WHERE (pinning_status = 'serviced'::v1.pinning_status);


--
-- TOC entry 5061 (class 1259 OID 41068)
-- Name: idx_s_shift_start; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_s_shift_start ON v1.shift USING btree (shift_start);


--
-- TOC entry 5035 (class 1259 OID 41071)
-- Name: idx_w_full_name; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_w_full_name ON v1.worker USING btree (full_name) WHERE (is_active = true);


--
-- TOC entry 5080 (class 1259 OID 41070)
-- Name: idx_ws_shift_id; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_ws_shift_id ON v1.worker_shift USING btree (shift_id);


--
-- TOC entry 5081 (class 1259 OID 41069)
-- Name: idx_ws_worker_id; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX idx_ws_worker_id ON v1.worker_shift USING btree (worker_id);


--
-- TOC entry 5099 (class 1259 OID 41459)
-- Name: uidx_active_shift_status_code; Type: INDEX; Schema: v1; Owner: -
--

CREATE UNIQUE INDEX uidx_active_shift_status_code ON v1.shift_status_setting USING btree (status_code) WHERE (is_active = true);


--
-- TOC entry 5090 (class 1259 OID 41336)
-- Name: uq_med_book_single_active; Type: INDEX; Schema: v1; Owner: -
--

CREATE UNIQUE INDEX uq_med_book_single_active ON v1.med_book USING btree (worker_id) WHERE (is_active = true);


--
-- TOC entry 5053 (class 1259 OID 41337)
-- Name: uq_passport_single_active; Type: INDEX; Schema: v1; Owner: -
--

CREATE UNIQUE INDEX uq_passport_single_active ON v1.passport USING btree (worker_id) WHERE (is_active = true);


--
-- TOC entry 5124 (class 2620 OID 41555)
-- Name: position trg_audit_position; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_audit_position AFTER INSERT OR DELETE OR UPDATE ON v1."position" FOR EACH ROW EXECUTE FUNCTION v1.trg_generic_audit();


--
-- TOC entry 5123 (class 2620 OID 41465)
-- Name: category trg_category_check; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_category_check BEFORE INSERT OR DELETE OR UPDATE ON v1.category FOR EACH ROW EXECUTE FUNCTION v1.trg_category();


--
-- TOC entry 5129 (class 2620 OID 41309)
-- Name: med_book trg_med_book_check; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_med_book_check BEFORE INSERT OR DELETE OR UPDATE ON v1.med_book FOR EACH ROW EXECUTE FUNCTION v1.trg_med_book();


--
-- TOC entry 5127 (class 2620 OID 41354)
-- Name: passport trg_passport_clean_and_check; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_passport_clean_and_check BEFORE INSERT OR DELETE OR UPDATE ON v1.passport FOR EACH ROW EXECUTE FUNCTION v1.trg_passport();


--
-- TOC entry 5125 (class 2620 OID 41553)
-- Name: position trg_position_before_delete; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_position_before_delete BEFORE DELETE ON v1."position" FOR EACH ROW EXECUTE FUNCTION v1.trg_position_delete_check();


--
-- TOC entry 5126 (class 2620 OID 41543)
-- Name: position trg_position_before_save; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_position_before_save BEFORE INSERT OR UPDATE ON v1."position" FOR EACH ROW EXECUTE FUNCTION v1.trg_position_hierarchy_check();


--
-- TOC entry 5128 (class 2620 OID 41461)
-- Name: shift trg_shift_check; Type: TRIGGER; Schema: v1; Owner: -
--

CREATE TRIGGER trg_shift_check BEFORE INSERT OR DELETE OR UPDATE ON v1.shift FOR EACH ROW EXECUTE FUNCTION v1.trg_shift();


--
-- TOC entry 5103 (class 2606 OID 24771)
-- Name: storage_scoup fk_batch; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT fk_batch FOREIGN KEY (batch_id) REFERENCES v1.batch(batch_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 5109 (class 2606 OID 24756)
-- Name: position fk_category; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position"
    ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES v1.category(category_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 5106 (class 2606 OID 24655)
-- Name: dish_scoup fk_dish; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup
    ADD CONSTRAINT fk_dish FOREIGN KEY (dish_id) REFERENCES v1.dish(dish_id) NOT VALID;


--
-- TOC entry 5117 (class 2606 OID 24695)
-- Name: order_scoup fk_dish; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT fk_dish FOREIGN KEY (dish_id) REFERENCES v1.dish(dish_id);


--
-- TOC entry 5105 (class 2606 OID 32824)
-- Name: dish fk_dish_category; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish
    ADD CONSTRAINT fk_dish_category FOREIGN KEY (category_id) REFERENCES v1.dish_category(category_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 5101 (class 2606 OID 24712)
-- Name: batch fk_ingr; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch
    ADD CONSTRAINT fk_ingr FOREIGN KEY (ingr_id) REFERENCES v1.ingredient(ingredient_id) NOT VALID;


--
-- TOC entry 5107 (class 2606 OID 24677)
-- Name: dish_scoup fk_ingredient; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup
    ADD CONSTRAINT fk_ingredient FOREIGN KEY (ingr_id) REFERENCES v1.ingredient(ingredient_id) NOT VALID;


--
-- TOC entry 5122 (class 2606 OID 32940)
-- Name: med_book fk_med_book_worker; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.med_book
    ADD CONSTRAINT fk_med_book_worker FOREIGN KEY (worker_id) REFERENCES v1.worker(worker_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5118 (class 2606 OID 24700)
-- Name: order_scoup fk_order; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES v1."order"(order_id);


--
-- TOC entry 5112 (class 2606 OID 24650)
-- Name: order fk_order_table; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order"
    ADD CONSTRAINT fk_order_table FOREIGN KEY (pinning_id) REFERENCES v1.pinned_table(pinning_id) NOT VALID;


--
-- TOC entry 5469 (class 0 OID 0)
-- Dependencies: 5112
-- Name: CONSTRAINT fk_order_table ON "order"; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON CONSTRAINT fk_order_table ON v1."order" IS 'table which pinned by the waiter ';


--
-- TOC entry 5108 (class 2606 OID 24742)
-- Name: worker fk_position; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES v1."position"(position_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 5100 (class 2606 OID 24761)
-- Name: shipment fk_provider; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment
    ADD CONSTRAINT fk_provider FOREIGN KEY (provider_id) REFERENCES v1.provider(provider_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 5113 (class 2606 OID 41434)
-- Name: shift fk_shift_policy; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift
    ADD CONSTRAINT fk_shift_policy FOREIGN KEY (type_id) REFERENCES v1.shift_policy(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5114 (class 2606 OID 41452)
-- Name: shift fk_shift_status_setting; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift
    ADD CONSTRAINT fk_shift_status_setting FOREIGN KEY (status_id) REFERENCES v1.shift_status_setting(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5102 (class 2606 OID 24766)
-- Name: batch fk_shipment; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch
    ADD CONSTRAINT fk_shipment FOREIGN KEY (shipment_id) REFERENCES v1.shipment(shipment_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 5104 (class 2606 OID 24776)
-- Name: storage_scoup fk_storage; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT fk_storage FOREIGN KEY (storage_id) REFERENCES v1.storage(storage_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 5115 (class 2606 OID 24645)
-- Name: pinned_table fk_table; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT fk_table FOREIGN KEY (table_id) REFERENCES v1.table_unit(table_id) NOT VALID;


--
-- TOC entry 5111 (class 2606 OID 32880)
-- Name: career_log fk_worker; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log
    ADD CONSTRAINT fk_worker FOREIGN KEY (worker_id) REFERENCES v1.worker(worker_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5110 (class 2606 OID 16547)
-- Name: passport fk_worker; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport
    ADD CONSTRAINT fk_worker FOREIGN KEY (worker_id) REFERENCES v1.worker(worker_id);


--
-- TOC entry 5116 (class 2606 OID 40994)
-- Name: pinned_table fk_worker_shift; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT fk_worker_shift FOREIGN KEY (ws_id) REFERENCES v1.worker_shift(ws_id);


--
-- TOC entry 5119 (class 2606 OID 33485)
-- Name: worker_shift fk_ws_position_in_shift; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift
    ADD CONSTRAINT fk_ws_position_in_shift FOREIGN KEY (position_in_shift) REFERENCES v1."position"(position_id) NOT VALID;


--
-- TOC entry 5120 (class 2606 OID 32858)
-- Name: worker_shift fk_ws_shift; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift
    ADD CONSTRAINT fk_ws_shift FOREIGN KEY (shift_id) REFERENCES v1.shift(shift_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5121 (class 2606 OID 32853)
-- Name: worker_shift fk_ws_worker; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift
    ADD CONSTRAINT fk_ws_worker FOREIGN KEY (worker_id) REFERENCES v1.worker(worker_id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2026-05-20 04:42:17

--
-- PostgreSQL database dump complete
--

\unrestrict uAfJ3rmOr9XPX7dPj8fJqTQ61RnhchMnkSo91dLHHIZZKM8dQjpNBKxcL59j5Ip

