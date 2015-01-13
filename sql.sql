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
	telephone varchar NOT NULL,
	street varchar NOT NULL,
	city varchar NOT NULL,
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
	discount numeric NOT NULL DEFAULT 0,
	street varchar NOT NULL,
	city varchar NOT NULL,
	canceled boolean NOT NULL DEFAULT false,
	CONSTRAINT "pk_Conference" PRIMARY KEY (id),
	CONSTRAINT check_discount CHECK ((0<=discount AND discount<=1)),
	CONSTRAINT check_date CHECK (start_date<=end_date AND start_date>=CURRENT_DATE)

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
	name varchar NOT NULL,
	start_time timestamp NOT NULL,
	end_time timestamp NOT NULL,
	seats integer NOT NULL,
	price numeric NOT NULL,
	canceled boolean NOT NULL DEFAULT false,
	"id_ConfDay" integer NOT NULL,
	CONSTRAINT "pk_Workshop" PRIMARY KEY (id),
	CONSTRAINT positive_seats CHECK (seats > 0),
	CONSTRAINT positive_price CHECK (price >= 0),
	CONSTRAINT check_time CHECK (start_time<=end_time AND start_time>=CURRENT_TIMESTAMP AND end_time >= CURRENT_TIMESTAMP)

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
	canceled boolean NOT NULL DEFAULT false,
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
	canceled boolean NOT NULL DEFAULT false,
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
	reservation_date date NOT NULL DEFAULT CURRENT_DATE,
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
-- DROP FUNCTION public.add_conference(varchar,date,date,numeric,varchar,varchar,integer,numeric);
CREATE FUNCTION public.add_conference ( name varchar,  start_date date,  end_date date,  discount numeric,  street varchar,  city varchar,  
seats integer,  price numeric DEFAULT 0)
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
INSERT INTO "Conference"(name,start_date,end_date,discount,street,city) VALUES(name,start_date,end_date,discount,street,city) RETURNING id 
INTO id_Conference;
days = (end_date-start_date);
i = 0;

WHILE i<days LOOP
  INSERT INTO "ConfDay"(seats,date,"id_Conference") 
  VALUES(seats,start_date+i,id_Conference) RETURNING id INTO id_ConfDay;
   
  PERFORM add_price(id_ConfDay,CURRENT_DATE,price);
  i = i+1;
END LOOP;

END$$;
COMMENT ON FUNCTION public.add_conference(varchar,date,date,numeric,varchar,varchar,integer,numeric) IS 'Add Conference with ConfDays and 
first price from CURRENT_DATE';
-- ddl-end --

-- object: public.add_user | type: FUNCTION --
-- DROP FUNCTION public.add_user(boolean,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar);
CREATE FUNCTION public.add_user ( company boolean,  name varchar,  first_name varchar,  sur_name varchar,  telephone varchar,  street varchar,  
city varchar,  login varchar,  email varchar,  password varchar)
	RETURNS void
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$INSERT INTO "User"(company,name,first_name,sur_name,telephone,street,city,login,email, password)
VALUES(company, name, first_name, sur_name, telephone, street, city, login, email, password);
$$;
-- ddl-end --

-- object: public.add_price | type: FUNCTION --
-- DROP FUNCTION public.add_price(integer,date,numeric);
CREATE FUNCTION public.add_price ( id_confday integer,  date date,  price numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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
COMMENT ON FUNCTION public.add_price(integer,date,numeric) IS 'Adds price valid for ConfDay from date.';
-- ddl-end --

-- object: public.add_workshop | type: FUNCTION --
-- DROP FUNCTION public.add_workshop(integer,varchar,time,time,integer,numeric);
CREATE FUNCTION public.add_workshop ( "id_ConfDay" integer,  name varchar,  start_time time,  end_time time,  seats integer,  price numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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
-- DROP FUNCTION public.create_confreservation(integer,integer,integer);
CREATE FUNCTION public.create_confreservation ( id_user integer,  id_conf_day integer,  reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
id_conf_reservation INTEGER;
BEGIN

INSERT INTO "ConfReservation"("id_User") VALUES(id_user) 
RETURNING id INTO id_conf_reservation;
PERFORM reserve_next_confday_for_confreservation(id_conf_reservation,id_conf_day,reserved_seats);
END$$;
COMMENT ON FUNCTION public.create_confreservation(integer,integer,integer) IS 'Create ConfReservation with first reservation for ConfDay.';
-- ddl-end --

-- object: public.reserve_next_confday_for_confreservation | type: FUNCTION --
-- DROP FUNCTION public.reserve_next_confday_for_confreservation(integer,integer,integer);
CREATE FUNCTION public.reserve_next_confday_for_confreservation ( id_conf_reservation integer,  id_conf_day integer,  reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
INSERT INTO "ConfDayReservation"("id_ConfReservation","id_ConfDay",reserved_seats) VALUES(id_conf_reservation,id_conf_day,reserved_seats);
END$$;
COMMENT ON FUNCTION public.reserve_next_confday_for_confreservation(integer,integer,integer) IS 'Adds ConfDayReservation to ConfReservation';
-- ddl-end --

-- object: public.add_payment | type: FUNCTION --
-- DROP FUNCTION public.add_payment(integer,numeric);
CREATE FUNCTION public.add_payment ( id_conf_reservation integer,  value numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
INSERT INTO "Payments"(value,"id_ConfReservation") VALUES(value,id_conf_reservation);	
END$$;
COMMENT ON FUNCTION public.add_payment(integer,numeric) IS 'Add payment to ConfReservation';
-- ddl-end --

-- object: public.cancel_confreservation | type: FUNCTION --
-- DROP FUNCTION public.cancel_confreservation(integer);
CREATE FUNCTION public.cancel_confreservation ( id_conf_reservation integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
  UPDATE "ConfReservation" SET canceled=true WHERE id=id_conf_reservation;
END$$;
-- ddl-end --

-- object: public.reserve_workshop | type: FUNCTION --
-- DROP FUNCTION public.reserve_workshop(integer,smallint,integer);
CREATE FUNCTION public.reserve_workshop ( id_conf_day_reservation integer,  id_workshop smallint,  reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
INSERT INTO "WorkshopReservation"(reserved_seats,"id_Workshop","id_ConfDayReservation") VALUES(reserved_seats, id_workshop, 
id_conf_day_reservation);
END$$;
-- ddl-end --

-- object: public.connect_person_to_conference | type: FUNCTION --
-- DROP FUNCTION public.connect_person_to_conference(varchar,varchar,integer,integer);
CREATE FUNCTION public.connect_person_to_conference ( _first_name varchar,  _sur_name varchar,  id_conf_day_reservation integer,  student_card 
integer DEFAULT NULL)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
person_id INTEGER;
BEGIN
SELECT p.id INTO person_id FROM "People" p WHERE p."first_name"=_first_name AND p."sur_name"=_sur_name;
IF NOT FOUND THEN 
    INSERT INTO "People"(first_name,sur_name) VALUES(_first_name,_sur_name) RETURNING id INTO person_id;
END IF;

INSERT INTO "PeopleAndConfReservation"("id_People", "id_ConfDayReservation", student_card) VALUES(person_id, id_conf_day_reservation, 
student_card);

END$$;
-- ddl-end --

-- object: public.connect_person_to_workshop | type: FUNCTION --
-- DROP FUNCTION public.connect_person_to_workshop(integer,integer);
CREATE FUNCTION public.connect_person_to_workshop ( id_people_and_conf_reservation integer,  id_workshop_reservation integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
INSERT INTO "PeopleAndWorkshopReservation"("id_WorkshopReservation", "id_PeopleAndConfReservation") VALUES(id_workshop_reservation, 
id_people_and_conf_reservation);
END$$;
-- ddl-end --

-- object: public.edit_user | type: FUNCTION --
-- DROP FUNCTION public.edit_user(varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar);
CREATE FUNCTION public.edit_user ( login varchar,  name varchar,  first_name varchar,  sur_name varchar,  telephone varchar,  street varchar,  
city varchar,  email varchar,  password varchar)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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
IF telephone IS NOT NULL THEN
  UPDATE "User" u SET u.telephone=telephone WHERE u.login=login;
END IF;
IF street IS NOT NULL THEN
  UPDATE "User" u SET u.street=street WHERE u.login=login;
END IF;
IF city IS NOT NULL THEN
  UPDATE "User" u SET u.city=city WHERE u.login=login;
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
-- DROP FUNCTION public.edit_workshop_reservation_seats(integer,integer);
CREATE FUNCTION public.edit_workshop_reservation_seats ( id_workshop_reservation integer,  new_reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
UPDATE "WorkshopReservation" wr SET wr.reserved_seats=new_reserved_seats WHERE wr.id=id_workshop_reservation;
END$$;
-- ddl-end --

-- object: public.edit_conf_day_reservation_seats | type: FUNCTION --
-- DROP FUNCTION public.edit_conf_day_reservation_seats(integer,integer);
CREATE FUNCTION public.edit_conf_day_reservation_seats ( id_conf_day_reservation integer,  new_reserved_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
UPDATE "ConfDayReservation" cdr SET cdr.reserved_seats=new_reserved_seats WHERE cdr.id=id_conf_day_reservation;
END$$;
-- ddl-end --

-- object: public.edit_conf_day_seats | type: FUNCTION --
-- DROP FUNCTION public.edit_conf_day_seats(integer,integer);
CREATE FUNCTION public.edit_conf_day_seats ( id_conf_day integer,  new_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
UPDATE "ConfDay" cd SET cd.seats=new_seats WHERE cd.id=id_conf_day;
END$$;
-- ddl-end --

-- object: public.edit_workshop_seats | type: FUNCTION --
-- DROP FUNCTION public.edit_workshop_seats(integer,integer);
CREATE FUNCTION public.edit_workshop_seats ( id_workshop integer,  new_seats integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
UPDATE "Workshop" w SET w.seats=new_seats WHERE w.id=id_workshop;
END$$;
-- ddl-end --

-- object: public.get_sum_price_for_workshop_reservation | type: FUNCTION --
-- DROP FUNCTION public.get_sum_price_for_workshop_reservation(integer);
CREATE FUNCTION public.get_sum_price_for_workshop_reservation ( id_workshop_reservation integer)
	RETURNS numeric
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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
-- DROP FUNCTION public.get_price_and_discount_from_conf_day(integer,date);
CREATE FUNCTION public.get_price_and_discount_from_conf_day ( id_conf_day integer,  reserved_date date)
	RETURNS public.price_and_discount
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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
-- DROP FUNCTION public.sum_price_for_conf_reservation(integer);
CREATE FUNCTION public.sum_price_for_conf_reservation ( id_conf_reservation integer)
	RETURNS numeric
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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
-- DROP FUNCTION public.get_sum_conf_day_reservation(integer);
CREATE FUNCTION public.get_sum_conf_day_reservation ( id_conf_day_reservation integer)
	RETURNS numeric
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
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

-- object: public.list_people_on_conf_day | type: FUNCTION --
-- DROP FUNCTION public.list_people_on_conf_day(integer);
CREATE FUNCTION public.list_people_on_conf_day ( id_conf_day integer)
	RETURNS TABLE ( "First name" varchar,  "Surname" varchar)
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

RETURN QUERY SELECT p.first_name,p.sur_name
FROM "ConfDay" cd
INNER JOIN "ConfDayReservation" cdr ON cdr."id_ConfDay"=cd.id AND cd.id=id_conf_day
INNER JOIN "ConfReservation" cr ON cr.id=cdr."id_ConfReservation"
INNER JOIN "PeopleAndConfReservation" pacr ON pacr."id_ConfDayReservation"=cdr.id
INNER JOIN "People" p ON pacr."id_People"=p.id
WHERE cr.canceled=false;

END$$;
-- ddl-end --

-- object: public.list_people_on_workshop | type: FUNCTION --
-- DROP FUNCTION public.list_people_on_workshop(integer);
CREATE FUNCTION public.list_people_on_workshop ( id_workshop integer)
	RETURNS TABLE ( "First name" varchar,  "Surname" varchar)
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

RETURN QUERY SELECT p.first_name,p.sur_name
FROM "Workshop" w
INNER JOIN "WorkshopReservation" wr ON wr."id_Workshop"=w.id AND w.id=id_workshop AND w.canceled=false
INNER JOIN "PeopleAndWorkshopReservation" pawr ON wr.id=pawr."id_WorkshopReservation"
INNER JOIN "PeopleAndConfReservation" pacr ON pawr."id_PeopleAndConfReservation"=pacr.id
INNER JOIN "People" p ON pacr."id_People"=p.id;

END$$;
-- ddl-end --

-- object: public.check_available_seats_on_confday | type: FUNCTION --
-- DROP FUNCTION public.check_available_seats_on_confday();
CREATE FUNCTION public.check_available_seats_on_confday ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE 
available_seats INTEGER;
res_seats INTEGER;
BEGIN
SELECT cd.seats INTO available_seats FROM "ConfDay" cd
WHERE cd.id = NEW."id_ConfDay";

SELECT sum(cdr.reserved_seats) INTO res_seats FROM "ConfDayReservation" cdr
WHERE cdr."id_ConfDay" = NEW."id_ConfDay";

IF res_seats > available_seats THEN
  RAISE EXCEPTION 'too many reserved seats';
END IF;

RETURN NULL;
END$$;
-- ddl-end --

-- object: check_seats_in_conf_day | type: TRIGGER --
-- DROP TRIGGER check_seats_in_conf_day ON public."ConfDayReservation";
CREATE TRIGGER check_seats_in_conf_day
	AFTER INSERT OR UPDATE OF reserved_seats
	ON public."ConfDayReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_available_seats_on_confday();
-- ddl-end --

-- object: public.check_available_seats_on_workshop | type: FUNCTION --
-- DROP FUNCTION public.check_available_seats_on_workshop();
CREATE FUNCTION public.check_available_seats_on_workshop ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE 
available_seats INTEGER;
res_seats INTEGER;
BEGIN
SELECT w.seats INTO available_seats FROM "Workshop" w
WHERE w.id = NEW."id_Workshop";

SELECT sum(wr.reserved_seats) INTO res_seats FROM "WorkshopReservation" cdr
WHERE wr."id_Workshop" = NEW."id_Workshop";

IF res_seats > available_seats THEN
  RAISE EXCEPTION 'too many reserved seats';
END IF;

RETURN NULL;
END;$$;
-- ddl-end --

-- object: check_seats_in_workshop | type: TRIGGER --
-- DROP TRIGGER check_seats_in_workshop ON public."WorkshopReservation";
CREATE TRIGGER check_seats_in_workshop
	AFTER INSERT OR UPDATE OF reserved_seats
	ON public."WorkshopReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_available_seats_on_workshop();
-- ddl-end --

-- object: public.check_date_price | type: FUNCTION --
-- DROP FUNCTION public.check_date_price();
CREATE FUNCTION public.check_date_price ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

IF OLD.date <= CURRENT_DATE THEN
  RAISE EXCEPTION 'You cannot delete past prices'
END IF;

RETURN OLD;
END;$$;
-- ddl-end --

-- object: check_date_price | type: TRIGGER --
-- DROP TRIGGER check_date_price ON public."Price";
CREATE TRIGGER check_date_price
	BEFORE DELETE OR UPDATE
	ON public."Price"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_date_price();
-- ddl-end --

-- object: public.check_overlaping_workshop_reservations | type: FUNCTION --
-- DROP FUNCTION public.check_overlaping_workshop_reservations();
CREATE FUNCTION public.check_overlaping_workshop_reservations ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
one RECORD;
new_reservation RECORD;
BEGIN

SELECT w.start_time, w.end_time INTO new_reservation FROM "WorkshopReservation" wr
INNER JOIN "Workshop" w ON w.id=wr."id_Workshop" AND wr.id=NEW."id_WorkshopReservation";

FOR one IN SELECT w.start_time, w.end_time 
FROM "PeopleAndWorkshopReservation" pawr
INNER JOIN "WorkshopReservation" wr ON wr.id=pawr."id_WorkshopReservation" AND 
pawr."id_PeopleAndConfReservation"=NEW."id_PeopleAndConfReservation"
INNER JOIN "Workshop" w ON w.id=wr."id_Workshop"
LOOP
  IF (new_reservation.start_time<one.start_time AND new_reservation.end_time>one.end_time) OR (new_reservation.start_time<one.end_time AND 
new_reservation.end_time>one.end_time) 
OR (new_reservation.start_time<one.start_time AND new_reservation.end_time>one.start_time) THEN
    RAISE EXCEPTION 'workshop reservations are overlapping';
  END IF;
END LOOP;
 
RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_overlapping_workshop_reservations | type: TRIGGER --
-- DROP TRIGGER check_overlapping_workshop_reservations ON public."PeopleAndWorkshopReservation";
CREATE TRIGGER check_overlapping_workshop_reservations
	BEFORE INSERT OR UPDATE
	ON public."PeopleAndWorkshopReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_overlaping_workshop_reservations();
-- ddl-end --

-- object: public.check_people_number_on_reservation | type: FUNCTION --
-- DROP FUNCTION public.check_people_number_on_reservation();
CREATE FUNCTION public.check_people_number_on_reservation ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
current_number INTEGER;
max INTEGER;
BEGIN

SELECT cdr.reserved_seats INTO max FROM "PeopleAndConfReservation" pacr
INNER JOIN  "ConfDayReservation" cdr ON cdr.id=pacr."id_ConfDayReservation"
AND pacr.id=NEW.id;

SELECT count(pacr.id) INTO current_number FROM "PeopleAndConfReservation" pacr 
WHERE pacr."id_ConfDayReservation"=NEW."id_ConfDayReservation";

IF max < current_number THEN
  RAISE EXCEPTION 'Too many people on reservation';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: people_number_on_reservation | type: TRIGGER --
-- DROP TRIGGER people_number_on_reservation ON public."PeopleAndConfReservation";
CREATE TRIGGER people_number_on_reservation
	AFTER INSERT OR UPDATE
	ON public."PeopleAndConfReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_people_number_on_reservation();
-- ddl-end --

-- object: public.check_people_number_on_workshop_reservation | type: FUNCTION --
-- DROP FUNCTION public.check_people_number_on_workshop_reservation();
CREATE FUNCTION public.check_people_number_on_workshop_reservation ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
current_state INTEGER;
max INTEGER;
BEGIN

SELECT reserved_seats INTO max FROM "WorkshopReservation"
WHERE id=NEW."id_WorkshopReservation";

SELECT count(id) INTO current_state FROM "PeopleAndWorkshopReservation"
WHERE "id_WorkshopReservation"=NEW."id_WorkshopReservation";

IF max < current_state THEN
  RAISE EXCEPTION 'Too many people on workshop reservation';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_number_on_w_reservation | type: TRIGGER --
-- DROP TRIGGER check_number_on_w_reservation ON public."PeopleAndWorkshopReservation";
CREATE TRIGGER check_number_on_w_reservation
	AFTER INSERT OR UPDATE
	ON public."PeopleAndWorkshopReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_people_number_on_workshop_reservation();
-- ddl-end --

-- object: public.check_conf_day_reservation_seats_after_edit | type: FUNCTION --
-- DROP FUNCTION public.check_conf_day_reservation_seats_after_edit();
CREATE FUNCTION public.check_conf_day_reservation_seats_after_edit ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
people INTEGER;
BEGIN

SELECT count(pacr.id) INTO people FROM "PeopleAndConfReservation" pacr
WHERE pacr."id_ConfDayReservation" = NEW.id;

IF NEW.reserved_seats < people THEN
  RAISE EXCEPTION 'Cannot resize seats, there is too many people!';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_seats_after_edit | type: TRIGGER --
-- DROP TRIGGER check_seats_after_edit ON public."ConfDayReservation";
CREATE TRIGGER check_seats_after_edit
	AFTER UPDATE OF reserved_seats
	ON public."ConfDayReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_conf_day_reservation_seats_after_edit();
-- ddl-end --

-- object: public.check_workshop_reservation_seats_after_edit | type: FUNCTION --
-- DROP FUNCTION public.check_workshop_reservation_seats_after_edit();
CREATE FUNCTION public.check_workshop_reservation_seats_after_edit ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
people INTEGER;
BEGIN

SELECT count(pawr.id) INTO people FROM "PeopleAndWorkshopReservation" pawr
WHERE pawr."id_WorkshopReservation" = NEW.id;

IF NEW.reserved_seats < people THEN
  RAISE EXCEPTION 'Cannot resize workshop reservation. Too many people!';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_seats_after_edit | type: TRIGGER --
-- DROP TRIGGER check_seats_after_edit ON public."WorkshopReservation";
CREATE TRIGGER check_seats_after_edit
	AFTER UPDATE OF reserved_seats
	ON public."WorkshopReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_workshop_reservation_seats_after_edit();
-- ddl-end --

-- object: public.check_double_conf_day_as_workshop | type: FUNCTION --
-- DROP FUNCTION public.check_double_conf_day_as_workshop();
CREATE FUNCTION public.check_double_conf_day_as_workshop ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

IF NOT EXISTS (
  SELECT pawr.id FROM "Workshop" w 
  INNER JOIN "WorkshopReservation" wr ON w.id=wr."id_Workshop" AND wr.id=NEW."id_WorkshopReservation"
  INNER JOIN "PeopleAndWorkshopReservation" pawr ON pawr."id_WorkshopReservation"=wr.id
  INNER JOIN "PeopleAndConfReservation" pacr ON pawr."id_PeopleAndConfReservation"=pacr.id
  INNER JOIN "ConfDayReservation" cdr ON cdr.id=pacr."id_ConfDayReservation"
  INNER JOIN "ConfDay" cd ON cd.id=cdr."id_ConfDay"
  WHERE cd.date = w.start_time::date;
  
  ) THEN
    RAISE EXCEPTION 'Person is not on same ConfDay';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_same_conf_day | type: TRIGGER --
-- DROP TRIGGER check_same_conf_day ON public."PeopleAndWorkshopReservation";
CREATE TRIGGER check_same_conf_day
	BEFORE INSERT OR UPDATE
	ON public."PeopleAndWorkshopReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_double_conf_day_as_workshop();
-- ddl-end --

-- object: public.check_conf_day_seats_after_edit | type: FUNCTION --
-- DROP FUNCTION public.check_conf_day_seats_after_edit();
CREATE FUNCTION public.check_conf_day_seats_after_edit ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
sum_reserved_seats INTEGER;
BEGIN

SELECT sum(reserved_seats) INTO sum_reserved_seats FROM "ConfDayReservation"
WHERE "id_ConfDay"=NEW.id;

IF sum_reserved_seats > NEW.seats
  RAISE EXCEPTION 'Cannot resize ConfDay, too many reserved seats!';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_seats_after_edit | type: TRIGGER --
-- DROP TRIGGER check_seats_after_edit ON public."ConfDay";
CREATE TRIGGER check_seats_after_edit
	AFTER UPDATE OF seats
	ON public."ConfDay"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_conf_day_seats_after_edit();
-- ddl-end --

-- object: public.check_workshop_seats_after_edit | type: FUNCTION --
-- DROP FUNCTION public.check_workshop_seats_after_edit();
CREATE FUNCTION public.check_workshop_seats_after_edit ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
sum_reserved_seats INTEGER;
BEGIN

SELECT sum(reserved_seats) INTO sum_reserved_seats FROM "WorkshopReservation"
WHERE "id_Workshop"=NEW.id;

IF sum_reserved_seats > NEW.seats
  RAISE EXCEPTION 'Cannot resize Workshop, too many reserved seats!';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_seats_after_edit | type: TRIGGER --
-- DROP TRIGGER check_seats_after_edit ON public."Workshop";
CREATE TRIGGER check_seats_after_edit
	AFTER UPDATE OF seats
	ON public."Workshop"
	FOR EACH STATEMENT
	EXECUTE PROCEDURE public.check_workshop_seats_after_edit();
-- ddl-end --

-- object: public.check_payment_full_or_too_many | type: FUNCTION --
-- DROP FUNCTION public.check_payment_full_or_too_many();
CREATE FUNCTION public.check_payment_full_or_too_many ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
price_sum NUMERIC;
payments_sum NUMERIC;
BEGIN

price_sum = sum_price_for_conf_reservation(NEW."id_ConfReservation");

SELECT sum(value) INTO payments_sum FROM "Payments"
WHERE "id_ConfReservation"=NEW."id_ConfReservation";

IF price_sum < payments_sum THEN
  RAISE EXCEPTION 'Too much money!';
END IF;

END;$$;
-- ddl-end --

-- object: public.view_not_yet_paid | type: VIEW --
-- DROP VIEW public.view_not_yet_paid;
CREATE VIEW public.view_not_yet_paid
AS SELECT u.id as "UserID", cr.id as "ConfReservationID", sum_price_for_conf_reservation(cr.id) as "ToPay", COALESCE(SUM(p.value),0) as "Paid"
FROM "User" u
INNER JOIN "ConfReservation" cr ON cr."id_User"=u.id
LEFT JOIN "Payments" p ON p."id_ConfReservation"=cr.id
WHERE cr.canceled=false
GROUP BY u.id, cr.id
HAVING sum_price_for_conf_reservation(cr.id)>sum(p.value);
-- ddl-end --

-- object: public.view_best_clients | type: VIEW --
-- DROP VIEW public.view_best_clients;
CREATE VIEW public.view_best_clients
AS SELECT u.id, u.company, u.name, u.first_name, u.sur_name, u.login, u.email
FROM "User" u
INNER JOIN "ConfReservation" cr ON cr."id_User"=u.id
INNER JOIN "ConfDayReservation" cdr ON cdr."id_ConfReservation"=cr.id
WHERE cr.canceled=false AND u.company=false
GROUP BY u.id
ORDER BY sum(cdr.reserved_seats) DESC
LIMIT 10;
-- ddl-end --

-- object: public.view_conf_with_missing_people | type: VIEW --
-- DROP VIEW public.view_conf_with_missing_people;
CREATE VIEW public.view_conf_with_missing_people
AS SELECT u.id "UserID", u.login, u.email, u.name, u.first_name, u.sur_name, u.telephone, cr.id "ConfReservationID", cdr.id 
"ConfDayReservation", COALESCE(COUNT(pacr.id),0) "Provided", cdr.reserved_seats
FROM "User" u
INNER JOIN "ConfReservation" cr ON u.id=cr."id_User"
INNER JOIN "ConfDayReservation" cdr ON cdr."id_ConfReservation"=cr.id
INNER JOIN "PeopleAndConfReservation" pacr ON pacr."id_ConfDayReservation"=cdr.id
INNER JOIN "ConfDay" cd ON cd.id=cdr."id_ConfDay"
WHERE cr.canceled=false AND cd.date <= (CURRENT_DATE-14)
GROUP BY cdr.id, u.id, cr.id
HAVING COALESCE(COUNT(pacr.id),0) < cdr.reserved_seats;
;
-- ddl-end --

-- object: public.list_reservation_for_conference | type: FUNCTION --
-- DROP FUNCTION public.list_reservation_for_conference();
CREATE FUNCTION public.list_reservation_for_conference ()
	RETURNS TABLE ( "ConfReservationID" integer,  "ConfDayReservationID" integer,  reserved_seats integer,  reservation_date date,  
"UserID" integer,  login varchar)
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
RETURN QUERY SELECT cr.id, cdr.id, cdr.reserved_seats, cdr.reservation_date, u.id, u.login 
FROM "Conference" c
INNER JOIN "ConfDay" cd ON c.id=cd."id_Conference"
INNER JOIN "ConfDayReservation" cdr ON cdr."id_ConfDay"=cd.id
INNER JOIN "ConfReservation" cr ON cr.id=cdr."id_ConfReservation"
INNER JOIN "User" u ON u.id=cr."id_User"
WHERE cr.canceled=false
END;$$;
-- ddl-end --

-- object: public.list_reservation_workshop | type: FUNCTION --
-- DROP FUNCTION public.list_reservation_workshop();
CREATE FUNCTION public.list_reservation_workshop ()
	RETURNS TABLE ( "WorkshopID" integer,  "WorkshopName" varchar,  "WorkshopReservationID" integer,  reserved_seats integer,  
"ConfDayReservationID" integer,  "UserID" integer,  login varchar)
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN
RETURN QUERY SELECT w.id, w.name, wr.id, wr.reserved_seats, cdr.id, u.id, u.login
FROM "Workshop" w
INNER JOIN "WorkshopReservation" wr ON w.id=wr."id_Workshop"
INNER JOIN "ConfDayReservation" cdr ON cdr.id=wr."id_ConfDayReservation"
INNER JOIN "ConfReservation" cr ON cr.id=cdr."id_ConfReservation"
INNER JOIN "User" u ON u.id=cr."id_User"
WHERE cr.canceled=false AND wr.canceled=false;
END;$$;
-- ddl-end --

-- object: public.check_canceled_conf_day_reservation | type: FUNCTION --
-- DROP FUNCTION public.check_canceled_conf_day_reservation();
CREATE FUNCTION public.check_canceled_conf_day_reservation ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

IF NOT EXISTS (
  SELECT id 
  FROM "ConfReservation"
  WHERE id=NEW.id AND canceled!=true
) THEN
  RAISE EXCEPTION 'ConfReservation is canceled!';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_conf_reservation_canceled | type: TRIGGER --
-- DROP TRIGGER check_conf_reservation_canceled ON public."ConfDayReservation";
CREATE TRIGGER check_conf_reservation_canceled
	BEFORE INSERT 
	ON public."ConfDayReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_canceled_conf_day_reservation();
-- ddl-end --

-- object: public.check_cancel_conf_reservation | type: FUNCTION --
-- DROP FUNCTION public.check_cancel_conf_reservation();
CREATE FUNCTION public.check_cancel_conf_reservation ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$DECLARE
workshop_id RECORD;
BEGIN

FOR workshop_id IN SELECT wr.id FROM "ConfDayReservation" cdr 
  INNER JOIN "WorkshopReservation" wr ON wr."id_ConfDayReservation"=cdr.id
  WHERE cdr."id_ConfReservation"=NEW.id LOOP

    UPDATE "WorkshopReservation" SET canceled=true WHERE id=workshop_id;

END LOOP;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: check_cancel_conf_reservation | type: TRIGGER --
-- DROP TRIGGER check_cancel_conf_reservation ON public."ConfReservation";
CREATE TRIGGER check_cancel_conf_reservation
	AFTER INSERT OR UPDATE OF canceled
	ON public."ConfReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_cancel_conf_reservation();
-- ddl-end --

-- object: public.view_available_conferences | type: VIEW --
-- DROP VIEW public.view_available_conferences;
CREATE VIEW public.view_available_conferences
AS SELECT c.id "ConferenceID", c.name, c.start_date, c.end_date, c.street, c.city, cd.id "ConfDayID", cd.seats, cd.date  
FROM "Conference" c
INNER JOIN "ConfDay" cd ON c.id=cd."id_Conference"
WHERE c.canceled!=true AND start_date > CURRENT_DATE;;
-- ddl-end --

-- object: public.check_conf_day_available_for_reservation | type: FUNCTION --
-- DROP FUNCTION public.check_conf_day_available_for_reservation();
CREATE FUNCTION public.check_conf_day_available_for_reservation ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

IF NOT EXISTS (
  SELECT cd.id
  FROM "ConfDay" cd
  INNER JOIN "Conference" c ON c.id=cd."id_Conference"
  WHERE cd.id=NEW."id_ConfDay" AND cd.date >= CURRENT_DATE AND c.canceled!=true
) THEN
  RAISE EXCEPTION 'Conference is passed or canceled!';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: conf_day_available_for_reservation | type: TRIGGER --
-- DROP TRIGGER conf_day_available_for_reservation ON public."ConfDayReservation";
CREATE TRIGGER conf_day_available_for_reservation
	BEFORE INSERT 
	ON public."ConfDayReservation"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_conf_day_available_for_reservation();
-- ddl-end --

-- object: public.check_conf_day_only_one | type: FUNCTION --
-- DROP FUNCTION public.check_conf_day_only_one();
CREATE FUNCTION public.check_conf_day_only_one ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$BEGIN

IF EXISTS (
  SELECT id
  FROM "ConfDay" cd
  WHERE "id_Conference"=NEW."id_Conference" AND date=NEW.date
) THEN
  RAISE EXCEPTION 'There is ConfDay for this Conference at this date';
END IF;

IF NOT EXISTS (
  SELECT id
  FROM "Conference"
  WHERE id=NEW."id_Conference" AND start_date <= NEW.date AND end_date >= NEW.date
) THEN
  RAISE EXCEPTION 'ConfDay is not between start and end of Conference';
END IF;

RETURN NEW;
END;$$;
-- ddl-end --

-- object: conf_day_only_one | type: TRIGGER --
-- DROP TRIGGER conf_day_only_one ON public."ConfDay";
CREATE TRIGGER conf_day_only_one
	BEFORE INSERT OR UPDATE
	ON public."ConfDay"
	FOR EACH ROW
	EXECUTE PROCEDURE public.check_conf_day_only_one();
-- ddl-end --

-- object: unique_date_and_conf_day | type: CONSTRAINT --
-- ALTER TABLE public."Price" DROP CONSTRAINT unique_date_and_conf_day;
ALTER TABLE public."Price" ADD CONSTRAINT unique_date_and_conf_day UNIQUE (date,"id_ConfDay");
-- ddl-end --



-- Appended SQL commands --
SELECT add_conference('Taka tam', CURRENT_DATE, CURRENT_DATE+1, 0.5, 'street', 'city', 300, 3);
--SELECT insert_conference('Taka tam2', CURRENT_DATE-5, CURRENT_DATE-3, 0);
SELECT add_conference('Taka tam3', CURRENT_DATE+20, CURRENT_DATE+30, 0.7, 'street1', 'city1', 40, 2.50);
--SELECT insert_conference('Taka tam4', CURRENT_DATE+50, CURRENT_DATE+39, 0);
SELECT add_conference('Taka tam5', CURRENT_DATE, CURRENT_DATE+1, 0, 'street2', 'city2', 50);
--SELECT insert_conference('Taka tam6', CURRENT_DATE, CURRENT_DATE+1, 0, true);
SELECT add_user(false,null,'Paulina','Lach','123123', 'ulica','miasto','smig','mail@smig.me','password');
SELECT add_user(true,'SM',null,null,'2222222', 'ulica1','miasto1','smigfirm','mail1@smig.me','password1');
--SELECT insert_user(true,null,null,null,'smigfirm','mail1@smig.me','password1');
--SELECT insert_user(false,'SM',null,null,'smigfirm','mail1@smig.me','password1');
--SELECT add_price(1,CURRENT_DATE-1,20.2);
SELECT create_confreservation(1,1,250);
SELECT connect_person_to_conference('Jakub', 'Kruczek', 1,1);
SELECT sum_price_for_conf_reservation(1);
SELECT list_people_on_conf_day(1);
---

