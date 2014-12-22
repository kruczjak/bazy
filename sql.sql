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
	CONSTRAINT check_good_names CHECK ((company=true AND name IS NOT NULL) OR (company=false AND first_name IS NOT NULL AND sur_name IS NOT NULL))

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
	CONSTRAINT positive_value CHECK (value > 0),
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
	CONSTRAINT "id_User" PRIMARY KEY (id),
	CONSTRAINT positive_price CHECK (value > 0)

);
-- ddl-end --
-- object: public."ConfReservation" | type: TABLE --
-- DROP TABLE public."ConfReservation";
CREATE TABLE public."ConfReservation"(
	id serial NOT NULL,
	reserved_seats integer NOT NULL,
	reservation_date date DEFAULT CURRENT_DATE,
	canceled boolean DEFAULT false,
	"id_User" integer NOT NULL,
	"id_Payments" integer,
	CONSTRAINT "id_ConfReservation" PRIMARY KEY (id),
	CONSTRAINT positive_reserved_seats CHECK ("reserved_seats" > 0)

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
	"id_ConfReservation" integer NOT NULL,
	"id_Workshop" integer NOT NULL,
	CONSTRAINT "id_WorkshopReservation" PRIMARY KEY (id),
	CONSTRAINT "positive_reservedSeats" CHECK ("reserved_seats" > 0)

);
-- ddl-end --
-- object: "ConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."WorkshopReservation" DROP CONSTRAINT "ConfReservation_fk";
ALTER TABLE public."WorkshopReservation" ADD CONSTRAINT "ConfReservation_fk" FOREIGN KEY ("id_ConfReservation")
REFERENCES public."ConfReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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


-- object: "Payments_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfReservation" DROP CONSTRAINT "Payments_fk";
ALTER TABLE public."ConfReservation" ADD CONSTRAINT "Payments_fk" FOREIGN KEY ("id_Payments")
REFERENCES public."Payments" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfDay_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Workshop" DROP CONSTRAINT "ConfDay_fk";
ALTER TABLE public."Workshop" ADD CONSTRAINT "ConfDay_fk" FOREIGN KEY ("id_ConfDay")
REFERENCES public."ConfDay" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public."ConfReservationAndConfDay" | type: TABLE --
-- DROP TABLE public."ConfReservationAndConfDay";
CREATE TABLE public."ConfReservationAndConfDay"(
	id serial NOT NULL,
	"id_ConfReservation" integer NOT NULL,
	"id_ConfDay" integer NOT NULL,
	CONSTRAINT "pkCRandCD" PRIMARY KEY (id)

);
-- ddl-end --
-- object: "ConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfReservationAndConfDay" DROP CONSTRAINT "ConfReservation_fk";
ALTER TABLE public."ConfReservationAndConfDay" ADD CONSTRAINT "ConfReservation_fk" FOREIGN KEY ("id_ConfReservation")
REFERENCES public."ConfReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfDay_fk" | type: CONSTRAINT --
-- ALTER TABLE public."ConfReservationAndConfDay" DROP CONSTRAINT "ConfDay_fk";
ALTER TABLE public."ConfReservationAndConfDay" ADD CONSTRAINT "ConfDay_fk" FOREIGN KEY ("id_ConfDay")
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
	"id_ConfReservationAndConfDay" integer NOT NULL,
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
AS SELECT c.id as ConferenceID, c.name, cd.date, cr.id as ConfReservationID, cr.reserved_seats
FROM "ConfReservation" cr 
INNER JOIN "ConfReservationAndConfDay" cracd on cr.id=cracd."id_ConfReservation"
INNER JOIN "ConfDay" cd on cd.id=cracd."id_ConfDay"
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
AS SELECT c.id, c.name, sum(cr.reserved_seats) as Popularity
FROM "Conference" c
INNER JOIN "ConfDay" cd on cd."id_Conference"=c.id
INNER JOIN "ConfReservationAndConfDay" cracd on cracd."id_ConfDay"=cd.id
INNER JOIN "ConfReservation" cr on cr.id=cracd."id_ConfReservation"
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

-- object: "ConfReservationAndConfDay_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndConfReservation" DROP CONSTRAINT "ConfReservationAndConfDay_fk";
ALTER TABLE public."PeopleAndConfReservation" ADD CONSTRAINT "ConfReservationAndConfDay_fk" FOREIGN KEY ("id_ConfReservationAndConfDay")
REFERENCES public."ConfReservationAndConfDay" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: public.view_not_paid | type: VIEW --
-- DROP VIEW public.view_not_paid;
CREATE VIEW public.view_not_paid
AS SELECT u.id "UserID", u.name "Name", cr.id "ConfReservationID", cr.reserved_seats, SUM(pa.value) "Paid so far", SUM(pr.value) "Price"
FROM "Payments" pa
INNER JOIN "ConfReservation" cr ON cr."id_Payments"=pa.id AND cr.canceled=false
INNER JOIN "User" u ON u.id=cr."id_User" AND u.company=true
INNER JOIN "ConfReservationAndConfDay" cracd ON cracd."id_ConfReservation"=cr.id
INNER JOIN "ConfDay" cd ON cd.id=cracd."id_ConfDay"
INNER JOIN "Price" pr ON cd.id=pr."id_ConfDay" AND pr.date = cr.reservation_date
INNER JOIN "Conference" c ON c.id=cd."id_Conference" AND c.start_date > CURRENT_DATE + 14
GROUP BY "UserID", "ConfReservationID", cr.reserved_seats, "Name"
HAVING SUM(pa.value) < SUM(pr.value)

UNION

SELECT u.id "UserID", u.first_name || ' ' || u.sur_name "Name", cr.id "ConfReservationID", cr.reserved_seats, SUM(pa.value) "Paid so far", SUM(pr.value) "Price"
FROM "Payments" pa
INNER JOIN "ConfReservation" cr ON cr."id_Payments"=pa.id AND cr.canceled=false
INNER JOIN "User" u ON u.id=cr."id_User" AND u.company=false
INNER JOIN "ConfReservationAndConfDay" cracd ON cracd."id_ConfReservation"=cr.id
INNER JOIN "ConfDay" cd ON cd.id=cracd."id_ConfDay"
INNER JOIN "Price" pr ON cd.id=pr."id_ConfDay" AND pr.date = cr.reservation_date
INNER JOIN "Conference" c ON c.id=cd."id_Conference" AND c.start_date > CURRENT_DATE + 14
GROUP BY "UserID", "ConfReservationID", cr.reserved_seats, "Name"
HAVING SUM(pa.value) < SUM(pr.value);
COMMENT ON VIEW public.view_not_paid IS 'Show Users that haven''t paid yet. For company, display it''s name, for not company first name and last.';
-- ddl-end --

-- object: public.add_conference | type: FUNCTION --
-- DROP FUNCTION public.add_conference(varchar,date,date,numeric,integer,numeric);
CREATE FUNCTION public.add_conference ( name varchar,  start_date date,  end_date date,  discount numeric,  seats integer,  price numeric DEFAULT -1)
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
  
  IF price>=0 THEN 
    PERFORM add_price(id_ConfDay,CURRENT_DATE,price);
  END IF;
  i = i+1;
END LOOP;

END$$;
COMMENT ON FUNCTION public.add_conference(varchar,date,date,numeric,integer,numeric) IS 'Add Conference with ConfDays and (optional) first price from CURRENT_DATE';
-- ddl-end --

-- object: public.add_user | type: FUNCTION --
-- DROP FUNCTION public.add_user(boolean,varchar,varchar,varchar,varchar,varchar,varchar);
CREATE FUNCTION public.add_user ( company boolean,  name varchar,  first_name varchar,  sur_name varchar,  login varchar,  email varchar,  password varchar)
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
-- DROP FUNCTION public.add_price(integer,date,numeric);
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
	COST 1
	AS $$INSERT INTO "Workshop"(name,start_time,end_time,seats,price,"id_ConfDay") 
VALUES(name,start_time,end_time,seats,price,id_ConfDay);$$;
-- ddl-end --

-- object: public.add_payment | type: FUNCTION --
-- DROP FUNCTION public.add_payment(integer,numeric);
CREATE FUNCTION public.add_payment ( "id_ConfReservation" integer,  value numeric)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$INSERT INTO "Payments"(value,"id_ConfReservation") VALUES(value,id_ConfReservation);$$;
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
---

