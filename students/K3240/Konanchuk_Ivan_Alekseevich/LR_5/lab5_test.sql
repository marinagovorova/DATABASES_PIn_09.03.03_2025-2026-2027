-- ============================================================
-- Лабораторная работа 5
-- Тестовый скрипт для функций, процедуры и триггеров
-- База данных: azs_sales_db
-- ============================================================

set search_path to azs, public;

\echo '0. Список созданных триггеров'

select
    event_object_table as table_name,
    trigger_name,
    action_timing,
    event_manipulation
from information_schema.triggers
where trigger_schema = 'azs'
order by event_object_table, trigger_name, event_manipulation;

\echo '4.1. Покупки клиента за выбранную дату'

-- Сначала показать даты, за которые у клиентов есть покупки.
select
    ca.id_customer,
    c.full_name,
    s.sale_datetime::date as sale_date,
    count(*) as sale_count
from sale s
join card_account ca on ca.id_card = s.id_card
join customer c on c.id_customer = ca.id_customer
group by ca.id_customer, c.full_name, s.sale_datetime::date
order by s.sale_datetime::date, ca.id_customer;

-- Проверить функцию из индивидуального задания 4.1.
select *
from fn_customer_purchases_by_date(1, date '2026-03-05');

\echo '4.2. Количество видов топлива, поставляемых каждой компанией'

select *
from fn_company_fuel_type_count();

\echo '4.3. Добавление новой тестовой станции АЗГС'

begin;

call pr_add_azgs_station(
    1,
    1,
    'Saint Petersburg, Lab5 AZGS, 1',
    '+78125550115',
    null::integer
);

select
    id_station,
    id_company,
    id_city,
    station_type,
    station_address,
    station_phone
from station
order by id_station desc
limit 3;

rollback;

\echo '5.1. Проверка триггеров: расчет итоговой суммы и уменьшение баланса'
\echo 'Триггеры: trg_01, trg_02, trg_03, trg_04'

begin;

select 'баланс до продажи' as test_step, id_card, balance
from card_account
where id_card = 1;

insert into sale (
    id_sale,
    id_card,
    id_station,
    id_company_fuel,
    sale_datetime,
    liters,
    total_amount,
    status
)
values (
    (select coalesce(max(id_sale), 0) + 1 from sale),
    1,
    1,
    1,
    now(),
    10.000,
    0,
    'completed'
);

select
    'добавленная продажа после срабатывания триггеров' as test_step,
    id_sale,
    id_card,
    id_station,
    id_company_fuel,
    sale_datetime,
    liters,
    total_amount,
    status
from sale
where id_sale = (select max(id_sale) from sale);

select 'баланс после продажи' as test_step, id_card, balance
from card_account
where id_card = 1;

rollback;

\echo '5.2. Проверка триггера: отмена завершенной продажи и восстановление баланса'
\echo 'Триггер: trg_05_sale_restore_balance_on_cancel'

begin;

select 'баланс до продажи' as test_step, id_card, balance
from card_account
where id_card = 1;

insert into sale (
    id_sale,
    id_card,
    id_station,
    id_company_fuel,
    sale_datetime,
    liters,
    total_amount,
    status
)
values (
    (select coalesce(max(id_sale), 0) + 1 from sale),
    1,
    1,
    1,
    now(),
    10.000,
    0,
    'completed'
);

select 'баланс после завершенной продажи' as test_step, id_card, balance
from card_account
where id_card = 1;

update sale
set status = 'cancelled'
where id_sale = (select max(id_sale) from sale);

select
    'продажа после отмены' as test_step,
    id_sale,
    total_amount,
    status
from sale
where id_sale = (select max(id_sale) from sale);

select 'баланс после отмены' as test_step, id_card, balance
from card_account
where id_card = 1;

rollback;

\echo '5.3. Проверка триггера: некорректная дата карты должна вызвать ошибку'
\echo 'Триггер: trg_01_sale_check_card_validity'

-- Ожидаемый результат: вставка отклоняется триггером.
do $$
begin
    begin
        insert into sale (
            id_sale,
            id_card,
            id_station,
            id_company_fuel,
            sale_datetime,
            liters,
            total_amount,
            status
        )
        values (
            (select coalesce(max(id_sale), 0) + 1 from sale),
            1,
            1,
            1,
            timestamp '2024-12-01 10:00:00',
            10.000,
            0,
            'completed'
        );

        raise exception 'ТЕСТ НЕ ПРОЙДЕН: продажа с недействительной картой была добавлена';
    exception
        when others then
            raise notice 'Ожидаемая ошибка перехвачена: %', sqlerrm;
    end;
end;
$$;

\echo '5.4. Проверка триггера: станция не может продавать топливо другой компании'
\echo 'Триггер: trg_02_sale_check_station_fuel_company'

-- Ожидаемый результат: вставка отклоняется триггером.
do $$
begin
    begin
        insert into sale (
            id_sale,
            id_card,
            id_station,
            id_company_fuel,
            sale_datetime,
            liters,
            total_amount,
            status
        )
        values (
            (select coalesce(max(id_sale), 0) + 1 from sale),
            1,
            1,
            4,
            now(),
            10.000,
            0,
            'completed'
        );

        raise exception 'ТЕСТ НЕ ПРОЙДЕН: продажа топлива другой компании была добавлена';
    exception
        when others then
            raise notice 'Ожидаемая ошибка перехвачена: %', sqlerrm;
    end;
end;
$$;

\echo '5.5. Проверка триггера: закрытие предыдущей активной цены'
\echo 'Триггер: trg_06_price_history_close_previous'

begin;

select
    'цены до вставки' as test_step,
    id_price,
    id_company_fuel,
    start_date,
    end_date,
    price_per_unit
from price_history
where id_company_fuel = 1
order by start_date;

insert into price_history (
    id_price,
    id_company_fuel,
    start_date,
    end_date,
    price_per_unit
)
values (
    (select coalesce(max(id_price), 0) + 1 from price_history),
    1,
    current_date,
    null,
    60.00
);

select
    'цены после вставки' as test_step,
    id_price,
    id_company_fuel,
    start_date,
    end_date,
    price_per_unit
from price_history
where id_company_fuel = 1
order by start_date;

rollback;

\echo '5.6. Проверка триггера: закрытие предыдущей активной скидки'
\echo 'Триггер: trg_07_discount_close_previous'

begin;

select
    'скидки до вставки' as test_step,
    id_discount,
    id_card,
    start_date,
    end_date,
    discount_percent,
    discount_type
from discount
where id_card = 1
order by start_date;

insert into discount (
    id_discount,
    id_card,
    start_date,
    end_date,
    discount_percent,
    discount_type
)
values (
    (select coalesce(max(id_discount), 0) + 1 from discount),
    1,
    current_date,
    null,
    10,
    'lab5_test'
);

select
    'скидки после вставки' as test_step,
    id_discount,
    id_card,
    start_date,
    end_date,
    discount_percent,
    discount_type
from discount
where id_card = 1
order by start_date;

rollback;

\echo 'Все тесты завершены. Тестовые вставки были отменены там, где это требовалось.'
