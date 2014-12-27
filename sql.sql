-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.0-alpha2
-- PostgreSQL version: 9.4
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: konferencje | type: DATABASE --
-- -- DROP DATABASE konferencje;
-- CREATE DATABASE konferencje
-- ;
-- -- ddl-end --
-- 

-- object: public."User" | type: TABLE --
-- DROP TABLE public."User";
CREATE TABLE public."User"(
	id serial NOT NULL,
	company boolean DEFAULT false,
	name varchar(30),
	first_name varchar(30),
	sur_name varchar(30),
	login varchar(30) NOT NULL,
	email varchar(40) NOT NULL,
	password varchar NOT NULL,
	CONSTRAINT "pk_User" PRIMARY KEY (id),
	CONSTRAINT unique_login UNIQUE (login),
	CONSTRAINT unique_email UNIQUE (email),
	CONSTRAINT check_good_names CHECK ((company=true AND name IS NOT NULL) OR (company=false AND first_name IS NOT NULL AND sur_name IS 
NOT NULL))

);
-- ddl-end --
-- object: public."Conference" | type: TABLE --
-- DROP TABLE public."Conference";
CREATE TABLE public."Conference"(
	id serial NOT NULL,
	name varchar(30) NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	discount numeric DEFAULT 0,
	canceled boolean DEFAULT false,
	CONSTRAINT "pk_Conference" PRIMARY KEY (id),
	CONSTRAINT check_discount CHECK ((0<=discount AND discount<=1)),
	CONSTRAINT check_date CHECK (start_date<=end_date AND start_date>=CURRENT_DATE AND end_date >= CURRENT_DATE)

);
-- ddl-end --
COMMENT ON CONSTRAINT check_discount ON public."Conference" IS 'Discount must be beetwen 0 to 1';
-- ddl-end --

-- object: public."ConfDay" | type: TABLE --
-- DROP TABLE public."ConfDay";
CREATE TABLE public."ConfDay"(
	id serial NOT NULL,
	seats integer NOT NULL,
	date date NOT NULL,
	"id_Conference" integer NOT NULL,
	CONSTRAINT "pk_ConfDay" PRIMARY KEY (id),
	CONSTRAINT positive_seats CHECK (seats > 0),
	CONSTRAINT check_date CHECK (date >= CURRENT_DATE)

);
-- ddl-end --
-- object: public."Price" | type: TABLE --
-- DROP TABLE public."Price";
CREATE TABLE public."Price"(
	id serial NOT NULL,
	value numeric NOT NULL,
	date date NOT NULL,
	"id_ConfDay" integer NOT NULL,
	CONSTRAINT "id_Price" PRIMARY KEY (id),
	CONSTRAINT positive_value CHECK (value >= 0),
	CONSTRAINT check_date CHECK (date >= CURRENT_DATE)

);
-- ddl-end --
-- object: public."Workshop" | type: TABLE --
-- DROP TABLE public."Workshop";
CREATE TABLE public."Workshop"(
	id serial NOT NULL,
	name varchar,
	start_time time NOT NULL,
	end_time time NOT NULL,
	seats integer NOT NULL,
	price numeric NOT NULL,
	canceled boolean DEFAULT false,
	"id_ConfDay" integer NOT NULL,
	CONSTRAINT "pk_Workshop" PRIMARY KEY (id),
	CONSTRAINT positive_seats CHECK (seats > 0),
	CONSTRAINT positive_price CHECK (price >= 0),
	CONSTRAINT check_time CHECK (start_time<=end_time AND start_time>=CURRENT_TIME AND end_time >= CURRENT_TIME)

);
-- ddl-end --
-- object: public."People" | type: TABLE --
-- DROP TABLE public."People";
CREATE TABLE public."People"(
	id serial NOT NULL,
	first_name varchar(30) NOT NULL,
	sur_name varchar(30) NOT NULL,
	CONSTRAINT "pk_People" PRIMARY KEY (id)

);
-- ddl-end --
-- object: "Conference_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfDay" DROP CONSTRAINT "Conference_fk";
ALTER TABLE public."ConfDay" ADD CONSTRAINT "Conference_fk" FOREIGN KEY ("id_Conference")
REFERENCES public."Conference" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public."Payments" | type: TABLE --
-- DROP TABLE public."Payments";
CREATE TABLE public."Payments"(
	id serial NOT NULL,
	timestamp timestamp NOT NULL DEFAULT now(),
	value numeric NOT NULL,
	"id_ConfReservation" integer NOT NULL,
	CONSTRAINT "id_User" PRIMARY KEY (id)

);
-- ddl-end --
-- object: public."ConfReservation" | type: TABLE --
-- DROP TABLE public."ConfReservation";
CREATE TABLE public."ConfReservation"(
	id serial NOT NULL,
	canceled boolean DEFAULT false,
	"id_User" integer NOT NULL,
	CONSTRAINT "id_ConfReservation" PRIMARY KEY (id)

);
-- ddl-end --
-- object: "User_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfReservation" DROP CONSTRAINT "User_fk";
ALTER TABLE public."ConfReservation" ADD CONSTRAINT "User_fk" FOREIGN KEY ("id_User")
REFERENCES public."User" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public."WorkshopReservation" | type: TABLE --
-- DROP TABLE public."WorkshopReservation";
CREATE TABLE public."WorkshopReservation"(
	id serial NOT NULL,
	reserved_seats integer NOT NULL,
	canceled boolean,
	"id_Workshop" integer NOT NULL,
	"id_ConfDayReservation" integer NOT NULL,
	CONSTRAINT "id_WorkshopReservation" PRIMARY KEY (id),
	CONSTRAINT "positive_reservedSeats" CHECK ("reserved_seats" > 0)

);
-- ddl-end --
-- object: "Workshop_fk" | type: CONSTRAINT --
-- ALTER TABLE public."WorkshopReservation" DROP CONSTRAINT "Workshop_fk";
ALTER TABLE public."WorkshopReservation" ADD CONSTRAINT "Workshop_fk" FOREIGN KEY ("id_Workshop")
REFERENCES public."Workshop" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfDay_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Price" DROP CONSTRAINT "ConfDay_fk";
ALTER TABLE public."Price" ADD CONSTRAINT "ConfDay_fk" FOREIGN KEY ("id_ConfDay")
REFERENCES public."ConfDay" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfDay_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Workshop" DROP CONSTRAINT "ConfDay_fk";
ALTER TABLE public."Workshop" ADD CONSTRAINT "ConfDay_fk" FOREIGN KEY ("id_ConfDay")
REFERENCES public."ConfDay" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public."ConfDayReservation" | type: TABLE --
-- DROP TABLE public."ConfDayReservation";
CREATE TABLE public."ConfDayReservation"(
	id serial NOT NULL,
	"id_ConfReservation" integer NOT NULL,
	"id_ConfDay" integer NOT NULL,
	reserved_seats integer NOT NULL,
	reservation_date date DEFAULT CURRENT_DATE,
	CONSTRAINT "pkCRandCD" PRIMARY KEY (id),
	CONSTRAINT positive_seats CHECK ("reserved_seats" > 0)

);
-- ddl-end --
-- object: "ConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfDayReservation" DROP CONSTRAINT "ConfReservation_fk";
ALTER TABLE public."ConfDayReservation" ADD CONSTRAINT "ConfReservation_fk" FOREIGN KEY ("id_ConfReservation")
REFERENCES public."ConfReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfDay_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfDayReservation" DROP CONSTRAINT "ConfDay_fk";
ALTER TABLE public."ConfDayReservation" ADD CONSTRAINT "ConfDay_fk" FOREIGN KEY ("id_ConfDay")
REFERENCES public."ConfDay" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public."PeopleAndWorkshopReservation" | type: TABLE --
-- DROP TABLE public."PeopleAndWorkshopReservation";
CREATE TABLE public."PeopleAndWorkshopReservation"(
	id serial,
	"id_WorkshopReservation" integer,
	"id_PeopleAndConfReservation" integer,
	CONSTRAINT "PandWR" PRIMARY KEY (id)

);
-- ddl-end --
-- object: "WorkshopReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndWorkshopReservation" DROP CONSTRAINT "WorkshopReservation_fk";
ALTER TABLE public."PeopleAndWorkshopReservation" ADD CONSTRAINT "WorkshopReservation_fk" FOREIGN KEY ("id_WorkshopReservation")
REFERENCES public."WorkshopReservation" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --


-- object: public."PeopleAndConfReservation" | type: TABLE --
-- DROP TABLE public."PeopleAndConfReservation";
CREATE TABLE public."PeopleAndConfReservation"(
	id serial,
	student_card integer,
	"id_People" integer NOT NULL,
	"id_ConfDayReservation" integer NOT NULL,
	CONSTRAINT "PandCR" PRIMARY KEY (id)

);
-- ddl-end --
-- object: "People_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndConfReservation" DROP CONSTRAINT "People_fk";
ALTER TABLE public."PeopleAndConfReservation" ADD CONSTRAINT "People_fk" FOREIGN KEY ("id_People")
REFERENCES public."People" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "PeopleAndConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndWorkshopReservation" DROP CONSTRAINT "PeopleAndConfReservation_fk";
ALTER TABLE public."PeopleAndWorkshopReservation" ADD CONSTRAINT "PeopleAndConfReservation_fk" FOREIGN KEY ("id_PeopleAndConfReservation")
REFERENCES public."PeopleAndConfReservation" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --


-- object: public."view_canceled_ConfReservation" | type: VIEW --
-- DROP VIEW public."view_canceled_ConfReservation";
CREATE VIEW public."view_canceled_ConfReservation"
AS SELECT c.id as ConferenceID, c.name, cd.date as ConfReservationID
FROM "ConfReservation" cr 
INNER JOIN "ConfDayReservation" cdr on cr.id=cdr."id_ConfReservation"
INNER JOIN "ConfDay" cd on cd.id=cdr."id_ConfDay"
INNER JOIN "Conference" c on c.id=cd."id_Conference"
WHERE cr.canceled=true;
COMMENT ON VIEW public."view_canceled_ConfReservation" IS 'Show canceled ConfReservations (and it''s conference name)';
-- ddl-end --

-- object: public."view_canceled_WorkshopReservations" | type: VIEW --
-- DROP VIEW public."view_canceled_WorkshopReservations";
CREATE VIEW public."view_canceled_WorkshopReservations"
AS SELECT w.id as WorkshopID, w.name, wr.id as WorkshopReservationID, wr.reserved_seats
FROM "WorkshopReservation" wr 
INNER JOIN "Workshop" w on w.id=wr."id_Workshop"
WHERE wr.canceled=true;;
COMMENT ON VIEW public."view_canceled_WorkshopReservations" IS 'Show canceled WorkshopReservations (and their''s Workshop name)';
-- ddl-end --

-- object: public."view_popular_Conferences" | type: VIEW --
-- DROP VIEW public."view_popular_Conferences";
CREATE VIEW public."view_popular_Conferences"
AS SELECT c.id, c.name, sum(cdr.reserved_seats) as Popularity
FROM "Conference" c
INNER JOIN "ConfDay" cd on cd."id_Conference"=c.id
INNER JOIN "ConfDayReservation" cdr on cdr."id_ConfDay"=cd.id
INNER JOIN "ConfReservation" cr on cr.id=cdr."id_ConfReservation"
WHERE cr.canceled = false
GROUP BY c.id, c.name
ORDER BY Popularity DESC;
-- ddl-end --

-- object: public."view_popular_Workshops" | type: VIEW --
-- DROP VIEW public."view_popular_Workshops";
CREATE VIEW public."view_popular_Workshops"
AS SELECT w.id, w.name, sum(wr.reserved_seats) as Popularity
FROM "Workshop" w
INNER JOIN "WorkshopReservation" wr on wr."id_Workshop"=w.id
WHERE wr.canceled = false
GROUP BY w.id, w.name
ORDER BY Popularity DESC;
-- ddl-end --

-- object: public."view_canceled_Workshops" | type: VIEW --
-- DROP VIEW public."view_canceled_Workshops";
CREATE VIEW public."view_canceled_Workshops"
AS SELECT id, name FROM "Workshop"
WHERE canceled = true;
-- ddl-end --

-- object: public."view_canceled_Conferences" | type: VIEW --
-- DROP VIEW public."view_canceled_Conferences";
CREATE VIEW public."view_canceled_Conferences"
AS SELECT id, name FROM "Conference"
WHERE canceled = true;
-- ddl-end --

-- object: public.view_companies | type: VIEW --
-- DROP VIEW public.view_companies;
CREATE VIEW public.view_companies
AS SELECT id, name, login, email FROM "User"
WHERE company=true;
-- ddl-end --

-- object: public.view_not_companies | type: VIEW --
-- DROP VIEW public.view_not_companies;
CREATE VIEW public.view_not_companies
AS SELECT id, first_name || ' ' ||sur_name, login, email FROM "User"
WHERE company=false;
-- ddl-end --

-- object: "ConfDayReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndConfReservation" DROP CONSTRAINT "ConfDayReservation_fk";
ALTER TABLE public."PeopleAndConfReservation" ADD CONSTRAINT "ConfDayReservation_fk" FOREIGN KEY ("id_ConfDayReservation")
REFERENCES public."ConfDayReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public.add_conference | type: FUNCTION --
-- DROP FUNCTION add_conference(varchar,date,date,numeric,integer,numeric);
CREATE FUNCTION public.add_conference ( name varchar,  start_date date,  end_date date,  discount numeric,  seats integer,  price numeric 
DEFAULT 0)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
i SMALLINT;
days INTEGER;
id_Conference INTEGER;
id_ConfDay INTEGER;
BEGIN
INSERT INTO "Conference"(name,start_date,end_date,discount) VALUES(name,start_date,end_date,discount) RETURNING id INTO id_Conference;
days = (end_date-start_date);
i = 0;

WHILE i<days LOOP
  INSERT INTO "ConfDay"(seats,date,"id_Conference") 
  VALUES(seats,start_date+i,id_Conference) RETURNING id INTO id_ConfDay;
   
  PERFORM add_price(id_ConfDay,CURRENT_DATE,price);
  i = i+1;
END LOOP;

END$$;
COMMENT ON FUNCTION add_conference(varchar,date,date,numeric,integer,numeric) IS 'Add Conference with ConfDays and first price from 
CURRENT_DATE';
-- ddl-end --

-- object: public.add_user | type: FUNCTION --
-- DROP FUNCTION add_user(boolean,varchar,varchar,varchar,varchar,varchar,varchar);
CREATE FUNCTION public.add_user ( company boolean,  name varchar,  first_name varchar,  sur_name varchar,  login varchar,  email varchar,  
password varchar)
	RETURNS void
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$INSERT INTO "User"(company,name,first_name,sur_name,login,email, password)
VALUES(company, name, first_name, sur_name, login, email, password);
$$;
-- ddl-end --

-- object: public.add_price | type: FUNCTION --
-- DROP FUNCTION add_price(integer,date,numeric);
CREATE FUNCTION public.add_price ( id_confday integer,  date date,  price numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
conf_day_date DATE;
BEGIN

SELECT cd.date INTO conf_day_date FROM "ConfDay" cd WHERE cd.id=id_confday;
IF NOT FOUND THEN 
  RAISE EXCEPTION 'No such ConfDay!';
END IF;

IF date <= conf_day_date THEN
  INSERT INTO "Price"(value, date, "id_ConfDay") VALUES(price,date,id_confday);
ELSE
  RAISE EXCEPTION 'Date is greater then % (CURRENT_DATE)', CURRENT_DATE
  USING HINT = 'Please choose better date';
END IF;

END$$;
COMMENT ON FUNCTION add_price(integer,date,numeric) IS 'Adds price valid for ConfDay from date.';
-- ddl-end --

-- object: public.add_workshop | type: FUNCTION --
-- DROP FUNCTION add_workshop(integer,varchar,time,time,integer,numeric);
CREATE FUNCTION public.add_workshop ( "id_ConfDay" integer,  name varchar,  start_time time,  end_time time,  seats integer,  price numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$INSERT INTO "Workshop"(name,start_time,end_time,seats,price,"id_ConfDay") 
VALUES(name,start_time,end_time,seats,price,id_ConfDay);$$;
-- ddl-end --

-- object: "ConfDayReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."WorkshopReservation" DROP CONSTRAINT "ConfDayReservation_fk";
ALTER TABLE public."WorkshopReservation" ADD CONSTRAINT "ConfDayReservation_fk" FOREIGN KEY ("id_ConfDayReservation")
REFERENCES public."ConfDayReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Payments" DROP CONSTRAINT "ConfReservation_fk";
ALTER TABLE public."Payments" ADD CONSTRAINT "ConfReservation_fk" FOREIGN KEY ("id_ConfReservation")
REFERENCES public."ConfReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public.create_confreservation | type: FUNCTION --
-- DROP FUNCTION create_confreservation(integer,integer,integer);
CREATE FUNCTION public.create_confreservation ( id_user integer,  id_conf_day integer,  reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
id_conf_reservation INTEGER;
BEGIN

INSERT INTO "ConfReservation"("id_User") VALUES(id_user) 
RETURNING id INTO id_conf_reservation;
PERFORM reserve_next_confday_for_confreservation(id_conf_reservation,id_conf_day,reserved_seats);
END$$;
COMMENT ON FUNCTION create_confreservation(integer,integer,integer) IS 'Create ConfReservation with first reservation for ConfDay.';
-- ddl-end --

-- object: public.reserve_next_confday_for_confreservation | type: FUNCTION --
-- DROP FUNCTION reserve_next_confday_for_confreservation(integer,integer,integer);
CREATE FUNCTION public.reserve_next_confday_for_confreservation ( id_conf_reservation integer,  id_conf_day integer,  reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
INSERT INTO "ConfDayReservation"("id_ConfReservation","id_ConfDay",reserved_seats) VALUES(id_conf_reservation,id_conf_day,reserved_seats);
END$$;
COMMENT ON FUNCTION reserve_next_confday_for_confreservation(integer,integer,integer) IS 'Adds ConfDayReservation to ConfReservation';
-- ddl-end --

-- object: public.add_payment | type: FUNCTION --
-- DROP FUNCTION add_payment(integer,numeric);
CREATE FUNCTION public.add_payment ( id_conf_reservation integer,  value numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
INSERT INTO "Payments"(value,"id_ConfReservation") VALUES(value,id_conf_reservation);	
END$$;
COMMENT ON FUNCTION add_payment(integer,numeric) IS 'Add payment to ConfReservation';
-- ddl-end --

-- object: public.cancel_confreservation | type: FUNCTION --
-- DROP FUNCTION cancel_confreservation(integer);
CREATE FUNCTION public.cancel_confreservation ( id_conf_reservation integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
workshop_id RECORD;
BEGIN
  UPDATE "ConfReservation" SET canceled=true WHERE id=id_conf_reservation;

  FOR workshop_id IN SELECT wr.id FROM "ConfDayReservation" cdr 
  INNER JOIN "WorkshopReservation" wr ON wr."id_ConfDayReservation"=cdr.id
  WHERE cdr."id_ConfReservation"=id_conf_reservation LOOP

    UPDATE "WorkshopReservation" SET canceled=true WHERE id=workshop_id;

  END LOOP;
END$$;
-- ddl-end --

-- object: public.reserve_workshop | type: FUNCTION --
-- DROP FUNCTION reserve_workshop(integer,smallint,integer);
CREATE FUNCTION public.reserve_workshop ( id_conf_day_reservation integer,  id_workshop smallint,  reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
INSERT INTO "WorkshopReservation"(reserved_seats,"id_Workshop","id_ConfDayReservation") VALUES(reserved_seats, id_workshop, 
id_conf_day_reservation);
END$$;
-- ddl-end --

-- object: public.connect_person_to_conference | type: FUNCTION --
-- DROP FUNCTION connect_person_to_conference(varchar,varchar,integer,integer);
CREATE FUNCTION public.connect_person_to_conference ( first_name varchar,  sur_name varchar,  id_conf_day_reservation integer,  student_card 
integer DEFAULT NULL)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
person_id INTEGER;
BEGIN
SELECT p.id INTO person_id FROM "People" p WHERE p.first_name=first_name AND p.sur_name=sur_name;
IF NOT FOUND THEN 
    INSERT INTO "People"(first_name,sur_name) VALUES(first_name,sur_name) RETURNING id INTO person_id;
END IF;

INSERT INTO "PeopleAndConfReservation"("id_People", "id_ConfDay", student_card) VALUES(person_id, id_conf_day_reservation, student_card);

END$$;
-- ddl-end --

-- object: public.connect_person_to_workshop | type: FUNCTION --
-- DROP FUNCTION connect_person_to_workshop(integer,integer);
CREATE FUNCTION public.connect_person_to_workshop ( id_people_and_conf_reservation integer,  id_workshop_reservation integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
INSERT INTO "PeopleAndWorkshopReservation"("id_WorkshopReservation", "id_PeopleAndConfReservation") VALUES(id_workshop_reservation, 
id_people_and_conf_reservation);
END$$;
-- ddl-end --

-- object: public.edit_user | type: FUNCTION --
-- DROP FUNCTION edit_user(varchar,varchar,varchar,varchar,varchar,varchar);
CREATE FUNCTION public.edit_user ( login varchar,  name varchar,  first_name varchar,  sur_name varchar,  email varchar,  password varchar)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN

IF name IS NOT NULL THEN
  UPDATE "User" u SET u.name=name WHERE u.login=login;
END IF;
IF first_name IS NOT NULL THEN
  UPDATE "User" u SET u.first_name=first_name WHERE u.login=login;
END IF;
IF sur_name IS NOT NULL THEN
  UPDATE "User" u SET u.sur_name=sur_name WHERE u.login=login;
END IF;
IF email IS NOT NULL THEN
  UPDATE "User" u SET u.email=email WHERE u.login=login;
END IF;
IF password IS NOT NULL THEN
  UPDATE "User" u SET u.password=password WHERE u.login=login;
END IF;

END$$;
-- ddl-end --

-- object: public.edit_workshop_reservation_seats | type: FUNCTION --
-- DROP FUNCTION edit_workshop_reservation_seats(integer,integer);
CREATE FUNCTION public.edit_workshop_reservation_seats ( id_workshop_reservation integer,  new_reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
UPDATE "WorkshopReservation" wr SET wr.reserved_seats=new_reserved_seats WHERE wr.id=id_workshop_reservation;
END$$;
-- ddl-end --

-- object: public.edit_conf_day_reservation_seats | type: FUNCTION --
-- DROP FUNCTION edit_conf_day_reservation_seats(integer,integer);
CREATE FUNCTION public.edit_conf_day_reservation_seats ( id_conf_day_reservation integer,  new_reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
UPDATE "ConfDayReservation" cdr SET cdr.reserved_seats=new_reserved_seats WHERE cdr.id=id_conf_day_reservation;
END$$;
-- ddl-end --

-- object: public.edit_conf_day_seats | type: FUNCTION --
-- DROP FUNCTION edit_conf_day_seats(integer,integer);
CREATE FUNCTION public.edit_conf_day_seats ( id_conf_day integer,  new_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
UPDATE "ConfDay" cd SET cd.seats=new_seats WHERE cd.id=id_conf_day;
END$$;
-- ddl-end --

-- object: public.edit_workshop_seats | type: FUNCTION --
-- DROP FUNCTION edit_workshop_seats(integer,integer);
CREATE FUNCTION public.edit_workshop_seats ( id_workshop integer,  new_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$BEGIN
UPDATE "Workshop" w SET w.seats=new_seats WHERE w.id=id_workshop;
END$$;
-- ddl-end --

-- object: public.get_sum_price_for_workshop_reservation | type: FUNCTION --
-- DROP FUNCTION get_sum_price_for_workshop_reservation(integer);
CREATE FUNCTION public.get_sum_price_for_workshop_reservation ( id_workshop_reservation integer)
	RETURNS numeric
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
number_of_people INTEGER;
price NUMERIC;
BEGIN
SELECT count(pawr.id) INTO number_of_people FROM "PeopleAndWorkshopReservation" pawr
INNER JOIN "WorkshopReservation" wr ON wr.id=pawr."id_WorkshopReservation" AND wr.id=id_workshop_reservation;

SELECT w.price INTO price FROM "WorkshopReservation" wr INNER JOIN "Workshop" w ON wr."id_Workshop"=w.id AND wr.id=id_workshop_reservation;

RETURN (number_of_people * price);
END$$;
-- ddl-end --

-- object: public.price_and_discount | type: TYPE --
-- DROP TYPE public.price_and_discount;
CREATE TYPE public.price_and_discount AS
(
  price numeric,
  discount numeric
);
-- ddl-end --

-- object: public.get_price_and_discount_from_conf_day | type: FUNCTION --
-- DROP FUNCTION get_price_and_discount_from_conf_day(integer,date);
CREATE FUNCTION public.get_price_and_discount_from_conf_day ( id_conf_day integer,  reserved_date date)
	RETURNS public.price_and_discount
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
return_record public.price_and_discount;
BEGIN

SELECT c.discount, p.value INTO return_record.discount, return_record.price 
FROM "ConfDay" cd
INNER JOIN "Conference" c ON c.id=cd."id_Conference" AND cd.id=id_conf_day
INNER JOIN "Price" p ON p."id_ConfDay"=cd.id AND p.date<=reserved_date
ORDER BY p.date DESC
LIMIT 1;

RETURN return_record;

END$$;
-- ddl-end --

-- object: public.sum_price_for_conf_reservation | type: FUNCTION --
-- DROP FUNCTION sum_price_for_conf_reservation(integer);
CREATE FUNCTION public.sum_price_for_conf_reservation ( id_conf_reservation integer)
	RETURNS numeric
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
sum NUMERIC;
partial_sum NUMERIC;
cdr_r RECORD;
BEGIN
sum=0.0;

FOR cdr_r IN SELECT id FROM "ConfDayReservation" cdr WHERE cdr."id_ConfReservation"=id_conf_reservation LOOP
  sum = sum + get_sum_conf_day_reservation(cdr_r.id);
END LOOP;

RETURN sum;
END$$;
-- ddl-end --

-- object: public.get_sum_conf_day_reservation | type: FUNCTION --
-- DROP FUNCTION get_sum_conf_day_reservation(integer);
CREATE FUNCTION public.get_sum_conf_day_reservation ( id_conf_day_reservation integer)
	RETURNS numeric
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$DECLARE
c_d_reservation RECORD;
workshop_reservation RECORD;
price_and_discount public.price_and_discount;
partial_sum NUMERIC;
sum NUMERIC;
BEGIN
sum=0.0;

SELECT * INTO c_d_reservation FROM "ConfDayReservation" cdr
WHERE cdr.id=id_conf_day_reservation;

--get price and discount from conf_day
price_and_discount = get_price_and_discount_from_conf_day(c_d_reservation."id_ConfDay",c_d_reservation.reservation_date);

--price of workshops
FOR workshop_reservation IN SELECT wr.id FROM "WorkshopReservation" wr WHERE wr."id_ConfDayReservation"=c_d_reservation.id LOOP
  sum = sum + get_sum_price_for_workshop_reservation(workshop_reservation.id);
END LOOP;

--price for conferences for not students
SELECT count(pacr.id)*price_and_discount.price INTO partial_sum FROM "PeopleAndConfReservation" pacr
INNER JOIN "ConfDayReservation" cdr ON cdr.id=pacr."id_ConfDayReservation" AND pacr.student_card IS NULL;
sum = sum + partial_sum;

--price for conferences for students
SELECT count(pacr.id)*price_and_discount.price*(1-price_and_discount.discount) INTO partial_sum FROM "PeopleAndConfReservation" pacr
INNER JOIN "ConfDayReservation" cdr ON cdr.id=pacr."id_ConfDayReservation" AND pacr.student_card IS NOT NULL;
sum = sum + partial_sum;

RETURN sum;
END$$;
-- ddl-end --


-- Appended SQL commands --
SELECT add_conference('Taka tam', CURRENT_DATE, CURRENT_DATE+1, 0, 200);
--SELECT insert_conference('Taka tam2', CURRENT_DATE-5, CURRENT_DATE-3, 0);
SELECT add_conference('Taka tam3', CURRENT_DATE+20, CURRENT_DATE+30, 0.7, 40, 2.50);
--SELECT insert_conference('Taka tam4', CURRENT_DATE+50, CURRENT_DATE+39, 0);
SELECT add_conference('Taka tam5', CURRENT_DATE, CURRENT_DATE+1, 0, 50);
--SELECT insert_conference('Taka tam6', CURRENT_DATE, CURRENT_DATE+1, 0, true);
SELECT add_user(false,null,'Paulina','Lach','smig','mail@smig.me','password');
SELECT add_user(true,'SM',null,null,'smigfirm','mail1@smig.me','password1');
--SELECT insert_user(true,null,null,null,'smigfirm','mail1@smig.me','password1');
--SELECT insert_user(false,'SM',null,null,'smigfirm','mail1@smig.me','password1');
--SELECT add_price(1,CURRENT_DATE-1,20.2);
SELECT create_confreservation(1,1,250);
SELECT sum_price_from_conf_reservation(1);
---

