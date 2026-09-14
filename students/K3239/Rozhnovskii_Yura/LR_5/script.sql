-- Процедура 1

create procedure railway_schema.p_raise_suburban_prices()
language plpgsql
as $$
begin
	update railway_schema."Tariff" t
	set tr_price = round(t.tr_price * 1.2, 2)
	from railway_schema."Route" r
	where t.id_route = r.id_route
		and r.route_type = 'Пригородный';
end;
$$;

-- Процедура 2

create procedure railway_schema.p_create_flight(
	in p_id_train integer,
	in p_id_route integer,
	in p_dep_date date,
	inout p_new_id_flight integer
)
language plpgsql
as $$
declare
    v_train_status varchar(20);
    v_dep_time time without time zone;
    v_duration interval;
    v_schedule_exists boolean;
    v_flight_exists boolean;
    v_intersec_exists boolean;
begin
	if p_id_train is null or p_id_route is null or p_dep_date is null then
        raise notice 'Нулевое значение в индексе поезда, индексе маршрута или дате отправления.';
		return;
	end if;

	select ts.status
	into v_train_status
	from railway_schema."Train_Status" ts
	where ts.id_train = p_id_train
	order by ts.change_date desc, ts.id_train_status desc
	limit 1;

	if not found or v_train_status != 'Используется' then
        raise notice 'Такого поезда нет или он не может быть использован в данный момент.';
		return;
	end if;

	select r.dep_time, r.duration
    into v_dep_time, v_duration
    from railway_schema."Route" r
    where r.id_route = p_id_route;

    if not found then
        raise notice 'Такого маршрута нет.';
        return;
    end if;

	select exists (
		select 1
		from railway_schema."Route_Schedule" rs
		where rs.id_route = p_id_route
	)
	into v_schedule_exists;

	if not v_schedule_exists then
        raise notice 'У этого маршрута нет расписания.';
		return;
	end if;

	select exists (
		select 1
		from railway_schema."Flight" f
		where f.id_train = p_id_train
			and f.id_route = p_id_route
			and f.dep_date = p_dep_date
	)
	into v_flight_exists;

	if v_flight_exists then
        raise notice 'Такой рейс уже существует.';
		return;
	end if;

    select exists (
        select 1
        from railway_schema."Flight" f
        join railway_schema."Route" r
            on r.id_route = f.id_route
        left join lateral (
            select fs.status
            from railway_schema."Flight_Status" fs
            where fs.id_flight = f.id_flight
            order by fs.change_date desc, fs.id_flight_status desc
            limit 1
        ) ls on true
        where f.id_train = p_id_train
        and ls.status in ('Активен', 'Задержан')
        and (f.dep_date + r.dep_time) < (p_dep_date + v_dep_time + v_duration)
        and (f.dep_date + r.dep_time + r.duration) > (p_dep_date + v_dep_time)
        limit 1
    )
    into v_intersec_exists;

    if v_intersec_exists then
        raise notice 'Этот рейс пересекается с уже имеющимися рейсами этого поезда.';
        return;
    end if;

	insert into railway_schema."Flight" (id_train, id_route, dep_date)
	values (p_id_train, p_id_route, p_dep_date)
	returning id_flight into p_new_id_flight;

	insert into railway_schema."Flight_Status" (id_flight, change_date, status)
	values (p_new_id_flight, current_date, 'Активен');
end;
$$;

-- Процедура 3

create procedure railway_schema.p_get_revenue_for_date(
	in p_date date,
	inout p_total numeric
)
language plpgsql
as $$
begin
	if p_date is null then
		raise notice 'Не задана дата для расчета выручки';
        return;
	end if;

	select coalesce(sum(t.price), 0)
	into p_total
	from railway_schema."Ticket" t
	left join lateral (
		select ts.change_date, ts.status
		from railway_schema."Ticket_Status" ts
		where ts.id_ticket = t.id_ticket
		order by ts.change_date desc, ts.id_status desc
		limit 1
	) ts on true
	where ts.change_date = p_date
		and ts.status != 'Сдан';
end;
$$;

-- Триггер 1

create function railway_schema.fn_check_route_schedule_time()
returns trigger
language plpgsql
as $$
declare
	v_prev_time interval;
begin
	if new.stop_time < interval '0'  or new.time_since_dep < interval '0' then
		raise exception 'Время стоянки и время с момента отправления не могут быть отрицательными';
	end if;

    if new.time_since_dep > (
        select r.duration
        from railway_schema."Route" r
        where new.id_route = r.id_route
    ) then
        raise exception 'Время с момента отправления не может быть больше длительности маршрута';
    end if;

	if new.order_num = 1 and new.time_since_dep != interval '0' then
		raise exception 'Для первой остановки маршрута время от начала следования должно быть 00:00:00';
	end if;

	if new.order_num > 1 then
		select max(rs.time_since_dep)
		into v_prev_time
		from railway_schema."Route_Schedule" rs
		where rs.id_route = new.id_route
			and rs.order_num < new.order_num
			and rs.id_schedule is distinct from new.id_schedule;

		if v_prev_time is not null and new.time_since_dep < v_prev_time then
			raise exception 'Время по маршруту должно быть возрастающим. Предыдущая остановка имеет время %', v_prev_time;
		end if;
	end if;

	return new;
end;
$$;

create trigger trg_route_schedule_time_check
before insert or update on railway_schema."Route_Schedule"
for each row
execute function railway_schema.fn_check_route_schedule_time();

-- Триггер 2

create function railway_schema.fn_check_tariff_station_orders()
returns trigger
language plpgsql
as $$
declare
	v_as_dep_exists boolean;
	v_as_arr_exists boolean;
	v_tariff_exists boolean;
begin
	if new.dep_station_order >= new.arr_station_order then
		raise exception 'Порядок станции отправления должен быть меньше порядка станции прибытия';
	end if;

    if tg_op = 'INSERT' then
        select exists (
                select 1
                from railway_schema."Tariff" t
                where t.id_route = new.id_route
                    and t.id_seat_type = new.id_seat_type
                    and t.dep_station_order = new.dep_station_order
                    and t.arr_station_order = new.arr_station_order
        )
        into v_tariff_exists;

        if v_tariff_exists then
            raise exception 'Такой тариф уже существует';
        end if;
    end if;

    select exists (
        select 1
        from railway_schema."Route_Schedule" rs
        where rs.id_route = new.id_route
            and rs.order_num = new.dep_station_order
    )
    into v_as_dep_exists;

    select exists (
        select 1
        from railway_schema."Route_Schedule" rs
        where rs.id_route = new.id_route
            and rs.order_num = new.arr_station_order
    )
    into v_as_arr_exists;

	if not (v_as_dep_exists and v_as_arr_exists) then
		raise exception 'Тариф ссылается на несуществующий порядок остановки маршрута %', new.id_route;
	end if;

	return new;
end;
$$;

create trigger trg_tariff_station_orders_check
before insert or update on railway_schema."Tariff"
for each row
execute function railway_schema.fn_check_tariff_station_orders();

-- Триггер 3

create function railway_schema.fn_check_seat_limit()
returns trigger
language plpgsql
as $$
declare
	v_seat_count integer;
    v_seat_exists boolean;
begin
	select w.seat_count
	into v_seat_count
	from railway_schema."Wagon_in_Flight" wf
	join railway_schema."Wagon" w on w.id_wagon = wf.id_wagon
	where wf.id_wagon_in_flight = new.id_wagon_in_flight;

	if not found then
		raise exception 'Вагон рейса с id_wagon_in_flight = % не найден', new.id_wagon_in_flight;
	end if;

    if tg_op = 'INSERT' then
        select exists (
                select 1
                from railway_schema."Seat_in_Flight" sf
                where sf.id_wagon_in_flight = new.id_wagon_in_flight
                    and sf.seat_num = new.seat_num
        )
        into v_seat_exists;

        if v_seat_exists then
            raise exception 'Такое место уже существует';
        end if;
    end if;

	if new.seat_num > v_seat_count then
		raise exception 'Номер места % превышает количество мест в вагоне (%)', new.seat_num, v_seat_count;
	end if;

	return new;
end;
$$;

create trigger trg_seat_in_flight_seat_limit
before insert or update on railway_schema."Seat_in_Flight"
for each row
execute function railway_schema.fn_check_seat_limit();

-- Триггер 4

create function railway_schema.fn_ticket_seat_free()
returns trigger
language plpgsql
as $$
declare
    v_seat_status varchar(14);
begin
    select sf.status
    into v_seat_status
    from railway_schema."Seat_in_Flight" sf
    where sf.id_wagon_in_flight = new.id_wagon_in_flight
        and sf.seat_num = new.seat_num;

    if not found then
        raise exception 'Место % не существует', new.seat_num;
    end if;

    if v_seat_status != 'Свободно' then
        raise exception 'Место % в вагоне рейса уже занято', new.seat_num;
    end if;

    return new;
end;
$$;

create trigger trg_ticket_seat_free_before_insert
before insert on railway_schema."Ticket"
for each row
execute function railway_schema.fn_ticket_seat_free();

-- Триггер 5

create function railway_schema.fn_ticket_reserve_seat()
returns trigger
language plpgsql
as $$
begin
	update railway_schema."Seat_in_Flight"
	set status = 'Забронировано'
	where id_wagon_in_flight = new.id_wagon_in_flight
		and seat_num = new.seat_num
		and status = 'Свободно';

	return new;
end;
$$;

create trigger trg_ticket_reserve_seat_after_insert
after insert on railway_schema."Ticket"
for each row
execute function railway_schema.fn_ticket_reserve_seat();

-- Триггер 6

create function railway_schema.fn_ticket_status_used_date_check()
returns trigger
language plpgsql
as $$
declare
	v_dep_date date;
begin
	if new.status = 'Использован' then
		select f.dep_date
		into v_dep_date
		from railway_schema."Ticket" t
		join railway_schema."Wagon_in_Flight" wf
			on wf.id_wagon_in_flight = t.id_wagon_in_flight
		join railway_schema."Flight" f
			on f.id_flight = wf.id_flight
		where t.id_ticket = new.id_ticket;

		if not found then
			raise exception 'Билет % не найден', new.id_ticket;
		end if;

		if new.change_date < v_dep_date then
			raise exception 'Билет нельзя пометить использованным раньше даты отправления рейса (%)', v_dep_date;
		end if;
	end if;

	return new;
end;
$$;

create trigger trg_ticket_status_used_date_check
before insert or update on railway_schema."Ticket_Status"
for each row
execute function railway_schema.fn_ticket_status_used_date_check();

-- Триггер 7

create or replace function railway_schema.fn_ticket_return_free_seat()
returns trigger
language plpgsql
as $$
declare
    v_wagon_in_flight integer;
    v_seat_num integer;
begin
    if new.status = 'Сдан' and old.status is distinct from new.status then
        select t.id_wagon_in_flight, t.seat_num
        into v_wagon_in_flight, v_seat_num
        from railway_schema."Ticket" t
        where t.id_ticket = new.id_ticket;

        if found then
            update railway_schema."Seat_in_Flight"
            set status = 'Свободно'
            where id_wagon_in_flight = v_wagon_in_flight
              and seat_num = v_seat_num
              and status = 'Забронировано';
        end if;
    end if;

    return new;
end;
$$;

create trigger trg_ticket_return_free_seat
after insert or update on railway_schema."Ticket_Status"
for each row
execute function railway_schema.fn_ticket_return_free_seat();