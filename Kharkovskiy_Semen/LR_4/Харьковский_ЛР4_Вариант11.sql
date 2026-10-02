-- Лабораторная работа 4. Вариант 11. БД «Автомастерская».
-- Студент: Харьковский Семён, К3341.

SET search_path TO autoservice, public;

INSERT INTO orders
    (order_id, contract_id, car_id, accepted_date, planned_end_date,
     actual_end_date, order_description, reported_faults, status)
VALUES
    (101, 1, 1, CURRENT_DATE - 20, CURRENT_DATE - 18, CURRENT_DATE - 18,
     'Повторная диагностика Toyota', 'Контроль после ремонта', 'выдан'),
    (102, 1, 1, CURRENT_DATE - 10, CURRENT_DATE - 8, CURRENT_DATE - 8,
     'Плановая диагностика Toyota', 'Нестабильный холостой ход', 'выдан'),
    (103, 2, 2, CURRENT_DATE - 25, CURRENT_DATE - 22, CURRENT_DATE - 20,
     'Повторный ремонт тормозов', 'Вибрация при торможении', 'выдан'),
    (104, 2, 2, CURRENT_DATE - 5, CURRENT_DATE - 2, NULL,
     'Диагностика тормозной системы', 'Скрип передних колодок', 'ремонт'),
    (105, 3, 3, CURRENT_DATE - 15, CURRENT_DATE - 12, CURRENT_DATE - 12,
     'Повторная диагностика подвески', 'Проверка после замены втулок', 'выдан'),
    (106, 1, 1, CURRENT_DATE - 45, CURRENT_DATE - 42, CURRENT_DATE - 40,
     'Замена масла Toyota', 'Плановое техническое обслуживание', 'выдан')
ON CONFLICT (order_id) DO UPDATE SET
    contract_id = EXCLUDED.contract_id,
    car_id = EXCLUDED.car_id,
    accepted_date = EXCLUDED.accepted_date,
    planned_end_date = EXCLUDED.planned_end_date,
    actual_end_date = EXCLUDED.actual_end_date,
    order_description = EXCLUDED.order_description,
    reported_faults = EXCLUDED.reported_faults,
    status = EXCLUDED.status;

INSERT INTO order_services
    (order_service_id, order_id, work_type_id, quantity, labor_price, service_status)
VALUES
    (101, 101, 1, 1, 2500.00, 'выполнена'),
    (102, 102, 1, 1, 2500.00, 'выполнена'),
    (103, 103, 2, 1, 4200.00, 'выполнена'),
    (104, 104, 2, 1, 4200.00, 'выполняется'),
    (105, 105, 4, 1, 2200.00, 'выполнена'),
    (106, 106, 3, 1, 1800.00, 'выполнена')
ON CONFLICT (order_service_id) DO UPDATE SET
    order_id = EXCLUDED.order_id,
    work_type_id = EXCLUDED.work_type_id,
    quantity = EXCLUDED.quantity,
    labor_price = EXCLUDED.labor_price,
    service_status = EXCLUDED.service_status;

INSERT INTO work_assignments
    (assignment_id, order_service_id, master_id,
     assigned_by_administrator_id, assigned_at, completed_at, labor_cost)
VALUES
    (101, 101, 2, 1, (CURRENT_DATE - 20) + TIME '10:00', (CURRENT_DATE - 18) + TIME '12:00', 2500.00),
    (102, 102, 2, 1, (CURRENT_DATE - 10) + TIME '10:00', (CURRENT_DATE - 8) + TIME '12:00', 2500.00),
    (103, 103, 3, 1, (CURRENT_DATE - 25) + TIME '10:00', (CURRENT_DATE - 20) + TIME '12:00', 4200.00),
    (104, 104, 3, 1, (CURRENT_DATE - 5) + TIME '10:00', NULL, 4200.00),
    (105, 105, 5, 4, (CURRENT_DATE - 15) + TIME '10:00', (CURRENT_DATE - 12) + TIME '12:00', 2200.00),
    (106, 106, 2, 1, (CURRENT_DATE - 45) + TIME '10:00', (CURRENT_DATE - 40) + TIME '12:00', 1800.00)
ON CONFLICT (assignment_id) DO UPDATE SET
    order_service_id = EXCLUDED.order_service_id,
    master_id = EXCLUDED.master_id,
    assigned_by_administrator_id = EXCLUDED.assigned_by_administrator_id,
    assigned_at = EXCLUDED.assigned_at,
    completed_at = EXCLUDED.completed_at,
    labor_cost = EXCLUDED.labor_cost;

-- ================================================================
-- 1. ЗАПРОСЫ НА ВЫБОРКУ ДАННЫХ
-- ================================================================

-- 1.1. Фамилия мастера, который чаще всего работает с Toyota.
WITH toyota_counts AS (
    SELECT e.employee_id, e.last_name, COUNT(*) AS work_count,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS place_no
    FROM work_assignments wa
    JOIN employees e       ON e.employee_id = wa.master_id
    JOIN order_services os ON os.order_service_id = wa.order_service_id
    JOIN orders o          ON o.order_id = os.order_id
    JOIN cars c            ON c.car_id = o.car_id
    JOIN car_brands b      ON b.brand_id = c.brand_id
    WHERE b.brand_name = 'Toyota'
    GROUP BY e.employee_id, e.last_name
)
SELECT last_name AS "Фамилия мастера", work_count AS "Количество работ"
FROM toyota_counts
WHERE place_no = 1;

-- 1.2. Владельцы, которых по одному виду работ всегда обслуживает один мастер.
SELECT c.last_name AS "Владелец",
       wt.work_type_name AS "Вид работы",
       MIN(e.last_name) AS "Постоянный мастер",
       COUNT(*) AS "Количество обращений"
FROM clients c
JOIN contracts ct       ON ct.client_id = c.client_id
JOIN orders o           ON o.contract_id = ct.contract_id
JOIN order_services os  ON os.order_id = o.order_id
JOIN work_types wt      ON wt.work_type_id = os.work_type_id
JOIN work_assignments wa ON wa.order_service_id = os.order_service_id
JOIN employees e        ON e.employee_id = wa.master_id
GROUP BY c.client_id, c.last_name, wt.work_type_id, wt.work_type_name
HAVING COUNT(*) > 1 AND COUNT(DISTINCT wa.master_id) = 1
ORDER BY c.last_name, wt.work_type_name;

-- 1.3. Мастера, не выполнившие работу в срок, и число дней просрочки.
SELECT DISTINCT e.last_name AS "Фамилия мастера",
       o.order_id AS "Заказ",
       GREATEST(COALESCE(o.actual_end_date, CURRENT_DATE) - o.planned_end_date, 0)
           AS "Дней просрочки"
FROM work_assignments wa
JOIN employees e       ON e.employee_id = wa.master_id
JOIN order_services os ON os.order_service_id = wa.order_service_id
JOIN orders o          ON o.order_id = os.order_id
WHERE COALESCE(o.actual_end_date, CURRENT_DATE) > o.planned_end_date
ORDER BY "Дней просрочки" DESC, "Фамилия мастера";

-- 1.4. Клиенты, чаще всего посещавшие сервис за последний год.
WITH visit_counts AS (
    SELECT c.client_id, c.last_name, c.first_name, COUNT(*) AS visit_count,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS place_no
    FROM clients c
    JOIN contracts ct ON ct.client_id = c.client_id
    JOIN orders o     ON o.contract_id = ct.contract_id
    WHERE o.accepted_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY c.client_id, c.last_name, c.first_name
)
SELECT last_name AS "Фамилия", first_name AS "Имя",
       visit_count AS "Количество посещений"
FROM visit_counts
WHERE place_no = 1;

-- 1.5. Сколько заработал каждый мастер за последний месяц.
-- Согласно представлению master_payments мастеру начисляется 50% стоимости работы.
SELECT e.last_name AS "Фамилия мастера",
       ROUND(SUM(wa.labor_cost * 0.50), 2) AS "Заработано, руб."
FROM work_assignments wa
JOIN employees e       ON e.employee_id = wa.master_id
JOIN order_services os ON os.order_service_id = wa.order_service_id
JOIN orders o          ON o.order_id = os.order_id
WHERE wa.completed_at IS NOT NULL
  AND wa.completed_at::date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY e.employee_id, e.last_name
ORDER BY "Заработано, руб." DESC;

-- 1.6. Владельцы, обращавшиеся за ремонтом более одного раза.
SELECT c.last_name AS "Фамилия", c.first_name AS "Имя",
       COUNT(o.order_id) AS "Количество обращений"
FROM clients c
JOIN contracts ct ON ct.client_id = c.client_id
JOIN orders o     ON o.contract_id = ct.contract_id
GROUP BY c.client_id, c.last_name, c.first_name
HAVING COUNT(o.order_id) > 1
ORDER BY "Количество обращений" DESC, c.last_name;

-- 1.7. Штраф каждого мастера за последний месяц.
-- За день просрочки удерживается 5% от причитающихся мастеру 50% стоимости работы.
SELECT e.last_name AS "Фамилия мастера",
       ROUND(SUM(
           wa.labor_cost * 0.50 * 0.05 *
           GREATEST(COALESCE(o.actual_end_date, CURRENT_DATE) - o.planned_end_date, 0)
       ), 2) AS "Штраф, руб."
FROM work_assignments wa
JOIN employees e       ON e.employee_id = wa.master_id
JOIN order_services os ON os.order_service_id = wa.order_service_id
JOIN orders o          ON o.order_id = os.order_id
WHERE o.accepted_date >= CURRENT_DATE - INTERVAL '1 month'
  AND COALESCE(o.actual_end_date, CURRENT_DATE) > o.planned_end_date
GROUP BY e.employee_id, e.last_name
ORDER BY "Штраф, руб." DESC;

-- ================================================================
-- 2. ПРЕДСТАВЛЕНИЯ
-- ================================================================

-- 2.1. Для клиентов: модель автомобиля, с которой мастер работает чаще всего.
CREATE OR REPLACE VIEW v_master_favorite_car_models AS
WITH model_counts AS (
    SELECT e.employee_id, e.last_name, b.brand_name, c.model_name,
           COUNT(*) AS repair_count,
           DENSE_RANK() OVER (
               PARTITION BY e.employee_id ORDER BY COUNT(*) DESC
           ) AS place_no
    FROM work_assignments wa
    JOIN employees e       ON e.employee_id = wa.master_id
    JOIN order_services os ON os.order_service_id = wa.order_service_id
    JOIN orders o          ON o.order_id = os.order_id
    JOIN cars c            ON c.car_id = o.car_id
    JOIN car_brands b      ON b.brand_id = c.brand_id
    GROUP BY e.employee_id, e.last_name, b.brand_name, c.model_name
)
SELECT employee_id, last_name AS master_last_name,
       brand_name, model_name, repair_count
FROM model_counts
WHERE place_no = 1;

SELECT * FROM v_master_favorite_car_models
ORDER BY master_last_name, brand_name, model_name;

-- 2.2. Для менеджеров: 10% премии мастерам, завершившим все заказы вовремя.
CREATE OR REPLACE VIEW v_punctual_master_bonuses AS
SELECT e.employee_id,
       e.last_name AS master_last_name,
       ROUND(SUM(wa.labor_cost * 0.50), 2) AS salary_for_month,
       ROUND(SUM(wa.labor_cost * 0.50) * 0.10, 2) AS bonus_10_percent
FROM employees e
JOIN work_assignments wa ON wa.master_id = e.employee_id
JOIN order_services os   ON os.order_service_id = wa.order_service_id
JOIN orders o            ON o.order_id = os.order_id
WHERE o.accepted_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY e.employee_id, e.last_name
HAVING BOOL_AND(
    wa.completed_at IS NOT NULL
    AND wa.completed_at::date <= o.planned_end_date
);

SELECT * FROM v_punctual_master_bonuses ORDER BY master_last_name;

-- ================================================================
-- 3. МОДИФИКАЦИЯ ДАННЫХ С ПОДЗАПРОСАМИ
-- ================================================================

-- 3.1. INSERT: добавить отсутствующую дорогую деталь в мастерскую
-- с наименьшим количеством складских позиций.
BEGIN;
SELECT * FROM inventory ORDER BY workshop_id, part_id;

INSERT INTO inventory (workshop_id, part_id, quantity, minimum_stock)
SELECT
    (SELECT w.workshop_id
     FROM workshops w
     LEFT JOIN inventory i ON i.workshop_id = w.workshop_id
     GROUP BY w.workshop_id
     ORDER BY COUNT(i.inventory_id), w.workshop_id
     LIMIT 1),
    (SELECT p.part_id
     FROM parts p
     WHERE NOT EXISTS (
         SELECT 1
         FROM inventory i2
         WHERE i2.part_id = p.part_id
           AND i2.workshop_id = (
               SELECT w2.workshop_id
               FROM workshops w2
               LEFT JOIN inventory i3 ON i3.workshop_id = w2.workshop_id
               GROUP BY w2.workshop_id
               ORDER BY COUNT(i3.inventory_id), w2.workshop_id
               LIMIT 1
           )
     )
     ORDER BY p.unit_price DESC, p.part_id
     LIMIT 1),
    0, 2;

SELECT * FROM inventory ORDER BY workshop_id, part_id;
ROLLBACK;

-- 3.2. UPDATE: увеличить на 7% действующую цену востребованных работ,
-- число заказов которых выше среднего по всем видам работ.
BEGIN;
SELECT work_price_id, work_type_id, labor_price
FROM work_prices WHERE valid_to IS NULL ORDER BY work_type_id;

UPDATE work_prices wp
SET labor_price = ROUND(wp.labor_price * 1.07, 2)
WHERE wp.valid_to IS NULL
  AND wp.work_type_id IN (
      SELECT os.work_type_id
      FROM order_services os
      GROUP BY os.work_type_id
      HAVING COUNT(*) > (
          SELECT AVG(type_count)
          FROM (
              SELECT COUNT(*)::NUMERIC AS type_count
              FROM order_services
              GROUP BY work_type_id
          ) counts_by_type
      )
  );

SELECT work_price_id, work_type_id, labor_price
FROM work_prices WHERE valid_to IS NULL ORDER BY work_type_id;
ROLLBACK;

-- 3.3. DELETE: удалить тестового клиента, если у него нет договоров.
BEGIN;
INSERT INTO clients
    (client_id, last_name, first_name, middle_name, phone, email)
VALUES
    (9001, 'Тестов', 'Временный', NULL, '+7(900)000-90-01', 'temporary9001@example.ru')
ON CONFLICT (client_id) DO UPDATE SET
    last_name = EXCLUDED.last_name,
    first_name = EXCLUDED.first_name,
    phone = EXCLUDED.phone,
    email = EXCLUDED.email;

SELECT * FROM clients WHERE client_id = 9001;

DELETE FROM clients c
WHERE c.client_id = (
    SELECT c2.client_id
    FROM clients c2
    WHERE c2.client_id = 9001
      AND NOT EXISTS (
          SELECT 1 FROM contracts ct WHERE ct.client_id = c2.client_id
      )
);

SELECT * FROM clients WHERE client_id = 9001;
ROLLBACK;

-- ================================================================
-- 4. ИНДЕКСЫ И EXPLAIN ANALYZE
-- ================================================================
-- Нагрузочные строки существуют только внутри транзакции и удаляются ROLLBACK.
-- Запускайте весь раздел целиком. В Messages/Data Output сохраняются реальные
-- Execution Time и выбранные узлы плана для скриншотов отчёта.

BEGIN;

INSERT INTO orders
    (order_id, contract_id, car_id, accepted_date, planned_end_date,
     actual_end_date, order_description, reported_faults, status)
SELECT 1000000 + g, 1, 1,
       CURRENT_DATE - (g % 365),
       CURRENT_DATE - (g % 365) + 2,
       CURRENT_DATE - (g % 365) + 2,
       'LR4 benchmark order ' || g,
       'Нагрузочная строка для анализа плана',
       'выдан'
FROM generate_series(1, 50000) AS g;

INSERT INTO order_services
    (order_service_id, order_id, work_type_id, quantity, labor_price, service_status)
SELECT 2000000 + g, 1000000 + g, (g % 4) + 1, 1,
       CASE (g % 4) + 1
           WHEN 1 THEN 2500.00 WHEN 2 THEN 4200.00
           WHEN 3 THEN 1800.00 ELSE 2200.00
       END,
       CASE (g / 4) % 4
           WHEN 0 THEN 'выполнена'
           WHEN 1 THEN 'запланирована'
           WHEN 2 THEN 'выполняется'
           ELSE 'отменена'
       END
FROM generate_series(1, 50000) AS g;

ANALYZE orders;
ANALYZE order_services;

-- 4.1. Простой индекс по дате приёмки заказа.
DROP INDEX IF EXISTS idx_lr4_orders_accepted_date;
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, accepted_date, status
FROM orders
WHERE accepted_date BETWEEN CURRENT_DATE - 100 AND CURRENT_DATE - 90;

CREATE INDEX idx_lr4_orders_accepted_date ON orders (accepted_date);
ANALYZE orders;
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, accepted_date, status
FROM orders
WHERE accepted_date BETWEEN CURRENT_DATE - 100 AND CURRENT_DATE - 90;

DROP INDEX idx_lr4_orders_accepted_date;

-- 4.2. Составной индекс по виду и состоянию услуги.
DROP INDEX IF EXISTS idx_lr4_services_work_status;
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_service_id, order_id, labor_price
FROM order_services
WHERE work_type_id = 2 AND service_status = 'выполняется';

CREATE INDEX idx_lr4_services_work_status
    ON order_services (work_type_id, service_status);
ANALYZE order_services;
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_service_id, order_id, labor_price
FROM order_services
WHERE work_type_id = 2 AND service_status = 'выполняется';

DROP INDEX idx_lr4_services_work_status;
ROLLBACK;
