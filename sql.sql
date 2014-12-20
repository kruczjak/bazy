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
	"firstName" varchar(30),
	"surName" varchar(30),
	login varchar(30) NOT NULL,
	email varchar(40) NOT NULL,
	CONSTRAINT "pk_User" PRIMARY KEY (id),
	CONSTRAINT unique_login_email UNIQUE (login,email)

);
-- ddl-end --
-- object: public."Conference" | type: TABLE --
-- DROP TABLE public."Conference";
CREATE TABLE public."Conference"(
	id serial NOT NULL,
	"startDate" date NOT NULL,
	"endDate" date NOT NULL,
	name varchar(30) NOT NULL,
	CONSTRAINT "pk_Conference" PRIMARY KEY (id)

);
-- ddl-end --
-- object: public."ConfDay" | type: TABLE --
-- DROP TABLE public."ConfDay";
CREATE TABLE public."ConfDay"(
	id serial NOT NULL,
	seats integer NOT NULL,
	date date NOT NULL,
	"id_Conference" integer NOT NULL,
	CONSTRAINT "pk_ConfDay" PRIMARY KEY (id),
	CONSTRAINT positive_seats CHECK (seats > 0)

);
-- ddl-end --
-- object: public."Price" | type: TABLE --
-- DROP TABLE public."Price";
CREATE TABLE public."Price"(
	id serial NOT NULL,
	value numeric NOT NULL,
	date date NOT NULL,
	"id_ConfDay" integer,
	CONSTRAINT "id_Price" PRIMARY KEY (id),
	CONSTRAINT positive_value CHECK (value > 0)

);
-- ddl-end --
-- object: public."Workshop" | type: TABLE --
-- DROP TABLE public."Workshop";
CREATE TABLE public."Workshop"(
	id serial NOT NULL,
	"startTime" time NOT NULL,
	"endTime" time NOT NULL,
	seats integer NOT NULL,
	canceled boolean DEFAULT false,
	"id_ConfDay" integer NOT NULL,
	CONSTRAINT "pk_Workshop" PRIMARY KEY (id),
	CONSTRAINT positive_seats CHECK (seats > 0)

);
-- ddl-end --
-- object: public."People" | type: TABLE --
-- DROP TABLE public."People";
CREATE TABLE public."People"(
	id serial NOT NULL,
	"firstName" varchar(30) NOT NULL,
	"surName" varchar(30) NOT NULL,
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
	"reservedSeats" integer NOT NULL,
	canceled boolean DEFAULT false,
	"id_User" integer NOT NULL,
	"id_Payments" integer,
	CONSTRAINT "id_ConfReservation" PRIMARY KEY (id),
	CONSTRAINT positive_reserved_seats CHECK ("reservedSeats" > 0)

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
	"reservedSeats" integer NOT NULL,
	canceled boolean,
	"id_ConfReservation" integer NOT NULL,
	"id_Workshop" integer NOT NULL,
	CONSTRAINT "id_WorkshopReservation" PRIMARY KEY (id),
	CONSTRAINT "positive_reservedSeats" CHECK ("reservedSeats" > 0)

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
ON DELETE SET NULL ON UPDATE CASCADE;
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
	"studentCard" integer,
	"id_People" integer NOT NULL,
	"id_ConfReservation" integer NOT NULL,
	CONSTRAINT "PandCR" PRIMARY KEY (id)

);
-- ddl-end --
-- object: "People_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndConfReservation" DROP CONSTRAINT "People_fk";
ALTER TABLE public."PeopleAndConfReservation" ADD CONSTRAINT "People_fk" FOREIGN KEY ("id_People")
REFERENCES public."People" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "ConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndConfReservation" DROP CONSTRAINT "ConfReservation_fk";
ALTER TABLE public."PeopleAndConfReservation" ADD CONSTRAINT "ConfReservation_fk" FOREIGN KEY ("id_ConfReservation")
REFERENCES public."ConfReservation" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: "PeopleAndConfReservation_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PeopleAndWorkshopReservation" DROP CONSTRAINT "PeopleAndConfReservation_fk";
ALTER TABLE public."PeopleAndWorkshopReservation" ADD CONSTRAINT "PeopleAndConfReservation_fk" FOREIGN KEY ("id_PeopleAndConfReservation")
REFERENCES public."PeopleAndConfReservation" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --




