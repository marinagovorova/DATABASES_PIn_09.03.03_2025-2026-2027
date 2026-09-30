-- Лабораторная работа 5
-- Процедуры, функции и триггеры для azs_sales_db

set search_path to azs, public;

-- Часть 1. Функции, процедуры. Задание 4

-- 1. Показать все покупки одного клиента за выбранную дату
create or replace function fn_customer_purchases_by_date(
    p_id_customer integer,
    p_sale_date date
)
returns table (
    customer_id integer,
    customer_name varchar,
    customer_email varchar,
    customer_phone varchar,
    sale_date date,
    sale_time time,
    station_id integer,
    fuel_name varchar,
    liters numeric,
    paid_amount numeric
)
language sql
as $$
    select
        c.id_customer,
        c.full_name,
        c.customer_email,
        c.customer_phone,
        s.sale_datetime::date as sale_date,
        s.sale_datetime::time as sale_time,
        st.id_station,
        cf.fuel_name,
        s.liters,
        s.total_amount
    from customer c
        join card_account ca on ca.id_customer = c.id_customer
        join sale s on s.id_card = ca.id_card
        join station st on st.id_station = s.id_station
        join company_fuel cf on cf.id_company_fuel = s.id_company_fuel
    where c.id_customer = p_id_customer
      and s.sale_datetime::date = p_sale_date
      and s.status = 'completed'
    order by s.sale_datetime;
$$;


-- 2. Подсчитать количество видов топлива, поставляемых каждой компанией
create or replace function fn_company_fuel_type_count()
returns table (
    company_id integer,
    company_name varchar,
    fuel_type_count bigint
)
language sql
as $$
    select
        c.id_company,
        c.company_name,
        count(distinct cf.id_fuel_type) as fuel_type_count
    from company c
        left join company_fuel cf on cf.id_company = c.id_company
    group by c.id_company, c.company_name
    order by c.id_company;
$$;


-- 3. Добавить новую станцию АЗГС для компании
create or replace procedure pr_add_azgs_station(
    in p_id_company integer,
    in p_id_city integer,
    in p_station_address varchar,
    in p_station_phone varchar,
    inout p_new_station_id integer
)
language plpgsql
as $$
begin
    -- Существует ли компания
    if not exists (
        select 1
        from company
        where id_company = p_id_company
    ) then
        raise exception 'Company with id % does not exist', p_id_company;
    end if;

    -- Существует ли город
    if not exists (
        select 1
        from city
        where id_city = p_id_city
    ) then
        raise exception 'City with id % does not exist', p_id_city;
    end if;

    -- Сгенерировать id станции, если не был передан
    if p_new_station_id is null then
        select coalesce(max(id_station), 0) + 1
        into p_new_station_id
        from station;
    end if;

    -- Добавить только станцию типа АЗГС
    insert into station (
        id_station,
        id_company,
        id_city,
        station_type,
        station_address,
        station_phone
    )
    values (
        p_new_station_id,
        p_id_company,
        p_id_city,
        'AZGS',
        p_station_address,
        p_station_phone
    );
end;
$$;


-- Часть 2. Триггерные функции

-- Триггер 1.
-- Проверить, что карта действительна на дату продажи
create or replace function fn_trg_sale_check_card_validity()
returns trigger
language plpgsql
as $$
declare
    v_issue_date date;
    v_valid_until date;
begin
    select issue_date, valid_until
    into v_issue_date, v_valid_until
    from card_account
    where id_card = new.id_card;

    if not found then
        raise exception 'Card with id % does not exist', new.id_card;
    end if;

    if new.sale_datetime::date < v_issue_date
       or new.sale_datetime::date > v_valid_until then
        raise exception
            'Card % is not valid for sale date %',
            new.id_card,
            new.sale_datetime::date;
    end if;

    return new;
end;
$$;


-- Триггер 2.
-- Проверить, что станция продает топливо своей компании
create or replace function fn_trg_sale_check_station_fuel_company()
returns trigger
language plpgsql
as $$
declare
    v_station_company integer;
    v_fuel_company integer;
begin
    select id_company
    into v_station_company
    from station
    where id_station = new.id_station;

    select id_company
    into v_fuel_company
    from company_fuel
    where id_company_fuel = new.id_company_fuel;

    if v_station_company is null then
        raise exception 'Station with id % does not exist', new.id_station;
    end if;

    if v_fuel_company is null then
        raise exception 'Company fuel with id % does not exist', new.id_company_fuel;
    end if;

    if v_station_company <> v_fuel_company then
        raise exception
            'Fuel % belongs to company %, but station % belongs to company %',
            new.id_company_fuel,
            v_fuel_company,
            new.id_station,
            v_station_company;
    end if;

    return new;
end;
$$;


-- Триггер 3.
-- Автоматически рассчитать итоговую сумму продажи с учетом актуальной цены и скидки
create or replace function fn_trg_sale_calculate_total_amount()
returns trigger
language plpgsql
as $$
declare
    v_price numeric(10,2);
    v_discount smallint;
    v_balance numeric(12,2);
begin
    -- Найти актуальную цену топлива на дату продажи
    select ph.price_per_unit
    into v_price
    from price_history ph
    where ph.id_company_fuel = new.id_company_fuel
      and new.sale_datetime::date between ph.start_date and coalesce(ph.end_date, date '9999-12-31')
    order by ph.start_date desc
    limit 1;

    if v_price is null then
        raise exception
            'Actual price for company fuel % on date % was not found',
            new.id_company_fuel,
            new.sale_datetime::date;
    end if;

    -- Найти актуальную скидку по карте на дату продажи
    select coalesce(max(d.discount_percent), 0)
    into v_discount
    from discount d
    where d.id_card = new.id_card
      and new.sale_datetime::date between d.start_date and coalesce(d.end_date, date '9999-12-31');

    -- Рассчитать итоговую сумму
    new.total_amount :=
        round(new.liters * v_price * ((100 - v_discount)::numeric / 100), 2);

    -- Для завершенной продажи проверить баланс карты
    if new.status = 'completed' then
        select balance
        into v_balance
        from card_account
        where id_card = new.id_card;

        if v_balance < new.total_amount then
            raise exception
                'Not enough money on card %. Balance: %, required: %',
                new.id_card,
                v_balance,
                new.total_amount;
        end if;
    end if;

    return new;
end;
$$;


-- Триггер 4.
-- Уменьшить баланс карты после завершенной продажи
create or replace function fn_trg_sale_decrease_card_balance()
returns trigger
language plpgsql
as $$
begin
    if new.status = 'completed' then
        update card_account
        set balance = balance - new.total_amount
        where id_card = new.id_card;
    end if;

    return null;
end;
$$;


-- Триггер 5.
-- Восстановить баланс, если завершенная продажа была отменена
create or replace function fn_trg_sale_restore_balance_on_cancel()
returns trigger
language plpgsql
as $$
begin
    if old.status = 'completed' and new.status = 'cancelled' then
        update card_account
        set balance = balance + old.total_amount
        where id_card = old.id_card;
    end if;

    return null;
end;
$$;


-- Триггер 6.
-- Закрыть предыдущую активную цену при добавлении новой цены
create or replace function fn_trg_price_history_close_previous()
returns trigger
language plpgsql
as $$
begin
    update price_history
    set end_date = new.start_date - 1
    where id_company_fuel = new.id_company_fuel
      and end_date is null
      and start_date < new.start_date;

    return new;
end;
$$;


-- Триггер 7.
-- Закрыть предыдущую активную скидку при добавлении новой скидки
create or replace function fn_trg_discount_close_previous()
returns trigger
language plpgsql
as $$
begin
    update discount
    set end_date = new.start_date - 1
    where id_card = new.id_card
      and end_date is null
      and start_date < new.start_date;

    return new;
end;
$$;


-- Часть 3. Триггеры

drop trigger if exists trg_01_sale_check_card_validity on sale;
drop trigger if exists trg_02_sale_check_station_fuel_company on sale;
drop trigger if exists trg_03_sale_calculate_total_amount on sale;
drop trigger if exists trg_04_sale_decrease_card_balance on sale;
drop trigger if exists trg_05_sale_restore_balance_on_cancel on sale;
drop trigger if exists trg_06_price_history_close_previous on price_history;
drop trigger if exists trg_07_discount_close_previous on discount;


create trigger trg_01_sale_check_card_validity
before insert or update of id_card, sale_datetime
on sale
for each row
execute function fn_trg_sale_check_card_validity();


create trigger trg_02_sale_check_station_fuel_company
before insert or update of id_station, id_company_fuel
on sale
for each row
execute function fn_trg_sale_check_station_fuel_company();


create trigger trg_03_sale_calculate_total_amount
before insert or update of id_card, id_company_fuel, sale_datetime, liters, status
on sale
for each row
execute function fn_trg_sale_calculate_total_amount();


create trigger trg_04_sale_decrease_card_balance
after insert
on sale
for each row
execute function fn_trg_sale_decrease_card_balance();


create trigger trg_05_sale_restore_balance_on_cancel
after update of status
on sale
for each row
execute function fn_trg_sale_restore_balance_on_cancel();


create trigger trg_06_price_history_close_previous
before insert
on price_history
for each row
execute function fn_trg_price_history_close_previous();


create trigger trg_07_discount_close_previous
before insert
on discount
for each row
execute function fn_trg_discount_close_previous();
