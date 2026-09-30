set search_path to azs, public;

insert into city (id_city, city_name, region_code) values
(1, 'Saint Petersburg', 78),
(2, 'Moscow', 77),
(3, 'Kazan', 16);

insert into company (id_company, company_name, company_address, company_phone, company_email) values
(1, 'Lukoil', 'Saint Petersburg, Nevsky Ave, 100', '+78120000001', 'office@lukoil.test'),
(2, 'Gazprom Neft', 'Moscow, Leningradsky Ave, 50', '+74950000002', 'info@gpn.test');

insert into fuel_type (id_fuel_type, fuel_kind, fuel_group, brand, octane_number, eco_class, seasonality, standard_name) values
(1, 'gasoline', 'liquid', 'AI-92', 92, 5, null, 'Euro-5'),
(2, 'gasoline', 'liquid', 'AI-95', 95, 5, null, 'Euro-5'),
(3, 'diesel', 'liquid', 'DT', null, 5, 'Z', 'Euro-5'),
(4, 'gas', 'gas', 'Propan', null, 5, null, 'GOST');

insert into customer (id_customer, full_name, customer_email, customer_phone) values
(1, 'Ivan Ivanov', 'ivanov@test.ru', '+79000000001'),
(2, 'Petr Petrov', 'petrov@test.ru', '+79000000002'),
(3, 'Anna Sidorova', 'sidorova@test.ru', '+79000000003');

insert into station (id_station, id_company, id_city, station_type, station_address, station_phone) values
(1, 1, 1, 'AZS', 'Saint Petersburg, Nevsky Ave, 10', '+78125550001'),
(2, 1, 2, 'AZS', 'Moscow, Leningradsky Ave, 15', '+74955550002'),
(3, 2, 1, 'AZS', 'Saint Petersburg, Moskovsky Ave, 25', '+78125550003'),
(4, 2, 3, 'AZGS', 'Kazan, Pobedy Ave, 40', '+78435550004');

insert into company_fuel (id_company_fuel, id_company, id_fuel_type, fuel_name) values
(1, 1, 1, 'AI-92 Lukoil'),
(2, 1, 2, 'AI-95 Lukoil'),
(3, 2, 2, 'AI-95 G-Drive'),
(4, 2, 3, 'DT Gazprom Neft');

insert into card_account (id_card, id_customer, issue_date, valid_until, balance) values
(1, 1, '2025-01-15', '2028-01-15', 5000.00),
(2, 2, '2025-03-10', '2028-03-10', 3200.00),
(3, 3, '2025-05-20', '2028-05-20', 1500.00);

insert into price_history (id_price, id_company_fuel, start_date, end_date, price_per_unit) values
(1, 1, '2026-01-01', '2026-02-28', 56.90),
(2, 1, '2026-03-01', null, 57.90),
(3, 2, '2026-03-01', null, 61.40),
(4, 3, '2026-03-01', null, 63.20),
(5, 4, '2026-03-01', null, 68.90);

insert into discount (id_discount, id_card, start_date, end_date, discount_percent, discount_type) values
(1, 1, '2026-01-01', null, 5, 'permanent'),
(2, 2, '2026-02-01', null, 7, 'personal'),
(3, 3, '2026-03-01', '2026-12-31', 3, 'promo');

insert into sale (id_sale, id_card, id_station, id_company_fuel, sale_datetime, liters, total_amount, status) values
(1, 1, 1, 1, '2026-03-05 10:15:00', 30.500, 1677.65, 'completed'),
(2, 2, 2, 2, '2026-03-06 12:40:00', 20.000, 1142.04, 'completed'),
(3, 3, 4, 4, '2026-03-07 09:20:00', 35.000, 2339.16, 'completed'),
(4, 1, 3, 3, '2026-03-08 18:05:00', 15.250, 915.61, 'completed');
