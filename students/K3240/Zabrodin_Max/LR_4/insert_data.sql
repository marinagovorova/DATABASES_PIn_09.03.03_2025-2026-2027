SET search_path TO wholesale;

INSERT INTO manufacturers
    (manufacturer_name, manufacturer_inn, email, country, address, phone)
VALUES
    ('TechProm LLC', '7812345678', 'info@techprom.ru', 'Russia', 'Saint Petersburg, Nevsky Ave, 10', '+7(812)111-22-33'),
    ('FoodLine JSC', '7701234567', 'sales@foodline.ru', 'Russia', 'Moscow, Tverskaya St, 15', '+7(495)222-33-44'),
    ('OfficeWorld LLC', '540987654321', 'contact@officeworld.ru', 'Russia', 'Novosibirsk, Lenina St, 25', '+7(383)333-44-55');

INSERT INTO customers
    (customer_name, address, phone, email, customer_inn)
VALUES
    ('Retail Market LLC', 'Saint Petersburg, Sadovaya St, 8', '+7(812)444-55-66', 'orders@retailmarket.ru', '7801112233'),
    ('North Trade JSC', 'Murmansk, Mira St, 12', '+7(815)555-66-77', 'purchase@northtrade.ru', '5101234567'),
    ('City Store LLC', 'Kazan, Bauman St, 20', '+7(843)666-77-88', 'supply@citystore.ru', '1609876543'),
    ('West Trade LLC', 'Kaliningrad, Pobedy St, 5', '+7(401)777-88-99', 'orders@westtrade.ru', '3905566778'),
    ('South Market JSC', 'Rostov-on-Don, Bolshaya Sadovaya St, 30', '+7(863)888-99-00', 'sales@southmarket.ru', '6164433221');

INSERT INTO positions
    (position_name, duties, salary)
VALUES
    ('Supply Manager', 'Processing supplier contracts and controlling product deliveries', 85000.00),
    ('Sales Manager', 'Processing customer orders and preparing sales documents', 90000.00),
    ('Warehouse Manager', 'Controlling warehouse stock and product batches', 78000.00);

INSERT INTO measurement_units
    (unit_name, unit_symbol)
VALUES
    ('Piece', 'pcs'),
    ('Kilogram', 'kg'),
    ('Box', 'box');

INSERT INTO employees
    (personnel_number, full_name, passport_data, phone, email, position_id)
VALUES
    (1001, 'Ivan Petrov', '4012 123456', '+7(921)111-22-33', 'petrov@wholesale.ru', 1),
    (1002, 'Anna Smirnova', '4013 234567', '+7(921)222-33-44', 'smirnova@wholesale.ru', 2),
    (1003, 'Pavel Ivanov', '4014 345678', '+7(921)333-44-55', 'ivanov@wholesale.ru', 3);

INSERT INTO contracts
    (contract_number, contract_date, position_id, contract_type, validity_period, contract_kind, employee_id)
VALUES
    ('SUP-2025-001', '2025-02-01', 1, 'Supply', 365, 'Long-term', 1),
    ('SALE-2025-001', '2025-02-10', 2, 'Sale', 180, 'Long-term', 2),
    ('MIX-2025-001', '2025-03-01', 1, 'Mixed', 90, 'One-time', 1);

INSERT INTO suppliers
    (supplier_name, address, phone, email)
VALUES
    ('Alpha Supply LLC', 'Saint Petersburg, Industrial Ave, 5', '+7(812)777-11-22', 'alpha@supply.ru'),
    ('Beta Logistics JSC', 'Moscow, Warehouse St, 3', '+7(495)888-22-33', 'beta@logistics.ru'),
    ('Gamma Trade LLC', 'Kazan, Trade St, 7', '+7(843)999-33-44', 'gamma@trade.ru');

INSERT INTO products
    (manufacturer_id, unit_id, product_name, product_description, product_category)
VALUES
    (1, 1, 'Laptop Model A', 'Business laptop with 16 GB RAM and SSD storage', 'Electronics'),
    (2, 2, 'Sugar', 'White granulated sugar for retail sale', 'Food'),
    (3, 3, 'Office Paper', 'A4 office paper, 5 packs per box', 'Office supplies');

INSERT INTO supplies
    (supplier_id, contract_number, invoice_id, supply_date, status, description, waybill_number, actual_supply_date)
VALUES
    (1, 'SUP-2025-001', NULL, '2025-03-05', 'Received', 'Supply of laptops from supplier Alpha Supply LLC', 'WB-001', '2025-03-06'),
    (2, 'SUP-2025-001', NULL, '2025-03-07', 'Received', 'Supply of sugar from supplier Beta Logistics JSC', 'WB-002', '2025-03-07'),
    (3, 'MIX-2025-001', NULL, '2025-03-10', 'Received', 'Supply of office paper from supplier Gamma Trade LLC', 'WB-003', '2025-03-11'),
    (1, 'SUP-2025-001', NULL, '2025-04-10', 'Received', 'Supply of sugar from supplier Alpha Supply LLC', 'WB-004', '2025-04-11'),
    (2, 'SUP-2025-001', NULL, '2025-04-12', 'Received', 'Supply of laptops from supplier Beta Logistics JSC', 'WB-005', '2025-04-13'),
    (3, 'MIX-2025-001', NULL, '2025-04-15', 'Received', 'Supply of laptops from supplier Gamma Trade LLC', 'WB-006', '2025-04-16'),
    (1, 'SUP-2025-001', NULL, '2025-04-20', 'Received', 'Supply of office paper from supplier Alpha Supply LLC', 'WB-007', '2025-04-21'),
    (2, 'SUP-2025-001', NULL, '2026-06-25', 'Received', 'Supply of sugar from supplier Beta Logistics JSC', 'WB-008', '2026-06-25'),
    (3, 'MIX-2025-001', NULL, '2026-06-20', 'Received', 'Supply of office paper from supplier Gamma Trade LLC', 'WB-009', '2026-06-20');

INSERT INTO supply_items
    (supply_id, product_id, batch_number, supplied_quantity, purchase_unit_price, remaining_stock_quantity)
VALUES
    (1, 1, 'BATCH-LAP-001', 20.000, 65000.00, 15.000),
    (2, 2, 'BATCH-SUG-001', 500.000, 55.00, 430.000),
    (3, 3, 'BATCH-PAP-001', 100.000, 1200.00, 80.000),
    (4, 2, 'BATCH-SUG-002', 100.000, 55.00, 90.000),
    (5, 1, 'BATCH-LAP-002', 10.000, 64000.00, 8.000),
    (6, 1, 'BATCH-LAP-003', 8.000, 66000.00, 6.000),
    (7, 3, 'BATCH-PAP-002', 50.000, 1250.00, 45.000),
    (8, 2, 'BATCH-SUG-003', 200.000, 55.00, 200.000),
    (9, 3, 'BATCH-PAP-003', 30.000, 1200.00, 30.000);

INSERT INTO orders
    (order_status, customer_id, contract_number, order_date)
VALUES
    ('Paid', 1, 'SALE-2025-001', '2025-03-12'),
    ('Created', 2, 'SALE-2025-001', '2025-03-13'),
    ('Assembled', 3, 'MIX-2025-001', '2025-03-14'),
    ('Paid', 4, 'SALE-2025-001', '2025-04-18'),
    ('Paid', 5, 'SALE-2025-001', '2025-05-05'),
    ('Picked up', 1, 'SALE-2025-001', '2026-06-20'),
    ('Picked up', 2, 'SALE-2025-001', '2026-06-25'),
    ('Picked up', 3, 'SALE-2025-001', '2026-06-25');

INSERT INTO order_items
    (supply_id, product_id, batch_number, ordered_quantity, sale_unit_price)
VALUES
    (1, 1, 'BATCH-LAP-001', 5.000, 72000.00),
    (2, 2, 'BATCH-SUG-001', 70.000, 65.00),
    (3, 3, 'BATCH-PAP-001', 20.000, 1350.00),
    (4, 2, 'BATCH-SUG-002', 10.000, 65.00),
    (5, 1, 'BATCH-LAP-002', 2.000, 71000.00),
    (8, 2, 'BATCH-SUG-003', 5.000, 65.00),
    (9, 3, 'BATCH-PAP-003', 15.000, 1350.00),
    (7, 3, 'BATCH-PAP-002', 5.000, 1380.00);

INSERT INTO supply_invoices
    (supply_id, invoice_amount, invoice_status, creation_date, payment_date)
VALUES
    (1, 1300000.00, 'Paid', '2025-03-05', '2025-03-06'),
    (2, 27500.00, 'Paid', '2025-03-07', '2025-03-08'),
    (3, 120000.00, 'Created', '2025-03-10', NULL),
    (4, 5500.00, 'Paid', '2025-04-10', '2025-04-11'),
    (5, 640000.00, 'Paid', '2025-04-12', '2025-04-13'),
    (6, 528000.00, 'Paid', '2025-04-15', '2025-04-16'),
    (7, 62500.00, 'Created', '2025-04-20', NULL),
    (8, 11000.00, 'Paid', '2026-06-25', '2026-06-25'),
    (9, 36000.00, 'Created', '2026-06-20', NULL);

UPDATE supplies
SET invoice_id = 1
WHERE supply_id = 1;

UPDATE supplies
SET invoice_id = 2
WHERE supply_id = 2;

UPDATE supplies
SET invoice_id = 3
WHERE supply_id = 3;

UPDATE supplies
SET invoice_id = 4
WHERE supply_id = 4;

UPDATE supplies
SET invoice_id = 5
WHERE supply_id = 5;

UPDATE supplies
SET invoice_id = 6
WHERE supply_id = 6;

UPDATE supplies
SET invoice_id = 7
WHERE supply_id = 7;

UPDATE supplies
SET invoice_id = 8
WHERE supply_id = 8;

UPDATE supplies
SET invoice_id = 9
WHERE supply_id = 9;

INSERT INTO order_invoices
    (order_id, invoice_amount, invoice_status, creation_date, payment_date)
VALUES
    (1, 360000.00, 'Paid', '2025-03-12', '2025-03-13'),
    (2, 4550.00, 'Created', '2025-03-13', NULL),
    (3, 27000.00, 'Paid', '2025-03-14', '2025-03-15'),
    (4, 650.00, 'Paid', '2025-04-18', '2025-04-19'),
    (5, 142000.00, 'Paid', '2025-05-05', '2025-05-06'),
    (6, 325.00, 'Paid', '2026-06-20', '2026-06-21'),
    (7, 20250.00, 'Paid', '2026-06-25', '2026-06-25'),
    (8, 6900.00, 'Paid', '2026-06-25', '2026-06-25');
