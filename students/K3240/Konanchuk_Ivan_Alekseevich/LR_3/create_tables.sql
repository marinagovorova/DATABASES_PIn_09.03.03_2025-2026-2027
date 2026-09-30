create schema if not exists azs;
set search_path to azs, public;

-- Table: company
create table if not exists company (
    id_company integer primary key,
    company_name varchar(100) not null,
    company_address varchar(200) not null,
    company_phone varchar(16) not null,
    company_email varchar(254) not null,
    constraint ck_company_id_positive
        check (id_company > 0),
    constraint ck_company_name_len
        check (char_length(btrim(company_name)) between 1 and 100),
    constraint ck_company_address_len
        check (char_length(btrim(company_address)) between 1 and 200),
    constraint ck_company_phone_format
        check (company_phone ~ '^\+?[0-9]{10,15}$'),
    constraint ck_company_email_format
        check (company_email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    constraint uq_company_email
        unique (company_email)
);

-- Table: fuel_type
create table if not exists fuel_type (
    id_fuel_type integer primary key,
    fuel_kind varchar(20) not null,
    fuel_group varchar(30),
    brand varchar(20) not null,
    octane_number smallint,
    eco_class smallint not null,
    seasonality varchar(10),
    standard_name varchar(50),
    constraint ck_fuel_type_id_positive
        check (id_fuel_type > 0),
    constraint ck_fuel_type_kind
        check (fuel_kind in ('gasoline', 'diesel', 'gas')),
    constraint ck_fuel_type_group_len
        check (fuel_group is null or char_length(btrim(fuel_group)) <= 30),
    constraint ck_fuel_type_brand_len
        check (char_length(btrim(brand)) between 1 and 20),
    constraint ck_fuel_type_octane
        check (octane_number is null or octane_number between 40 and 120),
    constraint ck_fuel_type_eco_class
        check (eco_class between 0 and 6),
    constraint ck_fuel_type_seasonality
        check (seasonality is null or seasonality in ('L', 'E', 'Z', 'A', 'VS')),
    constraint ck_fuel_type_standard_len
        check (standard_name is null or char_length(btrim(standard_name)) <= 50)
);

-- Table: customer
create table if not exists customer (
    id_customer integer primary key,
    full_name varchar(100) not null,
    customer_email varchar(254) not null,
    customer_phone varchar(16) not null,
    constraint ck_customer_id_positive
        check (id_customer > 0),
    constraint ck_customer_full_name_len
        check (char_length(btrim(full_name)) between 1 and 100),
    constraint ck_customer_full_name_words
        check (full_name ~ '^[A-Za-z]+([ -][A-Za-z]+)+$'),
    constraint ck_customer_email_format
        check (customer_email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
    constraint ck_customer_phone_format
        check (customer_phone ~ '^\+?[0-9]{10,15}$')
);

-- Table: station
create table if not exists station (
    id_station integer primary key,
    id_company integer not null,
    id_city integer not null,
    station_type varchar(10) not null,
    station_address varchar(200) not null,
    station_phone varchar(16) not null,
    constraint ck_station_id_positive
        check (id_station > 0),
    constraint ck_station_type
        check (station_type in ('AZS', 'AZGS')),
    constraint ck_station_address_len
        check (char_length(btrim(station_address)) between 1 and 200),
    constraint ck_station_phone_format
        check (station_phone ~ '^\+?[0-9]{10,15}$'),
    constraint uq_station_company_address
        unique (id_company, station_address),
    constraint fk_station_company
        foreign key (id_company)
        references company (id_company)
        on update cascade
        on delete restrict,
    constraint fk_station_city
        foreign key (id_city)
        references city (id_city)
        on update cascade
        on delete restrict
);

-- Table: company_fuel
create table if not exists company_fuel (
    id_company_fuel integer primary key,
    id_company integer not null,
    id_fuel_type integer not null,
    fuel_name varchar(60) not null,
    constraint ck_company_fuel_id_positive
        check (id_company_fuel > 0),
    constraint ck_company_fuel_name_len
        check (char_length(btrim(fuel_name)) between 1 and 60),
    constraint uq_company_fuel_company_type
        unique (id_company, id_fuel_type),
    constraint fk_company_fuel_company
        foreign key (id_company)
        references company (id_company)
        on update cascade
        on delete restrict,
    constraint fk_company_fuel_fuel_type
        foreign key (id_fuel_type)
        references fuel_type (id_fuel_type)
        on update cascade
        on delete restrict
);

-- Table: card_account
create table if not exists card_account (
    id_card integer primary key,
    id_customer integer not null,
    issue_date date not null,
    valid_until date not null,
    balance numeric(12,2) not null,
    constraint ck_card_account_id_positive
        check (id_card > 0),
    constraint ck_card_account_issue_date
        check (issue_date <= current_date),
    constraint ck_card_account_valid_until
        check (valid_until >= issue_date),
    constraint ck_card_account_balance
        check (balance >= 0),
    constraint fk_card_account_customer
        foreign key (id_customer)
        references customer (id_customer)
        on update cascade
        on delete restrict
);

-- Table: price_history
create table if not exists price_history (
    id_price integer primary key,
    id_company_fuel integer not null,
    start_date date not null,
    end_date date,
    price_per_unit numeric(10,2) not null,
    constraint ck_price_history_id_positive
        check (id_price > 0),
    constraint ck_price_history_dates
        check (end_date is null or end_date >= start_date),
    constraint ck_price_history_price
        check (price_per_unit > 0),
    constraint uq_price_history_business
        unique (id_company_fuel, start_date),
    constraint fk_price_history_company_fuel
        foreign key (id_company_fuel)
        references company_fuel (id_company_fuel)
        on update cascade
        on delete cascade
);

-- Table: discount
create table if not exists discount (
    id_discount integer primary key,
    id_card integer not null,
    start_date date not null,
    end_date date,
    discount_percent smallint not null,
    discount_type varchar(30) not null,
    constraint ck_discount_id_positive
        check (id_discount > 0),
    constraint ck_discount_dates
        check (end_date is null or end_date >= start_date),
    constraint ck_discount_percent
        check (discount_percent between 0 and 100),
    constraint ck_discount_type_len
        check (char_length(btrim(discount_type)) between 1 and 30),
    constraint uq_discount_business
        unique (id_card, start_date),
    constraint fk_discount_card
        foreign key (id_card)
        references card_account (id_card)
        on update cascade
        on delete cascade
);

-- Table: sale
create table if not exists sale (
    id_sale integer primary key,
    id_card integer not null,
    id_station integer not null,
    id_company_fuel integer not null,
    sale_datetime timestamp not null,
    liters numeric(10,3) not null,
    total_amount numeric(12,2) not null,
    status varchar(15) not null,
    constraint ck_sale_id_positive
        check (id_sale > 0),
    constraint ck_sale_datetime
        check (sale_datetime <= now()),
    constraint ck_sale_liters
        check (liters > 0 and liters <= 500),
    constraint ck_sale_total_amount
        check (total_amount >= 0),
    constraint ck_sale_status
        check (status in ('completed', 'cancelled', 'processing')),
    constraint fk_sale_card
        foreign key (id_card)
        references card_account (id_card)
        on update cascade
        on delete restrict,
    constraint fk_sale_station
        foreign key (id_station)
        references station (id_station)
        on update cascade
        on delete restrict,
    constraint fk_sale_company_fuel
        foreign key (id_company_fuel)
        references company_fuel (id_company_fuel)
        on update cascade
        on delete restrict
);
