-----------------------------------------------------------------------------
1 - Для вывода данных о пассажирах, которые заказывали такси в заданном, как параметр, временном интервале.
-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION passenger_data_by_date1(start_date DATE, end_date DATE)
RETURNS TABLE (
    passenger_id INT,
    full_name VARCHAR,
    phone VARCHAR,
    rating INT 
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        p.passenger_id, 
        p.full_name, 
        p.phone, 
        p.rating           
    FROM "Taxi".passenger p
    JOIN "Taxi"."order" o ON p.passenger_id = o.passenger_id 
    WHERE o.date BETWEEN start_date AND end_date;
END;
$$;

select passenger_data_by_date1('2024-10-05','2024-10-10');

DROP FUNCTION IF EXISTS passenger_data_by_date1(DATE, DATE);
----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE passenger_data_by_date(start_date DATE, end_date DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT 
            p.passenger_id, 
            p.full_name, 
            p.phone, 
            p.rating 
        FROM "Taxi".passenger p
        JOIN "Taxi"."order" o ON p.passenger_id = o.passenger_id
        WHERE o.date BETWEEN start_date AND end_date
        GROUP BY p.passenger_id, p.full_name, p.phone, p.rating
    LOOP
        RAISE NOTICE 'ID: %, Name: %, Phone: %, Rating: %', 
                     rec.passenger_id, 
                     rec.full_name, 
                     rec.phone, 
                     rec.rating;
    END LOOP;
END;
$$;

call passenger_data_by_date('2024-10-05','2024-10-10');

DROP PROCEDURE IF EXISTS passenger_data_by_date(DATE, DATE);
-----------------------------------------------------------------
2 - Вывести сведения о том, куда был доставлен пассажир по заданному номеру телефона пассажира
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION destination_by_number(phone_number VARCHAR(12))
RETURNS TABLE (
    full_name VARCHAR,
    street VARCHAR,
    building INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.full_name,
        da.street,
        da.building 
    FROM "Taxi".passenger p
    JOIN "Taxi"."order" o ON p.passenger_id = o.passenger_id
    JOIN "Taxi".destination_address da ON o.order_id = da.order_id
    WHERE p.phone = phone_number
    ORDER BY o.date DESC;
END;
$$;

select destination_by_number('+79161112233');

DROP FUNCTION IF EXISTS destination_by_number(VARCHAR);
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE destination_by_number2(phone_number VARCHAR(12))
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    RAISE NOTICE 'Адреса доставки для пассажира с номером %:', phone_number;
    RAISE NOTICE '------------------------------------------------';
    
    FOR rec IN 
        SELECT 
            p.full_name,
            da.street,
            da.building
        FROM "Taxi".passenger p
        JOIN "Taxi"."order" o ON p.passenger_id = o.passenger_id
        JOIN "Taxi".destination_address da ON o.order_id = da.order_id
        WHERE p.phone = phone_number
        ORDER BY o.date DESC
    LOOP
        RAISE NOTICE 'Пассажир: %, Улица: %, Дом: %',  
                     rec.full_name, 
                     rec.street,
                     rec.building;
    END LOOP;
END;
$$;

call destination_by_number2('+79161112233');

DROP PROCEDURE IF EXISTS destination_by_number2(VARCHAR);
-----------------------------------------------------------------------
3 - Для вычисления суммарного дохода таксопарка за истекший месяц. 
-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION total_sum_last_month()
RETURNS TABLE (
    month_year TEXT,
    total BIGINT,
    orders_count BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
BEGIN
    last_month_start := DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')::DATE;
    last_month_end := (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 day')::DATE;
    
    RETURN QUERY
    SELECT 
        to_char(last_month_start, 'MM YYYY') AS month_year,
        COALESCE(SUM(o.cost), 0)::BIGINT AS total,
        COUNT(o.order_id)::BIGINT AS orders_count
    FROM "Taxi"."order" o
    WHERE o.date BETWEEN last_month_start AND last_month_end;
END;
$$;

select total_sum_last_month();

DROP FUNCTION IF EXISTS total_sum_last_month();
------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE total_sum_last_month2()
LANGUAGE plpgsql
AS $$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
    total_income BIGINT;
    orders_count BIGINT;
BEGIN
    last_month_start := (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month')::DATE;
    last_month_end := (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 day')::DATE;
    
    SELECT 
        COALESCE(SUM(o.cost), 0),
        COUNT(o.order_id)
    INTO total_income, orders_count
    FROM "Taxi"."order" o
    WHERE o.date BETWEEN last_month_start AND last_month_end;
    
    RAISE NOTICE '---------------------------------------------';
    RAISE NOTICE 'ОТЧЕТ О ДОХОДАХ ТАКСОПАРКА';
    RAISE NOTICE '-----------------------------------------------';
    RAISE NOTICE 'Период: % - %', last_month_start, last_month_end;
    RAISE NOTICE '--------------------------------------------------';
    RAISE NOTICE 'Суммарный доход: % руб.', total_income;
    RAISE NOTICE 'Количество заказов: %', orders_count;
    RAISE NOTICE '---------------------------------------------';
END;
$$;

call total_sum_last_month2();

DROP PROCEDURE IF EXISTS total_sum_last_month2();
---------------------------------------------------------
Тригеры
-------------------------------------
1 - Автоформат телефона
-------------------------------------------------------
CREATE OR REPLACE FUNCTION fmt_phone()
RETURNS TRIGGER AS $$
DECLARE
    digits_only TEXT;
BEGIN
    digits_only := regexp_replace(NEW.phone, '[^0-9]', '', 'g');
    NEW.phone := '+7' || RIGHT(digits_only, 10);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_fmt_phone
    BEFORE INSERT OR UPDATE ON "Taxi".passenger
    FOR EACH ROW EXECUTE FUNCTION fmt_phone();

DROP TRIGGER IF EXISTS trg_fmt_phone ON "Taxi".passenger;
DROP FUNCTION IF EXISTS fmt_phone();
---------------------------------------------------
2 - Автоматически рассчитывает стоимость заказа
-------------------------------------------------------
CREATE OR REPLACE FUNCTION calc_cost()
RETURNS TRIGGER AS $$
DECLARE
    price INTEGER;
BEGIN
    SELECT price_per_km INTO price FROM "Taxi".tariff WHERE tariff_id = NEW.tariff_id;
    NEW.cost := NEW.distance * price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calc_cost
    BEFORE INSERT ON "Taxi"."order"
    FOR EACH ROW EXECUTE FUNCTION calc_cost();

DROP TRIGGER IF EXISTS trg_calc_cost ON "Taxi"."order";
DROP FUNCTION IF EXISTS calc_cost();
---------------------------------------------------------
3 - Запрещает удаление водителя, если у него есть активные (незавершённые) заказы
-------------------------------------------------------
CREATE OR REPLACE FUNCTION no_delete_driver()
RETURNS TRIGGER AS $$
DECLARE
    cnt INTEGER;
BEGIN
    SELECT COUNT(*) INTO cnt FROM "Taxi"."order" o
    JOIN "Taxi".work_shedule ws ON o.schedule_id = ws.schedule_id
    JOIN "Taxi".employment_contract ec ON ws.contract_id = ec.contract_id
    JOIN "Taxi".passport_data pd ON pd.series_number = ec.passport_series_number
    WHERE pd.employee_id = OLD.employee_id AND o.status_id != 3;
    
    IF cnt > 0 THEN RAISE EXCEPTION 'У водителя есть активные заказы (%)', cnt;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_no_delete_driver
    BEFORE DELETE ON "Taxi".employee
    FOR EACH ROW EXECUTE FUNCTION no_delete_driver();

DROP TRIGGER IF EXISTS trg_no_delete_driver ON "Taxi".employee;
DROP FUNCTION IF EXISTS no_delete_driver();
---------------------------------------------------
4 - Контроль количества символов в отзыве
-------------------------------------------------------
CREATE OR REPLACE FUNCTION check_review_length()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.review_text IS NOT NULL AND LENGTH(NEW.review_text) < 10 THEN
        RAISE EXCEPTION 'Отзыв слишком короткий (минимум 10 символов, введено %)', LENGTH(NEW.review_text);
    END IF;
    
    IF NEW.review_text IS NOT NULL AND LENGTH(NEW.review_text) > 500 THEN
        RAISE EXCEPTION 'Отзыв слишком длинный (максимум 500 символов, введено %)', LENGTH(NEW.review_text);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_review_length
    BEFORE INSERT OR UPDATE ON "Taxi".review
    FOR EACH ROW
    EXECUTE FUNCTION check_review_length();

DROP TRIGGER IF EXISTS trg_check_review_length ON "Taxi".review;
DROP FUNCTION IF EXISTS check_review_length();
----------------------------------------------------
5 - Автоматическая установка статуса закончен при заполнении времени высадки
-------------------------------------------------------
CREATE OR REPLACE FUNCTION auto_complete_order()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.dropoff_time IS NOT NULL AND NEW.status_id != 3 THEN
        NEW.status_id := (SELECT status_id FROM "Taxi".order_status WHERE name = 'закончен');
        RAISE NOTICE 'Заказ % автоматически завершён (время высадки: %)', NEW.order_id, NEW.dropoff_time;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_auto_complete_order
    BEFORE INSERT OR UPDATE ON "Taxi"."order"
    FOR EACH ROW
    EXECUTE FUNCTION auto_complete_order();

DROP TRIGGER IF EXISTS trg_auto_complete_order ON "Taxi"."order";
DROP FUNCTION IF EXISTS auto_complete_order();
--------------------------------------------------------
6 - Запрет отзыва без завершённого заказа
---------------------------------------------------------
CREATE OR REPLACE FUNCTION check_review_allowed()
RETURNS TRIGGER AS $$
DECLARE
    order_status_id INTEGER;
BEGIN
    SELECT status_id INTO order_status_id
    FROM "Taxi"."order"
    WHERE order_id = NEW.order_id;
    
    IF order_status_id != (SELECT status_id FROM "Taxi".order_status WHERE name = 'закончен') THEN
        RAISE EXCEPTION 'Нельзя оставить отзыв на незавершённый заказ (статус не "закончен")';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_review_allowed
    BEFORE INSERT ON "Taxi".review
    FOR EACH ROW
    EXECUTE FUNCTION check_review_allowed();

DROP TRIGGER IF EXISTS trg_check_review_allowed ON "Taxi".review;
DROP FUNCTION IF EXISTS check_review_allowed();
------------------------------------------------------------
7 - Автоматически применяет ночной коэффициент к стоимости заказа, если поездка совершается после 22:00
------------------------------------------------------------
CREATE OR REPLACE FUNCTION apply_night_rate()
RETURNS TRIGGER AS $$
DECLARE
    base_price INTEGER;
    night_rate NUMERIC := 1.2; 
BEGIN
    SELECT price_per_km INTO base_price
    FROM "Taxi".tariff
    WHERE tariff_id = NEW.tariff_id;
    
    NEW.cost := NEW.distance * base_price;
    
    IF NEW.planned_pickup_time >= '22:00:00' OR NEW.planned_pickup_time < '07:00:00' THEN
        NEW.cost := NEW.cost * night_rate;
        RAISE NOTICE 'Применён ночной коэффициент %. Стоимость: % руб.', night_rate, NEW.cost;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_apply_night_rate
    BEFORE INSERT ON "Taxi"."order"
    FOR EACH ROW
    EXECUTE FUNCTION apply_night_rate();

DROP TRIGGER IF EXISTS trg_apply_night_rate ON "Taxi"."order";
DROP FUNCTION IF EXISTS apply_night_rate();
------------------------
Проверка
------------------------
-- Триггер 1: Автоформат телефона
INSERT INTO "Taxi".passenger (full_name, phone, rating) VALUES
    ('Тест1_Россия_8', '89261234567', 5),
    ('Тест2_Плюс7', '+79534234567', 5),
    ('Тест3_С_дефисами', '8-926-999-45-67', 5),
    ('Тест4_Со_скобками', '8 (926) 123-99-67', 5);
SELECT * FROM "Taxi".passenger;

-- Триггер 2: Авторасчёт стоимости заказа
INSERT INTO "Taxi"."order" (schedule_id, tariff_id, passenger_id, status_id, distance, planned_pickup_time, date)
VALUES (1, 1, 1, 1, 10, '12:00:00', CURRENT_DATE);
SELECT cost, order_id, date FROM "Taxi"."order" order by order_id;

-- Триггер 3: Запрет удаления водителя с активными заказами
select e.employee_id, pd.full_name, o.status_id from "Taxi".employee e 
    JOIN "Taxi".passport_data pd ON pd.employee_id = e.employee_id
    JOIN "Taxi".employment_contract ec ON pd.series_number = ec.passport_series_number
    JOIN "Taxi".work_shedule ws ON ws.contract_id = ec.contract_id
    JOIN "Taxi".order o ON o.schedule_id = ws.schedule_id
    WHERE o.status_id != 3;
delete from "Taxi".employee where employee_id = 5;

-- Триггер 4: Контроль количества символов в отзыве
INSERT INTO "Taxi".review (order_id, review_text,comment, status, date)
values (2,'Мало', 'Круто', 'опубликован', '2024-10-01');

INSERT INTO "Taxi".review (order_id, review_text,comment, status, date)
values (2,'Нооооооооооооооооооооооооооооооооорм', 'Круто', 'опубликован', '2024-10-01');

-- Триггер 5: Автоматическая установка статуса закончен
INSERT INTO "Taxi"."order" (schedule_id,tariff_id,passenger_id,status_id,cost,distance,planned_pickup_time,pickup_time,dropoff_time,date)
values (5,3,5,2,700,67,'09:15:00','09:18:00','09:55:00','2026-03-02');

-- Триггер 6: Запрет отзыва без завершённого заказа
INSERT INTO "Taxi".review (order_id, review_text,comment, status, date)
values (5,'Не должно быть', 'Круто', 'опубликован', '2024-10-01');

-- Триггер 7: Автоматически применяет ночной коэффициент к стоимости заказа
INSERT INTO "Taxi"."order" (schedule_id,tariff_id,passenger_id,status_id,cost,distance,planned_pickup_time,pickup_time,dropoff_time,date)
values (5,3,5,2,700,67,'23:00:00','23:00:00',NULL,'2026-03-02');

INSERT INTO "Taxi"."order" (schedule_id,tariff_id,passenger_id,status_id,cost,distance,planned_pickup_time,pickup_time,dropoff_time,date)
values (5,3,5,2,700,67,'10:00:00','10:00:00',NULL,'2026-03-02');













---------------------------------------------------
Переделанный триггер
--------------------------------------------------
