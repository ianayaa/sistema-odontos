--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: AppointmentStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AppointmentStatus" AS ENUM (
    'SCHEDULED',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED',
    'NO_SHOW'
);


ALTER TYPE public."AppointmentStatus" OWNER TO postgres;

--
-- Name: PaymentMethod; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."PaymentMethod" AS ENUM (
    'CASH',
    'CARD',
    'TRANSFER'
);


ALTER TYPE public."PaymentMethod" OWNER TO postgres;

--
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'PENDING',
    'COMPLETED',
    'CANCELLED',
    'REFUNDED'
);


ALTER TYPE public."PaymentStatus" OWNER TO postgres;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Role" AS ENUM (
    'ADMIN',
    'DENTIST',
    'ASSISTANT',
    'PATIENT'
);


ALTER TYPE public."Role" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Appointment" (
    id text NOT NULL,
    "patientId" text NOT NULL,
    "userId" text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    status public."AppointmentStatus" DEFAULT 'SCHEDULED'::public."AppointmentStatus" NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    duration integer,
    "endDate" timestamp(3) without time zone,
    "serviceId" text
);


ALTER TABLE public."Appointment" OWNER TO postgres;

--
-- Name: ClinicConfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ClinicConfig" (
    id text NOT NULL,
    "nombreClinica" text NOT NULL,
    telefono text NOT NULL,
    direccion text NOT NULL,
    correo text NOT NULL,
    horario text NOT NULL,
    "colorPrincipal" text NOT NULL,
    "logoUrl" text,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ClinicConfig" OWNER TO postgres;

--
-- Name: Consultation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Consultation" (
    id text NOT NULL,
    "patientId" text NOT NULL,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    motivo text,
    diagnostico text,
    tratamiento text,
    observaciones text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Consultation" OWNER TO postgres;

--
-- Name: DentistPayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DentistPayment" (
    id text NOT NULL,
    "dentistId" text NOT NULL,
    period text NOT NULL,
    "baseSalary" double precision NOT NULL,
    commission double precision NOT NULL,
    deductions double precision NOT NULL,
    total double precision NOT NULL,
    status text NOT NULL,
    "paymentDate" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."DentistPayment" OWNER TO postgres;

--
-- Name: DentistSchedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DentistSchedule" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "workingDays" jsonb NOT NULL,
    "startTime" text NOT NULL,
    "endTime" text NOT NULL,
    "blockedHours" jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."DentistSchedule" OWNER TO postgres;

--
-- Name: MedicalHistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MedicalHistory" (
    id text NOT NULL,
    "patientId" text NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    alergias text,
    "cigarrillosPorDia" integer,
    compania text,
    diabetes boolean,
    domicilio text,
    edad integer,
    "edadFiebreReumatica" integer,
    embarazo boolean,
    "empleoProfesion" text,
    escolaridad text,
    "estadoCivil" text,
    "fechaNacimiento" timestamp(3) without time zone,
    "fechaUltimaConsultaMedica" timestamp(3) without time zone,
    "frecuenciaCardiaca" text,
    fum timestamp(3) without time zone,
    fuma boolean,
    "interrogatorioTipo" text,
    "lugarNacimiento" text,
    "medicamentosActuales" text,
    "motivoConsulta" text,
    "motivoUltimaConsultaMedica" text,
    "nombreCompleto" text,
    "nombreInformante" text,
    ocupacion text,
    "otrasCondicionesMedicas" text,
    "padecimientoOdontologicoActual" text,
    "padecimientosGastricos" text,
    "parentescoInformante" text,
    "periodoMenstrual" text,
    "presionArterial" text,
    "procesosQuirurgicos" text,
    respuesta text,
    rh text,
    "saludGeneral" text,
    sangrado text,
    sexo text,
    "telefonoDomicilio" text,
    "telefonoOficina" text,
    temperatura text,
    "terapeuticaEmpleada" text,
    "tipoSanguineo" text,
    "tratamientosHormonales" text,
    urgencia text,
    "apellidoMaterno" text,
    "apellidoPaterno" text,
    asma boolean,
    bradicardia boolean,
    bronquitis boolean,
    cirrosis boolean,
    enfisema boolean,
    "hepatitisA" boolean,
    "hepatitisB" boolean,
    "hepatitisC" boolean,
    "hepatitisD" boolean,
    "hepatitisHigado" boolean,
    herpes boolean,
    hipertension boolean,
    hipertiroidismo boolean,
    hipotension boolean,
    hipotiroidismo boolean,
    "mesesEmbarazo" integer,
    taquicardia boolean,
    vih boolean,
    angina boolean,
    convulsiones boolean,
    cortaduras boolean,
    "diabetesControlMedico" boolean,
    "doloresPecho" boolean,
    extracciones boolean,
    "fiebreReumatica" boolean,
    infarto boolean,
    "nerviosismoDental" boolean,
    "problemasRinonUrinarias" boolean,
    "sangradoNasal" boolean
);


ALTER TABLE public."MedicalHistory" OWNER TO postgres;

--
-- Name: Patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Patient" (
    id text NOT NULL,
    name text NOT NULL,
    "lastNamePaterno" text,
    "lastNameMaterno" text,
    email text,
    phone text,
    "birthDate" timestamp(3) without time zone,
    address text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "userId" text
);


ALTER TABLE public."Patient" OWNER TO postgres;

--
-- Name: Payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Payment" (
    id text NOT NULL,
    "patientId" text NOT NULL,
    amount double precision NOT NULL,
    method public."PaymentMethod" NOT NULL,
    status public."PaymentStatus" DEFAULT 'PENDING'::public."PaymentStatus" NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Payment" OWNER TO postgres;

--
-- Name: Permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Permission" (
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Permission" OWNER TO postgres;

--
-- Name: Service; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Service" (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    duration integer NOT NULL,
    price double precision NOT NULL,
    description text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    color text
);


ALTER TABLE public."Service" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    role public."Role" DEFAULT 'PATIENT'::public."Role" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    speciality text,
    license text,
    phone text,
    "isActive" boolean DEFAULT true NOT NULL,
    "lastNameMaterno" text,
    "lastNamePaterno" text
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: UserPermission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserPermission" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "permissionId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."UserPermission" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: odontogram; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.odontogram (
    id text NOT NULL,
    "patientId" text NOT NULL,
    data jsonb NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.odontogram OWNER TO postgres;

--
-- Data for Name: Appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Appointment" (id, "patientId", "userId", date, status, notes, "createdAt", "updatedAt", duration, "endDate", "serviceId") FROM stdin;
eb7eff59-be92-4e26-887a-6bbb8fd50a8a	b7d6724f-ade9-4592-85cf-fbdd8f032c9b	55e7a281-cab1-4155-9db2-71167deeb665	2025-08-25 16:00:00	SCHEDULED		2025-05-07 22:09:24.45	2025-05-07 22:09:24.45	120	2025-08-25 18:00:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
1bed403c-d61d-41ac-9f1d-ec6393ee4e53	5daff24f-3e2f-4cbe-9edc-b0e6602de041	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-06 16:00:00	SCHEDULED		2025-05-06 00:12:26.131	2025-05-06 00:12:26.131	60	2025-05-06 17:00:00	e9e71042-0e34-4f10-87c7-f8e1957e70ee
7f0f5798-6454-45bf-a59a-7a4f2e76356d	41a0620b-2ec7-4a8e-9506-63ddd4d1f0b1	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-06 22:30:00	SCHEDULED		2025-05-06 00:13:59.027	2025-05-06 00:13:59.027	30	2025-05-06 23:00:00	15ac41c0-0bd7-4b77-b9b9-5e7ca87c5263
ab3d0352-595b-43c3-a3fe-883565e22e2b	1b2251ed-8e4f-4595-ad0c-7d74d5ab4b5c	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-07 16:00:00	SCHEDULED		2025-05-06 00:31:05.702	2025-05-06 00:31:05.702	60	2025-05-07 17:00:00	302235da-4fad-46ef-8ced-d9f02692ced6
749fd0a1-5c05-4272-a8ed-63d2bc4c6762	b7d6724f-ade9-4592-85cf-fbdd8f032c9b	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-07 22:00:00	SCHEDULED		2025-05-06 00:32:27.174	2025-05-06 00:32:27.174	60	2025-05-07 23:00:00	302235da-4fad-46ef-8ced-d9f02692ced6
ee11d407-a1ba-47c5-9292-87d5ac1005b6	f28ddbe5-7567-441b-bf37-22245d6d20f3	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-08 21:00:00	SCHEDULED		2025-05-06 00:33:39.173	2025-05-06 00:33:39.173	60	2025-05-08 22:00:00	302235da-4fad-46ef-8ced-d9f02692ced6
7e6258d1-8707-441e-86d0-9428adefe1c2	740bbc1d-9f13-47d0-9064-780ae7e521f0	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-08 22:15:00	SCHEDULED		2025-05-06 00:35:11.567	2025-05-06 00:35:11.567	75	2025-05-08 23:30:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
1cae36dd-2a3b-4cb4-8c16-f1d84317a336	95084963-ea97-46c4-8652-1b717f549acc	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-09 23:00:00	SCHEDULED		2025-05-06 00:36:02.391	2025-05-06 00:36:02.391	15	2025-05-09 23:15:00	cd98c738-b188-4e51-8f1f-65a5c4fa5463
12097f9d-14ed-4784-bcc4-8ed7cf2599db	cdae144a-aa82-434e-af4e-97b505a61742	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-17 17:00:00	SCHEDULED		2025-05-06 00:43:20.686	2025-05-06 00:43:20.686	60	2025-05-17 18:00:00	a97018a1-609a-4baf-a77c-3dfec05c9163
fc9d0523-d9b6-42a8-b4b1-c119f9a05b75	b31cc161-a81f-472d-a9e6-87270bc4f73f	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-19 22:00:00	SCHEDULED		2025-05-06 00:45:10.548	2025-05-06 00:45:10.548	60	2025-05-19 23:00:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
57719d4e-9193-4062-8623-916cd3815b10	257bca77-a606-4420-b904-bd0a56936c8e	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-15 23:00:00	SCHEDULED		2025-05-06 21:12:45.14	2025-05-06 21:12:45.14	30	2025-05-15 23:30:00	38f83905-3a90-4d5b-b3f7-ec5646de6f4f
3633cd73-c404-4c4f-8ce7-a2fb7373f626	bec6e71b-727e-459c-a961-00f5725c2bc3	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-15 23:30:00	SCHEDULED		2025-05-06 21:17:32.983	2025-05-06 21:17:32.983	30	2025-05-16 00:00:00	38f83905-3a90-4d5b-b3f7-ec5646de6f4f
53cb6bf3-4baa-425f-88cd-49f5d4930792	f0920fd1-e258-4588-9b07-9e544792ede3	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-06 21:00:00	SCHEDULED		2025-05-06 21:19:01.552	2025-05-06 21:19:01.552	60	2025-05-06 22:00:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
2e905263-11c0-4ae6-ab3c-eb6dfa9f72ea	f0920fd1-e258-4588-9b07-9e544792ede3	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-09 23:30:00	SCHEDULED		2025-05-06 21:34:08.012	2025-05-06 21:34:08.012	30	2025-05-10 00:00:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
407681f0-adb7-478a-8965-c5f0d8db3ba5	5daff24f-3e2f-4cbe-9edc-b0e6602de041	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-09 16:00:00	SCHEDULED		2025-05-06 17:27:51.261	2025-05-07 05:11:21.248	60	2025-05-09 17:00:00	e9e71042-0e34-4f10-87c7-f8e1957e70ee
e411fae7-5a91-4d8a-b3ad-f29a54b16771	ec868803-a731-4539-8d11-44d90026586d	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-16 00:30:00	SCHEDULED		2025-05-07 15:10:24.195	2025-05-07 15:10:24.195	15	2025-05-16 00:45:00	38f83905-3a90-4d5b-b3f7-ec5646de6f4f
b5027139-4f1e-4bdf-82bf-0058357587c6	dfd9deeb-c65b-48e2-bb38-3acaaa98301d	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-08 16:00:00	SCHEDULED		2025-05-07 18:15:52.143	2025-05-07 18:15:52.143	45	2025-05-08 16:45:00	a97018a1-609a-4baf-a77c-3dfec05c9163
82ec1904-07e0-4563-b0e0-c7f26a2d2903	f28ddbe5-7567-441b-bf37-22245d6d20f3	55e7a281-cab1-4155-9db2-71167deeb665	2025-06-21 18:00:00	SCHEDULED		2025-05-08 21:19:42.525	2025-05-08 21:19:42.525	60	2025-06-21 19:00:00	5d10eb55-3bee-4f96-870b-0e8d86170a20
c72cc10e-a91b-4088-8bc1-9f30263f3841	740bbc1d-9f13-47d0-9064-780ae7e521f0	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-15 20:45:00	SCHEDULED		2025-05-08 22:21:22.351	2025-05-08 22:21:22.351	45	2025-05-15 21:30:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
c435bf5c-703b-4145-afcb-4e0dd0787c2e	f886fa50-1529-4a98-bb1e-d24c8dab7f97	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-09 17:15:00	SCHEDULED		2025-05-09 16:45:43.081	2025-05-09 16:45:43.081	15	2025-05-09 17:30:00	a97018a1-609a-4baf-a77c-3dfec05c9163
6a40e5d8-248d-4040-be3e-fbb4f54530c7	392d8e20-ffc7-400f-84d9-cbfd3d088cb7	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-17 18:00:00	SCHEDULED		2025-05-09 19:15:14.25	2025-05-09 19:15:14.25	60	2025-05-17 19:00:00	5d10eb55-3bee-4f96-870b-0e8d86170a20
5bf390e0-302c-4410-bef0-a93763d913c0	0c8713a5-a91e-42e3-a5ea-8b0e2d0358ec	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-15 22:30:00	SCHEDULED		2025-05-10 00:27:19.236	2025-05-10 00:27:19.236	30	2025-05-15 23:00:00	d606d483-81de-4adc-88ed-0248a307845e
f4f26c38-5428-49c7-bfe1-c6a73adf8d1d	5daff24f-3e2f-4cbe-9edc-b0e6602de041	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-16 16:00:00	SCHEDULED		2025-05-13 23:46:49.495	2025-05-13 23:46:49.495	60	2025-05-16 17:00:00	e9e71042-0e34-4f10-87c7-f8e1957e70ee
90a3e589-8a52-42fe-90b4-d1ce2226fe75	b08bf7a8-0aa1-4d52-9510-72242d4142a2	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-16 17:00:00	SCHEDULED		2025-05-16 00:17:27.619	2025-05-16 00:17:27.619	60	2025-05-16 18:00:00	a97018a1-609a-4baf-a77c-3dfec05c9163
bddfcc6e-5a49-4857-91fb-3215822a583b	b0e51ed7-7178-4eb7-b829-1fd9d3f46f51	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-16 18:00:00	SCHEDULED		2025-05-16 00:17:59.097	2025-05-16 00:17:59.097	60	2025-05-16 19:00:00	e9e71042-0e34-4f10-87c7-f8e1957e70ee
5158ed40-b902-42ed-ae12-c25994ac5460	740bbc1d-9f13-47d0-9064-780ae7e521f0	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-16 21:00:00	SCHEDULED		2025-05-16 00:18:46.825	2025-05-16 00:18:46.825	45	2025-05-16 21:45:00	8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9
2ac52aae-439c-4d6e-b162-84dca1aaefaa	95084963-ea97-46c4-8652-1b717f549acc	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-17 16:00:00	SCHEDULED		2025-05-16 00:20:04.756	2025-05-16 00:20:04.756	60	2025-05-17 17:00:00	cd98c738-b188-4e51-8f1f-65a5c4fa5463
7014b573-8952-45b6-a29f-7e7f347b3815	bec6e71b-727e-459c-a961-00f5725c2bc3	55e7a281-cab1-4155-9db2-71167deeb665	2025-06-17 23:00:00	SCHEDULED		2025-05-16 01:23:40.216	2025-05-16 01:23:40.216	30	2025-06-17 23:30:00	38f83905-3a90-4d5b-b3f7-ec5646de6f4f
aa13ad8f-1b01-4ebf-bd5b-5fdf99e5bc62	85590c3b-c61f-4537-a81d-249b94c8e7ce	55e7a281-cab1-4155-9db2-71167deeb665	2025-05-24 17:00:00	SCHEDULED		2025-05-16 15:26:28.768	2025-05-16 15:26:28.768	60	2025-05-24 18:00:00	78e9336d-706a-4592-a93e-98c4bc5b9775
b1f394a3-48e2-4560-b249-46dcdb1086ea	257bca77-a606-4420-b904-bd0a56936c8e	55e7a281-cab1-4155-9db2-71167deeb665	2025-06-17 23:30:00	SCHEDULED		2025-05-16 00:04:52.555	2025-05-16 15:37:42.649	30	2025-06-18 00:00:00	38f83905-3a90-4d5b-b3f7-ec5646de6f4f
\.


--
-- Data for Name: ClinicConfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ClinicConfig" (id, "nombreClinica", telefono, direccion, correo, horario, "colorPrincipal", "logoUrl", "updatedAt") FROM stdin;
2024f569-6917-4c19-953e-754369d2e599	Odontos					#b91c1c		2025-04-30 21:23:25.447
\.


--
-- Data for Name: Consultation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Consultation" (id, "patientId", date, motivo, diagnostico, tratamiento, observaciones, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: DentistPayment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DentistPayment" (id, "dentistId", period, "baseSalary", commission, deductions, total, status, "paymentDate", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: DentistSchedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DentistSchedule" (id, "userId", "workingDays", "startTime", "endTime", "blockedHours", "createdAt", "updatedAt") FROM stdin;
750657d1-aae0-4280-bb90-ca13c35265cb	43393c65-c4b1-4b6d-9df1-dcbe568cde72	[1, 2, 3, 4, 5, 6]	10:00	18:00	[]	2025-05-02 18:38:19.197	2025-05-05 23:29:12.831
59d6ada2-e484-4c43-b307-c532d8c66b90	55e7a281-cab1-4155-9db2-71167deeb665	[1, 2, 3, 4, 5, 6]	10:00	20:00	[{"end": "13:00", "date": "2025-05-10", "start": "10:00"}, {"end": "23:59", "date": "2025-05-12", "start": "00:00"}, {"end": "23:59", "date": "2025-05-13", "start": "00:00"}]	2025-05-06 00:36:12.398	2025-05-10 00:19:13.872
\.


--
-- Data for Name: MedicalHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MedicalHistory" (id, "patientId", notes, "createdAt", "updatedAt", alergias, "cigarrillosPorDia", compania, diabetes, domicilio, edad, "edadFiebreReumatica", embarazo, "empleoProfesion", escolaridad, "estadoCivil", "fechaNacimiento", "fechaUltimaConsultaMedica", "frecuenciaCardiaca", fum, fuma, "interrogatorioTipo", "lugarNacimiento", "medicamentosActuales", "motivoConsulta", "motivoUltimaConsultaMedica", "nombreCompleto", "nombreInformante", ocupacion, "otrasCondicionesMedicas", "padecimientoOdontologicoActual", "padecimientosGastricos", "parentescoInformante", "periodoMenstrual", "presionArterial", "procesosQuirurgicos", respuesta, rh, "saludGeneral", sangrado, sexo, "telefonoDomicilio", "telefonoOficina", temperatura, "terapeuticaEmpleada", "tipoSanguineo", "tratamientosHormonales", urgencia, "apellidoMaterno", "apellidoPaterno", asma, bradicardia, bronquitis, cirrosis, enfisema, "hepatitisA", "hepatitisB", "hepatitisC", "hepatitisD", "hepatitisHigado", herpes, hipertension, hipertiroidismo, hipotension, hipotiroidismo, "mesesEmbarazo", taquicardia, vih, angina, convulsiones, cortaduras, "diabetesControlMedico", "doloresPecho", extracciones, "fiebreReumatica", infarto, "nerviosismoDental", "problemasRinonUrinarias", "sangradoNasal") FROM stdin;
9b988718-c1dc-4a0a-aa14-6d332640038f	e2b4cfb8-307c-42d8-869a-412583f4d6d2	\N	2025-05-03 21:13:21.701	2025-05-03 22:08:42.564		\N		f		\N	\N	f				\N	2025-05-03 00:00:00		\N	f				caries		Jorge				caries			NO																	f	f	f	f	f	f	f	f	f	f	f	f	f	f	f	\N	f	f	f	f	f	f	f	f	f	f	f	f	f
\.


--
-- Data for Name: Patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Patient" (id, name, "lastNamePaterno", "lastNameMaterno", email, phone, "birthDate", address, "createdAt", "updatedAt", "userId") FROM stdin;
9213d1be-0808-4fa6-8fef-729f8809edd8	Abel	Pantoja Pacheco		\N	\N	2009-01-12 00:00:00		2025-05-03 20:50:49.341	2025-05-03 20:50:49.341	\N
3fe05cb6-b8f3-43ce-b7f5-0f1f793553fe	Abel	Pantoja Pacheco		\N	\N	2009-01-14 00:00:00		2025-05-03 20:50:49.343	2025-05-03 20:50:49.343	\N
2e7b78bb-a922-43de-9091-b212fd7c418b	Abel	Pillado Meza		\N	\N	\N		2025-05-03 20:50:49.344	2025-05-03 20:50:49.344	\N
15709442-cd2e-4b66-8293-bb93a1092306	Abrahaam	Angulo Martínez		\N	\N	2007-11-12 00:00:00		2025-05-03 20:50:49.344	2025-05-03 20:50:49.344	\N
7056da3d-5067-4c7b-a128-0144179c957b	Abel	Ceron Jimenez		\N	\N	2007-05-31 00:00:00		2025-05-03 20:50:49.345	2025-05-03 20:50:49.345	\N
6634691b-92ec-4c3e-81d3-3dec60edf2b2	Abad	Tagle Valente		\N	\N	1957-12-05 00:00:00		2025-05-03 20:50:49.346	2025-05-03 20:50:49.346	\N
d193c125-762d-43eb-95bd-e3aa8105fb42	Abel	Uribe Navarro		\N	\N	1955-10-12 00:00:00		2025-05-03 20:50:49.346	2025-05-03 20:50:49.346	\N
b7d4e726-c9f3-41f3-8344-33c4cd781938	Abel	Morales Morales		abelbar52@yahoo.com.	\N	1979-03-17 00:00:00		2025-05-03 20:50:49.347	2025-05-03 20:50:49.347	\N
063c489b-a1da-4b1a-b742-97221ee47ff5	Abelardo	Castillo Rosas		abecito@gmail.com	\N	1959-05-31 00:00:00		2025-05-03 20:50:49.347	2025-05-03 20:50:49.347	\N
08650908-c15d-4bdf-879b-8e477175b118	Abel	Garcia Camarillo		\N	8141187626	\N		2025-05-03 20:50:49.347	2025-05-03 20:50:49.347	\N
63f4092c-4c2c-4d1a-b4ef-75127145cbb3	Abel	Sandoval Gómez		abelsan1@hotmail.com	\N	1981-11-12 00:00:00		2025-05-03 20:50:49.348	2025-05-03 20:50:49.348	\N
01d5deb1-201d-4e4d-b64c-46c06f248699	Abelina	Garcia Perez		\N	\N	2011-04-09 00:00:00		2025-05-03 20:50:49.348	2025-05-03 20:50:49.348	\N
de843316-0a07-4356-99fc-abf71a620b08	Abigail	Casterline		\N	+17168607839	\N		2025-05-03 20:50:49.348	2025-05-03 20:50:49.348	\N
b05816a4-404b-4885-992f-7b0ae1037a0a	Abigail	Rodriguez		\N	\N	\N		2025-05-03 20:50:49.349	2025-05-03 20:50:49.349	\N
3ae4a788-4f2c-4da5-8e7f-48308ce05f71	Abigail	Salasar ortiz		picail_aby83@hotmail.com	\N	1983-05-07 00:00:00		2025-05-03 20:50:49.349	2025-05-03 20:50:49.349	\N
de5a37e1-e502-4afc-b68f-709865acc44f	Abraham	Aparicio Llamas		\N	\N	1995-03-05 00:00:00		2025-05-03 20:50:49.35	2025-05-03 20:50:49.35	\N
5a771dac-4037-4537-8708-be8977cfba57	´Fernando	Hernández Olvera		\N	5541349162	\N		2025-05-03 20:50:49.35	2025-05-03 20:50:49.35	\N
4a880f74-5ea9-4295-b48b-d9bc6d695aa5	Abraham	Figeroa Moreno		\N	\N	\N		2025-05-03 20:50:49.351	2025-05-03 20:50:49.351	\N
6f1f18de-1260-4d0a-a4f1-5d907eb70d02	Alejandro	Quezada	Rojo		3221357422	1984-05-23 00:00:00		2025-05-03 20:50:49.403	2025-05-03 20:51:51.933	\N
048acf86-d603-42bb-a023-4a37f6acb718	abraham	Gonzales Estrada		\N	\N	2009-09-09 00:00:00		2025-05-03 20:50:49.351	2025-05-03 20:50:49.351	\N
02d39e81-4504-4ef5-8b39-0557e663dcdc	Abraham	Masiel Martinez		\N	\N	2007-12-20 00:00:00		2025-05-03 20:50:49.351	2025-05-03 20:50:49.351	\N
f5f0a688-6902-4af5-9ee2-9707a83cbe37	Adan	Suarez Hernández		facturas.glaumoroso@hotmail.com	\N	1989-02-12 00:00:00		2025-05-03 20:50:49.352	2025-05-03 20:50:49.352	\N
e850ef07-7491-40fc-9cbb-e91df7e3fea1	Abraham	Reyes Becerra		arq.abraham.reyes@gmail.com	\N	1981-03-16 00:00:00		2025-05-03 20:50:49.352	2025-05-03 20:50:49.352	\N
553c79e8-34f4-4dd3-84a4-20321402564c	abram	Morales Calzada		\N	\N	2007-03-15 00:00:00		2025-05-03 20:50:49.353	2025-05-03 20:50:49.353	\N
129d569e-7d9e-4cc6-b952-d78411373ba8	Abram SAir	Vazquez Vargas		\N	\N	2012-10-31 00:00:00		2025-05-03 20:50:49.353	2025-05-03 20:50:49.353	\N
85602e4f-558b-4495-8d03-c7d617ff041f	Abril	Casillas Romano		abrilromano@hotmail.com	\N	\N		2025-05-03 20:50:49.354	2025-05-03 20:50:49.354	\N
356a1fc0-f0cb-434c-b4b9-f27e3cb3f55a	Abril	Ramos Hernandez		abril.iyari@gmail.com	\N	1990-07-19 00:00:00		2025-05-03 20:50:49.354	2025-05-03 20:50:49.354	\N
66d77115-113e-4028-bc4a-8763646c5d0a	Ada	Aguirre		\N	\N	\N		2025-05-03 20:50:49.355	2025-05-03 20:50:49.355	\N
9ae03b34-3b2a-455c-9733-39587f7ded5b	Adalberto	Lòpez Lòpez		\N	\N	1950-04-22 00:00:00		2025-05-03 20:50:49.355	2025-05-03 20:50:49.355	\N
071db55e-5b27-438c-9dd0-1cd6ebc00e8a	Abraham	Pérez Gómez		\N	5560707727	\N		2025-05-03 20:50:49.355	2025-05-03 20:50:49.355	\N
66e1086f-cfb4-404c-a430-f8a7554a57fa	Abraham	Mendoza Nepumuceno		\N	\N	1930-03-16 00:00:00		2025-05-03 20:50:49.356	2025-05-03 20:50:49.356	\N
001105ab-fc3a-43c1-a9a1-90a856430227	Abraham	Castro Castro		\N	7411144248	\N		2025-05-03 20:50:49.356	2025-05-03 20:50:49.356	\N
e2b4cfb8-307c-42d8-869a-412583f4d6d2	Jorge Ivan	Anaya 	Herrera	ianaya813@gmail.com	3222628090	2003-07-08 00:00:00		2025-05-03 20:50:50.09	2025-05-04 06:41:14.698	\N
a57316b4-6042-49c9-a193-433bc867d346	Gabriela Anali	Quezada 	Herrera	analiquezadaherrera@gmail.com	+523221007891	2004-08-17 00:00:00		2025-05-03 20:50:49.895	2025-05-03 23:38:18.968	\N
efe6000e-7396-4c55-a8f0-6d90e4fb3ed9	Adilene	Zamora Suarez		\N	\N	1989-05-19 00:00:00		2025-05-03 20:50:49.359	2025-05-03 20:50:49.359	\N
a54f74bf-4d87-4a5c-b15b-ca69d657f9c6	Adda Lucy del Socorro	Raygosa Chab		\N	\N	1954-11-20 00:00:00		2025-05-03 20:50:49.356	2025-05-03 20:50:49.356	\N
0c00a795-b29f-4e8a-bebe-524f96608988	Adela	Torres Raimundo		\N	\N	\N		2025-05-03 20:50:49.357	2025-05-03 20:50:49.357	\N
68eed633-cd74-495e-86b9-37a8170f93ae	Adrian	Monticone		digitaladvice@live.com.ar	\N	1971-06-25 00:00:00		2025-05-03 20:50:49.357	2025-05-03 20:50:49.357	\N
b09ff91d-1527-4cc2-8c78-18d7da31b9ad	Adelaide	Pashley		\N	\N	2010-05-16 00:00:00		2025-05-03 20:50:49.357	2025-05-03 20:50:49.357	\N
11c73b2f-7738-4e90-a64c-70f5f6725532	Adelina	Garcìa Perez		\N	\N	2011-04-01 00:00:00		2025-05-03 20:50:49.358	2025-05-03 20:50:49.358	\N
e375cf62-f410-4d43-8e6b-e5ea6b0089da	Adrian	Tabarez Lopez		\N	\N	2009-08-27 00:00:00		2025-05-03 20:50:49.358	2025-05-03 20:50:49.358	\N
121ecadc-a8e7-4d8d-93e8-178c94b28655	Adrian	Valdes Uriza		\N	\N	2008-12-29 00:00:00		2025-05-03 20:50:49.359	2025-05-03 20:50:49.359	\N
955227b0-1dc5-4c53-b60e-9568d3289410	Adrian Arturo	Martinez Medina		\N	\N	2012-03-01 00:00:00		2025-05-03 20:50:49.36	2025-05-03 20:50:49.36	\N
55de2e53-c7b2-4d71-a820-75a0309c66bc	Adina	Tataru		tatarica202@yahoo.co.uk	\N	1976-05-15 00:00:00		2025-05-03 20:50:49.36	2025-05-03 20:50:49.36	\N
d888c29d-e888-497e-b286-7ffb1d9000e0	Adolfo	Sandoval Luna		alfo1970@aol.com.mx	\N	1970-05-08 00:00:00		2025-05-03 20:50:49.36	2025-05-03 20:50:49.36	\N
b1dd8bbd-bbe7-4326-8f80-e97b6026f6f0	Adaluci	Raigosa Chab		\N	\N	1954-11-20 00:00:00		2025-05-03 20:50:49.361	2025-05-03 20:50:49.361	\N
6b693ad0-6f0c-4af1-ae00-b1b4d5c92a98	Adrian	Gonzalez Castillo		\N	3335020551	\N		2025-05-03 20:50:49.361	2025-05-03 20:50:49.361	\N
c7290e44-be02-4eab-9a8a-549d150e702e	Adriana	Infante		\N	\N	\N		2025-05-03 20:50:49.362	2025-05-03 20:50:49.362	\N
f5505b00-a352-46fa-9052-190d93f5f1b5	Adaney	Samayoa Melgar		\N	\N	2009-07-02 00:00:00		2025-05-03 20:50:49.362	2025-05-03 20:50:49.362	\N
6c9965d5-2ef2-45ec-bff4-6ff5cddfb95a	Adrian	Mendez Ramos		\N	0445511497142	1967-05-05 00:00:00		2025-05-03 20:50:49.362	2025-05-03 20:50:49.362	\N
79fc91ce-c4c0-4106-93d4-86fb29d64755	Adolfo	Reimer		\N	+16045515886	\N		2025-05-03 20:50:49.363	2025-05-03 20:50:49.363	\N
4de22590-f15d-4c71-b034-643d4fa53d23	Adrian	Provenza		adrianpza@gmail.com	\N	1978-12-05 00:00:00		2025-05-03 20:50:49.363	2025-05-03 20:50:49.363	\N
bd919219-4706-41ae-ba4b-29d083a3a980	Adrian	Valades		\N	\N	\N		2025-05-03 20:50:49.363	2025-05-03 20:50:49.363	\N
ad50a14d-df37-42dc-aa1a-f815f3700419	Adriana	Godoy Lomelí		refadriana@hotmail.com	\N	1968-08-04 00:00:00		2025-05-03 20:50:49.364	2025-05-03 20:50:49.364	\N
25ebac37-ba2a-479b-826d-a28aa4310539	Adriana	gomez quintero		\N	\N	1971-04-21 00:00:00		2025-05-03 20:50:49.364	2025-05-03 20:50:49.364	\N
1915588d-a9ce-40cc-ba5d-3a6bacff7234	Adriana	Hernandez Carrillo		mexicanaciega@gmail.com	\N	1968-03-05 00:00:00		2025-05-03 20:50:49.364	2025-05-03 20:50:49.364	\N
4c28075e-70fd-4607-9e6a-4257ab79f6bc	Adriana	Plascencia Jimenez		\N	\N	1987-11-09 00:00:00		2025-05-03 20:50:49.365	2025-05-03 20:50:49.365	\N
7f1e62e7-5209-4df7-9e62-b2178b93dd11	Adriana	Hernández Hernández		\N	\N	2009-05-15 00:00:00		2025-05-03 20:50:49.365	2025-05-03 20:50:49.365	\N
d67f2b87-2af2-4f6a-92db-df3f20bab4e2	Adriana	Hernández Pérez		\N	\N	\N		2025-05-03 20:50:49.365	2025-05-03 20:50:49.365	\N
2122756d-10c3-4cbc-b523-961d6d63137f	Adrian	Ortega Juarez		\N	+15038750394	\N		2025-05-03 20:50:49.366	2025-05-03 20:50:49.366	\N
1f6f4126-abc2-4908-9731-19fab72c78cc	Adriana	Marquez Cruz		\N	\N	1974-10-02 00:00:00		2025-05-03 20:50:49.366	2025-05-03 20:50:49.366	\N
4b40f8dd-622a-409a-bb91-c5296febcffe	Adriana	Mesa Morales		adry.radiologo@outlook.com	\N	1976-06-05 00:00:00		2025-05-03 20:50:49.366	2025-05-03 20:50:49.366	\N
b65bd04e-e2c4-4515-a86f-5a7e15e6e1b0	Adriana	Mora Santos		\N	\N	\N		2025-05-03 20:50:49.367	2025-05-03 20:50:49.367	\N
496ebd98-6926-4675-a17f-9245941c2c14	Adriana	Olvera Robles		\N	\N	\N		2025-05-03 20:50:49.367	2025-05-03 20:50:49.367	\N
242820df-aee2-483e-882a-d30d3503b6c3	Adriana	Ovando Rodriguez		\N	\N	2006-03-15 00:00:00		2025-05-03 20:50:49.367	2025-05-03 20:50:49.367	\N
c025b7b6-e06b-40cb-9c47-751589bc22ef	Adriana	Partida Rodriguez		adrix_lili@hotmail.com	\N	1985-03-27 00:00:00		2025-05-03 20:50:49.367	2025-05-03 20:50:49.367	\N
e2527b31-bd4f-4629-93bb-b013f7bb80f4	Adriana	Velazquez Burciaga		\N	\N	2006-12-05 00:00:00		2025-05-03 20:50:49.368	2025-05-03 20:50:49.368	\N
2b506145-9cb5-4f3b-9a5c-bea5391169ce	Adriana Jaqueline	Avalos de Franco		safm30@hotmail.com	\N	\N		2025-05-03 20:50:49.368	2025-05-03 20:50:49.368	\N
c9c39bd1-2939-4942-9e0a-11687375bd0e	Adriana Monzerrat	Bañuelos Godoy		ambg_monze@hotmail.com	3221801462	1998-04-14 00:00:00		2025-05-03 20:50:49.368	2025-05-03 20:50:49.368	\N
7ed5021e-c26e-4804-aa7d-8177a573ef22	Adriana	Ramirez Alanis		\N	\N	2005-09-22 00:00:00		2025-05-03 20:50:49.369	2025-05-03 20:50:49.369	\N
cae17032-5bd5-4940-b30d-2a30da9f0a4f	Adriana	Reyes Magaña		\N	\N	2009-04-27 00:00:00		2025-05-03 20:50:49.369	2025-05-03 20:50:49.369	\N
b4766762-f815-4a8d-aa82-c46b80f5b529	Adriana	Rodriguez Castañeda		\N	\N	\N		2025-05-03 20:50:49.37	2025-05-03 20:50:49.37	\N
f19b31d0-6104-496b-9da1-950ac5bdf4eb	Adriana	Legorreta Gutierrez		alegorretag@intercam.cpm.mx	3221576496	1956-03-27 00:00:00		2025-05-03 20:50:49.37	2025-05-03 20:50:49.37	\N
09527259-6a29-465a-97bd-98b1e554c19e	Adriana	Lizarraga Lerma		\N	\N	\N		2025-05-03 20:50:49.37	2025-05-03 20:50:49.37	\N
74584ff1-4ce1-4504-8976-cd66750b9dd4	Adriana	Romo Gonzalez		\N	\N	1976-06-15 00:00:00		2025-05-03 20:50:49.371	2025-05-03 20:50:49.371	\N
02c27665-f83d-4d66-bd1f-a0334de392d8	Adriana	Ruiz de Paz		adrianaruizdepaz9@gmai.com	\N	1991-09-06 00:00:00		2025-05-03 20:50:49.371	2025-05-03 20:50:49.371	\N
df93b3ce-4011-46ed-bcc8-006ca2992d21	Aida	Magaña Bernal		\N	\N	1983-05-27 00:00:00		2025-05-03 20:50:49.371	2025-05-03 20:50:49.371	\N
adf92f65-2db7-41d8-8a30-4de3eb503d45	Adriana	Santiago Cabrera		\N	\N	1963-03-06 00:00:00		2025-05-03 20:50:49.372	2025-05-03 20:50:49.372	\N
bdaf548f-a484-4709-afda-4dd054f6c67a	Adriana	Tejeda Hernandez		\N	\N	1984-06-09 00:00:00		2025-05-03 20:50:49.372	2025-05-03 20:50:49.372	\N
cd774242-134e-4496-b7d1-995c3204f6b9	Adriana	Torres  Venegas		adriana_guera22@hotmail.com	3318480320	1994-07-22 00:00:00		2025-05-03 20:50:49.372	2025-05-03 20:50:49.372	\N
cd6ec668-96f0-4d35-b1fe-44885cd11c25	Adalberto	Zanabria Ruíz		\N	3222272341	\N		2025-05-03 20:50:49.373	2025-05-03 20:50:49.373	\N
be044ced-5d5d-43fc-9e30-b2d31d46b13b	Afredo	Grimaldi Lopez		agrimaldi@truper.com.	\N	1974-09-09 00:00:00		2025-05-03 20:50:49.373	2025-05-03 20:50:49.373	\N
0f1c1ee6-abcb-4873-be4d-5d92bcecd97c	Agapito	Mesa Arechiga		\N	\N	\N		2025-05-03 20:50:49.373	2025-05-03 20:50:49.373	\N
113726dc-1412-4139-bae5-d62e89cccc81	Adam Saúl	Collazo Arana		\N	3221686082	\N		2025-05-03 20:50:49.374	2025-05-03 20:50:49.374	\N
8570970a-4bc0-491a-8d7d-a07ffecf0578	Ailine	Vannoland		aileenvn1@yahoo.com	+19164108651	1957-05-15 00:00:00		2025-05-03 20:50:49.374	2025-05-03 20:50:49.374	\N
786b89f5-442b-4185-a54e-55d217033662	Aime Guadalupe	Saucedo Bernal		\N	\N	2007-04-11 00:00:00		2025-05-03 20:50:49.374	2025-05-03 20:50:49.374	\N
1ab7bafc-5b95-4913-971e-1b909bb853a9	Agustin	Castro Posada		\N	\N	1975-03-29 00:00:00		2025-05-03 20:50:49.374	2025-05-03 20:50:49.374	\N
96640f2e-3b9f-4501-8eae-89d005c4e563	Adriana	Romero Ronstadt		\N	\N	1959-11-27 00:00:00		2025-05-03 20:50:49.375	2025-05-03 20:50:49.375	\N
845204d5-6cdd-43f2-8d46-57a6a250d0fd	Ahui	Peña Herréra		\N	\N	1977-12-17 00:00:00		2025-05-03 20:50:49.375	2025-05-03 20:50:49.375	\N
a6df1921-19c6-430f-aaa3-041595fa79b5	Aida	Reyes Sastre		gricelissste@hotmail.com	\N	1980-12-23 00:00:00		2025-05-03 20:50:49.375	2025-05-03 20:50:49.375	\N
467eda8e-9bf3-4b66-938a-0486b2bad1de	Aida Edelmira	Ortuño Cota		\N	\N	1936-04-06 00:00:00		2025-05-03 20:50:49.376	2025-05-03 20:50:49.376	\N
098e0fa4-c9ab-4c44-af23-26b000741ed9	Aiden	García Navarro		\N	\N	\N		2025-05-03 20:50:49.376	2025-05-03 20:50:49.376	\N
9a5855b0-15dd-4711-84e4-b0d559323695	Ailde Sofia	Florez Meza		\N	\N	2008-08-20 00:00:00		2025-05-03 20:50:49.376	2025-05-03 20:50:49.376	\N
99128a95-2c15-4afd-aebf-0edf78b4cd92	Ailet Sophia	Florez Meza		\N	3221399828	\N		2025-05-03 20:50:49.377	2025-05-03 20:50:49.377	\N
ee5140c6-098f-4638-afd7-dac7e45c9264	Ailed Eunice	Meza Lazareno		amor.amor335@gmail.com	\N	1981-03-16 00:00:00		2025-05-03 20:50:49.377	2025-05-03 20:50:49.377	\N
1f133aec-53ab-4c37-9753-31dccc2e6e86	Alan	Bayliss		alanbayliss@gmai.com	\N	1952-10-29 00:00:00		2025-05-03 20:50:49.377	2025-05-03 20:50:49.377	\N
cee87374-8648-44ef-bbb0-231d87b481c6	Agustin	Sanchez Olmedo		\N	\N	1949-04-24 00:00:00		2025-05-03 20:50:49.378	2025-05-03 20:50:49.378	\N
033d9541-a306-4e37-ae6e-ea931032f958	Agustina	Espino Romero		a.espino@itzapublicidad.com	\N	1974-05-08 00:00:00		2025-05-03 20:50:49.378	2025-05-03 20:50:49.378	\N
cab7ef0c-c03a-465f-93ae-57de7eae239d	Alan Arturo	Rangel Ceguero		\N	\N	1983-08-16 00:00:00		2025-05-03 20:50:49.378	2025-05-03 20:50:49.378	\N
17c1aed4-7191-41ab-9880-df89c09bdfac	Adrian	Gonzalez Cruz		\N	3221071239	\N		2025-05-03 20:50:49.379	2025-05-03 20:50:49.379	\N
9f3883bd-1922-4baf-969e-f59d5dc5d59f	Adriana Monzerrat	Bañuelos Godoy		ambgmonze@gmail.com	+523221801462	\N		2025-05-03 20:50:49.379	2025-05-03 20:50:49.379	\N
32e96cc7-85bd-480e-a051-b930bdee010a	Alain	Francoeur		\N	\N	\N		2025-05-03 20:50:49.379	2025-05-03 20:50:49.379	\N
b5f5d88e-0b90-444e-a183-086428f2a46c	Alana	Fluchler		\N	\N	\N		2025-05-03 20:50:49.38	2025-05-03 20:50:49.38	\N
262c352a-305f-4c41-8b45-a073190f37c9	Alba	Lopez Rodriguez		albilla26@hotmal.com	\N	1978-02-26 00:00:00		2025-05-03 20:50:49.38	2025-05-03 20:50:49.38	\N
2726e013-06dc-4851-9908-9fb916ceae9b	Alain	Lavoie		\N	\N	1967-04-25 00:00:00		2025-05-03 20:50:49.38	2025-05-03 20:50:49.38	\N
44e035d7-4e03-4968-90c2-ec12dea2d027	Alain	Roy		\N	\N	1950-08-31 00:00:00		2025-05-03 20:50:49.381	2025-05-03 20:50:49.381	\N
7ee94925-a6ea-42c6-bcbb-6b90b0516d40	Alan Isai	Rubio Gonzalez		spareservationscv@velasresorts.com	+523327930104	\N		2025-05-03 20:50:49.381	2025-05-03 20:50:49.381	\N
82a2eac1-c871-482d-83e8-484b98cd2307	Alberta	Ruiz		\N	\N	1968-11-15 00:00:00		2025-05-03 20:50:49.381	2025-05-03 20:50:49.381	\N
2e388866-d3d7-42c1-9af9-3ce231814bb7	Alberto	Fernandez Barasa		jesus_fernamdez720@hotmail.com	\N	1987-12-24 00:00:00		2025-05-03 20:50:49.382	2025-05-03 20:50:49.382	\N
89307809-9b20-4a8c-9ac2-60ecb64874f5	Alberto	Figeroa Gonzalez		\N	\N	2008-12-18 00:00:00		2025-05-03 20:50:49.382	2025-05-03 20:50:49.382	\N
d4a5e59a-cdb4-44f4-a372-0ba4230b017d	Ailed	Flores Mez		\N	3221399828	\N		2025-05-03 20:50:49.382	2025-05-03 20:50:49.382	\N
516a6ab4-7147-41b7-bd80-e4c34ab2b267	Alain Adrian	Torres Sanchez		\N	3221089107	\N		2025-05-03 20:50:49.383	2025-05-03 20:50:49.383	\N
fe9ea6b5-3bbe-448e-b936-3b74f6abbf72	Alberto	Rueda Villegas		\N	\N	\N		2025-05-03 20:50:49.383	2025-05-03 20:50:49.383	\N
b3687bd3-4581-4673-9a3d-3fbe99e253e4	Alberto	Santillan Sanchez		\N	\N	2007-07-05 00:00:00		2025-05-03 20:50:49.383	2025-05-03 20:50:49.383	\N
c353e84e-2783-4ba5-a7f8-d79af4e4f11c	Airam Natzarelly	Santo Villela		\N	\N	2002-10-17 00:00:00		2025-05-03 20:50:49.384	2025-05-03 20:50:49.384	\N
c0d54626-e52e-4d32-a221-61a61f8a46e4	Aitana Fabiola	Rodríguez Bernal		\N	\N	2017-01-06 00:00:00		2025-05-03 20:50:49.384	2025-05-03 20:50:49.384	\N
463337ad-1385-44d9-8eb2-801fbe7ef41a	Alberto	Stone Guerra		alberto-898@hotmail.com	\N	2000-05-19 00:00:00		2025-05-03 20:50:49.384	2025-05-03 20:50:49.384	\N
6e7cee34-3764-44d0-849c-c5478acea760	Alan	Sellers		beachbum74@hotmail.com	\N	1974-10-26 00:00:00		2025-05-03 20:50:49.385	2025-05-03 20:50:49.385	\N
74eece3a-ac8a-403b-9e0f-80de8daf7bf3	Claudia	Flores Altamirano		\N	\N	1993-08-11 00:00:00		2025-05-03 20:50:49.652	2025-05-03 20:50:49.652	\N
a85fcdb5-a4b5-42d5-8316-6515df3db51e	Alberto Raul	Rueda Villegas		albertoruedav@gmail.com	3292913711	1950-10-20 00:00:00		2025-05-03 20:50:49.385	2025-05-03 20:50:49.385	\N
86372868-37d4-4e16-8297-d9334a172b73	Alama Gabriela	Sanchez Ramos		\N	3221392537	\N		2025-05-03 20:50:49.385	2025-05-03 20:50:49.385	\N
4ab38ea2-1624-4beb-89de-c9cdb25eec8b	Alan Yasser	Cardenas Molina		\N	\N	\N		2025-05-03 20:50:49.386	2025-05-03 20:50:49.386	\N
11ff8e1e-34fd-4807-8128-a0f29cab2f11	Alberta	Mejia		\N	\N	2003-12-18 00:00:00		2025-05-03 20:50:49.386	2025-05-03 20:50:49.386	\N
94d48984-18ad-4919-ada3-0edf56712314	Aldo	Juarez de Aró		\N	\N	\N		2025-05-03 20:50:49.386	2025-05-03 20:50:49.386	\N
475ae5da-2267-4ef1-bace-4e10b6bdc76f	Alberta	Mejia		\N	\N	2005-02-09 00:00:00		2025-05-03 20:50:49.387	2025-05-03 20:50:49.387	\N
5b307829-a03b-442b-9130-a8e40b9d1134	Alberta	Mejia		\N	\N	2005-02-10 00:00:00		2025-05-03 20:50:49.387	2025-05-03 20:50:49.387	\N
72fadbde-3b26-4798-aaaf-361f7b403d0f	Alejandra	Alvarez Gutierrez		alezeravla@gmail.com	\N	1982-07-08 00:00:00		2025-05-03 20:50:49.387	2025-05-03 20:50:49.387	\N
377a3605-f898-4867-94a7-965862a0988a	Alejandra	Arreaga Arreaga		rojana8897@yahoo.com.mxc	\N	1971-03-15 00:00:00		2025-05-03 20:50:49.388	2025-05-03 20:50:49.388	\N
18da1df3-3927-4471-8e9b-976a5d9d2224	Alejandra	Bravo Castillon		ale_bravo7@outloock.	\N	1988-08-19 00:00:00		2025-05-03 20:50:49.388	2025-05-03 20:50:49.388	\N
82ce62f1-f904-4b4f-a4c4-6286254b172e	Alberto	Gonzalez Castro		\N	\N	2008-11-14 00:00:00		2025-05-03 20:50:49.388	2025-05-03 20:50:49.388	\N
7bef404c-4bcd-4d97-809c-94caa0e39bac	alejandra	flores santiago		\N	\N	2006-04-17 00:00:00		2025-05-03 20:50:49.389	2025-05-03 20:50:49.389	\N
faced336-d5ed-4f60-a0c8-01120e3fde85	Alberto	Izas Placencia		albert_izas@hotmail.com	\N	1984-10-09 00:00:00		2025-05-03 20:50:49.389	2025-05-03 20:50:49.389	\N
9d16cec0-e70e-4193-b2cc-bd83ba678492	Alberto	Sarate  Sanchez		\N	3221078007	\N		2025-05-03 20:50:49.389	2025-05-03 20:50:49.389	\N
392c13d6-9ced-4736-adb0-0fcd094e5bbe	Alberto	Solis Robles		\N	\N	\N		2025-05-03 20:50:49.39	2025-05-03 20:50:49.39	\N
31ab0bd3-f45d-4a77-8b05-8e6bb06d7b41	Alberto jasiel	Muñoz Villegas		\N	\N	1990-01-14 00:00:00		2025-05-03 20:50:49.39	2025-05-03 20:50:49.39	\N
2403c8e0-0bd1-4ab9-8925-a8dd05b4e8a6	Alejandra	Ibarra Falcon		\N	\N	1961-05-15 00:00:00		2025-05-03 20:50:49.39	2025-05-03 20:50:49.39	\N
ceeeaee6-d2fa-4ce0-b43c-0654b1496371	Alejandra	Martinez		\N	\N	1993-01-16 00:00:00		2025-05-03 20:50:49.391	2025-05-03 20:50:49.391	\N
497e4b92-1b04-4fa1-95e6-9af8d4964fb1	Alejandra	Nava  Puente		ale_navap@hotmail.com	\N	1993-12-10 00:00:00		2025-05-03 20:50:49.391	2025-05-03 20:50:49.391	\N
48e7ef67-fe5d-4da4-9762-4b03b7f6c352	Alberto Yigael	Lopez Padilla		yigael13@gmail.com	3334879609	1983-05-10 00:00:00		2025-05-03 20:50:49.391	2025-05-03 20:50:49.391	\N
0c5f072a-fa95-4772-b1a8-34525da01c76	Alan Santiago	Becerra López		\N	\N	2014-01-10 00:00:00		2025-05-03 20:50:49.392	2025-05-03 20:50:49.392	\N
0659e90e-c8a0-43a8-a2e9-9edb6d2f10c0	Aldivar	Macias Soltero		\N	\N	\N		2025-05-03 20:50:49.392	2025-05-03 20:50:49.392	\N
f23dfc45-4a64-468d-adc8-531738f933b5	Aldo	Martinez Sanchez		\N	\N	2010-09-13 00:00:00		2025-05-03 20:50:49.392	2025-05-03 20:50:49.392	\N
9368db96-d7f1-4059-aec4-7c833bff962a	Alejandra	Alvarado Toribio		\N	\N	\N		2025-05-03 20:50:49.393	2025-05-03 20:50:49.393	\N
2915591b-9374-49a7-801f-eec0d928e30c	Alejandra	Delgadillo		\N	\N	\N		2025-05-03 20:50:49.393	2025-05-03 20:50:49.393	\N
b96b25cc-ceb8-4794-a336-f70738b5af6a	Alejandra	Urbina Solis		\N	\N	1974-10-28 00:00:00		2025-05-03 20:50:49.393	2025-05-03 20:50:49.393	\N
b5c1046a-0bea-4933-bb50-8aafaf149b38	Alejandra	Fonseca Delgado		fonseca_920@hotmail.com	\N	1990-07-18 00:00:00		2025-05-03 20:50:49.394	2025-05-03 20:50:49.394	\N
b7e5d948-05db-4fe9-83c8-35648d3dc634	Alejandra	García Rodriguez		\N	\N	1999-10-14 00:00:00		2025-05-03 20:50:49.394	2025-05-03 20:50:49.394	\N
796aa926-a7cb-454d-b9f0-a4e235d69e0e	Albino	Reyna Martínez		arema_62@hotmail.com	\N	1962-10-01 00:00:00		2025-05-03 20:50:49.394	2025-05-03 20:50:49.394	\N
0775711e-3e96-4a63-892f-91fe51d603e6	Alejandra	Gomez Castañeda		\N	\N	2010-03-29 00:00:00		2025-05-03 20:50:49.394	2025-05-03 20:50:49.394	\N
727bcd1d-4488-4557-b4ed-36a0ea135bab	Alejandra Teresita	Valencia Zamora		alevaza_fut@hotmail.com	\N	1993-03-15 00:00:00		2025-05-03 20:50:49.395	2025-05-03 20:50:49.395	\N
2c7e9a89-b4af-48cb-936e-6a21a3b4b5a2	Alejandra	Gomez Lara		\N	\N	2007-05-11 00:00:00		2025-05-03 20:50:49.395	2025-05-03 20:50:49.395	\N
302b5320-57f9-4a62-8279-edbc4bb6902d	Alejandro	Bañuelos Godoy		\N	3221178198	1996-03-29 00:00:00		2025-05-03 20:50:49.395	2025-05-03 20:50:49.395	\N
434b1f87-afa8-4bd0-94d0-de5405a7256e	Alejandro	Crúz Fuentes		\N	\N	1956-07-16 00:00:00		2025-05-03 20:50:49.396	2025-05-03 20:50:49.396	\N
01b3037e-3717-452d-8c69-3d2c1fbd7353	Akiko	Mar		\N	3222438609	\N		2025-05-03 20:50:49.396	2025-05-03 20:50:49.396	\N
160785cd-8f97-46ec-90bb-54f863631d06	Akiiko	Mar		\N	3222438609	\N		2025-05-03 20:50:49.396	2025-05-03 20:50:49.396	\N
74ad361c-b33e-4932-8e52-473fd5e17b8f	Alan	Santos Espinosa		\N	\N	\N		2025-05-03 20:50:49.397	2025-05-03 20:50:49.397	\N
a7a084cc-1132-4a23-baab-5d251669b140	Alejandro	Gaspar Morales		\N	\N	\N		2025-05-03 20:50:49.397	2025-05-03 20:50:49.397	\N
7d72a403-67ac-4237-9018-cab9571ab0f9	Alejandra	Osuna Solis		\N	3222416516	\N		2025-05-03 20:50:49.397	2025-05-03 20:50:49.397	\N
55a33319-4a90-4046-96b2-a283636ee384	Alejandra	Ovando Rodriguez		\N	\N	2006-07-07 00:00:00		2025-05-03 20:50:49.398	2025-05-03 20:50:49.398	\N
c0b44826-f9bb-472b-9a0f-a36c2882a65c	Alejandra	Plata Villa		\N	3223225233	\N		2025-05-03 20:50:49.398	2025-05-03 20:50:49.398	\N
5f6c82e4-e1d7-4435-8717-4367aa8c282d	Alejandra	Romero Zamora		\N	\N	2008-05-29 00:00:00		2025-05-03 20:50:49.398	2025-05-03 20:50:49.398	\N
17ecde7e-a85b-4560-8bd2-7ddf38088827	Alejandro	Guzman		alexguzman@me.com	\N	1976-03-03 00:00:00		2025-05-03 20:50:49.399	2025-05-03 20:50:49.399	\N
9ed6c928-4abd-4889-bee0-59848708440b	Alejandro	Guzmán		\N	\N	\N		2025-05-03 20:50:49.399	2025-05-03 20:50:49.399	\N
ab1debc3-1dbf-4def-aa0e-ea998fe234b9	Alejandro	Jimenez		\N	\N	\N		2025-05-03 20:50:49.4	2025-05-03 20:50:49.4	\N
254c8f51-17f6-4fca-a993-eee2a91e11f4	Alejandro	Jimenez Flores		alepad3030@gmail.com	\N	1992-03-29 00:00:00		2025-05-03 20:50:49.4	2025-05-03 20:50:49.4	\N
c14d5c62-e1b7-4d69-aa23-80126c81224c	Alejandro	Lara Aguado		\N	\N	2006-09-22 00:00:00		2025-05-03 20:50:49.4	2025-05-03 20:50:49.4	\N
2105cb26-2b69-4aae-b5f7-8dccbf7543d5	Alejandra	Ruiz Molinares		\N	3221820326	\N		2025-05-03 20:50:49.401	2025-05-03 20:50:49.401	\N
fa8ce18f-1a21-4b39-8192-c82fa1e5692f	Alejandro	Martinez. Hernandéz		\N	\N	2006-07-20 00:00:00		2025-05-03 20:50:49.401	2025-05-03 20:50:49.401	\N
700d5f89-fdcd-4b33-a369-14d548269846	Alejandro	Molina Lerma		\N	\N	2006-08-31 00:00:00		2025-05-03 20:50:49.401	2025-05-03 20:50:49.401	\N
4153a39c-88b4-4a89-bb00-702c33f02077	Alejandra	Topete Cortes		\N	\N	2008-06-23 00:00:00		2025-05-03 20:50:49.402	2025-05-03 20:50:49.402	\N
eecdeb62-2e60-47f1-b6cf-98ab791554c0	Alejandra Fabiola	Gomez García		alejandragarcia.tur@gmail.com	\N	1989-01-22 00:00:00		2025-05-03 20:50:49.402	2025-05-03 20:50:49.402	\N
0132a023-ea17-4fd5-8766-573a3ce7445a	Alejandro	Peralta Arreaga		\N	\N	2006-11-20 00:00:00		2025-05-03 20:50:49.402	2025-05-03 20:50:49.402	\N
a16151cd-c87b-437b-bb7d-c77adb8ee311	Alejandro	Piñan		alejandroxochipili@gmail.com	+523222274704	\N		2025-05-03 20:50:49.403	2025-05-03 20:50:49.403	\N
0b774c3f-2c71-43d4-8839-06cab5bcfee7	Alejandrina	Medina Arcega		disenos_arcega@hotmail.com	\N	1963-04-24 00:00:00		2025-05-03 20:50:49.403	2025-05-03 20:50:49.403	\N
550246a9-c60e-4d93-8367-61acad5f9e8a	Alejandro	Geyne Guevara		\N	\N	1957-03-20 00:00:00		2025-05-03 20:50:49.403	2025-05-03 20:50:49.403	\N
e4d21911-3794-46c3-ae4e-9ca0838d9140	Alejandro	Uriza Sanchez		\N	\N	2009-03-20 00:00:00		2025-05-03 20:50:49.404	2025-05-03 20:50:49.404	\N
1fb18878-2481-4805-be4b-6bbdb54bc852	Alejandro	Velasco Mendisabal		\N	\N	2007-11-17 00:00:00		2025-05-03 20:50:49.404	2025-05-03 20:50:49.404	\N
3b1951cb-8184-4c18-bebd-78f03ea64cd9	Alejandra Marilyn	Perez Zepeda		\N	3221578569	\N		2025-05-03 20:50:49.405	2025-05-03 20:50:49.405	\N
c3eb7494-c126-4f51-8c0c-c42850001fec	Alejandro	Goméz Manzanilla		alejandrobabaro@htomail.com.	\N	1968-09-12 00:00:00		2025-05-03 20:50:49.405	2025-05-03 20:50:49.405	\N
7d5221ff-40a8-43a9-b2ca-89048a53a8f8	Alejandra Noemi	Barba Carrillo		\N	\N	\N		2025-05-03 20:50:49.405	2025-05-03 20:50:49.405	\N
b42e2f01-198b-4fb4-91aa-ba449d95b902	Alejandro	Vivaldi		\N	\N	\N		2025-05-03 20:50:49.406	2025-05-03 20:50:49.406	\N
6692af78-4246-43de-9ce9-bb8edc543f0a	Alejandro	Osorio Estrada		\N	+12132859785	\N		2025-05-03 20:50:49.406	2025-05-03 20:50:49.406	\N
9e206e8f-7014-485c-91ee-d05d00d91e3c	Alejandro Arón	Cisneros Garcia.		aaroncisnedi30@gmail.com	\N	1999-06-19 00:00:00		2025-05-03 20:50:49.406	2025-05-03 20:50:49.406	\N
27346328-ca3c-4e55-aeb3-9482cf596f39	Aleman	Aleman		\N	\N	2007-04-04 00:00:00		2025-05-03 20:50:49.407	2025-05-03 20:50:49.407	\N
accbac9b-7e46-4658-8418-bd23c87f431e	Alejandro	Martinez Alvarado		\N	\N	1955-07-10 00:00:00		2025-05-03 20:50:49.407	2025-05-03 20:50:49.407	\N
6d34ca7a-d6ee-40e5-bd43-e39e1617441a	Alejandro	Navarro Tenorio		alejandro.n.tenorio@gmail.com	\N	1983-11-07 00:00:00		2025-05-03 20:50:49.407	2025-05-03 20:50:49.407	\N
f337d67b-06c3-40e8-98e4-5c0cb4ed43a3	Alessandra	Acosta Sandoval		\N	\N	2006-01-31 00:00:00		2025-05-03 20:50:49.408	2025-05-03 20:50:49.408	\N
1fcc6db8-c488-482f-8185-1b028c0948eb	Alessandro	Carrillo Rodriguez		tarm23@hotmail.com	\N	2009-09-30 00:00:00		2025-05-03 20:50:49.408	2025-05-03 20:50:49.408	\N
00b3e21e-6869-46d3-950c-5c74ed31e54c	Alejandro	Olivares Huerta		\N	\N	2007-03-17 00:00:00		2025-05-03 20:50:49.408	2025-05-03 20:50:49.408	\N
79ea884e-2bbb-44e5-9b21-ae461d153e5c	Alejandro	Ximenes Orozco		\N	3222911044	\N		2025-05-03 20:50:49.409	2025-05-03 20:50:49.409	\N
a1ed8053-e889-4d61-b8f7-8b8241f1d026	Alex	Wasswermann		\N	\N	\N		2025-05-03 20:50:49.409	2025-05-03 20:50:49.409	\N
3c5d039c-3cc2-403d-aeda-e46a7c171099	Alex	Zupancie		\N	\N	\N		2025-05-03 20:50:49.409	2025-05-03 20:50:49.409	\N
79b6ea90-4a16-4e3a-9fab-446b03013537	Alejandra Isabel	Arreola Fregoso		Isabel.arreola.fregoso@gmail.com	+523111418861	\N		2025-05-03 20:50:49.409	2025-05-03 20:50:49.409	\N
d44c2e22-02cd-4e0f-9cac-f69864e63c18	Alejandro	Salinas Pimentel		salinasalejandro2001@gmail.com	\N	1989-05-24 00:00:00		2025-05-03 20:50:49.41	2025-05-03 20:50:49.41	\N
8c9fcffc-905e-40fa-8db2-ce7f6930ef5d	Alejandro	Rivera Mellado		\N	6862285724	\N		2025-05-03 20:50:49.41	2025-05-03 20:50:49.41	\N
dcd53cbd-6075-4861-b65b-3d1f1b20a969	Alejandro	Villalobos Avila		\N	\N	2009-12-14 00:00:00		2025-05-03 20:50:49.41	2025-05-03 20:50:49.41	\N
af7a7d4f-1310-42f6-af94-b6d12b407c59	Alejandro	Villalobos Carpin		\N	\N	2010-04-19 00:00:00		2025-05-03 20:50:49.411	2025-05-03 20:50:49.411	\N
509d4dd4-40db-4928-9967-391d8e812109	Alejandro	Villalobos Jarquin		\N	\N	2010-04-19 00:00:00		2025-05-03 20:50:49.411	2025-05-03 20:50:49.411	\N
54997bb0-2f95-4122-80e2-317787b7d167	alejandro	Gomez Barajas		\N	3223210161	\N		2025-05-03 20:50:49.411	2025-05-03 20:50:49.411	\N
3c87926b-ba51-4d72-8631-2f4de060908c	Alexis	Ornelas Gradilla		\N	\N	1993-10-07 00:00:00		2025-05-03 20:50:49.412	2025-05-03 20:50:49.412	\N
820454b0-9db5-4758-9193-d772ca118c00	Alejandro	Gutierrez Morales		sleepygang1369@gmail.com.com	\N	1988-09-30 00:00:00		2025-05-03 20:50:49.412	2025-05-03 20:50:49.412	\N
9212193b-bc0d-4059-9439-cd021d5dc3e8	Alexis Eliseo	Castillo Ayala		\N	\N	\N		2025-05-03 20:50:49.412	2025-05-03 20:50:49.412	\N
06f2b981-f444-4ea4-8006-f11cb865b293	Alejandro	Piñan Gutierrez		\N	3222274704	\N		2025-05-03 20:50:49.413	2025-05-03 20:50:49.413	\N
3a3cc0e2-a859-4948-872c-952df9277a00	Alexis	Bucio Ledezma		\N	5576953207	\N		2025-05-03 20:50:49.413	2025-05-03 20:50:49.413	\N
a5b65ed2-8e60-4c22-b302-8607dd47f7d1	Alex	Wassermann		\N	\N	\N		2025-05-03 20:50:49.413	2025-05-03 20:50:49.413	\N
223bea55-098f-4bf8-b246-fb1ee7aca802	Alejandro	Torres Sanchez		\N	3223279402	\N		2025-05-03 20:50:49.414	2025-05-03 20:50:49.414	\N
78571af1-2b32-4f8a-8d64-265513cf6bd2	Alfonzo	Buenrostro Ansalde		\N	\N	1958-08-23 00:00:00		2025-05-03 20:50:49.414	2025-05-03 20:50:49.414	\N
0a116ac2-974e-4641-9058-0783ae69f2cb	Alfonzo	Morales		\N	\N	2011-02-20 00:00:00		2025-05-03 20:50:49.414	2025-05-03 20:50:49.414	\N
9f5a19ef-4ca5-4b7b-bf0e-e86167deb1c4	Alexander	Ahmad Daoud		alexasalon4u@hotmail.com	\N	1976-05-17 00:00:00		2025-05-03 20:50:49.415	2025-05-03 20:50:49.415	\N
bb333003-7437-449c-a6e4-dc38d225d9da	Alfredo	Grimaldi Lopez		\N	\N	2006-11-29 00:00:00		2025-05-03 20:50:49.415	2025-05-03 20:50:49.415	\N
e0d70afd-9ee9-42b4-b886-6f4f6ff42cf8	Alexander Martin	Ramirez Nikolovki		\N	3222244525	2002-12-06 00:00:00		2025-05-03 20:50:49.416	2025-05-03 20:50:49.416	\N
0ac87098-993d-48f4-aaad-b7c970becba2	Alexandra	Quiceno		marcela1821997@hotmail.com	\N	1976-04-15 00:00:00		2025-05-03 20:50:49.416	2025-05-03 20:50:49.416	\N
bf564ed6-afa9-448b-89bf-31fd4fc5a99f	Alfredo	Jimenez Lopéz		alfre32@yahoo.com	\N	1984-04-03 00:00:00		2025-05-03 20:50:49.416	2025-05-03 20:50:49.416	\N
250fad6e-dc32-4817-88c8-fdd6f92d8b93	Alfredo	León Bejar		\N	\N	2009-01-12 00:00:00		2025-05-03 20:50:49.417	2025-05-03 20:50:49.417	\N
0becbf89-7544-45f1-ab03-9c4d9c1c947a	Alenka	Gomboc		\N	5542442561	\N		2025-05-03 20:50:49.417	2025-05-03 20:50:49.417	\N
72079561-cfce-460b-99fe-21ec07a57d82	Alexis	Bobadilla Villanueva		abobadilla15@gmail.com	\N	1984-09-19 00:00:00		2025-05-03 20:50:49.417	2025-05-03 20:50:49.417	\N
528f26be-c16b-4f43-9deb-a31d3237f2f8	Alexandre	Amhad Daoud		\N	3221698111	\N		2025-05-03 20:50:49.418	2025-05-03 20:50:49.418	\N
9aaf823b-c4e8-4f5d-8de5-493416e8f034	Alexis Iridian	Cardenas Macedo		alexisiridian@aotlook.com	\N	1997-11-18 00:00:00		2025-05-03 20:50:49.418	2025-05-03 20:50:49.418	\N
3b76d0f2-f45a-465d-8828-f88bb25ef3b7	Alfonso	Arriola Perez		\N	\N	\N		2025-05-03 20:50:49.418	2025-05-03 20:50:49.418	\N
272508e5-8242-4e47-92ef-ff3fc5e80ce0	Alfonso	Rios Curiel		\N	\N	1995-01-25 00:00:00		2025-05-03 20:50:49.419	2025-05-03 20:50:49.419	\N
62bad862-a20d-481c-8e97-db6e47f0bb3c	Alfredo	Becerra García		\N	\N	\N		2025-05-03 20:50:49.419	2025-05-03 20:50:49.419	\N
e294b651-7875-4b91-9740-492e1c42f055	Alfredo	Herrera Escobedo		alfherrera@hotmail.com.	3227799152	1961-09-15 00:00:00		2025-05-03 20:50:49.419	2025-05-03 20:50:49.419	\N
da25b6bc-7843-4d7c-8a7e-106071667069	Alfredo	Herrera Lara		\N	\N	\N		2025-05-03 20:50:49.419	2025-05-03 20:50:49.419	\N
5588c7e7-b199-4b60-911f-b3564023f3d1	Alfredo	Pinedo Martinez		\N	\N	2011-01-11 00:00:00		2025-05-03 20:50:49.42	2025-05-03 20:50:49.42	\N
3b7cf94b-f43c-46be-9d46-c0fe9033355d	Alicia	García Gonzalez		\N	\N	1956-10-13 00:00:00		2025-05-03 20:50:49.42	2025-05-03 20:50:49.42	\N
9b8c7792-7417-4e28-a22d-e0942ee6fcd0	Alfredo	Ramos Valadés		\N	\N	1970-05-17 00:00:00		2025-05-03 20:50:49.42	2025-05-03 20:50:49.42	\N
acd2f50e-b75a-4fcb-9948-0a019a243c12	Alicia	Morales Soltero		alicia_mosol@hotmail.com	\N	1987-12-01 00:00:00		2025-05-03 20:50:49.421	2025-05-03 20:50:49.421	\N
6183f1cc-b219-4013-bec5-c40aa535ed1b	Alicia	Ramirez Martínez		\N	\N	1947-12-11 00:00:00		2025-05-03 20:50:49.421	2025-05-03 20:50:49.421	\N
5e1e5c29-318b-4e73-951e-a3070bbffb5a	Alex	Budros		\N	3223238251	\N		2025-05-03 20:50:49.421	2025-05-03 20:50:49.421	\N
85285bf0-e250-4218-b326-9623b5bd7d11	Alicia	Rubio Ponce		\N	\N	1984-03-07 00:00:00		2025-05-03 20:50:49.422	2025-05-03 20:50:49.422	\N
6056894b-42b4-482e-9878-24414a192e90	Alexis	Torres Varo		sodi532@hotmail.com	\N	1986-01-05 00:00:00		2025-05-03 20:50:49.422	2025-05-03 20:50:49.422	\N
d34f1855-1887-4adf-aff4-92d95eefbc34	Alicia Margarita	Chavez Gordiano		\N	\N	\N		2025-05-03 20:50:49.423	2025-05-03 20:50:49.423	\N
1e5e7e2a-26f3-4410-afb8-05607e0c1fb3	Alexa	Melo sollano		jrzcfh45sw@privaterelay.appleid.com	+525542913028	\N		2025-05-03 20:50:49.423	2025-05-03 20:50:49.423	\N
33abf630-48cd-4df7-a8f0-9f4d402ea1b9	Ali	Farach		ali@nauticarealty.net	\N	1950-12-27 00:00:00		2025-05-03 20:50:49.423	2025-05-03 20:50:49.423	\N
ea9bbad6-33bd-453b-bb95-093f6ceede8a	Alicia	Briones Mercado		odominguezpv@hotmail.com	\N	1985-05-03 00:00:00		2025-05-03 20:50:49.424	2025-05-03 20:50:49.424	\N
75f4cabf-e7eb-4bc5-8d50-38d426a736b9	Alicia	Castañeda de Muñoz		\N	\N	1942-11-22 00:00:00		2025-05-03 20:50:49.424	2025-05-03 20:50:49.424	\N
340ae64f-eb4c-448b-b982-f932843817f7	Alicia	Cervantes		\N	\N	1969-04-23 00:00:00		2025-05-03 20:50:49.424	2025-05-03 20:50:49.424	\N
db783e0e-b25f-49ab-8d3d-953ef987390e	Aline Gisselle	Ambriz Zárate		\N	\N	1991-11-08 00:00:00		2025-05-03 20:50:49.425	2025-05-03 20:50:49.425	\N
4d6d8e82-6e2e-4f42-b7e7-9672bb3b1351	Alicia	del Rio Jimenes		\N	\N	1936-10-07 00:00:00		2025-05-03 20:50:49.425	2025-05-03 20:50:49.425	\N
6494ae82-accd-4897-9913-1e9b15db8592	Alicia	Figeroa Carrión		\N	\N	1956-09-12 00:00:00		2025-05-03 20:50:49.425	2025-05-03 20:50:49.425	\N
d3d30b4e-7a6c-4888-9982-dadcfca0d44a	Allan	Ballies		\N	\N	\N		2025-05-03 20:50:49.426	2025-05-03 20:50:49.426	\N
47a5caa9-13d0-4539-a018-fc4975f87f31	Alicia	Mendoza López		\N	\N	\N		2025-05-03 20:50:49.426	2025-05-03 20:50:49.426	\N
f5731452-58d3-4eaa-b769-f0ee087026e2	Alicia	Rubio Ponce		\N	\N	1984-03-07 00:00:00		2025-05-03 20:50:49.426	2025-05-03 20:50:49.426	\N
5bfa4eca-cc36-4ec1-bcfb-39f1e9af75b6	Allvaro	Garcìa		\N	\N	2011-03-24 00:00:00		2025-05-03 20:50:49.427	2025-05-03 20:50:49.427	\N
eb5d69ea-5abe-4a6c-917f-3e42eee77dba	Alfredo Jose	Torres Saldivia		alfredots@yahoo.com.mx	\N	1974-06-24 00:00:00		2025-05-03 20:50:49.427	2025-05-03 20:50:49.427	\N
a3dd954f-93c5-4fb6-bc87-1a4ebec08d33	Alma	Valdes Salas		\N	\N	1972-07-07 00:00:00		2025-05-03 20:50:49.427	2025-05-03 20:50:49.427	\N
131ca04f-6c04-4989-9495-a201df755193	Alina	Olmos Ramirez		alinaolmos@gmail.com	\N	2002-10-20 00:00:00		2025-05-03 20:50:49.427	2025-05-03 20:50:49.427	\N
b9f0676f-b8e3-4ca6-9252-ddee44df283d	Alfredo Bernado	Castilo Morales.		\N	3221493936	\N		2025-05-03 20:50:49.428	2025-05-03 20:50:49.428	\N
d0253531-2ac4-4c0f-b99d-24dc7b1f972f	alenka	gomboc		al.gomboc@gmail.com	+525542442561	\N		2025-05-03 20:50:49.428	2025-05-03 20:50:49.428	\N
6aba0b38-5bcf-4bf7-9c97-50d1fc89dee7	Aline	Carrier		carrauge@gmail.com	\N	1955-08-17 00:00:00		2025-05-03 20:50:49.428	2025-05-03 20:50:49.428	\N
1b56cef5-4750-49e6-9432-63a7f67012b5	Alisson Geraldin	De los Santos Ayala		\N	\N	2008-10-29 00:00:00		2025-05-03 20:50:49.429	2025-05-03 20:50:49.429	\N
3cb9f30b-5df1-4417-8062-61c98f8a06e7	Alma Delia	Bañuelos Garcia		\N	3221901500	\N		2025-05-03 20:50:49.429	2025-05-03 20:50:49.429	\N
a933137f-4c1a-4fbe-8484-203fef6cc807	Alma Graciela	Lopez Cota		\N	\N	2010-02-20 00:00:00		2025-05-03 20:50:49.43	2025-05-03 20:50:49.43	\N
1d67c404-9c2d-4dc4-ad65-a988a50fbb64	Alla Abdalla	Elsage		aladino@auotlook	\N	1989-01-01 00:00:00		2025-05-03 20:50:49.43	2025-05-03 20:50:49.43	\N
bab43107-bc84-4267-b304-c49a9185697d	Alma Rosa	Vazquez		\N	\N	\N		2025-05-03 20:50:49.43	2025-05-03 20:50:49.43	\N
aba949fc-cc2b-4c65-9511-63cdfed04f99	Alicia	Villalobos Mancilla		aliciapuvta@hotmail.com	\N	1953-07-08 00:00:00		2025-05-03 20:50:49.431	2025-05-03 20:50:49.431	\N
0b1064a3-a541-4500-bcf1-2014feda9285	Alma Virguinia	Pérez de Gutierrez		\N	\N	1957-08-18 00:00:00		2025-05-03 20:50:49.431	2025-05-03 20:50:49.431	\N
d3d4433b-b709-4bb0-b01a-4af28bc374e8	Alma Yesicca	Martinez   Jara		\N	\N	\N		2025-05-03 20:50:49.431	2025-05-03 20:50:49.431	\N
b94c2e00-01ed-4072-a40b-f7c81e2c124c	Alon	Afriat		alon6505@yahoo.ca	\N	1957-02-13 00:00:00		2025-05-03 20:50:49.432	2025-05-03 20:50:49.432	\N
c522105f-f0b2-44e1-8957-d2141bb84b50	Alicia Margarita	Santos Estrella		\N	\N	1984-08-09 00:00:00		2025-05-03 20:50:49.432	2025-05-03 20:50:49.432	\N
1663782a-78f1-43cb-bb39-c4e8f19750f7	Alexis Gustavo Ivan	Bobadilla Villanueva		\N	+13124148332	\N		2025-05-03 20:50:49.432	2025-05-03 20:50:49.432	\N
57476f29-dfc2-4e62-9370-3822d395c76b	Alma Delia	Mora García		almoragarcia@hotmail.com	\N	1970-06-21 00:00:00		2025-05-03 20:50:49.433	2025-05-03 20:50:49.433	\N
58b85686-ea4e-492f-a63b-09ee39db1f00	Alondra	Ramirez Mora		\N	\N	2010-10-08 00:00:00		2025-05-03 20:50:49.433	2025-05-03 20:50:49.433	\N
cefcd497-553f-4808-9d7f-e93743d32e70	Alma Delia	Ontiveros Trejo		almaraul7574@gmail.com	\N	1975-06-28 00:00:00		2025-05-03 20:50:49.433	2025-05-03 20:50:49.433	\N
01580f8d-23a2-45cd-b5ae-6a5d838bbb7f	Alma Esther	Ibarra Fierro		estheryba.58@hotmail.com	\N	1958-07-01 00:00:00		2025-05-03 20:50:49.434	2025-05-03 20:50:49.434	\N
09b4fbec-88e0-48ae-bb93-b679891167eb	Alika	Del Toro Ramirez		Deltororamirez.fm1@gmail.com	3314410060	\N		2025-05-03 20:50:49.434	2025-05-03 20:50:49.434	\N
eca50045-ae3e-4114-ac27-5492c042caf8	Alma Rosa	Vazquez Salcedo		\N	3141063844	1960-09-15 00:00:00		2025-05-03 20:50:49.434	2025-05-03 20:50:49.434	\N
efc7af15-04c6-49e3-8cea-a00ddf9223c4	Alondra Lucia	Colmenero Rodriguez		\N	\N	2009-01-08 00:00:00		2025-05-03 20:50:49.435	2025-05-03 20:50:49.435	\N
aafceaa1-c497-4624-9c07-77b7d85a21ed	Alondra Yared	Castillo Flippen		alondraflippen_93@hotmail.com	\N	1993-10-15 00:00:00		2025-05-03 20:50:49.435	2025-05-03 20:50:49.435	\N
4c7f8f4a-a5e8-473d-b52c-26f14b5e2b6f	Alina lizbeth	Solis Toscano		\N	3223325272	\N		2025-05-03 20:50:49.435	2025-05-03 20:50:49.435	\N
22e9c9b7-dc9b-4254-b0d7-0935a8b9a44b	Allan	Doherty		\N	\N	1953-03-10 00:00:00		2025-05-03 20:50:49.435	2025-05-03 20:50:49.435	\N
798cb534-7815-4ae4-8e6d-575d6ba9b195	Alvaro	Agiss Rojas		\N	\N	2007-03-27 00:00:00		2025-05-03 20:50:49.436	2025-05-03 20:50:49.436	\N
6edd4021-beb3-4284-8370-3b7123bc53f4	Alvaro	Campos Fernandez		alvaro.a_campos@hotmail.com	3221403498	2003-08-05 00:00:00		2025-05-03 20:50:49.436	2025-05-03 20:50:49.436	\N
f920250a-069e-4064-927d-e0210495e6f7	Alvaro	Diaz Dueñas		alvaro.diaz70@yahoo.com.mx	\N	1975-09-23 00:00:00		2025-05-03 20:50:49.436	2025-05-03 20:50:49.436	\N
4edb28e4-f3a2-4523-b80a-f5ddfc741719	Alma Gabriela	Sánchez		gabysuchi42@gmail.com	+523221392537	\N		2025-05-03 20:50:49.437	2025-05-03 20:50:49.437	\N
b8abdd65-ed24-4e21-a0f1-80839a78555c	Alvaro	Garcia Flores		\N	\N	\N		2025-05-03 20:50:49.437	2025-05-03 20:50:49.437	\N
e63081e3-52a4-4320-af2b-49a96362be9b	Alvaro	Garcìa Herrnandez		\N	\N	2011-03-29 00:00:00		2025-05-03 20:50:49.437	2025-05-03 20:50:49.437	\N
6b237e1c-6431-43df-8579-4346e9d598b9	Alvaro Daniel	Mandujano Perez		\N	\N	\N		2025-05-03 20:50:49.438	2025-05-03 20:50:49.438	\N
f044b3e4-54fa-42f6-a5f8-a7248882e102	Amadat	Reyes Duran		amadat@hotmail.com	\N	1985-06-18 00:00:00		2025-05-03 20:50:49.438	2025-05-03 20:50:49.438	\N
95bbdabb-9157-468f-86bb-2ab20f5c0d3f	Alli	Farach		\N	\N	\N		2025-05-03 20:50:49.438	2025-05-03 20:50:49.438	\N
0fdec9e0-f67b-4d2f-963b-8df46f5b61ac	Amancia	Hernandez Mar		\N	\N	\N		2025-05-03 20:50:49.439	2025-05-03 20:50:49.439	\N
efa74ed6-220c-4fca-884f-020c19af74ca	Amanda	Duval		cocre8life@yahoo.com	3222247011	1960-01-20 00:00:00		2025-05-03 20:50:49.439	2025-05-03 20:50:49.439	\N
98931056-cb50-4f52-967d-cde3dc767bc5	Amanda	Green		\N	\N	\N		2025-05-03 20:50:49.439	2025-05-03 20:50:49.439	\N
347f2a96-f080-43e4-8114-18e0f1e3cd50	Amando	Castañeda		\N	\N	\N		2025-05-03 20:50:49.44	2025-05-03 20:50:49.44	\N
8e3b6f33-f6a1-4a97-8055-6cd6b786ef9b	Alma	Diaz del Guante		\N	\N	\N		2025-05-03 20:50:49.44	2025-05-03 20:50:49.44	\N
33a37d0d-db0d-49df-8920-1a9350a4569d	Ambar	Meeser Sobreu		\N	\N	2010-02-08 00:00:00		2025-05-03 20:50:49.44	2025-05-03 20:50:49.44	\N
3faf961d-c1f3-4111-a6d2-4b408144c1ba	Alondra	Jimenes Llanos		aloshorty@hotmail.com	\N	1986-07-20 00:00:00		2025-05-03 20:50:49.441	2025-05-03 20:50:49.441	\N
8d3e52c0-c2ee-4fc1-b336-d97f94c1c58a	Alondra	Jimenez LLano		aloshorty@hotmail.com	\N	1986-07-20 00:00:00		2025-05-03 20:50:49.441	2025-05-03 20:50:49.441	\N
bbde330b-d54f-4bdd-93b6-3ada59b25ab7	Amelia	Plett		amyliajoy@yahoo.com	\N	1993-10-28 00:00:00		2025-05-03 20:50:49.441	2025-05-03 20:50:49.441	\N
f6a9eb4b-affe-4a6d-b2d3-84d516f2006e	Alma  Patricia	Gutierrez  Padilla		apgutierrezp73@gmail.com	\N	1973-03-30 00:00:00		2025-05-03 20:50:49.442	2025-05-03 20:50:49.442	\N
a5f0c8d1-ba16-4587-a535-523dfd18175f	Alonso	Cueva Guitron		\N	3222051252	\N		2025-05-03 20:50:49.442	2025-05-03 20:50:49.442	\N
0b9a41aa-9f4c-4efa-8802-3f022b98cd97	Amelia	Retano Barrasa		\N	\N	\N		2025-05-03 20:50:49.442	2025-05-03 20:50:49.442	\N
66c388c1-6be7-4d92-a87c-6b7bfbbe21ba	Alondra Anais	Rubio Gutierrez		anaisrg.06@hotmail.com	3221470259	1988-07-14 00:00:00		2025-05-03 20:50:49.443	2025-05-03 20:50:49.443	\N
48dafa60-48c7-4c89-86c8-080ce308def5	Alondra DINORA	Jimenez Llano		aloshorty@hotmail.com	\N	1986-07-20 00:00:00		2025-05-03 20:50:49.443	2025-05-03 20:50:49.443	\N
cf914ddd-1954-4ba6-a801-0dbc5d313724	America Ximena	Arechiga López		\N	3222224314	2012-04-02 00:00:00		2025-05-03 20:50:49.443	2025-05-03 20:50:49.443	\N
1e1a4c78-6aef-4222-87e4-839d1788cbbe	Alma Rosa	Ochoa Hernandez		\N	3221524952	\N		2025-05-03 20:50:49.444	2025-05-03 20:50:49.444	\N
d9a6eea8-4d6f-4aa9-a440-40b0255c566f	Amor Olimpya	Flores Vallejo		amorfloresv@gmnail.com	\N	2003-01-13 00:00:00		2025-05-03 20:50:49.444	2025-05-03 20:50:49.444	\N
14ecf4b8-5274-4e49-910c-6c172a0bc6ce	Alondra	Nava Puente		kisses_cerecit@live.com.mx	\N	1996-03-07 00:00:00		2025-05-03 20:50:49.444	2025-05-03 20:50:49.444	\N
4a3408d3-a41a-401e-b98e-a2d4fd43019f	Ana	Baez		\N	\N	\N		2025-05-03 20:50:49.445	2025-05-03 20:50:49.445	\N
32c988ad-e050-4149-94d9-9d01e3f46a8e	America	Arias Aguilar		\N	\N	1996-06-23 00:00:00		2025-05-03 20:50:49.445	2025-05-03 20:50:49.445	\N
98b34cb2-e545-4936-8c53-409874e58994	Alondra Lizzete	Zermeño gutierrez		\N	3222321066	\N		2025-05-03 20:50:49.445	2025-05-03 20:50:49.445	\N
c50adbad-e8e2-4d7c-8c7f-dd09e9dd04cd	Alvaro	Diaz Dueñas		\N	9983300336	\N		2025-05-03 20:50:49.446	2025-05-03 20:50:49.446	\N
1ace78db-bf9e-4007-aad4-05979cca7c6e	Alondra	Vegas Suarez		\N	4981126402	\N		2025-05-03 20:50:49.446	2025-05-03 20:50:49.446	\N
0a444094-83c7-47f8-9bb7-d14d6c376aca	Amalea	Camacho Salgado		\N	3221301160	\N		2025-05-03 20:50:49.446	2025-05-03 20:50:49.446	\N
19391d7b-ab0b-4692-9ed6-458ddaede4f5	Ana	Muñoz Cardenas		anamunozcardenas@gmail.com	\N	1982-02-10 00:00:00		2025-05-03 20:50:49.447	2025-05-03 20:50:49.447	\N
3373dc91-ccb4-496d-ade3-82f2e4bdd629	Amando	Sanchez		\N	\N	\N		2025-05-03 20:50:49.447	2025-05-03 20:50:49.447	\N
f1a74f18-aac2-44ab-ad4a-36d618962a28	Amelia	Alvarez García		\N	\N	1947-07-18 00:00:00		2025-05-03 20:50:49.447	2025-05-03 20:50:49.447	\N
a7b82cf9-920c-4e23-aa64-c6862ae219a4	ana	valades		\N	\N	\N		2025-05-03 20:50:49.448	2025-05-03 20:50:49.448	\N
39a57319-daad-412d-aa6e-dc680014dc5d	ana	valadez		\N	\N	\N		2025-05-03 20:50:49.448	2025-05-03 20:50:49.448	\N
2bbf24c7-e35e-4026-8856-1bc042524231	Ana Adriana	Lopez Palomera		adylp_@hotmail.com	\N	1965-05-17 00:00:00		2025-05-03 20:50:49.448	2025-05-03 20:50:49.448	\N
f7ef8cd6-37e5-46fc-968a-cf70d8fe251a	Amelia	Huerta Vallin		\N	\N	1956-11-20 00:00:00		2025-05-03 20:50:49.449	2025-05-03 20:50:49.449	\N
50c0e0be-cbed-46f5-a9e6-dcadc52dac78	Ana Beatriz	Pérez Peréz		\N	\N	1986-10-23 00:00:00		2025-05-03 20:50:49.449	2025-05-03 20:50:49.449	\N
67c344c8-b1c0-4bd6-8b99-e19c1cd8a51e	Amelia	Ramirez Soto		ameliarodriguezsoto@hotmail.com	3311202542	1966-07-17 00:00:00		2025-05-03 20:50:49.449	2025-05-03 20:50:49.449	\N
7f141713-2299-44fa-89c1-860ef88c5dbd	Amelia	Renteria Huerta		\N	\N	\N		2025-05-03 20:50:49.449	2025-05-03 20:50:49.449	\N
e26f81f5-dc6f-4190-bb0f-e1e7b6967112	Ana	Del Toro Torres		adeltoro1974@gmail.com	\N	1974-09-17 00:00:00		2025-05-03 20:50:49.45	2025-05-03 20:50:49.45	\N
0a97f86f-8364-4e69-ab81-7eb4862139d3	Ana Berta	Gonzalez Spiller		\N	\N	1965-08-13 00:00:00		2025-05-03 20:50:49.45	2025-05-03 20:50:49.45	\N
91cd6dab-a034-497b-b76d-452d36170a2f	Ana	Dolores ballardo		\N	\N	1985-10-31 00:00:00		2025-05-03 20:50:49.45	2025-05-03 20:50:49.45	\N
234bff95-e474-42f8-99f0-0df1cef867f7	Ana	Guevara Suárez		\N	\N	1991-10-21 00:00:00		2025-05-03 20:50:49.451	2025-05-03 20:50:49.451	\N
fe440967-884b-4476-a179-1bd25727889d	Amy	Lamb		\N	\N	1977-09-29 00:00:00		2025-05-03 20:50:49.451	2025-05-03 20:50:49.451	\N
9859a66d-b0f2-40ac-8049-ac82760074d5	Ana del Pilar	Giner Cortés		\N	\N	1973-07-04 00:00:00		2025-05-03 20:50:49.451	2025-05-03 20:50:49.451	\N
28a5536b-e1d7-4e24-bd8f-ca2cb69c9361	Ana	Camarota Scialo		partenopeyelmar@hotmail.com	\N	1964-06-30 00:00:00		2025-05-03 20:50:49.452	2025-05-03 20:50:49.452	\N
1e0ef038-3a43-44af-b9e4-b195fa76b5f1	Ana Elisa	Ortiz de Ibarraran		\N	\N	1962-02-03 00:00:00		2025-05-03 20:50:49.452	2025-05-03 20:50:49.452	\N
4467fd88-4037-400f-9cd9-893873fba1ed	Ana Fabiola	Morroy Rivera		\N	\N	\N		2025-05-03 20:50:49.452	2025-05-03 20:50:49.452	\N
997061cb-6485-4056-a6ec-55985bf07f14	Ameyalli	Soberanez		soberanezame@gmail.com	+526673947809	1995-10-13 00:00:00		2025-05-03 20:50:49.453	2025-05-03 20:50:49.453	\N
bf097c66-b07e-483c-a38a-c7522d3aafc3	Ana Gabriela	Vazquez Roman		\N	\N	1985-07-26 00:00:00		2025-05-03 20:50:49.453	2025-05-03 20:50:49.453	\N
09aed201-a3bb-4c8d-b6bd-ef6ede9f04a0	America Mercedes	Fernandes Ibarra		\N	3223838076	\N		2025-05-03 20:50:49.453	2025-05-03 20:50:49.453	\N
fee74598-36fc-415b-abad-66c2d08eabd2	Ana Berta	Herrera Mendez		annis12595@gmail.com	+523221363616	1974-05-08 00:00:00		2025-05-03 20:50:49.453	2025-05-03 20:50:49.453	\N
853a480a-e470-4d68-b220-3fe59bba42f6	Ana	Lewis		\N	\N	2008-08-21 00:00:00		2025-05-03 20:50:49.454	2025-05-03 20:50:49.454	\N
d20b30da-c200-4163-8ea8-f7ebce0195b5	Ana Julisa	Mejia Peña		najulisamejia@hotmail.com	\N	1968-07-28 00:00:00		2025-05-03 20:50:49.454	2025-05-03 20:50:49.454	\N
9294e22a-c970-4a94-a66d-cbd9efcf2bde	Ana Karen	Lynn Rodriguez		karenlynnroo@gmai.com	\N	1990-12-14 00:00:00		2025-05-03 20:50:49.454	2025-05-03 20:50:49.454	\N
5a154c74-6cce-453b-a494-26bc99beb63c	Ana Karen	Martinez		tatuajesdeana@gmail.com	\N	1992-12-12 00:00:00		2025-05-03 20:50:49.455	2025-05-03 20:50:49.455	\N
4dcad74f-a1d2-4547-a4dd-b6a88af0a456	Ana	Muñoz López		amunoz@velashotels.com	\N	1983-02-04 00:00:00		2025-05-03 20:50:49.455	2025-05-03 20:50:49.455	\N
9a89f50f-0ebf-4dc7-8e41-2c1ad66e1e2e	Ana Karen	Radilla Hernández		\N	+523222641830	\N		2025-05-03 20:50:49.455	2025-05-03 20:50:49.455	\N
3fdf2c57-41dc-4517-ae40-990f650220c9	Ana	Murillo Alvarez		\N	\N	\N		2025-05-03 20:50:49.456	2025-05-03 20:50:49.456	\N
5a96d375-f2b0-4bea-8702-29481db6e302	Ana Alejandra	Calderon Moreno		ana_calderon_moreno@hotmail.com	\N	1999-09-23 00:00:00		2025-05-03 20:50:49.456	2025-05-03 20:50:49.456	\N
f8a647e5-bf57-4bb0-913b-b1aeeca0c8c0	Ana Bel	Avando Cardenas		\N	\N	1986-01-26 00:00:00		2025-05-03 20:50:49.456	2025-05-03 20:50:49.456	\N
bda650b7-2603-45af-86fc-7f6b4a21a100	Ana Karen	Trujillo García		any_k91@hotmail.com	\N	1991-06-15 00:00:00		2025-05-03 20:50:49.457	2025-05-03 20:50:49.457	\N
fb8152d0-1b7a-4978-b845-161d5072d6d9	Ana Laura	Barron  León		\N	\N	2009-04-07 00:00:00		2025-05-03 20:50:49.457	2025-05-03 20:50:49.457	\N
c8e71670-323e-4c61-ba29-9dc11979a07c	Ana Laura	Garcia Ruiz		laurag_udg@hotmail.com	\N	1987-03-31 00:00:00		2025-05-03 20:50:49.457	2025-05-03 20:50:49.457	\N
4c143fd9-51ae-48af-932e-c9f1ff020392	Ana Bel	X		\N	\N	\N		2025-05-03 20:50:49.458	2025-05-03 20:50:49.458	\N
792701d2-8ce9-4661-bd12-d58a00d90558	Ana belem	Gallegos Pérez		\N	\N	1971-05-14 00:00:00		2025-05-03 20:50:49.458	2025-05-03 20:50:49.458	\N
bf5ae1a7-5518-4e90-b138-d44410f1bc2f	Alonso	Cueva Rubio		cuevarubionoemi@gmail.com	+523222746735	\N		2025-05-03 20:50:49.459	2025-05-03 20:50:49.459	\N
19796ac6-e64c-4cb9-8705-c4bbbdb88427	Ana isabel	González Muñoz		Isabelglez95@hotmail.com	+523316049751	\N		2025-05-03 20:50:49.459	2025-05-03 20:50:49.459	\N
02f1ddea-8964-41fa-99e4-50faa0320d1b	Ana Berta	Herrera Mendéz		\N	3221363616	\N		2025-05-03 20:50:49.459	2025-05-03 20:50:49.459	\N
f6ff80ff-d0a1-4019-af96-3a6a0096bc8f	Ana Elena	Fuentes Gonzales		\N	3316717096	\N		2025-05-03 20:50:49.459	2025-05-03 20:50:49.459	\N
e702c1c2-c468-4c04-9687-6dd80a9fe637	Ana Lizeth	Gonzalez  Gonzalez		anna_g2@hotmail.com	\N	1990-04-20 00:00:00		2025-05-03 20:50:49.46	2025-05-03 20:50:49.46	\N
e9add27c-c1d3-41df-b6c9-9b1f3a704577	Ana Lucia	Alvarado Cruz		\N	\N	\N		2025-05-03 20:50:49.46	2025-05-03 20:50:49.46	\N
984c527a-453b-4d16-acac-91f47a07fc11	Ana Lucia	Sánchez Salcedo		analuciaygordo@gmail.com	\N	1970-09-24 00:00:00		2025-05-03 20:50:49.46	2025-05-03 20:50:49.46	\N
087141a2-1b5c-4662-b434-90c2010663ad	Ana Bertha	Cardenas González		ana.cg6604@gmail.com	3221417237	\N		2025-05-03 20:50:49.461	2025-05-03 20:50:49.461	\N
0066d96f-5ff9-434a-9f82-786afd576709	Ana Marcela	de la Rosa		ana29marcela@hotmail.com	\N	1983-01-29 00:00:00		2025-05-03 20:50:49.461	2025-05-03 20:50:49.461	\N
3b0e1765-e048-4297-924d-dfe62ae73168	Ana Maria	Cardona Lopez		annalocamx@yahoo.com.mx	\N	1977-05-17 00:00:00		2025-05-03 20:50:49.461	2025-05-03 20:50:49.461	\N
95bae51f-d1b4-4c9f-a3c2-4f0a8b691bf6	Ana Maria	García Rodríguez		\N	3292965270	1957-07-03 00:00:00		2025-05-03 20:50:49.462	2025-05-03 20:50:49.462	\N
5224acbb-15b1-427a-93f7-feec940d6ba4	Ana isabel	Valades Rabasa		\N	3221600451	\N		2025-05-03 20:50:49.462	2025-05-03 20:50:49.462	\N
61d9e52e-113d-4ae9-8901-2520f79d4388	Ana Karen	Martinez Almaguer		\N	3223100351	\N		2025-05-03 20:50:49.462	2025-05-03 20:50:49.462	\N
5dddac83-2e2e-457e-b59b-996c8b05ff53	Ana Maria	Platas García		\N	\N	2008-07-11 00:00:00		2025-05-03 20:50:49.463	2025-05-03 20:50:49.463	\N
c6b94a5b-4386-443c-b180-2ca7008b542e	Ana Maria	Vega Ferrer		la.mas.anita@gmail.com	\N	1978-05-28 00:00:00		2025-05-03 20:50:49.463	2025-05-03 20:50:49.463	\N
dc92d184-52e5-4a98-b9a0-5d2d4298352b	Ana Maria Lorenza	Fregozo Limas		\N	\N	1940-09-16 00:00:00		2025-05-03 20:50:49.463	2025-05-03 20:50:49.463	\N
12f14162-2a07-4986-b2cb-86dc0d0b4882	Ana Marina	Suarez Calvillo		\N	3221277724	1978-12-09 00:00:00		2025-05-03 20:50:49.464	2025-05-03 20:50:49.464	\N
0ed21399-2230-4d36-b763-177a3f0c4384	Ana Lidia	Orta Cabrera		orcanly@hotmail.com	\N	\N		2025-05-03 20:50:49.464	2025-05-03 20:50:49.464	\N
65ccfc11-06fb-42a7-a0b4-ca877be35943	Ana Rosa	Rendon Rodriguez		\N	\N	1967-09-05 00:00:00		2025-05-03 20:50:49.464	2025-05-03 20:50:49.464	\N
11f06a5d-d195-48cb-892e-f6dfcd2fb44d	Ana Rosina	Cuvarrubias Aguirre		\N	\N	1936-10-18 00:00:00		2025-05-03 20:50:49.465	2025-05-03 20:50:49.465	\N
c4ad6b0b-c33b-497e-b976-c85eeec4e94b	Ana Rosina	Sandoval Cobarruvias		ana.rosina.sandoval@hotmail.com	\N	1964-10-10 00:00:00		2025-05-03 20:50:49.465	2025-05-03 20:50:49.465	\N
dcf653c7-38ca-45ef-ab86-4ebed6b979df	Anabel	Holmes Garcia		shainty1@hotmail.com	\N	2007-09-27 00:00:00		2025-05-03 20:50:49.465	2025-05-03 20:50:49.465	\N
72bff994-7b38-4859-8c1d-4086d5cbf9aa	Ana Lilia	Alvarez Lozoya		\N	\N	1963-02-01 00:00:00		2025-05-03 20:50:49.466	2025-05-03 20:50:49.466	\N
b04617a6-ca1d-4227-a1fb-4e5f9743b0ec	Ana Luisa	Grano Cortes		ana_luisagc@hotmail.com	\N	1983-03-23 00:00:00		2025-05-03 20:50:49.466	2025-05-03 20:50:49.466	\N
cf87d3f4-0102-4217-a2df-f4fdfc05d050	Ana Maria	Gonzalez Cazar		\N	\N	\N		2025-05-03 20:50:49.466	2025-05-03 20:50:49.466	\N
4b808ff8-3f31-400f-b200-429d8243072a	Ana Isabel	Valades Rabsa		\N	3221600451	\N		2025-05-03 20:50:49.467	2025-05-03 20:50:49.467	\N
75a851c6-9ec7-429d-ac38-0d5aa59d890c	Ana leonor	Langarica bautista		langaricaleonor7@gmail.com	+523223959786	\N		2025-05-03 20:50:49.467	2025-05-03 20:50:49.467	\N
22219c00-35fc-4d6f-aaae-43528691fbd8	Ana Gabriela	Lopez Andalon		\N	3221525742	\N		2025-05-03 20:50:49.467	2025-05-03 20:50:49.467	\N
8caf5481-0222-4a38-bc0d-22a2ac801c50	Anatohy	Butok		\N	\N	1977-07-07 00:00:00		2025-05-03 20:50:49.468	2025-05-03 20:50:49.468	\N
1a500fb4-60b3-4a6b-b98c-4411af5d402b	Anayeli	Miral Rio		anayeli03m@hotmail.com	\N	1984-08-03 00:00:00		2025-05-03 20:50:49.468	2025-05-03 20:50:49.468	\N
14aaf7e4-b05f-462c-a85a-be8c4ed70068	Andre	Beaudry		\N	\N	1954-11-11 00:00:00		2025-05-03 20:50:49.468	2025-05-03 20:50:49.468	\N
a009d4d5-6221-4987-8e4d-063cc01f230c	Ana Laura	Lovato		\N	\N	\N		2025-05-03 20:50:49.468	2025-05-03 20:50:49.468	\N
606d1651-2a77-4da9-a253-16bebb7f6295	Ana Karen	Rodriguez Pérez		anakarenrodriguezperez02@gmail.com	+523221224621	\N		2025-05-03 20:50:49.469	2025-05-03 20:50:49.469	\N
5d89f7a4-229e-4cea-a0e0-63aba638f14c	Andre	Mercier		jmarcandre@hotmail.com	\N	1952-07-28 00:00:00		2025-05-03 20:50:49.469	2025-05-03 20:50:49.469	\N
9c9720b7-2e5b-4720-9b26-f7d5fb962727	Andre Carolina	Casillas Aguilar		a.aguilarsk8@hotmail.com	3227790449	2000-09-23 00:00:00		2025-05-03 20:50:49.469	2025-05-03 20:50:49.469	\N
3f827f63-394a-45f7-bb3f-caa3e7f9b6f6	Andre Martin	Rodriguez Cardenas		andrecardenas57@gmail.com	\N	1995-07-05 00:00:00		2025-05-03 20:50:49.47	2025-05-03 20:50:49.47	\N
392fd1c0-c537-4448-8bbd-ac5d52d79ae7	Ana Laura	Peña Loza		\N	\N	1970-08-04 00:00:00		2025-05-03 20:50:49.47	2025-05-03 20:50:49.47	\N
d3529706-f721-4e1a-bc5b-dc83b75af69f	Ana Karen	Rodriguez Perez		\N	3221224621	\N		2025-05-03 20:50:49.47	2025-05-03 20:50:49.47	\N
cfe9fa59-a086-475d-9217-830db7e01f7a	Ana Marisol	Celdon Olivier		\N	\N	\N		2025-05-03 20:50:49.471	2025-05-03 20:50:49.471	\N
74659485-dba7-4cf1-a1dd-1e1ca9f8c306	Andrea	Duran Cortez		\N	\N	1994-07-22 00:00:00		2025-05-03 20:50:49.471	2025-05-03 20:50:49.471	\N
65489a06-c011-4325-906d-aad629c93ffe	Andrea	Glez		\N	\N	\N		2025-05-03 20:50:49.471	2025-05-03 20:50:49.471	\N
e3379084-ced6-4eb6-b7fd-769bae4099b5	Andrea	Gomez Camarena		andrea.gomezc94@hotmail.com	\N	1994-10-16 00:00:00		2025-05-03 20:50:49.472	2025-05-03 20:50:49.472	\N
6ed95f05-953d-4ced-b2cb-037dec543f7a	Andrea	Gonzalez Corona		andrea.glez.c@hotmail.com	\N	1989-12-03 00:00:00		2025-05-03 20:50:49.472	2025-05-03 20:50:49.472	\N
251ef0c2-af6a-4860-96a9-5da93e6ee111	Andrea	Hernandez  Monje		\N	\N	\N		2025-05-03 20:50:49.472	2025-05-03 20:50:49.472	\N
5c5c8ec7-d0e8-446f-bf20-1a867cc75f7a	Andrea	Lopez Mendez		\N	\N	\N		2025-05-03 20:50:49.473	2025-05-03 20:50:49.473	\N
2a6bc571-9f87-48b3-bd4c-bcd23b8aa7d4	Andrea	Martinez Jimenez		\N	\N	2003-05-26 00:00:00		2025-05-03 20:50:49.473	2025-05-03 20:50:49.473	\N
3ca3b367-22cd-4b86-bc85-9fa1d067ad8d	Andrea	Montes García		\N	\N	1950-02-05 00:00:00		2025-05-03 20:50:49.473	2025-05-03 20:50:49.473	\N
217d08bb-8b2c-40f9-9311-7e9ab324ff41	Andrea	Pacheco Galvan		\N	\N	1995-04-05 00:00:00		2025-05-03 20:50:49.474	2025-05-03 20:50:49.474	\N
d3af41b9-c05e-43fa-a512-3b843049f595	Anahi	Camacho Salvatierra		eanahi_case@hotmail.com	\N	1986-08-23 00:00:00		2025-05-03 20:50:49.474	2025-05-03 20:50:49.474	\N
6670e474-689b-43d6-9f96-61cdd3ac1bd5	Ana Karen	Reyes Rodriguez		\N	8112125664	\N		2025-05-03 20:50:49.474	2025-05-03 20:50:49.474	\N
0dd783ec-e915-42a2-94b6-3843ebf750f2	Andrea Camila	Gomez Sandoval		\N	3222949845	2003-01-23 00:00:00		2025-05-03 20:50:49.475	2025-05-03 20:50:49.475	\N
18f80d84-ff09-4faa-a437-2c5d279e179f	Andrea Camila	Gomez Sandoval		\N	\N	\N		2025-05-03 20:50:49.475	2025-05-03 20:50:49.475	\N
9adaf647-2c89-4322-a037-f9fd104e0aae	Andrea Elizableth	Valenzuela Casillas		andypekebill@live.com	\N	1986-08-13 00:00:00		2025-05-03 20:50:49.475	2025-05-03 20:50:49.475	\N
d1dbab41-2fdf-4706-a054-699a15799bc9	Andrea Guadalupe	Soto Tejada		\N	\N	2014-05-31 00:00:00		2025-05-03 20:50:49.476	2025-05-03 20:50:49.476	\N
33a15dae-695f-4057-aa0c-285fcb7b1d82	Andrea Itzal	Ramírez Garay		\N	\N	2006-09-11 00:00:00		2025-05-03 20:50:49.476	2025-05-03 20:50:49.476	\N
a501c5a1-7523-42b3-bd4d-5a965349d38f	Andrea Paulina	Robles Cuevas		robles.cuevas01@gmail.com	\N	1994-08-01 00:00:00		2025-05-03 20:50:49.476	2025-05-03 20:50:49.476	\N
accb73be-8221-4108-bc1d-06c00ef4b819	Andrea Paulina	Soberon Verástigui		\N	\N	\N		2025-05-03 20:50:49.477	2025-05-03 20:50:49.477	\N
7e4fa01e-c3fa-4003-be42-8502b433604f	Andrea Valeria	Cortez Rendon		\N	\N	1999-07-09 00:00:00		2025-05-03 20:50:49.477	2025-05-03 20:50:49.477	\N
4e7c15f3-cf2a-4522-91ac-8a7ce6cbe7ca	Andree	Simard		lucandree1972@hotmail.ca	\N	1951-06-25 00:00:00		2025-05-03 20:50:49.477	2025-05-03 20:50:49.477	\N
b2098e12-3221-45be-a07c-c36489fbba61	Andrea	Cervantes		acervantesm77@gmail.com	+525545403097	\N		2025-05-03 20:50:49.478	2025-05-03 20:50:49.478	\N
0401cf3f-838e-4f18-abc9-4ed7ee27976d	Andres	Bustos Sanchez		\N	\N	1989-11-24 00:00:00		2025-05-03 20:50:49.478	2025-05-03 20:50:49.478	\N
2d1373d4-4aab-4c93-9d09-0b5423af7300	Anahi	Corona Lemus		\N	2227282293	\N		2025-05-03 20:50:49.478	2025-05-03 20:50:49.478	\N
8b1d34ee-9579-41b8-b8ac-32cd9cad35fa	Andres	Castaño Zamora		\N	\N	1993-12-28 00:00:00		2025-05-03 20:50:49.479	2025-05-03 20:50:49.479	\N
37e9e5b3-5da0-4886-8dc4-1a856fc39c96	Andres	Castellanos Toledano		\N	3221368752	\N		2025-05-03 20:50:49.479	2025-05-03 20:50:49.479	\N
e6fb257b-d99a-40a8-a59b-ce57776bad1e	Andres	Fonceca Delgado		\N	3222991725	1981-06-05 00:00:00		2025-05-03 20:50:49.479	2025-05-03 20:50:49.479	\N
d17efbc5-6710-42e0-9346-2bc7aed8a52f	ANA LAURA	MONTES ROSARIO		ana_060991@hotmail.com	+523222014217	\N		2025-05-03 20:50:49.48	2025-05-03 20:50:49.48	\N
cc7d6a16-8482-4e9f-a247-4445be2e1098	Andres	Gonzalez  Gonzalez		andy_glez01@hotmail.com	\N	1985-10-30 00:00:00		2025-05-03 20:50:49.48	2025-05-03 20:50:49.48	\N
de52baea-2c67-4da2-a9b2-b2dac4c27309	Andres	Gonzalez Palomera		palomera01@jahoo.com	\N	1963-03-01 00:00:00		2025-05-03 20:50:49.48	2025-05-03 20:50:49.48	\N
b5e99950-6fc9-4009-80b6-a82bcd9548bb	Andres	Lucero Durán		andy_burberry@hotmail.com	\N	1993-06-27 00:00:00		2025-05-03 20:50:49.48	2025-05-03 20:50:49.48	\N
72f6c549-b5d9-4798-b1e3-2f43c10df07a	Andres Alberto	González Gonzalez		\N	\N	\N		2025-05-03 20:50:49.481	2025-05-03 20:50:49.481	\N
9f6dee6f-8022-45c8-b316-28463c3a9e11	Anahi	Huerta Agustin		\N	2221059036	\N		2025-05-03 20:50:49.481	2025-05-03 20:50:49.481	\N
758186b3-945b-4ad1-9320-32d8574a5006	Anahi	Huerta		anne.huerta94@gmail.com	+522221059036	\N		2025-05-03 20:50:49.481	2025-05-03 20:50:49.481	\N
301e9f9d-43b3-4e21-83bc-4bddf8580344	Andre	Cliche		gaethur@hotmail.com	\N	\N		2025-05-03 20:50:49.482	2025-05-03 20:50:49.482	\N
9a5f3853-c36f-4057-aff4-45074f757c25	Andres Yahir	Ramirez		\N	\N	2009-10-27 00:00:00		2025-05-03 20:50:49.482	2025-05-03 20:50:49.482	\N
ae568821-858a-4faa-b6c4-645f5a6c6850	Andre	Letendre		andreletendre@hotmail.com	+15145707986	1954-05-17 00:00:00		2025-05-03 20:50:49.482	2025-05-03 20:50:49.482	\N
d04cec6e-be26-4681-a395-8d36111c7bd8	Andrea	Boudreault		\N	\N	1984-10-24 00:00:00		2025-05-03 20:50:49.483	2025-05-03 20:50:49.483	\N
50406de9-efed-4655-8c8c-0f75e506eb53	Andri	Bernard		desembuagequebec@gmail.com	\N	1952-05-18 00:00:00		2025-05-03 20:50:49.483	2025-05-03 20:50:49.483	\N
c6f9eeea-0e62-4ba7-ae35-0ffebe043ec1	Anet	Yañez Crúz		\N	\N	1982-08-19 00:00:00		2025-05-03 20:50:49.483	2025-05-03 20:50:49.483	\N
d3e9f525-4270-48ef-a112-aa4759736ab3	Anastacia	Boudros		\N	3127711906	\N		2025-05-03 20:50:49.484	2025-05-03 20:50:49.484	\N
2c12317f-bb33-468c-9adf-76e5b60d2f2a	Angel	Chacon Talamante		angelchacont@gmail.com	\N	1991-11-08 00:00:00		2025-05-03 20:50:49.484	2025-05-03 20:50:49.484	\N
ef57e40c-14f7-4740-8caa-03bba2649319	Ana María	Mendez Sosa		\N	\N	1974-08-20 00:00:00		2025-05-03 20:50:49.484	2025-05-03 20:50:49.484	\N
0877a349-98c4-40e0-a524-0baf24541134	Angel	Mellado Quintos		mellado_pvr@hotmail.com	\N	1972-11-11 00:00:00		2025-05-03 20:50:49.485	2025-05-03 20:50:49.485	\N
9aa6269d-581c-4631-a286-fb9e3e106bbb	Angel	Merino García		\N	\N	1972-11-11 00:00:00		2025-05-03 20:50:49.485	2025-05-03 20:50:49.485	\N
97f6025c-4eb6-4ccf-bc97-d21b7ec4242e	Angel Alberto	Gonzalez Perez		\N	\N	1992-09-11 00:00:00		2025-05-03 20:50:49.485	2025-05-03 20:50:49.485	\N
084236e9-424e-4407-bd6b-da19a548e13c	Ángel Antonio	Flores Torres		\N	\N	2011-10-06 00:00:00		2025-05-03 20:50:49.486	2025-05-03 20:50:49.486	\N
4f5b0b18-2a00-4ff2-94a2-99f08a342c73	Anahi	Valencia Collazo		\N	3221422173	\N		2025-05-03 20:50:49.486	2025-05-03 20:50:49.486	\N
ea27380e-0f59-4253-a74c-08dcc0dd3718	Angel Isac	Snchez Bautista		\N	\N	2009-05-02 00:00:00		2025-05-03 20:50:49.486	2025-05-03 20:50:49.486	\N
6b8dd050-8a39-4f05-be31-1bd44b3f91e2	Angel Jaime	Alvarez Leyva		alvarezleyva1@hotmail.com	\N	1952-08-06 00:00:00		2025-05-03 20:50:49.487	2025-05-03 20:50:49.487	\N
5eabce43-3649-4310-b425-1df165240fc7	Angel Zair	Romero Llamas		\N	3222292635	2002-02-13 00:00:00		2025-05-03 20:50:49.487	2025-05-03 20:50:49.487	\N
04f31980-ea4b-4a33-886c-2bfeb099d714	Andres Alessandro	Gomez Araiza		\N	3223047963	\N		2025-05-03 20:50:49.487	2025-05-03 20:50:49.487	\N
22ce1b40-f11a-4265-b315-e590ed31db07	Angela	Kunkel		\N	\N	1965-05-26 00:00:00		2025-05-03 20:50:49.488	2025-05-03 20:50:49.488	\N
c9331955-6ceb-4c9e-bb44-8d1b1682efb9	Andrea	Salgado Juarez		\N	3221397909	\N		2025-05-03 20:50:49.488	2025-05-03 20:50:49.488	\N
da87f225-3479-4572-b84c-0fe7606b1a56	Angelberto	Rodriguez Castillon		\N	\N	1956-08-02 00:00:00		2025-05-03 20:50:49.488	2025-05-03 20:50:49.488	\N
82cd5084-7c2d-4122-bdca-f6bb360f1ad1	Andres	Casacuberta Moreno		andrescasacuberta@gmail.com	\N	\N		2025-05-03 20:50:49.489	2025-05-03 20:50:49.489	\N
deb9f82e-224c-403a-9674-cfa7ccbfc4a6	Andres	Gomez Calderón		andygokupower@hotmail.com	\N	2000-08-24 00:00:00		2025-05-03 20:50:49.489	2025-05-03 20:50:49.489	\N
8db124fc-3657-49d0-9fca-8236b1647932	Angeles Geraldine	Ramírez Santana		\N	\N	2004-11-20 00:00:00		2025-05-03 20:50:49.489	2025-05-03 20:50:49.489	\N
83bc00c3-1aa9-4153-8f0a-b34984c70a5a	Andres Eduardo	Ruelas Diaz		\N	\N	\N		2025-05-03 20:50:49.49	2025-05-03 20:50:49.49	\N
500a9825-d62b-45fa-ba0e-5db340dd88ea	Andres Nicolas	Urrutia Crisosto		urrutiaandres@outloock.com	\N	1996-02-01 00:00:00		2025-05-03 20:50:49.49	2025-05-03 20:50:49.49	\N
338ccab0-8310-4bd4-a47d-f52c6699209a	angelica	campos		\N	\N	\N		2025-05-03 20:50:49.49	2025-05-03 20:50:49.49	\N
b37fea08-4733-4ac9-b7a3-1f7b5ddb5175	Angèlica	Duran Tapìa		\N	\N	1960-02-13 00:00:00		2025-05-03 20:50:49.491	2025-05-03 20:50:49.491	\N
c32d3efd-d34e-4024-8d05-2b36a668b77e	Andrea	Sigler		\N	+112062001264	1969-01-19 00:00:00		2025-05-03 20:50:49.491	2025-05-03 20:50:49.491	\N
fe08ac65-1419-40c5-8531-15b925346298	Angelica	Gonzales Corona		\N	\N	1981-06-26 00:00:00		2025-05-03 20:50:49.491	2025-05-03 20:50:49.491	\N
40f117c0-6091-4942-8916-c1655e2a3ebf	Angelica	López Delgadillo		\N	\N	2008-05-21 00:00:00		2025-05-03 20:50:49.491	2025-05-03 20:50:49.491	\N
a04dceb0-0cd3-4168-91d2-4313ac383eb8	Angelica	Lopez Toribio		\N	\N	\N		2025-05-03 20:50:49.492	2025-05-03 20:50:49.492	\N
8d2482da-9f6c-4289-af9f-81e2f3ca41b2	Angelica	Medina Hérnandez		\N	\N	1970-04-11 00:00:00		2025-05-03 20:50:49.492	2025-05-03 20:50:49.492	\N
f760721d-05f5-41ad-9d18-bc44e80ec2fc	Andrew	Ruckemann		ruckemann@hotmail.com	\N	1951-12-02 00:00:00		2025-05-03 20:50:49.492	2025-05-03 20:50:49.492	\N
f8d2bc6a-2a5c-4b1f-b49c-b1dd769c68aa	Angelica	Peña		angie_sazu89@gmail.com	\N	1989-11-27 00:00:00		2025-05-03 20:50:49.493	2025-05-03 20:50:49.493	\N
b9886c9e-5fe0-409b-acb3-b850765f6ac1	Aneth Arabely	Palacios Fletes		anethpalafle@gmail.com	+523221813229	\N		2025-05-03 20:50:49.493	2025-05-03 20:50:49.493	\N
f26c6905-94f6-45ed-b6d5-89fc1ac7126a	Angelica Maria	LLamas Sandoval		camilo3.1416@gmail.com	3221711199	1979-07-25 00:00:00		2025-05-03 20:50:49.493	2025-05-03 20:50:49.493	\N
6c8727b6-c807-4fd7-8a8d-16c2b91c7a27	Angelica Viridiana	Navarrete Perez		viridiana.navarrete95@hotmail.com	\N	1995-06-12 00:00:00		2025-05-03 20:50:49.494	2025-05-03 20:50:49.494	\N
f413f0d7-29c3-4963-a13f-500deb83ee7f	Andrew	Hewitt		\N	+16502090111	\N		2025-05-03 20:50:49.494	2025-05-03 20:50:49.494	\N
56feeb5e-a462-423f-8f09-6789dcf4fd0d	Angelixa	Rains		amgelicarains@gmail.com	\N	1963-05-09 00:00:00		2025-05-03 20:50:49.494	2025-05-03 20:50:49.494	\N
4442c809-7ee5-4ae5-9b8c-224c63000f60	Angie	Poszwa		angepozwa@gmail.com	\N	1976-03-27 00:00:00		2025-05-03 20:50:49.495	2025-05-03 20:50:49.495	\N
83df7ed2-12f6-4420-b148-a1a6391a2f13	Angie Marcela	Restrepo		\N	\N	1997-02-18 00:00:00		2025-05-03 20:50:49.495	2025-05-03 20:50:49.495	\N
f7ecd975-132c-4cf6-b7ee-90c63cd46c7a	Angie Mary	Henrández Bocanegra		\N	\N	\N		2025-05-03 20:50:49.495	2025-05-03 20:50:49.495	\N
513d89b3-0905-4ea7-8475-19d8702936c9	Anguelica Viridiana	Navarrete Perez		viridiana.navarrete85@hotmail.com	\N	\N		2025-05-03 20:50:49.496	2025-05-03 20:50:49.496	\N
a1067913-b24d-4756-893e-a08abd5f8d44	Anibal	Galllegos Arismendi		\N	\N	1973-12-01 00:00:00		2025-05-03 20:50:49.496	2025-05-03 20:50:49.496	\N
a7d5df69-0f5c-4e5e-ab41-0456682e358b	Anibal Tomas	Acuña López		\N	\N	\N		2025-05-03 20:50:49.496	2025-05-03 20:50:49.496	\N
94a12ed4-b55a-40aa-a397-9404fe2e9f7c	Anita	Alvarado Toribio		\N	\N	\N		2025-05-03 20:50:49.497	2025-05-03 20:50:49.497	\N
64d13c54-1b35-4503-b7b0-cb9e9e99f863	Anna	Rudenko		\N	\N	\N		2025-05-03 20:50:49.497	2025-05-03 20:50:49.497	\N
f192d367-a488-4027-9d9f-ffc32eaa5391	Anne	Hognestad		\N	\N	\N		2025-05-03 20:50:49.497	2025-05-03 20:50:49.497	\N
44977c48-555f-4d96-9ba7-619f442f6218	Anne	Markward		amarkward@gmail.com	\N	1959-08-08 00:00:00		2025-05-03 20:50:49.498	2025-05-03 20:50:49.498	\N
c9d78a48-7e9e-4f42-9064-35fa66e24316	Andrea	Cervantes Martinez		\N	5545403097	\N		2025-05-03 20:50:49.498	2025-05-03 20:50:49.498	\N
1fa91ffc-e6bb-4bab-b330-38d1c4eb873f	Annie	Annr		\N	\N	\N		2025-05-03 20:50:49.498	2025-05-03 20:50:49.498	\N
e4e543dc-68ba-48bf-bae1-4a47bc07170c	Annie	Gradilla		\N	\N	\N		2025-05-03 20:50:49.499	2025-05-03 20:50:49.499	\N
f3dde5d9-405f-4d6c-bf5a-1570104e4023	Annie	Grillet		grilletannie@gmail.com	\N	1946-12-01 00:00:00		2025-05-03 20:50:49.499	2025-05-03 20:50:49.499	\N
9126cd8b-8b60-43ab-837b-1bac05a7174c	Annie Saide	Gonzalez Padilla		david.auza@sistemasdigitalespvr.com	\N	1996-05-26 00:00:00		2025-05-03 20:50:49.499	2025-05-03 20:50:49.499	\N
6c8e2dc1-4515-44a6-8bbc-8ad0b3867b72	Anselmo	Torres		\N	\N	2008-01-25 00:00:00		2025-05-03 20:50:49.5	2025-05-03 20:50:49.5	\N
b6afaae4-7e6f-4e76-bb95-66a028470831	Anthony	Robertson		\N	\N	\N		2025-05-03 20:50:49.5	2025-05-03 20:50:49.5	\N
9829bf41-8ef4-48c1-b012-759c93e55e1d	Anthony Sebastian	Sosa Michell		\N	\N	2011-07-10 00:00:00		2025-05-03 20:50:49.5	2025-05-03 20:50:49.5	\N
439a8ac6-2a38-48ee-9eec-62b90807366b	Antonella	Luise		\N	\N	\N		2025-05-03 20:50:49.501	2025-05-03 20:50:49.501	\N
6fa1f87a-0cca-4393-9135-2588a9d6a401	Antonia	Aguilar		\N	\N	1951-04-08 00:00:00		2025-05-03 20:50:49.501	2025-05-03 20:50:49.501	\N
149bac7e-a309-4965-80c5-42b98bba4620	Antonia	Cardenas Velazco		\N	\N	2010-12-13 00:00:00		2025-05-03 20:50:49.501	2025-05-03 20:50:49.501	\N
a46673c7-346e-4174-8621-193e0830512c	Antonia	Cuevas Perez		\N	\N	1966-06-13 00:00:00		2025-05-03 20:50:49.502	2025-05-03 20:50:49.502	\N
dc20af73-b8dd-45fe-b83e-922793be6c4e	Antonia	García Solano		\N	\N	1967-05-10 00:00:00		2025-05-03 20:50:49.502	2025-05-03 20:50:49.502	\N
a7c90d3b-c4a6-4b44-bd54-774cf5a8b0e5	Antonia	Solorzano Montes		solorzano557@hotmail.com	\N	1972-09-11 00:00:00		2025-05-03 20:50:49.502	2025-05-03 20:50:49.502	\N
9be101ef-7c90-4e3c-8094-ce417e0d4aac	Antonia Mayanin	Orihuela Lepe		mayanin8622@gmail.com	\N	1986-10-22 00:00:00		2025-05-03 20:50:49.503	2025-05-03 20:50:49.503	\N
bb38227c-4ad4-445d-9b5e-6673eb100294	Antonieta	Aguilar Rosales		\N	\N	2009-05-12 00:00:00		2025-05-03 20:50:49.503	2025-05-03 20:50:49.503	\N
211222c4-afa1-4af9-8217-aebfe3b519ce	Antonio	Aguilar		\N	\N	1979-11-06 00:00:00		2025-05-03 20:50:49.503	2025-05-03 20:50:49.503	\N
56b2c2be-eca7-4632-b291-35ff816afc66	ANTONIO	AGUILERA GARCIA		\N	\N	\N		2025-05-03 20:50:49.503	2025-05-03 20:50:49.503	\N
db1e8050-ac1c-45b4-b051-174540ac1235	Andres	Alvares Sandoval		\N	3221801054	\N		2025-05-03 20:50:49.504	2025-05-03 20:50:49.504	\N
e84b8039-8539-4079-8b6a-92b7540324aa	Antonio	Barquet Buenfil		barquet47@yahoo.es	\N	1947-09-08 00:00:00		2025-05-03 20:50:49.504	2025-05-03 20:50:49.504	\N
9c825bba-4a3d-41f2-a541-f6bd1ffe6cae	Antonio	Colin Mendoza		\N	\N	2008-07-04 00:00:00		2025-05-03 20:50:49.505	2025-05-03 20:50:49.505	\N
67821851-6ac9-4340-a881-a0f88c5bd559	Angeles	Lugo		ma.lugo@docplanner.com	+527751107375	\N		2025-05-03 20:50:49.505	2025-05-03 20:50:49.505	\N
3fe9da5d-570f-4320-b897-4f02e5efbe5b	Antonio	Gomez Garcia		\N	\N	1972-06-29 00:00:00		2025-05-03 20:50:49.505	2025-05-03 20:50:49.505	\N
e11f58fb-9128-4781-aa0f-3eb90d1fd0f7	Antonio	Guzman Portillo		\N	\N	1968-12-27 00:00:00		2025-05-03 20:50:49.505	2025-05-03 20:50:49.505	\N
cb625bf0-399e-473d-b75b-ffbe3070505e	Antonio	Ibañes Morillas		\N	\N	2009-06-04 00:00:00		2025-05-03 20:50:49.506	2025-05-03 20:50:49.506	\N
b43c3389-be24-4667-a595-bb711e951020	Antonio	Leaño L.de Guevara		\N	\N	\N		2025-05-03 20:50:49.506	2025-05-03 20:50:49.506	\N
0d10056f-7009-48f4-9d2c-603f9eec047c	Antonio	Lorenzo Saldaña		\N	3222755590	1949-07-18 00:00:00		2025-05-03 20:50:49.506	2025-05-03 20:50:49.506	\N
0092f79d-188d-4ea4-9cfe-4bab8653a5a3	Antonio	Mejia Leiva		\N	\N	2010-03-04 00:00:00		2025-05-03 20:50:49.507	2025-05-03 20:50:49.507	\N
ba91907a-5fe2-4a84-a88a-f97826f00cac	Angela	Corley		Traveljunkie2020@outlook.com	+14588032664	\N		2025-05-03 20:50:49.507	2025-05-03 20:50:49.507	\N
79bf0dca-05ec-44a5-804c-2815051fef60	Antonio	Olvera Ramirez		\N	\N	\N		2025-05-03 20:50:49.507	2025-05-03 20:50:49.507	\N
fb19aa6c-1149-427f-a70a-2b5e59d77924	Antonio	Rivera Fernández		el_tigrero_mex@yahoo.com.mx	\N	1951-02-25 00:00:00		2025-05-03 20:50:49.508	2025-05-03 20:50:49.508	\N
bf70c62a-01ff-49e4-83d9-cb4707d85e44	Antonio	Rodriguez		\N	\N	1975-03-10 00:00:00		2025-05-03 20:50:49.508	2025-05-03 20:50:49.508	\N
d428f39c-f818-47f1-806c-6ca53f0005c0	Antonio	Rodríguez Meléndez		\N	\N	1966-12-21 00:00:00		2025-05-03 20:50:49.508	2025-05-03 20:50:49.508	\N
6e68d513-7ef2-4a4c-9235-378152483670	Antonio	Rodriguez Melendez		\N	\N	\N		2025-05-03 20:50:49.509	2025-05-03 20:50:49.509	\N
f4b37860-0a52-4f9e-8c7e-567dc1561037	Antonio	Sanchez Lopez		\N	\N	2009-05-18 00:00:00		2025-05-03 20:50:49.509	2025-05-03 20:50:49.509	\N
04925476-cf87-47d9-a0a2-7ae93f9e0fea	Antonio	Soto Vidal		\N	\N	1952-01-17 00:00:00		2025-05-03 20:50:49.509	2025-05-03 20:50:49.509	\N
31e918b0-39d0-4568-97b9-21081295806a	Antonio Ernesto	Rebollo Tamayo		\N	\N	2001-05-14 00:00:00		2025-05-03 20:50:49.51	2025-05-03 20:50:49.51	\N
6d6ae8d2-0ba6-40fa-8697-3d279dceb92d	Antonio Renato	Acosta Leyva		\N	\N	1978-06-05 00:00:00		2025-05-03 20:50:49.51	2025-05-03 20:50:49.51	\N
9175fb62-64be-44a8-be07-7b7e0a8f757e	Antu	Santiago		\N	\N	2002-10-03 00:00:00		2025-05-03 20:50:49.51	2025-05-03 20:50:49.51	\N
55ef1f2f-cda2-4ad7-b6cc-a388f6de19b9	Anuar	Sahade Espinoza		\N	\N	1982-03-21 00:00:00		2025-05-03 20:50:49.511	2025-05-03 20:50:49.511	\N
fde6f0e1-fbd1-4575-a0e1-22ccbec77519	Anwar	Abaji García		anwarabagi@hotmail.com	\N	1970-08-26 00:00:00		2025-05-03 20:50:49.511	2025-05-03 20:50:49.511	\N
e97a7534-ab6d-40fc-bb6a-81c9096733c6	Apolonio	Gomez Cuevas		\N	\N	\N		2025-05-03 20:50:49.511	2025-05-03 20:50:49.511	\N
f7d7b5ed-ea4b-44c7-821f-f69239194d95	Araceli	De Santiago Ruela		\N	\N	\N		2025-05-03 20:50:49.512	2025-05-03 20:50:49.512	\N
44aa7366-ef3d-4840-989a-8d0886cf106e	Araceli	García de Arce		\N	\N	2006-09-29 00:00:00		2025-05-03 20:50:49.512	2025-05-03 20:50:49.512	\N
8f229479-419a-4d5a-b85a-a57b005503d3	Angela	Torres Villalobos		\N	3221113565	\N		2025-05-03 20:50:49.512	2025-05-03 20:50:49.512	\N
b1f81c19-e6ed-4534-ba98-704bfeb32e66	Araceli	Palomera Mora		aracelipalomera@yahoo.com	\N	\N		2025-05-03 20:50:49.512	2025-05-03 20:50:49.512	\N
352d2fb8-c03e-490a-b9d0-b39ced142be3	Araceli	Pastrana Mendez		armaxi777@gmail.com	\N	1962-09-11 00:00:00		2025-05-03 20:50:49.513	2025-05-03 20:50:49.513	\N
f958a3ab-b9e1-4c5e-bd77-f87c036b5f72	Araceli	Ruano Leonardo		araixoye_33@hotmail.com	3223735887	1987-09-04 00:00:00		2025-05-03 20:50:49.513	2025-05-03 20:50:49.513	\N
245c3e20-973e-42b9-9579-7bccc9ceccd0	Araceli	Vazquez Ramos		\N	\N	1980-12-15 00:00:00		2025-05-03 20:50:49.513	2025-05-03 20:50:49.513	\N
e00e5e60-934d-4460-95df-6e0aaf55c621	Araceli Moncerrat	Camacho Salgado		\N	\N	1992-10-09 00:00:00		2025-05-03 20:50:49.514	2025-05-03 20:50:49.514	\N
564ceb85-39d5-48c4-a10d-9badbe6de902	Aracely	Cuevas Peña		\N	\N	1987-09-15 00:00:00		2025-05-03 20:50:49.514	2025-05-03 20:50:49.514	\N
eb336277-a925-4ecc-8e55-4810cd669f70	Aracely	Delgado		\N	\N	\N		2025-05-03 20:50:49.514	2025-05-03 20:50:49.514	\N
e1ae1d3a-ff87-473f-bf72-fcb7dde963c1	Aranza	Torres Medina		\N	\N	\N		2025-05-03 20:50:49.515	2025-05-03 20:50:49.515	\N
de90bea4-58bf-4b72-900c-6bc824fedc11	Aranzasu	Flores Sanchez		\N	\N	2008-09-11 00:00:00		2025-05-03 20:50:49.515	2025-05-03 20:50:49.515	\N
70d04aba-fe3d-49dc-bc19-8be141c266a3	Aranzazu	Torres Medina		aranzu11@hotmail.com	\N	1991-11-11 00:00:00		2025-05-03 20:50:49.516	2025-05-03 20:50:49.516	\N
80c5fd9d-004d-441a-b59c-3e23c0a1862c	Angeles	Olvera Martínez		\N	3222395942	\N		2025-05-03 20:50:49.516	2025-05-03 20:50:49.516	\N
d6d47406-d75c-4cff-8884-84b4041d07ef	Arcelia	Crúz Hernández		\N	\N	1964-12-18 00:00:00		2025-05-03 20:50:49.516	2025-05-03 20:50:49.516	\N
97ce4ac8-62c5-4818-9783-9c5a277ab627	Ari	Tanur		\N	\N	2008-06-17 00:00:00		2025-05-03 20:50:49.517	2025-05-03 20:50:49.517	\N
b254c350-6e32-4b86-9023-158d2d624c98	Ari	Tanur Pfefer		\N	\N	2008-06-18 00:00:00		2025-05-03 20:50:49.517	2025-05-03 20:50:49.517	\N
5f00aca9-7d84-4876-b624-3ca215c70de6	Angelica	Esteban Rubio		\N	3222744125	\N		2025-05-03 20:50:49.517	2025-05-03 20:50:49.517	\N
c6f01008-5b70-456a-a67d-1e07b822cdff	Ariana	Cortez Sanchez		\N	\N	2006-10-31 00:00:00		2025-05-03 20:50:49.518	2025-05-03 20:50:49.518	\N
979abad4-c7ec-4f76-9a41-0e3d1023d305	Ariana	Delgado Valenzuela		delgadovalenzuela@hotmail.ocm	\N	2000-11-01 00:00:00		2025-05-03 20:50:49.518	2025-05-03 20:50:49.518	\N
d73d39e4-eced-4108-accd-f07cb83d8fda	Ariana Danae	Rondan Ramos		\N	\N	\N		2025-05-03 20:50:49.518	2025-05-03 20:50:49.518	\N
4c11470d-8fb0-4715-a422-3f2fe31a889a	Ariana Elizabeth	Sandoval Rodriguez		arissuperpopulares8@hotmail.com	\N	2002-03-01 00:00:00		2025-05-03 20:50:49.518	2025-05-03 20:50:49.518	\N
2768cf52-30d0-4c04-9c45-45634ba4f519	Arianna	Aldama Castillo		ariana_aldama@msn.com	\N	1988-03-31 00:00:00		2025-05-03 20:50:49.519	2025-05-03 20:50:49.519	\N
882d0245-a637-4ed1-928b-86eb042cfa72	Angelez	Pagaza Farias		\N	3222747252	\N		2025-05-03 20:50:49.519	2025-05-03 20:50:49.519	\N
d751b1e6-2fb7-43df-968f-62567fc05170	Aries Jaqueline	Valencia Negrete		yakii_ari@hotmail.com	\N	1995-04-06 00:00:00		2025-05-03 20:50:49.519	2025-05-03 20:50:49.519	\N
f7736396-2fa8-4f47-aec9-871995a5b3b0	Arleen	Veale Pastrana		\N	\N	2006-10-26 00:00:00		2025-05-03 20:50:49.52	2025-05-03 20:50:49.52	\N
826b0cd9-48df-498f-8f0d-ab7f7a956f37	Arleth Stephania	Ruelas		maryruelas@hotmail.com	\N	2001-11-09 00:00:00		2025-05-03 20:50:49.52	2025-05-03 20:50:49.52	\N
98221b10-7715-4ea0-af93-6f782fab448d	Armando	Aceves Bahena		\N	\N	1975-09-02 00:00:00		2025-05-03 20:50:49.52	2025-05-03 20:50:49.52	\N
242efe47-5f48-40a5-9c38-6f351338db08	Armando	Alvarez Lopez		\N	\N	2008-03-31 00:00:00		2025-05-03 20:50:49.521	2025-05-03 20:50:49.521	\N
e17277ad-a04b-41d2-b95e-ee111289f9d9	Armando	Cazar		\N	\N	\N		2025-05-03 20:50:49.521	2025-05-03 20:50:49.521	\N
d10ebe5b-c763-4f25-9bee-4dd08455a9d2	Armando	Garcia Gama		armando.garciagana8@gmail.com	\N	1987-07-11 00:00:00		2025-05-03 20:50:49.521	2025-05-03 20:50:49.521	\N
0dec4513-41c0-460a-8cee-f79e935c04be	Angel	Medina		\N	\N	\N		2025-05-03 20:50:49.522	2025-05-03 20:50:49.522	\N
c64c3fd7-363d-4d3a-8854-5700eb4f66bf	Angelica	Briseño Curiel		\N	3222058100	\N		2025-05-03 20:50:49.522	2025-05-03 20:50:49.522	\N
8073101d-fa13-4404-91fd-9631f3ecb777	Armando	Gutierres Franco		\N	\N	1960-10-05 00:00:00		2025-05-03 20:50:49.522	2025-05-03 20:50:49.522	\N
65149860-86a4-4a42-a4d6-3c663c70267d	Armando	Lua Sanchez		rojodragon.70@gmail.com	\N	1974-05-07 00:00:00		2025-05-03 20:50:49.523	2025-05-03 20:50:49.523	\N
27ee8dda-b6f3-48b0-88db-41baeb8bfe2a	Armando	Ponce Rodriguez		\N	\N	\N		2025-05-03 20:50:49.523	2025-05-03 20:50:49.523	\N
e88e1d3b-3b1f-4d13-8a98-1318402f2622	Armando Daniel	Perez Venengas		\N	\N	2006-11-18 00:00:00		2025-05-03 20:50:49.523	2025-05-03 20:50:49.523	\N
8fb75e88-e9fb-4198-a445-34a1d9471d0d	Armando Rafael	García Panuco		epi.fishing@gmil.com	\N	2008-04-07 00:00:00		2025-05-03 20:50:49.524	2025-05-03 20:50:49.524	\N
dd6a009f-27e3-4fb6-be8b-fbff26d05fbb	Arnold	Dyck		arnolddyck@hotmail.com.com	\N	2017-03-31 00:00:00		2025-05-03 20:50:49.524	2025-05-03 20:50:49.524	\N
cba855e3-92f3-42ed-a9e0-c037d9149b3f	Arnoldo	Mendoza Guzman		arnoldom425@gmail.com	\N	1980-06-14 00:00:00		2025-05-03 20:50:49.524	2025-05-03 20:50:49.524	\N
f1bf2ed8-2c7f-4785-b7e8-00207610885d	Arnulfo	García Garcia		\N	\N	\N		2025-05-03 20:50:49.524	2025-05-03 20:50:49.524	\N
24b84d5a-699f-4dc8-a486-b2ba6939cfb6	Arnulfo	Gonzales Barrera		\N	\N	\N		2025-05-03 20:50:49.525	2025-05-03 20:50:49.525	\N
5f70e097-3947-41fa-9d73-978561f22ec7	Arón	Reyes		aron.vallarta@hotmail.com	\N	1963-08-22 00:00:00		2025-05-03 20:50:49.525	2025-05-03 20:50:49.525	\N
c3db83af-d424-48b4-aa27-48d62820c3cd	Aron	Rivas		\N	\N	\N		2025-05-03 20:50:49.525	2025-05-03 20:50:49.525	\N
86a25303-ab71-4a39-bd10-b54c44c7ff41	Artemio	de León Partida		\N	\N	\N		2025-05-03 20:50:49.526	2025-05-03 20:50:49.526	\N
bf9e2470-ba46-4b35-a728-7c5c9527242c	Artenio	Maldonado Vilchis		\N	\N	\N		2025-05-03 20:50:49.526	2025-05-03 20:50:49.526	\N
9d800be4-d173-4260-8459-8679ff8b8a56	Arthur	Rudenko		\N	\N	\N		2025-05-03 20:50:49.526	2025-05-03 20:50:49.526	\N
fcf6dd23-5d08-4346-8982-58d99ce64b36	Arturo	Chavez Albarran		\N	\N	\N		2025-05-03 20:50:49.527	2025-05-03 20:50:49.527	\N
642de6f0-4583-40ff-ba9d-9dddc762f528	Arturo	Davalos Peña		avalos37@hotmail.com	\N	1965-04-26 00:00:00		2025-05-03 20:50:49.527	2025-05-03 20:50:49.527	\N
ee9da5a0-3c14-493f-ab55-0dbb1babe17f	Arturo	Davalos Vazquez del mercado		\N	\N	1976-07-06 00:00:00		2025-05-03 20:50:49.527	2025-05-03 20:50:49.527	\N
0b18ba0f-285a-4dc9-9307-d8e76785a9c1	Arturo	General		\N	\N	\N		2025-05-03 20:50:49.528	2025-05-03 20:50:49.528	\N
f00e04d0-ccbe-4bf2-971c-3bde87b8ecf1	Arturo	Gonzales		\N	\N	2009-11-30 00:00:00		2025-05-03 20:50:49.528	2025-05-03 20:50:49.528	\N
2a6d6178-e5d1-4722-9877-fc840d2c400b	Arturo	Granados Yañez		\N	\N	1976-11-08 00:00:00		2025-05-03 20:50:49.528	2025-05-03 20:50:49.528	\N
a2a06746-f490-4077-aadc-b7f138121cc9	Annick	Nivaud		\N	\N	1945-11-18 00:00:00		2025-05-03 20:50:49.529	2025-05-03 20:50:49.529	\N
227e95dc-2506-46f5-8ae3-7867811e42ea	Arturo	Hernández Soto		arturo.hdz.soto@gmail.com	\N	1989-06-30 00:00:00		2025-05-03 20:50:49.529	2025-05-03 20:50:49.529	\N
783c29fb-a787-46aa-8d09-cbf146a38cff	Angelica Esbeidy	Hernández Dueñas		\N	3223526861	\N		2025-05-03 20:50:49.529	2025-05-03 20:50:49.529	\N
abca24c5-30c0-4b03-b604-0298119fa92f	Arturo	Ramirez Torres		\N	\N	2008-04-07 00:00:00		2025-05-03 20:50:49.529	2025-05-03 20:50:49.529	\N
b4463443-db9f-4db4-b691-8a08fb081751	Arturo	Robles Quezada		\N	\N	1985-09-24 00:00:00		2025-05-03 20:50:49.53	2025-05-03 20:50:49.53	\N
5fefb024-8a30-4a16-ba21-c6e159b5b217	Arturo	Sanchez Mercado		\N	\N	2007-04-25 00:00:00		2025-05-03 20:50:49.53	2025-05-03 20:50:49.53	\N
843a2122-eba6-4f2b-a225-ced3e124d243	Arturo Adonis	Dimate Ardila		\N	\N	1964-08-28 00:00:00		2025-05-03 20:50:49.531	2025-05-03 20:50:49.531	\N
e476f418-993d-44a5-968f-86b7dcffb4fa	Arturo Israel	Villegas Morquecho		\N	\N	1994-12-31 00:00:00		2025-05-03 20:50:49.531	2025-05-03 20:50:49.531	\N
c1394d5c-097a-4ce5-98f2-262f4f43301e	Arturo Martín	Guillen Jimenez		\N	\N	2009-06-04 00:00:00		2025-05-03 20:50:49.531	2025-05-03 20:50:49.531	\N
70ad00db-fc7e-4b06-b72a-cef62ae91d2e	Arum	Rajaram Prasad		\N	\N	1970-03-05 00:00:00		2025-05-03 20:50:49.532	2025-05-03 20:50:49.532	\N
4d819bcc-535d-4eeb-9f8d-244728e41a7e	Asaf Alejandro	Rufino Padilla		\N	\N	2008-04-05 00:00:00		2025-05-03 20:50:49.532	2025-05-03 20:50:49.532	\N
356a8057-47ce-4864-b2e2-9031df739519	Ashley	Contreras		\N	\N	2001-10-08 00:00:00		2025-05-03 20:50:49.532	2025-05-03 20:50:49.532	\N
1e65868a-e971-4c7b-94d8-182fa75eafe3	Angel Arturo	Castillon señas		\N	3881053309	\N		2025-05-03 20:50:49.533	2025-05-03 20:50:49.533	\N
82705051-e1c1-4944-89ec-d3b84a4a2f9a	Angelica	Mejia		angelica_mejiah@hotmail.com	+525555092404	\N		2025-05-03 20:50:49.533	2025-05-03 20:50:49.533	\N
ce3ebf8b-41dd-4a95-80e6-e0be319cbfa8	Assenet	Chavez Rodríguez		\N	\N	\N		2025-05-03 20:50:49.533	2025-05-03 20:50:49.533	\N
d65e84d2-9ef4-4e56-acd1-d0871b40ae3f	Astelbina	Rodriguez Amaran		gloria.sayulita@gmail.com	\N	1962-06-24 00:00:00		2025-05-03 20:50:49.534	2025-05-03 20:50:49.534	\N
3ba84e4f-e1ad-43d2-a4da-71e72a323673	Asucena	Vivanco Castro		\N	\N	1983-09-05 00:00:00		2025-05-03 20:50:49.534	2025-05-03 20:50:49.534	\N
2eed0913-d3fe-4ace-8984-547d6decd3e7	Atanasia	Navarrete Alvarado		\N	\N	1945-05-03 00:00:00		2025-05-03 20:50:49.534	2025-05-03 20:50:49.534	\N
74ab2a9b-7571-4aee-a0f4-fffbe5459d00	Atenea	Villasana Torres		Sandragtorres_7@hotmail.com	\N	2010-08-09 00:00:00		2025-05-03 20:50:49.534	2025-05-03 20:50:49.534	\N
84a572b4-f931-4bff-9de5-a419227ee4de	Atenogenes	Pineda Duque		\N	\N	1965-01-18 00:00:00		2025-05-03 20:50:49.535	2025-05-03 20:50:49.535	\N
025fa307-c007-4417-ae84-7c3c54ce0c3c	Atiel Omar	Contreras Castrejon		\N	\N	2012-02-08 00:00:00		2025-05-03 20:50:49.535	2025-05-03 20:50:49.535	\N
3f10afdd-1019-4df3-a92c-70c0ca416614	Atzin	Soriano Gléz.		atzin_93@hotmail.com	\N	1993-05-26 00:00:00		2025-05-03 20:50:49.535	2025-05-03 20:50:49.535	\N
414bceff-a60e-46f6-b244-b1b8d9636935	Atzin	Soriano Gonzales		atzin_93@hotmail.com	\N	1993-05-26 00:00:00		2025-05-03 20:50:49.536	2025-05-03 20:50:49.536	\N
d87e1f68-d14f-4665-8ede-239ae34fafab	Aura Marina	Silvera  de James		\N	\N	1965-05-21 00:00:00		2025-05-03 20:50:49.536	2025-05-03 20:50:49.536	\N
e238fdbb-1f42-4964-970a-cae12066002d	Aurel	Lavinge		\N	\N	1959-02-10 00:00:00		2025-05-03 20:50:49.536	2025-05-03 20:50:49.536	\N
b112b41c-594a-4f91-a3c6-aaa1f3e00f56	Aurelia	¨Padilla Renteria		\N	\N	\N		2025-05-03 20:50:49.537	2025-05-03 20:50:49.537	\N
cfce5868-f986-48b1-8df4-eb05d774a2b4	Aurelio	Espinosa Ruelas		\N	\N	1987-09-25 00:00:00		2025-05-03 20:50:49.537	2025-05-03 20:50:49.537	\N
24b7e945-39a8-4ad1-a36c-84399d95a6c5	Aurora	Castellanos Dávila		\N	\N	1959-07-24 00:00:00		2025-05-03 20:50:49.537	2025-05-03 20:50:49.537	\N
193e68e6-d0d4-4ad8-8f06-6b6e1fd32e2c	Aurora	De la Rosa Hernandez		\N	\N	\N		2025-05-03 20:50:49.538	2025-05-03 20:50:49.538	\N
693c6dc4-32fb-486c-bf2b-2f02a866d046	Avelina	Muñiz Rodriguez		\N	\N	2005-09-27 00:00:00		2025-05-03 20:50:49.538	2025-05-03 20:50:49.538	\N
6790b338-240c-47e8-9dbc-b3a23d7c9bac	Avelino	Castañeda López		\N	\N	1934-07-03 00:00:00		2025-05-03 20:50:49.538	2025-05-03 20:50:49.538	\N
e26d1ecb-d202-4aa5-9641-d13700682ef3	Araceli	Montenegro		\N	\N	1943-06-09 00:00:00		2025-05-03 20:50:49.539	2025-05-03 20:50:49.539	\N
5d05ad17-0010-4cf9-aa34-2dc81a3b6086	Axel	Gomez Peña		\N	\N	2010-05-28 00:00:00		2025-05-03 20:50:49.539	2025-05-03 20:50:49.539	\N
da00d13b-ca60-4174-8d78-61ed8726b198	Axel	Samaniego		oxidonitrico2010@hotmail.com	\N	1982-09-05 00:00:00		2025-05-03 20:50:49.539	2025-05-03 20:50:49.539	\N
1ddc7f1d-a6bb-423e-9ce7-42064c3cf040	Antonio	Galvan Garcia		\N	3221503146	\N		2025-05-03 20:50:49.54	2025-05-03 20:50:49.54	\N
6f14489c-85e1-45ca-9452-a9dddd33994c	Axel fernando	Aragón Gonzalez		\N	\N	2009-03-24 00:00:00		2025-05-03 20:50:49.54	2025-05-03 20:50:49.54	\N
8b600beb-8b89-4bd7-9a5d-87867d6070bd	Axel Maritn	Gomez Bernal		alcachofa-mar@hotmail.com	\N	\N		2025-05-03 20:50:49.54	2025-05-03 20:50:49.54	\N
7012b1a1-e9cd-4271-8a67-425e87a1741a	Antonio	Alcazar		\N	3228881539	\N		2025-05-03 20:50:49.54	2025-05-03 20:50:49.54	\N
3f06e68e-01ec-4c0f-a030-5b944dfd8848	Axel Yamil	Valle Sanchez		\N	\N	2001-12-22 00:00:00		2025-05-03 20:50:49.541	2025-05-03 20:50:49.541	\N
d3579478-8b43-4278-8702-37152de3ea7e	Ariel	Pacheco Ortiz		\N	3221059463	\N		2025-05-03 20:50:49.541	2025-05-03 20:50:49.541	\N
f5fdaa9f-8ccf-480f-a147-c63640aff506	AYMI	LAMB		thisnativeheart@gmail.com	\N	1977-09-29 00:00:00		2025-05-03 20:50:49.542	2025-05-03 20:50:49.542	\N
d9d9b94f-4c61-4df1-b517-504c642f91de	Ariana	Aldama Castillo		\N	3221005608	\N		2025-05-03 20:50:49.542	2025-05-03 20:50:49.542	\N
b1b23b88-81da-4ac8-9c81-4a4f3b900386	Azusena	Gomez Rodriguez		\N	\N	\N		2025-05-03 20:50:49.542	2025-05-03 20:50:49.542	\N
6e741dd5-9e27-475d-bfee-e41326468135	Arcelia	Bueno Diaz		4arcelia.bueno@gmail.com	+526674795544	\N		2025-05-03 20:50:49.543	2025-05-03 20:50:49.543	\N
3211c2fd-4508-4e42-a436-a731ecad99c0	Barbar	Castle		castlebl@comcast.net	\N	1960-04-05 00:00:00		2025-05-03 20:50:49.543	2025-05-03 20:50:49.543	\N
af090715-f8e2-4075-a676-c5e9c38b0fd5	Barbara	Alvarez		barbarascabos@live.com.mx	\N	1971-10-07 00:00:00		2025-05-03 20:50:49.543	2025-05-03 20:50:49.543	\N
daa89e91-4ae3-479d-84bc-a37d41f085b7	Barbara	Bravo Zenteno		\N	\N	2007-06-01 00:00:00		2025-05-03 20:50:49.544	2025-05-03 20:50:49.544	\N
8e89f56d-a273-4e62-9835-27291699ebdf	Barbara	Iglesias Larrazolo		\N	\N	1957-05-12 00:00:00		2025-05-03 20:50:49.544	2025-05-03 20:50:49.544	\N
bf262cbe-8517-4b77-945f-8e48d0920fdc	Angelina	lomeli Lopez		\N	\N	2008-02-08 00:00:00		2025-05-03 20:50:49.545	2025-05-03 20:50:49.545	\N
c63d039a-f58d-4cd1-b38c-d1bbf5ce46b8	Barbara	Martin		barbaralmartin@outlook.com	\N	1955-04-24 00:00:00		2025-05-03 20:50:49.545	2025-05-03 20:50:49.545	\N
bcc9c763-239f-425d-84ec-2a2390b987f9	BARBARA	SKORA		\N	\N	\N		2025-05-03 20:50:49.545	2025-05-03 20:50:49.545	\N
a2bd0007-d543-41b1-87a7-a974e19050cf	Arturo	Ortiz Sandoval		\N	3222252707	\N		2025-05-03 20:50:49.545	2025-05-03 20:50:49.545	\N
2e20f08a-6408-4f2a-a78f-771febf5a38a	Barbara	Steinberg		artsiebarb1@gmail.com	\N	1946-05-12 00:00:00		2025-05-03 20:50:49.546	2025-05-03 20:50:49.546	\N
e7a4c932-39f6-4a7d-9af6-af6c47074bbe	Barbara Georgina	Nolasco Gomez		\N	\N	2009-11-29 00:00:00		2025-05-03 20:50:49.546	2025-05-03 20:50:49.546	\N
22265691-3d44-4e33-a683-e33ed85d029b	Barbara Monserrat	Jimenez Betancourt		\N	\N	\N		2025-05-03 20:50:49.546	2025-05-03 20:50:49.546	\N
0539ea5e-32bd-4ef2-9233-95de90b9a85d	Barry	XXX		\N	\N	\N		2025-05-03 20:50:49.547	2025-05-03 20:50:49.547	\N
88bac199-976a-4228-b8e7-30a4431434bf	Antonio	Meza Escobedo		\N	3222656858	\N		2025-05-03 20:50:49.547	2025-05-03 20:50:49.547	\N
ffc64611-2e1c-4205-90f1-6da94f168137	Baruc	Gutierrez Landin		barucgutiland@gmail.com	3222996513	2005-09-26 00:00:00		2025-05-03 20:50:49.547	2025-05-03 20:50:49.547	\N
6fdf3df8-2b8b-4055-80f4-524d6678e9e8	Bastiaan	karsten		\N	\N	\N		2025-05-03 20:50:49.548	2025-05-03 20:50:49.548	\N
f2be69ff-a831-48c0-aff6-5a2594d70f61	Ashley	Ray		ashleyray1@gmail.com	+19126632735	1983-07-05 00:00:00		2025-05-03 20:50:49.548	2025-05-03 20:50:49.548	\N
5f4ec506-438f-46c4-ab36-95e510ad246f	Beatris	Sanchez Martinez		\N	\N	2010-03-22 00:00:00		2025-05-03 20:50:49.548	2025-05-03 20:50:49.548	\N
bef1a27b-4bd9-47ff-b9b4-ec1935d7149a	Beatriz	Gonzalez Méndez		beatrizgonzales.14@hotmail.com	\N	1975-03-14 00:00:00		2025-05-03 20:50:49.549	2025-05-03 20:50:49.549	\N
648d11be-6365-4b7e-894b-4bb0cb682929	Armando	Garcia Rosas		\N	3221040184	\N		2025-05-03 20:50:49.549	2025-05-03 20:50:49.549	\N
2e80925c-b328-458e-bbf7-f1367a7ed1f8	Axel Alejandro	Herrera Goméz		\N	\N	\N		2025-05-03 20:50:49.549	2025-05-03 20:50:49.549	\N
ad9e3943-d0fa-4c0d-a5e5-808271001317	Beatriz	Miksche		\N	3222948552	\N		2025-05-03 20:50:49.55	2025-05-03 20:50:49.55	\N
1be27ef5-91eb-4fe6-91c1-70c9aa9021eb	Beatriz	Polanco Gamboa		bea.plox.85@gmail.com	\N	1985-10-12 00:00:00		2025-05-03 20:50:49.55	2025-05-03 20:50:49.55	\N
5586513d-47a6-4c75-9b28-3bc2645af019	Beatriz	Ramos Rodriguez		\N	\N	\N		2025-05-03 20:50:49.55	2025-05-03 20:50:49.55	\N
9292beb2-88c3-45f7-a033-704270a713e1	Beatriz	Reyes Flores		beatriz-vallarta@live.com.mx	\N	1972-10-25 00:00:00		2025-05-03 20:50:49.551	2025-05-03 20:50:49.551	\N
374f7078-9a9b-4e09-b130-877f7397f6c5	Beatriz Gabriela de Jesus	Mendoza		\N	\N	1950-01-15 00:00:00		2025-05-03 20:50:49.551	2025-05-03 20:50:49.551	\N
48b33e47-f159-4d6b-bb8e-ddd0c69b6561	Begoña	Malo Villasante		be.malo.vi@gmail.com	\N	1993-09-09 00:00:00		2025-05-03 20:50:49.551	2025-05-03 20:50:49.551	\N
8ea1011a-c87d-4158-9112-96262ea253f4	Axel Osvaldo	García Mora		\N	\N	\N		2025-05-03 20:50:49.551	2025-05-03 20:50:49.551	\N
f1a125f1-8c43-445a-929b-80febbf55608	Belen	Gonzalez Diáz		\N	\N	2009-11-09 00:00:00		2025-05-03 20:50:49.552	2025-05-03 20:50:49.552	\N
ab8f76f0-70ec-4a88-ae5b-113798e43229	Belen	Licea Muñoz		\N	\N	1942-01-24 00:00:00		2025-05-03 20:50:49.552	2025-05-03 20:50:49.552	\N
efceb6f2-e822-402e-b518-bc09a94c5a07	Belin	Villasante Paillaud		belinuvp@yahoo.com.mx	\N	1964-02-22 00:00:00		2025-05-03 20:50:49.552	2025-05-03 20:50:49.552	\N
7710bea5-fddc-430b-b36d-beb880273ec9	Belin	Villasante Pailliud		belinvp@yahoo.com.mx	\N	\N		2025-05-03 20:50:49.553	2025-05-03 20:50:49.553	\N
d7540bbe-7445-4355-bdb2-05b0872a6b48	Belinda	Derenia		bderenia@gamil.com	\N	1967-10-16 00:00:00		2025-05-03 20:50:49.553	2025-05-03 20:50:49.553	\N
f433ae3d-20f5-4f75-962e-6d8f54f0799f	Belinda	Lepe Flores		\N	3223060940	1976-08-12 00:00:00		2025-05-03 20:50:49.554	2025-05-03 20:50:49.554	\N
ffa681bb-f411-439a-9901-0d1ca972e90d	Beliza	Rojas Hernandez		\N	\N	\N		2025-05-03 20:50:49.554	2025-05-03 20:50:49.554	\N
a24ae421-3597-45c2-807d-224eb6419cca	Bella Angeline	Franco Vazquez		\N	\N	2013-01-22 00:00:00		2025-05-03 20:50:49.554	2025-05-03 20:50:49.554	\N
bd73a131-b2a6-4479-b6e6-5e1a4e8b1fb0	Benita	Barajas Hermocillo		diasbarajas7475@hotmai.com	\N	1975-08-29 00:00:00		2025-05-03 20:50:49.555	2025-05-03 20:50:49.555	\N
d4d363dc-41b4-49e9-a778-09c30ced66e3	Benita	Perez Hernandez		\N	\N	1939-04-03 00:00:00		2025-05-03 20:50:49.555	2025-05-03 20:50:49.555	\N
947b9d46-fb71-4e6d-8980-4423dd9b474e	Ayali Paola	Gutierrez Vega		\N	\N	\N		2025-05-03 20:50:49.555	2025-05-03 20:50:49.555	\N
9c47e529-ab44-4941-9c4f-6424189e7be9	Benito	Cruz Ruiz		\N	\N	1992-08-05 00:00:00		2025-05-03 20:50:49.555	2025-05-03 20:50:49.555	\N
710d2afb-079f-4583-9f7a-734f7787b0f1	Benjamin	Gonzales Orosco		\N	\N	2010-05-14 00:00:00		2025-05-03 20:50:49.556	2025-05-03 20:50:49.556	\N
1c407f74-c0b3-4c56-829b-8e555ec30f78	Benjamin	Kosiek		\N	\N	2000-06-30 00:00:00		2025-05-03 20:50:49.556	2025-05-03 20:50:49.556	\N
cbc1672e-5248-42d0-b77f-94210380b992	Benjamin	Pashley		\N	\N	2012-10-20 00:00:00		2025-05-03 20:50:49.556	2025-05-03 20:50:49.556	\N
d17c9559-518e-4f6d-8f08-a772d514e023	Azucena	Quintero Hernández		azucenaqh85@hotmail.com	\N	1985-02-27 00:00:00		2025-05-03 20:50:49.557	2025-05-03 20:50:49.557	\N
75daf53c-4e94-4fb6-93e1-0acaa22d4f05	Armando	Gomez García		\N	3320346158	\N		2025-05-03 20:50:49.557	2025-05-03 20:50:49.557	\N
32f134c0-3bab-4476-b447-fb76ee5cc51b	BENOIT	BEAUDRY		\N	\N	\N		2025-05-03 20:50:49.557	2025-05-03 20:50:49.557	\N
1a08b7b4-bfd8-400f-a1ee-cb687a50caca	Berenice	López		\N	3227797433	1940-04-26 00:00:00		2025-05-03 20:50:49.558	2025-05-03 20:50:49.558	\N
e582e78f-cc05-430b-a312-38f39b830e50	Berenice	Lucero Sabiñon		\N	\N	2011-03-02 00:00:00		2025-05-03 20:50:49.558	2025-05-03 20:50:49.558	\N
37ae56d9-6e4a-4ee4-997d-7a3a65331a2a	Berenice	Orozco Mora		\N	\N	2009-10-28 00:00:00		2025-05-03 20:50:49.558	2025-05-03 20:50:49.558	\N
f3677b34-1d94-400b-8e71-8a8cccd498e6	Berlin Karime	Ortiiz Torres		\N	\N	\N		2025-05-03 20:50:49.559	2025-05-03 20:50:49.559	\N
bd678631-628f-4c1e-a3db-ee1edf841957	Bernabe	Cienfuegos Castillo		bernabe-100@hotmail.com	\N	1955-06-11 00:00:00		2025-05-03 20:50:49.559	2025-05-03 20:50:49.559	\N
7df43710-2ec5-4321-9b8d-571d3ce2c468	Bartolome	Mendoza Guiberra		\N	\N	\N		2025-05-03 20:50:49.56	2025-05-03 20:50:49.56	\N
4483c305-19a7-4202-af1c-b4ab2205f0ec	Bernard	Davidson		myst9@hotmail.com	\N	1954-10-26 00:00:00		2025-05-03 20:50:49.56	2025-05-03 20:50:49.56	\N
49d56143-e4c5-4be9-b2a6-ba576d547cdd	Bernardo	Castillo Morales		cama.films@gmail.com	\N	1968-04-04 00:00:00		2025-05-03 20:50:49.56	2025-05-03 20:50:49.56	\N
01f8df2f-d728-4c65-aa3a-be8a9e409221	bernardo	Delgado Valenzuela		\N	\N	1999-03-15 00:00:00		2025-05-03 20:50:49.56	2025-05-03 20:50:49.56	\N
a89bcd92-3e53-4661-a5fb-4123afb9b8fd	Avner	Fireman		\N	+18025561904	\N		2025-05-03 20:50:49.561	2025-05-03 20:50:49.561	\N
c75eef02-55eb-4c8e-8c81-4b3ea1e70193	Berta	estrada Crúz		\N	\N	2009-09-28 00:00:00		2025-05-03 20:50:49.561	2025-05-03 20:50:49.561	\N
49ed3422-f495-4ef4-a71a-2acb46bd413a	Berta	Vitela Chavez		\N	\N	1951-03-17 00:00:00		2025-05-03 20:50:49.561	2025-05-03 20:50:49.561	\N
14c57a3e-0278-4b0d-8583-65ee0a029adf	Berta Alicia	Colmenares Colmenares		\N	\N	1966-04-11 00:00:00		2025-05-03 20:50:49.562	2025-05-03 20:50:49.562	\N
4378f988-f82a-4f91-92f8-0867666ce2a8	Berta Alicia	Rodriguez Rodriguez		\N	\N	2011-03-03 00:00:00		2025-05-03 20:50:49.562	2025-05-03 20:50:49.562	\N
b67cdd05-e407-4889-955f-c3df3841682a	Betsi	Magallon		\N	\N	\N		2025-05-03 20:50:49.562	2025-05-03 20:50:49.562	\N
eeffcfa3-4472-46bf-813c-cfecb3238777	Betty Pirs	Mclaughlin		roadpartner@me.com	\N	1954-06-14 00:00:00		2025-05-03 20:50:49.563	2025-05-03 20:50:49.563	\N
20e7ff15-5e7b-4fda-933a-c0c38bd64a62	Ashley	Haumada		\N	6653928972	\N		2025-05-03 20:50:49.563	2025-05-03 20:50:49.563	\N
f40976da-7608-4535-843c-d80a7c9ae87f	Beatris	Pichardo Mendoza		woodymex@yahoo.com	\N	2009-02-24 00:00:00		2025-05-03 20:50:49.563	2025-05-03 20:50:49.563	\N
06ccc034-a537-4206-9c4e-65292a793a92	Bibiana	Alvarado Dueñas		\N	\N	1962-10-22 00:00:00		2025-05-03 20:50:49.564	2025-05-03 20:50:49.564	\N
bf7c9f5a-ccbb-4e91-ac72-1ead50ccd8aa	Bibiana	Blanco		\N	\N	\N		2025-05-03 20:50:49.564	2025-05-03 20:50:49.564	\N
d6621578-8364-441b-8234-5e7c3d9fb735	Bibiana	Escobedo Acevez		bibi-121281@hotmail.com	\N	1981-12-12 00:00:00		2025-05-03 20:50:49.564	2025-05-03 20:50:49.564	\N
10381cc7-40e1-4aff-a659-be5cdf62282e	Bijan	Pourat		antiagingbybijan@hotmail.com	\N	1947-04-20 00:00:00		2025-05-03 20:50:49.565	2025-05-03 20:50:49.565	\N
2a2d8b3d-864a-482c-90c5-14e2e4f46ad0	Blair	Macey		bmacey@telusplanet.net	3223804336	1959-09-16 00:00:00		2025-05-03 20:50:49.565	2025-05-03 20:50:49.565	\N
45c8dc43-a55b-463f-8ea8-2713cd3713c1	Blanca	Aguilera		\N	\N	2009-06-24 00:00:00		2025-05-03 20:50:49.565	2025-05-03 20:50:49.565	\N
6fd44c4e-0150-47ce-b36f-2d2c1c0f8845	Blanca	Barraza Manjarres		\N	\N	1958-09-04 00:00:00		2025-05-03 20:50:49.566	2025-05-03 20:50:49.566	\N
c0a0d035-6721-4963-8760-cea7bd4e119a	Blanca	Diaz Barajas		blanca.diasbarajas@gmail.com	\N	2001-09-21 00:00:00		2025-05-03 20:50:49.566	2025-05-03 20:50:49.566	\N
34cc1f2a-7464-43e9-a236-2d1a78ef5200	Blanca	Durand		\N	\N	2010-05-10 00:00:00		2025-05-03 20:50:49.566	2025-05-03 20:50:49.566	\N
4df661da-36a2-49eb-a60c-29d209b18ca2	Blanca	Garcia Torres		\N	\N	1956-09-25 00:00:00		2025-05-03 20:50:49.567	2025-05-03 20:50:49.567	\N
745cb462-a404-4b6b-8ae2-42f1c986e532	Blanca	Mejia		sudzal@hotmail.cm	\N	1971-12-07 00:00:00		2025-05-03 20:50:49.567	2025-05-03 20:50:49.567	\N
6b76da7b-133f-49db-b9a6-df3c0928f68f	Blanca	Morales de Lezama		blancaasesorpv@gmail.com	\N	1973-07-28 00:00:00		2025-05-03 20:50:49.567	2025-05-03 20:50:49.567	\N
1b2251ed-8e4f-4595-ad0c-7d74d5ab4b5c	Blanca	Morales Gomez		\N	3221356485	1973-07-28 00:00:00		2025-05-03 20:50:49.567	2025-05-03 20:50:49.567	\N
7f4d4235-2853-4859-b91c-8ba7070445f9	Blanca	Sanchez Gonzales		\N	\N	1947-02-04 00:00:00		2025-05-03 20:50:49.568	2025-05-03 20:50:49.568	\N
3372f7d7-5e96-4c81-a568-e512181d6871	Blanca	Sanchez Rodtriguez		blanquitta@hotmail.com	\N	1977-03-02 00:00:00		2025-05-03 20:50:49.568	2025-05-03 20:50:49.568	\N
d405ac6b-06a0-43fa-a414-5abf1e959901	Blanca	Zuñiga		\N	\N	1978-09-29 00:00:00		2025-05-03 20:50:49.568	2025-05-03 20:50:49.568	\N
e616ad38-8eda-4923-bfbd-eafc261183b1	Blanca Elena	Quezada Garcia.		\N	\N	2008-01-23 00:00:00		2025-05-03 20:50:49.569	2025-05-03 20:50:49.569	\N
91ebcb2e-edeb-4749-bdb2-b4b0ae9dbfe9	Bernardo	Gómez		odranreb22@gmail.com	+523222086277	\N		2025-05-03 20:50:49.569	2025-05-03 20:50:49.569	\N
b06b1e62-4811-4db0-b94c-af4b4a228465	Blanca Estela	Morales Gomez		blancaasesorpv@gmail.com	+523221356485	1973-07-28 00:00:00		2025-05-03 20:50:49.569	2025-05-03 20:50:49.569	\N
9dd2209b-72a2-47c5-9cdd-8d99ad752760	Blanca Estela	Palafox Espinoza		\N	\N	1982-05-11 00:00:00		2025-05-03 20:50:49.57	2025-05-03 20:50:49.57	\N
b7d6724f-ade9-4592-85cf-fbdd8f032c9b	Blanca Estela	Pérez Alonzo		\N	3223195754	1959-07-07 00:00:00		2025-05-03 20:50:49.57	2025-05-03 20:50:49.57	\N
81e68815-f51f-468f-979a-7e855278eeb3	Blanca Esthela	De los Santos Peña		\N	\N	\N		2025-05-03 20:50:49.57	2025-05-03 20:50:49.57	\N
3fb0eaac-ab8f-4295-b51f-116017a609c5	Blanca Esthela	García Cortez		\N	\N	1955-09-18 00:00:00		2025-05-03 20:50:49.571	2025-05-03 20:50:49.571	\N
9751dbe1-065c-4501-a2ad-6f24693cc45f	Betzy Del Carmen	Morales de la Cruz		\N	3223684469	\N		2025-05-03 20:50:49.571	2025-05-03 20:50:49.571	\N
1e2d9401-a31d-45bc-be26-fa6615e6b28a	Blanca Esthela	Ruano Leonardo		\N	3315494521	1979-02-09 00:00:00		2025-05-03 20:50:49.571	2025-05-03 20:50:49.571	\N
0cc31b9f-7696-41b6-84ed-33b28d49444e	Blanca Esther	Rodriguez Reyes		\N	\N	\N		2025-05-03 20:50:49.572	2025-05-03 20:50:49.572	\N
670a1273-c7b3-4041-8c39-74b62402d9d0	Blanca Flor	García Martinez		\N	\N	\N		2025-05-03 20:50:49.572	2025-05-03 20:50:49.572	\N
cd1deb18-a8c5-44a0-88f3-29c74b315a11	Blanca Karina	Guitierres Ramirez		karygutierrez31@gmail.com	\N	1978-05-17 00:00:00		2025-05-03 20:50:49.572	2025-05-03 20:50:49.572	\N
2d4e558b-fe41-4a31-a6b6-3d4ec00e2ec2	Arturo	Guillen		\N	3221470806	\N		2025-05-03 20:50:49.572	2025-05-03 20:50:49.572	\N
c7d84223-2dc8-4ebd-af31-4cafb2d34ca5	Benito	Castillo Morales		\N	\N	\N		2025-05-03 20:50:49.573	2025-05-03 20:50:49.573	\N
b648d9e9-5242-4a56-a83c-f2c15870ace5	Blanca Lilia	Navarro Velasquez		minizayuri@hotmail.com	\N	1978-03-09 00:00:00		2025-05-03 20:50:49.573	2025-05-03 20:50:49.573	\N
e8d96dcf-94dd-4d69-a8f3-8c01a36d7a10	Blanca Margarita	Ramírez Arias		mandarina.62@hotmail.com	\N	1962-05-17 00:00:00		2025-05-03 20:50:49.574	2025-05-03 20:50:49.574	\N
db0ef7bc-4b58-4889-82f6-20981649238e	Blanca Maribel	López Peña		blanca_4444@hotmail.com	\N	1985-01-03 00:00:00		2025-05-03 20:50:49.574	2025-05-03 20:50:49.574	\N
d1c58734-b734-40a2-9176-04aefeb4fae3	Blanca Rocio	Noyola Sanchez		brnoyola@hotmail.com	\N	1985-03-08 00:00:00		2025-05-03 20:50:49.574	2025-05-03 20:50:49.574	\N
4ed22bb4-d113-410c-b419-6e7c58185f48	Blas	Ochoa Magaña		\N	\N	2010-05-12 00:00:00		2025-05-03 20:50:49.575	2025-05-03 20:50:49.575	\N
4132cd1c-8cca-473a-a815-04de1062fb5d	Bob	Allison		shebob@northwestel.net	3221975093	1959-08-20 00:00:00		2025-05-03 20:50:49.575	2025-05-03 20:50:49.575	\N
900f873d-f97e-403f-836d-cf5840d16197	Bob	REMPEL		\N	\N	1950-04-01 00:00:00		2025-05-03 20:50:49.575	2025-05-03 20:50:49.575	\N
1094e2b7-ed68-4f1b-ad20-e0c81379ada3	Bonnie	Cretzman		bonnic999@gmail.com	\N	1958-09-27 00:00:00		2025-05-03 20:50:49.575	2025-05-03 20:50:49.575	\N
e0ae969d-24ce-4df8-a394-7c4f648a6ed7	Beatriz	Holman		\N	6265516694	\N		2025-05-03 20:50:49.576	2025-05-03 20:50:49.576	\N
8512572c-5587-4e45-aef7-942392bde953	Boris Eric	Avellaneda Saint John		borisavellaneda@hotmail.com	3221589706	1980-04-23 00:00:00		2025-05-03 20:50:49.576	2025-05-03 20:50:49.576	\N
84d504bd-1186-443d-9a5d-2dd3d4083435	Braulio	López Ramírez		braunny3b@gmail.com	\N	1977-01-24 00:00:00		2025-05-03 20:50:49.576	2025-05-03 20:50:49.576	\N
0bc0831c-e92f-4cf2-b933-423926934ac4	Brend	Peterson		\N	\N	\N		2025-05-03 20:50:49.577	2025-05-03 20:50:49.577	\N
d14a5f18-5519-4bb9-b839-49986a18385b	Belem Irais	Anguel Oliva		\N	3221698144	\N		2025-05-03 20:50:49.577	2025-05-03 20:50:49.577	\N
df684fee-bcac-4d71-bac7-ff50abd651d7	Beatriz	Holman		\N	+16265516694	\N		2025-05-03 20:50:49.577	2025-05-03 20:50:49.577	\N
306d52ca-aa61-4785-bd9e-fd9c013a9d05	Brenda	Escamilla Vazquez		Breescamilla@gmail.com	+523221884024	\N		2025-05-03 20:50:49.578	2025-05-03 20:50:49.578	\N
e589289a-719d-4743-862e-bf1167e5746f	Benny	Daniel		\N	+12145859503	\N		2025-05-03 20:50:49.578	2025-05-03 20:50:49.578	\N
2d179a2c-cda1-4bd3-a192-af9c50ecdd45	Benny	Daniel		\N	+12148500167	\N		2025-05-03 20:50:49.578	2025-05-03 20:50:49.578	\N
9fa5bbd3-af7b-42b5-84b4-f10dfd87bb87	Barbara	León Escobedo		\N	5511492813	\N		2025-05-03 20:50:49.579	2025-05-03 20:50:49.579	\N
7135864e-d5b2-4a8a-a317-20a86a1e3915	Brian	Alegria Popova		\N	\N	2011-07-20 00:00:00		2025-05-03 20:50:49.579	2025-05-03 20:50:49.579	\N
ea816ef1-e077-473a-b9bf-ffb684e8f27d	Brent	Manning		olmatejimmy@gmail.com	+525614111913	2025-03-06 00:00:00		2025-05-03 20:50:49.579	2025-05-03 20:50:49.579	\N
9623908e-76fb-4031-9758-33d4aadcadd2	Bret	Manning		\N	5614111913	\N		2025-05-03 20:50:49.579	2025-05-03 20:50:49.579	\N
7f8999e5-7b85-48c0-9df3-6826f21b53f4	Brian Gerardo	Luna Cordova		\N	\N	2005-08-22 00:00:00		2025-05-03 20:50:49.58	2025-05-03 20:50:49.58	\N
a2df865d-7b4a-46bf-870d-6307d40c13af	Brianda	Valdes Lopez		\N	\N	\N		2025-05-03 20:50:49.58	2025-05-03 20:50:49.58	\N
3b832bf9-748c-4737-b23b-3e126a96952a	Bridget	Hoyle		\N	\N	1965-10-08 00:00:00		2025-05-03 20:50:49.58	2025-05-03 20:50:49.58	\N
c52eff2b-8ee4-4b12-9640-467dca871b98	Brillet	Hoyle		\N	\N	1965-10-08 00:00:00		2025-05-03 20:50:49.581	2025-05-03 20:50:49.581	\N
80a5d2ff-035e-4498-af6c-4354b447d5a4	Baraba	Iglesias Larrazolo		\N	3221353708	\N		2025-05-03 20:50:49.581	2025-05-03 20:50:49.581	\N
8368e47b-6773-4ca4-b5a0-9a2832b89e68	Brisa Cristel	García Ruíz		\N	\N	2011-03-12 00:00:00		2025-05-03 20:50:49.581	2025-05-03 20:50:49.581	\N
a576221e-73b0-48f2-b2aa-e48ae6b56c3a	Barbara	Stanber		\N	3222383281	\N		2025-05-03 20:50:49.582	2025-05-03 20:50:49.582	\N
a45e313b-6e79-48d1-822a-11c4cbe53294	Brithany Lizbeth	Vega Herrera		\N	\N	\N		2025-05-03 20:50:49.582	2025-05-03 20:50:49.582	\N
c8fd9e04-6a21-4cfb-a5ca-4f22e9b9d429	Brogan	Ronske		\N	\N	1994-09-13 00:00:00		2025-05-03 20:50:49.582	2025-05-03 20:50:49.582	\N
235cb9d7-20c5-4288-bc79-475021fbca87	Bruce	Mceacharn		mceacharnb@bellsouth.net	\N	1956-01-13 00:00:00		2025-05-03 20:50:49.583	2025-05-03 20:50:49.583	\N
ff4478fb-21af-497b-a6f5-80bc233c0666	Bianca Guadalupe	Ramírez Hernández		\N	3221265736	\N		2025-05-03 20:50:49.583	2025-05-03 20:50:49.583	\N
bda691ce-8bb7-4c8d-a284-5ba51498f862	Bruno	Alcaraz Benavides		bral712010@gmail.com	\N	1971-05-30 00:00:00		2025-05-03 20:50:49.583	2025-05-03 20:50:49.583	\N
08bc916e-e399-4700-8a59-58c02c2fd845	Bryan	Sendiz Martinez		\N	\N	1999-10-21 00:00:00		2025-05-03 20:50:49.584	2025-05-03 20:50:49.584	\N
e1cf97e8-a1d6-440b-885e-0fab4f2f531b	Blanca lidia	Uribe Ponce		buribe1301@hotmail.cm	\N	1980-01-13 00:00:00		2025-05-03 20:50:49.584	2025-05-03 20:50:49.584	\N
1053fa8f-381a-4a84-bc61-33f27ede54bc	Blanca Elia	Magaña magaña		\N	3221356913	\N		2025-05-03 20:50:49.584	2025-05-03 20:50:49.584	\N
e618a695-9ef9-4686-950a-09131f155bf6	Caleb	Nicols		caleb@kickapoocoffee.com	\N	1978-04-02 00:00:00		2025-05-03 20:50:49.584	2025-05-03 20:50:49.584	\N
41281d41-5fe8-48b3-8672-ce6732b2e09f	Caleb	Rodríguez Sanchez		jarf_78@hotmail.com	\N	2011-04-06 00:00:00		2025-05-03 20:50:49.585	2025-05-03 20:50:49.585	\N
1b2af92f-2ac2-41c1-844d-092c5796362a	Callo	Egan		\N	\N	2008-08-27 00:00:00		2025-05-03 20:50:49.585	2025-05-03 20:50:49.585	\N
68241b1f-603b-4394-95c0-4c96903e7360	Blanca Leticia	Hernández Castillo		\N	3221514698	\N		2025-05-03 20:50:49.585	2025-05-03 20:50:49.585	\N
2f3c14ad-2016-4e9e-8e48-d081fc62a0ef	Blanca Esthela	Morales Gomez		\N	3221356485	\N		2025-05-03 20:50:49.586	2025-05-03 20:50:49.586	\N
6ab6d4aa-82f5-4302-9dbc-924ef9aa8ca5	Camila	Tapia Hernández		\N	3221103084	\N		2025-05-03 20:50:49.586	2025-05-03 20:50:49.586	\N
8b634942-53ed-4df1-8908-b3aa33ba7f20	Brenda	Heredia		\N	\N	\N		2025-05-03 20:50:49.586	2025-05-03 20:50:49.586	\N
1684311d-d361-44fd-86d7-89960b6a5294	Camila madre de simon	Castillo		\N	\N	\N		2025-05-03 20:50:49.587	2025-05-03 20:50:49.587	\N
9290b214-ba71-4812-889e-71cb04689495	Camille	Hamilton		\N	\N	\N		2025-05-03 20:50:49.587	2025-05-03 20:50:49.587	\N
378be451-e9cb-4036-8649-78a3f1555409	Candelario	Gonzales Carlos		\N	\N	1946-03-23 00:00:00		2025-05-03 20:50:49.587	2025-05-03 20:50:49.587	\N
f4840e43-1048-4dab-a20c-a178694e61f4	Carina	Corujo Cardoza		\N	\N	1984-10-03 00:00:00		2025-05-03 20:50:49.588	2025-05-03 20:50:49.588	\N
d4c42695-ba0f-4a30-ad36-b66b6e72f6cd	Brenda Yesenia	Fernandez		\N	\N	\N		2025-05-03 20:50:49.588	2025-05-03 20:50:49.588	\N
d08923c2-a671-46a1-8139-7ac79cea77c4	Carla Yadira	Sanchez Meza		\N	\N	2006-06-05 00:00:00		2025-05-03 20:50:49.588	2025-05-03 20:50:49.588	\N
d9c35fac-b7a8-4198-9faf-4d8d30f4d3b1	Carla Yasbeth	Cerda Chavez		\N	\N	\N		2025-05-03 20:50:49.589	2025-05-03 20:50:49.589	\N
1f81e974-2ea3-46fe-b28a-28c8de66dca9	Carlo	De Michellis  Marchorro		\N	\N	\N		2025-05-03 20:50:49.59	2025-05-03 20:50:49.59	\N
e193046f-6967-4c9f-ae30-335b5f0b9547	Carlo	Demichellis		carlodem@hotmail.com	\N	1956-07-14 00:00:00		2025-05-03 20:50:49.59	2025-05-03 20:50:49.59	\N
1498a4a2-cc5c-40a2-9116-67b5ee851278	Carlos	Aragon		\N	\N	2009-08-04 00:00:00		2025-05-03 20:50:49.59	2025-05-03 20:50:49.59	\N
ecf32bb7-f4e7-4fe1-9cc4-4ccc27bbdd1d	Carlos	Arteaga Rodriguez		karloz_arteaga03@hotmail.com	\N	1992-01-19 00:00:00		2025-05-03 20:50:49.591	2025-05-03 20:50:49.591	\N
1fd75b50-5191-4729-b9b0-984f0356cf53	Carlos	Camba		\N	+523221098387	2010-09-29 00:00:00		2025-05-03 20:50:49.591	2025-05-03 20:50:49.591	\N
1cd14e2c-27cc-4ad7-914c-3a797fa1422b	Bernad	Labrecque		\N	\N	\N		2025-05-03 20:50:49.591	2025-05-03 20:50:49.591	\N
1678ecd9-1d46-4688-bd41-767df5015fea	Carlos	Candido Peña		\N	\N	1995-02-10 00:00:00		2025-05-03 20:50:49.592	2025-05-03 20:50:49.592	\N
6cb21e00-6b36-4cf7-b58b-c80abb8e5d87	Carlos	Contreras Fernandez		\N	\N	2006-06-17 00:00:00		2025-05-03 20:50:49.592	2025-05-03 20:50:49.592	\N
c31c564a-8ed5-4b2e-b92c-5016dc8fd366	Carlos	Cordova Aguilar		\N	\N	2006-06-15 00:00:00		2025-05-03 20:50:49.592	2025-05-03 20:50:49.592	\N
5edfe97f-6ef1-4c6d-a1d4-330b0a93e2e9	Carlos	Cortez Larios		autositemaspv@hotmail.com	\N	1967-01-28 00:00:00		2025-05-03 20:50:49.593	2025-05-03 20:50:49.593	\N
3cd7ab15-97c8-4426-8ca2-3d937b1cef19	Carlos	Cruz Gil		\N	\N	2007-02-17 00:00:00		2025-05-03 20:50:49.593	2025-05-03 20:50:49.593	\N
c365458c-02f9-4222-884e-f7d72fd5f41b	Carlos	Eguiarte		\N	\N	1965-07-06 00:00:00		2025-05-03 20:50:49.593	2025-05-03 20:50:49.593	\N
a9797fd3-f8f1-4d6c-a611-b58f39cb204e	Carlos	García Licona		carlitosmodadisa@gmail.com	5514084456	1976-05-13 00:00:00		2025-05-03 20:50:49.593	2025-05-03 20:50:49.593	\N
b3552aa5-692c-43dd-8a9e-f51c384459fa	Carlos	Gonzales López		\N	\N	1995-07-19 00:00:00		2025-05-03 20:50:49.594	2025-05-03 20:50:49.594	\N
5ce1ebf0-b226-4391-8336-4ab50b6703e1	Brillite	Meissner		\N	\N	\N		2025-05-03 20:50:49.594	2025-05-03 20:50:49.594	\N
83fcbb4c-c8e5-4cab-b7bf-cc0590f866d5	Britany	Ronhaar		\N	\N	\N		2025-05-03 20:50:49.594	2025-05-03 20:50:49.594	\N
b9c83e31-8e4d-4521-a48a-f065a94888c3	Brunel	Mireille		brunelmireille@gmail.com	\N	1937-11-10 00:00:00		2025-05-03 20:50:49.595	2025-05-03 20:50:49.595	\N
45b8f31e-d367-4e65-8e57-e1e4f6417596	Carlos	Jaramillo Morales		\N	\N	2006-04-06 00:00:00		2025-05-03 20:50:49.595	2025-05-03 20:50:49.595	\N
b4c90ba1-d5aa-45c4-ae29-db8ffdf63c78	Carlos	Ladron de Guevara		\N	\N	2010-01-25 00:00:00		2025-05-03 20:50:49.595	2025-05-03 20:50:49.595	\N
7055a916-616a-4ae6-b613-b06e6a69b5fb	Carlos	Maldonado Peña		\N	\N	2010-03-29 00:00:00		2025-05-03 20:50:49.596	2025-05-03 20:50:49.596	\N
41d340cc-d401-40da-89bb-a3d6489ad520	Carlos	Mancha Lucio		\N	3222241036	1953-11-20 00:00:00		2025-05-03 20:50:49.596	2025-05-03 20:50:49.596	\N
b406ca5b-de3c-40f4-acc5-ac6f470c7e86	Carlos	Miranda Hernandez		\N	\N	1971-12-16 00:00:00		2025-05-03 20:50:49.596	2025-05-03 20:50:49.596	\N
641746ce-2cda-4a16-bb49-fc7b02ed4356	Carlos	Murillo Herrera		muhc702@gmail.com	\N	1962-06-14 00:00:00		2025-05-03 20:50:49.597	2025-05-03 20:50:49.597	\N
054a4470-a0b9-46c7-a568-eaa5a5e4db5a	Carlos	Orozco Montelongo		\N	\N	1990-08-03 00:00:00		2025-05-03 20:50:49.597	2025-05-03 20:50:49.597	\N
6a0ecc38-e0f0-47f6-b5c7-01b6138d22ec	Carlos	Ortega Sn Roman		\N	\N	1937-09-06 00:00:00		2025-05-03 20:50:49.597	2025-05-03 20:50:49.597	\N
18ae5e99-a66d-4843-a292-945a40aae487	Bonnie	Kristian		\N	3221350226	\N		2025-05-03 20:50:49.598	2025-05-03 20:50:49.598	\N
679afcf8-6315-4052-afa4-95935f8e8049	Camerún	Perke		\N	+447985181342	\N		2025-05-03 20:50:49.598	2025-05-03 20:50:49.598	\N
c4f10615-3e4f-4a55-8f3e-e9f02cb98bdc	Brenda	Marquez  Villaseñor		\N	3222717230	\N		2025-05-03 20:50:49.598	2025-05-03 20:50:49.598	\N
8406c141-e8bd-4411-952b-81829e88a7e3	Carlos	Ramirez Torres		\N	\N	1961-06-19 00:00:00		2025-05-03 20:50:49.599	2025-05-03 20:50:49.599	\N
0f544d73-22a5-457b-8b54-c35fddb7c766	Carlos	Saldaña Ulloa		\N	\N	\N		2025-05-03 20:50:49.599	2025-05-03 20:50:49.599	\N
ef3b69ac-75d4-422c-afc9-549069658e94	Carlos	Soberon		sobcar@gmail.com	3222450050	1962-02-28 00:00:00		2025-05-03 20:50:49.599	2025-05-03 20:50:49.599	\N
475d8a0e-150e-40a6-b586-cc79e4186121	Carlos	Solana		\N	\N	\N		2025-05-03 20:50:49.6	2025-05-03 20:50:49.6	\N
69b30d09-e0cb-4b2d-9527-38ba364f310b	Carlos	Solis Cuevas		amairan002@gmail.com	\N	1995-11-19 00:00:00		2025-05-03 20:50:49.6	2025-05-03 20:50:49.6	\N
e33af108-fc39-4c66-b1b9-8640b8f4940c	Carlos	Terán Saucedo		teran_saucedo@yahoo.com.mx	\N	1976-11-04 00:00:00		2025-05-03 20:50:49.6	2025-05-03 20:50:49.6	\N
478bbdf9-07dd-466e-b031-76a764387451	Carlos	Velazquez Perez		\N	\N	2006-12-05 00:00:00		2025-05-03 20:50:49.601	2025-05-03 20:50:49.601	\N
ebfde9ac-7998-4c9c-ac42-7dd6c51243ac	Carlos	Villalba Abarca		\N	\N	1973-02-16 00:00:00		2025-05-03 20:50:49.601	2025-05-03 20:50:49.601	\N
004c08c2-8d1d-489a-8a71-61cf4803c49f	Carlos Adan	Lopez Zamorano		\N	\N	1966-01-21 00:00:00		2025-05-03 20:50:49.601	2025-05-03 20:50:49.601	\N
6ca16589-59bc-4a51-843e-ea277febaf46	Carlos Alberto	Gómez Domínguez		\N	3221809003	\N		2025-05-03 20:50:49.602	2025-05-03 20:50:49.602	\N
c48c2613-f53f-47f4-9665-c58e651a7e9c	Carlos Alberto	Martinez Sanchez		carlosmtzsanchez@gmail.com	\N	\N		2025-05-03 20:50:49.602	2025-05-03 20:50:49.602	\N
578046c9-d006-4cfa-a85e-e9985f70a3de	Carlos Alejandro	Morales Perez		\N	\N	\N		2025-05-03 20:50:49.602	2025-05-03 20:50:49.602	\N
87d6289b-fef0-4457-bc5b-45e9676ff803	Carlos Alexis	Flores Nuñez		caflo_alex@hotmail.com	\N	1985-04-11 00:00:00		2025-05-03 20:50:49.602	2025-05-03 20:50:49.602	\N
673af188-6a79-46aa-8274-e47a9de6d758	carlos Alfonso	Villalva Lara		\N	\N	2006-09-25 00:00:00		2025-05-03 20:50:49.603	2025-05-03 20:50:49.603	\N
fa18ed8c-0759-48f2-89b4-1ccf064e1367	Carlos Ariel	De la Torre		ancawa26@hotmail.com	3292955107	1956-12-26 00:00:00		2025-05-03 20:50:49.603	2025-05-03 20:50:49.603	\N
f709c0b9-081a-41e8-9cda-a0e1705a9772	Carlos Armando	Franco Thomas		\N	\N	2007-07-03 00:00:00		2025-05-03 20:50:49.604	2025-05-03 20:50:49.604	\N
c8f3acdf-f8da-481c-b726-a478f56b2a31	Carlos Daniel	Maldonado Lepe		narut.lepe@hotmail.es	3221821749	1999-07-10 00:00:00		2025-05-03 20:50:49.604	2025-05-03 20:50:49.604	\N
fdcbc939-8ddf-4700-aac4-73297157e84a	Bryan Ali	Gil Lobera		\N	5586864292	\N		2025-05-03 20:50:49.604	2025-05-03 20:50:49.604	\N
4e3c4aa3-c75e-4d72-9297-60d5edaabb1e	Bryan Eduardo	Santiago Gonzales		\N	\N	2009-09-07 00:00:00		2025-05-03 20:50:49.605	2025-05-03 20:50:49.605	\N
a1621852-dff8-4f93-925f-49ec9ec9f529	Carlos Eduardo	Regla Cordoba		\N	\N	2004-05-09 00:00:00		2025-05-03 20:50:49.605	2025-05-03 20:50:49.605	\N
1e1c5b8c-1370-4d20-81f6-e6a78875c745	Carlos Enrique	Hernandez Nuñez		\N	3222294116	1976-12-18 00:00:00		2025-05-03 20:50:49.605	2025-05-03 20:50:49.605	\N
1655caa1-996d-4916-a0ff-5424761689c2	Carlos Enrrique	Barrañaga Luna		erndi2150@gmail.com	\N	1982-04-12 00:00:00		2025-05-03 20:50:49.606	2025-05-03 20:50:49.606	\N
e763a7d9-a068-400a-9a75-7fd1b689dff4	Carlos Enrrique	Hernandez Nuñes		carloenri76@hotmail.com	3222294116	1976-12-18 00:00:00		2025-05-03 20:50:49.606	2025-05-03 20:50:49.606	\N
70115744-611e-4fe4-aafc-e3ac632c2e8d	Camila	López González		camlopg23@gmail.com	+523221515599	\N		2025-05-03 20:50:49.606	2025-05-03 20:50:49.606	\N
e29be813-a253-4d3a-b553-78ddb2c7552a	Carlos Giovany	Alvarado Ruíz		\N	\N	1990-12-26 00:00:00		2025-05-03 20:50:49.607	2025-05-03 20:50:49.607	\N
72fde405-47f4-4535-83b8-30fa44936b49	Carlos Leopold	Gonzalez Coronado		carosgc47@hotmail.com	\N	1947-08-04 00:00:00		2025-05-03 20:50:49.607	2025-05-03 20:50:49.607	\N
dbc8156e-783b-475c-b144-d9e90881fe41	Carlos Roberto	Lorenzana		\N	\N	\N		2025-05-03 20:50:49.607	2025-05-03 20:50:49.607	\N
19a9d816-2ad4-413f-af9e-e439f1891616	Carlos Samuel	García Salcedo		laura_samantha_@hotmail.com	\N	2006-01-01 00:00:00		2025-05-03 20:50:49.608	2025-05-03 20:50:49.608	\N
3199d308-c6b6-4720-80e1-aab534c49169	Carlos Tlacuilotzin	García López		ctlacuilo@prodigy.net.mx	\N	1954-02-07 00:00:00		2025-05-03 20:50:49.608	2025-05-03 20:50:49.608	\N
f3bb638f-3315-49f2-a069-9650470d0802	CarlosRodolfo	Guerrero Moreno Cachi		carlos.guerrero.m82@hotmail.com	\N	1982-11-18 00:00:00		2025-05-03 20:50:49.608	2025-05-03 20:50:49.608	\N
59f1028a-3cda-4f9b-aa4b-969bbcb85e03	Carlota	Jimenez de Paredes		\N	\N	1936-08-23 00:00:00		2025-05-03 20:50:49.608	2025-05-03 20:50:49.608	\N
43f1e011-4f91-428c-be75-761e30e17a9e	Carly	Schwichtenberg		cjschwichtenberg@gmail.com	\N	1986-05-24 00:00:00		2025-05-03 20:50:49.609	2025-05-03 20:50:49.609	\N
f1f21f66-b18b-4d9c-bd87-69b025c1d8e8	Carly	Taylor		carlytaylor@hotmail.co.nz	3221124409	\N		2025-05-03 20:50:49.609	2025-05-03 20:50:49.609	\N
872d2735-d0b0-423c-a0fe-3fd0c7648288	Carmela	Tostado Martínez		Camarto@hotmail.com	\N	1962-11-05 00:00:00		2025-05-03 20:50:49.609	2025-05-03 20:50:49.609	\N
a671c450-7627-4fd8-8f28-a44943e32439	Carmelita	Ramirez Chavez		facturacion.latia@gmail.com	3222210769	1993-12-01 00:00:00		2025-05-03 20:50:49.61	2025-05-03 20:50:49.61	\N
337a1b6c-40a1-4ed8-9320-9e77f516b314	Carmen	Arellano García		niyolpaki16@hotmail.com	\N	1975-07-16 00:00:00		2025-05-03 20:50:49.61	2025-05-03 20:50:49.61	\N
53f1b1fa-2541-4252-86bc-d3b51c3702ac	Carmen	Bravo		cita4@hotmail.com	\N	1960-10-24 00:00:00		2025-05-03 20:50:49.61	2025-05-03 20:50:49.61	\N
5d4e50a8-a785-4500-b81d-f1e93dc7f263	Carmen	Morales de la Torre		\N	\N	1982-08-16 00:00:00		2025-05-03 20:50:49.611	2025-05-03 20:50:49.611	\N
513ccf76-6ab7-4d87-9ca4-4cfa585805e7	Carmen	Moralez De La Torre		\N	\N	1982-09-16 00:00:00		2025-05-03 20:50:49.611	2025-05-03 20:50:49.611	\N
ba8e1b67-f408-4162-8d36-4f6645e45494	Carmen	Moreno Gonzales		\N	\N	1987-10-27 00:00:00		2025-05-03 20:50:49.611	2025-05-03 20:50:49.611	\N
2c2b314d-6503-4248-b6cf-e8b460c3deba	Carmen	Nava cuevas		\N	\N	\N		2025-05-03 20:50:49.612	2025-05-03 20:50:49.612	\N
fe5b297d-2dbd-4d54-b2ef-38df60b17ba4	Carmen	Petrasa		mcnenita09@hotmail.com	\N	1980-09-14 00:00:00		2025-05-03 20:50:49.612	2025-05-03 20:50:49.612	\N
d3367bc9-52f5-4da6-8c56-9be95f01a63d	Carmen	Torres Delgado		\N	\N	1979-01-27 00:00:00		2025-05-03 20:50:49.612	2025-05-03 20:50:49.612	\N
8808e728-1b5b-4cc7-b6c9-ccda61123946	Carmen Alondra	Mendoza Ordaz		alo_nic3@hotmail.com	\N	2000-04-21 00:00:00		2025-05-03 20:50:49.613	2025-05-03 20:50:49.613	\N
f8747381-dcd2-4b0e-a957-78916efad88a	Carmen Denisse	Alegria Garrido		denisse_alegria@hotmail.com	\N	1984-02-05 00:00:00		2025-05-03 20:50:49.613	2025-05-03 20:50:49.613	\N
f1a42524-95e1-462d-bb85-3d9d46d589c8	Carmen Lizeth	Flores Carrillo		\N	\N	\N		2025-05-03 20:50:49.613	2025-05-03 20:50:49.613	\N
efece230-1765-4787-ba8c-72859ff5af87	Carmen Veronica	Garay Serrano		garay-v@hotmail.com	\N	1972-02-26 00:00:00		2025-05-03 20:50:49.613	2025-05-03 20:50:49.613	\N
79456048-b78d-40f0-b12d-549f455c9c85	Carol	Blanco Perez		\N	\N	1989-12-03 00:00:00		2025-05-03 20:50:49.614	2025-05-03 20:50:49.614	\N
0af5a0cf-99d0-4cde-b102-7b5c58880d69	Carolina	Ahumada Marcial		\N	\N	\N		2025-05-03 20:50:49.614	2025-05-03 20:50:49.614	\N
c567b848-9a35-4434-b0ce-056ef0c2bda8	Carolina	Casella		\N	3227282844	1976-06-22 00:00:00		2025-05-03 20:50:49.614	2025-05-03 20:50:49.614	\N
7d993b12-997c-4a41-819d-b5227df2a631	Camila Elizeth	Lopez Gonzales		\N	3221515599	2005-11-23 00:00:00		2025-05-03 20:50:49.615	2025-05-03 20:50:49.615	\N
bc2a2c53-ce4b-4ff8-8350-84448e1900a0	Carolina	Cordova Trucios		karito_cordova@hotmail.com	\N	1983-02-03 00:00:00		2025-05-03 20:50:49.615	2025-05-03 20:50:49.615	\N
614ff655-5d50-45c5-a78e-eeef5553e847	Carolina	Cuenvas Navarro		anonima_sl@hotmail.com	\N	1964-12-03 00:00:00		2025-05-03 20:50:49.615	2025-05-03 20:50:49.615	\N
d1d013d8-5ac0-4f15-a2cc-5ae71a8a5d15	Carolina	Cuevas Contreras		\N	\N	2008-12-02 00:00:00		2025-05-03 20:50:49.616	2025-05-03 20:50:49.616	\N
b8cd16ea-a00d-4617-9c04-dd29b02cad31	Carolina	Dias Estrada		\N	\N	1999-04-27 00:00:00		2025-05-03 20:50:49.616	2025-05-03 20:50:49.616	\N
18fbafad-a9ac-473b-9792-0fdb2b6ee63b	Carolina	Dueñas Rojas		carolyne_1606@hotmail.com	\N	1979-06-16 00:00:00		2025-05-03 20:50:49.616	2025-05-03 20:50:49.616	\N
606aa0c2-64c8-4639-bb9a-b185fa35092d	Carolina	García Ruiz		\N	\N	2006-06-21 00:00:00		2025-05-03 20:50:49.617	2025-05-03 20:50:49.617	\N
b82bb1ed-6b57-4861-b0e3-6916feeb03d2	Carolina	Gúzman Lopéz		\N	\N	1982-07-15 00:00:00		2025-05-03 20:50:49.617	2025-05-03 20:50:49.617	\N
29ac2220-8857-40e9-9a13-f732d2659d48	Carolina	Lopez Gonzalez		\N	\N	2014-07-31 00:00:00		2025-05-03 20:50:49.618	2025-05-03 20:50:49.618	\N
2c3f4a1d-a687-487d-8935-1843676daa57	Carolina	Mercado Gallegos		erandibb@hotmail.com	\N	1989-03-29 00:00:00		2025-05-03 20:50:49.618	2025-05-03 20:50:49.618	\N
2df669de-8e4c-457f-90b7-f8ee32b0d5a7	Carolina	Muñiz Rodriguez		\N	\N	2006-02-06 00:00:00		2025-05-03 20:50:49.618	2025-05-03 20:50:49.618	\N
5c9a5d90-680f-44d1-820e-730606a450b0	Carolina	Santana Estrada		\N	\N	2009-12-15 00:00:00		2025-05-03 20:50:49.618	2025-05-03 20:50:49.618	\N
3ca14b2b-0861-4612-bcf0-f4cc14f33647	Carla Tiare	Garza Mendoza		garzatiare3@gmail.com	+523317361708	\N		2025-05-03 20:50:49.619	2025-05-03 20:50:49.619	\N
af751982-878f-4cda-bd4d-95618aa0a3be	Cassandra	Mark		\N	\N	\N		2025-05-03 20:50:49.619	2025-05-03 20:50:49.619	\N
4fd150b2-018c-4364-8d5d-c16f4241f600	Catalina	Alonzo Villa		\N	\N	\N		2025-05-03 20:50:49.619	2025-05-03 20:50:49.619	\N
d0201525-f3c6-4cbb-817b-a7b49ef0472c	Catalina	Carrasco Rodriguez		\N	\N	1943-11-25 00:00:00		2025-05-03 20:50:49.62	2025-05-03 20:50:49.62	\N
fa33a235-2807-423a-9e18-32db7e1abf72	Catalina	Contreras Perea		cata_c_p@hotmail.com	\N	1958-01-05 00:00:00		2025-05-03 20:50:49.62	2025-05-03 20:50:49.62	\N
a6483539-d2ef-4671-b690-8cb9ff1ca656	Brian	Caldwell		\N	\N	1946-02-26 00:00:00		2025-05-03 20:50:49.62	2025-05-03 20:50:49.62	\N
32e891d9-d33c-46f2-bc3d-a3d45f4fb5ac	Catalina	Martinez Garcia		\N	\N	1981-01-08 00:00:00		2025-05-03 20:50:49.621	2025-05-03 20:50:49.621	\N
6d29438a-242b-4c7b-910b-a9e13868e67d	Catalina	Villalobos Ocaranza		catyvillalobos76@gmail.com	\N	1976-09-14 00:00:00		2025-05-03 20:50:49.621	2025-05-03 20:50:49.621	\N
60d0a2da-2bcc-4555-a7c9-cd4c5ee1c154	Caterine	Howwe		\N	\N	\N		2025-05-03 20:50:49.621	2025-05-03 20:50:49.621	\N
fbbbe4a8-3f8f-4e06-976e-7b7605f2b6e1	Catherin	Thahan		catherine.tahan@gmail.com	\N	1968-11-28 00:00:00		2025-05-03 20:50:49.622	2025-05-03 20:50:49.622	\N
1825a5d5-be63-48ba-a0b0-813bf0fcd197	Catherine	Garbe		cathygarbe67@gmail.com	3221374502	1967-05-02 00:00:00		2025-05-03 20:50:49.622	2025-05-03 20:50:49.622	\N
e377abcd-32fd-4c39-a8fb-04ca5fe91553	Catherine	Sims		catesims@gmail.com	\N	1953-09-29 00:00:00		2025-05-03 20:50:49.622	2025-05-03 20:50:49.622	\N
34f3a1bb-eee8-479b-9c29-cdb3ca22eeb4	CECILIA	COLÍN		\N	\N	2008-05-20 00:00:00		2025-05-03 20:50:49.623	2025-05-03 20:50:49.623	\N
18e68247-e909-48c5-9497-9cd0d7b30cbd	Cecilia	Lopez Cueto		\N	\N	1966-03-04 00:00:00		2025-05-03 20:50:49.623	2025-05-03 20:50:49.623	\N
dbebbf53-580d-4ca9-b8db-3bbd6420d94d	Cecilia	Lorenzo Medina		\N	\N	1998-08-22 00:00:00		2025-05-03 20:50:49.623	2025-05-03 20:50:49.623	\N
18ab9895-feed-4db9-9fd4-bb5ced0336ac	Brian	Pettit		\N	3337882347	\N		2025-05-03 20:50:49.624	2025-05-03 20:50:49.624	\N
1ef012be-71f2-4149-b97e-ee573bda1cb4	Cecilia	Medina Gudiño		\N	\N	1970-11-22 00:00:00		2025-05-03 20:50:49.624	2025-05-03 20:50:49.624	\N
3b13e819-cfea-4285-978b-c13ce4f24bc4	Carlos	Gozales Paredes		\N	\N	1949-03-10 00:00:00		2025-05-03 20:50:49.624	2025-05-03 20:50:49.624	\N
f5d18218-a948-4b17-bb4f-9f84280b7d13	Cecilia	Zepeda Regalado		\N	\N	1940-05-15 00:00:00		2025-05-03 20:50:49.624	2025-05-03 20:50:49.624	\N
7cdb1f00-0f5c-4107-be49-1e217a847662	Cecilia Daniela	Flores Casique		danycasique09@gmail.com	\N	1997-09-19 00:00:00		2025-05-03 20:50:49.625	2025-05-03 20:50:49.625	\N
241ebe6c-3ec6-4f01-a780-79338591367a	Cecilia Fernanda	Delgado		\N	\N	\N		2025-05-03 20:50:49.625	2025-05-03 20:50:49.625	\N
f28ddbe5-7567-441b-bf37-22245d6d20f3	Cecilia Guadalupe	Aguirre Valdez		\N	3222789333	\N		2025-05-03 20:50:49.625	2025-05-03 20:50:49.625	\N
a9928301-324a-42c5-9c16-d476ddaa7419	Celia	Casillas Nolazco		\N	\N	1974-01-14 00:00:00		2025-05-03 20:50:49.626	2025-05-03 20:50:49.626	\N
19140b3a-cf50-4d4b-8060-d651aa842d6e	Celia	Gonzalez Gonzalez		celi_02@hotmail.com	\N	1980-02-20 00:00:00		2025-05-03 20:50:49.626	2025-05-03 20:50:49.626	\N
a29d6a26-d457-4728-8079-53ebe9507600	Celia	Rodriguez Delgado		\N	\N	\N		2025-05-03 20:50:49.626	2025-05-03 20:50:49.626	\N
39256ef9-611c-4df2-9e98-000344522734	Celina	Gama Aguilar		celinagama2007@hotmail.com	5552743618	1949-12-10 00:00:00		2025-05-03 20:50:49.627	2025-05-03 20:50:49.627	\N
34e6c344-10eb-4113-b447-e632b9e2d83d	cervico	ruck		\N	\N	\N		2025-05-03 20:50:49.627	2025-05-03 20:50:49.627	\N
0fe18698-2ee6-4970-9de7-0b8aefdc396a	Cesar	Cruz Valdez		\N	\N	\N		2025-05-03 20:50:49.627	2025-05-03 20:50:49.627	\N
6117d77b-ee2d-41d8-a659-e887b4bf2c4d	Cesar	Hernandez Corona		chicharras04@hotmail.com	3221605544	1973-04-06 00:00:00		2025-05-03 20:50:49.628	2025-05-03 20:50:49.628	\N
26c8dd45-b719-4f29-9141-dd3c5d239066	Carlos	Hernandez Rodriguez		\N	\N	\N		2025-05-03 20:50:49.628	2025-05-03 20:50:49.628	\N
fbd66ee0-b97e-4067-891c-6361b7410ad8	Carlos DAria	García Romero		carlosdariogromero@gmail.com	3222992205	2007-02-13 00:00:00		2025-05-03 20:50:49.628	2025-05-03 20:50:49.628	\N
d9483c6e-dc21-48b7-becc-24ec7e9710d4	Cesar	Perez Morales		\N	\N	1979-08-29 00:00:00		2025-05-03 20:50:49.629	2025-05-03 20:50:49.629	\N
b5f1f9ef-6759-44f3-a95f-b7cd046cd79f	Cesar	Perez Suarez		\N	\N	1977-11-16 00:00:00		2025-05-03 20:50:49.629	2025-05-03 20:50:49.629	\N
102d3d7c-af88-4f38-865b-53f8a6dbded0	Cesar	Rodriguez Garcia		cesarrodriguez8562@gmail.com	\N	2002-06-09 00:00:00		2025-05-03 20:50:49.629	2025-05-03 20:50:49.629	\N
4313580a-5160-47b8-8e62-f0590c95eebb	Cesar	Rodriguez Robles		\N	\N	1974-08-24 00:00:00		2025-05-03 20:50:49.63	2025-05-03 20:50:49.63	\N
f5b8b141-4766-4ecf-ac26-5faaf6ef754e	Cesar Alejandro	Juarez Pagua		\N	\N	2008-06-11 00:00:00		2025-05-03 20:50:49.63	2025-05-03 20:50:49.63	\N
645f2661-59e4-41d2-bf74-b89df51092df	Cesar Antonio	Cuevas Cervantes		sonidocesar@yahoo.com.mx	\N	1970-07-24 00:00:00		2025-05-03 20:50:49.63	2025-05-03 20:50:49.63	\N
d68c7787-2930-46d4-8a86-0d13461d455b	Cesar Ariel	Salazar Navarro		eurek77@hotmail.com	\N	1977-02-01 00:00:00		2025-05-03 20:50:49.63	2025-05-03 20:50:49.63	\N
d1c477bd-7d09-4a4d-91b7-c48f8b8f6002	Cesar Augusto	Crúz Valdéz		cesar66cruz22@hotmail.com	\N	1966-06-22 00:00:00		2025-05-03 20:50:49.631	2025-05-03 20:50:49.631	\N
9d1f9c69-a9b0-4efc-9d4d-029e0bfdc8a4	CEsar Ceberino	Gonzales Garcia		gomcesar6@gmail.com	\N	1989-08-24 00:00:00		2025-05-03 20:50:49.631	2025-05-03 20:50:49.631	\N
f6b652cc-00a2-443d-98e9-7c2e9257c958	Cesar Eduardo	García Castro		\N	\N	2007-12-15 00:00:00		2025-05-03 20:50:49.632	2025-05-03 20:50:49.632	\N
8d3f380a-89bc-4412-8c50-02bb6ed7f453	Cesar Gabriel	Loera Hdez		\N	\N	2012-10-18 00:00:00		2025-05-03 20:50:49.632	2025-05-03 20:50:49.632	\N
8eb7ef83-a21c-414b-9bc3-c52614356990	Cesar Giovanni	Camacho Canal		\N	\N	1997-09-28 00:00:00		2025-05-03 20:50:49.632	2025-05-03 20:50:49.632	\N
0d43dfcf-7af4-4de6-9a0d-0717b679eb91	Cesar Giovanni	Gonzalez Díaz		elgio121086@gmail.com	\N	1983-08-24 00:00:00		2025-05-03 20:50:49.633	2025-05-03 20:50:49.633	\N
7216fcc1-d52e-4d6a-b1d7-758324789d71	Cesar Gonzalo	Santos Alcantar		\N	\N	\N		2025-05-03 20:50:49.633	2025-05-03 20:50:49.633	\N
bbcf7bb8-1896-4a31-ae7a-258df189566f	Cesar Luis	Ruiz Casillas		\N	\N	\N		2025-05-03 20:50:49.633	2025-05-03 20:50:49.633	\N
d130a11c-8b08-4f1c-ad7d-c8e2101e3f9a	Cesar Margarito	Tapia Corona		cesarmargarito@gmail.com	\N	1987-05-24 00:00:00		2025-05-03 20:50:49.634	2025-05-03 20:50:49.634	\N
9753223b-0b6a-4db3-a36b-5e6cb3936cab	Cesar Obet	Guardado de la Rosa		\N	\N	2004-06-22 00:00:00		2025-05-03 20:50:49.634	2025-05-03 20:50:49.634	\N
db839b11-b247-4da6-b5ef-d23e2b719f3c	Cesar Omar	Alonzo Villa		\N	\N	2004-01-19 00:00:00		2025-05-03 20:50:49.634	2025-05-03 20:50:49.634	\N
e189dc96-28b9-4a75-8319-20e69648c712	Cesar Ricardo	Lesama Calvillo		\N	3221358771	2010-04-13 00:00:00		2025-05-03 20:50:49.634	2025-05-03 20:50:49.634	\N
62197dd6-6e14-4067-a3ed-0163d2f84df5	Cesar Ricardo	Lopez Mora		cesarllopezmora@gmail.com	\N	1980-12-08 00:00:00		2025-05-03 20:50:49.635	2025-05-03 20:50:49.635	\N
b9829dc9-bb3a-4534-a984-e2c1258c3de2	Cesario	Zepeda Gonzalez		\N	3221360511	1943-08-15 00:00:00		2025-05-03 20:50:49.635	2025-05-03 20:50:49.635	\N
66c3cee2-6f28-4d91-b3f8-d4f7b8a703ed	Chantale	Cloutier		\N	\N	1978-05-30 00:00:00		2025-05-03 20:50:49.635	2025-05-03 20:50:49.635	\N
1fe2b8c5-da9c-410c-aa70-cd516ac079ed	Charlie	Rondot		charlie.rondot@cblacosta.com	3221363980	2010-06-04 00:00:00		2025-05-03 20:50:49.636	2025-05-03 20:50:49.636	\N
3998f61e-2c5f-41aa-863b-92fca11f0625	Charlotte	St-Laurent		\N	\N	\N		2025-05-03 20:50:49.636	2025-05-03 20:50:49.636	\N
b45bb8d1-309e-4c91-b893-708038bd144a	Carlos David	Vargas Cordova		charlyvc@hotmail.com	\N	1990-06-03 00:00:00		2025-05-03 20:50:49.636	2025-05-03 20:50:49.636	\N
7a8584d1-f7d2-4731-bfbe-9cc3b67fec13	Carlos Felipe	Camba Pérez		\N	3221098387	\N		2025-05-03 20:50:49.637	2025-05-03 20:50:49.637	\N
b05fb01b-0399-46a5-9a6d-0f46a5b13b37	Cherie	Walters		\N	\N	1988-03-01 00:00:00		2025-05-03 20:50:49.637	2025-05-03 20:50:49.637	\N
e486a5ef-7050-4b35-b9c7-9678f8a6abe9	Christel	Elsayah		\N	\N	\N		2025-05-03 20:50:49.637	2025-05-03 20:50:49.637	\N
468acedb-8eda-4a60-9956-50d5d50c638e	Carolina	Contreras Peréa		\N	3221048121	\N		2025-05-03 20:50:49.638	2025-05-03 20:50:49.638	\N
68d4b6e3-ed4b-4a6f-9684-d7ceb4de0043	Christian Alberto	Flores Meza		\N	\N	2005-03-26 00:00:00		2025-05-03 20:50:49.638	2025-05-03 20:50:49.638	\N
06f834ab-aa53-47da-8b77-31748eb778db	Christian Edgar	Soto Jaramillo		\N	\N	1984-09-14 00:00:00		2025-05-03 20:50:49.638	2025-05-03 20:50:49.638	\N
365b2e63-4b1a-4424-b9ae-765e65b5ad4d	Christian Giovani	Medina Rodriguez		\N	\N	\N		2025-05-03 20:50:49.638	2025-05-03 20:50:49.638	\N
89ecaf7e-0fb5-4360-a2f9-20f805d7e11c	Christian Giovany	Medina Rodríguez		\N	\N	1989-10-07 00:00:00		2025-05-03 20:50:49.639	2025-05-03 20:50:49.639	\N
e6516325-3b5d-4b05-82a3-ea07c99fc884	Christian Javier	Perez Quinter		\N	3222812618	2002-08-03 00:00:00		2025-05-03 20:50:49.639	2025-05-03 20:50:49.639	\N
f5368de4-c451-44ce-8d37-cde46b741fd7	Christian Omar	Medellin Hernandez		\N	\N	2010-03-02 00:00:00		2025-05-03 20:50:49.639	2025-05-03 20:50:49.639	\N
90e03fd3-8399-40e7-a102-4e8fae12b47c	Carolina Lizbeth	Aguilar Calvario		ev_clac06@hotmail.com	+523334524587	\N		2025-05-03 20:50:49.64	2025-05-03 20:50:49.64	\N
226e3902-c674-4c0a-b222-1cb94fd93d8a	Christine	Cooney		\N	3292955586	1955-06-09 00:00:00		2025-05-03 20:50:49.64	2025-05-03 20:50:49.64	\N
c4908f16-1ac9-4bb2-a666-03a21486a0ac	Christine	Schoeck		christin.schoeck@gmail.com	\N	1958-07-15 00:00:00		2025-05-03 20:50:49.64	2025-05-03 20:50:49.64	\N
abbefc98-ed91-48f3-83a3-3f09d89ec198	Christofer	Ochoa Navarro		chritofer.ochoa@hotmail.com	\N	1988-10-06 00:00:00		2025-05-03 20:50:49.641	2025-05-03 20:50:49.641	\N
456a4e37-cdb8-4673-acee-1cfc8b406d12	Christopher	Abbott		susyabbott9@gnail.com	\N	1989-07-17 00:00:00		2025-05-03 20:50:49.641	2025-05-03 20:50:49.641	\N
c48862ac-28af-44ab-9f06-a4bfd0a4464d	Christopher	Palese Zepeda		chrispalise@hotmail.com	\N	1996-04-14 00:00:00		2025-05-03 20:50:49.641	2025-05-03 20:50:49.641	\N
a6d3c47c-df35-4ca5-a751-dfe74fa6abd1	Christopher Guztavo	Barbosa Nuño		virgo_cg93@hotmail.com	\N	1993-09-06 00:00:00		2025-05-03 20:50:49.642	2025-05-03 20:50:49.642	\N
fe9ed226-55d8-4829-973c-3788ebcc89b1	Chuck	Dunlop		\N	\N	1967-07-06 00:00:00		2025-05-03 20:50:49.642	2025-05-03 20:50:49.642	\N
f3523dd8-20b0-437d-97f4-f41b21157fb6	Cindy	Tejeda Carrillo		\N	\N	2010-12-21 00:00:00		2025-05-03 20:50:49.642	2025-05-03 20:50:49.642	\N
bbab9ceb-389d-4b1b-882e-793191a79fc6	Catalina	Contreras Perea		\N	3221260409	\N		2025-05-03 20:50:49.643	2025-05-03 20:50:49.643	\N
be17508e-e012-4129-b78a-a3dfa05fbc96	Cindy Alaka	Samchez Chaves		sacha1987@hotmail.com	\N	1987-09-10 00:00:00		2025-05-03 20:50:49.643	2025-05-03 20:50:49.643	\N
4d5eef25-c7a9-451a-a362-ef6fed5efd92	Cinthia	Rodriguez Guerrero		\N	\N	\N		2025-05-03 20:50:49.643	2025-05-03 20:50:49.643	\N
0f23c41a-0594-4b37-b73b-40caa84e1d14	Cinthia	Toledo López		a.toledoelizabeth@gmail.com	\N	1991-02-09 00:00:00		2025-05-03 20:50:49.643	2025-05-03 20:50:49.643	\N
f1eb8fa4-af83-4b8a-a4af-54aa3e86fe97	Cinthia	Torres Ruvalcaba		i_bets@hotmail.com.es	\N	1995-07-13 00:00:00		2025-05-03 20:50:49.644	2025-05-03 20:50:49.644	\N
1b90d711-9822-496c-bf64-4a92c2fcb2e8	Cinthia	Vargas		\N	\N	\N		2025-05-03 20:50:49.644	2025-05-03 20:50:49.644	\N
cd238cbd-db29-4f23-9f62-ccfea37d11bd	Cinthiya Lizeth	Bobadilla Ornelas		\N	\N	1986-03-27 00:00:00		2025-05-03 20:50:49.644	2025-05-03 20:50:49.644	\N
7006cb09-c1a3-4c28-9af2-4926f34a1f42	Cinthya Abigail	Soto Castro		\N	\N	2012-04-30 00:00:00		2025-05-03 20:50:49.645	2025-05-03 20:50:49.645	\N
bdbfb1d9-4398-4f64-a599-2a683efc7085	Cinthya Fabiola	González rodríguez		\N	3224291950	\N		2025-05-03 20:50:49.645	2025-05-03 20:50:49.645	\N
b438e206-aed4-4dff-8a09-c2cc5c4419bc	Cinthya Noemi	Diaz Romero		\N	\N	1987-09-03 00:00:00		2025-05-03 20:50:49.645	2025-05-03 20:50:49.645	\N
7875ce17-30ff-4641-8bbc-e6c296363a7f	Cinthya Noemi	Diaz Romero		\N	\N	\N		2025-05-03 20:50:49.646	2025-05-03 20:50:49.646	\N
8c17d5dd-0368-4d05-b230-b83a404d4f18	Cintia	Esperon Mijares		cynthiaesperon_05@hotmail.com	\N	1981-05-05 00:00:00		2025-05-03 20:50:49.646	2025-05-03 20:50:49.646	\N
d3ce4407-107c-4a43-9b53-49ac5ddaa6da	Cintia Noemi	Gutierrez Palomera		cinthia_arkos@hotmail.com	\N	1989-01-26 00:00:00		2025-05-03 20:50:49.646	2025-05-03 20:50:49.646	\N
c1378677-8cde-4fff-86d2-f5b456e7749c	Cintya	López Lepe		cintyalole@hotmail.com	\N	1989-10-27 00:00:00		2025-05-03 20:50:49.647	2025-05-03 20:50:49.647	\N
4f828093-27ba-4ad4-80b4-34177122fd5c	Ciryl	Valentina		\N	\N	1971-04-14 00:00:00		2025-05-03 20:50:49.647	2025-05-03 20:50:49.647	\N
5d3e32c8-9b26-4bb9-afe4-665c8593b428	Carlos	Camba		\N	+523221098387	\N		2025-05-03 20:50:49.647	2025-05-03 20:50:49.647	\N
2be3b61f-2713-46be-8be2-a9c01f712b6e	Citlalli Sofía	Galindo García		sonnodellavita@hotmail.com	3221085415	1990-04-09 00:00:00		2025-05-03 20:50:49.648	2025-05-03 20:50:49.648	\N
2d1dc8a9-a19d-4e6d-89f5-a6a65e1b5dd6	Clara	Hernández Monterrubio		\N	\N	2005-07-20 00:00:00		2025-05-03 20:50:49.648	2025-05-03 20:50:49.648	\N
bbeaf6d9-b458-435a-b4ce-e3ac66f48e68	Clara	Ramirez Aldaco		claritaaldaco@hotmail.com	\N	1980-11-27 00:00:00		2025-05-03 20:50:49.648	2025-05-03 20:50:49.648	\N
11defbff-ec2e-4733-a6dd-24c3109d4a96	Cecilia	Macedo Aranda		\N	3221824853	\N		2025-05-03 20:50:49.649	2025-05-03 20:50:49.649	\N
8f264106-321f-42e1-be62-70eea945c665	Clara Patricia	Guevara Rubio.		\N	\N	2011-01-19 00:00:00		2025-05-03 20:50:49.649	2025-05-03 20:50:49.649	\N
f5300ada-7545-4ce1-ba53-f2cc3e7d9fa1	Clara Sofia	Mirassou Nuñez		\N	\N	\N		2025-05-03 20:50:49.649	2025-05-03 20:50:49.649	\N
563cdb91-0c08-46ee-9248-077d4f10bc1c	Carlos	Gonzalez Paredes		\N	\N	1949-03-10 00:00:00		2025-05-03 20:50:49.65	2025-05-03 20:50:49.65	\N
35203735-2b6c-44a7-8cb3-673e5a926729	CLARE	Broward		\N	\N	\N		2025-05-03 20:50:49.65	2025-05-03 20:50:49.65	\N
17f00dfd-8807-49b2-96cc-79176491a5b3	Clare	Wilkins		lavidaclarita@yahoo.com	\N	1970-09-24 00:00:00		2025-05-03 20:50:49.65	2025-05-03 20:50:49.65	\N
fe84234a-225d-4573-aa1e-f70fdb40e68c	Clarence	Eddy		\N	\N	\N		2025-05-03 20:50:49.651	2025-05-03 20:50:49.651	\N
1ca17fc5-e88d-47a1-b168-e74acbce338e	Claudia	Avila Aguilera		\N	3221785418	\N		2025-05-03 20:50:49.651	2025-05-03 20:50:49.651	\N
6ada588c-eead-41be-a9c0-f0eccbec4ac2	Claudia	Barrera		\N	\N	2007-04-16 00:00:00		2025-05-03 20:50:49.651	2025-05-03 20:50:49.651	\N
d838587a-d0ae-44a4-b175-378705dbb2ce	Claudia	Calderon Baltazar		clauscalderon@hotmail.com	\N	1970-11-25 00:00:00		2025-05-03 20:50:49.651	2025-05-03 20:50:49.651	\N
60c12a72-c159-4669-a8ab-ad538036a127	Claudia	Del León Martinéz		\N	\N	2008-05-22 00:00:00		2025-05-03 20:50:49.652	2025-05-03 20:50:49.652	\N
739a04d1-8c60-4715-8b7c-f9df5abb11f9	Claudia	Duran Alonzo		\N	\N	1977-04-22 00:00:00		2025-05-03 20:50:49.652	2025-05-03 20:50:49.652	\N
cd4e50e5-ac55-4f55-9132-ddec18d1b98c	Claudia	Gallegos ¨Perez		\N	\N	1968-08-12 00:00:00		2025-05-03 20:50:49.653	2025-05-03 20:50:49.653	\N
dc2e194a-706d-43ad-b44b-0db9da53ff67	Cesar	Jimenez Martinez		cjimenez@ecosta.com.mx	\N	1971-06-18 00:00:00		2025-05-03 20:50:49.653	2025-05-03 20:50:49.653	\N
e033b3b2-43f6-4d61-9060-f257851240ab	Claudia	Lopez Jaimes		cloelopez@gmail.com	\N	1972-07-01 00:00:00		2025-05-03 20:50:49.653	2025-05-03 20:50:49.653	\N
947af416-08c4-4527-b5d4-56c858175537	Claudia	Montero Hernández		claus_rocio@hotmail.com	\N	1982-12-03 00:00:00		2025-05-03 20:50:49.654	2025-05-03 20:50:49.654	\N
b19aad05-6320-4701-85f0-aa622504341a	Cesar	Maruri		cesarmaruri@gmail.com	+522288371644	\N		2025-05-03 20:50:49.654	2025-05-03 20:50:49.654	\N
b2570bd6-ab24-4cc7-bf5b-eebf7649e01d	Claudia	Sanchez Vigil		\N	\N	\N		2025-05-03 20:50:49.654	2025-05-03 20:50:49.654	\N
8bc25d6a-f69d-4b69-b9f3-70e953920887	Claudia  Vianey	Rosales Alvarado		yo_clau_9@hotmail.com	\N	1995-07-20 00:00:00		2025-05-03 20:50:49.655	2025-05-03 20:50:49.655	\N
d125fe8f-7252-431d-8e5f-7f82fdaa99b0	Claudia Alicia	Carrasco León		claucarrasco00@hotmail.com	3221881160	1988-05-31 00:00:00		2025-05-03 20:50:49.655	2025-05-03 20:50:49.655	\N
0f107721-c3f1-4856-9d71-8dfd004ed695	Claudia Angelica	López Martínez		conejoguapo@hotmail.com	\N	1975-05-19 00:00:00		2025-05-03 20:50:49.655	2025-05-03 20:50:49.655	\N
023ae70f-37a9-4eba-80c8-cd39045b7086	Claudia Berenice	Gutierres Rivera		\N	\N	\N		2025-05-03 20:50:49.656	2025-05-03 20:50:49.656	\N
2710df60-9e44-4da1-9de7-49351f67ed2e	Claudia Daniela	Peña Hernández		\N	\N	1996-01-05 00:00:00		2025-05-03 20:50:49.656	2025-05-03 20:50:49.656	\N
628b923c-724c-4ffe-8069-d20281b44857	Claudia Edith	Martinez Bernal		mbce0427@gmail.com	\N	1978-04-27 00:00:00		2025-05-03 20:50:49.656	2025-05-03 20:50:49.656	\N
a0150abb-ac63-45b6-b512-7f8a53ca466d	Claudia Guadalupe	Ventoza  Alonzo		\N	\N	\N		2025-05-03 20:50:49.656	2025-05-03 20:50:49.656	\N
e224bb94-50f3-4c4c-9b65-9d17f63b95c5	Claudia Valeria	Garrido Velázco		\N	3221270642	2005-12-21 00:00:00		2025-05-03 20:50:49.657	2025-05-03 20:50:49.657	\N
90cd6f27-091d-4e73-b5b0-4f9c38159c91	Claudia Veronica	Diaz Garcia		\N	\N	\N		2025-05-03 20:50:49.657	2025-05-03 20:50:49.657	\N
6ed3e336-d141-41d8-9802-9bc99c197464	Claudia Veronica	Diaz García.		claudiadiaz@hotmail.com	\N	1997-03-18 00:00:00		2025-05-03 20:50:49.658	2025-05-03 20:50:49.658	\N
b91a81f8-433f-49ac-8037-4860498c23b3	Chen	Keden		\N	3221806412	\N		2025-05-03 20:50:49.658	2025-05-03 20:50:49.658	\N
f15f8662-7480-49d4-882b-2c0b3f8a26d6	Claudine	Coussens		exoclo@live.fr	\N	1963-04-08 00:00:00		2025-05-03 20:50:49.658	2025-05-03 20:50:49.658	\N
b3d2d127-2123-4477-b6f6-8a01336437d3	Claudio	Morga		claudiomorga@hotmail.com	\N	1969-10-30 00:00:00		2025-05-03 20:50:49.658	2025-05-03 20:50:49.658	\N
555e6a53-fc24-438e-b523-a7f51bf18b70	Claudio	Rodríguez Aguirre		\N	\N	1963-08-12 00:00:00		2025-05-03 20:50:49.659	2025-05-03 20:50:49.659	\N
adf689e4-47e6-4b3b-8819-e9cce4aa2064	Chen	Keden		\N	3221806412	\N		2025-05-03 20:50:49.659	2025-05-03 20:50:49.659	\N
8eea3572-ec09-44eb-b6af-ea0a1983995d	Clayton	Belitski		Jennicaw@pawfc.com	+14034660324	\N		2025-05-03 20:50:49.66	2025-05-03 20:50:49.66	\N
50e82b68-0848-492c-a11a-948ea58733a1	Coco	Valentin Serrano		cocoleoco.cv@gmail.com	\N	1966-02-09 00:00:00		2025-05-03 20:50:49.66	2025-05-03 20:50:49.66	\N
0352f2a8-d11e-4887-9ced-97b379dac92c	Columba	Hernandez  Gutierrez		\N	\N	1993-11-26 00:00:00		2025-05-03 20:50:49.66	2025-05-03 20:50:49.66	\N
31e36e51-255f-4e59-a35f-2c432df53dff	Concepción	Ibarra Trejo		conchita_ibarra2003@yahoo.com.mx	\N	1945-03-25 00:00:00		2025-05-03 20:50:49.661	2025-05-03 20:50:49.661	\N
4127e114-cd7d-4e29-91f5-a86e3d840f2d	Concepciòn	Martinez Sanchez		\N	\N	2010-03-23 00:00:00		2025-05-03 20:50:49.661	2025-05-03 20:50:49.661	\N
4ef6f031-ab11-4903-82cf-645af571f8f8	Concepcion	Moran dela Rosa		\N	\N	\N		2025-05-03 20:50:49.661	2025-05-03 20:50:49.661	\N
7881226d-189b-4ab8-9ebd-81546d56fe94	Concepcion	Moreno Aramburo		cocho_moreno@hotmail.com	\N	1956-11-15 00:00:00		2025-05-03 20:50:49.662	2025-05-03 20:50:49.662	\N
6e717eb4-ec58-4057-a880-299ccdf08e64	Concesa	Uribe Navarro		\N	\N	1966-08-26 00:00:00		2025-05-03 20:50:49.662	2025-05-03 20:50:49.662	\N
d262fbb3-38ce-43e1-bb06-d96fe3ef44a2	Coni	Cordoba Javalois		conniecordova@hotmail.com	\N	1967-10-05 00:00:00		2025-05-03 20:50:49.662	2025-05-03 20:50:49.662	\N
d912b31c-e7a9-4e59-8c6a-666058217f13	Connie	Peterson		petersonconnie7@gmail.com	\N	1957-04-28 00:00:00		2025-05-03 20:50:49.662	2025-05-03 20:50:49.662	\N
e960e5f5-77c2-473e-92b0-d33a53683b2f	Consuelo	Rodriguez Garcia		\N	\N	1966-09-03 00:00:00		2025-05-03 20:50:49.663	2025-05-03 20:50:49.663	\N
d754124d-8090-4428-a096-a40a625ae96f	Consuelo	Topete Macedo		\N	\N	\N		2025-05-03 20:50:49.663	2025-05-03 20:50:49.663	\N
8faab953-39b8-49d8-afed-1ddc551f79a0	Cora	Galvan Cerón		\N	\N	1965-07-10 00:00:00		2025-05-03 20:50:49.663	2025-05-03 20:50:49.663	\N
34b9e381-ddb8-4e53-af9d-ee15dc478ee9	Christian	Gonzalez		\N	4421226505	\N		2025-05-03 20:50:49.664	2025-05-03 20:50:49.664	\N
02a2120d-4df8-450d-88eb-46f91be78bcc	Christina	Villalobos Martinez		\N	\N	\N		2025-05-03 20:50:49.664	2025-05-03 20:50:49.664	\N
15bb2eeb-cf74-4ba0-9b04-8e6cacc23edd	Coral	Ramirez Negrete		\N	\N	\N		2025-05-03 20:50:49.664	2025-05-03 20:50:49.664	\N
6f9f8674-9846-4ce2-a6ef-a055aeed8abd	Corazón	Ruiz Hérnadez		\N	\N	1953-07-11 00:00:00		2025-05-03 20:50:49.665	2025-05-03 20:50:49.665	\N
f10c0f12-1dba-401d-bb9c-0ebdc9fab8f9	Cori	Jansen		\N	\N	\N		2025-05-03 20:50:49.665	2025-05-03 20:50:49.665	\N
68727294-b579-4fbb-8ace-2969a9b51f1c	Corina Elizabeth	Meza Romero		\N	3223795302	\N		2025-05-03 20:50:49.665	2025-05-03 20:50:49.665	\N
dbdbffb4-4285-473f-855c-b8ae5f2d407e	Corina Monserrat	Luna Rodriguez		\N	\N	2010-06-15 00:00:00		2025-05-03 20:50:49.666	2025-05-03 20:50:49.666	\N
2d4ceaf1-2ef9-4091-9446-a43a7dcae54a	Corinne	Fernàndez Brandi		\N	\N	1956-05-14 00:00:00		2025-05-03 20:50:49.666	2025-05-03 20:50:49.666	\N
de0d8fde-3fbd-4f6c-85ba-6f2ec97bc95c	Cory	Modzen		\N	\N	\N		2025-05-03 20:50:49.666	2025-05-03 20:50:49.666	\N
1639d075-d5be-4c74-96eb-fb17971f7b95	Cory	Mozdzen		corymwk@autlook.com	\N	1971-07-30 00:00:00		2025-05-03 20:50:49.667	2025-05-03 20:50:49.667	\N
b4618df4-4d4c-4491-92ed-10e6205d31bd	Coutu	Jean Pierre		coutujp@hotmail.com	\N	\N		2025-05-03 20:50:49.667	2025-05-03 20:50:49.667	\N
432fc49e-7e9a-4bd9-bfce-9381876ace80	Craig	Abhamon		\N	\N	2010-02-22 00:00:00		2025-05-03 20:50:49.667	2025-05-03 20:50:49.667	\N
350d31d4-a055-4326-91b1-e4bce86f418e	Crecencia	Villa Valdéz		\N	3222226601	1941-12-29 00:00:00		2025-05-03 20:50:49.667	2025-05-03 20:50:49.667	\N
02328302-9b4d-4891-8685-9abc13e95aa0	Crhistian Ivan	Bravo Orozco		\N	\N	2011-04-06 00:00:00		2025-05-03 20:50:49.668	2025-05-03 20:50:49.668	\N
09f2a452-52ce-4bab-8255-7b839ea1aa67	Crhistofer Orlando	Cabrera Lorenzo		\N	\N	2006-12-25 00:00:00		2025-05-03 20:50:49.668	2025-05-03 20:50:49.668	\N
b62cd578-c381-409c-ae1a-fd787444cf74	Crhitine	Cameron		\N	\N	\N		2025-05-03 20:50:49.668	2025-05-03 20:50:49.668	\N
08fcec20-94af-4f07-960c-83160e832a73	Cris	Herrera-Rodriguez		crisherrerarodriguez9@gmail.com	+529833335099	\N		2025-05-03 20:50:49.669	2025-05-03 20:50:49.669	\N
f3b1cb42-91a8-4993-a4ff-cb042d5432d1	Crispin	Gutierrez Ayala		\N	\N	1952-12-05 00:00:00		2025-05-03 20:50:49.669	2025-05-03 20:50:49.669	\N
594d527d-b282-4572-855f-30d54e9dc703	Cristal	Romero Ahumada		\N	\N	2011-04-02 00:00:00		2025-05-03 20:50:49.669	2025-05-03 20:50:49.669	\N
4588fa99-77a9-4b83-a9c1-3f590cd03de9	Cristian	de la Rosa Mesa		\N	\N	2002-10-29 00:00:00		2025-05-03 20:50:49.67	2025-05-03 20:50:49.67	\N
b9185934-ac5c-4eec-b9d1-63e8dca206d8	Cristian	Duran Geyne		\N	\N	1980-02-11 00:00:00		2025-05-03 20:50:49.67	2025-05-03 20:50:49.67	\N
ff40c5f7-0c56-4fad-8c72-33f606e4207d	Cindy	Walton		\N	+17809090354	\N		2025-05-03 20:50:49.67	2025-05-03 20:50:49.67	\N
b41ebb62-34da-4d88-b134-ccdfadb84ca0	Cristian	Gil Romero		\N	\N	1988-05-04 00:00:00		2025-05-03 20:50:49.671	2025-05-03 20:50:49.671	\N
e6380d85-0c90-42c9-9d7c-7fe774329841	Cristian	Lorenzana Guizar		\N	\N	1991-02-06 00:00:00		2025-05-03 20:50:49.671	2025-05-03 20:50:49.671	\N
291d92e1-bb56-42bd-a75d-b28fc8c47109	Cristian	Martinez		\N	\N	\N		2025-05-03 20:50:49.671	2025-05-03 20:50:49.671	\N
0fcf8196-644c-48da-8d6e-278eded45843	Cristian	Piña Carrillo		\N	\N	2003-08-19 00:00:00		2025-05-03 20:50:49.671	2025-05-03 20:50:49.671	\N
9a42ebe0-edda-4e97-bf51-67bc5db2bd4f	Cristian	Sanchez Jimenez		\N	\N	1994-12-15 00:00:00		2025-05-03 20:50:49.672	2025-05-03 20:50:49.672	\N
2b5f68cf-8348-49a2-8834-47462a83b8d7	Cristian Alberto	Alvarado		Megia_cristhian92@gmail.com	\N	1992-08-20 00:00:00		2025-05-03 20:50:49.672	2025-05-03 20:50:49.672	\N
fa3ea378-ad5a-414a-b388-31a2f646b693	Cristian Eduardo	García Bojorquez		\N	\N	1985-01-04 00:00:00		2025-05-03 20:50:49.672	2025-05-03 20:50:49.672	\N
4f0767f4-0f43-4d4d-aa4b-1cde10ea9e59	Cristian Javier	Perez Montero		ccjjpm@gmail.com	\N	2002-08-03 00:00:00		2025-05-03 20:50:49.673	2025-05-03 20:50:49.673	\N
884de7a4-9450-44d1-b9cc-eab4d8256f1e	Cristian Yahir	García Barba		\N	3221411579	\N		2025-05-03 20:50:49.673	2025-05-03 20:50:49.673	\N
d6db95b3-623b-4e39-99f9-51d612be3a0a	Cristina	Abarca Moreno		\N	\N	\N		2025-05-03 20:50:49.674	2025-05-03 20:50:49.674	\N
d88a7ff4-541c-4290-8421-097755642628	Cristina	Dalli		\N	\N	\N		2025-05-03 20:50:49.674	2025-05-03 20:50:49.674	\N
159ebf64-c0c6-4f06-a284-84389ae13715	Cristina	Gonzalez Gonzalez		\N	\N	2008-02-29 00:00:00		2025-05-03 20:50:49.674	2025-05-03 20:50:49.674	\N
3f377be5-856c-4e56-90b7-f5284a822cda	Cristina	Hernandez Garcia		klisty2@hotmail.com	\N	1970-12-27 00:00:00		2025-05-03 20:50:49.674	2025-05-03 20:50:49.674	\N
969b0c6b-d2a6-463e-994b-4abb79af6a44	Cristina	Koransky		cameron1910@sbcglobal.net	\N	1945-05-15 00:00:00		2025-05-03 20:50:49.675	2025-05-03 20:50:49.675	\N
9e9fe213-0b9c-4e0b-b773-0bb37ae043f5	Citlalli	Perez Meza		citlalli.perez.meza@gmail.com	\N	1972-05-26 00:00:00		2025-05-03 20:50:49.675	2025-05-03 20:50:49.675	\N
35d969e6-aa63-4454-b5de-7666d531e77d	Cristina	Peña		\N	+13607896330	\N		2025-05-03 20:50:49.675	2025-05-03 20:50:49.675	\N
c2a4d099-4c01-4ce9-9d76-369a31851f81	Cristina	Rodriguez Moreno		\N	\N	1982-10-25 00:00:00		2025-05-03 20:50:49.676	2025-05-03 20:50:49.676	\N
3ef7c484-fda8-45d3-8b28-ba9aba4fbcce	Cristina	Rodriguez Moreno		\N	+523221640271	1900-01-02 00:00:00		2025-05-03 20:50:49.676	2025-05-03 20:50:49.676	\N
91f8d586-a8f0-45dd-a54a-39974bd3a5d9	Cristina	Ruiz Estrada		cristyruiz1904@hotmail.com	\N	1977-04-19 00:00:00		2025-05-03 20:50:49.676	2025-05-03 20:50:49.676	\N
404421b2-2582-4f76-bf59-ea32b1f5a61a	Clara Jasive	Cruz Martinez		jasivecruz97@gmail.com	+523221469701	\N		2025-05-03 20:50:49.677	2025-05-03 20:50:49.677	\N
1162e456-5d0a-4aa9-9c40-72aad8f955be	Cristina Estefania	Rivera Islas		\N	\N	\N		2025-05-03 20:50:49.677	2025-05-03 20:50:49.677	\N
cd09d240-1020-4376-a56a-719e19a582bd	Cristina Guadalupe	Torres Lopez		\N	\N	\N		2025-05-03 20:50:49.677	2025-05-03 20:50:49.677	\N
4f5003bf-8660-4eaa-8fbb-de7cb5fe2cbb	Cristopher	Abaji		\N	\N	\N		2025-05-03 20:50:49.678	2025-05-03 20:50:49.678	\N
837cf1b6-a300-4dc0-9551-51ca0907871c	Cristopher	Alvarado Rosales		\N	\N	2011-06-27 00:00:00		2025-05-03 20:50:49.678	2025-05-03 20:50:49.678	\N
0577c1a3-ea16-42bf-a48e-4b85fc5bc23e	Cecilia	Naya Jimenez		\N	3221169085	\N		2025-05-03 20:50:49.678	2025-05-03 20:50:49.678	\N
d632fe35-6dce-467c-923d-bc1928792ee7	Cristopher Alexis	Agilar Valenzuela		\N	\N	2010-04-30 00:00:00		2025-05-03 20:50:49.678	2025-05-03 20:50:49.678	\N
f0f6d059-697e-41f1-bebf-fa46940daf03	Claudia	Ramíres Rúbi		\N	3221356892	\N		2025-05-03 20:50:49.679	2025-05-03 20:50:49.679	\N
4fdf6f6d-da80-4bfb-a391-2ceaf9fa7d05	Crsitina	Villegas Olivares		\N	\N	1966-09-23 00:00:00		2025-05-03 20:50:49.679	2025-05-03 20:50:49.679	\N
3f51a5f1-4849-403f-96b1-d350b9e215e7	Cudberto	Hernández Delgado		\N	\N	\N		2025-05-03 20:50:49.679	2025-05-03 20:50:49.679	\N
2b70acbf-8304-47bd-b341-faf9db993f85	Curiel Rodríguez	Jose Salvador		jscurielr@gmail.com	5522043378	\N		2025-05-03 20:50:49.68	2025-05-03 20:50:49.68	\N
558f8401-e983-41ce-8ba0-fb9401f3785a	cxianey	Gudiño		\N	\N	\N		2025-05-03 20:50:49.68	2025-05-03 20:50:49.68	\N
5f66aec6-2ebf-4e53-ad04-0a0283f8a03b	Cynthia	Esperon Mijares		cynthiaesperon_5@hotmail.com	\N	1981-05-05 00:00:00		2025-05-03 20:50:49.68	2025-05-03 20:50:49.68	\N
49e0dc91-b87a-4ffe-ab48-09dfd46e1524	Cynthia	García Villla		p109_cinthya@hotmail.com	\N	1991-03-25 00:00:00		2025-05-03 20:50:49.681	2025-05-03 20:50:49.681	\N
a4d8db6e-bbc7-437e-b359-a52cecf5dccd	Cynthia	Lichfield		cynthialichfield@gmail.com	\N	1955-05-23 00:00:00		2025-05-03 20:50:49.681	2025-05-03 20:50:49.681	\N
82f970b5-1b68-447e-b741-bd7be1aa7438	Claudia Yadira	Arambul Solis		yoyiyss@gmail.com	3222451035	\N		2025-05-03 20:50:49.681	2025-05-03 20:50:49.681	\N
17466cd8-5ecd-4773-8ad0-7fb3bfe82821	Dale	Rourck		\N	\N	1951-09-30 00:00:00		2025-05-03 20:50:49.682	2025-05-03 20:50:49.682	\N
31dc0eda-67c0-463c-a8c5-5379bec984d4	Dalia	Jimenez  Madero		\N	\N	\N		2025-05-03 20:50:49.682	2025-05-03 20:50:49.682	\N
3c43d90b-d1f7-45b6-afb3-ad72d3ab5749	Claurdia	Hernández		\N	\N	1975-01-07 00:00:00		2025-05-03 20:50:49.682	2025-05-03 20:50:49.682	\N
c689c8dc-2b49-4e5a-ac1c-8877ac652d5f	Damar	Rámirez Romero		berenan-013@live.com.mx	\N	1992-12-13 00:00:00		2025-05-03 20:50:49.683	2025-05-03 20:50:49.683	\N
ad128c65-090d-4e5f-8352-7daa8ab72d27	Damaris	Diaz Lepe		\N	\N	1998-12-27 00:00:00		2025-05-03 20:50:49.683	2025-05-03 20:50:49.683	\N
e549989c-fb06-4b66-97d5-9fd344b22d57	Damaris	Peña Aguirre		damaris_p89@yahoo.com.mx	\N	1989-08-03 00:00:00		2025-05-03 20:50:49.683	2025-05-03 20:50:49.683	\N
97f651e9-22bc-441c-934a-54a7d1f9ad5c	Cora	Ortiz		canal3.cortiz@gmail.com	+527773069161	\N		2025-05-03 20:50:49.683	2025-05-03 20:50:49.683	\N
c9d2f7a2-7b61-482b-8a47-8328f0bd044d	Damian Ildelfonzo	Clemente Lugo		\N	\N	1979-11-07 00:00:00		2025-05-03 20:50:49.684	2025-05-03 20:50:49.684	\N
93a5b674-b96e-43f5-b28a-e689871f8b42	Cora	Ortiz Morales		\N	7773069161	\N		2025-05-03 20:50:49.684	2025-05-03 20:50:49.684	\N
ce6b3528-4a3b-4c9e-8816-a144bc6b4c90	Dana Michelle	Lopez Alonzo		danamichellopezalonzo@hotmail.com	3222226601	2005-12-22 00:00:00		2025-05-03 20:50:49.684	2025-05-03 20:50:49.684	\N
9869ba3e-6884-40cd-a3c3-588d2dbd4518	Danailcho	Dimov		macmexphotography@gmail.com	3222243076	1971-01-28 00:00:00		2025-05-03 20:50:49.685	2025-05-03 20:50:49.685	\N
caa25008-0b88-499b-b3e7-014c97f65e96	Daniel	Allen		danielrallen10@gmail.com	\N	1987-10-10 00:00:00		2025-05-03 20:50:49.685	2025-05-03 20:50:49.685	\N
0c0509fe-2ca7-43ee-98a5-89597bc8260c	Daniel	Amarillas Hdéz.		\N	\N	2009-01-24 00:00:00		2025-05-03 20:50:49.685	2025-05-03 20:50:49.685	\N
f101128d-0521-4997-93c8-66ecfe82ba38	Daniel	Carrillo Palacios		adar_assur6@hotmail.com	\N	\N		2025-05-03 20:50:49.686	2025-05-03 20:50:49.686	\N
d82cf426-3e9a-4f31-8b10-70d1a0c70705	Daniel	dela Rosa Fonceca		\N	\N	2007-08-01 00:00:00		2025-05-03 20:50:49.686	2025-05-03 20:50:49.686	\N
ee831e1b-44ac-4374-953e-f3d8a226028c	Daniel	Eickschen		\N	\N	\N		2025-05-03 20:50:49.686	2025-05-03 20:50:49.686	\N
15bd370f-2b77-46e6-bb33-066933797b8f	Daniel	Flores Montoya		\N	\N	1948-09-22 00:00:00		2025-05-03 20:50:49.687	2025-05-03 20:50:49.687	\N
0840cc6f-6a7a-4bbf-a54a-80f78d764481	Cristina	Villalobos		mtra.villalobos@gmail.com	+523221113565	1978-07-24 00:00:00		2025-05-03 20:50:49.687	2025-05-03 20:50:49.687	\N
8d3125ef-b7b9-4753-801d-d77584755ebd	Daniel	Flores Vera		\N	\N	1974-04-19 00:00:00		2025-05-03 20:50:49.687	2025-05-03 20:50:49.687	\N
2e23a605-5964-4d25-9601-2b53fb49c146	Daniel	Freeman		\N	\N	\N		2025-05-03 20:50:49.688	2025-05-03 20:50:49.688	\N
97212460-00bd-4812-926f-a1ef73e000d7	Daniel	Fuentes Carrillo		DJCKNR@GMAIL.COM	\N	1985-01-29 00:00:00		2025-05-03 20:50:49.688	2025-05-03 20:50:49.688	\N
0a34014f-618d-48ae-9679-d6c01f34fd8e	Daniel	Fuentes Hernandéz		\N	\N	\N		2025-05-03 20:50:49.688	2025-05-03 20:50:49.688	\N
94ac4b11-8f64-423b-b029-bd877cacf449	Daniel	Gallo Arevalo		dgallovallarta@gmail.com	3221724835	1973-12-04 00:00:00		2025-05-03 20:50:49.689	2025-05-03 20:50:49.689	\N
4c344def-88ea-4eec-89b0-8e3b5cf36a53	Daniel	Gonzales Hernández		\N	\N	2003-09-26 00:00:00		2025-05-03 20:50:49.689	2025-05-03 20:50:49.689	\N
f8db9f3d-47d1-40b4-b19b-cdfb377b18fc	Daniel	Guevara		\N	\N	2007-05-15 00:00:00		2025-05-03 20:50:49.689	2025-05-03 20:50:49.689	\N
ea2295ae-7712-48a5-8248-24be7326f92f	Daniel	Gutierrez		\N	\N	1976-07-21 00:00:00		2025-05-03 20:50:49.69	2025-05-03 20:50:49.69	\N
1267b1f5-469a-4b5c-840e-1da35eecd96b	Daniel	Ibarra Díaz		\N	\N	\N		2025-05-03 20:50:49.69	2025-05-03 20:50:49.69	\N
50216eac-aebb-4a7f-ac3b-dc188f583b58	Daniel	Land		\N	\N	\N		2025-05-03 20:50:49.69	2025-05-03 20:50:49.69	\N
0fd5d0b9-2d0a-4904-8506-5a3c6b7f4338	Daniel	Macedo Rendon		macedorendonj@gmail-com	\N	1991-08-26 00:00:00		2025-05-03 20:50:49.691	2025-05-03 20:50:49.691	\N
ac52f918-b87a-42d6-ab91-7b73c5c3eacb	Daniel	Marquez Oros		dmemarquez@hotmail.com	\N	1974-09-08 00:00:00		2025-05-03 20:50:49.691	2025-05-03 20:50:49.691	\N
a7a6bdbb-9dc8-4633-a31a-60091456dc5f	Daniel	Migall		\N	\N	\N		2025-05-03 20:50:49.691	2025-05-03 20:50:49.691	\N
37d6f644-fbbf-4b7a-80e9-5088085d249c	Daniel	Amador		\N	3221312585	\N		2025-05-03 20:50:49.691	2025-05-03 20:50:49.691	\N
f1825dc5-e3dc-4eda-917b-ff4d8937f1d3	Daniel	Palafox Espinoza		danielálafoxespinoza@gmail.com	\N	1996-03-25 00:00:00		2025-05-03 20:50:49.692	2025-05-03 20:50:49.692	\N
c30eb630-aec5-4258-b253-6c4709e5af91	Daniel	Ramirez Ortega		\N	\N	1973-11-09 00:00:00		2025-05-03 20:50:49.692	2025-05-03 20:50:49.692	\N
44ced70b-c85d-4322-a61d-2909670e9de2	Daniel	Salazar Martinez		salazar.danni@gmail.com	\N	1983-09-01 00:00:00		2025-05-03 20:50:49.692	2025-05-03 20:50:49.692	\N
d4db24b2-a00e-4ee6-827d-899c6e7325cc	Daniel	Tomatis		\N	3221591255	1955-12-09 00:00:00		2025-05-03 20:50:49.693	2025-05-03 20:50:49.693	\N
7581f7e3-5e7d-4fb4-a383-3d2997995f19	Daniel	Velasco Mendizabal		\N	\N	2007-11-17 00:00:00		2025-05-03 20:50:49.693	2025-05-03 20:50:49.693	\N
3c98c96b-b50f-4c0f-af2d-7bbbc3fbf7f3	Cristina	Mercado Estrada		\N	3221314274	\N		2025-05-03 20:50:49.693	2025-05-03 20:50:49.693	\N
56dad7bf-c810-4d6a-8dce-8773989330f7	Daniel Albert	Bocanegra Lopez		\N	\N	2011-03-08 00:00:00		2025-05-03 20:50:49.694	2025-05-03 20:50:49.694	\N
ed175bfd-2a66-4632-ae6a-a2933adf295f	Daniel Edwuard	Peck		dpeck6524@gmail.com	\N	1965-02-28 00:00:00		2025-05-03 20:50:49.694	2025-05-03 20:50:49.694	\N
ac3a790d-1833-41b9-9524-72199eeaa0a1	Cristian	Garcia		cristian.garciagu@gmail.com	+525538876151	\N		2025-05-03 20:50:49.694	2025-05-03 20:50:49.694	\N
c0ecdd06-8cf8-4a39-9a89-6c5856375ac2	Daniela	Chavez Hernández		\N	\N	1994-04-02 00:00:00		2025-05-03 20:50:49.695	2025-05-03 20:50:49.695	\N
a0eaa2fa-1abb-48db-ab72-9271c5e427ff	Cristopher	Carrasco		\N	3313567856	\N		2025-05-03 20:50:49.695	2025-05-03 20:50:49.695	\N
dff25328-56d3-40c1-9632-fb55cba938f9	Daniela	Ruiz Arce		\N	\N	2006-01-16 00:00:00		2025-05-03 20:50:49.695	2025-05-03 20:50:49.695	\N
caca1992-f020-455a-9b9a-903e2829a18e	Clara Yang	Sandoval Han		klarsonne28@gmail.com	+523221015166	\N		2025-05-03 20:50:49.696	2025-05-03 20:50:49.696	\N
1860c2be-1477-476e-a5c8-32ad860c831d	Daniela Monserrat	Valencia Zamora		daniela@lifestylepropertiespv.com	\N	\N		2025-05-03 20:50:49.696	2025-05-03 20:50:49.696	\N
e45d4778-6cc4-469b-946c-b148c799c4d1	Daniela Virginia	Cremasco del Monte		dany_cremas@hotmail.com	\N	1990-11-14 00:00:00		2025-05-03 20:50:49.696	2025-05-03 20:50:49.696	\N
37f7f574-6f4f-4eaf-ac34-8bea27df4ea8	Claudia	Hernadez Lopez		\N	3221560824	\N		2025-05-03 20:50:49.696	2025-05-03 20:50:49.696	\N
83304815-8b69-43e2-aaa4-4c43ed81127e	Danielle	Heroux		danielleheroux6@hotmail.com	3223830966	1958-06-08 00:00:00		2025-05-03 20:50:49.697	2025-05-03 20:50:49.697	\N
8e5282df-719e-41f2-b878-7407ede30dad	Danielle	Yoja		dd.jb99@outlook.com	\N	1957-08-27 00:00:00		2025-05-03 20:50:49.697	2025-05-03 20:50:49.697	\N
53dd012e-d023-4747-8171-22ea4e5d3f08	Danitxia Yandeli	Zepeda Barrios		\N	\N	2010-03-11 00:00:00		2025-05-03 20:50:49.697	2025-05-03 20:50:49.697	\N
f00ae6f5-333a-4046-ad14-b3427401ef1e	Danna	Salazar Lopez		\N	\N	2010-09-18 00:00:00		2025-05-03 20:50:49.698	2025-05-03 20:50:49.698	\N
16b3e6b8-37ce-43ec-921a-c5bf76e71a8e	Danna Michell	Lopez Alonso		\N	\N	\N		2025-05-03 20:50:49.698	2025-05-03 20:50:49.698	\N
5479e0ad-6c51-4588-b4f8-ed66c98aaa95	Daira	Barajas Martínez		d.marianabarajas@gmail.com	+523320668513	\N		2025-05-03 20:50:49.698	2025-05-03 20:50:49.698	\N
cd7f64a6-678d-4df9-99a6-7c6c5194f12c	Danny	Myall		\N	\N	\N		2025-05-03 20:50:49.699	2025-05-03 20:50:49.699	\N
c0c3df0e-d6fe-4c89-9778-33cd51a6bcd2	Darell	hA		\N	\N	\N		2025-05-03 20:50:49.699	2025-05-03 20:50:49.699	\N
aac66c63-8696-4d4a-b5b4-3e2b1cef40c1	Darell	Hassell		\N	\N	1943-11-24 00:00:00		2025-05-03 20:50:49.699	2025-05-03 20:50:49.699	\N
14886714-72d0-4814-8b58-e5aa5c7b555a	Dariel Iram	Perez Estrada		baco3@hotmail.com	\N	1998-01-02 00:00:00		2025-05-03 20:50:49.7	2025-05-03 20:50:49.7	\N
c00a5dff-5405-4b09-8bd6-5a57b7ba7abc	Darinka	Funes Briseño		darinca1988@hotmail.com	\N	1986-12-05 00:00:00		2025-05-03 20:50:49.7	2025-05-03 20:50:49.7	\N
fa5dba8f-f91d-4cf5-8dcc-7d427714fe2d	DALIA PAULINA	ANGUIANO SANDOVAL		paulina.anguiano2001@gmail.com	+522292074554	\N		2025-05-03 20:50:49.7	2025-05-03 20:50:49.7	\N
7d1d27c9-c921-491b-8325-6541e062a95e	Darlene Faith Heide	Loewen		\N	\N	\N		2025-05-03 20:50:49.701	2025-05-03 20:50:49.701	\N
8c23f2e2-ebe0-4a25-b58f-c0f5c0a3efa3	Darrel	Aasen Wayne		\N	\N	1942-11-24 00:00:00		2025-05-03 20:50:49.701	2025-05-03 20:50:49.701	\N
9850b62a-d250-497d-b15b-4e73843a1006	Dave	Vibert		\N	\N	\N		2025-05-03 20:50:49.701	2025-05-03 20:50:49.701	\N
9076954f-7adb-4e5f-a3e2-130d55329ee0	David	Apale Mancilla		\N	3223313748	1987-01-15 00:00:00		2025-05-03 20:50:49.702	2025-05-03 20:50:49.702	\N
e9a1d107-ec67-446f-9f47-651ed0fa0275	David	Bocanegra Villagran		\N	\N	\N		2025-05-03 20:50:49.702	2025-05-03 20:50:49.702	\N
85590c3b-c61f-4537-a81d-249b94c8e7ce	David	Conrriquez Godinez		lcp.davidconrriquez@gmail.com	3221030776	1990-11-16 00:00:00		2025-05-03 20:50:49.702	2025-05-03 20:50:49.702	\N
f4b17a21-6c9e-4acf-a406-96ca13a59ca1	David	Cuevas Garcia		\N	\N	1954-11-07 00:00:00		2025-05-03 20:50:49.703	2025-05-03 20:50:49.703	\N
a926eedf-1dcf-4dbe-9f10-cc95f0e61cdc	David	Flores Rodriguez		\N	\N	\N		2025-05-03 20:50:49.703	2025-05-03 20:50:49.703	\N
af62c0f2-993b-430e-bb90-d611088e2432	Damian	Segura Hernández		\N	5539879305	\N		2025-05-03 20:50:49.703	2025-05-03 20:50:49.703	\N
e0bfaa41-30a5-4c58-9878-1aaea2979f18	David	Gonzalez Auzan		david.auza@sistemasdigitalespvr.com	\N	\N		2025-05-03 20:50:49.704	2025-05-03 20:50:49.704	\N
95c53239-bd0a-475b-b9ff-4cf27a9815d8	David	Gravel		dgravel4@yahoo.com	\N	1945-09-14 00:00:00		2025-05-03 20:50:49.704	2025-05-03 20:50:49.704	\N
f9f7714f-3c77-4789-a12f-c0751ac25acf	David	Gutierrez Acebedo		david17071@hotmmail.com	3221784109	1985-07-17 00:00:00		2025-05-03 20:50:49.704	2025-05-03 20:50:49.704	\N
35a5d298-b616-40d4-9b4c-a0d795e4d1b8	David	Haney		haney.dave27@gmail.com	\N	1975-12-25 00:00:00		2025-05-03 20:50:49.705	2025-05-03 20:50:49.705	\N
aa86499e-54f3-40c5-813d-96cf8c098b7f	David	Hoffman		\N	\N	1971-09-06 00:00:00		2025-05-03 20:50:49.705	2025-05-03 20:50:49.705	\N
e7ec2043-896d-4c01-9919-582a458ca863	David	Jiménez Gardiel		dgj1708@hotmail.com	\N	1988-08-17 00:00:00		2025-05-03 20:50:49.705	2025-05-03 20:50:49.705	\N
37ebb284-378b-44e8-86a4-25620ff6ef80	David	Kopelman		kopelmandavid@gmail.com	\N	1983-11-12 00:00:00		2025-05-03 20:50:49.705	2025-05-03 20:50:49.705	\N
d18ca3b7-5cf7-4537-bb7a-da091f680909	David	Leon Enrique		davidleonpersonaltrainer@live.com.mx	\N	1971-01-13 00:00:00		2025-05-03 20:50:49.706	2025-05-03 20:50:49.706	\N
d36ca9df-cc78-4329-9861-a14212442632	David	Meza Silvera		\N	\N	1996-09-12 00:00:00		2025-05-03 20:50:49.706	2025-05-03 20:50:49.706	\N
3ddbf7a9-bfde-4026-9d00-f186d939cc3d	David	Placencia Barreto		\N	\N	1968-12-22 00:00:00		2025-05-03 20:50:49.706	2025-05-03 20:50:49.706	\N
9e04a940-4b6f-4402-a0b2-e633e5650d8b	Danelia	Camacho Barragan		\N	3222124655	1968-02-07 00:00:00		2025-05-03 20:50:49.707	2025-05-03 20:50:49.707	\N
9f65b29e-21a6-42ec-a52d-c15149d504e6	DAVID	REYNA  PANCHO		\N	\N	\N		2025-05-03 20:50:49.707	2025-05-03 20:50:49.707	\N
313b63cc-aa4f-4691-83c0-e68171e6d138	David	Reyna Alvarado		\N	\N	\N		2025-05-03 20:50:49.707	2025-05-03 20:50:49.707	\N
dcb0033b-1b5a-408f-ae5e-5bb3f2126dab	David	Ruíz Morin		\N	\N	\N		2025-05-03 20:50:49.708	2025-05-03 20:50:49.708	\N
9d661c8f-b8a8-4e21-a231-8919ea8ccef5	Dana	Andrew		\N	3221093411	\N		2025-05-03 20:50:49.708	2025-05-03 20:50:49.708	\N
c1edf76d-491b-4c73-ba08-ca3005641578	David	Silvera Menedez		lamaquinaria_libre14@hotmail.com	\N	1996-09-12 00:00:00		2025-05-03 20:50:49.708	2025-05-03 20:50:49.708	\N
cc54eb02-95ef-4820-880f-120201526227	David	Triggs		\N	\N	\N		2025-05-03 20:50:49.709	2025-05-03 20:50:49.709	\N
894adc49-2f75-44a2-b469-765bf6c5be0e	David	Zepeda Jimenez		\N	\N	\N		2025-05-03 20:50:49.709	2025-05-03 20:50:49.709	\N
746b7b34-0586-4fa9-a69a-1271cf0e6492	David Alberto	Arriola López		\N	\N	2010-03-07 00:00:00		2025-05-03 20:50:49.709	2025-05-03 20:50:49.709	\N
4c1ce18e-38db-4e2f-aee6-6e9197109e31	David Daniel	Wharton Camacho		davidwhartonc@gmailcom	3222124655	1995-09-20 00:00:00		2025-05-03 20:50:49.71	2025-05-03 20:50:49.71	\N
1276615a-d64e-4947-b79a-6c6512737a59	David Heriberto	Hernandez Michel		\N	\N	1988-04-06 00:00:00		2025-05-03 20:50:49.71	2025-05-03 20:50:49.71	\N
b0d353ef-12eb-4bf2-bb12-497e34688cde	David Santiago	Vazquez Arellano		mary.design37@gmail.com	\N	2007-07-21 00:00:00		2025-05-03 20:50:49.71	2025-05-03 20:50:49.71	\N
3bdd5fbe-1e40-4bc7-b73b-0d74b7bc681f	Dayan	Chavarin		\N	3222934004	1992-12-16 00:00:00		2025-05-03 20:50:49.71	2025-05-03 20:50:49.71	\N
31fe0e2d-9238-4aa5-bb1c-3172bd3babdf	Dayana Carlonina	Rodriguez Pelaez		\N	\N	\N		2025-05-03 20:50:49.711	2025-05-03 20:50:49.711	\N
a0b4bc23-6d04-44ce-a774-19bfc816a52a	Dayana Karely	Alcala Grijalba		\N	\N	\N		2025-05-03 20:50:49.711	2025-05-03 20:50:49.711	\N
86016fa0-bc4c-4085-8dab-dfba7eb84116	Dayana Karely	Alcala Grijalva		\N	\N	2005-12-09 00:00:00		2025-05-03 20:50:49.711	2025-05-03 20:50:49.711	\N
718708a4-0547-483f-8f54-ed2eab51c9d7	Dayana Nazareth	Martinez Verá		\N	\N	2011-01-21 00:00:00		2025-05-03 20:50:49.712	2025-05-03 20:50:49.712	\N
889cfe04-7b9e-4bcb-82eb-df4d9a3377ec	Dayana Yasuri	Aguilar Mendoza		\N	\N	2006-07-15 00:00:00		2025-05-03 20:50:49.712	2025-05-03 20:50:49.712	\N
ccb34e47-b9a1-4ef6-82a8-62d749fa593f	Danailcho	Dimov		fun42mexico@gmail.com	+523221837772	\N		2025-05-03 20:50:49.712	2025-05-03 20:50:49.712	\N
e555d106-f230-4384-a466-dc0c01330397	de la Garza Becerra	Silvia		\N	\N	2005-12-03 00:00:00		2025-05-03 20:50:49.713	2025-05-03 20:50:49.713	\N
473ceba2-8ce6-4aad-ae26-7fef94cf45ce	Dean	Casterline		\N	+17168609816	\N		2025-05-03 20:50:49.713	2025-05-03 20:50:49.713	\N
212a75e9-cb5b-48a1-a55f-97b55a365210	Daniel	Palafox Espinosa		\N	3221117073	\N		2025-05-03 20:50:49.713	2025-05-03 20:50:49.713	\N
03e8c649-8c58-4e81-811c-cc40427bda12	Deborah	McCauley J		echo725@msn.com	\N	1959-05-14 00:00:00		2025-05-03 20:50:49.714	2025-05-03 20:50:49.714	\N
ac6bccbb-c4f3-4fbf-a30d-7c1e0794a6e6	Daniel	Flores Ruano		\N	3334849229	\N		2025-05-03 20:50:49.714	2025-05-03 20:50:49.714	\N
2bfe4095-c99d-4cff-96df-22b11bda843d	Deevinda	Tosten		\N	\N	\N		2025-05-03 20:50:49.714	2025-05-03 20:50:49.714	\N
e2b6956f-1d81-494d-a731-8f8522e8f861	Deida	Jimenez Deniz		\N	\N	1966-03-28 00:00:00		2025-05-03 20:50:49.715	2025-05-03 20:50:49.715	\N
641966cf-fb10-45d2-be15-1e068e7734d9	Deisy	Fletes Camacho		deisy_efc@hotmail.com	\N	1989-03-31 00:00:00		2025-05-03 20:50:49.715	2025-05-03 20:50:49.715	\N
23882abf-9aab-46cb-aab9-9bce347c4e50	Delia	Cortez Muñoz		\N	\N	1949-08-27 00:00:00		2025-05-03 20:50:49.715	2025-05-03 20:50:49.715	\N
3aa029ec-76ec-4a36-8c3b-ac772769200e	Delia	Lujano Rivera		\N	\N	\N		2025-05-03 20:50:49.716	2025-05-03 20:50:49.716	\N
b8f15b62-ecec-404c-a74d-7bd50f41b379	Denia Elizabeth	Miranda Guerrero		\N	\N	2008-08-22 00:00:00		2025-05-03 20:50:49.716	2025-05-03 20:50:49.716	\N
a73023ce-183d-4f08-804a-6032ff889d8b	Denilson Fabian	Orozco Garibay		\N	\N	1998-07-02 00:00:00		2025-05-03 20:50:49.716	2025-05-03 20:50:49.716	\N
cf7cf5ce-dc37-491e-a5d4-ed215114a288	Denis	Bedard		bedard_denis@outloock.fr	\N	1954-02-08 00:00:00		2025-05-03 20:50:49.717	2025-05-03 20:50:49.717	\N
01754884-34dc-40c2-9e42-7424853c1824	Denis	Brouillard		\N	\N	\N		2025-05-03 20:50:49.717	2025-05-03 20:50:49.717	\N
618f27a2-4d33-4a49-970d-bdb16491aef5	Denis	Broullard		\N	\N	1952-11-02 00:00:00		2025-05-03 20:50:49.717	2025-05-03 20:50:49.717	\N
51fb4b01-cd76-4b86-9c0c-7c539373201b	Denis	Towpin		denitowpin50@hotmail.com	\N	1941-07-19 00:00:00		2025-05-03 20:50:49.718	2025-05-03 20:50:49.718	\N
85775b9a-b0a0-4b66-913a-18dc91576ab1	Denise	Doran		\N	\N	2009-12-18 00:00:00		2025-05-03 20:50:49.718	2025-05-03 20:50:49.718	\N
e0184c66-8aac-4854-8097-047c807cc3e4	Denise	Rosenfeld		rosenfelddenise@hotmail.com	\N	1964-06-03 00:00:00		2025-05-03 20:50:49.718	2025-05-03 20:50:49.718	\N
50e385a5-bafa-4a79-821b-aea9e008416e	Denise	Rosse		\N	\N	\N		2025-05-03 20:50:49.719	2025-05-03 20:50:49.719	\N
b65c2cc7-ccdd-4925-8494-2100f968e4bc	Daniel	Vuceciv		\N	3221826280	\N		2025-05-03 20:50:49.719	2025-05-03 20:50:49.719	\N
89f0de67-2671-4ce3-906c-6673781160dd	Denisse	Gonzalez		\N	\N	\N		2025-05-03 20:50:49.719	2025-05-03 20:50:49.719	\N
d21dfcf2-5d7b-47ca-8dd7-10e56841ed1c	Denisse	Gonzalez Hernandez		david.auza@sistemasdigitalespvr.com	\N	2007-05-09 00:00:00		2025-05-03 20:50:49.72	2025-05-03 20:50:49.72	\N
7364aca7-8852-4053-accf-7724e8c153f7	Denisse	Gonzalez Hernández		seida@sistemasdigitalespvr.com	\N	2007-05-09 00:00:00		2025-05-03 20:50:49.72	2025-05-03 20:50:49.72	\N
178d1ea6-3730-4221-b0cb-dccaee19f2cd	Denisse	Loyo Aguirre		\N	\N	\N		2025-05-03 20:50:49.72	2025-05-03 20:50:49.72	\N
7b0e5d15-bbfc-4c28-b11f-097c7b84b84d	Dennis	Kolish		dgkolish@accesscomm.ca	\N	1959-09-24 00:00:00		2025-05-03 20:50:49.721	2025-05-03 20:50:49.721	\N
8d0c0c1f-cdd7-4249-a2b5-d4150abb3ade	Dennis	Varga Hernandez		\N	\N	1990-09-20 00:00:00		2025-05-03 20:50:49.721	2025-05-03 20:50:49.721	\N
d8f90efa-ef6e-444a-9797-4835d84ead0f	Daniela Alejandra	Andalon Calleros		dandalon602@gmail.com	+523221580468	\N		2025-05-03 20:50:49.721	2025-05-03 20:50:49.721	\N
83358696-bc82-43c3-a2f2-324486782b80	Devi	Henderson		\N	\N	\N		2025-05-03 20:50:49.722	2025-05-03 20:50:49.722	\N
a5da31bf-e390-4d7d-bda5-d87abde73b5d	Devora	RICHMAN		\N	\N	\N		2025-05-03 20:50:49.722	2025-05-03 20:50:49.722	\N
c4f933df-4f2e-4961-adcf-0348e5ab10db	Devorah	Bravo Velazquez		\N	\N	\N		2025-05-03 20:50:49.722	2025-05-03 20:50:49.722	\N
7eda1cfd-bb18-41ba-a693-f69a3a641ec4	Deyda	Jimenez Deniz		\N	\N	\N		2025-05-03 20:50:49.722	2025-05-03 20:50:49.722	\N
cd8a13c2-7361-4c47-954e-6881083f7561	Denisse	Gonzáles Hernández		\N	3221723723	\N		2025-05-03 20:50:49.723	2025-05-03 20:50:49.723	\N
5c785aa3-4d75-4bda-9bb5-f077b257ec14	Diana	BLENER		\N	\N	\N		2025-05-03 20:50:49.723	2025-05-03 20:50:49.723	\N
e7a6dca6-0fc3-4a9a-85ac-24747d71e30b	Diana	Bracamontes Maldonado		\N	\N	2009-01-07 00:00:00		2025-05-03 20:50:49.723	2025-05-03 20:50:49.723	\N
f36ebae2-29a1-4dbf-9277-e6b8d6681ae3	Diana	Brenner		Deahnakoach3601@hotmail.com	\N	1960-06-24 00:00:00		2025-05-03 20:50:49.724	2025-05-03 20:50:49.724	\N
3fc8e6d2-7e8b-45bf-bd15-4642ecbb2311	Diana	Delacerna		\N	\N	2009-12-14 00:00:00		2025-05-03 20:50:49.724	2025-05-03 20:50:49.724	\N
fb2d69b5-51dc-4ef8-9d66-9beb6bce2cac	Crsitianeh	Hernandex Aguirre		\N	3333572107	\N		2025-05-03 20:50:49.724	2025-05-03 20:50:49.724	\N
5a81dccb-a7c2-49f2-9bef-ee867a1ed047	Diana	García Becerra		comprasrmantto@gmail.com	\N	1988-05-03 00:00:00		2025-05-03 20:50:49.725	2025-05-03 20:50:49.725	\N
05400c5e-ae23-4ae1-baea-7ec8ffecadcf	Diana	Goetz		\N	\N	1982-04-29 00:00:00		2025-05-03 20:50:49.725	2025-05-03 20:50:49.725	\N
5d565da2-2eca-485c-b427-b234f51609a4	Diana	Guitierrez Munch		\N	\N	1953-04-14 00:00:00		2025-05-03 20:50:49.725	2025-05-03 20:50:49.725	\N
e86d1754-2489-4f00-8d58-54fcdf97cf48	Diana	Herrera Hernández		\N	\N	1987-07-23 00:00:00		2025-05-03 20:50:49.725	2025-05-03 20:50:49.725	\N
3b0670ce-1ae0-4b1c-829a-e88a779d2473	Danna Valeria	Aguirre Contreras		\N	3338201512	\N		2025-05-03 20:50:49.726	2025-05-03 20:50:49.726	\N
19d14ed0-1eac-41ad-94ad-8600e5ccae99	Diana	Sheen		\N	\N	1949-07-22 00:00:00		2025-05-03 20:50:49.726	2025-05-03 20:50:49.726	\N
be2daca4-29ba-47c2-b3e2-f558810be063	Diana	Shenn		\N	\N	\N		2025-05-03 20:50:49.726	2025-05-03 20:50:49.726	\N
fefa517c-6ff9-437d-ac0a-6a93b4d93295	Diana Alejandra	Cardenas Tirado		\N	\N	1994-01-10 00:00:00		2025-05-03 20:50:49.727	2025-05-03 20:50:49.727	\N
b856d82c-cf7a-47ae-a3ca-9b7a20c6f395	Diana Elena	Aguilar Reyes		\N	\N	1984-07-24 00:00:00		2025-05-03 20:50:49.727	2025-05-03 20:50:49.727	\N
c671c4a8-c8f4-47eb-9693-e0f76e7275d4	Devena	Hubbard		\N	+17206147632	\N		2025-05-03 20:50:49.727	2025-05-03 20:50:49.727	\N
81dcdb02-516f-498f-8d22-7bea14aa5a9b	Diana Lizeth	Orozco Aguilera		\N	\N	2005-03-23 00:00:00		2025-05-03 20:50:49.728	2025-05-03 20:50:49.728	\N
5a65493d-cf6b-4089-ad84-13db225e9c3c	Danielle	Crofort		\N	+14697553153	\N		2025-05-03 20:50:49.728	2025-05-03 20:50:49.728	\N
b031431b-a007-4708-81fc-f4def051ab46	Diana Paola	Lopez Glez.		\N	\N	2008-03-12 00:00:00		2025-05-03 20:50:49.728	2025-05-03 20:50:49.728	\N
4646d1cc-49be-4029-bf26-b0b7953bcba4	David	Flores Valdobinos		\N	3338007485	\N		2025-05-03 20:50:49.728	2025-05-03 20:50:49.728	\N
b5dda847-b90d-445f-be10-d5d6a65b76e5	Diana Valentina	Puja Robles		\N	\N	\N		2025-05-03 20:50:49.729	2025-05-03 20:50:49.729	\N
c4b8ff8a-79d7-4f89-9d81-b3859070b2c3	Diane	Aubry		diane_aubry@videotron.ca	\N	1954-07-21 00:00:00		2025-05-03 20:50:49.729	2025-05-03 20:50:49.729	\N
bb5ffa5d-12ca-4874-a438-430770b481b8	Diane	Bouchard		dianebouchard@gmail.com	\N	1950-03-20 00:00:00		2025-05-03 20:50:49.729	2025-05-03 20:50:49.729	\N
f6ffaeb9-b0d4-451d-a6d8-cdf808cfc66e	Diane	Moisan		dianemoisan146@gmail.com	\N	1949-10-08 00:00:00		2025-05-03 20:50:49.73	2025-05-03 20:50:49.73	\N
5cac0340-93e7-489e-9a1d-38ba26d39a47	Dianne	Gagnon		rnmartel@hotmail.com	\N	1959-10-09 00:00:00		2025-05-03 20:50:49.73	2025-05-03 20:50:49.73	\N
b1711568-803d-45db-a2d1-99aca9c534aa	Diego	Franco Jiménez		diegofrancojimenez1@gmail.com	3318486900	1983-11-04 00:00:00		2025-05-03 20:50:49.731	2025-05-03 20:50:49.731	\N
d4b843f8-64a5-475e-8ee7-264daea87a61	Diego	Franco Jimenez		\N	\N	1983-11-04 00:00:00		2025-05-03 20:50:49.731	2025-05-03 20:50:49.731	\N
fba6381b-7588-40e8-a183-9ece19ef6333	Diego	Gomez Silva		\N	\N	\N		2025-05-03 20:50:49.731	2025-05-03 20:50:49.731	\N
55b76c86-2681-4c0e-979a-3dbfa9eaced9	Diego	Guillermo Flores Castro		\N	3221786063	\N		2025-05-03 20:50:49.731	2025-05-03 20:50:49.731	\N
37bd26ee-671c-440b-80c2-a20cc2c40762	diego	jimenez		\N	\N	2006-05-02 00:00:00		2025-05-03 20:50:49.732	2025-05-03 20:50:49.732	\N
14cc7e17-66fa-4ac9-8c57-52da28455327	Diego	Juarez Garcia		\N	\N	1983-09-14 00:00:00		2025-05-03 20:50:49.732	2025-05-03 20:50:49.732	\N
af441d51-9a75-4e57-ad89-b7b8b3f79759	Diego	Orueta Macias		diegooruetamacias@gmail.com	3221685676	2005-11-11 00:00:00		2025-05-03 20:50:49.732	2025-05-03 20:50:49.732	\N
6b426a37-e64e-4b64-9733-6bc88c9129b5	Diego	Ramos		\N	\N	\N		2025-05-03 20:50:49.733	2025-05-03 20:50:49.733	\N
1c687609-a745-4fe2-a174-d85209d562f6	Dario	Ramirez		darioramirezc36@gmail.com	+523222192745	\N		2025-05-03 20:50:49.733	2025-05-03 20:50:49.733	\N
bc06bd3e-48ba-4c31-94e4-a26c19b1d402	David	Sanchez		alphawolf@poquitoloco.com	3223781718	\N		2025-05-03 20:50:49.733	2025-05-03 20:50:49.733	\N
4053392f-2d9a-4df1-b1d0-534fed6a3011	Diego Alejandro	Ramos Camberos		\N	\N	1996-11-21 00:00:00		2025-05-03 20:50:49.734	2025-05-03 20:50:49.734	\N
e76bbe99-947a-4045-9636-0d7f6ac395e4	Diego Armando	Tovar Arevalo		etnie_fox@hotmail.com	\N	1987-02-09 00:00:00		2025-05-03 20:50:49.734	2025-05-03 20:50:49.734	\N
efffca05-9e90-4451-aa17-249f7387179b	Diego Axel	Radilla Gómez		\N	\N	2000-02-14 00:00:00		2025-05-03 20:50:49.734	2025-05-03 20:50:49.734	\N
8557150e-eda6-4270-be4e-98c77f42cc0a	David	Prieto		\N	2291287289	\N		2025-05-03 20:50:49.734	2025-05-03 20:50:49.734	\N
6dff2204-a8fe-47ba-99a2-75e40ce18917	Daniela	Andalon Calleros		\N	3221580468	\N		2025-05-03 20:50:49.735	2025-05-03 20:50:49.735	\N
0bd001a9-7eb0-479d-9cd6-4514a77a8243	Diego Nicolas	Rosas Valenzuela		andypekebil@live.com	\N	2008-06-10 00:00:00		2025-05-03 20:50:49.735	2025-05-03 20:50:49.735	\N
4efb0e92-c5f9-43d6-82c3-1d3cd16b1fd7	Diego Sebastian	Lopez Mora		sebastianmora165@gmail.com	\N	1983-02-23 00:00:00		2025-05-03 20:50:49.735	2025-05-03 20:50:49.735	\N
73c21162-3b36-4ccb-89b9-faefe2b66df3	Dilene	Rosas Gonzáles		adytelcel23@gmail.com	\N	1991-12-15 00:00:00		2025-05-03 20:50:49.736	2025-05-03 20:50:49.736	\N
696e1266-efbd-494d-bf0a-561a3e9f5f9c	Dimitri	Kruchenko		\N	\N	\N		2025-05-03 20:50:49.736	2025-05-03 20:50:49.736	\N
53d76122-7e4c-4ed1-9e18-900363e137ef	Dimitri	Krushenco		\N	\N	\N		2025-05-03 20:50:49.736	2025-05-03 20:50:49.736	\N
26f13468-a916-49a0-8844-b45f694f1fb0	Dina	Btener		\N	\N	\N		2025-05-03 20:50:49.737	2025-05-03 20:50:49.737	\N
42293443-57aa-4113-a22c-6a535674d000	Dinna	Valente		office22direct@yahoo.ca	\N	1961-06-20 00:00:00		2025-05-03 20:50:49.737	2025-05-03 20:50:49.737	\N
d1dfcce1-b4aa-40fc-8550-ebadbe9b14b8	Daniela	Luna Quintero		\N	+523891051164	\N		2025-05-03 20:50:49.737	2025-05-03 20:50:49.737	\N
39b0b90e-c630-4d28-93ea-b57a0feb3b7c	Dolores	Acebes Areas		\N	\N	1963-05-24 00:00:00		2025-05-03 20:50:49.738	2025-05-03 20:50:49.738	\N
7cecb2fc-fda5-45e9-b3de-3b2e9d2de55d	Diana	Arreola		margievaldes@hotmail.com	+523321816662	\N		2025-05-03 20:50:49.738	2025-05-03 20:50:49.738	\N
5ef7c0d3-211c-4b19-a063-6297a09c4fdd	Diana	Duarte Dorado		\N	\N	1975-02-25 00:00:00		2025-05-03 20:50:49.738	2025-05-03 20:50:49.738	\N
5b1cafa6-436a-4f7e-ab0b-c4b4c754e4a7	Dominick	Gonzales Aguilar		\N	3222168592	\N		2025-05-03 20:50:49.738	2025-05-03 20:50:49.738	\N
3145c6c9-96af-4a8d-a221-75135ff671f1	Dominique	Foulon		\N	\N	2010-07-12 00:00:00		2025-05-03 20:50:49.739	2025-05-03 20:50:49.739	\N
3da8d2f0-3c20-4305-a66d-122deeb22ca6	Domitila	Peña Esparza		\N	3292960351	1949-05-12 00:00:00		2025-05-03 20:50:49.739	2025-05-03 20:50:49.739	\N
299204af-7aa6-4c27-81cd-cbf9517f25ff	Donna	Fiala		\N	+12085390414	1997-02-08 00:00:00		2025-05-03 20:50:49.74	2025-05-03 20:50:49.74	\N
9f628cab-7e95-4198-a035-2869841c239c	Donna Marya	Fiala		\N	\N	\N		2025-05-03 20:50:49.74	2025-05-03 20:50:49.74	\N
fd8fcb45-6074-4730-bc9d-0ae65e379a25	Dayra Elizbeth	Castillo Bernal		\N	3221369005	\N		2025-05-03 20:50:49.74	2025-05-03 20:50:49.74	\N
17549b2a-7015-4546-b7f2-99414b750047	Dean	Casterline		deanojc55@gmail.com	+17168607839	\N		2025-05-03 20:50:49.74	2025-05-03 20:50:49.74	\N
446f0b80-362d-4f9c-93ad-1bf15f4ac4fa	Dora	Perez Murillo		\N	\N	1977-04-06 00:00:00		2025-05-03 20:50:49.741	2025-05-03 20:50:49.741	\N
f998b881-e124-454f-b1ba-ab9a6dc3e24e	Dora Alicia	Guardado		\N	\N	2011-02-23 00:00:00		2025-05-03 20:50:49.741	2025-05-03 20:50:49.741	\N
c528c275-1703-40fc-a4d0-097b9c96e40b	Dora Elva	Ortiz Peña		\N	\N	2011-01-13 00:00:00		2025-05-03 20:50:49.741	2025-05-03 20:50:49.741	\N
a123d6e0-6760-44b8-9978-1deb2d804af9	Doris	xx		\N	\N	2008-09-04 00:00:00		2025-05-03 20:50:49.742	2025-05-03 20:50:49.742	\N
98df0dd9-b92c-4b30-ad9b-0bbaebd376ec	Douglas Albert	Sherman		\N	\N	2008-07-18 00:00:00		2025-05-03 20:50:49.742	2025-05-03 20:50:49.742	\N
28f914c7-2601-467d-9604-d9bf92bc21cf	Dowd	Calhoun		\N	\N	\N		2025-05-03 20:50:49.742	2025-05-03 20:50:49.742	\N
9f458779-e1fe-4e4a-97e6-dd04b8eb0dcb	Dr. Roberto	Castillo (IMPLANTES)		\N	\N	2007-04-17 00:00:00		2025-05-03 20:50:49.743	2025-05-03 20:50:49.743	\N
6d99f0a3-138e-47a9-a085-fd6b2362a1b7	Dra.Elva	Mendez		\N	\N	1954-05-05 00:00:00		2025-05-03 20:50:49.743	2025-05-03 20:50:49.743	\N
11ebcb26-b94f-4ac8-bb2a-ec6dcecfda4b	Dulce	Hernàndez Sànchez		\N	\N	1977-04-10 00:00:00		2025-05-03 20:50:49.743	2025-05-03 20:50:49.743	\N
4fc1ae4f-67a5-43eb-aaf4-3fcc096b51a6	Dulce	Waterman		\N	\N	2009-02-05 00:00:00		2025-05-03 20:50:49.744	2025-05-03 20:50:49.744	\N
86099757-de05-44e9-a7c8-2aa3dd806414	Dulce fabiola	Sanchez Rangel		\N	\N	1984-02-04 00:00:00		2025-05-03 20:50:49.744	2025-05-03 20:50:49.744	\N
0f1f404f-00e5-4075-a485-cb486b35daa8	Diana	Rubio Arciga		\N	3228891922	\N		2025-05-03 20:50:49.744	2025-05-03 20:50:49.744	\N
aea338c2-d531-452a-ad21-ea16029065ee	Dulce Maria	Ayala García		ayala.dulce@hotmail.com	\N	1974-04-08 00:00:00		2025-05-03 20:50:49.745	2025-05-03 20:50:49.745	\N
87c6572a-de75-4a53-864c-83e7e19f9260	Dulce Maria	Flores Rodríguez		dulce25fr@hotmail.com	\N	2000-06-25 00:00:00		2025-05-03 20:50:49.745	2025-05-03 20:50:49.745	\N
9f37453b-e2c8-421b-9e2e-50ed0c639fa0	Dulce María	Heredia García		dulce.heredia.garcia@gmail.com	\N	1987-10-27 00:00:00		2025-05-03 20:50:49.745	2025-05-03 20:50:49.745	\N
6b9070ef-ccc7-4633-8c5c-bdd7ab4155b9	Dulce Maria	Rangel Baños		dulmaraba@gmail.com	\N	1980-01-30 00:00:00		2025-05-03 20:50:49.746	2025-05-03 20:50:49.746	\N
2396b712-4a5a-428c-8704-2bfa3649daf6	Dwayne	Meyer		meyerda@shaw.ca	\N	1957-08-27 00:00:00		2025-05-03 20:50:49.746	2025-05-03 20:50:49.746	\N
110e24f4-b7a8-4b2e-859e-7c041f6868da	Eda	Sciutto		\N	\N	\N		2025-05-03 20:50:49.746	2025-05-03 20:50:49.746	\N
4fa4bdb5-fb30-4bf6-9064-83823875db1b	Karen Anel	Torres Medrano		\N	\N	1993-02-27 00:00:00		2025-05-03 20:50:50.565	2025-05-03 20:50:50.565	\N
d33d6622-a8fa-4287-87f7-54a5027b71c0	Diego Frncisco	Rico Patiño		diego_rico90@hotmail.com	+525610021475	1990-06-03 00:00:00		2025-05-03 20:50:49.747	2025-05-03 20:50:49.747	\N
e4ccda53-e86c-45e1-8aa1-80a1627494e2	Edgar	Bender Guzman		ebenderg@hotmail.com	\N	1955-01-09 00:00:00		2025-05-03 20:50:49.747	2025-05-03 20:50:49.747	\N
59a8e5a8-a8e4-4553-8a2b-f66d394cf321	Edgar	Delgadillo		\N	\N	2011-06-15 00:00:00		2025-05-03 20:50:49.747	2025-05-03 20:50:49.747	\N
fe6d2dd1-6b3d-40a3-99c0-ca2e2ec856ea	Edgar	Delgado		\N	\N	\N		2025-05-03 20:50:49.747	2025-05-03 20:50:49.747	\N
924149c5-2642-4242-abcb-f9156fa1fa3e	Edgar	Medina Alanis		\N	\N	1987-02-24 00:00:00		2025-05-03 20:50:49.748	2025-05-03 20:50:49.748	\N
f95decc6-27db-425a-a45a-74ee58a80239	Edgar	Ramirez Hernandez		edgar51929@hotmail.com	\N	1995-01-17 00:00:00		2025-05-03 20:50:49.748	2025-05-03 20:50:49.748	\N
649a2a36-4d6c-40ca-b9aa-cf02244dd8e3	Edgar Antono	Morales Marreto		\N	\N	\N		2025-05-03 20:50:49.748	2025-05-03 20:50:49.748	\N
694f170c-ef7b-42b7-9220-62a9c4a2445a	Edgar Eduardo	Contreras Barajas		\N	\N	1988-01-28 00:00:00		2025-05-03 20:50:49.749	2025-05-03 20:50:49.749	\N
cbff826b-055a-43a4-93fb-45a81624a842	Edgar Emiliano	Badillo Espinosa		\N	015929220530	1994-01-19 00:00:00		2025-05-03 20:50:49.749	2025-05-03 20:50:49.749	\N
4e5d87f9-f2f5-4504-993b-9239ecd88c4e	Edgar Isac	Aguayo Padilla		\N	\N	2006-03-18 00:00:00		2025-05-03 20:50:49.749	2025-05-03 20:50:49.749	\N
92924162-953a-4753-a43b-298a2d090b07	Edgar Manuel	Radilla Gómez		\N	\N	2001-09-18 00:00:00		2025-05-03 20:50:49.75	2025-05-03 20:50:49.75	\N
90970edb-7075-48ba-b155-d3a517a0abc5	Edgar Santos	López Olmos		\N	\N	2004-01-31 00:00:00		2025-05-03 20:50:49.75	2025-05-03 20:50:49.75	\N
5db28025-eb1d-40eb-919d-743727ba0804	Edgardo	Orta		\N	\N	1946-06-08 00:00:00		2025-05-03 20:50:49.75	2025-05-03 20:50:49.75	\N
ad77052c-a054-4a60-9b7f-e9df69114e97	Edgardo	Orta Calles		\N	\N	1946-07-08 00:00:00		2025-05-03 20:50:49.751	2025-05-03 20:50:49.751	\N
67afe5b9-9983-4ca0-905b-f3d09ceec640	Edith	Aguilar López		\N	3221391133	1978-12-22 00:00:00		2025-05-03 20:50:49.751	2025-05-03 20:50:49.751	\N
744fd4ee-6fc1-4e7f-94b5-65113fbdcb75	Edith	Aguilar Moreno		\N	3221501622	1998-12-19 00:00:00		2025-05-03 20:50:49.751	2025-05-03 20:50:49.751	\N
6d9776a6-b063-4b46-84fa-9b4cb4ffbc2d	Edgar	Amard Magaña		\N	3223226625	\N		2025-05-03 20:50:49.752	2025-05-03 20:50:49.752	\N
058d88e0-06d3-42b3-b955-41f16422f2f6	Edith	Monroy Gonzalez		edith_m0625@hotmail.com	\N	\N		2025-05-03 20:50:49.752	2025-05-03 20:50:49.752	\N
6df9d254-b731-4a53-a79e-fad689f11ba7	Edith	Reyes Gonzalez		\N	\N	\N		2025-05-03 20:50:49.753	2025-05-03 20:50:49.753	\N
d662c375-2cb1-46aa-8b94-0b9a664421c5	Edmundo	Ortega Infante		\N	\N	2004-12-23 00:00:00		2025-05-03 20:50:49.753	2025-05-03 20:50:49.753	\N
262e5682-9990-4c7e-846d-6b790237c854	Edna	Cardoso		ena1411@yahoo.com.mx	\N	1978-12-06 00:00:00		2025-05-03 20:50:49.753	2025-05-03 20:50:49.753	\N
25c4b133-150e-4768-847e-a603aca72dcb	Edna marina	Arana Romero		maredna07@hotmail.com	\N	1981-07-18 00:00:00		2025-05-03 20:50:49.754	2025-05-03 20:50:49.754	\N
c52b8070-1d06-416d-83f3-f44653327fd5	Eduardo	Ajuria Rubio		eduardo.ajuria.@live.com.mx	3222935299	1990-05-21 00:00:00		2025-05-03 20:50:49.754	2025-05-03 20:50:49.754	\N
b34c1347-0781-41aa-b8f0-f29e528e04d4	Diana Gabriela	Cervantes Sanches		\N	3222969848	\N		2025-05-03 20:50:49.754	2025-05-03 20:50:49.754	\N
4c1332c6-7e7d-4f36-9e87-d667dd51b7b0	Eduardo	Bobadilla Sanchez		\N	\N	\N		2025-05-03 20:50:49.755	2025-05-03 20:50:49.755	\N
a42d8769-2473-40ad-9c72-c99a26473d89	Diana Margarita	Arreola Valdes		\N	3321816662	\N		2025-05-03 20:50:49.755	2025-05-03 20:50:49.755	\N
7e880be1-0edf-4ed2-bd17-b718c87a16b3	Eduardo	Galindo Rios		eduardogalindorios@hotmail.com	\N	1962-01-22 00:00:00		2025-05-03 20:50:49.755	2025-05-03 20:50:49.755	\N
9ff77314-d1ee-4b64-9b27-d65e98fb3b92	Eduardo	García Enciso		eduardogenciso@gmail.com	\N	1980-01-18 00:00:00		2025-05-03 20:50:49.756	2025-05-03 20:50:49.756	\N
328526be-7fc7-4b39-8a8b-028ed70efa91	Eduardo	MADISON		\N	\N	\N		2025-05-03 20:50:49.756	2025-05-03 20:50:49.756	\N
1cb48b6a-a689-45f2-a78c-f6bf7a9cd7ea	Eduardo	Manjarrez Brian		eduardolupita41@gmail.com.	\N	1940-05-01 00:00:00		2025-05-03 20:50:49.756	2025-05-03 20:50:49.756	\N
64b60aef-7b53-423d-9786-d32cb6072a9d	Eduardo	Manriquez Zanabria		8mazae@gmail.com	3221720730	1994-01-02 00:00:00		2025-05-03 20:50:49.757	2025-05-03 20:50:49.757	\N
bee41588-665a-4624-a89b-8b6b2bb5a7ee	Eduardo	Martinez Sanchez		\N	\N	\N		2025-05-03 20:50:49.757	2025-05-03 20:50:49.757	\N
03b6e622-d572-4862-94e9-9cf6d9c55c21	Eduardo	Montalvo campos		eduardomontalvo_@hotmail.com	\N	1961-03-28 00:00:00		2025-05-03 20:50:49.757	2025-05-03 20:50:49.757	\N
52e767d0-afdf-45ea-8d5e-2ad5c09e0caf	Eduardo	Ruiz Hernández		scena01@hotmail.com	\N	1961-10-11 00:00:00		2025-05-03 20:50:49.758	2025-05-03 20:50:49.758	\N
dbeddc5b-8890-4200-a1eb-04a4518333ad	Eduardo	Sanchez Becerra		eduar1712@hotmail.com	3222740929	1997-12-17 00:00:00		2025-05-03 20:50:49.758	2025-05-03 20:50:49.758	\N
8206bf32-3e57-497d-b67c-2d912262aad0	Diego Alberto	Cardenas Vargas		\N	3327929817	\N		2025-05-03 20:50:49.758	2025-05-03 20:50:49.758	\N
f331db3d-f9c3-4708-8e84-6a6ee9656b06	Eduardo Alfonzo	Ponce Meza		eduardo.ponza@gmail.com	\N	1989-03-25 00:00:00		2025-05-03 20:50:49.759	2025-05-03 20:50:49.759	\N
be4bf49b-3444-4ab4-9fb9-55f9e91c288c	Eduardo Carlo	Mora Soria		\N	\N	2008-08-27 00:00:00		2025-05-03 20:50:49.759	2025-05-03 20:50:49.759	\N
26fc56de-edca-47ba-ad01-60ba16cfc57b	Eduardo Nain	Martinez Vera		\N	\N	2011-01-20 00:00:00		2025-05-03 20:50:49.759	2025-05-03 20:50:49.759	\N
f1abc21c-5ac8-49ae-8972-097adf8ce7ea	Eduardo Samuel	Pelayo Rodriguez		eduardo12.espr@gmail.com	\N	2002-05-08 00:00:00		2025-05-03 20:50:49.76	2025-05-03 20:50:49.76	\N
dde1b093-5e6f-4194-b23b-9ef01bc8ec39	Edward	Phillyp		philipedwards2729@gmail.com	\N	\N		2025-05-03 20:50:49.76	2025-05-03 20:50:49.76	\N
1590ab1f-75e0-4844-95cc-743270000054	Edwin Antonio	Estrada Vazquez		\N	\N	\N		2025-05-03 20:50:49.76	2025-05-03 20:50:49.76	\N
983cbc7a-63b7-46bb-989c-944a3a4e3813	Edwin Azahel	Santana Sandoval		\N	\N	2007-03-03 00:00:00		2025-05-03 20:50:49.761	2025-05-03 20:50:49.761	\N
8170ad10-9147-4594-9e83-de5f98605829	Edwin Yair	García Cervantes		edwin.garcerv@gmail.com	\N	1995-07-02 00:00:00		2025-05-03 20:50:49.761	2025-05-03 20:50:49.761	\N
d53a3e70-5d86-4924-a5a7-a9416eca68ea	Efigenia	Peña Soltero		\N	\N	\N		2025-05-03 20:50:49.761	2025-05-03 20:50:49.761	\N
fc663752-6a7c-447b-bfed-f139f7035505	Efrain	Torres Ramos		\N	\N	1980-06-15 00:00:00		2025-05-03 20:50:49.762	2025-05-03 20:50:49.762	\N
356d7478-84d4-47b2-be6e-b95b0be1eb23	Efren	Ledesmas López		\N	\N	1959-06-18 00:00:00		2025-05-03 20:50:49.762	2025-05-03 20:50:49.762	\N
1fba91dc-e585-4967-b56d-e167002e8e26	Eira	Zuñiga Partida		\N	\N	2009-01-07 00:00:00		2025-05-03 20:50:49.762	2025-05-03 20:50:49.762	\N
1a2602b2-4c40-49ef-a962-286161fe8b0f	Elba	Mata Cortez		\N	\N	1968-12-05 00:00:00		2025-05-03 20:50:49.762	2025-05-03 20:50:49.762	\N
929d3b41-7439-4bd2-aaac-d96836a2c326	Elda	Rodriguez		\N	\N	\N		2025-05-03 20:50:49.763	2025-05-03 20:50:49.763	\N
755c7b31-9f39-49fe-a63d-1712a85434fe	Elder	Lopez Lopez		\N	\N	\N		2025-05-03 20:50:49.763	2025-05-03 20:50:49.763	\N
72a24754-ccbd-4b49-a917-a3c25694dbbc	Eleanor	Bayliss		eleanorbayliss@gmal.com	\N	1959-11-16 00:00:00		2025-05-03 20:50:49.763	2025-05-03 20:50:49.763	\N
26fb33ea-26a8-4459-8b78-ba2d3b20d5ab	Eleazar	Romero Juarez		\N	\N	2005-12-01 00:00:00		2025-05-03 20:50:49.764	2025-05-03 20:50:49.764	\N
9b6587fa-c34d-4202-8895-6f8e208cdf80	Elena	Badillo Hernàndez		\N	\N	2004-03-02 00:00:00		2025-05-03 20:50:49.764	2025-05-03 20:50:49.764	\N
d02661b7-1da2-4b53-8006-e8a2571ec459	Elena	Barajas Munguia		\N	3229944870	1962-07-14 00:00:00		2025-05-03 20:50:49.764	2025-05-03 20:50:49.764	\N
18260679-10f3-44fd-a1d8-2a3feed2ddd0	Elena	Dimova		\N	\N	1999-10-26 00:00:00		2025-05-03 20:50:49.765	2025-05-03 20:50:49.765	\N
da9ae566-23df-4b7e-8726-e13d62da937c	Elena	Guerrero Brito		\N	3222407593	1973-08-22 00:00:00		2025-05-03 20:50:49.765	2025-05-03 20:50:49.765	\N
700735d5-fe08-4e63-bfa4-fd8da5ca1b01	Elena	Meraz Salas		\N	\N	2008-05-06 00:00:00		2025-05-03 20:50:49.765	2025-05-03 20:50:49.765	\N
23c0832e-d547-44c2-9697-c344631593f5	Diana Raquel	Sanchez Almeida		\N	3222316016	\N		2025-05-03 20:50:49.766	2025-05-03 20:50:49.766	\N
e3e15db5-c10d-4368-9d9d-d26549057088	Diego Alberto	Cárdenas Vargas		gabytavm@hotmail.com	+523327929817	\N		2025-05-03 20:50:49.766	2025-05-03 20:50:49.766	\N
32d3bbbb-4aeb-4350-997c-5aa37faf9bbb	Edith	Juarez Ramirez		\N	3221713865	\N		2025-05-03 20:50:49.766	2025-05-03 20:50:49.766	\N
e043f132-e179-4e6c-949c-3ef82fd43301	Elena	Popova		\N	\N	1974-12-21 00:00:00		2025-05-03 20:50:49.766	2025-05-03 20:50:49.766	\N
1339da64-d4fb-4462-994e-62181806f95a	Elena	Ramírez Ipiales		\N	\N	1977-11-25 00:00:00		2025-05-03 20:50:49.767	2025-05-03 20:50:49.767	\N
cca16e7f-6ed8-4b06-917a-930a084ad950	Elena	Ramírez Valencía		\N	\N	1952-04-23 00:00:00		2025-05-03 20:50:49.767	2025-05-03 20:50:49.767	\N
9027b426-3eb8-4252-bcd8-d1fd1d5fee84	Elena	Reyes Deloya		\N	\N	\N		2025-05-03 20:50:49.767	2025-05-03 20:50:49.767	\N
ed8557b3-ac2f-400e-9710-b28f36cc6e68	Diego de Jesús	Flores Jaime		\N	8134137885	\N		2025-05-03 20:50:49.768	2025-05-03 20:50:49.768	\N
ea4fbdd3-e761-4805-b0d9-1047c3618d38	Elia	Rodríguez González		\N	\N	1966-02-04 00:00:00		2025-05-03 20:50:49.768	2025-05-03 20:50:49.768	\N
4079c025-725b-415a-be68-0670aa2bfc7c	Elia	Vazquez v.		\N	\N	1977-07-28 00:00:00		2025-05-03 20:50:49.768	2025-05-03 20:50:49.768	\N
58970717-2b12-4914-b773-6ead2eb35887	Elida	Rodriguez Dominguez		elida10rodiguez@gmail.com	3222592362	1971-06-10 00:00:00		2025-05-03 20:50:49.769	2025-05-03 20:50:49.769	\N
949c2a95-c18b-4f26-8117-f1f93772af84	ELIESTER	CAMACHO		\N	\N	1981-04-19 00:00:00		2025-05-03 20:50:49.769	2025-05-03 20:50:49.769	\N
d23ff3ba-d244-4acf-afac-225f1e88f8e0	Elisa	Pelayo		\N	\N	2006-02-01 00:00:00		2025-05-03 20:50:49.769	2025-05-03 20:50:49.769	\N
64cefc21-86ae-41a2-8307-023122aedcd4	Djanel	Deddine		\N	3223232103	\N		2025-05-03 20:50:49.77	2025-05-03 20:50:49.77	\N
2eac6a04-3f8b-4e8a-85b3-48d96b12eff4	Elise	Forget		eliseforget@hotmail.com	\N	1975-12-17 00:00:00		2025-05-03 20:50:49.77	2025-05-03 20:50:49.77	\N
f7191c85-e7db-4656-8750-6d30d32006be	Eliseida	Montiel		\N	\N	2006-02-01 00:00:00		2025-05-03 20:50:49.77	2025-05-03 20:50:49.77	\N
809f8b01-4a96-430a-b78d-86b94e04a0a5	Eliza	Dueñas Montes de Oca		\N	\N	1942-04-27 00:00:00		2025-05-03 20:50:49.771	2025-05-03 20:50:49.771	\N
bf537e3e-9054-49bf-9f15-0a4e680f4905	Eliza	Rubio Vázquez		\N	\N	\N		2025-05-03 20:50:49.771	2025-05-03 20:50:49.771	\N
30065b74-c86c-4098-ab40-d984e5918c38	Eliza	Rubio Vázquez		\N	013292965372	1962-06-16 00:00:00		2025-05-03 20:50:49.771	2025-05-03 20:50:49.771	\N
af5acbcb-806a-44f1-9719-37596189f98c	Eliza Alejandrina	Alvarez Valenzuela		\N	\N	1959-04-20 00:00:00		2025-05-03 20:50:49.772	2025-05-03 20:50:49.772	\N
42593f63-c09c-4d15-9f12-718bcf9d230b	Eliza Carlolina	Nolasco Barraza		carolinehowl@hotmail.com	\N	1994-11-03 00:00:00		2025-05-03 20:50:49.772	2025-05-03 20:50:49.772	\N
510a4df7-0186-40d7-b613-cc0e4be5f1cd	Elizabeth	Aguilera Vitela		\N	\N	1969-09-04 00:00:00		2025-05-03 20:50:49.772	2025-05-03 20:50:49.772	\N
a48d1e37-ef5b-4baa-9732-81cdbfb29b97	Elizabeth	Barrera Calzada		ely_kj@hotmail.com	\N	1971-03-30 00:00:00		2025-05-03 20:50:49.772	2025-05-03 20:50:49.772	\N
232b9f9f-4522-4e38-96db-fdf7aafff0de	Elizabeth	Bazan Hernández		\N	\N	1975-08-22 00:00:00		2025-05-03 20:50:49.773	2025-05-03 20:50:49.773	\N
cee6b508-5c91-4373-b8cb-b6f276967cf4	Elizabeth	Beenken		\N	\N	\N		2025-05-03 20:50:49.773	2025-05-03 20:50:49.773	\N
f43c6ab1-107c-4d17-a4b7-722cdeda3d8a	Elizabeth	Castro Gonzalez		ecastrog2310@htomail.com	\N	1981-10-23 00:00:00		2025-05-03 20:50:49.774	2025-05-03 20:50:49.774	\N
185cec98-4aff-4722-bd68-9a9447e92e8d	Elizabeth	Garfio López		\N	3221165336	1968-04-24 00:00:00		2025-05-03 20:50:49.774	2025-05-03 20:50:49.774	\N
a1d531fc-4b81-4532-a995-81c78360df46	Elizabeth	Maldonado Serna		mark_bts@yahoo.com.mx	\N	1980-06-20 00:00:00		2025-05-03 20:50:49.774	2025-05-03 20:50:49.774	\N
fad650b0-7c11-4965-b600-c77a812f7962	Elizabeth	Marianne		\N	\N	1946-11-21 00:00:00		2025-05-03 20:50:49.775	2025-05-03 20:50:49.775	\N
26e910a6-0524-4826-8b3b-b4da9e5d8fb2	Debra	Macculling		\N	3221122305	\N		2025-05-03 20:50:49.775	2025-05-03 20:50:49.775	\N
3a003fb3-2375-4a2e-aabe-fe2925b4e9e2	Elizabeth	Martinez Hernandez		\N	\N	\N		2025-05-03 20:50:49.775	2025-05-03 20:50:49.775	\N
df58cc98-4d63-4f75-88e8-38164712b37c	Elizabeth	Morales Encarnacion		\N	\N	1998-02-18 00:00:00		2025-05-03 20:50:49.776	2025-05-03 20:50:49.776	\N
660dd975-88c5-41dc-8a25-a4c366c83345	Elizabeth	Partida Mayorquino		\N	\N	2010-06-23 00:00:00		2025-05-03 20:50:49.776	2025-05-03 20:50:49.776	\N
eda57b2d-23ed-4272-8a0e-f106ef7a754e	Dolores	Ramos Macias		\N	3221307592	\N		2025-05-03 20:50:49.776	2025-05-03 20:50:49.776	\N
c39959a4-81e7-428d-9238-bce14440dedb	Elizabeth	Pelayo Castilo		elizabeth_cmq@hotmail.com	\N	1971-04-26 00:00:00		2025-05-03 20:50:49.777	2025-05-03 20:50:49.777	\N
01feb468-7ef5-417b-8f4e-943292680254	Elizabeth	Ramos Maritnez		\N	\N	\N		2025-05-03 20:50:49.777	2025-05-03 20:50:49.777	\N
b45c127e-632c-4305-a47a-969eeabf34d5	Elizabeth	Trejo Barrera		\N	\N	1963-01-21 00:00:00		2025-05-03 20:50:49.777	2025-05-03 20:50:49.777	\N
23f7fbc7-af7f-4527-a57c-1d8599bd4daa	Elizabeth Anahi	Locuay		\N	\N	\N		2025-05-03 20:50:49.778	2025-05-03 20:50:49.778	\N
deac53e1-db4e-45a8-b711-d2324742584a	Elizabeth Anai	loguay Cruz		\N	\N	\N		2025-05-03 20:50:49.778	2025-05-03 20:50:49.778	\N
036b80a8-8ed1-4e3c-b3be-8a4dac22c9a3	Dora	Gosselin		\N	3223516852	\N		2025-05-03 20:50:49.778	2025-05-03 20:50:49.778	\N
84edfe80-6d39-4b98-bdf8-8380ad5319ec	Elizabeth Devani	Partido Guillen		\N	\N	2003-11-24 00:00:00		2025-05-03 20:50:49.779	2025-05-03 20:50:49.779	\N
1dddf78c-1d03-43a9-b388-d68cbc9b8f54	Elizabeth Gpe.	Ruíz Pérez		lispitarojo@hotmail.com	\N	1971-09-20 00:00:00		2025-05-03 20:50:49.779	2025-05-03 20:50:49.779	\N
301353c6-ebff-43a0-8456-a079eb17c48f	Elizabeth Monserrat	Gutierrez Muciño		\N	\N	2007-03-15 00:00:00		2025-05-03 20:50:49.779	2025-05-03 20:50:49.779	\N
06a21d05-c2dd-42d8-9138-3f1f25f1c02f	Dora	Mayer		\N	+12069229335	\N		2025-05-03 20:50:49.78	2025-05-03 20:50:49.78	\N
526edb5d-b652-48a4-aa19-f3a2ac5a5d64	Elliot	Gallagher		ellgalla@hotmail..com	\N	1977-05-27 00:00:00		2025-05-03 20:50:49.78	2025-05-03 20:50:49.78	\N
a2918832-cebb-4add-a13a-f3989a52d8a2	Elodia	Alonzo Hernández		est_elo@hotmail.com	\N	1964-09-18 00:00:00		2025-05-03 20:50:49.78	2025-05-03 20:50:49.78	\N
ddca0cb0-9fdf-4c0b-b7f5-8d39f5138ae0	Elodia	Rodriguez Gomez		\N	\N	\N		2025-05-03 20:50:49.78	2025-05-03 20:50:49.78	\N
26d1b3f2-cace-4aaa-83ed-5c7079976369	Eloiza	Alcantar		\N	\N	\N		2025-05-03 20:50:49.781	2025-05-03 20:50:49.781	\N
b39f2286-0574-484e-be4b-7508e66c9c37	Eloiza	Montoya Ramírez		\N	\N	1947-02-19 00:00:00		2025-05-03 20:50:49.781	2025-05-03 20:50:49.781	\N
09790a63-fd36-4947-99e5-e91956c1ed7f	Elsa	Benavides		\N	\N	\N		2025-05-03 20:50:49.781	2025-05-03 20:50:49.781	\N
880f0645-0cd7-4907-a774-4b2412c993d4	Elsa	Galindo y  Rojas		\N	\N	1943-03-16 00:00:00		2025-05-03 20:50:49.782	2025-05-03 20:50:49.782	\N
4788a066-89fa-4894-9e03-1103c390e2b2	Elsa Esther	Benavides López		gaviotasmilenio15@hotmail.com	\N	1942-02-08 00:00:00		2025-05-03 20:50:49.782	2025-05-03 20:50:49.782	\N
717f3bc8-ee3e-4a9a-a407-45070589186c	Elva Lorena	Martinez Mares		\N	\N	1979-01-17 00:00:00		2025-05-03 20:50:49.782	2025-05-03 20:50:49.782	\N
22cc634d-90b4-4983-9504-39e6ea6929aa	Elvia	Orozco Nuñes		\N	\N	1959-08-12 00:00:00		2025-05-03 20:50:49.783	2025-05-03 20:50:49.783	\N
6a36348d-c96c-4356-b775-20f4591daef1	Elvira	Armenta Ortiz		\N	9581188397	1973-01-15 00:00:00		2025-05-03 20:50:49.783	2025-05-03 20:50:49.783	\N
a90efd12-3972-4ff7-b4c1-fd3c6b36ac7c	Dulce Karina	Ramirez Cruz		\N	4448671373	\N		2025-05-03 20:50:49.783	2025-05-03 20:50:49.783	\N
c93a58d1-4140-4e13-ad2c-e97be1874738	Elvis	Nuño Nuño		reynuno3@gmail.com	\N	1978-09-20 00:00:00		2025-05-03 20:50:49.784	2025-05-03 20:50:49.784	\N
13f925dc-18a2-45be-be74-ab666a6b2260	Ema	Ortiz Martínez		emmaortiz4@hotmail.com	\N	1959-01-03 00:00:00		2025-05-03 20:50:49.784	2025-05-03 20:50:49.784	\N
cb32c8f9-52b8-4625-924e-5711e6aff969	Emannuel	Solis Ortega		\N	\N	2005-05-24 00:00:00		2025-05-03 20:50:49.784	2025-05-03 20:50:49.784	\N
6b52e995-be18-4640-a9e4-485a13ee982e	Emanuel	Franco Aceves		franco.aemma@gmail.com	3222424734	1991-01-15 00:00:00		2025-05-03 20:50:49.784	2025-05-03 20:50:49.784	\N
f89636d6-8382-4354-a5d0-d0e9995e7938	Emanuel Fernando	Villalobos Martinez		\N	\N	1992-05-01 00:00:00		2025-05-03 20:50:49.785	2025-05-03 20:50:49.785	\N
f605cc84-9fd2-4053-ac44-a684854b77b6	Emanuelle	Andrade Aguirre		\N	\N	2011-04-14 00:00:00		2025-05-03 20:50:49.785	2025-05-03 20:50:49.785	\N
38bffc6e-d6a6-416d-a4b0-891ec25fd46c	Emanuelle Alejandro	Guerrero Contreras		\N	\N	2010-10-21 00:00:00		2025-05-03 20:50:49.785	2025-05-03 20:50:49.785	\N
fda2339a-40e9-49f4-be0b-2c64e0729795	Emerita	Navarrete Franco		\N	\N	1961-09-26 00:00:00		2025-05-03 20:50:49.786	2025-05-03 20:50:49.786	\N
73a1e35b-cdf9-42d8-b278-7554b95d0f3b	Emigdia	Medína Avíla		\N	\N	1938-08-05 00:00:00		2025-05-03 20:50:49.786	2025-05-03 20:50:49.786	\N
99542d6e-58f4-4b2b-b300-27df4c3c6604	Emili Vidali	Velazco Partida		\N	\N	2012-12-18 00:00:00		2025-05-03 20:50:49.786	2025-05-03 20:50:49.786	\N
2ca3946a-afc9-481b-b9f7-18f0404f7d2d	Emilia	Guadarrama Garcia		\N	\N	1956-08-16 00:00:00		2025-05-03 20:50:49.787	2025-05-03 20:50:49.787	\N
124fc17d-16c4-44e1-a308-06e8fc45a9ad	Emiliano	Cordova Montoya		\N	\N	1999-04-16 00:00:00		2025-05-03 20:50:49.787	2025-05-03 20:50:49.787	\N
e2313b08-be51-405e-997f-fcb33e314a58	Emiliano	Cueto Rodriguez		\N	\N	2002-07-22 00:00:00		2025-05-03 20:50:49.787	2025-05-03 20:50:49.787	\N
5d243624-f20a-4b38-b68b-d8c05df1acee	Emiliano	Gaubeca		\N	\N	1977-09-14 00:00:00		2025-05-03 20:50:49.788	2025-05-03 20:50:49.788	\N
13205c5b-8fb4-47e8-a14a-13c0985a5e80	Emiliano	Gomez López		gomezgraciano@hotmail.com.	3222058946	\N		2025-05-03 20:50:49.788	2025-05-03 20:50:49.788	\N
310c05af-cabc-4bdf-878c-42d96abe7463	Emiliano	Rodriguez Alvarao		emilianorodriguez99@hotmail.com	\N	1999-12-27 00:00:00		2025-05-03 20:50:49.788	2025-05-03 20:50:49.788	\N
9f41d548-5cb3-4884-9088-9726ed6722ee	Emilio	Bouche Paquin		\N	\N	\N		2025-05-03 20:50:49.789	2025-05-03 20:50:49.789	\N
3019afb3-8d92-47fd-876e-37eee11e9ba2	Emilio	López Gómez		lizethgomez1984@yahoo.com.mx	\N	2010-11-24 00:00:00		2025-05-03 20:50:49.789	2025-05-03 20:50:49.789	\N
35950dac-80b8-4951-8d0f-22d4b76e251b	Emilio	Villela Tomshon		\N	3223100146	\N		2025-05-03 20:50:49.789	2025-05-03 20:50:49.789	\N
3f23d383-7eaa-4a59-9607-8c34dbfd3d8d	Emily	Carterline		\N	+17168607839	\N		2025-05-03 20:50:49.79	2025-05-03 20:50:49.79	\N
d6c9378b-80e1-489a-a8c6-d060414fe5a8	Eduardo	Becerril Gonzalez		efbg28@hotmail.com	+525536596910	\N		2025-05-03 20:50:49.79	2025-05-03 20:50:49.79	\N
869a4857-ea04-4572-b66e-3e7592b54417	Emma Ivonne	Zetina Santamaria		nahoma_29@hotmail.com	\N	\N		2025-05-03 20:50:49.79	2025-05-03 20:50:49.79	\N
537ea090-ab8c-44a3-a24b-3531ef974201	Emma Paola	Buenrostro Díaz		\N	3222604999	2003-11-12 00:00:00		2025-05-03 20:50:49.791	2025-05-03 20:50:49.791	\N
09042b30-100c-45b8-8199-99bf8e56d44d	Emmanuel	Boileau		emmanuelboileau28@outlook.com	\N	1973-06-27 00:00:00		2025-05-03 20:50:49.791	2025-05-03 20:50:49.791	\N
54c5f8c2-e6bf-4db4-aae3-c220c8f41922	Engracia	Alvarez Tron		\N	\N	2005-02-24 00:00:00		2025-05-03 20:50:49.791	2025-05-03 20:50:49.791	\N
3cb37ab6-02bc-4608-956f-0ce889725681	Eduardo	Del Rio Pimentel		\N	3221800836	\N		2025-05-03 20:50:49.792	2025-05-03 20:50:49.792	\N
bf092fb7-7385-4817-babf-ce09622281f3	Enrique	Chang Ramos		echang78@hotmail.com	3291021141	1977-07-17 00:00:00		2025-05-03 20:50:49.792	2025-05-03 20:50:49.792	\N
eb718df7-c902-4a0d-bb08-6271860cb0c2	Enrique	Murillo Lopez		e_lopezfp@hotmail.com	\N	1971-07-05 00:00:00		2025-05-03 20:50:49.792	2025-05-03 20:50:49.792	\N
d26e87bb-d814-403e-991b-af00ff20edc6	Enrique	Peralta		\N	\N	1962-12-12 00:00:00		2025-05-03 20:50:49.793	2025-05-03 20:50:49.793	\N
9e3ca3cc-ab29-4010-81fc-0a89591ef5b0	Enrique	Ramos Lopez		pintepiravi@hotmail.com	\N	1968-08-10 00:00:00		2025-05-03 20:50:49.793	2025-05-03 20:50:49.793	\N
f227e893-8738-4267-868e-ef4c6a2265cf	Enrique	Reynoso Torres		enrique.reynosotorres@gmail.com	\N	1974-07-31 00:00:00		2025-05-03 20:50:49.793	2025-05-03 20:50:49.793	\N
880b475a-b3cc-4555-afb8-93e48a614972	Enrique	Rodriguez Alvarez		enrrique_ro_alvarez@hotmail.com	\N	1970-02-11 00:00:00		2025-05-03 20:50:49.794	2025-05-03 20:50:49.794	\N
996f1648-bbd9-4d36-a01d-04a9f99f3c25	Enriqueta	Andalon Lara		\N	3227790429	\N		2025-05-03 20:50:49.794	2025-05-03 20:50:49.794	\N
323d1759-dbba-4bc4-a036-c94ab6d73eb6	Elena	Rodriguez		\N	3223189078	\N		2025-05-03 20:50:49.794	2025-05-03 20:50:49.794	\N
e8a75e6d-1cea-433d-9fe4-7b04bd745f89	Enrrique	Ayala Coitia		\N	\N	1993-02-19 00:00:00		2025-05-03 20:50:49.794	2025-05-03 20:50:49.794	\N
9f0e3b40-f0b8-4fec-8f16-d5ed3227bff6	Enrrique	Garcia Garcia		\N	\N	1968-01-29 00:00:00		2025-05-03 20:50:49.795	2025-05-03 20:50:49.795	\N
298e2a0f-7014-4c89-a880-65014d927d36	Enrrique	Lara Moreno		\N	\N	\N		2025-05-03 20:50:49.795	2025-05-03 20:50:49.795	\N
e84029f8-4f5c-4937-b047-e2bb75162f59	Enrrique	Navarro Sambrano		\N	\N	2008-01-17 00:00:00		2025-05-03 20:50:49.795	2025-05-03 20:50:49.795	\N
0ec828fb-e7db-450d-aa72-a38a2dc4ea63	Enrrique	Sandoval Vital		\N	3222627473	\N		2025-05-03 20:50:49.796	2025-05-03 20:50:49.796	\N
5976cd86-f27b-418a-8764-5c4d1c818793	Enrrique	Vergara Solis		\N	\N	2006-10-28 00:00:00		2025-05-03 20:50:49.796	2025-05-03 20:50:49.796	\N
108d1366-0c24-4758-ac9c-4bbb57e1c36f	Enrrique	VITALPOOLS		\N	\N	\N		2025-05-03 20:50:49.796	2025-05-03 20:50:49.796	\N
978af10c-f754-4698-b9e8-23a4ee49f953	Enrrique Manuel	Robles Villalvazo		rove2502@prodigy.net.mx	\N	1962-02-25 00:00:00		2025-05-03 20:50:49.797	2025-05-03 20:50:49.797	\N
a0063bcd-905a-4cbe-8c12-5528274860cc	Enrriqueta	Rabasa de Valadés		\N	\N	2006-07-22 00:00:00		2025-05-03 20:50:49.797	2025-05-03 20:50:49.797	\N
b6127187-b0f3-4d80-904f-1498ec98f405	Enya	Garrido Velazco		\N	\N	2001-04-14 00:00:00		2025-05-03 20:50:49.797	2025-05-03 20:50:49.797	\N
d1aab892-15bc-4083-a985-8ab211848d85	Eriberto	Fregozo		Erik_martin.26@hotmail.com	\N	1988-04-26 00:00:00		2025-05-03 20:50:49.798	2025-05-03 20:50:49.798	\N
67429896-6da9-4168-938d-6a9efc323abe	Eriberto	Saucedo Perez		herikojoyeria@hotmail.com	\N	1977-03-16 00:00:00		2025-05-03 20:50:49.798	2025-05-03 20:50:49.798	\N
fdfde757-3722-4130-a4c3-00b21a2ffb65	Eric	Elizondo Aguayo		\N	\N	\N		2025-05-03 20:50:49.798	2025-05-03 20:50:49.798	\N
9f4bcff5-0c9f-4344-b4ca-09d5d8efb0f1	Erica	Reis De Souza		erica3reis@gmail.com	\N	1986-07-03 00:00:00		2025-05-03 20:50:49.799	2025-05-03 20:50:49.799	\N
d3392ceb-043a-479d-93db-7e6fd5d1e3b2	Erick	De La Cruz Mendez		\N	\N	\N		2025-05-03 20:50:49.799	2025-05-03 20:50:49.799	\N
44b255c5-cb4e-47f3-a9d3-46e125361dd6	Erick	Montoya Vela		\N	\N	\N		2025-05-03 20:50:49.799	2025-05-03 20:50:49.799	\N
e32f3014-8e9d-4ae5-9d22-f16409d66c02	Erick Francisco	Varela Zendeja		varela201013@gmail.com	3221921370	1982-09-27 00:00:00		2025-05-03 20:50:49.8	2025-05-03 20:50:49.8	\N
bff81ad0-99d0-48ed-bd77-bc8bc31fb448	Erik	Abelar Uribe		\N	\N	1974-07-01 00:00:00		2025-05-03 20:50:49.8	2025-05-03 20:50:49.8	\N
733ace46-a83d-48e9-88b0-d8fada59c27f	Erik	Elizondo		\N	\N	\N		2025-05-03 20:50:49.8	2025-05-03 20:50:49.8	\N
1e901c59-985a-4de8-b66c-53348fdf4f78	Erik	Nevares Reyes		\N	\N	2010-05-27 00:00:00		2025-05-03 20:50:49.801	2025-05-03 20:50:49.801	\N
d624d652-e617-4e1e-a9f1-8195f2388dd0	Erik	Pacheco Flores		\N	\N	\N		2025-05-03 20:50:49.801	2025-05-03 20:50:49.801	\N
fd76a784-d674-411e-aa33-44a08e8da0a8	Erik	Perez Venegas		\N	\N	2006-05-05 00:00:00		2025-05-03 20:50:49.801	2025-05-03 20:50:49.801	\N
fe5b44db-14d8-4064-ae1c-bbf062c79088	Eduardo	Tapia		\N	3228883004	\N		2025-05-03 20:50:49.801	2025-05-03 20:50:49.801	\N
7c0114d8-2fc6-4fb6-a276-252207dddb23	Erik Daniel	Neyra Gomez.		\N	\N	2008-03-13 00:00:00		2025-05-03 20:50:49.802	2025-05-03 20:50:49.802	\N
15accdf6-39f3-4c65-ae01-12b3b80f689a	Erik Ivan	Torres Martinez		\N	\N	1986-12-22 00:00:00		2025-05-03 20:50:49.802	2025-05-03 20:50:49.802	\N
0b78d916-7065-4556-975d-9cd69225d6d5	Erika	Boltvink		\N	\N	1974-08-31 00:00:00		2025-05-03 20:50:49.803	2025-05-03 20:50:49.803	\N
026ef5e0-892b-4418-bfc8-ccb006c093ec	Erika	Diloreto		erika.diloreto5@gmail.com	\N	1990-07-08 00:00:00		2025-05-03 20:50:49.803	2025-05-03 20:50:49.803	\N
cd2fd02f-a65f-40a7-be46-af16f74d4dd6	Erika	Orozco Villegas		\N	\N	1980-04-09 00:00:00		2025-05-03 20:50:49.803	2025-05-03 20:50:49.803	\N
c67580e4-bc4a-4d26-9700-d7032659b91d	Dolores	Contreras		\N	3223038103	\N		2025-05-03 20:50:49.803	2025-05-03 20:50:49.803	\N
5269bbf2-5f3b-4fbb-8b34-66521f70170b	Erika	Oseguera Noguez		\N	\N	1978-10-30 00:00:00		2025-05-03 20:50:49.804	2025-05-03 20:50:49.804	\N
060ed0e8-bb28-42e4-8720-633d56137704	Erika	Villaseñor		\N	\N	\N		2025-05-03 20:50:49.804	2025-05-03 20:50:49.804	\N
a8281479-7c48-4691-8093-fc3f68560313	Erika Enid	Hernández García		kika_end@live.com.mx	\N	1973-11-22 00:00:00		2025-05-03 20:50:49.804	2025-05-03 20:50:49.804	\N
7dad1f5e-466a-48b0-acb0-9fd07f04aa51	Erika Estefania	Lara Placito		lamasloca_yes@hotmail.com	\N	1994-08-15 00:00:00		2025-05-03 20:50:49.805	2025-05-03 20:50:49.805	\N
50c1ed42-d6c5-442a-bfdc-d42536a8816a	Erika Guadalupe	Sanchez Carrillo		erikacaribe@hotmail.com	\N	1983-10-20 00:00:00		2025-05-03 20:50:49.805	2025-05-03 20:50:49.805	\N
68611795-e1e5-469d-b70b-b26dcfe9f05e	Erika Judith	Perez Villegas		kimi97judi@gmail.com	\N	1975-07-16 00:00:00		2025-05-03 20:50:49.805	2025-05-03 20:50:49.805	\N
6efbbe77-9b15-44c8-9e57-bfdcf8165384	Elizabeth	Marmolejo		marmolejo.elizabeth@gmail.com	+523333590105	\N		2025-05-03 20:50:49.806	2025-05-03 20:50:49.806	\N
656631e5-e637-4023-bc6e-c829724a536d	Erin Renata	Martinez Medína		erinrenatamartinesmedina2009@gmai.com	3222903389	2009-10-21 00:00:00		2025-05-03 20:50:49.806	2025-05-03 20:50:49.806	\N
149d1551-6914-4eb7-b8ba-e1ded531cfd9	Ernestina	Alcantar Torres		\N	\N	1959-03-03 00:00:00		2025-05-03 20:50:49.806	2025-05-03 20:50:49.806	\N
476b30f0-b304-4322-8dc2-1e1daba4fb79	Ellen	Sanchez		\N	3223726452	\N		2025-05-03 20:50:49.807	2025-05-03 20:50:49.807	\N
19ef67cb-e498-4d2c-8297-6369ddcf86ae	Ernestina	García Romero		ernestinagromero@gmail.com	3221932410	1981-08-27 00:00:00		2025-05-03 20:50:49.807	2025-05-03 20:50:49.807	\N
794cf91e-def7-412f-82f3-502aacd96fe4	Ernesto	Angeles Mejia		\N	\N	1950-07-11 00:00:00		2025-05-03 20:50:49.807	2025-05-03 20:50:49.807	\N
7f972e2d-b128-4175-ba39-bbb4cae6acba	Ernesto	García Hernández		\N	3221399624	1966-11-07 00:00:00		2025-05-03 20:50:49.808	2025-05-03 20:50:49.808	\N
210d3960-33ef-4e40-b56c-c2d171166359	Ernesto Ramses	Villa Zuniga		\N	\N	2000-07-27 00:00:00		2025-05-03 20:50:49.808	2025-05-03 20:50:49.808	\N
75e12179-a02e-482a-8475-edae691bab94	Esequiel	Rodriguez Roldan		\N	\N	1939-04-05 00:00:00		2025-05-03 20:50:49.808	2025-05-03 20:50:49.808	\N
09efe435-2809-4736-80aa-16889ea38b5d	Esmeral	Reyes Delgadillo		esmerladareyes39@gmail.com	\N	1989-02-11 00:00:00		2025-05-03 20:50:49.809	2025-05-03 20:50:49.809	\N
a1c413ce-f81f-4e70-9815-3eb28c6056a4	Esmeralda	Leal Zepeda		\N	\N	1987-09-12 00:00:00		2025-05-03 20:50:49.809	2025-05-03 20:50:49.809	\N
9098539b-bf85-4f52-93df-0419d8333ba6	Elisa Mariela	Diaz Arias		\N	3221919991	\N		2025-05-03 20:50:49.809	2025-05-03 20:50:49.809	\N
f2234e6d-06de-4400-8c13-bb02a2fbed5f	Elizabeth Claudia	Hernandez  Lopez		\N	3221560824	\N		2025-05-03 20:50:49.809	2025-05-03 20:50:49.809	\N
1377d661-dbdf-4502-8a3e-56c2e9f76886	Esperanza	Paz Alcantará		\N	\N	2005-07-20 00:00:00		2025-05-03 20:50:49.81	2025-05-03 20:50:49.81	\N
2e0fa46d-9d7c-4a9b-841f-b6c563b099ae	Esteban	Alfaro Sanchez		ztankyboo@gmai.com	\N	1997-06-18 00:00:00		2025-05-03 20:50:49.81	2025-05-03 20:50:49.81	\N
9881463b-7f2c-4cab-a6e7-6283b77fae9a	Elvira	Khakimulina		\N	7711059952	\N		2025-05-03 20:50:49.81	2025-05-03 20:50:49.81	\N
c817168e-b4c8-42f3-8d87-eecc1c20882c	Esteban	FigueroaMares		\N	3222203659	\N		2025-05-03 20:50:49.811	2025-05-03 20:50:49.811	\N
c43a9edb-e88e-4ce9-923d-ceaed9088d9d	Estebania	GomezPeralta Cadena		\N	\N	1990-03-29 00:00:00		2025-05-03 20:50:49.811	2025-05-03 20:50:49.811	\N
eff9bdfe-dec7-44a5-b617-8955747ed310	Estefana	Quintero Torres		estepqt@gmail.com	\N	1989-10-30 00:00:00		2025-05-03 20:50:49.811	2025-05-03 20:50:49.811	\N
5e35e5e2-e1a5-44b4-8028-9eff2bdee5c2	Erika	Orozco Villegas		orozcoerika98@gmail.com	+523221829368	\N		2025-05-03 20:50:49.812	2025-05-03 20:50:49.812	\N
14bf5c5a-47d1-4652-a384-f5c5b34f81c0	Esteban	Figeroa mares		\N	3222203659	\N		2025-05-03 20:50:49.812	2025-05-03 20:50:49.812	\N
7d07fbd1-137a-451d-b73f-c356b2fd2c4d	Enia Nicole	Garrido Velzco		\N	3223277285	\N		2025-05-03 20:50:49.812	2025-05-03 20:50:49.812	\N
eb9e68b2-88a9-4ad5-ac4e-ea4dbc352d2f	Estefania	Martínez Velászquez		fanimtzvzz@gmnial.com	\N	1993-10-21 00:00:00		2025-05-03 20:50:49.813	2025-05-03 20:50:49.813	\N
a0d81c78-1946-4de5-843f-f8264ffefccc	Emma	McCurry		\N	+16786030474	\N		2025-05-03 20:50:49.813	2025-05-03 20:50:49.813	\N
5b541230-b814-4d2f-a981-41b7934d1afe	Estefania	Romero Gonzalez		\N	\N	\N		2025-05-03 20:50:49.813	2025-05-03 20:50:49.813	\N
0f38e327-607e-46e0-ad2c-e1d23be9831e	Estefania	Sanchez Montaño		\N	\N	1991-10-19 00:00:00		2025-05-03 20:50:49.814	2025-05-03 20:50:49.814	\N
1e67276d-e152-47b6-bc75-a9a4018d0f6e	Estefany	Rosas Abelarde		fanyvallarta@hotmail.com	\N	1980-10-05 00:00:00		2025-05-03 20:50:49.814	2025-05-03 20:50:49.814	\N
9b14f62d-2b61-4e0f-84fa-7334aa60e937	Enriqueta	Valades Rabasa		\N	5538869898	\N		2025-05-03 20:50:49.814	2025-05-03 20:50:49.814	\N
5fcb5c93-6c6c-40e9-b0dc-ae2fb8e57789	Eric	Elizondo		\N	3224038054	\N		2025-05-03 20:50:49.814	2025-05-03 20:50:49.814	\N
0770d8ea-68c0-4ef6-9310-4536aa498631	Enri	Valades Rabasa		valadesenriqueta@gmail.com	5538869898	\N		2025-05-03 20:50:49.815	2025-05-03 20:50:49.815	\N
74fc5175-2eaf-43f8-b4d2-c47f5c9fd0f1	Estela	Zavala Baez		\N	\N	2011-03-30 00:00:00		2025-05-03 20:50:49.815	2025-05-03 20:50:49.815	\N
21bd9d05-8965-4714-8c12-b51be5505972	Erik	Velázquez Pérez		\N	6242200022	1997-10-25 00:00:00		2025-05-03 20:50:49.815	2025-05-03 20:50:49.815	\N
1227aa9f-80da-448b-9055-18333e5bc554	Esther	Anaya Gonzalez		\N	\N	1988-01-09 00:00:00		2025-05-03 20:50:49.816	2025-05-03 20:50:49.816	\N
7639fce8-5c3c-4046-94dc-9e1934dcb6a0	Esther	Recoder Rodríguez		\N	\N	2009-08-06 00:00:00		2025-05-03 20:50:49.816	2025-05-03 20:50:49.816	\N
4c308250-2a65-4edd-a128-76e23bb9798b	Estrella Mesic	Garcia Jaimes		\N	\N	2012-11-01 00:00:00		2025-05-03 20:50:49.817	2025-05-03 20:50:49.817	\N
ed1ab1d2-60c1-4f9c-a577-d5a5cea1f990	Ethan	Casterlina		\N	\N	\N		2025-05-03 20:50:49.817	2025-05-03 20:50:49.817	\N
7e38c109-7e1b-4eae-8f7b-f3608406f133	Ethna	Cravioto Mazano		ecolifecreeme17@gmail.com	\N	1991-07-31 00:00:00		2025-05-03 20:50:49.817	2025-05-03 20:50:49.817	\N
ddaae0c2-30ac-45b9-8497-8524c6ce4b1e	Etna Johana	De la Torre Velazco		jhona2608-87@hotmail.com	\N	1987-08-26 00:00:00		2025-05-03 20:50:49.818	2025-05-03 20:50:49.818	\N
00b60648-8af0-416f-922a-6adcba1d4dfc	Eucebia	Sibrial Gomez		\N	\N	2008-09-04 00:00:00		2025-05-03 20:50:49.818	2025-05-03 20:50:49.818	\N
ededa189-71d2-4a3b-a905-f5cc72e23d67	Eugenia	Prieto Raigadas		prietoeu@mail.com	\N	1982-06-20 00:00:00		2025-05-03 20:50:49.818	2025-05-03 20:50:49.818	\N
1abae48c-557d-4930-86a0-d4905edb05b7	Eugenia	Rich		\N	\N	\N		2025-05-03 20:50:49.818	2025-05-03 20:50:49.818	\N
d20fde07-507f-4cf5-b9dd-3ee780ba6350	Elizabeth	Pelayo Castillo		\N	3221901195	\N		2025-05-03 20:50:49.819	2025-05-03 20:50:49.819	\N
6c5470cf-d7b9-47b9-9743-810e35be13ee	Eugenio	González Márquez		gonzalezmarquezvallarta@gmail.com	\N	1959-03-12 00:00:00		2025-05-03 20:50:49.819	2025-05-03 20:50:49.819	\N
2123b5d0-c4f7-4b5a-979d-d9c8b1613dd8	Eulalia	Palomera García		\N	3221573152	1983-02-12 00:00:00		2025-05-03 20:50:49.819	2025-05-03 20:50:49.819	\N
b8385bb6-8bdb-497a-a11f-3d962446e439	Eulalia	Vazquez Lopez		\N	\N	2005-10-01 00:00:00		2025-05-03 20:50:49.82	2025-05-03 20:50:49.82	\N
65b964b8-b863-4efa-98d7-1f895ef08e32	Eunice	Reyna Alvarado		\N	\N	2011-06-29 00:00:00		2025-05-03 20:50:49.82	2025-05-03 20:50:49.82	\N
7e3e0cf0-73a4-4329-bbb6-dd70641813dd	Eusebio	Bernal Ruiz		\N	\N	\N		2025-05-03 20:50:49.82	2025-05-03 20:50:49.82	\N
b675559c-6c5a-4fc0-80f2-69e66588ca2c	Eva	Barcs		\N	\N	1954-04-14 00:00:00		2025-05-03 20:50:49.821	2025-05-03 20:50:49.821	\N
a06a7214-d52b-4fa0-9b6e-d1a3043cc8bc	Eva	Mondragon Villar		xiomy1129@hotmail.com	\N	1990-03-11 00:00:00		2025-05-03 20:50:49.821	2025-05-03 20:50:49.821	\N
2c97150c-1441-48a6-9a1e-c6a5290f60ea	Eva	Muñoz		\N	\N	2010-10-20 00:00:00		2025-05-03 20:50:49.821	2025-05-03 20:50:49.821	\N
8f033044-91b7-43dc-9936-98e755f50113	Eva	Ongay		eva_ongay@hotmail.com	\N	1945-06-15 00:00:00		2025-05-03 20:50:49.822	2025-05-03 20:50:49.822	\N
0db59c21-3679-4ebd-94b6-4523ac25d0ae	Eva	Rodriguez Lorenzo		\N	\N	1952-03-28 00:00:00		2025-05-03 20:50:49.822	2025-05-03 20:50:49.822	\N
1e6db29a-e7dc-4f7d-b0b4-8387d166ed53	Eva	Vazquez Fonseca		\N	\N	1999-02-04 00:00:00		2025-05-03 20:50:49.822	2025-05-03 20:50:49.822	\N
5f412644-8b7a-4562-8c3f-93edadee93bd	Eva Jaqueline	Valle Hernández		yalinevahe@hotmail.com.	\N	1971-07-21 00:00:00		2025-05-03 20:50:49.823	2025-05-03 20:50:49.823	\N
736028e9-ec69-4496-b046-8f3b494ad145	Evelia	Casillas Bañuelos		\N	\N	\N		2025-05-03 20:50:49.823	2025-05-03 20:50:49.823	\N
819b0d08-4d55-4184-a47b-c3051298c731	Evelia	Fuentes Flores		\N	\N	1968-01-28 00:00:00		2025-05-03 20:50:49.823	2025-05-03 20:50:49.823	\N
d27432f0-216a-4ca2-b7c0-833397b4c35e	Evelia	Fuentes Flores		\N	\N	\N		2025-05-03 20:50:49.824	2025-05-03 20:50:49.824	\N
d31dee8c-ae24-4f96-897f-0d7c4a09b9c7	Evelin Romina	Ortiz Torres		\N	\N	\N		2025-05-03 20:50:49.824	2025-05-03 20:50:49.824	\N
2e025420-303e-4614-a861-d2f67021f128	Evelyn	Martinez Lizarraga		evelynlizarragamtz88@hotmail.com	\N	1988-09-30 00:00:00		2025-05-03 20:50:49.824	2025-05-03 20:50:49.824	\N
1252e5c5-f8e1-49e5-8a05-bcc3957580ea	Evelyn Noemi	Magaña Carranza		\N	\N	2006-06-15 00:00:00		2025-05-03 20:50:49.825	2025-05-03 20:50:49.825	\N
3d62b445-0644-4367-89dd-c8001309cc1a	Evelyn sofia	Caro Mercado		\N	\N	2009-08-30 00:00:00		2025-05-03 20:50:49.825	2025-05-03 20:50:49.825	\N
5ecb705f-1017-4bdd-bb41-6f130fb625b6	Ezechiel	Alvarez Gudiño		ezechielalvarez@outlook.com	\N	1991-09-10 00:00:00		2025-05-03 20:50:49.825	2025-05-03 20:50:49.825	\N
ab29b4d6-6a71-4590-8942-4c04538bf7a0	Ezequiel	Cardenas Peña		ezequielcardenas169@gmail.com	\N	1973-09-03 00:00:00		2025-05-03 20:50:49.825	2025-05-03 20:50:49.825	\N
dd6edff3-16c0-4e32-b463-ac9742a12b7b	Ezequiel	Romandetto		\N	\N	1975-02-22 00:00:00		2025-05-03 20:50:49.826	2025-05-03 20:50:49.826	\N
650f5096-4ea5-490b-82b6-936d9c819bbf	Ezequiel Agustin	Solis Medina		\N	\N	2010-10-18 00:00:00		2025-05-03 20:50:49.826	2025-05-03 20:50:49.826	\N
68bfec6f-4212-438d-9e07-cef16549706c	Fabia	Pichardo Franco		\N	\N	2007-10-18 00:00:00		2025-05-03 20:50:49.826	2025-05-03 20:50:49.826	\N
9f803c42-98a4-493f-809b-e01a958c93d0	Fabian	Culebro Flores		\N	\N	1996-01-06 00:00:00		2025-05-03 20:50:49.827	2025-05-03 20:50:49.827	\N
251d0989-2224-4af2-862c-ce0f8daa2abb	Fabian	Culebro Flores		\N	\N	1996-01-06 00:00:00		2025-05-03 20:50:49.827	2025-05-03 20:50:49.827	\N
3a57e8e8-1254-4373-92a9-100c6b54dd4a	fabian	e hijo		\N	\N	2006-06-06 00:00:00		2025-05-03 20:50:49.827	2025-05-03 20:50:49.827	\N
25f7502f-3308-480f-aada-9563c0a586cf	Erick	Rojas Mora		\N	3223694368	\N		2025-05-03 20:50:49.828	2025-05-03 20:50:49.828	\N
52aa90f1-a190-420c-bf0c-4578b2410960	Fabian de Jesus	Lizarraga Ortega		\N	\N	2001-02-22 00:00:00		2025-05-03 20:50:49.828	2025-05-03 20:50:49.828	\N
40cf1e1b-6485-46b1-ac57-7f9a0e055463	Fabian Marcelo	Morales Gutierrez		layan_centrartes@hotmail.com	\N	1983-11-21 00:00:00		2025-05-03 20:50:49.828	2025-05-03 20:50:49.828	\N
8b9488ab-d300-4194-aded-98bcf90cdae7	Fabiana	Sabatin		fabi0925@live.com	\N	1977-05-07 00:00:00		2025-05-03 20:50:49.829	2025-05-03 20:50:49.829	\N
d2ef7c87-1768-412e-960d-d6e2b6d1064e	Fabiana Marcela	Rapp de Mico		fabianamarcela_rapp@hotmail.com	\N	1965-03-15 00:00:00		2025-05-03 20:50:49.829	2025-05-03 20:50:49.829	\N
116fbfc4-0fec-4e9e-8457-45c3672892ca	Fabianne	Prado		\N	\N	\N		2025-05-03 20:50:49.829	2025-05-03 20:50:49.829	\N
f5741b48-a5fe-4b0d-a4c7-457ce98de18a	Fabianne	Prado Pérez		bananita_4X4@hotmail.com	\N	1999-09-14 00:00:00		2025-05-03 20:50:49.83	2025-05-03 20:50:49.83	\N
9163330d-306b-464c-8db4-e33fad927d1e	Fabio	Perino		kayalove98@gmail.com	\N	1976-01-08 00:00:00		2025-05-03 20:50:49.83	2025-05-03 20:50:49.83	\N
31ebe5d5-6146-44ee-a87c-3a3bea38f95a	Fabio	Vanin		fabiovanin@hotmail.com	3112584571	1962-10-16 00:00:00		2025-05-03 20:50:49.831	2025-05-03 20:50:49.831	\N
df1898f1-a628-4a50-8555-9922ab1f41f9	Fabiola	Campos Zetina		aby-cz@hotmail.com	\N	1978-06-10 00:00:00		2025-05-03 20:50:49.831	2025-05-03 20:50:49.831	\N
81c7e207-ec6e-4bee-98a8-dbd61f287bf2	Fabiola	Gonzales Lupercio		aymarafglez@hotmail.com	\N	1979-05-03 00:00:00		2025-05-03 20:50:49.831	2025-05-03 20:50:49.831	\N
6432c4fc-972c-4234-a8be-3c626468ec5e	Fabiola	Orosco Colin		\N	\N	1969-12-29 00:00:00		2025-05-03 20:50:49.832	2025-05-03 20:50:49.832	\N
fd4089dd-13c2-4f27-8827-6a5406230b77	Fabiola	Pesqueira Maya		\N	3221470259	\N		2025-05-03 20:50:49.832	2025-05-03 20:50:49.832	\N
67f633da-be35-4c18-9ab2-31c9b343bda0	Fabiola	Vasquez Ruiz		\N	\N	1978-05-30 00:00:00		2025-05-03 20:50:49.832	2025-05-03 20:50:49.832	\N
29c2c469-6f19-4246-b277-24f21b1d4595	Fabiola Margarita	Zepeda Garcia		fabiiola13@hotmail.com	\N	1980-01-13 00:00:00		2025-05-03 20:50:49.833	2025-05-03 20:50:49.833	\N
b1fe0e91-4e18-4b7a-9243-da27c282e0a4	Esmeralda Yudith	Romero Guerrero		rm7621904@gmail.com	3881039622	\N		2025-05-03 20:50:49.833	2025-05-03 20:50:49.833	\N
77e71da3-d545-432d-a39d-e1face90b2cd	Fabricio Gael	Gonzalez ]Fabian		fgonzalez28@ucol.mx	\N	2003-01-03 00:00:00		2025-05-03 20:50:49.834	2025-05-03 20:50:49.834	\N
5de3cc63-723f-4f0e-9b64-ca04deea7ef6	Esparza Perez	Cristian		\N	3221975678	\N		2025-05-03 20:50:49.834	2025-05-03 20:50:49.834	\N
6f609f2a-63e6-4e7a-9618-0ad2d8419aca	Fatima	Magaña Sanchez		\N	\N	1996-10-31 00:00:00		2025-05-03 20:50:49.834	2025-05-03 20:50:49.834	\N
a1a0a457-5e63-4c0e-a2ce-facef90f428c	Fatima	Martinez Rodriguez		martinez_fa@hotmail.com	\N	1985-07-03 00:00:00		2025-05-03 20:50:49.835	2025-05-03 20:50:49.835	\N
08b2ed18-d0e2-4faf-bc1b-502626e3abed	Ernestina	Garcia R		ernestinagromero@gmail.com	+523221932410	\N		2025-05-03 20:50:49.835	2025-05-03 20:50:49.835	\N
15f31e2b-1329-4844-b6f0-7234f6d3000b	Fatima Belem	Martínez Hernandéz		\N	\N	2000-02-22 00:00:00		2025-05-03 20:50:49.835	2025-05-03 20:50:49.835	\N
381966d0-5334-47f6-bdc4-6b4855270923	Fatima Montserrat	Cueva Hernandez		\N	\N	2008-03-10 00:00:00		2025-05-03 20:50:49.836	2025-05-03 20:50:49.836	\N
b1f6ea0a-9ccd-48d7-8df8-cc1320714d4c	Faustina	Virgen Baro		\N	\N	2009-11-09 00:00:00		2025-05-03 20:50:49.836	2025-05-03 20:50:49.836	\N
ce9a794d-889b-42ea-af99-69f03a815a02	Federica	Dugas		inukchuk2@yahoo.ca	\N	1946-08-05 00:00:00		2025-05-03 20:50:49.836	2025-05-03 20:50:49.836	\N
02ca2dc7-219b-4c4b-97bb-d50252d7d629	Estefania	Meraz Delgado		\N	3221697472	\N		2025-05-03 20:50:49.837	2025-05-03 20:50:49.837	\N
07ea0ba3-8fc3-4333-8e2e-c975cb1f3f3c	Federico	Arrizalaja Sandoval		\N	\N	\N		2025-05-03 20:50:49.837	2025-05-03 20:50:49.837	\N
4f59aa48-ddd7-462f-b510-7a3d82e00acb	Federico	Jimenez Lamoglia		\N	\N	1955-11-20 00:00:00		2025-05-03 20:50:49.837	2025-05-03 20:50:49.837	\N
411294ce-33cb-46c7-a113-205d44e882ac	Federico	Mendiola Nonato Jr.		gueromendiola@yahoo.com	\N	1978-04-02 00:00:00		2025-05-03 20:50:49.838	2025-05-03 20:50:49.838	\N
c15c572b-ad17-4321-8297-e668f3b69e7e	Federico	Oliva Cortez		foliva99@gmail.com	\N	\N		2025-05-03 20:50:49.838	2025-05-03 20:50:49.838	\N
1018aff1-8008-4a90-875f-2ad7a636a88f	Federico	Ruck		ruck.federico@mail.com	3221573982	1945-09-04 00:00:00		2025-05-03 20:50:49.838	2025-05-03 20:50:49.838	\N
e8ea9901-d09f-4078-9401-d4f63d068639	Estefania	Cruz Rios		\N	528714007536	\N		2025-05-03 20:50:49.839	2025-05-03 20:50:49.839	\N
7cd5cf8b-f18f-4360-a3f5-89bfddd320b9	Felicita	Sanchez González		tita_23@hotmail.com	\N	1969-05-23 00:00:00		2025-05-03 20:50:49.839	2025-05-03 20:50:49.839	\N
44f0904d-f576-40ad-8085-2ff156f3e5ce	Felicitas	Barragan Arreola		\N	\N	1926-07-30 00:00:00		2025-05-03 20:50:49.839	2025-05-03 20:50:49.839	\N
fedd7a47-b019-4f4b-84a2-5af02938d6b7	Felicitas	Rodriguez  García		\N	\N	1948-05-18 00:00:00		2025-05-03 20:50:49.84	2025-05-03 20:50:49.84	\N
ba883638-7fef-462a-b1dd-34a914788a57	Felicitas	Sanchez Gonzalez		tita_23@hotmail.com	\N	1969-05-23 00:00:00		2025-05-03 20:50:49.84	2025-05-03 20:50:49.84	\N
8ac7eb09-531c-45d3-8a45-a87ba8e5f041	Estefani Alejandra	Rosas Pinzon		\N	3221183084	\N		2025-05-03 20:50:49.84	2025-05-03 20:50:49.84	\N
9f758caf-cf3e-4f09-b741-3c7d7660f9db	Estefany	Rosas Avelarde		\N	3221689831	\N		2025-05-03 20:50:49.841	2025-05-03 20:50:49.841	\N
f7822d0a-52f2-4208-a8b5-ad302b219259	Felipe	Flores Avalos		\N	\N	\N		2025-05-03 20:50:49.841	2025-05-03 20:50:49.841	\N
09a2ca58-8177-486d-b1c1-8873a871efe1	Felipe	Joya Crúz		\N	\N	1987-01-31 00:00:00		2025-05-03 20:50:49.841	2025-05-03 20:50:49.841	\N
71d7ae8f-29d5-40a3-9ec5-9e9150b108b7	Felipe	Lorenzo Andrade		\N	\N	\N		2025-05-03 20:50:49.842	2025-05-03 20:50:49.842	\N
fc68e05c-79e3-491d-aa0c-6f1048bc756f	Felipe	Rios Gallardo		rigall_@hotmail.com	\N	\N		2025-05-03 20:50:49.842	2025-05-03 20:50:49.842	\N
ff05917d-6744-48c1-b3d0-320f16b84f70	Felipe	Rosales Rodríguez		\N	\N	1960-01-03 00:00:00		2025-05-03 20:50:49.842	2025-05-03 20:50:49.842	\N
c690daa1-e5f6-456b-ba87-ee128ea1cef0	Felipe alfonzo	Flores Arevalo		femiantos_64@hotmail.com	\N	1964-05-19 00:00:00		2025-05-03 20:50:49.843	2025-05-03 20:50:49.843	\N
4fe25f23-b5cf-42a3-9abc-a33e4a77c8d6	Felipe de Jesus	Barrera Moreno		wiphy_86@hotmail.com	\N	1986-08-08 00:00:00		2025-05-03 20:50:49.843	2025-05-03 20:50:49.843	\N
ef366d79-1dec-495a-965a-66e631a73b23	Felipe de Jesús	Becerra Ramirez		fejebera@hotmail.ocm	\N	1977-07-12 00:00:00		2025-05-03 20:50:49.843	2025-05-03 20:50:49.843	\N
8807da58-28f6-412a-9398-f55d09a89c7a	Felipe de Jesus	Orosco García		forozco_garcia@hotmail.com	\N	1967-02-05 00:00:00		2025-05-03 20:50:49.843	2025-05-03 20:50:49.843	\N
6ade2b56-331c-437a-b6ad-9cf9d708d97d	Felipe Román	Ortega Castillon		ortegacastilon@hotmail.com	\N	1993-10-07 00:00:00		2025-05-03 20:50:49.844	2025-05-03 20:50:49.844	\N
e73d8907-3c42-4f1a-addb-b9cb108f0b95	Estefania	Cruz Rios		\N	8714007536	\N		2025-05-03 20:50:49.844	2025-05-03 20:50:49.844	\N
9dddfc87-000c-45e6-a576-2f8be6ddd222	Felisa	Reyes Lira		\N	\N	1977-10-27 00:00:00		2025-05-03 20:50:49.844	2025-05-03 20:50:49.844	\N
bd316088-4e48-4d4e-b701-19694853b1da	Felix	Radilla Ochoa		\N	\N	1982-03-19 00:00:00		2025-05-03 20:50:49.845	2025-05-03 20:50:49.845	\N
ee537fdf-d665-40ba-9e9a-9a8cc19e0ec4	Felix Alberto	Prieto Jaramillo		ing.albertojaramillo@hotmail.com	\N	1989-07-20 00:00:00		2025-05-03 20:50:49.845	2025-05-03 20:50:49.845	\N
88b2bce7-2ce8-4161-a5ff-7988266089d6	Felix Fernando	Flores Beltran		\N	\N	\N		2025-05-03 20:50:49.846	2025-05-03 20:50:49.846	\N
dae5c511-66d5-44d0-834e-d63b79b20d0a	Felix Giovani	Gutierrez Avalos		\N	\N	\N		2025-05-03 20:50:49.846	2025-05-03 20:50:49.846	\N
a420caab-9928-4080-926b-ba6c85e21977	Felix Gregorio	De Dios Tobar		gregdedios@gmail.com	\N	\N		2025-05-03 20:50:49.846	2025-05-03 20:50:49.846	\N
1ed757c6-a607-4c27-9c66-d751cba9c3ea	Fernanda	Davila Torres		\N	\N	1988-05-30 00:00:00		2025-05-03 20:50:49.847	2025-05-03 20:50:49.847	\N
80b814dc-14ae-4746-801a-5272974f44d8	Fernanda	Gonzales Granados		\N	3222240547	2010-07-16 00:00:00		2025-05-03 20:50:49.847	2025-05-03 20:50:49.847	\N
1ff600ee-96e0-49f2-ab6a-1d8ea185b95e	Estela	Arias Cordova		\N	3222014703	\N		2025-05-03 20:50:49.847	2025-05-03 20:50:49.847	\N
e69d5f21-984a-4326-b7ad-79a787c3d879	Fernanda	Huerta Albarran		\N	\N	2009-11-05 00:00:00		2025-05-03 20:50:49.847	2025-05-03 20:50:49.847	\N
75366506-1d5e-4dc8-9889-107817ede608	fernanda	jimenez		\N	\N	2006-05-02 00:00:00		2025-05-03 20:50:49.848	2025-05-03 20:50:49.848	\N
0ebdf403-dd9c-478c-b875-33bb827fc18f	Fernanda	López Escalante		ferlopz02@gmail.com	\N	2002-09-26 00:00:00		2025-05-03 20:50:49.848	2025-05-03 20:50:49.848	\N
eb36372c-031f-47d8-90b2-d80a7c6ae8db	Fernanda	Oseguera Navarro		dofacturas@live.com	\N	\N		2025-05-03 20:50:49.848	2025-05-03 20:50:49.848	\N
654887c7-ba2f-4628-8c10-e2e41a89cf19	Estela	Aréas Cordova		\N	3222014703	1952-10-03 00:00:00		2025-05-03 20:50:49.849	2025-05-03 20:50:49.849	\N
b5ef578a-225c-496d-97bc-a60938cbb110	Federico	Ruck		\N	3221573982	\N		2025-05-03 20:50:49.849	2025-05-03 20:50:49.849	\N
f1320373-6843-4256-9583-26cbb7ef9fec	Fernanda	Rabasa Beurang		\N	\N	2009-01-06 00:00:00		2025-05-03 20:50:49.849	2025-05-03 20:50:49.849	\N
7a3406a9-dfa8-4f3b-80af-fab42802a3c8	Eugenio	Agustino		\N	3223441798	\N		2025-05-03 20:50:49.85	2025-05-03 20:50:49.85	\N
3e5b57a6-7fff-4133-8fdc-280ed3d9c7fd	Facundo Gabriel	Mastroberardino		facundomastro@gmail.com	+529841040733	1991-05-15 00:00:00		2025-05-03 20:50:49.85	2025-05-03 20:50:49.85	\N
a92bab41-ef63-478a-92bb-8f8dc4b7b35b	Erika Karina	Quezada Rojo		\N	3221806578	\N		2025-05-03 20:50:49.85	2025-05-03 20:50:49.85	\N
a0a906c1-27a8-404b-9cb3-e2d069d7258a	Fatima	Negrete Benítez		\N	3221750026	\N		2025-05-03 20:50:49.851	2025-05-03 20:50:49.851	\N
be4a56ee-4f2d-4495-8da8-e1f5a7d1e4d0	Fabian	Lopez Castillo		\N	3223276966	\N		2025-05-03 20:50:49.851	2025-05-03 20:50:49.851	\N
429f980b-9ef0-466a-99fb-2488e3bb946b	Fernando	Anciola Echavarria		anciolaf@yahoo.com	\N	1959-08-09 00:00:00		2025-05-03 20:50:49.851	2025-05-03 20:50:49.851	\N
be9a5a70-562b-42e5-bf2b-335f725d31e5	Fernando	Arjona Mercado		\N	\N	\N		2025-05-03 20:50:49.852	2025-05-03 20:50:49.852	\N
64e8254b-fc86-4532-8d4a-bd441948fc65	Fernando	Diaz Machuca		\N	\N	\N		2025-05-03 20:50:49.852	2025-05-03 20:50:49.852	\N
b7446164-d854-4961-b121-0cb5d81e0bf0	Fernando	Fonseca Gasca		\N	\N	1976-01-14 00:00:00		2025-05-03 20:50:49.852	2025-05-03 20:50:49.852	\N
85ae1607-336a-418e-a8e4-03708fbd5097	Fernando	Garcia Hernandez		\N	\N	\N		2025-05-03 20:50:49.853	2025-05-03 20:50:49.853	\N
7966e955-b6e0-4b8c-a274-edb3c611562c	Fernando	Gomez Alvarez		\N	\N	2007-11-26 00:00:00		2025-05-03 20:50:49.853	2025-05-03 20:50:49.853	\N
a68d45d7-7228-42ce-83e1-5458174963b9	Garbiel	Soto Castañeda		\N	3221358693	\N		2025-05-03 20:50:49.912	2025-05-03 20:50:49.912	\N
ffbdf751-ddf1-4ffb-b3e4-3159450e4926	Fernanda Nathalie	Cortes Palacios		lizetthpalacios7@gmail.com	+523221351642	\N		2025-05-03 20:50:49.853	2025-05-03 20:50:49.853	\N
cf6784ae-c77c-48c2-a25b-c11200e46061	Federica	Gradoli		\N	3224708051	\N		2025-05-03 20:50:49.854	2025-05-03 20:50:49.854	\N
8d7bb075-2eeb-4766-b5d9-d68bb9829956	Fernando	Lopez Cortez		sergioferlocs63@gmail.com	\N	1962-07-06 00:00:00		2025-05-03 20:50:49.854	2025-05-03 20:50:49.854	\N
269e8984-2f66-4b7a-8ae2-5b4572fab447	Fernando	Moreno Yañez		fernandomoreno208@gmail.com	\N	1985-01-02 00:00:00		2025-05-03 20:50:49.854	2025-05-03 20:50:49.854	\N
cbdbc960-e09c-42cd-b8a0-8fe0b028cd5b	Fernando	Peña Medina		\N	\N	1998-04-08 00:00:00		2025-05-03 20:50:49.855	2025-05-03 20:50:49.855	\N
4e002f79-b640-4b98-b09f-fa4e6e20773b	Fabriccio	Ramos Guereero		fa.briz@hotmail.com	4781070685	\N		2025-05-03 20:50:49.855	2025-05-03 20:50:49.855	\N
32259db3-5aa2-4761-80c4-1ea9cb64755f	Fernando	Ramírez		maluckpepe@hotmail.com	\N	1970-05-21 00:00:00		2025-05-03 20:50:49.856	2025-05-03 20:50:49.856	\N
eefc0c70-35e8-476c-a9d0-22ed3c51d656	Fernando	Rodriguez Vega		fernandorove@prodigy.net.mx	\N	1955-04-14 00:00:00		2025-05-03 20:50:49.856	2025-05-03 20:50:49.856	\N
cdc1c862-ae82-4792-a23e-bb03d3a7494a	Fernando	Villa Stoppelli		\N	\N	1973-06-19 00:00:00		2025-05-03 20:50:49.856	2025-05-03 20:50:49.856	\N
28e0fbc6-8e84-4c4b-b241-fb891402f322	Fernando Vladimir	Gonzlez Busambra		\N	\N	2010-11-17 00:00:00		2025-05-03 20:50:49.857	2025-05-03 20:50:49.857	\N
31765d78-f6d5-49dc-9c9e-18cafaa96745	Fidel	Franco Calderon		\N	\N	1975-09-20 00:00:00		2025-05-03 20:50:49.857	2025-05-03 20:50:49.857	\N
482b7182-40a4-44fa-9420-af7af46dd04b	Fidela	Arias Miramontes		\N	\N	1982-05-21 00:00:00		2025-05-03 20:50:49.857	2025-05-03 20:50:49.857	\N
606de5eb-8dc1-49cc-aa36-3e45be0c8917	Fidela	Barranco Lopez		\N	\N	1963-07-31 00:00:00		2025-05-03 20:50:49.858	2025-05-03 20:50:49.858	\N
9409ec80-b54a-461a-af86-c2c298a3d403	Fidela	Novoa		\N	\N	1986-10-05 00:00:00		2025-05-03 20:50:49.858	2025-05-03 20:50:49.858	\N
0e145298-94ef-496b-b853-63d864935d64	Fidencio	Orbe Antolino		forbe16@gmail.com	\N	1963-11-16 00:00:00		2025-05-03 20:50:49.858	2025-05-03 20:50:49.858	\N
32a4e691-37e2-4c47-8460-bd5ce58d41d6	Filadelfia	Valdovino Bello		\N	\N	1971-12-20 00:00:00		2025-05-03 20:50:49.859	2025-05-03 20:50:49.859	\N
c5f21001-d4ec-4602-8c50-d0ff50ac0dd4	Filadelphia	Valdovinos Bello		\N	\N	\N		2025-05-03 20:50:49.859	2025-05-03 20:50:49.859	\N
bfd897d2-6033-44ca-889b-67a28c9b4a3b	Filiberto	Alvarez Lozoya		fililozoya@hotmail.com	\N	1965-10-29 00:00:00		2025-05-03 20:50:49.859	2025-05-03 20:50:49.859	\N
7507f038-d740-4ec1-b200-ad9debcd8844	Fiona	Brawn		\N	\N	\N		2025-05-03 20:50:49.86	2025-05-03 20:50:49.86	\N
ed0d889f-4219-4551-877e-d677ccf5de21	Flavio	Cocho Urcini		\N	\N	\N		2025-05-03 20:50:49.86	2025-05-03 20:50:49.86	\N
b199a164-de06-4988-88bc-f61b56ced56f	Flavio	Escudero Ignacio		\N	\N	\N		2025-05-03 20:50:49.86	2025-05-03 20:50:49.86	\N
e38bf200-4f95-4cc5-8ecb-47a1e12fa1e2	Flor (Ragnhild)	Paus		ragnhildskaugepaus@gmail.com	\N	1991-02-23 00:00:00		2025-05-03 20:50:49.861	2025-05-03 20:50:49.861	\N
e14fb06f-74e0-4c62-923f-30cb0d873383	Flor Aide	Rodríguez López		pebelsb2a@hotmail.com	\N	1989-09-17 00:00:00		2025-05-03 20:50:49.861	2025-05-03 20:50:49.861	\N
74c5532e-c9be-440a-ba8f-6b0e52f4bb2f	Flor Alicia	Arriola Mata		\N	\N	2000-02-09 00:00:00		2025-05-03 20:50:49.861	2025-05-03 20:50:49.861	\N
d8d511c5-6a80-4d8f-9a3a-9c4bb45f9f7f	Flor Anadeli	Magallon de la Paz		\N	\N	1990-12-31 00:00:00		2025-05-03 20:50:49.862	2025-05-03 20:50:49.862	\N
f55fa074-4c1a-4a30-a6a8-12e7b7e97a7c	Flor Belem	León Escobedo		pucca52garu@hotmail.com	3223289791	1998-09-17 00:00:00		2025-05-03 20:50:49.862	2025-05-03 20:50:49.862	\N
8cc8e7c4-bd49-446f-a936-4ece02fbed1f	FELIPE	ARECHIGA GOMEZ		felipe_arechiga288@hotmail.com	+523224297308	\N		2025-05-03 20:50:49.862	2025-05-03 20:50:49.862	\N
87c703a8-7809-4a40-a435-841438978dd2	Felipe Silvestre	Martinez Ortega		\N	3221020342	\N		2025-05-03 20:50:49.863	2025-05-03 20:50:49.863	\N
79d723ef-f0f7-42aa-8538-bb255665cbb3	Flor Sarahi	López Ramírez		dragonandsofy@gmail.com	\N	2014-06-12 00:00:00		2025-05-03 20:50:49.863	2025-05-03 20:50:49.863	\N
7f76967b-706c-444f-a3a4-a85b5a20c0fd	Flora	Abel		danzainfinita@live.com.ar	\N	1979-09-08 00:00:00		2025-05-03 20:50:49.863	2025-05-03 20:50:49.863	\N
b6264aa2-8a0b-48aa-83cc-ea2bf6fcf3b3	Florencia	Cortéz		\N	\N	1939-01-01 00:00:00		2025-05-03 20:50:49.864	2025-05-03 20:50:49.864	\N
2ad3ee2a-78e3-4607-93a8-b62d3042a62c	Florencia  Karla	Ortube		\N	\N	1972-08-24 00:00:00		2025-05-03 20:50:49.864	2025-05-03 20:50:49.864	\N
08490084-fef2-4da7-a763-7064671ab326	Florentina	Cruz Lozano		\N	\N	1964-09-11 00:00:00		2025-05-03 20:50:49.864	2025-05-03 20:50:49.864	\N
1a59e904-a82e-47b9-b96d-a2c331eb2d27	Florentina	Torres Uriel		\N	\N	\N		2025-05-03 20:50:49.865	2025-05-03 20:50:49.865	\N
15c8ba99-4f03-4ed1-9af7-2e6fd00c3248	Florentino	Guillen Rúiz		\N	\N	2010-11-20 00:00:00		2025-05-03 20:50:49.865	2025-05-03 20:50:49.865	\N
1d496537-f8a1-47a2-8c8b-8fe65b28bf83	Florentino	Ruiz Palomera		\N	\N	1960-05-14 00:00:00		2025-05-03 20:50:49.865	2025-05-03 20:50:49.865	\N
3870445a-4eee-4d1b-bacb-12598d7c31db	Foca	Coca Cola		\N	\N	2005-10-08 00:00:00		2025-05-03 20:50:49.866	2025-05-03 20:50:49.866	\N
7ddb7ee3-755b-4de0-81e5-68d8c4f4c097	Felipa	Orozco Rojo		\N	3221189979	\N		2025-05-03 20:50:49.866	2025-05-03 20:50:49.866	\N
24137540-8a23-47e7-9554-a07000170895	France	Minguy		\N	\N	\N		2025-05-03 20:50:49.866	2025-05-03 20:50:49.866	\N
3a9aad22-874b-43c5-afb4-ec2824d76ab6	Francine	Angers		francinette46@gmail.com	\N	1946-06-07 00:00:00		2025-05-03 20:50:49.867	2025-05-03 20:50:49.867	\N
18982a6a-7826-49f5-88c4-d781d1f146da	Francine	Deblois		\N	\N	\N		2025-05-03 20:50:49.867	2025-05-03 20:50:49.867	\N
ad36b792-be67-49bd-aa42-91f5fd326fd5	Francine	Duchesne		duchesnefrancine@hotmail.com	\N	1955-01-31 00:00:00		2025-05-03 20:50:49.867	2025-05-03 20:50:49.867	\N
6df76f10-667d-4e98-aa4f-81759d14c810	Francis	Deblois		debloisfrancine@yahoo.fr.	\N	1948-04-25 00:00:00		2025-05-03 20:50:49.868	2025-05-03 20:50:49.868	\N
b9ff1166-8526-4013-b777-5d1312d9ffff	Francisco	Alonzo  Nuñez		\N	\N	1941-06-04 00:00:00		2025-05-03 20:50:49.868	2025-05-03 20:50:49.868	\N
93c0f2b3-d277-4892-9a56-e7fcce126415	Francisco	Arias		\N	\N	2011-02-09 00:00:00		2025-05-03 20:50:49.868	2025-05-03 20:50:49.868	\N
18c76fd2-d1a3-4578-8f91-3ea980fcd743	Francisco	Bayardo Brambila		zonaescolar152@gmail.com	\N	1948-05-28 00:00:00		2025-05-03 20:50:49.869	2025-05-03 20:50:49.869	\N
33a37b69-4fc7-4e9c-bca6-71597b43b9b8	Francisco	Benito		\N	\N	1933-03-03 00:00:00		2025-05-03 20:50:49.869	2025-05-03 20:50:49.869	\N
0695ab2b-5af2-44d3-9ca2-c7ff69105bed	Francisco	Canizo Falcón		\N	\N	1970-04-24 00:00:00		2025-05-03 20:50:49.869	2025-05-03 20:50:49.869	\N
92dd6e69-cc77-41cc-b579-64da75c0957c	Francisco	Casillas		\N	\N	\N		2025-05-03 20:50:49.87	2025-05-03 20:50:49.87	\N
8df3cc6f-28f8-4cd3-889c-7bae8c799f71	Francisco	Esquivel Alanis		\N	\N	\N		2025-05-03 20:50:49.87	2025-05-03 20:50:49.87	\N
53357ec4-5fc4-4382-8c07-55fe040b3312	Esthefanie	Villalpando Magaña		\N	3223782808	\N		2025-05-03 20:50:49.87	2025-05-03 20:50:49.87	\N
3a97f45a-3650-4fd9-a897-e2965dd0d15d	Francisco	Gómez Galván		\N	\N	1997-12-18 00:00:00		2025-05-03 20:50:49.871	2025-05-03 20:50:49.871	\N
844b5718-a52c-4b77-b213-fd76e5f83b52	Francisco	Granados Pérez		\N	\N	1983-07-15 00:00:00		2025-05-03 20:50:49.871	2025-05-03 20:50:49.871	\N
478f8613-2754-4a04-9ad0-f0b9e77a869a	Francisco	Lepe Fisher		\N	\N	1965-06-13 00:00:00		2025-05-03 20:50:49.871	2025-05-03 20:50:49.871	\N
e3aa6896-5495-40d2-af61-b888e9617b91	Francisco	Lugos Martinez		\N	\N	1939-12-03 00:00:00		2025-05-03 20:50:49.872	2025-05-03 20:50:49.872	\N
564bc17d-60df-4ae2-93a6-a20a7af404e9	Francisco	Mireles		fmirce@gmail.com	\N	1979-03-22 00:00:00		2025-05-03 20:50:49.872	2025-05-03 20:50:49.872	\N
a34a79d8-1584-4351-b917-7884c517063c	Francisco	Morales		\N	\N	\N		2025-05-03 20:50:49.872	2025-05-03 20:50:49.872	\N
e5d6e84d-915a-42fa-be5f-2bdff49f9a05	Fran	Goulet		\N	3223700996	\N		2025-05-03 20:50:49.872	2025-05-03 20:50:49.872	\N
47d1ca1b-0ebb-475a-9c8d-2cc09ffdc79f	Fernanda	Gonzalez		\N	3222753233	\N		2025-05-03 20:50:49.873	2025-05-03 20:50:49.873	\N
c4425dcc-02e1-4369-919c-3346215ecb65	Francisco	Torres García		yosoyecorex@hotmail.com	\N	1983-08-02 00:00:00		2025-05-03 20:50:49.873	2025-05-03 20:50:49.873	\N
5a53c48a-f57a-4c6e-bcf5-8a1c832eea08	Francisco Aaron	Moreno Cervantes		\N	\N	\N		2025-05-03 20:50:49.873	2025-05-03 20:50:49.873	\N
829fe58a-f9ec-4f75-b0ee-9e0fb5607215	Francisco Alberto	Montalvo Campos.		\N	\N	2004-12-13 00:00:00		2025-05-03 20:50:49.874	2025-05-03 20:50:49.874	\N
a849bb2e-450c-4f0b-a69d-d2dba31786a3	Francisco Andres	Alvarez Sandoval		andru932711@gmai.com	\N	1993-11-27 00:00:00		2025-05-03 20:50:49.874	2025-05-03 20:50:49.874	\N
213bcb7e-6857-4ac7-a4e7-27f6c7db0e55	Fernanda Abigail	Cibrian  Magaña		\N	3339683092	\N		2025-05-03 20:50:49.874	2025-05-03 20:50:49.874	\N
5d5d6020-e675-4f26-b751-38c8d03b8e2e	Francisco Giovani	Figueroa  Alvarado		\N	\N	\N		2025-05-03 20:50:49.875	2025-05-03 20:50:49.875	\N
af9da59a-6a11-489a-95b4-c220658cf53f	Francisco Isaias	Quezada Morales		\N	\N	2008-01-15 00:00:00		2025-05-03 20:50:49.875	2025-05-03 20:50:49.875	\N
464187b2-1172-461b-b67a-3d89982e0c2d	Francisco Javie	Flores Fuentes		\N	\N	2007-08-09 00:00:00		2025-05-03 20:50:49.876	2025-05-03 20:50:49.876	\N
9924065b-3a3c-4e63-87ea-f80101e6f2a6	Francisco Javier	Arenas Quijjano		\N	\N	1978-09-22 00:00:00		2025-05-03 20:50:49.876	2025-05-03 20:50:49.876	\N
d25c633d-c933-4f9a-888e-91d1bd80a2ae	Francisco Javier	Garrido Hernadez		\N	3221087223	1972-01-15 00:00:00		2025-05-03 20:50:49.876	2025-05-03 20:50:49.876	\N
ce63d43a-33c8-4245-beeb-994f88052be4	Francisco Javier	Jacinto López		\N	\N	2009-03-06 00:00:00		2025-05-03 20:50:49.877	2025-05-03 20:50:49.877	\N
df25722c-bca8-49d1-92e7-04e9e54332d8	Fernanda Natali	Cortes		\N	3221351642	\N		2025-05-03 20:50:49.877	2025-05-03 20:50:49.877	\N
f1cfccec-a983-430e-b223-112149878345	Francisco Javier	Madrueño Venegas		\N	3221140185	1962-09-23 00:00:00		2025-05-03 20:50:49.877	2025-05-03 20:50:49.877	\N
c8b8b1b2-a35d-4dee-9f99-a3a14a5a7d53	Francisco Javier	Moreno Andrade		thewalevallarta@hotmail.com	\N	1956-11-11 00:00:00		2025-05-03 20:50:49.878	2025-05-03 20:50:49.878	\N
e82967af-6286-4640-8cf9-b8db7efaaa52	Francisco Javier	Robles Cuevas		javi25robles@gmail.com	\N	1989-04-29 00:00:00		2025-05-03 20:50:49.878	2025-05-03 20:50:49.878	\N
6f94b6ee-1b6c-42bc-a11f-f063b0852b8a	Francisco Jesus	Juarez Memije		\N	\N	\N		2025-05-03 20:50:49.878	2025-05-03 20:50:49.878	\N
906127ef-e733-4634-babe-b3d66e11584a	Fernanda	Peña		fernanda_anything@hotmail.com	+523222634173	\N		2025-05-03 20:50:49.878	2025-05-03 20:50:49.878	\N
e971db80-db08-4ac5-acb9-27f118b4b8eb	Franck	Hinckfuss		franck@idigraf.net	\N	1970-01-07 00:00:00		2025-05-03 20:50:49.879	2025-05-03 20:50:49.879	\N
fd8c7ec7-68ca-44ca-bdb4-bde38cdfe614	Franck	Stilson		franckstilson@rogers.com	\N	1947-09-01 00:00:00		2025-05-03 20:50:49.879	2025-05-03 20:50:49.879	\N
0a50ec41-9d4d-42f4-989c-3ceca3e6fa56	Francklin Abel	Pilado Orozco		\N	\N	1986-07-06 00:00:00		2025-05-03 20:50:49.88	2025-05-03 20:50:49.88	\N
f0920fd1-e258-4588-9b07-9e544792ede3	Franco	Demichelis		\N	3221502393	1970-02-24 00:00:00		2025-05-03 20:50:49.88	2025-05-03 20:50:49.88	\N
6fad78ee-ccea-40f6-95e0-82ecc131ea30	Franco	Demiquellis		\N	3221502393	\N		2025-05-03 20:50:49.88	2025-05-03 20:50:49.88	\N
15d3fab6-78ec-4546-b7ff-4cfc7e845102	Fernanda Nattalie	Cortéz Palacios		\N	3221351642	\N		2025-05-03 20:50:49.881	2025-05-03 20:50:49.881	\N
76f8c61e-f371-4a20-8ad8-f1fc06d8038b	Fernández Abigail	Cibrian Magaña		\N	3339683092	\N		2025-05-03 20:50:49.881	2025-05-03 20:50:49.881	\N
36660211-42d2-418f-9e1f-fb6ee815167c	Frederic	Beaudry		\N	\N	1985-07-23 00:00:00		2025-05-03 20:50:49.881	2025-05-03 20:50:49.881	\N
07591823-62f0-43f8-98d5-d484ad1bfda6	Frida	Morales Barron		lipocosmetic@gmail.com	3310917572	2003-09-23 00:00:00		2025-05-03 20:50:49.882	2025-05-03 20:50:49.882	\N
3aee75a5-802f-4efa-ab21-788a11f6b676	Frida	Sanchez Hernandez		\N	\N	2000-04-29 00:00:00		2025-05-03 20:50:49.882	2025-05-03 20:50:49.882	\N
2109bf99-2a86-40c3-950f-f729493c6061	Frida Livier	Flores Hernandez		fridalivier@gmail.com	\N	1999-04-24 00:00:00		2025-05-03 20:50:49.882	2025-05-03 20:50:49.882	\N
9e44c15d-62b9-4d8e-bfd6-9cdfc32846fa	Frida Teresa	Lesama Morales		friida.lesama@hotmail.com	\N	1992-07-29 00:00:00		2025-05-03 20:50:49.883	2025-05-03 20:50:49.883	\N
6411f692-832b-4cc4-ae2b-17cd3ddaff02	Ftanck	Presiado SanAgustin		\N	\N	2007-03-26 00:00:00		2025-05-03 20:50:49.883	2025-05-03 20:50:49.883	\N
8eb928be-73f3-49a7-8d9c-6561dc91a415	Gabino	Delgado Gonzales		gabino_345@hotmail.com	3292980696	1968-10-25 00:00:00		2025-05-03 20:50:49.883	2025-05-03 20:50:49.883	\N
ff6cc133-228c-4e17-8ff3-c615f9b5622f	Gabino	Hernandez Mendez		\N	\N	\N		2025-05-03 20:50:49.883	2025-05-03 20:50:49.883	\N
1546f353-cad6-4b8c-9857-d64cc2edfee0	Gabino	Mencez Sanchéz		\N	\N	1981-12-24 00:00:00		2025-05-03 20:50:49.884	2025-05-03 20:50:49.884	\N
ef9c71b4-2572-454d-964f-39cc2092a566	Gabriel	Arancibia Olvera		\N	\N	1985-08-06 00:00:00		2025-05-03 20:50:49.884	2025-05-03 20:50:49.884	\N
da735bbb-5b38-450a-9827-e5c467fcb4b7	Gabriel	Conrriquez Contreras		\N	+14088076283	1954-07-05 00:00:00		2025-05-03 20:50:49.884	2025-05-03 20:50:49.884	\N
514f8694-1174-4bea-8ebe-474b1be10962	Francisco Eduardo	Gonzalez Hernandezez		\N	3223696872	\N		2025-05-03 20:50:49.885	2025-05-03 20:50:49.885	\N
d7d43a30-501d-4d11-bd29-49503e763b56	Gabriel	García Fregoso		gabynoa_64@hotmail.com	\N	1964-05-24 00:00:00		2025-05-03 20:50:49.885	2025-05-03 20:50:49.885	\N
d72bf068-0d5d-47ec-83a1-af0f1b97d3f3	Gabriel	Guzman		\N	\N	2005-03-30 00:00:00		2025-05-03 20:50:49.885	2025-05-03 20:50:49.885	\N
800674be-303b-4dba-8b63-a3d85c40b0dc	Gabriel	Ostin		\N	\N	1955-09-12 00:00:00		2025-05-03 20:50:49.886	2025-05-03 20:50:49.886	\N
ec57712f-0c95-4605-b3fa-fcfe8cec028c	Gabriel	Saldaña Velazco		\N	\N	1971-09-28 00:00:00		2025-05-03 20:50:49.886	2025-05-03 20:50:49.886	\N
0bd465be-8f57-432e-941b-85cb07d35dcb	Fred	Meyer		\N	+12064783733	\N		2025-05-03 20:50:49.886	2025-05-03 20:50:49.886	\N
b5262d4a-6a4f-45fb-9cea-75748191c3a0	Gabriel	Vazquéz Rodríguez		\N	\N	2007-05-17 00:00:00		2025-05-03 20:50:49.887	2025-05-03 20:50:49.887	\N
1cde350e-5f10-4a93-8801-ba2171c62511	Gabriel	Zepeda   Perez		\N	\N	\N		2025-05-03 20:50:49.887	2025-05-03 20:50:49.887	\N
e42a38ad-8cea-4d9a-a7da-3714a69909a3	Gabriela	Alvarado Briseño		arq.gabm@gmail.com	\N	1987-08-20 00:00:00		2025-05-03 20:50:49.887	2025-05-03 20:50:49.887	\N
51cd077b-0d27-48b3-af8e-d64c39de6f78	Gabriela	Arechiga		\N	\N	\N		2025-05-03 20:50:49.888	2025-05-03 20:50:49.888	\N
71799a5b-eb8e-400e-9b2f-fcc5310502f9	Gabriela	Arellano García		\N	\N	1980-08-12 00:00:00		2025-05-03 20:50:49.888	2025-05-03 20:50:49.888	\N
20889c17-9fe0-46e9-bd48-355bde2935da	GABRIELA	AUSTIN		\N	\N	\N		2025-05-03 20:50:49.888	2025-05-03 20:50:49.888	\N
d71da90f-9019-4c8d-b769-ab870e47b54d	Gabriela	Colin Cardin		gabicolin@yahoo.com.mx	\N	1975-03-24 00:00:00		2025-05-03 20:50:49.889	2025-05-03 20:50:49.889	\N
d207bdaf-fee2-4a46-a0c2-524ef24adeda	Gabriela	Escalante Cota		\N	\N	1981-11-10 00:00:00		2025-05-03 20:50:49.889	2025-05-03 20:50:49.889	\N
8de49f9c-910c-447f-a67e-1bfc34dedeaf	Gabriela	Guerrero Villegas		\N	\N	\N		2025-05-03 20:50:49.889	2025-05-03 20:50:49.889	\N
aec9ee7c-14fb-4306-a3be-549eed049645	Gabriela	Hernandez Monje		gabrielahdznv@gmail.com	\N	1992-02-09 00:00:00		2025-05-03 20:50:49.89	2025-05-03 20:50:49.89	\N
c6466cf8-d16a-4197-bd84-1411792e48fa	Gabriela	Iturbe Garcìa		\N	\N	2006-01-30 00:00:00		2025-05-03 20:50:49.89	2025-05-03 20:50:49.89	\N
7b9b0ea7-02ed-4d45-856f-cfaa3e1408b1	Gabriela	Jaxiola		\N	\N	2011-03-24 00:00:00		2025-05-03 20:50:49.89	2025-05-03 20:50:49.89	\N
f2272517-9fb1-4c78-92bf-2b289483250a	Gabriela	Lascano Vàzquez		\N	\N	1961-03-17 00:00:00		2025-05-03 20:50:49.891	2025-05-03 20:50:49.891	\N
c56fad53-57de-4a35-a13b-ea27f8192012	Gabriela	Lopez Andalon		\N	\N	1977-09-17 00:00:00		2025-05-03 20:50:49.891	2025-05-03 20:50:49.891	\N
0904554b-a2ac-4acb-b6ae-577f7f59bd06	Gabriela	López Gonzàlez		\N	\N	1968-01-01 00:00:00		2025-05-03 20:50:49.891	2025-05-03 20:50:49.891	\N
c5bb3810-5ff7-4345-a9d2-dbe068e97a34	Gabriela	Medína Robles		gabymedina111@hotmail.com	3314115174	1978-04-05 00:00:00		2025-05-03 20:50:49.892	2025-05-03 20:50:49.892	\N
4d161044-92f4-4785-8247-bfab30d6d7e3	Fernando	Limon Velazquez		\N	3325545625	\N		2025-05-03 20:50:49.892	2025-05-03 20:50:49.892	\N
9fb4b606-bb3f-42b8-9970-4d6b719f740d	Gabriela	Peña Aceves		gabriela_pv@yahoo.com	\N	1967-01-02 00:00:00		2025-05-03 20:50:49.892	2025-05-03 20:50:49.892	\N
af0dc753-31ac-4c19-8f5d-d2631ef90fd5	fernando	Gonzalez Contreras		fernando.gonzalez@jetcabomx.com	+526241578743	\N		2025-05-03 20:50:49.893	2025-05-03 20:50:49.893	\N
3f9d348e-e30d-426d-951e-17c8256f0c73	Gabriela	Rodriguez		gabrielapretty87@hotmail.com	\N	1987-03-07 00:00:00		2025-05-03 20:50:49.893	2025-05-03 20:50:49.893	\N
d190e50a-e8bf-4ece-8878-d2bc3fcaa904	Gabriela	Sanchez Mendoza		\N	\N	\N		2025-05-03 20:50:49.893	2025-05-03 20:50:49.893	\N
12f8509d-5321-4e3e-8755-789fcbb0daf6	Gabriela	Sanchez Ramos		administracion@pavsa.mx	\N	1982-06-21 00:00:00		2025-05-03 20:50:49.894	2025-05-03 20:50:49.894	\N
ce606d3a-0ff1-40fb-aea7-d039776738ee	Gabriela	Saucedo Patlan		\N	\N	\N		2025-05-03 20:50:49.894	2025-05-03 20:50:49.894	\N
bfa97109-9f62-4f6f-b0c4-7b7dd4432bea	Gabriela	Yebra Marínez		yebragab13@gmail.com	\N	1985-07-01 00:00:00		2025-05-03 20:50:49.894	2025-05-03 20:50:49.894	\N
77433bdd-b86e-4dee-8d6a-21e6823f2242	Gabriela	Zepeda Figeroa		katalinna.18@gmail.com	\N	1967-05-18 00:00:00		2025-05-03 20:50:49.895	2025-05-03 20:50:49.895	\N
bca655f2-6ef8-4e53-b27d-0ddf61a88de7	Flor Mireya	Quintero Peña		\N	3222774904	\N		2025-05-03 20:50:49.895	2025-05-03 20:50:49.895	\N
357e24ad-3895-4e3f-8ea0-5e4509bd3d5b	Gabriela Mariana	Cruz Ochoa		\N	\N	2006-07-03 00:00:00		2025-05-03 20:50:49.896	2025-05-03 20:50:49.896	\N
8a56e532-c69a-4a8a-b57e-63d3a1f44ad5	Flor Monserrat	Alvarado  Añorve		\N	3221334176	\N		2025-05-03 20:50:49.896	2025-05-03 20:50:49.896	\N
11e69d27-e3fe-4651-8a8f-fa9106209f2f	Gaetane	Turgeon		gaetur@hotmail.com	\N	1953-10-31 00:00:00		2025-05-03 20:50:49.896	2025-05-03 20:50:49.896	\N
36597ce2-9976-49ee-a4b5-c831d582e027	Fernando	Perez Calderon		\N	6524135093	\N		2025-05-03 20:50:49.897	2025-05-03 20:50:49.897	\N
85849d7c-174c-49b7-aa61-22d8e4c9fb9d	Galilea	Paz Carrizales		\N	\N	2002-07-24 00:00:00		2025-05-03 20:50:49.897	2025-05-03 20:50:49.897	\N
5fc4c0a8-0285-4641-8f16-047a3aacf80e	Francisco	Perez Ruiz		\N	\N	\N		2025-05-03 20:50:49.897	2025-05-03 20:50:49.897	\N
3d553408-7463-44ed-8ae9-8c1b25ac8b73	Garbiela	Castrillon		\N	\N	\N		2025-05-03 20:50:49.898	2025-05-03 20:50:49.898	\N
f49c747a-913c-4a2f-b4d1-1c30c736bc1a	Garbiela	Zepeda Figueroa		\N	\N	2010-08-24 00:00:00		2025-05-03 20:50:49.898	2025-05-03 20:50:49.898	\N
9697d204-befc-4824-b9f3-6a41e79ec5ac	Francisco	Ramires Langarica		\N	3221086017	\N		2025-05-03 20:50:49.898	2025-05-03 20:50:49.898	\N
5e954493-4d59-4f42-9fde-f94428b84215	Gary	Holloway		\N	\N	\N		2025-05-03 20:50:49.898	2025-05-03 20:50:49.898	\N
1eb49994-4425-4035-8053-1a37a730eb71	Geisy	Salazar Henriquez		\N	\N	1987-06-02 00:00:00		2025-05-03 20:50:49.899	2025-05-03 20:50:49.899	\N
93d1069c-c2f5-4cb9-89e0-759351906b26	Gema	Garcia Arechiga		\N	\N	1967-03-23 00:00:00		2025-05-03 20:50:49.899	2025-05-03 20:50:49.899	\N
f151c6fd-4fc8-4cce-b84b-0361cc563738	Gema	Garcìa Peña		\N	\N	2009-12-07 00:00:00		2025-05-03 20:50:49.899	2025-05-03 20:50:49.899	\N
604e20f8-ac3a-4654-bd67-c97f7b7dfa4a	gema	romero		\N	\N	\N		2025-05-03 20:50:49.9	2025-05-03 20:50:49.9	\N
e98ac6ca-ab69-44d7-968c-c24406f0279e	Gema	Romero Silva		\N	3221143504	2015-03-31 00:00:00		2025-05-03 20:50:49.9	2025-05-03 20:50:49.9	\N
2fbf0464-e06f-4aa0-8445-05c133ba29a2	Franklin	Alvarez		\N	5652937349	\N		2025-05-03 20:50:49.9	2025-05-03 20:50:49.9	\N
d966a2b7-f90b-492a-8d16-54a09d2bc8e7	Genesis	Sandoval Luna		\N	\N	\N		2025-05-03 20:50:49.901	2025-05-03 20:50:49.901	\N
7fd4d168-0846-4a08-8d0b-1a6c76ef6517	Genobeba	Ascebes García		\N	\N	2006-06-22 00:00:00		2025-05-03 20:50:49.901	2025-05-03 20:50:49.901	\N
6555c41a-0f33-4d9b-8571-46a8ffa9a603	George	Chioros		chiorosg@yahoo.com	3221668209	1939-02-21 00:00:00		2025-05-03 20:50:49.901	2025-05-03 20:50:49.901	\N
76275f24-0e97-425a-8531-7352d9e14800	Georgena	Choros		\N	\N	\N		2025-05-03 20:50:49.902	2025-05-03 20:50:49.902	\N
0444be3d-0966-484e-8823-8e066e9aad36	Georgina	Almaraz Pérez		gina_ap@lycos.com	\N	1983-04-19 00:00:00		2025-05-03 20:50:49.902	2025-05-03 20:50:49.902	\N
9b66d3b2-2518-49fd-9296-f5aa22be499f	Georgina	Chioros		\N	\N	\N		2025-05-03 20:50:49.902	2025-05-03 20:50:49.902	\N
d91dbad1-075d-432c-8eed-858056893ac8	Fernanda	Panduro		fer.aide07@gmail.com	+523112415408	\N		2025-05-03 20:50:49.903	2025-05-03 20:50:49.903	\N
bc0cf8ef-7b1e-43c3-a645-07003d8ace69	Francisco Tadeo	Huidobro Medina		\N	3221018459	\N		2025-05-03 20:50:49.903	2025-05-03 20:50:49.903	\N
bab52e63-7277-4e1b-aeb0-ab24633c66d7	Georgina	Oliva		\N	\N	\N		2025-05-03 20:50:49.903	2025-05-03 20:50:49.903	\N
358c44ef-4911-4bb4-92f4-e25c1e42c302	Gabriel	De la rosa		gab2005derosa@gmail.com	+523223052202	\N		2025-05-03 20:50:49.903	2025-05-03 20:50:49.903	\N
e01e67f6-9554-4362-97df-2f34dc769672	Georgina	Ramirez Perez		\N	5561116155	\N		2025-05-03 20:50:49.904	2025-05-03 20:50:49.904	\N
22f1a10c-c9c8-403d-a596-efd6a9680e46	Gabriel	Soto castañeda		\N	3221358693	\N		2025-05-03 20:50:49.904	2025-05-03 20:50:49.904	\N
b9313a4e-93d8-44e4-baeb-85ea3100c332	Geovani	Flores Montes		joel8734@hotmail.com	\N	1986-01-12 00:00:00		2025-05-03 20:50:49.905	2025-05-03 20:50:49.905	\N
ad2ef18f-31e8-48d1-b4b4-dc0e062c9dcf	Gerado	Cruz Lopez		\N	\N	2010-01-21 00:00:00		2025-05-03 20:50:49.905	2025-05-03 20:50:49.905	\N
7aed4613-c068-40d7-90fd-fac4d7f966d5	Gerald Reimer	Kornelsen		\N	\N	\N		2025-05-03 20:50:49.906	2025-05-03 20:50:49.906	\N
5402d66f-3f82-45c1-b57f-0c03e15061df	Gerardo	García Fuentes		gerardo.garcia@universidad-une.com	\N	1969-10-30 00:00:00		2025-05-03 20:50:49.906	2025-05-03 20:50:49.906	\N
b3d10c5e-b639-4ce2-91e6-c32a422b6bd2	Francisco Javier	Lopez Morales		\N	3223214105	\N		2025-05-03 20:50:49.906	2025-05-03 20:50:49.906	\N
32335664-dd05-4b71-80ef-794e5138638e	Gerardo	GomezPeralta		\N	\N	2004-11-18 00:00:00		2025-05-03 20:50:49.907	2025-05-03 20:50:49.907	\N
5f335b78-0950-4b34-bb24-93e834aab35c	Gabriela	Palacios Cervantes		\N	3221486611	\N		2025-05-03 20:50:49.907	2025-05-03 20:50:49.907	\N
ea44274a-6056-4428-a47a-da12e96e0047	Gabriela	Ramcke		\N	3331799398	\N		2025-05-03 20:50:49.907	2025-05-03 20:50:49.907	\N
9da64cd3-de3d-410e-b762-c707fde79f49	Gerardo	Perez Silva		\N	\N	\N		2025-05-03 20:50:49.908	2025-05-03 20:50:49.908	\N
333acdf9-1ae3-4956-9321-481c22fd1c2f	Gerardo	Ramirez Castillo		arqgr@hotmail.com	\N	1964-09-12 00:00:00		2025-05-03 20:50:49.908	2025-05-03 20:50:49.908	\N
fbf89839-5a5c-4ba2-bc58-518ddecce99c	Gerardo	Ramirez Martinez		\N	\N	2008-08-21 00:00:00		2025-05-03 20:50:49.908	2025-05-03 20:50:49.908	\N
8768ce65-55db-4e4d-83d2-05a3f834b03c	Gabriela Betzabe	Sanchez Sierra		gbysan@gmail.com	+523221464617	\N		2025-05-03 20:50:49.908	2025-05-03 20:50:49.908	\N
f83c80ec-ab1b-4608-9741-fcab1f726d05	Gerardo Gael	Palomera Lara		\N	\N	2011-05-12 00:00:00		2025-05-03 20:50:49.909	2025-05-03 20:50:49.909	\N
181f4dad-ffef-409a-acc0-1f4f0837068a	Gerhardt	Wassermann		\N	\N	2010-05-24 00:00:00		2025-05-03 20:50:49.909	2025-05-03 20:50:49.909	\N
1831067c-c9ee-4e90-b576-c50c0e2d7dd8	German	Estrada Torres		\N	\N	\N		2025-05-03 20:50:49.909	2025-05-03 20:50:49.909	\N
f8171ee0-b26e-4a7a-b798-7989270a6784	German	Gonzalez Zarate		\N	3221923114	1998-12-30 00:00:00		2025-05-03 20:50:49.91	2025-05-03 20:50:49.91	\N
39cae8f8-6488-4236-9787-a0140678bafa	German	Martinez		gmartinez@krystal-hotels.com	\N	1958-12-26 00:00:00		2025-05-03 20:50:49.91	2025-05-03 20:50:49.91	\N
9bfbaa1f-2e80-4754-a542-befc844b8799	German	Romero Ornelas		germanyornelas@gmail.com	\N	1980-01-29 00:00:00		2025-05-03 20:50:49.91	2025-05-03 20:50:49.91	\N
a4a80338-3919-4710-bfe7-9fa16f445941	German	Ruíz Zuñiga		germanruiz1974@yahoo.com.mx	\N	1971-01-17 00:00:00		2025-05-03 20:50:49.911	2025-05-03 20:50:49.911	\N
7f8bd70b-cdcb-4ec4-8a70-c8a26a983ee6	German	Sanchez Tobar		\N	\N	1931-07-11 00:00:00		2025-05-03 20:50:49.911	2025-05-03 20:50:49.911	\N
41f7ae1a-9cfd-49e5-b0cb-da9e120dbac2	Galdino	García Salasar		\N	3223033769	\N		2025-05-03 20:50:49.911	2025-05-03 20:50:49.911	\N
84ea7dbf-ca0b-483a-8e9c-0b0d2de415f1	Gerrie	Laurent		hope55304@hotmail.com	\N	1945-12-12 00:00:00		2025-05-03 20:50:49.912	2025-05-03 20:50:49.912	\N
28a63aa3-256b-4db5-855b-bf85e06a376b	Gerson	Gonzales		\N	\N	\N		2025-05-03 20:50:49.912	2025-05-03 20:50:49.912	\N
3b19b1c6-f348-41d6-b5d9-3f2a045c765b	Gertrudis	Avila Përez		\N	\N	2009-12-21 00:00:00		2025-05-03 20:50:49.913	2025-05-03 20:50:49.913	\N
bbd44b85-ccc6-4f03-9e80-4637e0af68a2	Ghislain	Champange		champaen.ghis@gmail.com	\N	1952-06-18 00:00:00		2025-05-03 20:50:49.913	2025-05-03 20:50:49.913	\N
7f16001c-132d-4238-8909-cf4c093518be	Gia	DiBene Altamirano		gia.divene@gmail.com	\N	1989-03-24 00:00:00		2025-05-03 20:50:49.913	2025-05-03 20:50:49.913	\N
bdb63465-59cb-4593-938d-22e92744f154	Gil	Sccott		\N	\N	\N		2025-05-03 20:50:49.914	2025-05-03 20:50:49.914	\N
f84b2838-c2a4-4a6e-b9d4-6d6941554d07	Gil Mauricio	Rodriguez Garduño		\N	\N	2005-12-03 00:00:00		2025-05-03 20:50:49.914	2025-05-03 20:50:49.914	\N
117d167f-2259-4f1d-9797-2c7613c2acda	Gilberto	Gomez Camarena		\N	\N	2008-05-27 00:00:00		2025-05-03 20:50:49.914	2025-05-03 20:50:49.914	\N
9b5bac40-c719-497b-9f02-1b48ce9bf361	Gilberto	Maldonado Peña		\N	\N	2010-04-29 00:00:00		2025-05-03 20:50:49.915	2025-05-03 20:50:49.915	\N
6438c2f4-74e2-46f8-aa5c-ddd3ac86ed35	Gilberto	Ramírez Aquíno		gilraquino28@hotmail.com	\N	1985-02-03 00:00:00		2025-05-03 20:50:49.915	2025-05-03 20:50:49.915	\N
c1ec62c2-ca42-493a-b02e-58a3992d736a	Gile	Brwle		\N	\N	\N		2025-05-03 20:50:49.915	2025-05-03 20:50:49.915	\N
2ebff776-dc29-4626-bf4e-546e39df8970	Gilles	Gervais gilles		\N	\N	\N		2025-05-03 20:50:49.916	2025-05-03 20:50:49.916	\N
42825df1-6b8d-4fbf-8697-c467b66f9ab1	Gina Paola	Hernández Aguas		gina_pao26@hotmail.com	3292980419	1977-03-12 00:00:00		2025-05-03 20:50:49.916	2025-05-03 20:50:49.916	\N
73c1c7d9-4795-4892-a816-79171fc32cb1	Ginette	Roy		normandpoulin07@yahoo.ca	\N	1948-10-31 00:00:00		2025-05-03 20:50:49.916	2025-05-03 20:50:49.916	\N
5a576814-2ac2-4346-b32e-7190283a1df3	Giovana	Alvarez Calvillo		\N	3222256200	1989-11-30 00:00:00		2025-05-03 20:50:49.917	2025-05-03 20:50:49.917	\N
455d78c3-d866-47a9-bd64-00bcab77c48a	Giovana	Visona		\N	\N	1940-01-20 00:00:00		2025-05-03 20:50:49.917	2025-05-03 20:50:49.917	\N
3d3ba276-4d15-4907-b674-05c100ecfaa2	Georgina	Lopez		\N	3222788052	\N		2025-05-03 20:50:49.917	2025-05-03 20:50:49.917	\N
44ab4d0b-c780-4bc0-8ab6-8d524978b375	Giovanni	Becerra Ramirez		\N	\N	1982-09-09 00:00:00		2025-05-03 20:50:49.918	2025-05-03 20:50:49.918	\N
00a56e2b-8fb4-48da-8bef-17eba57047fc	Giovany	Lopez Vazquez		\N	\N	1985-09-30 00:00:00		2025-05-03 20:50:49.918	2025-05-03 20:50:49.918	\N
382c65a5-a2c4-42c9-afcc-f21f67ed8d8d	Girherdit	wathermann		\N	\N	2010-04-23 00:00:00		2025-05-03 20:50:49.918	2025-05-03 20:50:49.918	\N
49c9c69a-add7-4822-8402-bbd7b2161f16	Giselle Emiret	Guzmán Tejeda		\N	\N	2007-11-22 00:00:00		2025-05-03 20:50:49.918	2025-05-03 20:50:49.918	\N
7a4eb7aa-16b4-4f96-a749-138887120bfa	Francisco	Gomez Bernal		\N	3221097164	\N		2025-05-03 20:50:49.919	2025-05-03 20:50:49.919	\N
1e449889-bdee-4c9b-9da1-1dcc9fdd467c	Gladis Antonieta	Gonzales Rodriguez		arq.sidalg@gmail.com	3331325769	1988-06-16 00:00:00		2025-05-03 20:50:49.919	2025-05-03 20:50:49.919	\N
c81a1aa4-8e7a-4d04-aa18-b051593c2eaf	Gema Paola	Diaz Castillo		\N	3222104793	\N		2025-05-03 20:50:49.92	2025-05-03 20:50:49.92	\N
8777287e-9ca0-49b7-a833-56e1555aaebb	Gladis Rocio	Lopez Figueroa		\N	\N	1985-01-30 00:00:00		2025-05-03 20:50:49.921	2025-05-03 20:50:49.921	\N
280b0744-8859-462f-ac8b-3068faae16e0	Glamis	Sánchez		glamissanchez@icloud.com	\N	1998-01-07 00:00:00		2025-05-03 20:50:49.921	2025-05-03 20:50:49.921	\N
027d1146-895e-44ba-a7e9-2d7e5f8daf0b	Georgina	Minero Medina		\N	3331902134	\N		2025-05-03 20:50:49.921	2025-05-03 20:50:49.921	\N
740bbc1d-9f13-47d0-9064-780ae7e521f0	Gerardo	Gómez González		erikagv747@gmail.com	3221595525	\N		2025-05-03 20:50:49.922	2025-05-03 20:50:49.922	\N
423305e4-384e-4921-a5d6-93df8f04cb91	Glenis	Amparo   Virgen		glenn@live.com.mx	\N	1990-11-18 00:00:00		2025-05-03 20:50:49.922	2025-05-03 20:50:49.922	\N
78857797-c020-42e4-b660-5e9b95cf80fa	Glenis Getzabelt	Amparo Virgen		glenn@live.com.mx	\N	1990-11-18 00:00:00		2025-05-03 20:50:49.922	2025-05-03 20:50:49.922	\N
76a9faab-3831-4a34-bc9a-692e88cb7e3f	Gary	Fiala		\N	+12083164615	\N		2025-05-03 20:50:49.923	2025-05-03 20:50:49.923	\N
64a2a447-6793-4503-8315-668af417ae07	Georgina del Rocio	Diaz Vallejo		\N	3222717033	\N		2025-05-03 20:50:49.923	2025-05-03 20:50:49.923	\N
6d396c29-335b-4136-a303-01e362b74756	Gloria	De León Ramos		gloriadlr2015@hotmail.com	3222600536	1981-12-31 00:00:00		2025-05-03 20:50:49.923	2025-05-03 20:50:49.923	\N
4954a1aa-cf46-45fd-9f2f-69be9d21d003	Gloria	Estrada Enciso		gloria_estrada_enciso@hotmail.com	\N	1977-09-16 00:00:00		2025-05-03 20:50:49.924	2025-05-03 20:50:49.924	\N
8b75d995-284a-4ab9-ba9a-52b9d4f15b99	Gloria	García Roméro.		\N	3221085415	1979-09-14 00:00:00		2025-05-03 20:50:49.924	2025-05-03 20:50:49.924	\N
313532ad-0f1f-41b6-a383-aa679c1dbadd	Gloria	Reyes Pantoga		\N	\N	\N		2025-05-03 20:50:49.924	2025-05-03 20:50:49.924	\N
94e735fe-a499-4ded-ab5e-16cb7ebd8685	Gerardo	Martinez Ortega		gerardomtz739@gmail.com	4425533640	\N		2025-05-03 20:50:49.925	2025-05-03 20:50:49.925	\N
5d5ad741-4308-471d-bae9-546ba9f1b65d	Gloria Edith	Moreno Aguilar		\N	3221501622	1998-12-19 00:00:00		2025-05-03 20:50:49.925	2025-05-03 20:50:49.925	\N
198d10c8-3960-4161-a107-edfb1ae4504d	Gloria Esther	Heredia Camacho		\N	\N	1966-03-13 00:00:00		2025-05-03 20:50:49.925	2025-05-03 20:50:49.925	\N
603aeb2c-51f8-441a-bff7-72004555852c	Gloria Gabina	Vazquez Chavarin		francogtz2@gmail.com	\N	1961-02-19 00:00:00		2025-05-03 20:50:49.926	2025-05-03 20:50:49.926	\N
d3d937da-3d60-4d1e-95b0-e9f9dfed4c76	Gloria Guadalupe	Lopez Torres		\N	\N	1958-12-21 00:00:00		2025-05-03 20:50:49.926	2025-05-03 20:50:49.926	\N
708d1c47-ac72-46ea-bc13-e9c80754d148	Gony	Luhr		\N	\N	\N		2025-05-03 20:50:49.926	2025-05-03 20:50:49.926	\N
5de167c0-927e-41a1-ac0a-b0d5a1577d9d	Gloria	Constreras Gonzalez		\N	3221106142	\N		2025-05-03 20:50:49.927	2025-05-03 20:50:49.927	\N
4a4d3a37-26b5-4cc6-9c99-077a2abfcf38	Georgina	Ramirez Aldaco		\N	3221410331	\N		2025-05-03 20:50:49.927	2025-05-03 20:50:49.927	\N
0440e840-03bf-43d2-929d-e394d2a4d844	Gorethi Janeth	Meza Rios		gjanethmeri@gmail.com	\N	1988-02-26 00:00:00		2025-05-03 20:50:49.927	2025-05-03 20:50:49.927	\N
74575da9-a58c-4ac4-a346-27bb68a10fdf	Gorgonio	Uribe Aguilar		\N	\N	1944-09-09 00:00:00		2025-05-03 20:50:49.927	2025-05-03 20:50:49.927	\N
71bcdd6d-88cd-47df-9564-6a7bc81b9d8c	Grabiela	Palacios Cervantes		palaciosgabriela@hotmail.com	\N	1975-08-25 00:00:00		2025-05-03 20:50:49.928	2025-05-03 20:50:49.928	\N
4045918e-1118-49b5-9f84-8862e5f1f1b8	Grace	Pambakian		pambakian1@hotmail.com	\N	\N		2025-05-03 20:50:49.928	2025-05-03 20:50:49.928	\N
67ff35dc-dc74-417e-b5a2-244c1b780610	Graciala	Castelli		gracielacastelli1@gmail.com	\N	1953-01-29 00:00:00		2025-05-03 20:50:49.928	2025-05-03 20:50:49.928	\N
42bf0369-eee1-4041-83b9-1854bcb349ee	Graciela	Cardenas Aldana		\N	3222994210	1965-06-19 00:00:00		2025-05-03 20:50:49.929	2025-05-03 20:50:49.929	\N
1c40fd9c-fcb5-4e62-81e1-aad28dba8cf2	Graciela	Castelli		gracielacastelli1@gmail.com	\N	1953-01-29 00:00:00		2025-05-03 20:50:49.929	2025-05-03 20:50:49.929	\N
e1d72ec2-a5dc-42b3-ab4b-83b1455c2042	Graciela	Espinoza Maldonado		\N	\N	1957-07-22 00:00:00		2025-05-03 20:50:49.929	2025-05-03 20:50:49.929	\N
fdd74989-f2ef-440e-b9c9-1c8b52a01699	Graciela	Godines Crúz		\N	3221040082	1953-06-29 00:00:00		2025-05-03 20:50:49.93	2025-05-03 20:50:49.93	\N
a63c783f-4b6d-4574-8eb4-7a541ff51bfa	Gael	Vinasco		\N	3222805140	\N		2025-05-03 20:50:49.93	2025-05-03 20:50:49.93	\N
ea48ba9a-d5ad-479b-87f4-a85191ff3f56	Graciela	Romero Jauregi		\N	\N	1992-04-27 00:00:00		2025-05-03 20:50:49.931	2025-05-03 20:50:49.931	\N
1a3bde09-9f2c-4ee3-85f7-4e7c2ef3fccc	Graciela	Rubio Ponce		\N	\N	1973-02-27 00:00:00		2025-05-03 20:50:49.931	2025-05-03 20:50:49.931	\N
0930e57f-32f4-4d4b-b05a-f0cbff3bf952	Graciela	Ruiz de Campos		\N	\N	1963-03-22 00:00:00		2025-05-03 20:50:49.932	2025-05-03 20:50:49.932	\N
30b5e8a3-af4e-480f-95c6-5e4a164d867b	Graciela	Valdez Ledesma		\N	\N	2006-08-01 00:00:00		2025-05-03 20:50:49.932	2025-05-03 20:50:49.932	\N
e7a9a3c8-3363-4858-adca-7487cd82ef28	Grecia	Tobar Reyes		\N	\N	2006-12-21 00:00:00		2025-05-03 20:50:49.932	2025-05-03 20:50:49.932	\N
a9df4361-74e9-4b5d-8ded-6c3f26b4f46a	Grecia Genesis	Madrigal Osorio		\N	\N	1994-08-29 00:00:00		2025-05-03 20:50:49.933	2025-05-03 20:50:49.933	\N
9f727f0e-9f58-4f04-9643-e6f7954444a9	Grecia Irene	Franques Elias		\N	\N	2000-04-29 00:00:00		2025-05-03 20:50:49.933	2025-05-03 20:50:49.933	\N
2064b295-f435-4560-b154-4cd6372cb31e	Grecia Judith	Bañales Rodriguez		\N	\N	2006-12-22 00:00:00		2025-05-03 20:50:49.933	2025-05-03 20:50:49.933	\N
29e3da84-e987-4d99-bde7-ad4a91023098	Gregorio	Aguilar Peraza		\N	\N	1953-05-09 00:00:00		2025-05-03 20:50:49.934	2025-05-03 20:50:49.934	\N
d510b453-e299-40ae-b268-74227c67a7e6	Gregorio	Hernandez Camacho		\N	\N	1974-05-09 00:00:00		2025-05-03 20:50:49.934	2025-05-03 20:50:49.934	\N
529b927a-fb5f-4ca3-8a1d-684a8848ebd0	Gretel Smantha	POnce Salgado		gretelponce@gmail.com	3221178176	2005-03-27 00:00:00		2025-05-03 20:50:49.934	2025-05-03 20:50:49.934	\N
213386d3-c52d-4e9c-85aa-64ff6b1a2f40	Gricela Olivia	Nolasco Zatarain		\N	\N	1968-04-11 00:00:00		2025-05-03 20:50:49.935	2025-05-03 20:50:49.935	\N
48badcc3-c5bd-4c0a-9cf0-918036d6faf1	Gerardo	Thiessen		\N	3222322127	\N		2025-05-03 20:50:49.935	2025-05-03 20:50:49.935	\N
51b59e51-feae-44ae-9ae2-1e950b28c5cb	Grinalda Elias	Vallejan		\N	\N	1967-02-28 00:00:00		2025-05-03 20:50:49.935	2025-05-03 20:50:49.935	\N
92b2b19c-a703-4325-9bfd-c023c1d397cc	German Misael	Ortiz Landeros		\N	3223776559	\N		2025-05-03 20:50:49.935	2025-05-03 20:50:49.935	\N
80425aae-3a2b-4507-8590-cee3f7a703ee	Griselda	Lopez Corona		\N	\N	1980-12-14 00:00:00		2025-05-03 20:50:49.936	2025-05-03 20:50:49.936	\N
5bb02f09-8bf9-4f47-a41b-1267c106ca13	Griselda Olivia	Nolasco Zatarain		grisolivia68@gmail.com	\N	1968-04-11 00:00:00		2025-05-03 20:50:49.936	2025-05-03 20:50:49.936	\N
f35a8441-1a2d-476e-9d96-34c4979cc9de	Grismar Yuritzi	Franquez Elias		yuri_turismo@hotmail.com	\N	1995-05-22 00:00:00		2025-05-03 20:50:49.936	2025-05-03 20:50:49.936	\N
0786a5c1-fc69-4cdc-b3a0-5fe52070644a	Guadalupe	Bautista Rojas		\N	\N	1985-11-18 00:00:00		2025-05-03 20:50:49.937	2025-05-03 20:50:49.937	\N
0b12df51-9e4e-4fbc-8a7d-9d12d5769b76	Guadalupe	Cantellan Campos		\N	\N	2007-06-05 00:00:00		2025-05-03 20:50:49.937	2025-05-03 20:50:49.937	\N
3cd54be3-6c0c-45d0-9921-a49f68c747e8	Guadalupe	Chacón Escandón		\N	\N	2007-03-29 00:00:00		2025-05-03 20:50:49.938	2025-05-03 20:50:49.938	\N
c1edc0bb-e7d6-4cbc-8844-57a7b8e1ded9	Guadalupe	Contreras		\N	\N	1960-03-10 00:00:00		2025-05-03 20:50:49.938	2025-05-03 20:50:49.938	\N
f4679902-e312-4ba2-b121-bb3c87b02228	Guadalupe	Contreras de Castellanos		castellanosdlupita@hotmail.com	3221325926	\N		2025-05-03 20:50:49.938	2025-05-03 20:50:49.938	\N
4b26279d-9c79-462a-b288-58238ba2bb0d	Guadalupe	Contreras Ramos		\N	\N	1946-01-29 00:00:00		2025-05-03 20:50:49.939	2025-05-03 20:50:49.939	\N
01ca9397-93ac-4f64-a126-6571ef450b8f	Guadalupe	Garduño		\N	\N	2006-02-03 00:00:00		2025-05-03 20:50:49.939	2025-05-03 20:50:49.939	\N
2d482721-1e1e-45b9-ae52-77a5b9e8cf75	Guadalupe	Hernández Martínez		\N	3221512427	1996-01-10 00:00:00		2025-05-03 20:50:49.939	2025-05-03 20:50:49.939	\N
234f96b8-fb46-40f0-9e78-cee180de606b	Guadalupe	Hernandez Martinez		\N	3221512427	\N		2025-05-03 20:50:49.94	2025-05-03 20:50:49.94	\N
80f9f690-4eac-4bba-a08d-b5c072eb63cb	Guadalupe	Lopez Navarrete		\N	\N	2009-05-12 00:00:00		2025-05-03 20:50:49.94	2025-05-03 20:50:49.94	\N
9b75a4f9-e521-49cf-8da3-1329ccef53d4	Guadalupe	Lorenzo Cr'uz		lulupismex@gmail.com	\N	1984-10-21 00:00:00		2025-05-03 20:50:49.94	2025-05-03 20:50:49.94	\N
5ecbdcc3-262d-4c52-b570-03b4b5c8523f	Guadalupe	Loyo Vazquez		\N	\N	2007-06-27 00:00:00		2025-05-03 20:50:49.941	2025-05-03 20:50:49.941	\N
0c5fd048-9d18-4c15-8df1-7712db1e9c9f	Guadalupe	Magaña Valdéz		coo.microcredito.vta@crediavance.com.mx	\N	2004-08-10 00:00:00		2025-05-03 20:50:49.941	2025-05-03 20:50:49.941	\N
ee5bb44f-fa84-44ac-b3cd-b2f1f18dc407	Guadalupe	Osuna Bernal		nutrixlupita@hotmail.com	\N	1966-10-12 00:00:00		2025-05-03 20:50:49.942	2025-05-03 20:50:49.942	\N
5da2498b-1fea-4a0f-9640-1cb77e237436	Guadalupe	Ramirez Delgadillo		\N	\N	1951-02-12 00:00:00		2025-05-03 20:50:49.942	2025-05-03 20:50:49.942	\N
161b7a7e-8388-4d15-8af4-140169609e33	Giovanna	Paniagua Corona		\N	5535136600	\N		2025-05-03 20:50:49.942	2025-05-03 20:50:49.942	\N
8b87869d-4076-4dcd-8e9c-b5193b40e2af	Guadalupe	Trujillo Venegas		\N	\N	1936-12-29 00:00:00		2025-05-03 20:50:49.942	2025-05-03 20:50:49.942	\N
d99fb322-5a4e-442a-a449-7df37be46da2	Guadalupe	Velazco Jimenez		\N	3292980625	1959-08-28 00:00:00		2025-05-03 20:50:49.943	2025-05-03 20:50:49.943	\N
f59e3b0d-efe7-4021-9ba5-7c81868d916e	Guadalupe Lorena	Navarrro Lopez		\N	\N	2008-12-18 00:00:00		2025-05-03 20:50:49.943	2025-05-03 20:50:49.943	\N
e95b6c3b-62c4-4aaf-9143-4717b44bede9	Giulian	Escobedo Huerta		honeybunygirl21@gmail.com	+523311509427	\N		2025-05-03 20:50:49.943	2025-05-03 20:50:49.943	\N
db06b8a6-1960-476c-9790-283e7aff74e3	Guery	Fiala		\N	\N	\N		2025-05-03 20:50:49.944	2025-05-03 20:50:49.944	\N
1d31c62b-501b-4df2-b52f-24276501cd68	Guilian	Escobedo Huerta		\N	+13237135858	1982-09-21 00:00:00		2025-05-03 20:50:49.944	2025-05-03 20:50:49.944	\N
34ff4dba-de77-467c-92ee-b0709e774cda	Guillermina	Uribe López		\N	\N	1952-06-09 00:00:00		2025-05-03 20:50:49.944	2025-05-03 20:50:49.944	\N
10c9ec57-a4e6-49f4-8c28-32064a412f22	Guillermo	Abarca Corona		\N	\N	1965-04-30 00:00:00		2025-05-03 20:50:49.945	2025-05-03 20:50:49.945	\N
e8778045-8de5-4299-b196-c92286c42030	Guillermo	García Mascorro		\N	\N	1979-03-11 00:00:00		2025-05-03 20:50:49.945	2025-05-03 20:50:49.945	\N
cb8cbd6d-27e1-43be-9a87-a182518e3c62	Guillermo	Hernández Bravo		polvo_hernandez@hotmail.com	\N	1989-09-17 00:00:00		2025-05-03 20:50:49.946	2025-05-03 20:50:49.946	\N
7ac0240c-7e85-497b-9222-8bee594c9371	Guillermo	Nuño Cosio		memopvr@hotmail.com	\N	1964-08-26 00:00:00		2025-05-03 20:50:49.946	2025-05-03 20:50:49.946	\N
b8757e7d-86bf-4b50-8020-15602b6a534e	Guillermo	Torres Ruiz		\N	\N	\N		2025-05-03 20:50:49.946	2025-05-03 20:50:49.946	\N
d179872c-8895-4c7b-bc32-42cb539abbed	Guillermo de Jesus Tomas	Silva Davila		\N	\N	1942-12-21 00:00:00		2025-05-03 20:50:49.946	2025-05-03 20:50:49.946	\N
962b1d73-e879-4e39-905f-3bb42b8d48cd	Gumaro	Navarro Navarro		\N	\N	1962-05-10 00:00:00		2025-05-03 20:50:49.947	2025-05-03 20:50:49.947	\N
bc307982-1a18-4d1a-8f8e-3c2e9a819283	Gustavo	Aguayo		\N	\N	\N		2025-05-03 20:50:49.947	2025-05-03 20:50:49.947	\N
353d6d96-ce6d-4e9c-b61f-326fa55e0a96	Gustavo	Aguayo Velazco		\N	3222259278	1990-02-17 00:00:00		2025-05-03 20:50:49.948	2025-05-03 20:50:49.948	\N
7ef68d32-1f56-44b6-bdbf-9aff6400d9dc	Gustavo	Antonio Avila		tavo6355@hotmail.com	3221144122	1969-12-12 00:00:00		2025-05-03 20:50:49.948	2025-05-03 20:50:49.948	\N
7f60e2fa-2fac-46c8-9339-25972bbce002	Gustavo	Ruiz Navarrete		\N	\N	1967-04-15 00:00:00		2025-05-03 20:50:49.948	2025-05-03 20:50:49.948	\N
7270475b-bec9-40a5-93dd-a31b37010a3a	Gustavo	Valladares Mata		\N	\N	1971-11-14 00:00:00		2025-05-03 20:50:49.949	2025-05-03 20:50:49.949	\N
52a01ede-890d-4a15-afce-87c9dd18547d	Gustavo Alvaro	Sarabia Kelly		\N	\N	2008-08-22 00:00:00		2025-05-03 20:50:49.949	2025-05-03 20:50:49.949	\N
32a9ab39-0a2b-466a-8010-9a4c14100b63	Gustavo Martin	Mares García		\N	\N	1991-07-15 00:00:00		2025-05-03 20:50:49.949	2025-05-03 20:50:49.949	\N
ef7231f7-a945-4595-aa67-56892392ff59	Gustavo Rafael	Guerreo Gonzalez		\N	\N	2010-10-21 00:00:00		2025-05-03 20:50:49.95	2025-05-03 20:50:49.95	\N
fd06d14c-e341-4d9e-8cd6-217785afa240	Gustavo Rafel	Guerrero Contreras		\N	\N	2010-10-21 00:00:00		2025-05-03 20:50:49.95	2025-05-03 20:50:49.95	\N
37f035cf-40f7-4121-9179-df65a7b49f6e	Germani	Hanshaw		\N	+15092646713	\N		2025-05-03 20:50:49.95	2025-05-03 20:50:49.95	\N
6982bfb0-ede9-44e3-8984-e792a22cc123	Guy	Cloutier		guy8984@hotmail.com	\N	1956-06-26 00:00:00		2025-05-03 20:50:49.951	2025-05-03 20:50:49.951	\N
33eaf013-62f9-4e8b-afc5-d554a28bf69b	Guy	Gilles		gillesguy01@icloud.com	\N	1949-10-15 00:00:00		2025-05-03 20:50:49.951	2025-05-03 20:50:49.951	\N
497d01a6-e0cc-4858-a04d-d52f49768058	Guylaine	Bauchard		\N	\N	1965-04-05 00:00:00		2025-05-03 20:50:49.951	2025-05-03 20:50:49.951	\N
d9359843-52c1-4ba1-93ba-56f1d6662150	Guylaine	Bouchard		bouchard.guylaine@icloud.com	\N	1965-04-05 00:00:00		2025-05-03 20:50:49.952	2025-05-03 20:50:49.952	\N
5b1daf03-ae03-430a-b4d6-bf9509ee2e24	Gualupe	Lorenzo Cruz		\N	3221033151	\N		2025-05-03 20:50:49.952	2025-05-03 20:50:49.952	\N
d74f0e19-e8bc-439d-8ef0-5b0e8de40629	Gloria	Budros		\N	3223238251	\N		2025-05-03 20:50:49.952	2025-05-03 20:50:49.952	\N
38d496c7-5200-4b5a-9fc2-29e865b08272	Hanna	Hwtchens		\N	\N	1995-02-02 00:00:00		2025-05-03 20:50:49.953	2025-05-03 20:50:49.953	\N
aaa6eacb-fbb9-4a8e-ac45-c151eb05a6e5	Hanna	Lubliner		\N	\N	\N		2025-05-03 20:50:49.953	2025-05-03 20:50:49.953	\N
3355611f-b4ce-4b4f-b4c5-0f49f3a190d8	Hanna	Van Noland		hanna_vannoland@yahoo.com	\N	1993-12-29 00:00:00		2025-05-03 20:50:49.953	2025-05-03 20:50:49.953	\N
3d9be46d-f8b0-44d7-9ba9-34f584de6807	Hanna	Vannoland		\N	\N	\N		2025-05-03 20:50:49.954	2025-05-03 20:50:49.954	\N
cfd1ca07-800f-43e1-aff6-49f1fe46e3c5	Hanna Yamile	Dezantis Gomez		\N	\N	2013-03-04 00:00:00		2025-05-03 20:50:49.954	2025-05-03 20:50:49.954	\N
7a29aaa8-6fa6-451e-9c79-6deeb0f14dac	Glandis Antonieta	Gonzales Rodriguez		\N	3331325769	\N		2025-05-03 20:50:49.954	2025-05-03 20:50:49.954	\N
e91eee34-f2f2-4ffd-8aab-317c98d16b27	Gladis Antonieta	Gonzalez Rodriguez		\N	3331325769	\N		2025-05-03 20:50:49.955	2025-05-03 20:50:49.955	\N
48c3053a-235e-46be-96f1-fe7f8247a4da	Gloria	Soto		sari_gloria@hotmail.com	+528715660303	\N		2025-05-03 20:50:49.955	2025-05-03 20:50:49.955	\N
846a7297-5bf1-40ec-9388-6c25328a42c3	Hassell Alejandro	Navarro Cadena		\N	\N	2009-05-25 00:00:00		2025-05-03 20:50:49.955	2025-05-03 20:50:49.955	\N
616b5330-58f2-44fc-af28-8c733a8bc04c	Hauslley	Silva		\N	\N	1977-12-31 00:00:00		2025-05-03 20:50:49.956	2025-05-03 20:50:49.956	\N
8f670920-7861-48de-8a2b-8dbb037e8025	Hauslley	Silva		hnsilva80@yahoo.com	\N	1977-12-31 00:00:00		2025-05-03 20:50:49.956	2025-05-03 20:50:49.956	\N
7b0923e8-ef05-4f6f-b06f-815202c8eb33	Heath	Sanderson		\N	\N	\N		2025-05-03 20:50:49.956	2025-05-03 20:50:49.956	\N
cc027358-d1c6-4c74-8ddd-03c01659bcd1	Hannah	Kinderleher		\N	+15056039528	\N		2025-05-03 20:50:49.957	2025-05-03 20:50:49.957	\N
4d55f923-9b0a-474a-9afa-4907ac51a4de	Hector	García Sanchez		hs3030@hotmail.com	\N	1980-02-05 00:00:00		2025-05-03 20:50:49.957	2025-05-03 20:50:49.957	\N
85c9ca16-0c8c-4397-b7da-2153844aff1e	Hector	Lomelí		\N	\N	\N		2025-05-03 20:50:49.958	2025-05-03 20:50:49.958	\N
62f21540-076e-4060-b62d-fe514a4162ea	Hector	Moreno Palomera		hectormmp1@hotmail.com	\N	1988-12-06 00:00:00		2025-05-03 20:50:49.958	2025-05-03 20:50:49.958	\N
2cdc920d-bae2-4b35-851b-27477a5b7596	Hector	Peralta Arteaga		\N	\N	2007-01-25 00:00:00		2025-05-03 20:50:49.958	2025-05-03 20:50:49.958	\N
6df1b9ae-6786-406a-a69d-1b98acc11fa5	Glenda	Starocelic		\N	+0012043905883	\N		2025-05-03 20:50:49.959	2025-05-03 20:50:49.959	\N
f64cc8e2-4e32-4788-9bd4-dcfaa5729307	Hector	Sahade Espinoza		\N	\N	1970-06-07 00:00:00		2025-05-03 20:50:49.959	2025-05-03 20:50:49.959	\N
a3651209-5925-4314-b420-bac0f1ced7d0	Hector	Sanchez Aleman		hecsal01@hotmail.com	\N	1964-06-08 00:00:00		2025-05-03 20:50:49.959	2025-05-03 20:50:49.959	\N
6cafc07f-ab09-46f0-bc77-a2c39cccbcf2	Hector	Tredeñoo Rios		\N	\N	1983-01-03 00:00:00		2025-05-03 20:50:49.96	2025-05-03 20:50:49.96	\N
7180ad40-9df9-4d99-b439-46950b33a509	Hector Alonzo	Macias Caballero		blacklyon_99@hotmail.com	\N	1987-07-12 00:00:00		2025-05-03 20:50:49.96	2025-05-03 20:50:49.96	\N
b628dee1-e0a9-42c2-90e9-eac6a02a9c90	Gonzalez Moreno	Rebeca		\N	3222746532	\N		2025-05-03 20:50:49.96	2025-05-03 20:50:49.96	\N
a9ce6798-c937-4bc0-9d0d-099e5685aab4	Hector Enrrique	Estrada Alvarado		\N	\N	2011-05-02 00:00:00		2025-05-03 20:50:49.96	2025-05-03 20:50:49.96	\N
62711bee-655c-491e-a9b3-598bea76f217	Graciela	Guadarrama Baena		chela.gu@gmail.com	5628208845	\N		2025-05-03 20:50:49.961	2025-05-03 20:50:49.961	\N
13f15831-6eab-4859-9e18-18ec45637d04	Hector Hazael	Tejeda Carrillo		\N	\N	2008-10-31 00:00:00		2025-05-03 20:50:49.961	2025-05-03 20:50:49.961	\N
704f8b25-758d-46b4-b938-465d640b68b7	Hector Manuel	Mendez Huerta		mendez_psycho@hotmail.com	\N	1987-10-19 00:00:00		2025-05-03 20:50:49.961	2025-05-03 20:50:49.961	\N
4462eee4-fc49-40de-b083-1406b7d24b91	Hector Manuel	Torres Dominguez		hector_delfines_@hotmail.com	\N	1968-06-27 00:00:00		2025-05-03 20:50:49.962	2025-05-03 20:50:49.962	\N
3ac4a790-6454-46b1-921f-d54d52ccaa60	Heidy Marcela	Quezada Brambila		\N	\N	2010-03-22 00:00:00		2025-05-03 20:50:49.962	2025-05-03 20:50:49.962	\N
1914ea06-d652-4d53-9bc0-f33df4290225	Helen	Lukaway		\N	\N	\N		2025-05-03 20:50:49.963	2025-05-03 20:50:49.963	\N
cf72b177-f62b-41cb-baca-5118d2e9eed2	Helena	Enrriques Delgado		\N	\N	1976-08-16 00:00:00		2025-05-03 20:50:49.963	2025-05-03 20:50:49.963	\N
82f27623-44ce-440a-a95e-abba6c4bce75	Helena	Naranjo Mendez		\N	\N	1957-08-18 00:00:00		2025-05-03 20:50:49.963	2025-05-03 20:50:49.963	\N
b65153e4-8279-413b-b04a-e4035183a0ea	Gerardo	Matrínez Ortega		\N	4425533640	\N		2025-05-03 20:50:49.963	2025-05-03 20:50:49.963	\N
0a616190-98a4-4f18-8c91-0505030290b1	Helia Andrea	Torres Juncal		h.andrea.t.juncal@gmail.com	\N	1984-06-01 00:00:00		2025-05-03 20:50:49.964	2025-05-03 20:50:49.964	\N
f0a041c6-f52a-4e6b-ab55-2527a2e5d652	Grisel	Estrada Aguilar		karou201529@gmail.com	+523223441314	\N		2025-05-03 20:50:49.964	2025-05-03 20:50:49.964	\N
b4991d65-32f5-4966-81ba-5849eb8f10b0	Herlinda	Gomez Armas		\N	\N	1937-03-02 00:00:00		2025-05-03 20:50:49.964	2025-05-03 20:50:49.964	\N
009f31e6-b668-4954-9ab9-d9a6f65f3c50	Herlinda	Hernandez Plata		\N	\N	2008-09-18 00:00:00		2025-05-03 20:50:49.965	2025-05-03 20:50:49.965	\N
782a71db-3215-4354-b840-f8b36c0caed0	Hermina	Villafuerte García		hermivillarfuerte@hotmail.com	\N	1974-02-07 00:00:00		2025-05-03 20:50:49.965	2025-05-03 20:50:49.965	\N
75288f9a-a257-44b5-97a1-5765cbfd29c2	Guadalupe	Ruiz Mendoza		\N	3228885673	\N		2025-05-03 20:50:49.965	2025-05-03 20:50:49.965	\N
393524fe-3794-472e-98cb-a796add3e672	Hernan	Gonzalez  Valades		hernan@anunciatel.com	\N	1977-02-24 00:00:00		2025-05-03 20:50:49.966	2025-05-03 20:50:49.966	\N
b20077ed-a19e-47ab-8392-bb72daab78b3	Hernán	González Valadéz		hernan@anunciatel.com	\N	1977-02-24 00:00:00		2025-05-03 20:50:49.966	2025-05-03 20:50:49.966	\N
a8002104-ebe9-45a9-bfb1-d008dca0bfe6	Gwen M	Nicole		\N	+447918272638	\N		2025-05-03 20:50:49.966	2025-05-03 20:50:49.966	\N
a1f69165-f3f5-4330-9130-3be4f8af3391	Hicham	Benthami		\N	\N	1975-11-07 00:00:00		2025-05-03 20:50:49.967	2025-05-03 20:50:49.967	\N
ef3f0bb7-1bb5-42c0-98ec-d5e4038b9e05	Gricelda	Becerra		\N	3112443114	\N		2025-05-03 20:50:49.967	2025-05-03 20:50:49.967	\N
6ce22c15-f3bc-4106-8b00-943fcc7b6a17	gutierrez	Mayra		\N	5631886444	\N		2025-05-03 20:50:49.967	2025-05-03 20:50:49.967	\N
ac2239e2-4f94-4b69-86c2-9f70ed0201de	Hilda Graciela	Barrios Gonzalez		\N	3292986307	1952-01-28 00:00:00		2025-05-03 20:50:49.968	2025-05-03 20:50:49.968	\N
baeaf8ad-1c15-4ddf-aaa4-21ec8a58bb5c	Hipolita	Crúz Ramírez		\N	\N	1964-06-28 00:00:00		2025-05-03 20:50:49.968	2025-05-03 20:50:49.968	\N
7884bcc4-ce1a-4d5a-8f68-e1cbeb4efe23	Holanda	García Alcantar		holy111@hotmail.com	\N	1984-06-17 00:00:00		2025-05-03 20:50:49.968	2025-05-03 20:50:49.968	\N
8eb5697b-f986-4c78-b3be-21310b7c6b23	Horacio	Conriquez Godinez		\N	3221243524	1986-07-02 00:00:00		2025-05-03 20:50:49.969	2025-05-03 20:50:49.969	\N
43830def-0ed2-4726-8251-bbd10fa17f44	Horacio	Cortez Quiroz		\N	\N	1999-10-20 00:00:00		2025-05-03 20:50:49.969	2025-05-03 20:50:49.969	\N
6124d373-0054-45ac-8762-83a14ee6f206	Hank	Hanson		thecarpslayer@gmail.com	\N	\N		2025-05-03 20:50:49.969	2025-05-03 20:50:49.969	\N
6b291aa2-0b2e-4869-8a3d-6a2a2a3bd7d9	Horacio	Macias Losa		\N	\N	\N		2025-05-03 20:50:49.97	2025-05-03 20:50:49.97	\N
4998eda1-6c78-4449-ac5e-ce76b6807e9c	Horacio	Rodriguez Joya		\N	\N	1977-09-04 00:00:00		2025-05-03 20:50:49.97	2025-05-03 20:50:49.97	\N
8e53a018-f92b-45bb-b695-86e9d9d485dd	Hortencia	Camacho Castro		\N	\N	\N		2025-05-03 20:50:49.97	2025-05-03 20:50:49.97	\N
69a2ab4f-8c59-48e3-a769-93f673198bb8	Hortencia	Del Campo Irizar		hortenciadelca@gmail.com	\N	1971-10-03 00:00:00		2025-05-03 20:50:49.971	2025-05-03 20:50:49.971	\N
2d1fb192-b09d-4176-bf78-cf18d7df9576	Hortencia	Sosa Dominguez		\N	\N	2006-04-03 00:00:00		2025-05-03 20:50:49.971	2025-05-03 20:50:49.971	\N
5ae1f286-b7a6-48b6-9cf7-29fafa3c3880	Helmut	wolf		\N	3222941520	1942-12-05 00:00:00		2025-05-03 20:50:49.971	2025-05-03 20:50:49.971	\N
49625548-0b1e-441c-9d2e-13fc0c3d1fa7	Howard	Pagin		\N	\N	\N		2025-05-03 20:50:49.972	2025-05-03 20:50:49.972	\N
1dc3a2e8-d9a2-47d5-a2c5-06ef74ca87c2	Gonzalez Beltran	Wendy		\N	8137396612	\N		2025-05-03 20:50:49.972	2025-05-03 20:50:49.972	\N
f7c48153-bae8-4d6b-b9a6-45cd62f815db	Hugo	Ortiz Cortigo		\N	\N	\N		2025-05-03 20:50:49.973	2025-05-03 20:50:49.973	\N
ea363723-6e0b-4596-bd56-6462682fd4d3	Hugo Enrique	Arcos de León		hugoe_arcosdeleon@hotmail.com	\N	1980-06-10 00:00:00		2025-05-03 20:50:49.973	2025-05-03 20:50:49.973	\N
f22ec471-223d-4e12-9d32-18645b2982ae	Hugo Jorge	Derath Guzmán		\N	3221331056	1969-06-12 00:00:00		2025-05-03 20:50:49.973	2025-05-03 20:50:49.973	\N
9720b53f-9a1e-4ad0-b24a-d8b0bc357514	Huguette	Gobeil		\N	\N	1950-08-30 00:00:00		2025-05-03 20:50:49.974	2025-05-03 20:50:49.974	\N
e1352273-c2b3-420f-b981-17985d6aa405	Humberto	Angeles Mejia		\N	\N	2005-05-22 00:00:00		2025-05-03 20:50:49.974	2025-05-03 20:50:49.974	\N
d517e0e1-e07d-465d-b4b0-bae976385e64	Humberto	Famania		humfama@gmail.com	3221820763	1949-08-16 00:00:00		2025-05-03 20:50:49.974	2025-05-03 20:50:49.974	\N
1b0171c4-1951-4d9f-9ec3-d42e31302c84	HumberTO	FLORES s		\N	\N	\N		2025-05-03 20:50:49.975	2025-05-03 20:50:49.975	\N
2aa8f061-c778-4ba6-9813-57f88a0ee486	Humberto	Flores Seegura		\N	\N	\N		2025-05-03 20:50:49.975	2025-05-03 20:50:49.975	\N
8bc86eb0-1a18-4cc4-bac4-5c3c0f27e1c5	Humberto	Fuentes		\N	\N	\N		2025-05-03 20:50:49.975	2025-05-03 20:50:49.975	\N
198f2a17-54b2-4345-9dfb-2c97f5924bef	Humberto	Salanova		\N	\N	\N		2025-05-03 20:50:49.976	2025-05-03 20:50:49.976	\N
8c5e9033-2f5b-43f9-b6b6-88fe4ed9801b	Ian Giovani	Canales Rubio		\N	\N	\N		2025-05-03 20:50:49.976	2025-05-03 20:50:49.976	\N
0335d468-3640-40fc-bf27-7d029f48e3a7	Ian Giovanniy	Canales Rubio.		\N	\N	2006-01-26 00:00:00		2025-05-03 20:50:49.976	2025-05-03 20:50:49.976	\N
794f4c57-d131-4169-bd72-06733af6fc98	Idiana Julisa	Arreaola Sanchez		\N	\N	2009-03-23 00:00:00		2025-05-03 20:50:49.976	2025-05-03 20:50:49.976	\N
1321bda3-d4fe-4025-8a8e-6ceb83c785d5	Idubina	Gonzales Rodriguez		\N	\N	1972-07-15 00:00:00		2025-05-03 20:50:49.977	2025-05-03 20:50:49.977	\N
11777fff-ac3b-4b52-9c6c-071e03360511	Ignacia	Rodriguez Urrutia		\N	\N	1952-03-02 00:00:00		2025-05-03 20:50:49.977	2025-05-03 20:50:49.977	\N
90c76bf8-e820-41b8-9600-234c7131df0e	Ignacio	Flores Gutierrez		\N	3221316300	2002-08-06 00:00:00		2025-05-03 20:50:49.977	2025-05-03 20:50:49.977	\N
888c3fd8-5a96-4ab0-89ba-95fb4a09572a	Ignacio	Gonzalez Paniagua		\N	\N	1984-07-31 00:00:00		2025-05-03 20:50:49.978	2025-05-03 20:50:49.978	\N
bb89c47f-c83f-4a65-8835-9337f0114e32	Ignacio	Gonzalez Vicencio		\N	\N	1955-09-10 00:00:00		2025-05-03 20:50:49.978	2025-05-03 20:50:49.978	\N
6d0be69a-b7df-4b3c-b2e6-be7f834971d8	Hector	Rodriguez		\N	3221426754	\N		2025-05-03 20:50:49.978	2025-05-03 20:50:49.978	\N
4f9f098f-5548-4aa6-a0ee-3674372ed554	Ike Raul	Martinez García		mraul077@yahoo.com	\N	2012-09-02 00:00:00		2025-05-03 20:50:49.979	2025-05-03 20:50:49.979	\N
88faff49-0a01-4d9c-9b16-8c1c61b6bdc2	Iker	A La Torre		\N	\N	2011-03-27 00:00:00		2025-05-03 20:50:49.979	2025-05-03 20:50:49.979	\N
a2682aee-cee3-40ac-8beb-951a5d276e6f	Hannah	Kindeerlerer		\N	+15056039528	\N		2025-05-03 20:50:49.979	2025-05-03 20:50:49.979	\N
d71d0b07-47d2-4cb6-92ec-5440e7b97546	Iker Moises	Betancourt Kalinshuk		mitka655@gmail.com	\N	2014-11-16 00:00:00		2025-05-03 20:50:49.98	2025-05-03 20:50:49.98	\N
eac83016-4a8e-46f4-891e-6f58eb084603	Iker Pastor	Rebollar García		\N	\N	2013-03-28 00:00:00		2025-05-03 20:50:49.98	2025-05-03 20:50:49.98	\N
61e3ac29-930a-40ec-ba59-efca154a7a63	Ileana	Martines Albares		facturasdpctoraileana@gmail.com	\N	1986-03-12 00:00:00		2025-05-03 20:50:49.98	2025-05-03 20:50:49.98	\N
9e787672-2ebb-428a-9849-672ce05dec9e	Hector Enrrique	Gonzales Rios		\N	3222914631	\N		2025-05-03 20:50:49.981	2025-05-03 20:50:49.981	\N
6550a8f7-6fcc-4eca-b208-59605928f696	Hector Antonio	Rodriguez Martinez		\N	3221426754	\N		2025-05-03 20:50:49.981	2025-05-03 20:50:49.981	\N
d733c30b-1581-4a72-a22d-0658f93f90f4	Iliana Nohemi	Sandoval Peña		mimisandovalpe@gmail.com	3222749091	2001-02-15 00:00:00		2025-05-03 20:50:49.981	2025-05-03 20:50:49.981	\N
e074e925-de1e-4c26-ad88-580689609edd	Iliana Raquel	Peña Velazco		lili_libra_95@hotmail.com	\N	1995-09-28 00:00:00		2025-05-03 20:50:49.982	2025-05-03 20:50:49.982	\N
18c5dd4a-d7e2-4b05-a035-decb37f86932	Ilse	Hermosillo Rodriguez		ilsehermosillo.rodriguez.714@gmail.com	\N	1990-02-14 00:00:00		2025-05-03 20:50:49.982	2025-05-03 20:50:49.982	\N
830a7334-974c-4de2-b9e5-9ced4e7f174a	Ilse Mariel	Hernandez Reynoso		marie.macias87@gmail.com	\N	1987-01-17 00:00:00		2025-05-03 20:50:49.982	2025-05-03 20:50:49.982	\N
834ce80f-7a23-4e78-a3db-58d41d98a9c0	Hersson	Portillo		\N	3221306122	\N		2025-05-03 20:50:49.983	2025-05-03 20:50:49.983	\N
4b2f5a6b-9aec-402c-8485-c3ec76903f02	Imelda	Ascebes Rodríguez		imelda_a_r@hotmail.com	\N	1963-05-13 00:00:00		2025-05-03 20:50:49.983	2025-05-03 20:50:49.983	\N
54424808-61ad-465a-bee7-49a2374f0931	Inde	Zepeda Mendez		\N	\N	1979-06-20 00:00:00		2025-05-03 20:50:49.983	2025-05-03 20:50:49.983	\N
7bd11316-02d5-4bb5-a7e0-84da4f300f9c	Indira Monserrat	Sanchez Rodriguez		msanchez.r@me.com	\N	1985-07-14 00:00:00		2025-05-03 20:50:49.984	2025-05-03 20:50:49.984	\N
8a322e6b-8a11-4022-9094-6ae1cbe7ab72	Ingmar	García		ingmargs@gmail.com	\N	1965-02-18 00:00:00		2025-05-03 20:50:49.984	2025-05-03 20:50:49.984	\N
76d7b37a-5915-43d2-a805-0aa97ef6f8e5	Ingrid	Perez Hérnandez		\N	\N	1994-07-31 00:00:00		2025-05-03 20:50:49.984	2025-05-03 20:50:49.984	\N
3c4ee19b-4a32-4b88-8469-e7db4f2c26db	Ingrid Jazmín	Figeroa Alvarado.		indrimicasa1234@gmail.com	\N	2000-04-07 00:00:00		2025-05-03 20:50:49.984	2025-05-03 20:50:49.984	\N
ba612770-3030-4c3e-a9dd-1f6ea6134660	Helena	Popova		\N	5524459304	\N		2025-05-03 20:50:49.985	2025-05-03 20:50:49.985	\N
ac839619-30c6-49a9-96a5-07f3e2f759cb	Inocencio	Orozco Flores		orozcoinicencio7@gmail.com	\N	1959-06-22 00:00:00		2025-05-03 20:50:49.985	2025-05-03 20:50:49.985	\N
e1654ea8-e9e5-4951-a4b3-12c9e41064dc	Iram	García Bustamante		\N	\N	1951-01-18 00:00:00		2025-05-03 20:50:49.985	2025-05-03 20:50:49.985	\N
c49a24e1-8c3f-49e0-bdd8-e440a3d820b2	Irene	Bergeron		ziry53@gmail.com	\N	\N		2025-05-03 20:50:49.986	2025-05-03 20:50:49.986	\N
1e292fff-b49f-4915-8854-9748c91afd92	Irene	Mendez Vázquez		\N	\N	2007-05-26 00:00:00		2025-05-03 20:50:49.986	2025-05-03 20:50:49.986	\N
0cc00430-a91e-40a6-a39c-1b93a006b6cb	Ireri	Reynoso Sepulveda		ireriitzigu@live.com.mx	\N	1988-08-24 00:00:00		2025-05-03 20:50:49.987	2025-05-03 20:50:49.987	\N
b0ce1bf1-b2f5-4f33-ad26-9042a7b3897f	Iris	Alvarez Torres		nenaicat@hotmail.com	\N	1979-02-03 00:00:00		2025-05-03 20:50:49.987	2025-05-03 20:50:49.987	\N
1899ae6f-d92f-43a1-aa49-0e30b41bffd4	Iris	Campa Perèz		teotlali31@hotmai.com	3221356398	1978-08-31 00:00:00		2025-05-03 20:50:49.987	2025-05-03 20:50:49.987	\N
862ac04b-63a1-4fa8-b79b-9671b0e88324	Iris  Adriana	Gonzalez Naranjo		aldo23@me.com	\N	1985-07-20 00:00:00		2025-05-03 20:50:49.988	2025-05-03 20:50:49.988	\N
f0302f58-cd8c-4a01-b754-e5be8068543f	Iris jasmin	Arce Salomon		\N	\N	1985-07-03 00:00:00		2025-05-03 20:50:49.988	2025-05-03 20:50:49.988	\N
fbc0823b-5e41-4694-b44c-0f80bb0f9cde	Irma	Davila Salcedo		\N	\N	1970-10-07 00:00:00		2025-05-03 20:50:49.988	2025-05-03 20:50:49.988	\N
3746523c-06de-4c81-89c4-13e3a9044b5f	Irma	Gutierez Ayala		\N	\N	2009-09-18 00:00:00		2025-05-03 20:50:49.989	2025-05-03 20:50:49.989	\N
60aff899-ed8a-4b6b-ac93-8fd4d79939a0	Irma Alejandra	Alvarez Gutierrez		alezeravla@gmail.com	\N	1982-07-08 00:00:00		2025-05-03 20:50:49.989	2025-05-03 20:50:49.989	\N
c1c54006-9bb1-42c0-8002-2128d00ac506	Irma Angelica	Osoria Reyes		\N	\N	\N		2025-05-03 20:50:49.989	2025-05-03 20:50:49.989	\N
ffd91a39-47d9-4092-a93f-abf9f7e52c8c	Irma Gabriela	JImenez Larromana		\N	\N	1994-10-29 00:00:00		2025-05-03 20:50:49.989	2025-05-03 20:50:49.989	\N
7b5256b9-051f-418e-9be9-bab6222ea314	Irma Leticia	Salcedo Ullón		\N	\N	1965-12-19 00:00:00		2025-05-03 20:50:49.99	2025-05-03 20:50:49.99	\N
fbabd33e-fe8f-44c8-bab1-02e087904ab7	Irma Lorena	Jimenez Santiago		\N	\N	1973-09-02 00:00:00		2025-05-03 20:50:49.99	2025-05-03 20:50:49.99	\N
a875819e-3e4f-450c-a770-c5a4f20b4bdb	Irma Margarita	Magdaleno Cervante		\N	\N	\N		2025-05-03 20:50:49.99	2025-05-03 20:50:49.99	\N
52047658-dbcd-4963-8240-801bf9a2ce47	Irsi Denisse	Fernandez Arellano		\N	\N	2010-01-18 00:00:00		2025-05-03 20:50:49.991	2025-05-03 20:50:49.991	\N
0b81ae74-69c0-4059-89d9-647fd6eaebc9	Irvin	Hernández Villa		\N	\N	1990-02-01 00:00:00		2025-05-03 20:50:49.991	2025-05-03 20:50:49.991	\N
a37f4304-05a4-4df1-8838-5a005a094f02	Horacio	González Calixto		hhhoracio.gonzal17@gmail.com	+523227797386	\N		2025-05-03 20:50:49.991	2025-05-03 20:50:49.991	\N
826fd16d-29f6-4b2f-8532-45f450e602f9	Hashim	Razak		\N	7711059952	\N		2025-05-03 20:50:49.992	2025-05-03 20:50:49.992	\N
f1e7f3e3-8ef6-400f-8c2f-55428e82ef7e	Irving Isaac	Aparicio Palmeros		\N	\N	2013-01-23 00:00:00		2025-05-03 20:50:49.992	2025-05-03 20:50:49.992	\N
81072af9-3b9e-4ecb-b950-07591a8a8378	Isaac	Guillen Barajas		\N	\N	1995-03-22 00:00:00		2025-05-03 20:50:49.992	2025-05-03 20:50:49.992	\N
fea6d486-da3e-48b8-a2f8-69bf625c9531	Isabel	Antunez Brito		\N	\N	2005-09-22 00:00:00		2025-05-03 20:50:49.993	2025-05-03 20:50:49.993	\N
55bbedad-974e-406a-ae8e-b03c9b71aa4a	Hernan	Gonzales Valades		hernan@anunciatel.com	3221304060	\N		2025-05-03 20:50:49.993	2025-05-03 20:50:49.993	\N
1895e40a-960a-4ec2-849e-7bbcf368919e	Isabel	Paredes Cardenas		\N	3221216321	1988-06-09 00:00:00		2025-05-03 20:50:49.993	2025-05-03 20:50:49.993	\N
0314a626-72a1-4bda-a7df-8ae2de298c63	Isabel	Ramirez		\N	\N	1976-09-09 00:00:00		2025-05-03 20:50:49.994	2025-05-03 20:50:49.994	\N
7a37219f-936a-411b-8e75-274dab0b6f69	Hilda Elizabeth	Angel Pagaza		\N	3222747252	\N		2025-05-03 20:50:49.994	2025-05-03 20:50:49.994	\N
99bc1e1a-d3db-4542-837a-1c2825992ab5	Isabel	Zararate galindo		\N	3221320879	\N		2025-05-03 20:50:49.994	2025-05-03 20:50:49.994	\N
19853046-a5da-436c-a593-d6611764d670	Isabel	Zavala		\N	\N	\N		2025-05-03 20:50:49.995	2025-05-03 20:50:49.995	\N
f65ddbfd-4a57-475f-99ff-ee029103bb47	Isabel	Zavala Chavez		isabel.2084@hotmail.com	\N	1984-02-20 00:00:00		2025-05-03 20:50:49.995	2025-05-03 20:50:49.995	\N
2d135911-3f27-4f1b-b114-15a7e7a6f9ba	Isabel Cristina	Vargas Flores		isacrisvf_24@hotmail.com	\N	1973-07-24 00:00:00		2025-05-03 20:50:49.995	2025-05-03 20:50:49.995	\N
d166b288-ef0c-4b38-a228-d5418f98314e	Hector	Galindo Rios		\N	3330667221	\N		2025-05-03 20:50:49.996	2025-05-03 20:50:49.996	\N
7b408f50-960c-4976-87e2-cbbb4810108a	Isabela Citlali	Hernández Santos		\N	\N	\N		2025-05-03 20:50:49.996	2025-05-03 20:50:49.996	\N
046b2746-5732-4085-b120-e77fff99a2ba	Hilda	Andalon Calleros		\N	3221085532	\N		2025-05-03 20:50:49.996	2025-05-03 20:50:49.996	\N
d46054c2-a56a-443d-8853-182627421899	Isac	Lopez Garcia		\N	\N	2012-02-11 00:00:00		2025-05-03 20:50:49.997	2025-05-03 20:50:49.997	\N
82b76dca-77f3-4ee8-9bc6-eab85378808e	Isac	Mariscal Lopez		\N	\N	1984-04-30 00:00:00		2025-05-03 20:50:49.997	2025-05-03 20:50:49.997	\N
37a7e79e-c9aa-47d6-bfe7-c9babb075331	Isac	Santana Mejia		\N	\N	1997-06-24 00:00:00		2025-05-03 20:50:49.997	2025-05-03 20:50:49.997	\N
5c6fc0ee-7414-42d6-b4d7-307b5c2440df	Isac Absalón	Guillen Barajas		\N	\N	1995-03-22 00:00:00		2025-05-03 20:50:49.997	2025-05-03 20:50:49.997	\N
866ef501-62a5-418a-8af2-c6216ddb6eaa	Isac Emanuel	Mariscal Anaya		isacmariscal30@hotmail.com	\N	2004-07-23 00:00:00		2025-05-03 20:50:49.998	2025-05-03 20:50:49.998	\N
3cc45c4d-a785-47a1-b726-611dc21d2145	Isadora	Aguilar Zaragoza		isadoraaguilar@hotmail.com	\N	1974-07-10 00:00:00		2025-05-03 20:50:49.998	2025-05-03 20:50:49.998	\N
9869f977-7eb5-4173-8332-4854ed9eca0e	Isadora	Padilla Mercado		\N	\N	\N		2025-05-03 20:50:49.999	2025-05-03 20:50:49.999	\N
c7de7276-93cc-4372-ae40-dc18e9e7a0c0	Isamar	xx		\N	\N	\N		2025-05-03 20:50:49.999	2025-05-03 20:50:49.999	\N
9a4cfb3b-afeb-4480-8683-ddd3657788bb	Isau	Lopez Ortiz		contacto@sungarden.com.mx	\N	1975-12-15 00:00:00		2025-05-03 20:50:49.999	2025-05-03 20:50:49.999	\N
35440835-d923-4eb7-9139-c23e24aac827	Isela	Jacobo Gonzalez		\N	\N	2008-06-26 00:00:00		2025-05-03 20:50:49.999	2025-05-03 20:50:49.999	\N
29b4b146-2942-404e-a4cd-24b4eb5b5d16	Isela	Muro Macias		\N	\N	1976-10-30 00:00:00		2025-05-03 20:50:50	2025-05-03 20:50:50	\N
5e2be1dd-50fb-441a-a08a-060b4bfad1f3	Isidro	Calvillo Solis		\N	\N	1953-08-24 00:00:00		2025-05-03 20:50:50	2025-05-03 20:50:50	\N
ab0a8d05-3b04-4c0d-a4ad-a0c52f757712	Isidro	Marquez Marquez		\N	\N	1993-06-17 00:00:00		2025-05-03 20:50:50	2025-05-03 20:50:50	\N
fa0d757b-d03e-4efd-8c75-cd34a0da152e	Ignacio	Velazco Luna		\N	3221285608	\N		2025-05-03 20:50:50.001	2025-05-03 20:50:50.001	\N
c668140d-5597-42be-a3e1-d5f8a24be709	Ismael	Pérez Madero		ismael_perezm@hotmail.com	\N	1952-03-13 00:00:00		2025-05-03 20:50:50.001	2025-05-03 20:50:50.001	\N
f76c05c0-19e2-4b58-9693-41301ee41eb9	Iker	Villa Ruiz		\N	3221505293	\N		2025-05-03 20:50:50.002	2025-05-03 20:50:50.002	\N
e3fa880f-d285-4603-b6ec-07ad3a1b9e65	Israel	Montoya Muñoz		\N	\N	\N		2025-05-03 20:50:50.002	2025-05-03 20:50:50.002	\N
7cce2911-dbbf-4a99-8ef4-401c4adfa8ef	Israel	Ramirez Lomeli		israelomeli@hotmail.com	\N	1975-02-12 00:00:00		2025-05-03 20:50:50.002	2025-05-03 20:50:50.002	\N
792163ca-e30a-465d-bffb-f3887fc20539	Israel	Vargas		\N	\N	\N		2025-05-03 20:50:50.003	2025-05-03 20:50:50.003	\N
e56d8665-49cf-4414-95cb-7fea67796faa	Israel	Villegas García		learsi80@hotmil.com	\N	1980-05-10 00:00:00		2025-05-03 20:50:50.003	2025-05-03 20:50:50.003	\N
9538071b-7d8d-4ae7-91f6-081e24784fe8	Istez	Pingarron Bautista		\N	\N	2010-04-28 00:00:00		2025-05-03 20:50:50.003	2025-05-03 20:50:50.003	\N
661d6222-00e9-41c2-9cf2-c76c42210ed1	Ileane Noemi	Sandoval Peña		\N	3222749091	\N		2025-05-03 20:50:50.004	2025-05-03 20:50:50.004	\N
cf351520-9a3a-49eb-8d82-2be30da445aa	Itsel	Montes de Oca Rivas		\N	\N	1980-04-30 00:00:00		2025-05-03 20:50:50.004	2025-05-03 20:50:50.004	\N
794cfd45-a4a7-4aa6-abfc-6271237f4552	Itzel	Montes de Oca		\N	\N	\N		2025-05-03 20:50:50.004	2025-05-03 20:50:50.004	\N
f8a72158-9262-4488-a6a9-f4a9f12d80f1	Hugo	Gutierrez Gutierrez		\N	3331471715	\N		2025-05-03 20:50:50.004	2025-05-03 20:50:50.004	\N
decba959-533e-4ead-83b9-8c8d9ef087c0	Ileana Noemi	Sandoval Peña		\N	3222749091	\N		2025-05-03 20:50:50.005	2025-05-03 20:50:50.005	\N
b44ddbad-c3ee-483e-9870-beafd8fc6348	Ivan	Alcantara Peña		\N	\N	\N		2025-05-03 20:50:50.005	2025-05-03 20:50:50.005	\N
5e2a0069-da84-434a-b390-acb8379b8115	Ivan	Gregorio Serrano		direccion@globacindustrial.es	\N	1986-02-26 00:00:00		2025-05-03 20:50:50.005	2025-05-03 20:50:50.005	\N
5b4bf151-03ae-4516-af47-de0040c74af6	Ivan	Hernandez Castillo		\N	\N	2015-04-16 00:00:00		2025-05-03 20:50:50.006	2025-05-03 20:50:50.006	\N
e45a1237-93e9-4424-ba80-2cd529455807	Ivan	Uriza Luviano		\N	\N	2010-04-30 00:00:00		2025-05-03 20:50:50.006	2025-05-03 20:50:50.006	\N
4901366f-34aa-4d66-ab39-00909e5d3d39	Ivan	Velez Zepeda		iveles_23@hotmail.com	\N	1985-05-06 00:00:00		2025-05-03 20:50:50.006	2025-05-03 20:50:50.006	\N
731a2b5d-f53a-451c-a8a8-cafe98d60b21	Ivanna Atzhiri	Ascencio Carrilllo		ivannascencio4@gmail.com	\N	2002-09-11 00:00:00		2025-05-03 20:50:50.007	2025-05-03 20:50:50.007	\N
6b252c5d-b050-4737-9734-fdcb6833b15b	Imelda	Ascebes Rodrigues		\N	3222940935	\N		2025-05-03 20:50:50.007	2025-05-03 20:50:50.007	\N
47ac877a-a47f-486f-a4c5-1c816137eb30	Ives	Poulin		devilrain1968@yahoo.com	\N	1968-06-16 00:00:00		2025-05-03 20:50:50.007	2025-05-03 20:50:50.007	\N
f831ff6a-3508-489f-b468-b1678a484aa1	Iveth	Tadeo Dena		\N	\N	1988-07-06 00:00:00		2025-05-03 20:50:50.008	2025-05-03 20:50:50.008	\N
189eb24b-2c37-46b8-8656-df54c8828f99	Ivett	Tovar Leyva		\N	\N	1980-05-11 00:00:00		2025-05-03 20:50:50.008	2025-05-03 20:50:50.008	\N
dc4fb021-9cf0-4a38-bcb3-4a78d980f60c	Ivette	Avalos Hernández		\N	\N	2005-07-01 00:00:00		2025-05-03 20:50:50.008	2025-05-03 20:50:50.008	\N
aa07ed6f-43c1-47d4-9b69-6b487089ca2a	Ivette	Urrutia Espino		orto-mezcales@hotmail.com	\N	1976-08-30 00:00:00		2025-05-03 20:50:50.009	2025-05-03 20:50:50.009	\N
e77d754c-970e-454a-97a6-92d2955fb926	Ivonne	Conrriques Godinez		\N	\N	1983-10-30 00:00:00		2025-05-03 20:50:50.009	2025-05-03 20:50:50.009	\N
cae29e21-a191-45df-8680-7afd42398c32	Ivonne	Suazo		\N	\N	\N		2025-05-03 20:50:50.009	2025-05-03 20:50:50.009	\N
ae23a94f-7e13-4903-b020-b10f100743e9	ivonne	xx		\N	\N	2008-04-21 00:00:00		2025-05-03 20:50:50.009	2025-05-03 20:50:50.009	\N
4a6b4bc5-d4fe-42b5-b24c-699522d9374b	Ivonne Alicia	Santa Maria Vivas		\N	\N	1961-12-21 00:00:00		2025-05-03 20:50:50.01	2025-05-03 20:50:50.01	\N
afe37ea3-0d5e-4295-a6e2-cd9b669dbd4b	Ivy	Arce Arzate		\N	\N	2006-03-27 00:00:00		2025-05-03 20:50:50.01	2025-05-03 20:50:50.01	\N
371f66ab-35b8-4d1f-b592-897adb9854af	J. Rosendo	Flores López		\N	\N	1971-03-01 00:00:00		2025-05-03 20:50:50.01	2025-05-03 20:50:50.01	\N
c6753f74-a911-45ec-8a24-ceb1f6109888	Jack	Goowill		\N	\N	\N		2025-05-03 20:50:50.011	2025-05-03 20:50:50.011	\N
bfb508f1-d86f-4c47-8406-c2558def4cb5	Jack	Kenny		jacques.kenny@yahoo.com	\N	1964-02-16 00:00:00		2025-05-03 20:50:50.011	2025-05-03 20:50:50.011	\N
9063fe2b-fdda-444e-95b2-5483bbc6e20f	Jacques	Poutre		marie-gi@hotmail.com	\N	1957-03-27 00:00:00		2025-05-03 20:50:50.011	2025-05-03 20:50:50.011	\N
6b751273-a0a1-4315-89f4-02bf4c7dd41b	Jacques	Robidoux		jaque_line06@hotmail.com	\N	1945-03-17 00:00:00		2025-05-03 20:50:50.012	2025-05-03 20:50:50.012	\N
fc8df35a-f1d4-48b4-bfdf-270686369b49	Jacques	St Jean		lmlaforme1961@gmail.com	\N	1957-07-29 00:00:00		2025-05-03 20:50:50.012	2025-05-03 20:50:50.012	\N
2a574499-7d6c-4060-911a-4af21e7b020b	Jade	Romandetto Haas		tatganh@yahoo.com	\N	2006-09-22 00:00:00		2025-05-03 20:50:50.012	2025-05-03 20:50:50.012	\N
e6a5bb2f-b422-4726-8fff-0e8fbe4b8da6	Jade	Vega Guzman		\N	\N	\N		2025-05-03 20:50:50.013	2025-05-03 20:50:50.013	\N
6262c32f-65ea-4123-a9b0-eed16fd89476	Jade Esmeralda	Vazquez Vargas		\N	\N	2005-05-28 00:00:00		2025-05-03 20:50:50.013	2025-05-03 20:50:50.013	\N
770b51af-332c-4adb-b392-ade778e86d85	Isis Elizabeth	Gomez Marmolejo		\N	3333590105	\N		2025-05-03 20:50:50.013	2025-05-03 20:50:50.013	\N
ab01763e-cd41-4c5b-a91c-b415bc0d3780	Irving	Santana		miriamcast2023@icloud.com	+526647523205	\N		2025-05-03 20:50:50.014	2025-05-03 20:50:50.014	\N
24013f3d-98ab-47b3-8470-2f7ddd804bc5	Irving Giovanny	Macias Huerta		\N	3221413917	\N		2025-05-03 20:50:50.014	2025-05-03 20:50:50.014	\N
b141fa0d-7d66-4290-954e-7b602c5e81d1	jaime	carmona		\N	\N	2007-04-20 00:00:00		2025-05-03 20:50:50.014	2025-05-03 20:50:50.014	\N
f88fb7d6-9471-4139-9b28-3b6fa6d000ca	Jaime	Carmona Leal		\N	\N	2007-04-21 00:00:00		2025-05-03 20:50:50.015	2025-05-03 20:50:50.015	\N
77e3f6b0-0f0a-439b-a1d6-6b9567c7a933	Jaime	Diaz Burciaga		jaimedeoj@gmail.com	\N	1993-12-02 00:00:00		2025-05-03 20:50:50.015	2025-05-03 20:50:50.015	\N
36b02320-83dd-45b5-b738-a2a444770860	inna Daniel	Ramirez Hernández		\N	3221514698	\N		2025-05-03 20:50:50.015	2025-05-03 20:50:50.015	\N
4d3ab5e4-054a-4ee6-801b-430a1686764f	Jahel	Tabera Minero		\N	3335702565	\N		2025-05-03 20:50:50.016	2025-05-03 20:50:50.016	\N
4e2e5546-c4a2-4e90-944a-a41e999a29e5	Jaime	Paniagua Casillas		ing_jpc@hotmail.com	\N	1971-05-30 00:00:00		2025-05-03 20:50:50.016	2025-05-03 20:50:50.016	\N
180ec2cb-d23a-4084-9526-41569085bec3	Jaime	Rivera García		\N	\N	2009-05-02 00:00:00		2025-05-03 20:50:50.016	2025-05-03 20:50:50.016	\N
e01d7df0-2864-4541-9ee2-fb1c0a34db55	Isabel	Cueva Iturria		valeriayturria@gmail.com	+528181620337	2014-09-07 00:00:00		2025-05-03 20:50:50.017	2025-05-03 20:50:50.017	\N
50996302-1b12-4b48-96f8-8e83832d0f2d	Jaden job	Santana ramirez		Lola.rch93@gmail.com	+523221056340	2013-10-01 00:00:00		2025-05-03 20:50:50.017	2025-05-03 20:50:50.017	\N
7f1637e8-7704-4e22-af4a-a0cb96acd38c	Jaime Alexis	Franco Santana		jamesdfrank96@gmail.com	\N	1996-01-30 00:00:00		2025-05-03 20:50:50.017	2025-05-03 20:50:50.017	\N
83be15ab-2ddf-4af9-8af1-2ecdd9a8b24a	Jair	Covarrubias Samaniego		\N	\N	1995-09-02 00:00:00		2025-05-03 20:50:50.018	2025-05-03 20:50:50.018	\N
6ec14376-08d4-4952-b791-c3eb628a9d03	Jairo Yair	Preciado Rodriguez		preciado_yair@hotmail.com	\N	1989-12-17 00:00:00		2025-05-03 20:50:50.018	2025-05-03 20:50:50.018	\N
1caff14d-8b1e-48c9-b927-58d6d4b52a17	Jake	Webb		vbjake96@gmial.com	\N	1996-03-02 00:00:00		2025-05-03 20:50:50.018	2025-05-03 20:50:50.018	\N
73659238-9290-4b14-af44-dd9ad586ba0b	James	Bearden		bevo89@hotmail.com	\N	1975-11-17 00:00:00		2025-05-03 20:50:50.019	2025-05-03 20:50:50.019	\N
4ba5272c-e431-4439-b329-2b8f452aa88d	James	Berkley		jamesberklay@hotmail.com	3222169613	1959-10-23 00:00:00		2025-05-03 20:50:50.019	2025-05-03 20:50:50.019	\N
300183ae-29b4-4339-87bf-7fb44dc041a2	Isabela	Contreras Zaragoza		\N	+15106773524	\N		2025-05-03 20:50:50.019	2025-05-03 20:50:50.019	\N
cce38fef-6548-446a-9a17-e6626e2a46ae	James	Larlham		larlham@telusplanet.net	\N	1957-09-01 00:00:00		2025-05-03 20:50:50.02	2025-05-03 20:50:50.02	\N
74427a12-fffb-46bd-869e-5f7ac9161319	James	Larlham		larham@telesplantet.net	3222937033	1957-09-04 00:00:00		2025-05-03 20:50:50.02	2025-05-03 20:50:50.02	\N
dcdb8f81-6131-4602-b020-14735fe4b52f	James	Wiggins		zanwiggins@yahoo.com	\N	1976-04-23 00:00:00		2025-05-03 20:50:50.02	2025-05-03 20:50:50.02	\N
6cb24e00-1a93-4952-9052-982adf28af84	James	Wilson		\N	\N	2008-02-12 00:00:00		2025-05-03 20:50:50.02	2025-05-03 20:50:50.02	\N
7b55a3f4-2084-4eb4-a493-a78e3106d15e	Jamie	Csobot		jamiecsubot@gmai.com	\N	1991-07-30 00:00:00		2025-05-03 20:50:50.021	2025-05-03 20:50:50.021	\N
a30936dd-25a7-42a9-9e8f-eb7714e07db0	Jamie Isabella	Berkley Paredes		\N	\N	2010-08-19 00:00:00		2025-05-03 20:50:50.021	2025-05-03 20:50:50.021	\N
409ace5c-26bb-4d25-9942-e6068a53f70a	Jan Pol	Abaji		\N	\N	2011-02-09 00:00:00		2025-05-03 20:50:50.021	2025-05-03 20:50:50.021	\N
866e7b53-197b-42a1-8ec5-5359f8f7065d	Janeth	Zanabria Castro		janethzc@gmail.com	\N	1987-12-08 00:00:00		2025-05-03 20:50:50.022	2025-05-03 20:50:50.022	\N
c73ace85-182d-408e-95d6-afee7cd4d998	Janette	Contreras Robles		janethcontreras26@hotmail.com	\N	1989-04-27 00:00:00		2025-05-03 20:50:50.022	2025-05-03 20:50:50.022	\N
a92f3d5c-b367-4efd-991b-cf26777381c8	Janice	Cooper		janice.goarbor@com	\N	1958-08-07 00:00:00		2025-05-03 20:50:50.022	2025-05-03 20:50:50.022	\N
5a9ad573-fb7e-4463-ad7a-3399d352fe1f	Janice	Rose		\N	\N	\N		2025-05-03 20:50:50.023	2025-05-03 20:50:50.023	\N
1e98d9fa-4f52-46a6-95d0-54d000af14a9	Janice	xxx		\N	\N	\N		2025-05-03 20:50:50.023	2025-05-03 20:50:50.023	\N
d2f73fe3-bd49-448c-89cb-567aeb4d47b7	Jannet	Miroslava Coronel Castañeda		\N	\N	\N		2025-05-03 20:50:50.023	2025-05-03 20:50:50.023	\N
0324912f-5560-4ecd-b56f-5ed75171bcbe	Jaqueline	Aguilar Rosas		\N	\N	2008-02-29 00:00:00		2025-05-03 20:50:50.024	2025-05-03 20:50:50.024	\N
de00a223-f8b6-408b-9467-568ef6c3a92d	Jaqueline	Jimenez Ledezma		\N	\N	2007-04-03 00:00:00		2025-05-03 20:50:50.024	2025-05-03 20:50:50.024	\N
b5302c81-4cef-4e13-8904-9c56c8c58708	Jaques	Poutre		\N	\N	\N		2025-05-03 20:50:50.024	2025-05-03 20:50:50.024	\N
efd2d2e3-6083-479d-9146-def66abdbe53	Jareidi	Zamora Beavides		jareidibenavides@gmail.com	\N	1997-08-31 00:00:00		2025-05-03 20:50:50.025	2025-05-03 20:50:50.025	\N
b63b3e7e-90f3-4f69-a878-e442825daa7d	Jasmyn	Ramós Gomez		\N	\N	2009-05-21 00:00:00		2025-05-03 20:50:50.025	2025-05-03 20:50:50.025	\N
9acef3a1-b4d3-44a3-a7d2-72d942793784	Jason	Flores Rosales		\N	\N	\N		2025-05-03 20:50:50.025	2025-05-03 20:50:50.025	\N
a597cd92-c843-4a95-970d-5a06acd6fa5a	Javier	Aguilar Otero		\N	\N	\N		2025-05-03 20:50:50.026	2025-05-03 20:50:50.026	\N
bc34ed07-dc58-4e2c-9cb6-878e983a5159	Javier	Cardenas Godines		javiercardenasgodines@gmail.com	\N	1965-08-17 00:00:00		2025-05-03 20:50:50.026	2025-05-03 20:50:50.026	\N
119455ac-3c17-46fb-90c3-8c2112315869	Javier	Carrillo Valle		\N	\N	2008-12-15 00:00:00		2025-05-03 20:50:50.026	2025-05-03 20:50:50.026	\N
c0c59613-41ab-432b-954c-abb15fb7a36c	Javier	Castrejon Acosta		\N	\N	2010-07-05 00:00:00		2025-05-03 20:50:50.027	2025-05-03 20:50:50.027	\N
c7c6bcba-aacc-4bf2-9857-fb1db0aac5d5	Javier	Fierro Hernández		javierfierro_21@hotmail.com	\N	1992-01-21 00:00:00		2025-05-03 20:50:50.027	2025-05-03 20:50:50.027	\N
cca14bd0-6ba3-4fd4-a979-168d8895acc1	Javier	García García		xaviergarci@hotmail.com	\N	1955-03-05 00:00:00		2025-05-03 20:50:50.027	2025-05-03 20:50:50.027	\N
a4983319-a1b1-43b8-b9e1-457127eee2f9	Javier	Garcia Rosales		\N	\N	\N		2025-05-03 20:50:50.028	2025-05-03 20:50:50.028	\N
c3cfa6b5-53ab-4265-82f8-8711ec0bafea	Javier	Guzman Palacios		jg189719@gmail.com	\N	1987-10-20 00:00:00		2025-05-03 20:50:50.028	2025-05-03 20:50:50.028	\N
d3073828-4748-486f-8e0a-274cf6efb5b6	Javier	Hermocillo Pazuengo		jhpazuengo@hotmail.com	3222251010	1955-07-30 00:00:00		2025-05-03 20:50:50.028	2025-05-03 20:50:50.028	\N
ad6aa93c-cefe-44a0-84a1-108e5dec5ad8	Isabella A.	Contreras		julio11contreras@gmail.com	+15106773524	\N		2025-05-03 20:50:50.029	2025-05-03 20:50:50.029	\N
03fa7cc5-161c-471c-9586-4ab691bde422	Javier	Islas Galindo		\N	\N	1973-04-29 00:00:00		2025-05-03 20:50:50.029	2025-05-03 20:50:50.029	\N
f4bddc42-69e3-43ed-85fd-c074e3142938	Javier	Jayregi Peña		\N	\N	\N		2025-05-03 20:50:50.029	2025-05-03 20:50:50.029	\N
139a180a-8e24-41f2-9752-87a3c1ddc094	Javier	Jimenez Saucedo		\N	\N	1966-10-31 00:00:00		2025-05-03 20:50:50.03	2025-05-03 20:50:50.03	\N
251558fb-75ce-4a9f-a03c-41bd503cc9a0	Javier	Lampreabe		javilamp@hotmail.com	3221832512	1962-08-04 00:00:00		2025-05-03 20:50:50.03	2025-05-03 20:50:50.03	\N
8376bb36-bc6a-458a-a929-b1a6c371732e	Javier	Maldonado Muñoz		\N	\N	1959-06-16 00:00:00		2025-05-03 20:50:50.03	2025-05-03 20:50:50.03	\N
49710da3-83b1-4585-b6ce-a7a85f4025c6	Javier	Mondragon Arreola		\N	\N	\N		2025-05-03 20:50:50.031	2025-05-03 20:50:50.031	\N
68a264ff-d633-4c1b-9cd1-2fcf7f18b795	Javier	Moreno Padilla		\N	\N	\N		2025-05-03 20:50:50.031	2025-05-03 20:50:50.031	\N
a1cae751-e442-48ce-a076-1c3623f38cf8	Javier	Nava Berugmen		\N	\N	1966-09-20 00:00:00		2025-05-03 20:50:50.031	2025-05-03 20:50:50.031	\N
e1aa9c29-5e8f-4b0f-8da8-96976bbae45f	Javier Abraham	Rodrígue Valdes		rovj171178@hotmail.com	\N	1978-11-17 00:00:00		2025-05-03 20:50:50.032	2025-05-03 20:50:50.032	\N
f0643126-1bf2-4244-af39-bbf005708670	Houslley	Silva		\N	4155868775	\N		2025-05-03 20:50:50.032	2025-05-03 20:50:50.032	\N
1f75df69-6244-47ed-abb7-981d2e3c1639	Itay	Maor		\N	+18183006790	\N		2025-05-03 20:50:50.032	2025-05-03 20:50:50.032	\N
a1ba0cf3-8751-4273-9582-00eff69bec91	Jazmin	Estrella García		\N	\N	2007-04-02 00:00:00		2025-05-03 20:50:50.032	2025-05-03 20:50:50.032	\N
d9e49899-6f5c-46fe-9f26-c69beff2061a	Jazmin	Lomeli Villegas		jaslovi2710@gmail.com	\N	1996-11-27 00:00:00		2025-05-03 20:50:50.033	2025-05-03 20:50:50.033	\N
46f9811e-44e0-44d1-b8b5-81716b7c695f	Jazmin	Nuñez		\N	\N	1993-06-04 00:00:00		2025-05-03 20:50:50.033	2025-05-03 20:50:50.033	\N
c87610e5-3fd2-49d4-8aea-7194576f11f0	Jazmín	Peréx Cisneros		\N	\N	\N		2025-05-03 20:50:50.033	2025-05-03 20:50:50.033	\N
1ce0d13f-8f7a-4319-aadc-167974bec230	Jazmin	Perez Cisneros		jacapec@hotmail.com	\N	1982-06-29 00:00:00		2025-05-03 20:50:50.034	2025-05-03 20:50:50.034	\N
be39a812-0636-4842-92d3-8125b075f620	Jazmin	Robles Alvares		jazmin_jra@hotmail.com	\N	1986-05-27 00:00:00		2025-05-03 20:50:50.034	2025-05-03 20:50:50.034	\N
6c806521-e00d-4147-84d5-3bac67333126	Jazmin	Ruiz Diaz		\N	\N	1974-04-17 00:00:00		2025-05-03 20:50:50.034	2025-05-03 20:50:50.034	\N
1887d357-6900-49d8-9040-3e1006214486	Jazmin Estrella	Garcia Aragon		\N	\N	\N		2025-05-03 20:50:50.035	2025-05-03 20:50:50.035	\N
12948596-7fc9-437a-bd07-63a5ae1b02d0	Jazmin Merari	Vega Maldonado		mharba89@hotmail.com	\N	1993-10-18 00:00:00		2025-05-03 20:50:50.035	2025-05-03 20:50:50.035	\N
36d6c203-9f6a-4443-8ac6-e4717458baf1	Jean Carlo	Gutierres Ramos		\N	\N	2012-11-06 00:00:00		2025-05-03 20:50:50.035	2025-05-03 20:50:50.035	\N
37a53776-ea18-411d-b021-7965580e1958	Jean Paul	Abagi García		\N	\N	2011-02-10 00:00:00		2025-05-03 20:50:50.035	2025-05-03 20:50:50.035	\N
0bfe3256-5594-4e6a-a018-511759bbb79e	Jean Pierre	Tremblay		loupix@hotmail.com	\N	1956-03-23 00:00:00		2025-05-03 20:50:50.036	2025-05-03 20:50:50.036	\N
d3da437d-58e4-4022-86ce-98d3a259dea9	Itzel	Rodriguez Zaragoza		\N	3512259524	\N		2025-05-03 20:50:50.036	2025-05-03 20:50:50.036	\N
2b6db522-d48e-4584-8e20-8fac040fbc27	Jeanne	Benard		jeanebernard97@gmail.com	\N	1946-10-11 00:00:00		2025-05-03 20:50:50.036	2025-05-03 20:50:50.036	\N
0b453828-06e4-4ae0-aceb-4a51021b7758	Israel	Enrriquez Nicolas		\N	3221829368	\N		2025-05-03 20:50:50.037	2025-05-03 20:50:50.037	\N
855b39e2-76b7-4070-a6b7-3d4a082514c4	Jeff	Williams		jnw42970@gmail.com	\N	1970-04-29 00:00:00		2025-05-03 20:50:50.037	2025-05-03 20:50:50.037	\N
092c7bfb-de88-4199-a7b1-72ffcf2abf07	Jenifer	Celis Amezcua		jenmifer_c@hotmau.com	3221023165	1983-07-04 00:00:00		2025-05-03 20:50:50.037	2025-05-03 20:50:50.037	\N
6d4ee3ff-ab3f-4132-b3c1-9eb9f8b00555	Jeniffer	Ochoa Hernández		\N	\N	\N		2025-05-03 20:50:50.038	2025-05-03 20:50:50.038	\N
22b4a7a9-63b0-4f79-b014-5f7afc100b1b	Jeanette	Escobedo Toscano		\N	3222005732	\N		2025-05-03 20:50:50.038	2025-05-03 20:50:50.038	\N
fb4e074b-4b9e-47b5-a4fb-e09ddd921e8f	Jennifer	Paniagua		lorenajisa@hotmail.com	\N	1999-10-02 00:00:00		2025-05-03 20:50:50.038	2025-05-03 20:50:50.038	\N
6f213d89-effd-496a-94c0-0d94db6c8579	Ivanna Atzhiri	Ascencio Carrillo		\N	3311806514	\N		2025-05-03 20:50:50.039	2025-05-03 20:50:50.039	\N
9652f126-168f-44a5-b7ee-b8e1ad9b0200	Jerry	Chung		\N	\N	\N		2025-05-03 20:50:50.039	2025-05-03 20:50:50.039	\N
1f85d81f-8920-4fe4-82b5-53dbfe698b8e	Jesica	Robles Gonzales		\N	\N	2009-11-13 00:00:00		2025-05-03 20:50:50.039	2025-05-03 20:50:50.039	\N
2997ccc0-5049-497b-a630-b59a5002d9d4	Jessemia	Patiño Rios		panoriossoprano@hotmail.com	\N	1984-05-25 00:00:00		2025-05-03 20:50:50.04	2025-05-03 20:50:50.04	\N
2e8810bb-6487-4233-a9d3-dfda96c2e73f	Jessica	Alvarez Castrillon		\N	\N	1993-12-18 00:00:00		2025-05-03 20:50:50.04	2025-05-03 20:50:50.04	\N
d31b380c-0ecc-4f83-9e27-65f189bb9b99	Jessica	Alvarez Jimenez		drajessicaalvarez@hotmail.es	\N	1956-06-16 00:00:00		2025-05-03 20:50:50.04	2025-05-03 20:50:50.04	\N
6ea94507-94ff-4819-85f3-96b54c2c97bd	Jessica	Arrona Ortiz		\N	\N	\N		2025-05-03 20:50:50.041	2025-05-03 20:50:50.041	\N
50fddcd2-6755-4052-b6c2-417380ebea74	Jessica	XX		\N	\N	\N		2025-05-03 20:50:50.041	2025-05-03 20:50:50.041	\N
e55a2d9f-fd72-49fb-9b6e-aaa2204b5783	Jessica Adriana	Rangel Vera		\N	\N	1985-05-03 00:00:00		2025-05-03 20:50:50.041	2025-05-03 20:50:50.041	\N
cf44bcd9-8d66-4088-9f15-bf1e20a8b745	Jessie	Lanaway		jessie.lanaway@gmail.com	\N	1986-04-23 00:00:00		2025-05-03 20:50:50.042	2025-05-03 20:50:50.042	\N
aa03f62e-7962-4d65-9d86-c656c0d33c0f	Itzuri	Vázquez		itzuri_alejandra_v.p@hotmail.com	+523222441932	\N		2025-05-03 20:50:50.042	2025-05-03 20:50:50.042	\N
5b1bae32-b326-467d-8368-0fac5b9021f9	Jessy	Silva Ranguel		\N	\N	2009-09-13 00:00:00		2025-05-03 20:50:50.042	2025-05-03 20:50:50.042	\N
93cb857b-2b54-4528-bd31-dc61065d1a07	Jesus	Amezcua Hernandez		\N	\N	\N		2025-05-03 20:50:50.043	2025-05-03 20:50:50.043	\N
5b8b5b41-2378-45fb-9b76-beb074cf3087	Jesus	Castro Vargas		chuycastrov@hotmail.com	\N	1961-01-28 00:00:00		2025-05-03 20:50:50.043	2025-05-03 20:50:50.043	\N
08d38ac5-935d-490e-a775-1b8b1aefef87	Jesús	Flores Torres		\N	\N	2008-01-12 00:00:00		2025-05-03 20:50:50.043	2025-05-03 20:50:50.043	\N
9d50020d-f462-4792-bd25-ea5ede9acf42	Jesus	Garcia Zuniga		s_chuy@hotmail.com	\N	1980-12-24 00:00:00		2025-05-03 20:50:50.044	2025-05-03 20:50:50.044	\N
a8f31aee-aee6-4e8c-b4af-3c342fd3e91a	Jesus	Gonzales Aguílar		\N	\N	1969-12-12 00:00:00		2025-05-03 20:50:50.044	2025-05-03 20:50:50.044	\N
1310a3b8-0d69-4411-aafc-4dd0eadc396d	Jesús	Hernández Figueroa		hedezjunior@hotmail.com	\N	1982-03-29 00:00:00		2025-05-03 20:50:50.044	2025-05-03 20:50:50.044	\N
fe745dc5-8f06-42dd-ba70-e303e57350aa	Jaime	Esqueda		machu1934@hotmail.com	+523329373436	\N		2025-05-03 20:50:50.045	2025-05-03 20:50:50.045	\N
c3d4da53-e480-45e6-95ab-a40c3bf46b38	Jesus	Lopez Mendoza		\N	\N	\N		2025-05-03 20:50:50.045	2025-05-03 20:50:50.045	\N
f00a9e68-d198-4773-93b6-27e02246b827	Jesus	López Quezáda		\N	\N	1989-01-15 00:00:00		2025-05-03 20:50:50.045	2025-05-03 20:50:50.045	\N
f4483638-dfa9-423a-b470-8dc93963cd51	Jesús	Luna Rodríguez		jdejesusl@hotmail.com	\N	1982-01-03 00:00:00		2025-05-03 20:50:50.046	2025-05-03 20:50:50.046	\N
875fb7d6-e9d1-4f38-8762-2df86be97af2	Isabel	Torres López		\N	3222465508	\N		2025-05-03 20:50:50.046	2025-05-03 20:50:50.046	\N
a7b1f5ee-ff87-4416-8be1-827dfbeb11b0	Jesus	Martinez		\N	\N	\N		2025-05-03 20:50:50.046	2025-05-03 20:50:50.046	\N
560420ad-192c-4940-9c16-7d33d2261c22	Jesus	Mejia Jr		\N	\N	1995-09-26 00:00:00		2025-05-03 20:50:50.047	2025-05-03 20:50:50.047	\N
b2d1e552-ae2d-4942-8650-95bb070531d7	Jesus	Montaño Ramires		\N	\N	\N		2025-05-03 20:50:50.047	2025-05-03 20:50:50.047	\N
19e804b4-0d16-4207-97f2-cc0ec90e64ca	Jesus	Montaño Ramirez		\N	\N	1913-11-08 00:00:00		2025-05-03 20:50:50.047	2025-05-03 20:50:50.047	\N
5d15f6a7-c9bf-4b17-b73f-971273f66a1a	Jaden	Portillo Riux		\N	3223298321	\N		2025-05-03 20:50:50.048	2025-05-03 20:50:50.048	\N
0ab224d2-8d40-4379-9cfd-79206e8c8c29	Jesus	Navarrete		\N	3221350635	1984-07-01 00:00:00		2025-05-03 20:50:50.048	2025-05-03 20:50:50.048	\N
3cb70811-f5ee-4691-8c4a-39ae70ad55b2	Jesus	Navarrete Alcivia		jesus.alcivia@yahoo.com	\N	1984-07-01 00:00:00		2025-05-03 20:50:50.048	2025-05-03 20:50:50.048	\N
b476b7b9-63eb-4c29-806b-c41abd7eb692	Jesus	Olmos Estrada		\N	\N	1959-05-12 00:00:00		2025-05-03 20:50:50.049	2025-05-03 20:50:50.049	\N
b3f5293b-2d6c-4977-93d3-5b5f960d1ab0	Jesus	Ortega		\N	\N	\N		2025-05-03 20:50:50.049	2025-05-03 20:50:50.049	\N
ba93cbf0-4aaa-41a7-8bcb-f245482c9efd	Jesus	Peña Velazco		\N	\N	2010-06-07 00:00:00		2025-05-03 20:50:50.049	2025-05-03 20:50:50.049	\N
b0dc1e8e-3a61-4519-8704-314ecb57fa55	Jaime	Zavala Martinez		\N	3221562567	\N		2025-05-03 20:50:50.049	2025-05-03 20:50:50.049	\N
c806dc94-3996-438a-ae64-3f6d64e76c73	Jesus	Sanchez Jimenez		\N	\N	2011-01-20 00:00:00		2025-05-03 20:50:50.05	2025-05-03 20:50:50.05	\N
ae4ccf06-cb67-4e5d-911b-dd49b42f4e56	Jesus	Sancj		\N	\N	2011-01-20 00:00:00		2025-05-03 20:50:50.05	2025-05-03 20:50:50.05	\N
1ad66f52-e27c-4b40-871f-9391858d95b5	Jesus	Santana Barrera		jesus081267@hotmail.com	\N	1967-12-08 00:00:00		2025-05-03 20:50:50.05	2025-05-03 20:50:50.05	\N
a23e898e-f68a-4d4d-a84c-17f83ebd2327	Jesus	Torres magaña		\N	\N	\N		2025-05-03 20:50:50.051	2025-05-03 20:50:50.051	\N
21676c84-6c84-41d4-868f-0f2b3f54d122	Jesus	ZARTE ESCOBEDO		\N	\N	2009-10-05 00:00:00		2025-05-03 20:50:50.051	2025-05-03 20:50:50.051	\N
ff53c5d3-4a51-43ab-8a5b-95fe4fc962d1	James	Berkley		jamesberkley@yahoo.com	+523222169613	\N		2025-05-03 20:50:50.051	2025-05-03 20:50:50.051	\N
4891938a-5dea-4d76-8e63-24363ca06359	Javier Juan	Agustidiano Clemente		\N	\N	\N		2025-05-03 20:50:50.052	2025-05-03 20:50:50.052	\N
010dcc2e-7deb-4873-acb3-529cd55a8dbc	Jesus Alfonzo	Gutierrez Valenzuela		chefalfonzo@hotmail.com	\N	1961-11-02 00:00:00		2025-05-03 20:50:50.052	2025-05-03 20:50:50.052	\N
d9dafb90-429b-4d51-bab3-4f57890026f4	Jesús António	Briones Sánchez		\N	\N	1996-07-04 00:00:00		2025-05-03 20:50:50.052	2025-05-03 20:50:50.052	\N
4d9c40d6-bdcf-493b-98f9-de59ce70b079	Jesus Antonio	Caloca Diaz		\N	\N	2012-10-11 00:00:00		2025-05-03 20:50:50.053	2025-05-03 20:50:50.053	\N
19e30371-5219-4964-9837-b7c8a5136fa6	Jesus Carlos	Casillas Martinez		\N	\N	2010-06-04 00:00:00		2025-05-03 20:50:50.053	2025-05-03 20:50:50.053	\N
6a3be204-262f-48ae-95a5-0a5b84a7cd92	Jesùs Eduardo	Narvaes Cabrera		\N	\N	1970-12-27 00:00:00		2025-05-03 20:50:50.053	2025-05-03 20:50:50.053	\N
33676527-ae6d-4562-9b86-d5d32430b6c5	Jesus Eduardo	Sanchez Enrriquez		lalin_sanchez@hotmail.com	\N	1968-05-06 00:00:00		2025-05-03 20:50:50.054	2025-05-03 20:50:50.054	\N
7358a09b-7903-45fb-bd63-b7bfd7655e97	Jennica	Wheeler		\N	+14034660324	\N		2025-05-03 20:50:50.054	2025-05-03 20:50:50.054	\N
84731b86-cdeb-4be9-8cac-8c5a7c4508fb	Jesus Emannuel	Grajeda  Torres		\N	\N	2007-11-28 00:00:00		2025-05-03 20:50:50.054	2025-05-03 20:50:50.054	\N
04df54d0-6477-49f2-bbf7-af32ed9ffe6d	Jesus Emmanuel	Grajeda Torres		\N	\N	\N		2025-05-03 20:50:50.055	2025-05-03 20:50:50.055	\N
7cf08e98-7554-4b5a-bbca-3f77b1d6eb10	Jesus Fernando	Solis Hernandez		solis_262@hotmail.com	3221910119	1966-09-18 00:00:00		2025-05-03 20:50:50.055	2025-05-03 20:50:50.055	\N
bf0ab1cf-5984-4c36-8b1a-1747868379f9	Jesus Gerardo	Soriano Lopéz		soriano-59@hotmail.com	\N	1959-02-16 00:00:00		2025-05-03 20:50:50.056	2025-05-03 20:50:50.056	\N
f75f2a67-e3f3-487e-89ef-dfa905b7f57a	Jesus Ivan	Castro Barajas		ivancb-@hotmail.com	013292987101	1988-03-11 00:00:00		2025-05-03 20:50:50.056	2025-05-03 20:50:50.056	\N
94a37ccc-efd8-4950-8ef0-f67397c36721	Jesus Jóse	Rodriguez Campoy		lic.campoy@hotmail.com	\N	1950-01-13 00:00:00		2025-05-03 20:50:50.056	2025-05-03 20:50:50.056	\N
c254b985-5f0b-438b-8138-3dede5722ccf	Jesus M.	Petrasa		\N	\N	\N		2025-05-03 20:50:50.057	2025-05-03 20:50:50.057	\N
864ca97a-14fc-45f1-9c3f-36b165e97f9e	Jesus Rafael	Rosas Ortiz		\N	\N	\N		2025-05-03 20:50:50.057	2025-05-03 20:50:50.057	\N
84707016-2580-4028-8ed3-578cbdd0a3b6	Jesus Salvadoir	Ortega Castillo		\N	\N	1986-12-13 00:00:00		2025-05-03 20:50:50.057	2025-05-03 20:50:50.057	\N
9044a4fa-2457-4242-ab5c-ffa5174596fc	Jeany Marisol	López Padilla		\N	3221483939	\N		2025-05-03 20:50:50.058	2025-05-03 20:50:50.058	\N
e4491483-41ef-4240-904f-2c80b6b7942d	Jheanny	Delgado Gonzales		shellydonovan88@hotmail.com	\N	1988-07-27 00:00:00		2025-05-03 20:50:50.058	2025-05-03 20:50:50.058	\N
610d359b-d849-44c0-be81-425bd8c34915	Jhon	Copd		\N	\N	\N		2025-05-03 20:50:50.058	2025-05-03 20:50:50.058	\N
2ca3e3e9-b37f-4cd6-a57d-17576c9507e1	Jhon	Martlew		\N	\N	1949-09-16 00:00:00		2025-05-03 20:50:50.058	2025-05-03 20:50:50.058	\N
3cc6d385-2c86-4dfc-a4ef-16e80378cd7b	Jhon	Muellen		jamaueller47@gmail.com	\N	1965-04-04 00:00:00		2025-05-03 20:50:50.059	2025-05-03 20:50:50.059	\N
b8a5d0c9-b534-43ae-9813-e0bd60a532a6	Jhon	Power		brendaleepower@hotmail.com	\N	\N		2025-05-03 20:50:50.059	2025-05-03 20:50:50.059	\N
1c0e480e-cb29-4a05-91d8-09b9ecf0a136	Jhonas	Fankhauser		\N	\N	1981-12-14 00:00:00		2025-05-03 20:50:50.059	2025-05-03 20:50:50.059	\N
1282c1dc-07bc-4b80-960a-dfd4b7f8b83a	Jhonatan	Ramírez Hernández		\N	\N	1989-07-05 00:00:00		2025-05-03 20:50:50.06	2025-05-03 20:50:50.06	\N
12b3a868-d8cd-43ec-a521-4ac1b08e3c34	Javier	Hernández Nava		javier.hernandeznava1973@gmail.com	+523221058850	\N		2025-05-03 20:50:50.06	2025-05-03 20:50:50.06	\N
6db82b41-a67c-4a5b-9245-7883134ddc46	Jhuliana	López Martínez		jhuliana_0728@hotmail.com	\N	1990-07-28 00:00:00		2025-05-03 20:50:50.06	2025-05-03 20:50:50.06	\N
b98ad29a-ecff-428c-ac95-e954c45118de	Jim	Chioros		\N	\N	1963-09-18 00:00:00		2025-05-03 20:50:50.061	2025-05-03 20:50:50.061	\N
fa6d5e8a-8f53-40f8-bbce-bb38ff026406	Jimena	Coronado Altamirano		jimcoralt71@gmail.com	\N	1995-03-04 00:00:00		2025-05-03 20:50:50.061	2025-05-03 20:50:50.061	\N
d2f2cc24-7d6b-4a13-b38d-edb41c024113	Jimena	Garza Colin		\N	\N	\N		2025-05-03 20:50:50.061	2025-05-03 20:50:50.061	\N
225a9741-b7c7-4e2d-a138-2e6fceecc8ce	Jimena	Gavidia Valencia		\N	\N	2008-03-08 00:00:00		2025-05-03 20:50:50.062	2025-05-03 20:50:50.062	\N
a65a8932-b82c-4ed1-86ef-c8a8385ab883	Jimena	Malacara crenteria		\N	\N	\N		2025-05-03 20:50:50.062	2025-05-03 20:50:50.062	\N
4864f06b-cde4-4434-8eec-f51335699841	Jimena	Ramirez  dela Peña		\N	\N	1984-10-17 00:00:00		2025-05-03 20:50:50.062	2025-05-03 20:50:50.062	\N
7d151924-6ddd-4390-8241-32713b404d13	Jimy Andres	Perez Cardenas		\N	\N	1980-11-02 00:00:00		2025-05-03 20:50:50.063	2025-05-03 20:50:50.063	\N
386533a2-43ab-4f2f-86c0-a76aaed1958a	Jiran	Mendoza Ramírez		\N	\N	\N		2025-05-03 20:50:50.063	2025-05-03 20:50:50.063	\N
4da85556-471c-4e10-b35a-115c36ff6b71	Jaime	Velez Torres		\N	3221274163	\N		2025-05-03 20:50:50.063	2025-05-03 20:50:50.063	\N
d6710b10-cfe0-4bef-bbac-b9113d74ef6d	Joan Manuel	Ciprian		alo-161@hotmail.com	\N	1985-09-23 00:00:00		2025-05-03 20:50:50.064	2025-05-03 20:50:50.064	\N
6bc14113-a85f-4108-b529-4cb627c65dd8	Joana	Abaji		\N	\N	2011-02-09 00:00:00		2025-05-03 20:50:50.064	2025-05-03 20:50:50.064	\N
92200d79-d102-4cc7-856e-534796cc16b5	Joana	Delgado Gonzales		\N	\N	\N		2025-05-03 20:50:50.064	2025-05-03 20:50:50.064	\N
ac0276ff-e4e0-4d19-9750-6b6da027cd30	Joanathan Gabriel	Neyra Corona		\N	\N	1983-03-22 00:00:00		2025-05-03 20:50:50.065	2025-05-03 20:50:50.065	\N
756a9d01-b4f0-4991-9d90-dd8033bf519c	Joanna Carolina	Martinez Hernández		jocamahe@hotmail.com.	\N	1979-09-26 00:00:00		2025-05-03 20:50:50.065	2025-05-03 20:50:50.065	\N
aeebdb70-24e1-4cc8-bda7-1d8b097f722e	Joary	Morales Campos		joarymc14@live.mx	\N	1992-06-14 00:00:00		2025-05-03 20:50:50.065	2025-05-03 20:50:50.065	\N
65245bf5-3a7c-468b-8591-88f202f152e3	Job	Ordaz Hernandez		vayjob@hotmail.com	\N	1988-08-01 00:00:00		2025-05-03 20:50:50.066	2025-05-03 20:50:50.066	\N
50c19647-e0ba-4290-a18b-79337bc04ce2	Job	Peña Gonzalez		\N	\N	2008-10-21 00:00:00		2025-05-03 20:50:50.066	2025-05-03 20:50:50.066	\N
42cd73e8-8436-4a47-bcaf-a0a41785627d	Job Abdom Jr.	Peña Gonzalez		jobpg1@gmail.com	\N	1993-08-18 00:00:00		2025-05-03 20:50:50.067	2025-05-03 20:50:50.067	\N
e83df0b4-7ecc-4ec4-9170-b9ac1140ba1a	Job Abdon	Figeroa Gonzalez		\N	\N	2008-10-28 00:00:00		2025-05-03 20:50:50.067	2025-05-03 20:50:50.067	\N
490bce0e-1e48-45da-b94e-f89861c109f2	Job Abdon	Peña Gonzalez		jobpg@yahoo.com	\N	1958-01-11 00:00:00		2025-05-03 20:50:50.067	2025-05-03 20:50:50.067	\N
2c5bb819-8e16-4c73-b6cb-722e1fe5c86d	Jobscar	Ruiz Quintero		\N	\N	2006-12-30 00:00:00		2025-05-03 20:50:50.068	2025-05-03 20:50:50.068	\N
c3d45a7a-2434-489f-a11f-051b60c61b0b	Joceline	Gonzalez Sustaita		\N	\N	2007-09-11 00:00:00		2025-05-03 20:50:50.068	2025-05-03 20:50:50.068	\N
27eb1702-a344-4970-87f2-d9e99befbffb	Jayden	portillo		\N	3221306122	\N		2025-05-03 20:50:50.068	2025-05-03 20:50:50.068	\N
431d8c8b-8756-4596-a482-1487394fa523	Joe	Yarbrough		josephyarbrough911@gmail.com	\N	1978-06-22 00:00:00		2025-05-03 20:50:50.069	2025-05-03 20:50:50.069	\N
7138c86a-6fb9-4015-969a-8f3eb7f7f692	Joee	Teplitsky		nanajoee@yahoo.com	\N	\N		2025-05-03 20:50:50.069	2025-05-03 20:50:50.069	\N
19b8dc65-fa62-4185-9e07-434b849f64cf	Joel	Diaz Yerena		\N	\N	1980-04-28 00:00:00		2025-05-03 20:50:50.069	2025-05-03 20:50:50.069	\N
26d559f9-3439-4afa-ad0b-f5ec0e2f9514	Jodi	Allbon		\N	+61403980850	\N		2025-05-03 20:50:50.069	2025-05-03 20:50:50.069	\N
209aa32c-b514-4e4b-86d1-7c2e671c8bf4	Joel Enrique	joya Renteria		ofi-servicios@hotmail.com.	\N	1974-07-13 00:00:00		2025-05-03 20:50:50.07	2025-05-03 20:50:50.07	\N
47702eb8-2bb5-436b-8713-fe6358098876	Johana	Abagi García		johannaabagi@hoptmail.com	\N	1978-08-25 00:00:00		2025-05-03 20:50:50.07	2025-05-03 20:50:50.07	\N
37366955-445a-402a-814a-9c037293ab10	Johana	Briseño Dueñas		\N	\N	\N		2025-05-03 20:50:50.071	2025-05-03 20:50:50.071	\N
c923abe2-2adb-4223-ac29-ef27492d3331	Johana	De Jesus Saucedo		\N	\N	2008-10-08 00:00:00		2025-05-03 20:50:50.071	2025-05-03 20:50:50.071	\N
ee07b750-a418-4eb7-b175-189b369b247b	Johana Jocelin	Tobar Leyva		\N	\N	1999-12-26 00:00:00		2025-05-03 20:50:50.071	2025-05-03 20:50:50.071	\N
f6e10f3d-b08f-49ac-a948-d8d099d1c736	Johanna	Giles		\N	\N	1962-05-26 00:00:00		2025-05-03 20:50:50.072	2025-05-03 20:50:50.072	\N
d2aec883-957f-4129-ab91-560eec6cedac	John	Bobb		bobb@westriv.com	\N	1950-11-21 00:00:00		2025-05-03 20:50:50.072	2025-05-03 20:50:50.072	\N
81566380-d157-4582-ac61-6461d739b409	Jennifer	Rangel Bautista		rangel1999linda@gmail.com	3222139733	\N		2025-05-03 20:50:50.072	2025-05-03 20:50:50.072	\N
acdbf551-6de3-46ee-8727-22199ff92ba7	Jaime	Esqueda de Anda		\N	3329373436	\N		2025-05-03 20:50:50.073	2025-05-03 20:50:50.073	\N
de7b4476-031c-4311-adcb-8a30356758ae	Johnny	Muheizen		\N	\N	1966-09-09 00:00:00		2025-05-03 20:50:50.073	2025-05-03 20:50:50.073	\N
a8a7c599-c1bb-4c42-83f3-29d4459bf82f	Jonatha Saul	Rodriguez Glez		jonathan_trener235@gmail.com	\N	1991-06-18 00:00:00		2025-05-03 20:50:50.073	2025-05-03 20:50:50.073	\N
714e7be8-9fee-4ef8-914c-91350f5e1f09	Jesus	Montero		monterojesusceballos@gmail.com	+523221204471	\N		2025-05-03 20:50:50.073	2025-05-03 20:50:50.073	\N
40a757eb-e062-42d1-8cdf-6704d5e834ce	Jonathan	Jallet		\N	3222395544	1987-07-22 00:00:00		2025-05-03 20:50:50.074	2025-05-03 20:50:50.074	\N
b1003f25-a1e2-4b0c-95c2-710e9b284c18	Jonathan	Magaña Mancilla		\N	\N	1985-08-23 00:00:00		2025-05-03 20:50:50.074	2025-05-03 20:50:50.074	\N
f1176a4c-02e8-40dd-b0c5-210a9c94e296	Jonathan	Sanchez Glez.		\N	\N	2006-10-16 00:00:00		2025-05-03 20:50:50.075	2025-05-03 20:50:50.075	\N
50419222-034d-42e7-b22d-e55efd9d0831	Jesus	Marcial Rubio		jesusmarcialr@gmail.com	+523227283777	\N		2025-05-03 20:50:50.075	2025-05-03 20:50:50.075	\N
4a0bd420-a08f-4cab-9099-84f7c11b31d7	Jonathan Eduardo	Barajas Barran		\N	3122116864	\N		2025-05-03 20:50:50.075	2025-05-03 20:50:50.075	\N
b6df77b7-04f1-422f-b4a6-b40affe951b9	Jesus Adrian	Villa Velázco		\N	3221000532	\N		2025-05-03 20:50:50.076	2025-05-03 20:50:50.076	\N
b74480d6-d769-4281-9fcf-26f9e36e619b	Jonathan Jeancarlo	Mesa Guerrero		\N	\N	\N		2025-05-03 20:50:50.076	2025-05-03 20:50:50.076	\N
786770e0-c75c-411e-86ff-a050dd1eb90d	Jonna	Sponaugle		jetsponaugle30@hotmail.com	\N	1967-10-30 00:00:00		2025-05-03 20:50:50.076	2025-05-03 20:50:50.076	\N
ead5693d-80e6-4909-b462-684db8e85df2	Jonny	Davis		\N	\N	2008-05-20 00:00:00		2025-05-03 20:50:50.076	2025-05-03 20:50:50.076	\N
ea5a0b01-70da-41f5-b661-50b024a55403	Jordan	Muheisen		holisticjo1@gmail.com	\N	1991-05-06 00:00:00		2025-05-03 20:50:50.077	2025-05-03 20:50:50.077	\N
7c31853b-5510-46f7-99b9-7784e11b002a	Jordan Alexander	Martinez Quintero		\N	\N	2008-02-13 00:00:00		2025-05-03 20:50:50.077	2025-05-03 20:50:50.077	\N
76a30ff7-510c-40ba-9c84-f8da27016ea0	Jesus	Rosas Chavez		\N	3227798505	\N		2025-05-03 20:50:50.077	2025-05-03 20:50:50.077	\N
f42957ed-5b0e-422e-86f1-416853734930	Jore Sebastian	Assisten Card		\N	\N	2006-04-17 00:00:00		2025-05-03 20:50:50.078	2025-05-03 20:50:50.078	\N
dd3466d4-a88b-4972-b1b9-4b6677bfcef7	Jorge	Baustista Mosqueira		\N	\N	2006-09-22 00:00:00		2025-05-03 20:50:50.078	2025-05-03 20:50:50.078	\N
7e9f8aa1-2d39-4d0e-a8b9-5d44f978f4a0	Jorge	Gaxiola León		jorgegaxiolal@gmail.com	\N	1996-06-03 00:00:00		2025-05-03 20:50:50.078	2025-05-03 20:50:50.078	\N
31dfa385-9e58-464a-844f-8325099d9f78	Jorge	Gómez Pérez		\N	\N	2007-05-08 00:00:00		2025-05-03 20:50:50.079	2025-05-03 20:50:50.079	\N
c8137961-91f5-46ea-866b-6e128a3e2eb5	Jorge	Gonzales		\N	\N	\N		2025-05-03 20:50:50.079	2025-05-03 20:50:50.079	\N
bd66be89-137d-4293-bb6e-eb4a584a69ca	Jorge	Guerrero		noema233@hotmail.com	\N	\N		2025-05-03 20:50:50.079	2025-05-03 20:50:50.079	\N
32d59d90-a275-4be0-9902-9e03dd184cd9	Jorge	Guzman Sanchez		97jorgeguzman@gmail.com	\N	1997-04-22 00:00:00		2025-05-03 20:50:50.08	2025-05-03 20:50:50.08	\N
86043503-bb8d-458b-878e-b49801821eeb	Jorge	Muñoz		\N	\N	2006-03-17 00:00:00		2025-05-03 20:50:50.08	2025-05-03 20:50:50.08	\N
0c8713a5-a91e-42e3-a5ea-8b0e2d0358ec	Jorge	Oliva		jorgeoliva@grupomaspaq.com	\N	1976-04-10 00:00:00		2025-05-03 20:50:50.08	2025-05-03 20:50:50.08	\N
7ca11980-d989-491a-98fa-0c64a8e4ae3a	Jorge	Platas Dominguez		\N	\N	\N		2025-05-03 20:50:50.081	2025-05-03 20:50:50.081	\N
e5ec3f36-adc2-43fe-9b12-401065b11264	Jorge	Rodriguez  Rodriguez		\N	\N	\N		2025-05-03 20:50:50.081	2025-05-03 20:50:50.081	\N
ab86a47a-e6db-4da0-aa10-2b0333003666	Jorge	Rodriguez Davila		\N	\N	1946-09-27 00:00:00		2025-05-03 20:50:50.081	2025-05-03 20:50:50.081	\N
26b8a21a-ff5d-4676-8b1f-58b44a84c8e4	Jorge	Ruiz Pelayo		\N	\N	1955-02-20 00:00:00		2025-05-03 20:50:50.082	2025-05-03 20:50:50.082	\N
fc13c975-ddf9-40ce-9df8-3128f8343c03	Jorge	Santa Ana		\N	\N	1969-07-25 00:00:00		2025-05-03 20:50:50.082	2025-05-03 20:50:50.082	\N
e6dd9b3a-4016-479f-b26d-e5b7cfe539be	Jesus Elias	Matinez Molina		\N	5517656104	\N		2025-05-03 20:50:50.083	2025-05-03 20:50:50.083	\N
1a346542-1fc1-415c-a7f1-d8b1c75e8b58	Jorge	Tovar		\N	\N	\N		2025-05-03 20:50:50.083	2025-05-03 20:50:50.083	\N
fac950b2-9c38-4847-9643-7d22138ea03f	Jorge	Vaca		\N	\N	\N		2025-05-03 20:50:50.083	2025-05-03 20:50:50.083	\N
3e8743b2-887c-46cb-9c33-9b5ba823db30	Jorge	Valdez Godinez		\N	\N	2005-03-17 00:00:00		2025-05-03 20:50:50.084	2025-05-03 20:50:50.084	\N
4a934b2c-e8c1-420b-81c5-d1e742f8b72c	Jorge	Vargas		\N	\N	1978-01-17 00:00:00		2025-05-03 20:50:50.084	2025-05-03 20:50:50.084	\N
0c96779d-55ee-4567-84dd-91c791e61f39	Jorge	Vasquez Balleza		infopatadeperro@gmail.com	\N	1976-08-25 00:00:00		2025-05-03 20:50:50.084	2025-05-03 20:50:50.084	\N
1e5b057c-6f0f-4ed8-9242-9eddfbd8e4ca	Jorge	Villalvaso Talancon		villalvasotalanconjorge@gmail.com	\N	1984-01-04 00:00:00		2025-05-03 20:50:50.084	2025-05-03 20:50:50.084	\N
1ce5d37e-0efd-4613-ad34-534f6c99f5ad	Jorge Adan	Perez Salvatierra		\N	\N	2010-05-31 00:00:00		2025-05-03 20:50:50.085	2025-05-03 20:50:50.085	\N
646aecbe-e9c4-4a77-bd15-f1743b864819	Jorge Alberto	Gomez Valdez		\N	\N	1971-09-07 00:00:00		2025-05-03 20:50:50.085	2025-05-03 20:50:50.085	\N
d3080800-60cb-4ff7-a41d-dcf8b58bd3f7	Jorge Alberto	Gonzalez Garcia		\N	\N	\N		2025-05-03 20:50:50.085	2025-05-03 20:50:50.085	\N
8da4d114-ff41-4653-93a2-b6727cc0ae01	Jorge Alberto	Silis Franck		\N	\N	1962-06-17 00:00:00		2025-05-03 20:50:50.085	2025-05-03 20:50:50.085	\N
89f82afb-0bcb-419e-881d-7f6f0fada3a7	Jorge Alejandro	Mondragon		\N	\N	\N		2025-05-03 20:50:50.086	2025-05-03 20:50:50.086	\N
d5d38895-19d1-4a21-b469-85710b6dfb8a	Jorge Amauri	De la Torre		\N	\N	2011-01-10 00:00:00		2025-05-03 20:50:50.086	2025-05-03 20:50:50.086	\N
2532ac78-99f6-452b-a116-1722827868a4	Jorge Antonio	Mariscal Robles		\N	\N	2009-05-25 00:00:00		2025-05-03 20:50:50.086	2025-05-03 20:50:50.086	\N
dcd41bc9-5108-4ef9-a470-6a61a135f5fb	Jorge Arturo	Herrera Hernández		arturo@baydirect.com	3222259917	1976-06-03 00:00:00		2025-05-03 20:50:50.086	2025-05-03 20:50:50.086	\N
5f2688eb-6a0f-44a1-97aa-a2bdae155941	John	Hultgren		\N	3223209986	\N		2025-05-03 20:50:50.106	2025-05-03 20:50:50.106	\N
6814b3d8-4789-4e65-94d8-f250fced9e77	Jorge Aturo	Vasquez Mendoza		\N	\N	1961-12-18 00:00:00		2025-05-03 20:50:50.087	2025-05-03 20:50:50.087	\N
9910d96b-f447-4854-ad2e-032a7c1236af	Jorge Cecilio	Arriola Meza		\N	\N	\N		2025-05-03 20:50:50.087	2025-05-03 20:50:50.087	\N
36130ca9-23ee-4285-9637-2d6f00261be1	Jhanna	Gurenko		\N	+15307618098	\N		2025-05-03 20:50:50.088	2025-05-03 20:50:50.088	\N
a4935fa7-f343-4a7b-9293-a3c37d0cdde2	Jorge Eduardo	Salndoval Rodríguez		jsandovalr09@gmail.com	\N	1988-09-07 00:00:00		2025-05-03 20:50:50.088	2025-05-03 20:50:50.088	\N
b002f957-0ce1-4237-bd4a-d39e551743ea	Jorge Enrique	Garza García		\N	\N	1999-02-23 00:00:00		2025-05-03 20:50:50.088	2025-05-03 20:50:50.088	\N
999cc8df-ff17-44ee-9ea2-28a0218743bf	Jorge Humberto	Hernandez Garduño		\N	\N	2011-06-17 00:00:00		2025-05-03 20:50:50.089	2025-05-03 20:50:50.089	\N
134a2a50-1fd7-41d4-895a-2725e07b82d4	Jorge Iram	García Razo		\N	\N	2010-10-21 00:00:00		2025-05-03 20:50:50.089	2025-05-03 20:50:50.089	\N
8ed110ca-d791-480f-88ef-7cb8965447d9	Jesus Alberto	Contreras Contreras		\N	3222171945	\N		2025-05-03 20:50:50.09	2025-05-03 20:50:50.09	\N
85a3e1ce-489a-4b1e-9d81-7155086e8d89	Jorge	Suarez Alvarez		\N	3221961656	\N		2025-05-03 20:50:50.091	2025-05-03 20:50:50.091	\N
ec538425-9116-4af0-b81a-ecbb2b9d0733	Jorge Luis	Orózco Aguilera		\N	\N	1995-11-30 00:00:00		2025-05-03 20:50:50.091	2025-05-03 20:50:50.091	\N
1ac01079-0911-4e1b-9c84-fa99f7a1e3a1	Jorge Luis	Palomeque Gutierrez		\N	\N	\N		2025-05-03 20:50:50.091	2025-05-03 20:50:50.091	\N
5e0ad427-0685-43db-ba71-21b8a606ad15	Jorge Luis	Ramirez Camacho		\N	\N	\N		2025-05-03 20:50:50.092	2025-05-03 20:50:50.092	\N
4cd56854-25f1-4972-87e3-c68a4fb1c54b	Jorge Luis	Valenzuela López		\N	\N	\N		2025-05-03 20:50:50.092	2025-05-03 20:50:50.092	\N
dcbd416d-7081-4fbf-bb2e-289b9458f8fb	Jorge Octavio	Joya García		donvictoriano@hotmail.com	\N	1964-01-19 00:00:00		2025-05-03 20:50:50.092	2025-05-03 20:50:50.092	\N
1f160be0-6958-4b63-9b8b-a77ec6c73c9e	Jorge Tomas	Rodriguez Nuñez		\N	\N	1987-10-23 00:00:00		2025-05-03 20:50:50.093	2025-05-03 20:50:50.093	\N
51366c24-eeed-45ef-864b-40ac27a15225	Jorge Ulices	Ledón Solozano		j.ledón@hotmail.com	\N	1996-02-21 00:00:00		2025-05-03 20:50:50.093	2025-05-03 20:50:50.093	\N
cbb7c58d-91d3-4b2b-ba69-fa8c0b980580	Jorje	Suarez Alvarez		decoracionsuarez@hotmaul.com	\N	1980-02-04 00:00:00		2025-05-03 20:50:50.093	2025-05-03 20:50:50.093	\N
97ef9bcf-8a88-4705-bf02-02a8d7a53932	Jose	Alvarez Servin		jservinp40@gmail.com	\N	1985-02-27 00:00:00		2025-05-03 20:50:50.093	2025-05-03 20:50:50.093	\N
c29c84dd-28c4-41d9-a78d-43ab127c8119	Jose	Cruz Ruiz		\N	\N	2011-02-20 00:00:00		2025-05-03 20:50:50.094	2025-05-03 20:50:50.094	\N
0a1af3df-b1d9-4cb2-9eaa-9e951395c772	Jose	Gomez Flores		josegf@hotmail.com	\N	\N		2025-05-03 20:50:50.094	2025-05-03 20:50:50.094	\N
b82d9e9d-8d64-4412-be4a-ae2976671a9b	Jose	Gonzalez		\N	\N	\N		2025-05-03 20:50:50.094	2025-05-03 20:50:50.094	\N
d274e4d3-2d4f-4c82-b0b2-a4e28515ecc2	José	González Pozos		tacosgratislassonrisas@gmail.com	\N	1978-10-08 00:00:00		2025-05-03 20:50:50.095	2025-05-03 20:50:50.095	\N
ba959532-2db4-45ab-a675-aca5653fe4ab	Jóse	Leonides Solis		\N	\N	2009-06-01 00:00:00		2025-05-03 20:50:50.095	2025-05-03 20:50:50.095	\N
ec02270c-5792-41bd-8b81-d417f43afe5d	Jose	Leonides Solis		\N	\N	2009-06-02 00:00:00		2025-05-03 20:50:50.096	2025-05-03 20:50:50.096	\N
54cd82e2-14e3-4067-ae31-22b4e11910f3	Jose	Martinez Martinez		\N	\N	2006-06-19 00:00:00		2025-05-03 20:50:50.096	2025-05-03 20:50:50.096	\N
42595439-b480-4318-aea2-4c1e6f6b3aaa	Jose	Martinez O		\N	\N	\N		2025-05-03 20:50:50.096	2025-05-03 20:50:50.096	\N
87835a49-ecbb-426c-b67e-291f8f785a49	Jose	Martins		jmartins1958@sapo.pt	\N	1954-04-21 00:00:00		2025-05-03 20:50:50.097	2025-05-03 20:50:50.097	\N
ad38bcce-cd58-4cf9-944d-97e3ff61c8b0	Jose	Muñoz		\N	\N	1941-11-27 00:00:00		2025-05-03 20:50:50.097	2025-05-03 20:50:50.097	\N
b92c45e0-b775-4926-b6d6-88c5ecfb189a	Jose	Pantoja		\N	\N	\N		2025-05-03 20:50:50.097	2025-05-03 20:50:50.097	\N
f479e9a3-0566-457f-91e9-a0ab89f73200	Jessie Alejandra	Velázquez Ríos		jessie.velazquez.cieci@gmail.com	+523320544143	\N		2025-05-03 20:50:50.098	2025-05-03 20:50:50.098	\N
11c3b8ff-a0f9-4aec-a484-5ea7cc164829	Jose	Rodriguez García		jorodriguez636@gmail.com	\N	1990-06-26 00:00:00		2025-05-03 20:50:50.098	2025-05-03 20:50:50.098	\N
888487bc-261f-4f85-8c7e-c08ec3fa2e08	Jose	Sanchez Duarte		joselillo92@gmail.com	\N	1992-07-18 00:00:00		2025-05-03 20:50:50.098	2025-05-03 20:50:50.098	\N
d6128237-9f98-4ffb-9a67-bea38283b382	Jose	Santana Rodriguez		\N	\N	\N		2025-05-03 20:50:50.099	2025-05-03 20:50:50.099	\N
d164303e-1eaf-42dd-b455-fa58d6069557	Jose	Vallarta		josevalarta1976@gmail.com	\N	1976-04-16 00:00:00		2025-05-03 20:50:50.099	2025-05-03 20:50:50.099	\N
203b7691-da85-4114-874f-95b62123fada	JOSE	Vargas Mancilla		\N	\N	\N		2025-05-03 20:50:50.099	2025-05-03 20:50:50.099	\N
bc9181ab-8369-4c12-aacc-5f156c7b7405	Jose  Ramon	Jauregui		\N	\N	\N		2025-05-03 20:50:50.1	2025-05-03 20:50:50.1	\N
5239ef31-8871-4685-9436-c5d1d4c98906	Jose Abdias	Jimenez Cardenas		\N	\N	1995-11-18 00:00:00		2025-05-03 20:50:50.1	2025-05-03 20:50:50.1	\N
bf4fc835-6287-47a5-8ae2-55af161c9c97	Jose Abraham	Medrano Villanueva		\N	\N	1998-12-11 00:00:00		2025-05-03 20:50:50.1	2025-05-03 20:50:50.1	\N
468e2334-0081-4494-9f20-17d3cac28283	Jose Alberto	Alnzo Villa		josealonso1503@hotmail.com	\N	1989-05-15 00:00:00		2025-05-03 20:50:50.101	2025-05-03 20:50:50.101	\N
2e60d702-d345-4f85-b36d-f52c1ce3874f	Jose Alberto	Alonzo Villa		josealoso1503@hotmail.com	\N	1989-03-15 00:00:00		2025-05-03 20:50:50.101	2025-05-03 20:50:50.101	\N
7cc235c4-6fa8-4d74-be21-c79b25b47e2b	Joan	Girard		jojodd15@hotmail.com	3221383712	\N		2025-05-03 20:50:50.101	2025-05-03 20:50:50.101	\N
ca3cdb4a-2184-4798-854d-296cb65950e8	john	Landry		\N	+12145859503	\N		2025-05-03 20:50:50.101	2025-05-03 20:50:50.101	\N
a80f6cb4-4e62-4a5b-a769-bcf6c3e5c62c	Jose Alberto	Gómez Juncal		jose.a.gomez.j@gmail.com	\N	1991-05-23 00:00:00		2025-05-03 20:50:50.102	2025-05-03 20:50:50.102	\N
3fbcc2f5-b9d5-466f-85b6-eb8ab7d7362b	Jose Alfredo	ARias Rodríguez		\N	\N	1992-11-03 00:00:00		2025-05-03 20:50:50.102	2025-05-03 20:50:50.102	\N
3df1cd4c-a870-4af2-81ba-5aac055ec6e7	Jose Alfredo	JImenez Gonzalez		\N	3222690315	1974-01-08 00:00:00		2025-05-03 20:50:50.102	2025-05-03 20:50:50.102	\N
c1486353-4571-452c-a238-6307224c32c3	Jose Alfredo	Lua Manjarrez		fredolua@gmail.com	\N	1978-05-05 00:00:00		2025-05-03 20:50:50.103	2025-05-03 20:50:50.103	\N
f02b6721-6575-44df-96e0-b1db1f582725	Jose Amando	Sanchez Hernandéz		\N	\N	2008-11-05 00:00:00		2025-05-03 20:50:50.103	2025-05-03 20:50:50.103	\N
d9761f8b-3b87-46ab-a581-383fcbae8582	Jose Angel	Benites Aguilar		\N	\N	1985-03-18 00:00:00		2025-05-03 20:50:50.103	2025-05-03 20:50:50.103	\N
d8086ea7-fd1e-49f8-b04c-518e7b647e41	Jóse Antonio	Alvarez Salgado		\N	\N	2009-05-29 00:00:00		2025-05-03 20:50:50.104	2025-05-03 20:50:50.104	\N
ac671556-9f3a-477e-afd0-2fdc9d1ffb76	Jose Antonio	Camacho Ochoa		\N	\N	1958-07-08 00:00:00		2025-05-03 20:50:50.104	2025-05-03 20:50:50.104	\N
66d1a57a-244b-4dc4-a952-65747d6c5a78	Jose Antonio	Flores Gonzales		aflores@comexpintacolor.com	\N	1977-09-23 00:00:00		2025-05-03 20:50:50.104	2025-05-03 20:50:50.104	\N
2da3263f-058b-41f6-a262-a2fdf4820333	Jose Antonio	Molina Nolasco		\N	\N	1982-01-17 00:00:00		2025-05-03 20:50:50.105	2025-05-03 20:50:50.105	\N
26aa2ab5-4534-4f96-ad93-bf1237b919eb	Jose Antonio	Resendiz Rosales		\N	\N	2010-01-22 00:00:00		2025-05-03 20:50:50.105	2025-05-03 20:50:50.105	\N
19fc3eb5-1261-421b-aa07-6c7595f5c4ba	Jose Antonio	Resendiz Rosalez		\N	\N	2010-01-22 00:00:00		2025-05-03 20:50:50.105	2025-05-03 20:50:50.105	\N
aa5c38ce-62b8-4b47-b6fc-7f0596281a9c	José Apolo	Tovar Hernández		polotovar@cafedesartistes.com	\N	1964-05-28 00:00:00		2025-05-03 20:50:50.106	2025-05-03 20:50:50.106	\N
ffb21601-fb83-44c5-aebd-b7cbb24144cf	Jhonn	Landry		\N	+12145859503	\N		2025-05-03 20:50:50.106	2025-05-03 20:50:50.106	\N
adb11adf-3fab-43a9-b174-e18e644b382c	Jose Carlos	Contreras Gallardo		jcarlos_1114@hotmail.com	\N	1964-02-14 00:00:00		2025-05-03 20:50:50.106	2025-05-03 20:50:50.106	\N
82f005ad-a8b4-49b4-aea3-0e115793f0b1	Jose Benito	Hernandez Ovando		\N	9851089372	\N		2025-05-03 20:50:50.107	2025-05-03 20:50:50.107	\N
734b47f3-08b7-4bb7-b1be-b44144db615d	Jose Carlos	Marquillo Salgado.		marquillo220987@gmail.com	\N	1987-09-22 00:00:00		2025-05-03 20:50:50.107	2025-05-03 20:50:50.107	\N
095272ca-69d2-4b8b-ae64-222c94ccfb0b	Jose Carlos	Palacios Coronado		\N	\N	2011-08-01 00:00:00		2025-05-03 20:50:50.107	2025-05-03 20:50:50.107	\N
790963ef-a4af-4e4d-9432-95d8192da638	Jesus	López Cardoso		\N	3223214105	\N		2025-05-03 20:50:50.108	2025-05-03 20:50:50.108	\N
7e9a459e-4a7d-4d37-b1fc-604ba01424d3	Jose de Jesus	Avalos Parra		\N	\N	1967-12-26 00:00:00		2025-05-03 20:50:50.108	2025-05-03 20:50:50.108	\N
e8f2b219-d52a-4b5c-b666-d3e8c3eda3ca	Jose de Jesus	Beas Sálas		\N	\N	1964-06-30 00:00:00		2025-05-03 20:50:50.108	2025-05-03 20:50:50.108	\N
ed6303c5-822b-4409-96a3-13ba01fbbaa1	Jose de Jesus	Franco Gutierrez		francogtz2@gmail.com	\N	1961-06-09 00:00:00		2025-05-03 20:50:50.109	2025-05-03 20:50:50.109	\N
0e16866b-4bab-4136-ab30-fc3d8fa3d01e	Jose de Jesus	Preciado Perez		\N	\N	\N		2025-05-03 20:50:50.109	2025-05-03 20:50:50.109	\N
9f9c4ecf-577d-499b-9385-1e338dde72b0	José de Jesús	Robles Arreola		joserobles82@hotmail.com	\N	\N		2025-05-03 20:50:50.11	2025-05-03 20:50:50.11	\N
11a97fcb-3207-423e-9bb2-f56e00dcb405	Jose de Jesus	Santana Peña		\N	\N	1936-11-18 00:00:00		2025-05-03 20:50:50.11	2025-05-03 20:50:50.11	\N
ed201f28-c4a7-4b4e-85e9-627947453b2d	Jose Eduardo	Arreola Placencia		joseeduardoap1998@gmail.com.	\N	1998-02-22 00:00:00		2025-05-03 20:50:50.11	2025-05-03 20:50:50.11	\N
e5b0107f-535b-40ff-b3f0-bbb4e004e668	José Eduardo	Bobadilla Sánchez		\N	\N	1997-01-14 00:00:00		2025-05-03 20:50:50.111	2025-05-03 20:50:50.111	\N
cdae144a-aa82-434e-af4e-97b505a61742	Jose Eduardo	Bustos Sanchez		\N	\N	1997-07-25 00:00:00		2025-05-03 20:50:50.111	2025-05-03 20:50:50.111	\N
871c02b7-1f20-4caf-bbdc-98d55279ec7b	Jonathan	Amezcua Carabantes		\N	3221481924	1981-03-13 00:00:00		2025-05-03 20:50:50.111	2025-05-03 20:50:50.111	\N
d7dab7f6-fbe6-4130-89e2-1c62aa022941	Jonathan Alberto	Antonio Gomez		\N	5619043263	\N		2025-05-03 20:50:50.112	2025-05-03 20:50:50.112	\N
dae20e66-7ead-4601-a144-e574a7253d60	Jose Emmanuel	Santana Casillas		\N	\N	\N		2025-05-03 20:50:50.112	2025-05-03 20:50:50.112	\N
c32c90b0-f0ff-4bbf-a21c-a601519f6c4c	Jose Facundo	Muñoz Vázquez		\N	\N	1941-11-27 00:00:00		2025-05-03 20:50:50.112	2025-05-03 20:50:50.112	\N
9780acd0-5c11-4227-a26a-cd6c7b0ba248	Jose Federico	Mendiola Nonatos		\N	\N	\N		2025-05-03 20:50:50.113	2025-05-03 20:50:50.113	\N
f3241e84-8766-4e6e-bc0f-61a1d44ed825	Jóse Francisco	Rodriguez Mata		\N	\N	2006-05-02 00:00:00		2025-05-03 20:50:50.113	2025-05-03 20:50:50.113	\N
4cba57b2-5fd1-484f-ac0b-f8f749cb066d	Jose Genaro	Muñoz Castalleda		\N	\N	\N		2025-05-03 20:50:50.113	2025-05-03 20:50:50.113	\N
8450f9e6-d366-4624-a337-2f9296b25e71	Jose Gpe.	Estrada Estiler		\N	\N	\N		2025-05-03 20:50:50.113	2025-05-03 20:50:50.113	\N
1507ef35-2393-42f7-8f5d-104006d5719b	Jose Guadalupe	Gutierrez Placencia		\N	\N	1988-02-14 00:00:00		2025-05-03 20:50:50.114	2025-05-03 20:50:50.114	\N
b3abe7a2-d192-4ac0-a427-e4f416e966d8	Jose Guadalupe	Salaiza Ruiz		josesalaiza@hotmail.com	\N	1991-03-25 00:00:00		2025-05-03 20:50:50.114	2025-05-03 20:50:50.114	\N
cffecc64-a314-43df-a60c-e6883d25d2c6	Jose Guadalupe	Vidrio Ulloa		josevidrioulloa@gmail.com	\N	1986-08-24 00:00:00		2025-05-03 20:50:50.114	2025-05-03 20:50:50.114	\N
db5c1c43-913c-4faf-a07d-1c61a3071b21	Jose Gustavo	Gonzalez Camargo		\N	\N	1962-12-11 00:00:00		2025-05-03 20:50:50.115	2025-05-03 20:50:50.115	\N
7bf9b9d9-7f61-428f-aa61-5d55bfcef224	Jose Hector	Monroy Sanchez		\N	\N	2010-05-27 00:00:00		2025-05-03 20:50:50.115	2025-05-03 20:50:50.115	\N
9b36f9ac-c925-4673-a98d-cbbfa1818852	Jose Hector	Monrroy Flores		\N	\N	2010-05-29 00:00:00		2025-05-03 20:50:50.115	2025-05-03 20:50:50.115	\N
ae30debb-4a6c-4813-9224-c413d5443420	Jose Hector	Tejeda de la Crúz		\N	\N	2010-12-19 00:00:00		2025-05-03 20:50:50.116	2025-05-03 20:50:50.116	\N
234f1d4f-7142-4738-a0f3-16f9322667c5	Jose Ignacio	Silva Solorio		jsilvasol0588@yahoo.com	\N	1988-01-05 00:00:00		2025-05-03 20:50:50.116	2025-05-03 20:50:50.116	\N
ae39c224-73c5-46cb-b264-ed68d1c4de4b	Jose Jaime	Bernal Valdez		j_jose_javier@hotmail.com	\N	1967-12-09 00:00:00		2025-05-03 20:50:50.116	2025-05-03 20:50:50.116	\N
637ae3e7-5910-4590-ad73-da38f7dae40e	Jose Javier	Gonzales Aragón		gonzalesaragon@live.com	\N	1969-09-04 00:00:00		2025-05-03 20:50:50.117	2025-05-03 20:50:50.117	\N
b96654f2-3115-460e-b1d4-bf1952fb90a1	Jose Jorge Alfonso	Hernandez Diaz		\N	3221271257	1950-07-27 00:00:00		2025-05-03 20:50:50.117	2025-05-03 20:50:50.117	\N
571354e6-ebe8-4d7b-b227-97852ecb8711	Jose Juan	Ortega Perez		\N	\N	1946-08-18 00:00:00		2025-05-03 20:50:50.117	2025-05-03 20:50:50.117	\N
3e223757-5a47-4c6b-91c6-0463d7ee3d30	Jose Leonardo	Espejel Paz		\N	0445521374122	2003-11-07 00:00:00		2025-05-03 20:50:50.118	2025-05-03 20:50:50.118	\N
ab686948-8252-4db0-9bda-cbb2736bf7cb	Jose Leopoldo	Palomera Rodriguez		\N	\N	2010-05-03 00:00:00		2025-05-03 20:50:50.118	2025-05-03 20:50:50.118	\N
6ab8a3f0-b27e-48c9-b48d-ebce5e57d6c3	Jose Luis	beas Salas		\N	\N	1962-07-04 00:00:00		2025-05-03 20:50:50.118	2025-05-03 20:50:50.118	\N
3544d3de-411f-422d-87e1-f29f1d07c7fe	Jose Luis	Colin Castillo		\N	\N	1961-08-11 00:00:00		2025-05-03 20:50:50.119	2025-05-03 20:50:50.119	\N
fce89696-bf3a-46d1-9fe0-d12435ae0d64	Jose Carlos	Hernández Godínez		\N	3221601025	\N		2025-05-03 20:50:50.119	2025-05-03 20:50:50.119	\N
74bb00c3-1c10-4663-9f90-7cb17d402e7b	Jose Luis	Dias Guzmán		\N	\N	1949-05-10 00:00:00		2025-05-03 20:50:50.119	2025-05-03 20:50:50.119	\N
a1cd8d5f-7c3c-4f8b-b280-53614b7996fb	Jose Luis	Lopes Orozco		\N	\N	2011-03-10 00:00:00		2025-05-03 20:50:50.119	2025-05-03 20:50:50.119	\N
bec6e71b-727e-459c-a961-00f5725c2bc3	Jordi	Badia Rodriguez		\N	3221189831	\N		2025-05-03 20:50:50.12	2025-05-03 20:50:50.12	\N
d722dd48-7325-48bb-822e-302464d5a246	Jose Luis	Orozco Aguilera		maestrojlorozcoa@hotmail.mail.com	\N	1966-12-19 00:00:00		2025-05-03 20:50:50.12	2025-05-03 20:50:50.12	\N
f6e895b3-70fd-4df5-b92d-c19bef009440	Jose Luis	Puga Moran		pugamoranjose@gmail.com	\N	1980-12-26 00:00:00		2025-05-03 20:50:50.121	2025-05-03 20:50:50.121	\N
2413b5b1-8d05-4af2-876e-e80ac08c2578	Jorge Daniel	Ledon  Ruíz		\N	3334475672	\N		2025-05-03 20:50:50.121	2025-05-03 20:50:50.121	\N
ac366b93-c98d-4a06-9b32-912b84e7e982	Jose Luis	Solorzano Zavala		solozano63@yahoo.com	\N	1962-08-25 00:00:00		2025-05-03 20:50:50.121	2025-05-03 20:50:50.121	\N
bc81e791-d8ea-4640-b504-1a344fe34a3f	José Luis	Tostado Becerra		joseluis290395@gmai.com	\N	1995-03-29 00:00:00		2025-05-03 20:50:50.122	2025-05-03 20:50:50.122	\N
35c1ab58-208e-43cf-bb07-150e20ee2423	Jose Luis	Trejo Lopez		\N	\N	2011-03-18 00:00:00		2025-05-03 20:50:50.122	2025-05-03 20:50:50.122	\N
d6b52f94-8a07-47c4-88a2-873bd2a5f77b	Jóse Luis	Valdes Cardenas		climasvaldes@prodigy.net.mx	\N	1962-01-20 00:00:00		2025-05-03 20:50:50.122	2025-05-03 20:50:50.122	\N
a1eaedec-3005-493b-ab06-6243b98a4383	Jonathan Giancarlo	Meza Guerrero		\N	3222407593	\N		2025-05-03 20:50:50.123	2025-05-03 20:50:50.123	\N
5c3c43f1-e6bd-4fe9-ae53-bb117b4b5856	Jose Luis	Vega Ramirez		\N	\N	\N		2025-05-03 20:50:50.123	2025-05-03 20:50:50.123	\N
77ab9ae4-df63-4233-aea6-40f80029f740	Jose Manuel	Cruz  Arechiga		\N	\N	1969-09-07 00:00:00		2025-05-03 20:50:50.123	2025-05-03 20:50:50.123	\N
95964ed6-779e-4fd9-8d57-e8cdbe81c0d6	Jose Manuel	Crúz Arechiga		claudia_morales_71@hotmil.com	\N	1969-11-07 00:00:00		2025-05-03 20:50:50.124	2025-05-03 20:50:50.124	\N
1cf8eccb-7fd7-4e27-a52f-f6353150d20f	Jose Manuel	Ramirez Osuna		\N	\N	1958-01-25 00:00:00		2025-05-03 20:50:50.124	2025-05-03 20:50:50.124	\N
08af939a-e0c1-4d55-b34c-c576b985ae1f	Jose Manuel	Santos Rodriguez		\N	\N	1960-08-20 00:00:00		2025-05-03 20:50:50.124	2025-05-03 20:50:50.124	\N
e371a020-14ca-490a-8d4a-9eac856b0105	Jose Mario	Ramirez ipirales		\N	\N	1980-05-01 00:00:00		2025-05-03 20:50:50.124	2025-05-03 20:50:50.124	\N
a1485e20-9138-4fe3-af59-94201a0a53f9	Jose Martin	Franquez Santana		martin.gris@hotmail.com	\N	1966-01-23 00:00:00		2025-05-03 20:50:50.125	2025-05-03 20:50:50.125	\N
720cbb01-9c24-4225-b371-94f30eaf2793	Jose Miguel	Crúz Válle		\N	\N	1997-11-05 00:00:00		2025-05-03 20:50:50.125	2025-05-03 20:50:50.125	\N
81e8471a-0055-45bd-b7a8-7a723b9408fd	Jose Miguel	Guzmán Tejeda		\N	\N	2002-10-17 00:00:00		2025-05-03 20:50:50.125	2025-05-03 20:50:50.125	\N
f8639625-325d-45ff-a177-4dab17cc1bf2	Jose Miguel	Ortega Ramos		j_miguel600@hotmail.com	\N	1990-09-28 00:00:00		2025-05-03 20:50:50.126	2025-05-03 20:50:50.126	\N
7fb0da77-0e0d-4fcf-b98a-f451e3675303	Jose Miguel	Paloque magaña		\N	\N	2002-10-16 00:00:00		2025-05-03 20:50:50.126	2025-05-03 20:50:50.126	\N
45c6941d-56e3-49a6-9c13-6d300e9a7d00	Jose Nemesio	Cheire Gutierrez		\N	\N	1959-08-29 00:00:00		2025-05-03 20:50:50.126	2025-05-03 20:50:50.126	\N
88b36bc0-31c6-486a-821b-f2b896e6a015	Jose Omar	Alonzo Villa		alonzo_villa@hotmail.com	\N	1983-01-05 00:00:00		2025-05-03 20:50:50.127	2025-05-03 20:50:50.127	\N
24bce087-e96e-4488-9951-3f172116cb86	Jose Luis	Sanciprian		\N	5516775017	\N		2025-05-03 20:50:50.127	2025-05-03 20:50:50.127	\N
96f607e3-cbf2-4509-aa52-5ae022275e87	Jose Rafael	Montero Hernadez		\N	\N	\N		2025-05-03 20:50:50.127	2025-05-03 20:50:50.127	\N
5a54e2ca-fd53-4551-af89-43370ac70477	Jose Rafael	Peña LLamas		\N	\N	\N		2025-05-03 20:50:50.128	2025-05-03 20:50:50.128	\N
1093deb3-6595-4731-a346-fdf53f55e882	Jorge Ivan	Vargas Martinez		\N	3221394086	\N		2025-05-03 20:50:50.128	2025-05-03 20:50:50.128	\N
bf8653db-0b8b-477c-b449-6d49c66cbcf8	Jose Ramon	Cuevas Barba		\N	\N	\N		2025-05-03 20:50:50.128	2025-05-03 20:50:50.128	\N
c654267f-2d20-41cd-a943-783dc78a31fe	Jose Ramón	Jauregi Muñoz		\N	\N	1997-02-14 00:00:00		2025-05-03 20:50:50.129	2025-05-03 20:50:50.129	\N
5ef77a94-d042-49d7-8229-353f5754e65b	Jose Ramón	Segura  Colmenares		jr.segura@live.com.mx	\N	1988-03-14 00:00:00		2025-05-03 20:50:50.129	2025-05-03 20:50:50.129	\N
c03a0c9f-fa43-4cb6-bd5a-9f9d97e11396	Jose Ricardo	Gonzalez Nuñez		\N	\N	2011-05-14 00:00:00		2025-05-03 20:50:50.129	2025-05-03 20:50:50.129	\N
7047eae6-901e-41f7-bde7-84813068ef25	Jose Ricardo	Morales Becerrill		\N	\N	1963-01-09 00:00:00		2025-05-03 20:50:50.13	2025-05-03 20:50:50.13	\N
1a6db917-6fc8-4cb1-b6b9-8c6cca9d94e3	Jose Saúl	Caro Moya		\N	\N	\N		2025-05-03 20:50:50.13	2025-05-03 20:50:50.13	\N
f65da839-efab-4de8-a6c0-ad45037ebeeb	José Trinidad	Castellon Anaya		\N	\N	1959-05-24 00:00:00		2025-05-03 20:50:50.13	2025-05-03 20:50:50.13	\N
7834143d-9867-45e0-9609-7ec9522a142e	Josefina	Betancourt Jimenez		\N	\N	2011-03-07 00:00:00		2025-05-03 20:50:50.131	2025-05-03 20:50:50.131	\N
29f22890-7cb6-4285-8d7a-a5d2080356a2	Josefina	Lara		\N	\N	\N		2025-05-03 20:50:50.131	2025-05-03 20:50:50.131	\N
d5ba9f6f-3a27-4a03-a3ff-8daf3cba4dd1	Josefina	Sanchez Uribe		\N	\N	2010-03-25 00:00:00		2025-05-03 20:50:50.131	2025-05-03 20:50:50.131	\N
b9ea227d-e4f9-45f9-bae2-1a3d133e565a	Joselin	Guzmán Marquet		\N	\N	1967-07-28 00:00:00		2025-05-03 20:50:50.132	2025-05-03 20:50:50.132	\N
410595b2-d565-4872-8425-a11b80b2556b	Joselyn Denisse	Alvarado Maríinez		jdam20001@hotmail.com	\N	2000-08-01 00:00:00		2025-05-03 20:50:50.133	2025-05-03 20:50:50.133	\N
c285f0f0-1cd6-45df-932c-92bd4c25f149	Jose Alberto	DelAngel Feliciano		\N	8334299742	\N		2025-05-03 20:50:50.133	2025-05-03 20:50:50.133	\N
26eef676-688c-4228-83c8-02807bf41c23	Joel Alejandro	Garcia España		\N	3221518606	\N		2025-05-03 20:50:50.133	2025-05-03 20:50:50.133	\N
2a267cc2-b243-4c91-8f1e-d846a2099286	Joseph	Stephan Christopher		\N	\N	1977-04-01 00:00:00		2025-05-03 20:50:50.134	2025-05-03 20:50:50.134	\N
e0179575-0595-44a9-afaa-4c030d8c2b28	Jose Eduardo	Bustos Sanchez		\N	3221648895	\N		2025-05-03 20:50:50.134	2025-05-03 20:50:50.134	\N
82371132-c6e0-4bf7-8cc4-8313bb2fb6d5	Joshua Ribelino	Regla Jimenez		\N	\N	2006-07-21 00:00:00		2025-05-03 20:50:50.134	2025-05-03 20:50:50.134	\N
eab7da93-1f04-48ed-ae57-4e3eba09bdea	Joshua Timoty	Vargaz Muñoz.		pegasso6902@gmail.com	\N	2008-03-30 00:00:00		2025-05-03 20:50:50.135	2025-05-03 20:50:50.135	\N
e29b9f08-00bf-4743-b05d-386e80389a90	Josue	Reed  Maldonado		\N	\N	1998-07-15 00:00:00		2025-05-03 20:50:50.135	2025-05-03 20:50:50.135	\N
f6c3bba5-3ba0-4eda-9fbd-ba94aa7e50ad	Josue	Vargas Orozco		\N	\N	1994-01-09 00:00:00		2025-05-03 20:50:50.135	2025-05-03 20:50:50.135	\N
1b90a2c6-2a21-43f6-9252-31b4b9dd1bb0	Jovita	Gurrola Hernandez		\N	\N	\N		2025-05-03 20:50:50.136	2025-05-03 20:50:50.136	\N
74d5c5bb-d950-4d18-b9ea-860c0d15229d	Juan	Aguilar		jatleo38@hotmail.com	\N	\N		2025-05-03 20:50:50.136	2025-05-03 20:50:50.136	\N
c165cbb1-d619-4eef-b0a5-fce0bcbdc3b9	Juan	Agundes Flores		\N	\N	1989-04-18 00:00:00		2025-05-03 20:50:50.136	2025-05-03 20:50:50.136	\N
7661f87d-d67e-46e3-ad84-5622a7251a63	Juan	Alcantara Cardenas		\N	\N	2011-02-01 00:00:00		2025-05-03 20:50:50.136	2025-05-03 20:50:50.136	\N
229b1e5e-f461-4a05-a07a-75ff583ea16d	Juan	Ayon Rosas		juanayon@hotmail.com	\N	1978-10-20 00:00:00		2025-05-03 20:50:50.137	2025-05-03 20:50:50.137	\N
a7160e9a-2886-409d-bacb-ad07ba8dddd0	Juan	Carrasco Sapien		juansapien31@gmail.com	\N	1979-09-29 00:00:00		2025-05-03 20:50:50.137	2025-05-03 20:50:50.137	\N
2c414b61-fcac-4355-838a-de5b2bab00e2	Juan	Estrada Hernández		\N	\N	1960-07-28 00:00:00		2025-05-03 20:50:50.138	2025-05-03 20:50:50.138	\N
a3f66a8a-39f8-4242-945c-c2447ef0249d	Juan	García Perez		\N	\N	1974-05-22 00:00:00		2025-05-03 20:50:50.138	2025-05-03 20:50:50.138	\N
c110cd0f-c44e-41be-beba-9f5e6a1ff2a1	Juan	Gutierrez Sanchez		\N	\N	\N		2025-05-03 20:50:50.138	2025-05-03 20:50:50.138	\N
a586d3fe-7820-48c6-88da-e49aa7ad538c	Juan	Mendoza Vazquez.		\N	\N	2007-03-27 00:00:00		2025-05-03 20:50:50.138	2025-05-03 20:50:50.138	\N
7e134223-27fe-4c55-acd0-fb16a1f4d3db	Juan	Mesa Franco		\N	3292950588	1968-09-08 00:00:00		2025-05-03 20:50:50.139	2025-05-03 20:50:50.139	\N
e1b2c3dd-6e57-4cc8-967c-c055cb3dd685	Juan	Morales Gomez		mgjr@correo.azc.uam.mx	\N	2006-09-23 00:00:00		2025-05-03 20:50:50.139	2025-05-03 20:50:50.139	\N
c5219dc9-7dc5-4f40-93e9-676492f775c6	Juan	Moreno Escobedo		\N	\N	1980-07-05 00:00:00		2025-05-03 20:50:50.139	2025-05-03 20:50:50.139	\N
83a7e569-dbc5-4926-a911-c66457c30fcd	Juan	Nuñez Navarro		\N	\N	2007-05-28 00:00:00		2025-05-03 20:50:50.14	2025-05-03 20:50:50.14	\N
52ee01a3-5d7a-4cd4-9869-0a1b293176c4	Juan	Ramirez Casares		\N	\N	2011-03-24 00:00:00		2025-05-03 20:50:50.14	2025-05-03 20:50:50.14	\N
1ac948c1-1eb9-4bfc-b4ca-be4b54d1ce84	Juan	Rodriguez Garcia		\N	\N	\N		2025-05-03 20:50:50.14	2025-05-03 20:50:50.14	\N
b087b3e7-4ad5-4b98-a03b-5973600bf339	Jose Carlos	Maldonado Peña		\N	3223060941	1971-02-17 00:00:00		2025-05-03 20:50:50.141	2025-05-03 20:50:50.141	\N
16e1b687-ef67-4324-a7a1-95ea4d542777	Juan	Sanchez Gatíca		3221892577jg@gmail.com	\N	1979-06-10 00:00:00		2025-05-03 20:50:50.141	2025-05-03 20:50:50.141	\N
f737c296-b533-40b7-b65a-611a3796a5fa	Juan	Vargas Vazquez		juan.vargas@stregis.com	\N	\N		2025-05-03 20:50:50.141	2025-05-03 20:50:50.141	\N
a6a2b643-ac95-4b68-9df1-917e9e3a154e	Juan	Villegas Gaona		\N	\N	\N		2025-05-03 20:50:50.142	2025-05-03 20:50:50.142	\N
fd7274e2-098b-4449-9609-8ec6fff33bbb	Juan  Carlos	Delfin Chagal		\N	\N	1981-09-24 00:00:00		2025-05-03 20:50:50.142	2025-05-03 20:50:50.142	\N
df3be2c4-a043-4118-aa90-b51523717451	Juan Alberto	Espinosa Zuñiga		\N	\N	2009-05-02 00:00:00		2025-05-03 20:50:50.142	2025-05-03 20:50:50.142	\N
fcbc8b41-637d-42df-850b-c80aef90604f	Juan Alfredo	Velazco Delgado		\N	\N	1993-04-05 00:00:00		2025-05-03 20:50:50.143	2025-05-03 20:50:50.143	\N
81d8e465-cc1e-4d57-8398-096420840c86	Juan Antonio	Barajas Medina		\N	3221132007	1992-10-16 00:00:00		2025-05-03 20:50:50.143	2025-05-03 20:50:50.143	\N
cd598043-df67-4995-8d69-e183e55dc4cd	Juan Antonio	Guzman Portillo		antonioguzmx@yahoo.com	\N	1968-12-27 00:00:00		2025-05-03 20:50:50.143	2025-05-03 20:50:50.143	\N
83f77e0c-e91a-4b3e-925e-04907b339759	Juan Antonio	Medel Parra		\N	\N	\N		2025-05-03 20:50:50.143	2025-05-03 20:50:50.143	\N
be81a8b5-ef51-4e9a-be49-59251afab309	Juan Antonio	Rubio Duarte		\N	\N	2008-09-08 00:00:00		2025-05-03 20:50:50.144	2025-05-03 20:50:50.144	\N
11e4f3d9-c3eb-4775-a172-671e4cf46e85	Juan Arturo	Martinez Chavarria.		\N	\N	2010-02-08 00:00:00		2025-05-03 20:50:50.144	2025-05-03 20:50:50.144	\N
a2d3d9c7-db7a-4107-84cc-0f0fd71875ab	Juan Aurelio	Flores del Toro		arc.juanaurelioflores@outloock.com	\N	1992-11-17 00:00:00		2025-05-03 20:50:50.144	2025-05-03 20:50:50.144	\N
a683aecf-2afb-46fb-b432-7ac3b5e7daf9	Juan Carlos	Albar Bibiano		\N	\N	2009-12-08 00:00:00		2025-05-03 20:50:50.145	2025-05-03 20:50:50.145	\N
5d84cbfe-bf09-406e-b6eb-33351ac7ede7	Juan Carlos	Arce Bernal		\N	\N	2006-04-13 00:00:00		2025-05-03 20:50:50.145	2025-05-03 20:50:50.145	\N
02ce4748-0090-4d7b-91dc-67ee5ec74866	Juan Carlos	Delfin		\N	\N	\N		2025-05-03 20:50:50.145	2025-05-03 20:50:50.145	\N
3f903010-3ceb-48ea-9ee5-505a43dbd74b	Juan Carlos	Garcia  dela Cruz		\N	\N	\N		2025-05-03 20:50:50.146	2025-05-03 20:50:50.146	\N
2e40d094-8b64-4930-a23d-e83f05972519	Jose Carlos	Varga Garcia		\N	3324947786	\N		2025-05-03 20:50:50.146	2025-05-03 20:50:50.146	\N
d50c58b7-fa95-4892-99aa-f25c2ad683ee	Juan Carlos	Hernández Granillo		hdzjuancarlos@hotmail.es	\N	1961-10-30 00:00:00		2025-05-03 20:50:50.146	2025-05-03 20:50:50.146	\N
018ba35c-c75d-47df-8c98-a5aeaa0e5a9c	Juan Carlos	Magdaleno Morales		\N	\N	2007-12-12 00:00:00		2025-05-03 20:50:50.147	2025-05-03 20:50:50.147	\N
77887b24-8c7d-4193-bfb5-29d4cb746545	Juan Carlos	Montaño Galvan		\N	\N	1983-01-12 00:00:00		2025-05-03 20:50:50.147	2025-05-03 20:50:50.147	\N
78a133b8-ea03-47ec-b475-f3adc7c320c7	Jose Luis	Cuevas Morales		\N	3313461208	\N		2025-05-03 20:50:50.148	2025-05-03 20:50:50.148	\N
5b626ae7-6427-46b1-9c5a-ccc82cf987fd	Juan Carlos	Ruíz Bravo		blackdx@live.com.mx	\N	1991-08-17 00:00:00		2025-05-03 20:50:50.148	2025-05-03 20:50:50.148	\N
2d40b0ea-e06c-4612-be4d-188208c9fd54	Juan Carlos	Sanchez Martìnez		\N	\N	1970-05-11 00:00:00		2025-05-03 20:50:50.148	2025-05-03 20:50:50.148	\N
f3c8c4f5-825f-4ba1-b53a-2c94a280034a	Juan de Dios	Briseño Morales		juandediosbri@hotmail.com	\N	1947-02-09 00:00:00		2025-05-03 20:50:50.149	2025-05-03 20:50:50.149	\N
25a9844a-dd44-4146-bded-f8fe14a85441	Juan de Jesus	De Jésus JImenez		\N	\N	1969-06-26 00:00:00		2025-05-03 20:50:50.149	2025-05-03 20:50:50.149	\N
fa31772e-5bd5-46f4-ab62-30a8e171b05b	Juan Diego	Virgen Castañeda		diegopayeta@hotmail.com	\N	1996-09-29 00:00:00		2025-05-03 20:50:50.149	2025-05-03 20:50:50.149	\N
6c32ac90-170a-45cc-ae8a-2bfbcf956af6	Juan Enrique	García Moreno		enrique370@yahoo.com	\N	1970-09-15 00:00:00		2025-05-03 20:50:50.15	2025-05-03 20:50:50.15	\N
24d2e157-0ec8-4826-9680-d6aac86d292f	Juan Ignácio	Gonzalez Davila		cpd99usmc94@gmail.com	\N	1975-11-10 00:00:00		2025-05-03 20:50:50.15	2025-05-03 20:50:50.15	\N
e03da366-45fa-4bd0-9062-33ba9c18d2d4	Juan Isaac	Santana Mejia		\N	\N	1997-07-24 00:00:00		2025-05-03 20:50:50.15	2025-05-03 20:50:50.15	\N
134340df-d73b-41aa-8156-430376a213aa	Jose Pablo	Marchena Arce		jpmarch4@gmail.com	+523224296314	\N		2025-05-03 20:50:50.151	2025-05-03 20:50:50.151	\N
ffd54832-a0b3-45eb-a571-d68ccbe43be3	Victor rene	Duran Tapia		\N	\N	1961-12-11 00:00:00		2025-05-03 20:50:50.151	2025-05-03 20:50:50.151	\N
55f86a49-a9fb-4da8-a4d8-a0ea0e11a007	Ligia Alejandra	Ceron Arzaluz		\N	\N	\N		2025-05-03 20:50:50.151	2025-05-03 20:50:50.151	\N
0c147376-42c7-43c5-828d-28c26bf42669	Lucia	Partida Zepeda		\N	\N	2009-02-09 00:00:00		2025-05-03 20:50:50.151	2025-05-03 20:50:50.151	\N
c7a759bb-b9c1-4907-af2f-b88bfc9e8967	Stand	Gabruk		\N	3227797571	\N		2025-05-03 20:50:50.152	2025-05-03 20:50:50.152	\N
9cf22ce7-1b0c-426e-8efb-9600449d969c	Sonia	Negrete		\N	\N	\N		2025-05-03 20:50:50.152	2025-05-03 20:50:50.152	\N
b06094e0-1dde-4f7e-a7ca-c2f96578e198	Miguel Edmundo	Pelayo Villalvazo		\N	\N	1986-01-25 00:00:00		2025-05-03 20:50:50.152	2025-05-03 20:50:50.152	\N
cfe3d59b-788b-4c65-a35d-3d1f975aac88	Oliver Emilio	Arrez Lubian		\N	\N	2007-01-20 00:00:00		2025-05-03 20:50:50.153	2025-05-03 20:50:50.153	\N
32ed14a4-3109-4e01-b6ae-ed1004819a75	Karla Samantha	Cervantes Topete		\N	\N	1995-09-13 00:00:00		2025-05-03 20:50:50.153	2025-05-03 20:50:50.153	\N
95ed9dd4-ecb0-4452-8c49-479b370909e9	Luis Pablo	Dolorez Ramirez		\N	\N	1998-02-28 00:00:00		2025-05-03 20:50:50.153	2025-05-03 20:50:50.153	\N
e7614e09-4b99-40fc-b4e5-ba9adcb6a561	Octavio Julian	Espinoza Franco		oespinos@telmex.com	\N	1975-08-16 00:00:00		2025-05-03 20:50:50.154	2025-05-03 20:50:50.154	\N
7b60595c-288f-4dd1-9fd0-f0698bc2474e	JOSE LUIS	MARTINEZ RODRIGUEZ		mrjosewuiz@gmail.com	+523223020789	\N		2025-05-03 20:50:50.154	2025-05-03 20:50:50.154	\N
fb6d63c1-3bf6-4e48-bb4b-4ffacdee64fa	Patricia	Lara Rosales		\N	\N	1960-07-21 00:00:00		2025-05-03 20:50:50.154	2025-05-03 20:50:50.154	\N
2d298c6e-441a-4081-9313-565c8e13a9b0	Lidia Araceli	Rubio de Ortiz		\N	\N	1956-08-03 00:00:00		2025-05-03 20:50:50.155	2025-05-03 20:50:50.155	\N
1bb37860-dcc0-4bff-a05d-dcb2340a9228	Rocio	Cadena Gonzàlez		\N	\N	1955-09-21 00:00:00		2025-05-03 20:50:50.155	2025-05-03 20:50:50.155	\N
9ef10e6a-cbda-4a02-a10a-4092a3a47fec	Rosa María	Martìnez Estrada		\N	\N	1950-06-29 00:00:00		2025-05-03 20:50:50.155	2025-05-03 20:50:50.155	\N
2a32a1cb-c7cb-4f67-bded-6c6c6d497a96	Ricardo	Ibarraran Padilla		ribarraran@todito.com	\N	1959-11-11 00:00:00		2025-05-03 20:50:50.156	2025-05-03 20:50:50.156	\N
b9770293-f380-429c-bc04-a947f08a2e34	Martha	Padilla Sosa		\N	\N	1953-09-13 00:00:00		2025-05-03 20:50:50.156	2025-05-03 20:50:50.156	\N
e161b62a-1304-43e5-af1c-a58826db0fc1	Mònica	Angeles Cervantes		\N	\N	1974-06-09 00:00:00		2025-05-03 20:50:50.156	2025-05-03 20:50:50.156	\N
7faccd82-7038-45fd-a222-b52e4f6cf4ae	Veronica	Valente Castillo		\N	\N	1979-08-26 00:00:00		2025-05-03 20:50:50.157	2025-05-03 20:50:50.157	\N
72026033-c083-444e-aee1-b4e73435a748	Nelly	Castillo Ramìrez		\N	\N	1944-09-10 00:00:00		2025-05-03 20:50:50.157	2025-05-03 20:50:50.157	\N
d464e345-2662-46a2-bfc3-a9ecfaabac0c	Olga	Angulo Solis		\N	\N	1961-08-29 00:00:00		2025-05-03 20:50:50.157	2025-05-03 20:50:50.157	\N
d55cd3db-a54e-4fd0-91f8-631579c46c57	Miguel Angel	Valdovinos Moya		publicidad_lor_vf@hotmail.com	\N	1977-06-26 00:00:00		2025-05-03 20:50:50.158	2025-05-03 20:50:50.158	\N
5ab47dc1-3f17-4ee2-af03-9525baf9e604	Miriam	Mireles Casas		\N	\N	1990-01-04 00:00:00		2025-05-03 20:50:50.158	2025-05-03 20:50:50.158	\N
497da429-3094-4412-bd03-3145d244f8cc	Juan Pablo	Perez Ornelas		moviecoffee@hotmail.com	\N	1979-07-03 00:00:00		2025-05-03 20:50:50.158	2025-05-03 20:50:50.158	\N
385248d0-bcc2-4312-b882-00e21c69a72d	Maria del Carmen	Rodrìguez Santoyo		\N	\N	1947-07-16 00:00:00		2025-05-03 20:50:50.159	2025-05-03 20:50:50.159	\N
24cd1fff-bb18-484b-a86c-e3f1eef51492	Omar Marcelino	Badillo Espinosa		\N	\N	1990-06-02 00:00:00		2025-05-03 20:50:50.159	2025-05-03 20:50:50.159	\N
3974c8c0-3f23-4771-bb7c-acb0de4a1564	Raul	Medina		\N	\N	2003-12-23 00:00:00		2025-05-03 20:50:50.159	2025-05-03 20:50:50.159	\N
0707a9e4-f85d-4192-9152-85c772a24931	Vero	Duran Cortez		\N	\N	1997-10-10 00:00:00		2025-05-03 20:50:50.16	2025-05-03 20:50:50.16	\N
1af268f5-af51-4a9b-af30-74766d7141cb	Mauricio	Gomez Peralta		gomezperalta@hotmail.com	\N	1968-02-09 00:00:00		2025-05-03 20:50:50.16	2025-05-03 20:50:50.16	\N
4dc56f72-ff4e-4dc9-8968-f00c84529aab	Ma. Helena	Garcia de Colin		\N	\N	1963-06-19 00:00:00		2025-05-03 20:50:50.16	2025-05-03 20:50:50.16	\N
9214f317-9623-4b48-a164-1e0d95bfe7fa	Romualdo	Damian Cruz		\N	\N	1950-08-07 00:00:00		2025-05-03 20:50:50.161	2025-05-03 20:50:50.161	\N
026b2775-7a98-4c64-9c28-8c52f7d2d174	Roberto Eduardo	Fernàndez Ruìz		\N	\N	1953-04-25 00:00:00		2025-05-03 20:50:50.161	2025-05-03 20:50:50.161	\N
f0a39603-9403-48e6-a8ff-fe80457eb843	Tomasa	Ovando Trinidad		\N	\N	1974-05-15 00:00:00		2025-05-03 20:50:50.161	2025-05-03 20:50:50.161	\N
2642e167-02dc-4b20-8a9e-fd154aa22d07	Oscar Eddie	Bermeo Ortega		\N	\N	1981-09-15 00:00:00		2025-05-03 20:50:50.162	2025-05-03 20:50:50.162	\N
3c477b22-0d40-49e1-9f7d-3145664ead5a	Luis Fernando	azcanio Zaldivar		\N	\N	1968-07-02 00:00:00		2025-05-03 20:50:50.162	2025-05-03 20:50:50.162	\N
5aed0e63-a6a8-48ad-bb00-e9b009719cf5	Mária Glpe.	Lopez Roa		\N	\N	1958-05-09 00:00:00		2025-05-03 20:50:50.162	2025-05-03 20:50:50.162	\N
5a30c81d-159e-4a98-92ed-213690791517	Julio	Sanchez Cobos		\N	\N	1947-11-18 00:00:00		2025-05-03 20:50:50.163	2025-05-03 20:50:50.163	\N
a3b68239-1c87-4245-b208-8f0b2b31e5f3	Juan Manuel	Fonseca Garay		\N	\N	2004-02-27 00:00:00		2025-05-03 20:50:50.163	2025-05-03 20:50:50.163	\N
bb99637c-bf71-4ddf-881e-bb6532c99ebd	Violeta	Martìnez Angeles		\N	\N	1984-10-15 00:00:00		2025-05-03 20:50:50.163	2025-05-03 20:50:50.163	\N
1927941f-27b3-4aca-b758-bba5516610f2	Lilia Michel	Vite Guzman		\N	\N	1997-08-04 00:00:00		2025-05-03 20:50:50.163	2025-05-03 20:50:50.163	\N
e1b67cff-428f-40b9-9f1b-e59156fc1876	Judith	Olmedo Azhar		\N	\N	2004-03-13 00:00:00		2025-05-03 20:50:50.164	2025-05-03 20:50:50.164	\N
20a5e513-cd88-4b40-8d28-2c9eafef8c1f	Lourdes	Sanchez Riveras		\N	\N	1940-06-22 00:00:00		2025-05-03 20:50:50.164	2025-05-03 20:50:50.164	\N
6c1ec716-9f50-43d5-9ecc-b0fb2d3a1caf	Rosa Marìa	Nuñez Espinal		\N	\N	1948-02-13 00:00:00		2025-05-03 20:50:50.165	2025-05-03 20:50:50.165	\N
6a4de47b-9fa3-4c38-9a1d-8caa15785adb	Jose elihu	Valenzuela Romero		\N	5614383016	\N		2025-05-03 20:50:50.165	2025-05-03 20:50:50.165	\N
c1fc6403-ed99-43b0-9adf-c0730ad089ba	Yunuén	Vázquez Rodríguez		nenidlao@hotmail.com	+523411491075	\N		2025-05-03 20:50:50.165	2025-05-03 20:50:50.165	\N
d0452b24-f643-4fff-b761-a76d250d1359	Jose Luis	Vasquez Sanchez		\N	3222014703	\N		2025-05-03 20:50:50.165	2025-05-03 20:50:50.165	\N
7dbf8da2-c31f-4ebf-b810-c1d650273092	Loren	Ramos Ortilla		\N	\N	1973-04-25 00:00:00		2025-05-03 20:50:50.166	2025-05-03 20:50:50.166	\N
7878cc9f-d717-4e8f-9120-2dec5e0f1871	Sandra	Flores Gutìerrez		\N	\N	1983-11-14 00:00:00		2025-05-03 20:50:50.166	2025-05-03 20:50:50.166	\N
d8ad84f0-d271-4750-8b55-c00f7ed5b2ba	Maria de Los Angeles	Huerta del Rio		mhuera@hotmail.com	\N	1968-10-08 00:00:00		2025-05-03 20:50:50.166	2025-05-03 20:50:50.166	\N
6ae236b2-5fe4-44c0-b3e1-230b06fb5161	Sara	Amaya Gil		\N	\N	1993-08-14 00:00:00		2025-05-03 20:50:50.167	2025-05-03 20:50:50.167	\N
800348c5-d865-4c45-882f-776d4df06e95	Roberto	Mora Ines		\N	\N	1961-07-06 00:00:00		2025-05-03 20:50:50.167	2025-05-03 20:50:50.167	\N
6448d21b-5712-4b54-bea0-d5f922e952e0	Mirella	Herrera Monrroy		\N	\N	1963-05-18 00:00:00		2025-05-03 20:50:50.167	2025-05-03 20:50:50.167	\N
b0a3bd73-1ae7-4330-99dc-84cc80cc0abb	Ricardo	Vidales Calderon		\N	\N	1968-02-16 00:00:00		2025-05-03 20:50:50.168	2025-05-03 20:50:50.168	\N
c94dc962-84cd-440f-927d-385fad3a86ea	Mauricio	Trueba  Màrquez		\N	\N	1964-01-04 00:00:00		2025-05-03 20:50:50.168	2025-05-03 20:50:50.168	\N
9fc73964-21d3-4109-b1da-a2128cb6abca	Ulises	Torres Mondragon		utorres@cft.gob.mx	\N	1971-08-06 00:00:00		2025-05-03 20:50:50.168	2025-05-03 20:50:50.168	\N
adf2ea86-c642-40e9-8c1c-5fcafb94aa7c	Laura	Alatorre Zavala		\N	\N	1967-07-06 00:00:00		2025-05-03 20:50:50.169	2025-05-03 20:50:50.169	\N
3664e3ba-e0c5-4726-9749-d7d3c4bd8bc2	Luis	Gonzales Rodriguez		\N	\N	1959-08-25 00:00:00		2025-05-03 20:50:50.169	2025-05-03 20:50:50.169	\N
228d4708-de9d-4dcd-93c6-85ec48cc2ddc	Ma. Concepción	Trejo Marquez		\N	\N	1982-05-08 00:00:00		2025-05-03 20:50:50.169	2025-05-03 20:50:50.169	\N
1e29e22a-983a-4c9e-b313-84ab046fbfe7	Teresa	Vivanco Martinez		\N	\N	1961-12-03 00:00:00		2025-05-03 20:50:50.169	2025-05-03 20:50:50.169	\N
72367d29-c35c-450c-ab0f-3ffbd25577d0	Vanessa Marìa	Newman Niño		\N	\N	1985-02-07 00:00:00		2025-05-03 20:50:50.17	2025-05-03 20:50:50.17	\N
d85c8cfe-e2ba-4c7a-9319-04307c5427aa	Monserrat	Salazar Ortiz		\N	\N	2004-07-05 00:00:00		2025-05-03 20:50:50.17	2025-05-03 20:50:50.17	\N
987ca548-dcf4-4efd-8dfc-7bce976c39b4	Maria Luisa	Arroyo Gonzàlez		\N	\N	1954-06-21 00:00:00		2025-05-03 20:50:50.171	2025-05-03 20:50:50.171	\N
70f1c814-1f82-44cf-a0d9-58f51eddeced	Lucia	Duran de Oviedo		licyrenace@yahoo.com.mx	\N	1963-11-11 00:00:00		2025-05-03 20:50:50.171	2025-05-03 20:50:50.171	\N
c04c9f3e-7938-41ba-af64-0c48693ed105	Karla	Bosch Perea		\N	\N	1971-02-01 00:00:00		2025-05-03 20:50:50.171	2025-05-03 20:50:50.171	\N
138788f1-f5ed-4296-bfce-a3112cf7c7fb	Maria del Carmen	Peña Arcos		\N	\N	1940-12-16 00:00:00		2025-05-03 20:50:50.172	2025-05-03 20:50:50.172	\N
16491515-9be4-4c34-a603-46f8fb2f4b3e	Ma. de los Angeles	Reyes Alegria		\N	\N	1953-05-28 00:00:00		2025-05-03 20:50:50.172	2025-05-03 20:50:50.172	\N
c13a5b08-b8a9-44d2-977d-277070e02b4f	Maricela	Mendoza Reyes.		\N	\N	2004-10-14 00:00:00		2025-05-03 20:50:50.173	2025-05-03 20:50:50.173	\N
3d4a0e57-a107-4f38-8cf6-b9cc76b7fb30	Melissa	Dorantes Trejo		\N	\N	1994-12-15 00:00:00		2025-05-03 20:50:50.173	2025-05-03 20:50:50.173	\N
cf70b1d8-d6ff-49e4-9d2f-1b98cae991f5	Roal	Dorantes Trejo		\N	\N	1991-05-24 00:00:00		2025-05-03 20:50:50.173	2025-05-03 20:50:50.173	\N
6472fc76-e734-4878-acff-9ad25996402d	Karen	Blanco Pérez		\N	\N	1989-03-12 00:00:00		2025-05-03 20:50:50.173	2025-05-03 20:50:50.173	\N
9a02bb3a-3212-4282-bfa0-271095883180	Nahely	Cano Ruiz		\N	\N	1976-08-11 00:00:00		2025-05-03 20:50:50.174	2025-05-03 20:50:50.174	\N
d930813f-4014-4907-b9df-75145317cd1e	Rigoberto	Burciaga Andujo		\N	\N	1956-06-30 00:00:00		2025-05-03 20:50:50.174	2025-05-03 20:50:50.174	\N
0a553ab3-129e-4597-901e-4102ca4e0a1f	Lucero Mireya	Angeles Ruíz		\N	\N	2004-12-11 00:00:00		2025-05-03 20:50:50.174	2025-05-03 20:50:50.174	\N
f8ab832f-5ae8-4b7d-8b4a-d8fd51ede335	Luis	Vega Contreras		\N	\N	1976-05-03 00:00:00		2025-05-03 20:50:50.175	2025-05-03 20:50:50.175	\N
1b6db8c6-06e4-40f4-88d9-49ff53c315e8	Rene Alberto	Villalobos Mercado		\N	\N	2005-01-31 00:00:00		2025-05-03 20:50:50.175	2025-05-03 20:50:50.175	\N
514b811a-f0a8-430c-962a-edddfc267fc3	Laura	Barrios Alvarez		\N	\N	1982-01-09 00:00:00		2025-05-03 20:50:50.175	2025-05-03 20:50:50.175	\N
f749922c-d2ce-401a-92c6-936b4d170a4f	Miriam	Perez Rubio		\N	\N	1995-12-31 00:00:00		2025-05-03 20:50:50.176	2025-05-03 20:50:50.176	\N
b027d8d5-0508-4633-9898-f894e6699e18	Maria	Arellano Castillo		\N	\N	1976-05-20 00:00:00		2025-05-03 20:50:50.176	2025-05-03 20:50:50.176	\N
c09b6011-32c8-4bab-b94a-f9c07811e612	Sergio	Perez Muñoz		\N	\N	2005-03-07 00:00:00		2025-05-03 20:50:50.176	2025-05-03 20:50:50.176	\N
29dbab7b-f625-4032-9dfc-6f6b4c2d0a8b	Oscar	Del Rosario Rosario		\N	\N	1948-01-07 00:00:00		2025-05-03 20:50:50.177	2025-05-03 20:50:50.177	\N
681d5195-4ca7-4742-bfd8-a90693423a41	Paulina	Tecocoatzi Camacho		\N	\N	1999-04-02 00:00:00		2025-05-03 20:50:50.177	2025-05-03 20:50:50.177	\N
25d8d3a0-a3bc-4e9a-96f5-bd711f1c6800	Victoria	Garcia Martinez		\N	\N	1992-07-17 00:00:00		2025-05-03 20:50:50.177	2025-05-03 20:50:50.177	\N
5cfbce9a-f0d2-4080-a7ae-60b49f6a07f4	María de Lourdes	Isidro Dominguez		\N	\N	1964-08-25 00:00:00		2025-05-03 20:50:50.178	2025-05-03 20:50:50.178	\N
5008c18f-2190-4f49-970f-12eed810af13	Saul	Pacheco Guajardo		\N	\N	2005-05-25 00:00:00		2025-05-03 20:50:50.178	2025-05-03 20:50:50.178	\N
22e9246c-25ed-4d6e-b5d3-23a629d10189	Luis Eduardo	Romero Maldonado		\N	\N	1999-08-21 00:00:00		2025-05-03 20:50:50.178	2025-05-03 20:50:50.178	\N
aebff67a-8fe2-4b8d-9fd2-3706216769d9	Sergio	Ibarra Falcón		\N	\N	2005-07-26 00:00:00		2025-05-03 20:50:50.178	2025-05-03 20:50:50.178	\N
d2606bc7-e0fd-4859-ac15-1da8f02365dc	Porfirio	Díaz  Marín		\N	\N	1956-08-08 00:00:00		2025-05-03 20:50:50.179	2025-05-03 20:50:50.179	\N
a2e12806-4f4f-4612-bd58-4d628039e274	Mauricio	Girette gonzalez		\N	\N	1972-11-09 00:00:00		2025-05-03 20:50:50.179	2025-05-03 20:50:50.179	\N
04931090-a9e0-475d-ae02-0fd02f151ad9	Nayeli Saide	Peralta Montiel		\N	\N	2005-09-22 00:00:00		2025-05-03 20:50:50.179	2025-05-03 20:50:50.179	\N
b923cf94-7b1b-4e52-9634-b6c2aabde710	Roberto	Beltran Cebrero		\N	\N	1954-06-07 00:00:00		2025-05-03 20:50:50.18	2025-05-03 20:50:50.18	\N
c0e79a09-e032-4553-b7bb-de24bea3b352	Ulises	Lara Villareal		\N	\N	1972-02-10 00:00:00		2025-05-03 20:50:50.18	2025-05-03 20:50:50.18	\N
831207a4-ae7a-4365-8810-f0da6613dfcc	Maria del Rosario	Martinez Garcia		\N	\N	2005-12-03 00:00:00		2025-05-03 20:50:50.18	2025-05-03 20:50:50.18	\N
4b29d3e0-ea8a-4501-af41-4f14b90d30ef	Monrroy Alvarez	Melissa		\N	\N	\N		2025-05-03 20:50:50.181	2025-05-03 20:50:50.181	\N
32a0d628-df95-4748-80fe-56d489b729ab	Melissa	Monrroy Alvarez		\N	\N	1964-11-24 00:00:00		2025-05-03 20:50:50.181	2025-05-03 20:50:50.181	\N
5718bf9d-f35b-4482-b908-3ddc4e96a00a	Sergio	Cruz Salazar		\N	\N	1964-11-24 00:00:00		2025-05-03 20:50:50.181	2025-05-03 20:50:50.181	\N
89172772-ebde-4c30-adb3-f17c89bdcc97	Karen Elizabeth	Jimenez Howes		\N	\N	1964-11-24 00:00:00		2025-05-03 20:50:50.182	2025-05-03 20:50:50.182	\N
3790b5fb-9381-41f2-8107-90cf3c60e1f6	Norma Angelica	Ortiz Ruiz		\N	\N	1971-05-07 00:00:00		2025-05-03 20:50:50.182	2025-05-03 20:50:50.182	\N
429ce75e-7405-42fb-aadf-a310687d95c9	Luis	Peña Muñoz		\N	\N	1977-09-22 00:00:00		2025-05-03 20:50:50.182	2025-05-03 20:50:50.182	\N
c7183fba-a063-4f7a-99cb-785b239a2722	Rosario	Santos Castro		\N	\N	2006-01-16 00:00:00		2025-05-03 20:50:50.183	2025-05-03 20:50:50.183	\N
028dabf4-db13-49bf-baa9-9f55688ddb8c	Pamela	Velàzquez Moreno		\N	\N	2006-01-24 00:00:00		2025-05-03 20:50:50.183	2025-05-03 20:50:50.183	\N
0b724694-8774-46db-9673-93f9dd7d2450	Luis Enrrique	Ovando Rodríguez		ovando75@hotmail.com	\N	1975-11-02 00:00:00		2025-05-03 20:50:50.183	2025-05-03 20:50:50.183	\N
31d72bc7-4eab-4380-8ace-a708fc0fbddf	Teresa	Vega Asceves		\N	\N	1974-08-14 00:00:00		2025-05-03 20:50:50.184	2025-05-03 20:50:50.184	\N
0298569f-add8-4b67-bd6a-4cb6a71ac909	Lorena	mayo Dominguez		\N	\N	2006-04-04 00:00:00		2025-05-03 20:50:50.184	2025-05-03 20:50:50.184	\N
da616e8a-f895-49c8-b03e-647f9c17105b	Julieta	Lopéz Hernandez		\N	\N	1968-10-22 00:00:00		2025-05-03 20:50:50.184	2025-05-03 20:50:50.184	\N
5a820cd2-082d-45c9-a831-6d2ed7fc7dfc	Miguel Angel	Camacho Salvatierra		\N	\N	1998-09-29 00:00:00		2025-05-03 20:50:50.185	2025-05-03 20:50:50.185	\N
7ec595b5-607e-4c57-8899-ac2e8ab280ec	Lilia	Flores Martinez		ilfom3@hotmail.com	\N	1978-05-05 00:00:00		2025-05-03 20:50:50.185	2025-05-03 20:50:50.185	\N
1baf34ad-fa3a-43cc-9072-b6a5bd20306c	Maria de la Luz	Escarcega Ramirez		\N	\N	2006-09-19 00:00:00		2025-05-03 20:50:50.185	2025-05-03 20:50:50.185	\N
a4354eb5-ba9f-4e92-b05d-84e72e449d51	Marco Antonio	Marical Rodriguez		\N	\N	2006-11-10 00:00:00		2025-05-03 20:50:50.185	2025-05-03 20:50:50.185	\N
0a76407d-6582-4328-8a66-b680a05e4375	Miguel	Aguirre Hernandez		\N	\N	1960-09-05 00:00:00		2025-05-03 20:50:50.186	2025-05-03 20:50:50.186	\N
de324614-7a53-45db-abcf-7c86dcbc430f	Ricardo	Vargas Velazco		\N	\N	1993-07-17 00:00:00		2025-05-03 20:50:50.186	2025-05-03 20:50:50.186	\N
e193e45e-2317-42b1-8e52-1e937c5142e9	Veronica	Mondragón Reyes		veronicamondragon23@hotmail.com	\N	1969-03-22 00:00:00		2025-05-03 20:50:50.187	2025-05-03 20:50:50.187	\N
62208a64-31b8-419e-82c0-c20a801cd45c	Yolanda	López Peña		\N	\N	1957-05-01 00:00:00		2025-05-03 20:50:50.187	2025-05-03 20:50:50.187	\N
595aba25-1df0-4b81-8d89-2055431090d1	Roxana	Mayo Dominguez		\N	\N	2007-02-22 00:00:00		2025-05-03 20:50:50.187	2025-05-03 20:50:50.187	\N
cba6b4f0-c9ee-4df4-a0bc-d6761e66a06d	Marcial	Islas Rivera		\N	\N	2007-03-05 00:00:00		2025-05-03 20:50:50.188	2025-05-03 20:50:50.188	\N
e1ccddf9-1bf4-4af5-b109-2d5af6e25d24	Veronica	López Matinez		\N	\N	1977-09-27 00:00:00		2025-05-03 20:50:50.188	2025-05-03 20:50:50.188	\N
44865d9a-85a7-4972-b6d6-8e9532ba6c7b	Reyna	Monrroy Antonio		\N	\N	2007-04-10 00:00:00		2025-05-03 20:50:50.188	2025-05-03 20:50:50.188	\N
a01af07f-0a90-4a3b-81a5-025a93f23ab2	Patricia	Amezcua Verdusco		patverduzco@hotmail.com	\N	1982-10-14 00:00:00		2025-05-03 20:50:50.189	2025-05-03 20:50:50.189	\N
e997f0e6-6111-4b03-b743-a3f7cfe8ec08	Maria de los Angeles	Valencia Morales		\N	\N	1965-07-03 00:00:00		2025-05-03 20:50:50.189	2025-05-03 20:50:50.189	\N
d9ec7edd-9201-46f0-8e1a-f9e1c10056b9	Maria Rene	lopez Rosales		yvetterv@hotmail.com	\N	2000-06-17 00:00:00		2025-05-03 20:50:50.189	2025-05-03 20:50:50.189	\N
baf7ec1b-0828-46d9-be1f-a55292e02a46	Virginia	Gonzales Constante		moda_viki@hotmail.com	\N	1960-01-31 00:00:00		2025-05-03 20:50:50.189	2025-05-03 20:50:50.189	\N
eb8d748e-e5d9-47b6-bdf0-20d62544987b	Margarito	Salcedo Mesa		margaritosm@hotmail.com	\N	1977-02-22 00:00:00		2025-05-03 20:50:50.19	2025-05-03 20:50:50.19	\N
8acc5cbe-acf5-4c6f-beb7-582c9f87248f	Juan Jose	Santos Palafox		jjsp1967@hotmail.com	\N	1967-04-04 00:00:00		2025-05-03 20:50:50.19	2025-05-03 20:50:50.19	\N
a09bdb35-17f3-4f98-82c6-b82f45dd26ad	Ruth	De León Jaxiola		rucaxi@hotmail.com	\N	1967-04-27 00:00:00		2025-05-03 20:50:50.19	2025-05-03 20:50:50.19	\N
75b78225-a2fc-484f-bfb9-c832c77d9e27	Ricardo	Robles Anaya		\N	\N	1948-02-07 00:00:00		2025-05-03 20:50:50.191	2025-05-03 20:50:50.191	\N
f5364275-9898-4c07-ad4b-0fa50654b2e8	Maria Elena	Mendoza de Famania		\N	3221923277	1952-12-31 00:00:00		2025-05-03 20:50:50.191	2025-05-03 20:50:50.191	\N
4c518e4d-3323-4e3a-8650-83164bfc490f	Marco Antonio	Robles Reyes		marco_contrufin@hotmail.com	\N	1969-10-08 00:00:00		2025-05-03 20:50:50.191	2025-05-03 20:50:50.191	\N
8b6960fa-da3a-4e64-9bce-587f2986d653	Miguel Angel	Centeno Ontiveros		miguel-centeno@hotmail.com	\N	1983-02-09 00:00:00		2025-05-03 20:50:50.192	2025-05-03 20:50:50.192	\N
d84d2b28-0137-4cc0-808e-87a2044696f7	Luz del Carmen	Peña Ruiz		\N	\N	1950-09-26 00:00:00		2025-05-03 20:50:50.192	2025-05-03 20:50:50.192	\N
5c938936-2e57-41b7-b7a6-768cea5cea40	Luis	Galindo Cervantes		madgesol@hotmail.com	\N	1956-12-17 00:00:00		2025-05-03 20:50:50.192	2025-05-03 20:50:50.192	\N
c75446a1-5363-48c8-a6d5-7683e09207a7	Madjejusol Atenea	Garza Aldaba		madgesol@hotmail.com	\N	1966-06-24 00:00:00		2025-05-03 20:50:50.193	2025-05-03 20:50:50.193	\N
174590f2-0dd7-414b-9b5f-3c7be0f1fca1	Karla	Barajas Hermosillo		\N	3223550066	1966-03-27 00:00:00		2025-05-03 20:50:50.193	2025-05-03 20:50:50.193	\N
f25ee748-ec92-4bcb-93fc-387f31523a84	Oscar	Silva		siguvallarta@hotmail.com	\N	1945-02-24 00:00:00		2025-05-03 20:50:50.193	2025-05-03 20:50:50.193	\N
12fbbc10-f696-44de-9273-d0cd1133932e	Manuel	Martinez Villalobos		ingmtz_hispania@hotmail.com	\N	1949-11-26 00:00:00		2025-05-03 20:50:50.194	2025-05-03 20:50:50.194	\N
32dfa915-51cc-408e-a5f0-c79c9004a8d3	Terecita	Zamora		tzamora_t@hotmail.com	\N	1967-10-07 00:00:00		2025-05-03 20:50:50.194	2025-05-03 20:50:50.194	\N
bac6c388-bfed-49d2-a1c5-d61726f7564a	Ruth	Zarco Venegas		\N	\N	1955-10-30 00:00:00		2025-05-03 20:50:50.194	2025-05-03 20:50:50.194	\N
435a23ee-adfe-40ae-88a0-ba9cf8a280b2	Matilde	Cuevas de Robles		maticuevas@yahoo.com.mx	\N	1962-03-14 00:00:00		2025-05-03 20:50:50.195	2025-05-03 20:50:50.195	\N
4c390d31-f983-4a90-af0d-85281a48ae18	Raquel	Madero García		\N	\N	1958-04-09 00:00:00		2025-05-03 20:50:50.195	2025-05-03 20:50:50.195	\N
51871e5a-6800-48c0-b829-18feff5b7470	Nedd	Norris		\N	\N	1936-12-25 00:00:00		2025-05-03 20:50:50.195	2025-05-03 20:50:50.195	\N
2c1ee1da-9453-4020-8afe-2f3e024fede8	Luz Divina	Castellón Alvárez		zulid_18@msn.com	\N	1985-04-23 00:00:00		2025-05-03 20:50:50.196	2025-05-03 20:50:50.196	\N
7be4e2d9-1592-4f53-9973-55ad4facae64	Melisa Anahi	De la torre		\N	\N	1988-09-26 00:00:00		2025-05-03 20:50:50.196	2025-05-03 20:50:50.196	\N
8f2ba3d0-7769-4b8b-8280-f5f9ae40a28e	Rosa Isabel	Ramírez Aldaco		isabelrameresvta@hotmail.com	\N	1976-09-09 00:00:00		2025-05-03 20:50:50.196	2025-05-03 20:50:50.196	\N
18b18847-68ed-4c92-a719-5504a80eb529	Maria Gpe.	del Toro Pérez		\N	\N	1958-12-07 00:00:00		2025-05-03 20:50:50.197	2025-05-03 20:50:50.197	\N
8c386a7d-5bec-4afc-9e75-9bb11329444e	Melissa	Martinez Madero		mtzmel@hotmail.com	\N	1980-08-30 00:00:00		2025-05-03 20:50:50.197	2025-05-03 20:50:50.197	\N
3d64ccd0-e031-4e66-9bd9-ba2047887ae2	Veronica	Godinez Arciniega		\N	\N	1968-07-25 00:00:00		2025-05-03 20:50:50.198	2025-05-03 20:50:50.198	\N
f8357db9-de43-4e26-a41e-ca49be988cce	Maria Ampelia	Quiñonez López		\N	\N	1965-01-28 00:00:00		2025-05-03 20:50:50.198	2025-05-03 20:50:50.198	\N
d9a3954c-9f46-4a16-85a7-93934c04e52a	Noemi	Gomez Prado		noemi_gop@hotmail.com	\N	1975-01-23 00:00:00		2025-05-03 20:50:50.198	2025-05-03 20:50:50.198	\N
b2ace625-6574-4691-83e7-2513d93a3ae9	Kathie	Colont		kcolont@gmail.com	\N	1956-05-15 00:00:00		2025-05-03 20:50:50.198	2025-05-03 20:50:50.198	\N
23da7bf3-706e-4ec7-83d2-e20027da7ec7	Teresa de Jesus	Rodriguez García		teresa_nurserg@hotmail.com	\N	1963-06-26 00:00:00		2025-05-03 20:50:50.199	2025-05-03 20:50:50.199	\N
cfc6cffb-763f-478f-8840-980cc479e484	Rafael	Alvarado Arechiga		\N	\N	1968-10-14 00:00:00		2025-05-03 20:50:50.199	2025-05-03 20:50:50.199	\N
b9c8273c-68af-43c4-bdcb-e1d874258908	Pablo	Torres		pablotorres@palmaterra.com.mx	\N	1978-11-18 00:00:00		2025-05-03 20:50:50.199	2025-05-03 20:50:50.199	\N
e04582da-133d-4172-9480-0ea50ee804d8	Leticia	De la Lama Treviño		ltdlalama@hotmail.com	\N	1960-08-16 00:00:00		2025-05-03 20:50:50.2	2025-05-03 20:50:50.2	\N
03921954-faa1-4f7c-8aa3-3e7f515bd9ac	Miriam Valeria	Hernández Alonzo		\N	\N	1993-02-20 00:00:00		2025-05-03 20:50:50.2	2025-05-03 20:50:50.2	\N
e8d52d59-5bd9-4f54-8cb7-7f1b931386d5	Oscar	Angiano López		granfarruco@hotmail.com	\N	1964-06-21 00:00:00		2025-05-03 20:50:50.2	2025-05-03 20:50:50.2	\N
9c62a0f9-2e4e-45c0-8c2d-5af076156dfa	Leonardo	Guixeras		\N	\N	1961-12-04 00:00:00		2025-05-03 20:50:50.201	2025-05-03 20:50:50.201	\N
868ebe7d-ce54-47ba-83c4-dc43ebbb4ba6	Vanessa	Meissner		vany2404@hotmail.com	\N	1974-04-24 00:00:00		2025-05-03 20:50:50.201	2025-05-03 20:50:50.201	\N
efd89431-6291-4d4e-8554-28b1edd450af	Xochitl	Vazquez Barbosa		xocitl_doll@hotmail.com	\N	1990-02-28 00:00:00		2025-05-03 20:50:50.201	2025-05-03 20:50:50.201	\N
fde9b0c6-93aa-4aeb-affb-b85ca907439f	Rafael	Rodriguez Loera		\N	\N	1962-02-28 00:00:00		2025-05-03 20:50:50.202	2025-05-03 20:50:50.202	\N
074504ae-e836-4b54-91f8-6c1a4ba7b42c	Karina	Macias Aguirre		kmacias7@gmail.com	\N	1978-01-02 00:00:00		2025-05-03 20:50:50.202	2025-05-03 20:50:50.202	\N
dff2e09e-bbf0-463a-ac7a-2c2c12975366	Libertad  Yolanda	Vargas Flores		\N	\N	1958-02-24 00:00:00		2025-05-03 20:50:50.202	2025-05-03 20:50:50.202	\N
9dc95b91-46cd-4656-8c6c-39f9564402a3	Luz Maria	Romero Campos		luz.maromero@hotmail.com	\N	1951-08-21 00:00:00		2025-05-03 20:50:50.203	2025-05-03 20:50:50.203	\N
b2067aa0-de8e-461c-aa6b-dc04e4bd8bf9	Leticia	Sambrano		\N	\N	1966-12-05 00:00:00		2025-05-03 20:50:50.203	2025-05-03 20:50:50.203	\N
02a996b8-1606-447a-9782-93e488329ff0	Miguel Angel	Arreaga Padilla		miguel.ap.90@hotmail.com	\N	1990-04-12 00:00:00		2025-05-03 20:50:50.203	2025-05-03 20:50:50.203	\N
b48f90a6-eaa7-499b-9d5d-03d6f9d74bce	Yvette Alexia	Piñero Robles		xalyapr@yahoo.com	\N	1965-08-29 00:00:00		2025-05-03 20:50:50.204	2025-05-03 20:50:50.204	\N
6f313a19-f258-43b8-9744-5ef2f80d0493	Nanci	Juixeras Salcido		nancy_pichu@hotmail.com	\N	1978-10-08 00:00:00		2025-05-03 20:50:50.204	2025-05-03 20:50:50.204	\N
9c054184-945d-4d0e-b43c-ab2ee5bc6bde	Norma	Centeno		normaz1036@yahoo.com.mx	\N	1967-08-10 00:00:00		2025-05-03 20:50:50.204	2025-05-03 20:50:50.204	\N
6c23b32c-097b-4f8e-a7c9-8c632f7ce729	Monica	Fregoso Ramos		monicafrego@hotmail.com	\N	1976-03-03 00:00:00		2025-05-03 20:50:50.205	2025-05-03 20:50:50.205	\N
3516f6ff-db12-487f-a7ae-385b526310d9	yolanda	gutierrez		yogutierrez@htomail.com	\N	1969-01-23 00:00:00		2025-05-03 20:50:50.205	2025-05-03 20:50:50.205	\N
a57a3a45-8741-427f-b90e-1d3036b4b064	Tomasa	Rodriguez García		\N	\N	1946-03-07 00:00:00		2025-05-03 20:50:50.205	2025-05-03 20:50:50.205	\N
29b13b1e-64ab-4a19-be2f-646992b67269	Noe	Renteria		zurdok_nuvi19@hotmail.com	\N	1987-11-07 00:00:00		2025-05-03 20:50:50.206	2025-05-03 20:50:50.206	\N
4073df6a-c780-446b-96e4-ddaf224bc0e4	Maria del Refugio	Samora Sanchez		\N	\N	1977-09-26 00:00:00		2025-05-03 20:50:50.206	2025-05-03 20:50:50.206	\N
dfc3afeb-1c7b-49da-8b9f-04ac1d751980	Klementina	Dimova		macmexphotography@gmail.com	\N	2002-12-07 00:00:00		2025-05-03 20:50:50.206	2025-05-03 20:50:50.206	\N
754a3a40-0373-4b0f-899b-8f9e47454973	Vanesa	Alvarez		vanesask@yahoo.com	\N	1981-11-04 00:00:00		2025-05-03 20:50:50.207	2025-05-03 20:50:50.207	\N
04e82376-3aa1-4893-b4e1-6f69f7a9fb75	Pedro Mario	Gonzalez Peñaloza		pedro_ale633@hotmail.com	\N	1989-01-13 00:00:00		2025-05-03 20:50:50.207	2025-05-03 20:50:50.207	\N
1afdbdcf-0e55-460e-84a5-2c4394ca3c81	Juan Salvador	Castillon Agras		salvador.agraz@gmail.com	\N	1995-03-01 00:00:00		2025-05-03 20:50:50.207	2025-05-03 20:50:50.207	\N
32ffce23-dd32-41d1-aaa7-3a417607175d	Lourdes	Sanchez Tapia		\N	\N	1972-03-12 00:00:00		2025-05-03 20:50:50.208	2025-05-03 20:50:50.208	\N
2d8fac37-365d-4b64-b727-24f5b288e01c	Salim	Abugannam Villaseñor		sabugannamv@gmail.com	\N	1980-02-25 00:00:00		2025-05-03 20:50:50.208	2025-05-03 20:50:50.208	\N
c198ff46-7305-43f6-a445-3d98926539a7	Rebeca	Arellanes		arellaneslee@hotmail.com	\N	1967-04-06 00:00:00		2025-05-03 20:50:50.208	2025-05-03 20:50:50.208	\N
393b9271-25be-4101-8a71-feb1ce0bd686	Zulet	Perez Cisneros		ZULETH@hotmail.com	\N	1979-04-21 00:00:00		2025-05-03 20:50:50.209	2025-05-03 20:50:50.209	\N
26a69463-7242-4ed0-9b3d-1827ffd45e2d	Luis Federico	Jimenez Betancourt		\N	\N	1987-12-06 00:00:00		2025-05-03 20:50:50.209	2025-05-03 20:50:50.209	\N
606dbe05-fa6f-4c76-b393-7146ccfa7a82	Juan Ramón	Vega Quintero		angelgabrielvallarta@hotmail.com	\N	1978-01-24 00:00:00		2025-05-03 20:50:50.209	2025-05-03 20:50:50.209	\N
36c9eaf9-a0dc-46ec-aa30-a0b1d17c838c	Zulma	Santana Ramos		mituly78@hotmail.com	\N	1978-04-08 00:00:00		2025-05-03 20:50:50.21	2025-05-03 20:50:50.21	\N
e9738693-98d0-4cb4-96ba-fc2da5ecc629	Leodegario	Pérez Costilla		\N	\N	1967-02-01 00:00:00		2025-05-03 20:50:50.21	2025-05-03 20:50:50.21	\N
426569ff-80de-4261-84df-a41fa4821a77	Luis	Carrasco		\N	\N	1952-05-25 00:00:00		2025-05-03 20:50:50.21	2025-05-03 20:50:50.21	\N
7cff3e64-ca56-44f2-97be-6bf7fcd9145c	Robert	Colont		rcolont@comcast.net	\N	\N		2025-05-03 20:50:50.211	2025-05-03 20:50:50.211	\N
9b874e43-eddc-4404-9a32-21f2dc488bbb	Tomasa	Robles Ortega		karendaniela_659@hotmail.com	\N	1967-03-07 00:00:00		2025-05-03 20:50:50.211	2025-05-03 20:50:50.211	\N
cd1175f3-7347-442b-b318-cdd47a1fec27	Maria Teresa	Deveze Gonzali		\N	\N	1943-01-12 00:00:00		2025-05-03 20:50:50.211	2025-05-03 20:50:50.211	\N
5d7e1142-c740-465f-9cb8-cfe0e2a7e9b8	Rosa Maria	Farias Barriga		\N	\N	\N		2025-05-03 20:50:50.212	2025-05-03 20:50:50.212	\N
34b3e9a7-3df0-4eff-8d2f-c24254a88c96	Marta	Martinez Villalobos		marta_victoria@life.com.mx	\N	1961-01-15 00:00:00		2025-05-03 20:50:50.212	2025-05-03 20:50:50.212	\N
818f422f-3b4c-42d1-a866-7fc678109a53	Maricruz	Rosales Chávez		maricruz_649@yahoo.com.mx	\N	1961-05-03 00:00:00		2025-05-03 20:50:50.212	2025-05-03 20:50:50.212	\N
6e6e6241-4c8b-4ce6-9e73-8884c0206ec0	Madelyn	Fregoso Lopez		bossanovita@gmail.com	3221307487	1985-08-12 00:00:00		2025-05-03 20:50:50.213	2025-05-03 20:50:50.213	\N
a0b51050-f914-4d7a-aa8a-596bc7eca28e	Juana	Almaraz García		\N	\N	1960-06-24 00:00:00		2025-05-03 20:50:50.213	2025-05-03 20:50:50.213	\N
1153835d-e116-4b11-affb-0368eb98a164	Maria Lucila	Romano Perez Milicua		\N	\N	1954-01-01 00:00:00		2025-05-03 20:50:50.213	2025-05-03 20:50:50.213	\N
defb3343-7455-42ce-8d7c-277c2e922bfd	Peter	Koransky		pkoransky@yahoo.com	\N	1944-08-08 00:00:00		2025-05-03 20:50:50.214	2025-05-03 20:50:50.214	\N
e613a034-5fdb-40bd-9d1f-646a169a3784	Oscar	Ortega Ramírez		tiberio_ortega@hotmail.com	\N	1974-07-13 00:00:00		2025-05-03 20:50:50.214	2025-05-03 20:50:50.214	\N
20b0bc47-2a13-4f6d-86f0-ca74c90ad238	Patricia	Garcia		pgg_vip@hotmail.com	\N	1954-09-02 00:00:00		2025-05-03 20:50:50.214	2025-05-03 20:50:50.214	\N
42f70dc3-de95-493d-ab1e-90b0aaed8f60	Ricardo	Morales Jimenez		rick_9811@hotmail.com	\N	1998-07-29 00:00:00		2025-05-03 20:50:50.214	2025-05-03 20:50:50.214	\N
4b02b988-0a55-48c1-9657-008a08d1de50	Rafael	Muños		munraf1949@yahoo.com	\N	1949-09-14 00:00:00		2025-05-03 20:50:50.215	2025-05-03 20:50:50.215	\N
b828c156-7ed3-4219-91a3-f123625ade8e	Mariana	Delgado		delgadovalenzuela@hotmail.com	\N	1981-10-21 00:00:00		2025-05-03 20:50:50.215	2025-05-03 20:50:50.215	\N
12d9c0f5-8423-4806-91eb-c15788a04c3a	Lucille	Dowson		dawsonluci@hotmail.com	\N	1949-03-23 00:00:00		2025-05-03 20:50:50.215	2025-05-03 20:50:50.215	\N
1a276cb1-206e-4705-b3b0-9eec4300e556	Maria	Villa Reyes		\N	\N	1952-11-01 00:00:00		2025-05-03 20:50:50.216	2025-05-03 20:50:50.216	\N
1d57e70b-eb97-46ee-95ae-d3d72b1e90e5	Juan MIguel	Ramirez Ozuna		j.migue_26@live.com	\N	1961-05-26 00:00:00		2025-05-03 20:50:50.216	2025-05-03 20:50:50.216	\N
b615571c-d9db-42d3-a941-377c6ad3c423	Manuel	Ledesma Corral		mledesma@tribunadeloscabos.com.mx	\N	1958-02-06 00:00:00		2025-05-03 20:50:50.216	2025-05-03 20:50:50.216	\N
09017564-f0b5-4c43-a1ee-a834d790a7b7	Yolanda	Alonzo Villa		\N	3228885935	1973-05-26 00:00:00		2025-05-03 20:50:50.217	2025-05-03 20:50:50.217	\N
7f0eeb04-65f8-498c-9d59-79d8a7e59eb8	Mary	Thomassen		mary@platinum.ca	\N	1946-02-25 00:00:00		2025-05-03 20:50:50.217	2025-05-03 20:50:50.217	\N
dc7f0c0a-adab-40d3-ba89-5d063f2cdf22	Mavidalia	Esparza Rodríguez		frenesi2511@hotmail.com	\N	1951-06-29 00:00:00		2025-05-03 20:50:50.217	2025-05-03 20:50:50.217	\N
37300079-4f2c-4ad9-b45b-fbf4acc98886	Luz Rubi	Ybarra Pinedo		\N	\N	\N		2025-05-03 20:50:50.218	2025-05-03 20:50:50.218	\N
76d2bee4-d0af-4fa5-9dc9-ecdd7b8f9279	juliio	Gutierrez		\N	\N	\N		2025-05-03 20:50:50.218	2025-05-03 20:50:50.218	\N
7683326c-17c1-4003-9386-c9330b410685	Seida	Hernández Vela		seidahdzv@hotmail.com	\N	1975-11-20 00:00:00		2025-05-03 20:50:50.218	2025-05-03 20:50:50.218	\N
29046a03-f501-4814-b229-8c8a727c7ef1	Susan	Catwell		\N	\N	\N		2025-05-03 20:50:50.218	2025-05-03 20:50:50.218	\N
08484c8f-536c-4787-8527-44aebd3b1a88	Maria	Abad Sayago		pvyogini@gmail.com	\N	1965-09-27 00:00:00		2025-05-03 20:50:50.219	2025-05-03 20:50:50.219	\N
9be299ff-a211-4087-8c4f-d5b14a5205e3	Noemi	Aguirre Salcedo		noemipas33@hotmail.com	\N	1972-09-23 00:00:00		2025-05-03 20:50:50.219	2025-05-03 20:50:50.219	\N
8dd6a5eb-1681-40c1-928e-e524e68244c4	Martin	García Gonzalez		\N	\N	1971-11-03 00:00:00		2025-05-03 20:50:50.219	2025-05-03 20:50:50.219	\N
6d1d1682-037c-4b6e-aa86-6d42f7759074	Nalleli	Barajas Mungia		nay.barajas@gmail.com	\N	1981-07-12 00:00:00		2025-05-03 20:50:50.22	2025-05-03 20:50:50.22	\N
e2e6ca0f-b8f4-4c26-9be8-4a869c0451f2	Pedro	Solorzano Rodarte		pedro.solorzano@ine.mx	\N	1955-06-08 00:00:00		2025-05-03 20:50:50.22	2025-05-03 20:50:50.22	\N
58540fea-eec0-42ca-a15e-65e21fdfb722	Marta	Castro Macias		\N	\N	\N		2025-05-03 20:50:50.221	2025-05-03 20:50:50.221	\N
4b52c5f9-7d00-4eb8-8841-80d579f7d2de	Wendy	Jimenez Armenta		\N	\N	\N		2025-05-03 20:50:50.221	2025-05-03 20:50:50.221	\N
9365634b-c2d5-432b-a13b-48acfedab8a4	Ma. Elena	Rodriguéz López		maelena_rl@hotmail.com	\N	1963-01-06 00:00:00		2025-05-03 20:50:50.221	2025-05-03 20:50:50.221	\N
eaa546ed-2fb0-48b9-afda-0d87ae12417f	Olinda	Figeroa Alvarado		\N	\N	1997-12-17 00:00:00		2025-05-03 20:50:50.222	2025-05-03 20:50:50.222	\N
b1f6206a-c714-496b-971d-d7d46d04bec2	Miguel Anguel	Luviano Borja		miguel.luviano@avis.com.mx	\N	\N		2025-05-03 20:50:50.222	2025-05-03 20:50:50.222	\N
a1225531-577f-4183-9c45-b0c925526d72	Maria Luisa	Martinez Morales		\N	\N	1949-08-25 00:00:00		2025-05-03 20:50:50.222	2025-05-03 20:50:50.222	\N
844c7c32-0d28-4418-b660-43957af7599f	Marco Antonio	Días Grano		dias66g@hotmail.com	\N	1966-11-11 00:00:00		2025-05-03 20:50:50.223	2025-05-03 20:50:50.223	\N
da5f93b4-4187-4d2c-a1e5-2b6d09e5873e	Luz Maria	Ramirez Ipiales		\N	\N	1982-08-24 00:00:00		2025-05-03 20:50:50.223	2025-05-03 20:50:50.223	\N
a2ffa3e7-3452-4134-b8c1-1505a2ed36bd	Raquel	Yañez Rodríguez		kanory641102@hotmail.ocm	\N	1964-02-02 00:00:00		2025-05-03 20:50:50.223	2025-05-03 20:50:50.223	\N
41755268-35ca-4d25-bc49-36590130a464	Roxana	Delgado		\N	\N	\N		2025-05-03 20:50:50.224	2025-05-03 20:50:50.224	\N
5a7d06c8-5d53-4137-be9e-50eec1139f33	Sergio	Rodriguez		sergio.rdg.sud@hotmail.ocm	\N	1981-06-06 00:00:00		2025-05-03 20:50:50.224	2025-05-03 20:50:50.224	\N
655fd5f4-da81-4276-bbaa-bb1075990e3b	Susan	Cadwell		scaldunpv@gmail.com	\N	\N		2025-05-03 20:50:50.224	2025-05-03 20:50:50.224	\N
5c831b8d-9460-4f79-9670-0c05943f8dc8	Oscar	Contreras Casillas		\N	\N	1986-07-04 00:00:00		2025-05-03 20:50:50.225	2025-05-03 20:50:50.225	\N
f9289556-5f8b-4794-84d1-39fc0a482310	Ofelia	García Juarez		\N	\N	\N		2025-05-03 20:50:50.225	2025-05-03 20:50:50.225	\N
3ec76610-ecdd-4bb9-be9d-959bcad4fad4	Marco Antonio	Nazaret		\N	\N	\N		2025-05-03 20:50:50.225	2025-05-03 20:50:50.225	\N
b2716b15-b120-4635-b203-6333385a062a	Rocio	Estrella Becerril		\N	\N	1956-10-05 00:00:00		2025-05-03 20:50:50.226	2025-05-03 20:50:50.226	\N
fdcd9edb-57b7-4ebd-88af-6c6c88ad3cfa	Maria Magdalena	Baez Jimenez		mbmagdabaez@gmail.com	\N	1977-01-23 00:00:00		2025-05-03 20:50:50.226	2025-05-03 20:50:50.226	\N
a8380cf4-eedd-481b-9964-96c4c5614ace	Salvador Eduardo	Perez Gonzalez		\N	\N	\N		2025-05-03 20:50:50.226	2025-05-03 20:50:50.226	\N
a9c61ca0-8a9b-46f0-bf64-8d4d999a8694	Marcela	Mireles Ceballos		my.marcell@hotmail.com	\N	1977-10-06 00:00:00		2025-05-03 20:50:50.226	2025-05-03 20:50:50.226	\N
3d6e7db7-c01a-44c8-b239-887dd75f6f04	Margarita	Bibiano Reducindo		magobibi@hotmail.com	\N	1963-08-27 00:00:00		2025-05-03 20:50:50.227	2025-05-03 20:50:50.227	\N
cebf70ed-a251-4118-b696-e9861d81cdc8	Ramón	Diaz Meza		ramondias27@hotmail.com	\N	1967-08-27 00:00:00		2025-05-03 20:50:50.227	2025-05-03 20:50:50.227	\N
ac2ab52b-a82f-4d4b-9021-5d437e4d6da6	Mavis	Oliver		\N	\N	1950-07-24 00:00:00		2025-05-03 20:50:50.227	2025-05-03 20:50:50.227	\N
e296fa17-6773-4a96-b55d-44019628ddbe	Maria del Rosario	Rodríguez González		mariposa211179@life.com	\N	1979-11-21 00:00:00		2025-05-03 20:50:50.228	2025-05-03 20:50:50.228	\N
de54c71b-b49b-4f59-8e9b-e4f13857da8d	Marcelino	Lepe Palomera		marcelino_javier@hatmail.com	\N	1981-03-22 00:00:00		2025-05-03 20:50:50.228	2025-05-03 20:50:50.228	\N
e39ce08a-1193-41db-b07f-c9755f3090d4	Maria del Carmén	Contreras García		\N	\N	1973-09-05 00:00:00		2025-05-03 20:50:50.228	2025-05-03 20:50:50.228	\N
0c7d5f50-32a6-4bf7-82d7-0139ed05ff29	Sarahí	Gacía Villa		\N	\N	1994-03-03 00:00:00		2025-05-03 20:50:50.229	2025-05-03 20:50:50.229	\N
5254695b-c87c-4f06-b83a-7f9339f39328	Maria Guadalupe	Preciado López		\N	\N	1952-09-12 00:00:00		2025-05-03 20:50:50.229	2025-05-03 20:50:50.229	\N
ead38e76-3abd-4646-8ffa-733eacc0b4af	Rosa Maria	Meza Arce		elcirculodepaz@homail.com	\N	1961-03-31 00:00:00		2025-05-03 20:50:50.229	2025-05-03 20:50:50.229	\N
c45ba9f1-883a-4caf-a410-a3f3d22bbec0	Vidamaria Fernanda	Valencia Zamora		\N	\N	2000-03-13 00:00:00		2025-05-03 20:50:50.23	2025-05-03 20:50:50.23	\N
79a1033d-bebd-477e-9b9e-89612c848022	María Ascenet	Castañeda Vela		mac10mary@hotmail..com	\N	1965-10-21 00:00:00		2025-05-03 20:50:50.23	2025-05-03 20:50:50.23	\N
77ce4d84-ce62-4fb4-b003-a5910665f9b7	Presiliano	Rodriguez Nuñez		pajarorn18@hotmail.com	\N	1984-09-15 00:00:00		2025-05-03 20:50:50.23	2025-05-03 20:50:50.23	\N
fc53bb94-d64d-4499-89e7-e16e9574bbff	Miryam	Morales Jimenez		\N	\N	1996-02-01 00:00:00		2025-05-03 20:50:50.231	2025-05-03 20:50:50.231	\N
b5d5e804-fd24-4699-9861-9cbec8f3d354	Juana	Garcia Peña		\N	\N	1969-01-10 00:00:00		2025-05-03 20:50:50.231	2025-05-03 20:50:50.231	\N
639bcbac-d9e6-45c6-b238-45b466f48787	Karla Valeria	Guzman Zuñiga		marysan_232@hotmail.com	\N	2006-02-23 00:00:00		2025-05-03 20:50:50.231	2025-05-03 20:50:50.231	\N
aaabdae9-51e5-420a-9cb4-5b6818c5e38c	Martha Genobeba	Guillen Baumgarten		vevitriggs@yahoo.com	\N	1957-05-13 00:00:00		2025-05-03 20:50:50.232	2025-05-03 20:50:50.232	\N
4ac23a68-0bd0-46fa-94c0-cd8dc9ef04e6	Luis	Roméro Mejía		larmruturi@hotmail.com	\N	1970-01-02 00:00:00		2025-05-03 20:50:50.232	2025-05-03 20:50:50.232	\N
2167ddd8-50e2-4d7d-b005-1475e77c6b5d	Mayra Angelica	Lara  Placito		an.placito@gmail.com	\N	1988-12-27 00:00:00		2025-05-03 20:50:50.232	2025-05-03 20:50:50.232	\N
92df36cf-905c-48e5-8dd7-10ac7d40c3dd	Rodolfo	Rios		\N	\N	\N		2025-05-03 20:50:50.232	2025-05-03 20:50:50.232	\N
c14a4ce7-959a-4c52-8340-956705306bdf	Natividad	Rios Rodriguez		\N	\N	1961-09-08 00:00:00		2025-05-03 20:50:50.233	2025-05-03 20:50:50.233	\N
07d029a6-e322-4e80-a857-46e9576b78e9	Mireya	Hernandez García		mireya2215@hotmail.com	\N	1986-04-22 00:00:00		2025-05-03 20:50:50.233	2025-05-03 20:50:50.233	\N
41a7744a-2872-4430-b46a-6f149c54991a	Kevi Alejandro	Estrada Estrada		\N	\N	2005-02-22 00:00:00		2025-05-03 20:50:50.233	2025-05-03 20:50:50.233	\N
1ac242f7-132c-44fa-aec9-b70b770f5539	Lourdes	Torres Barrón		\N	\N	1979-02-11 00:00:00		2025-05-03 20:50:50.234	2025-05-03 20:50:50.234	\N
bceab547-1673-459f-a4fc-eba5ea0b6327	Nayely	Jimenez Gradilla		\N	\N	\N		2025-05-03 20:50:50.234	2025-05-03 20:50:50.234	\N
22182f74-39ce-456e-883a-ef0db73c3f38	Patricia	Moreno Castañeda		abupatita62@hotmail.com	\N	1962-02-24 00:00:00		2025-05-03 20:50:50.234	2025-05-03 20:50:50.234	\N
c9002ee9-3f39-4369-bf22-903323f80180	Manuel	Olarte Michel		manhum@hotmaul.com	\N	1944-06-25 00:00:00		2025-05-03 20:50:50.235	2025-05-03 20:50:50.235	\N
c45efe64-2dce-446c-b150-b9dae8d08135	Julio Cesar	Martinez Alvarado		julio_alvarado5@hotmail.com	\N	1974-08-05 00:00:00		2025-05-03 20:50:50.235	2025-05-03 20:50:50.235	\N
698dff20-343b-4e5c-b49c-d4c52fe35046	Michell	Downed		hattiefilms@gmail.com	\N	1936-02-13 00:00:00		2025-05-03 20:50:50.235	2025-05-03 20:50:50.235	\N
1429c4b3-f327-4744-a300-12a04f0e59d4	Julieta	Aparicio Calixto		\N	\N	1974-07-30 00:00:00		2025-05-03 20:50:50.236	2025-05-03 20:50:50.236	\N
12b40f04-b510-4018-9ce6-1cd4c1c0c172	Sedani	De la Paz Lorenzo		\N	\N	2001-08-11 00:00:00		2025-05-03 20:50:50.236	2025-05-03 20:50:50.236	\N
cb52b4e4-d2a0-4bb8-ac99-9f0287a1d458	Maria de la Luz	Dueñas Ledesma		\N	\N	1952-05-28 00:00:00		2025-05-03 20:50:50.236	2025-05-03 20:50:50.236	\N
de978eca-b431-4e87-bb34-b0d913614328	Maria	Diaz Barajas		\N	\N	1943-03-03 00:00:00		2025-05-03 20:50:50.237	2025-05-03 20:50:50.237	\N
160ad1b9-5964-413b-9442-0e1fd3146c4a	Maria de jesus	Cueto Avalos		\N	\N	1974-02-13 00:00:00		2025-05-03 20:50:50.237	2025-05-03 20:50:50.237	\N
1a8b2b54-1598-4f17-bf52-86357e4f0984	Marissa	Segovia  Acosta		\N	\N	\N		2025-05-03 20:50:50.238	2025-05-03 20:50:50.238	\N
31998491-00c5-449f-97e1-17b3b9b741c0	Tabata	Macias Perez		\N	\N	2007-11-30 00:00:00		2025-05-03 20:50:50.238	2025-05-03 20:50:50.238	\N
d237aea7-af5e-4f3f-87b1-e570f3daf44a	Sayuri Yesenia	Sánchez Solis		\N	\N	1988-04-04 00:00:00		2025-05-03 20:50:50.238	2025-05-03 20:50:50.238	\N
25daee8f-2be9-45be-8bbf-2dc9c451accc	Violeta	Sotelo Casas		violetaborn@hotmail.com	\N	1994-03-13 00:00:00		2025-05-03 20:50:50.239	2025-05-03 20:50:50.239	\N
dfb886e2-a683-42ab-aa26-eb4e1839da4e	Patricia	Sotelo Casas		preguntaleapaty@gmail.com	\N	1997-04-06 00:00:00		2025-05-03 20:50:50.239	2025-05-03 20:50:50.239	\N
2be38631-f0ca-46e5-9b54-5a53ec993841	Urania	Ramos Chavez		\N	\N	1952-08-18 00:00:00		2025-05-03 20:50:50.239	2025-05-03 20:50:50.239	\N
b05a1794-7924-4a50-8362-a70996c9a3d1	Maria de La Luz	Dueña Ledesma		\N	\N	1952-05-28 00:00:00		2025-05-03 20:50:50.24	2025-05-03 20:50:50.24	\N
3d54ad14-a269-4dba-bf29-b73383ebe4e5	Santiago de Jesús	Centeno Ulin		censan10@hotmail.com	\N	1965-08-10 00:00:00		2025-05-03 20:50:50.24	2025-05-03 20:50:50.24	\N
19802e3f-2883-4c16-a3a4-cab0e661cffe	Rodolfo	Dominguez Monrroy		\N	\N	1980-09-07 00:00:00		2025-05-03 20:50:50.24	2025-05-03 20:50:50.24	\N
f6363f1c-d8e4-4002-a4ce-a5011e75809d	Rosina	Covarubias Aguirre		\N	\N	1936-10-18 00:00:00		2025-05-03 20:50:50.24	2025-05-03 20:50:50.24	\N
5a86a7a9-7646-42d1-a724-47197a5a9cd5	Marargarita	Salas Muñoz		\N	\N	\N		2025-05-03 20:50:50.241	2025-05-03 20:50:50.241	\N
8a72954a-7bdd-4a9e-8a7a-d59785045419	Sarai	Garcia Villa		sarahi-gvilla@hotmail.com	\N	1994-03-03 00:00:00		2025-05-03 20:50:50.241	2025-05-03 20:50:50.241	\N
32cd82f6-e5d4-4458-8f70-c999d490cf44	Maria Elena	Moran		\N	\N	1954-01-11 00:00:00		2025-05-03 20:50:50.241	2025-05-03 20:50:50.241	\N
7be3dacd-c4c7-4369-a03a-fce15eb94fc6	Martín	Sedano Aguirre		\N	\N	1965-03-03 00:00:00		2025-05-03 20:50:50.242	2025-05-03 20:50:50.242	\N
8f6dc6ad-838c-4615-b9d4-1ed4a572a649	Raúl	Pluma Perez		\N	3222890769	2007-12-07 00:00:00		2025-05-03 20:50:50.242	2025-05-03 20:50:50.242	\N
031f4351-989b-45a6-994e-cb4342b82e47	Obdulia	Camba Peña		\N	\N	1965-01-12 00:00:00		2025-05-03 20:50:50.242	2025-05-03 20:50:50.242	\N
93111c1d-87e0-41a9-a808-f660c1191977	Reyna	Cristina Guerra		reyna_guerra@live.com.mx	\N	1965-10-31 00:00:00		2025-05-03 20:50:50.243	2025-05-03 20:50:50.243	\N
fac1b62d-72a2-4458-a3b2-e0b003e7de84	Laura Alejandra	Dueñas Mesa		\N	\N	2009-11-04 00:00:00		2025-05-03 20:50:50.243	2025-05-03 20:50:50.243	\N
388971a4-a105-4e8a-a33a-458c1d582030	Maria de Jesus	Lara Colmenares		\N	\N	1966-12-20 00:00:00		2025-05-03 20:50:50.243	2025-05-03 20:50:50.243	\N
4c68d609-eb6a-411e-9b2b-feb365796408	Karina	Pelayo López		karina_pelayo@yahoo.com.mx	\N	1992-12-01 00:00:00		2025-05-03 20:50:50.244	2025-05-03 20:50:50.244	\N
5d70271a-dc5e-4bf2-baca-918e2c9049a2	Maria Cristina	Stone Guerra		reyna_guerra@live.com.mx	\N	2004-05-30 00:00:00		2025-05-03 20:50:50.244	2025-05-03 20:50:50.244	\N
219bad20-06b9-4746-912d-c9d5c8e38bf3	Mirna	Ramos Vargas		miclorava@hotmail.com	\N	1970-04-24 00:00:00		2025-05-03 20:50:50.244	2025-05-03 20:50:50.244	\N
e036fe9a-59ad-487e-b8b6-db0b306a2b8f	Julio Cesar	Villanueva Olivera		jcvillanuevao@hotmail.com	\N	1972-03-29 00:00:00		2025-05-03 20:50:50.245	2025-05-03 20:50:50.245	\N
f7314f6a-17a4-4e95-9f49-b98f0e913d0d	Kevin	Beltran Pinet		atleticosanjose@hotmail.com	\N	1996-07-13 00:00:00		2025-05-03 20:50:50.245	2025-05-03 20:50:50.245	\N
55013c72-b450-4f8a-bde5-830458d59a7a	Maria	Patiño Castillon		\N	\N	1938-06-27 00:00:00		2025-05-03 20:50:50.245	2025-05-03 20:50:50.245	\N
edfa907d-904b-4ec7-950d-719c4a8752a2	Paola	Rodriguez Villalobos		pao_rovi@hotmail.com	\N	1990-04-10 00:00:00		2025-05-03 20:50:50.246	2025-05-03 20:50:50.246	\N
bea53821-d97c-4db2-8f5d-9be7d2a01419	Maria Helena	Andrade Rodriguez		malenylic@hotmail.com	\N	1966-10-26 00:00:00		2025-05-03 20:50:50.246	2025-05-03 20:50:50.246	\N
92021efa-2a90-4404-ba84-aa31d44af10d	Mayra Araceli	Curiel Barajas		mayra23_04@hotmail.com	\N	1985-04-23 00:00:00		2025-05-03 20:50:50.246	2025-05-03 20:50:50.246	\N
429421a6-6ed4-4bdc-a6a6-ba2d533155eb	Julio Cesar	Porras Escobar		jcesarporras@hotmail.com	\N	1972-10-31 00:00:00		2025-05-03 20:50:50.247	2025-05-03 20:50:50.247	\N
04707cce-f551-4218-8641-739ec082e1ef	Julian	Lesama Morales		\N	\N	2001-03-05 00:00:00		2025-05-03 20:50:50.247	2025-05-03 20:50:50.247	\N
a97845da-caec-4997-a10e-bc797867928f	Maria Elena	Bernal  Guzman*-		\N	\N	1936-02-15 00:00:00		2025-05-03 20:50:50.247	2025-05-03 20:50:50.247	\N
f7ad316e-2be4-44b8-a197-8a8c8c2ff898	Yaneri	Avalos Miramontes		yaneriavalos@gmail.com	\N	1978-03-19 00:00:00		2025-05-03 20:50:50.248	2025-05-03 20:50:50.248	\N
28f7c19b-9392-4879-bfc1-f25ae6caf291	Perla	Regla Jimenez		\N	3221225207	1990-07-02 00:00:00		2025-05-03 20:50:50.248	2025-05-03 20:50:50.248	\N
000e2baa-ed05-4dd8-8269-5daf90e05393	Rosario	Contreras Arias		\N	\N	1985-01-05 00:00:00		2025-05-03 20:50:50.248	2025-05-03 20:50:50.248	\N
589a290d-6089-48b2-b892-79376c69084a	Roberto	Girard		\N	\N	\N		2025-05-03 20:50:50.249	2025-05-03 20:50:50.249	\N
d1cf192d-f35f-4da1-bded-3827ac795494	Shadee	Amirani Arellano		mamirani@hotmail.com	\N	2008-04-07 00:00:00		2025-05-03 20:50:50.249	2025-05-03 20:50:50.249	\N
20e82164-d8a2-463d-a327-91969b251b9b	Lilia Brigitte	Macias Ochóa		brigittepkdo@gmail.com	\N	1986-06-30 00:00:00		2025-05-03 20:50:50.249	2025-05-03 20:50:50.249	\N
8661d04d-48fb-42a1-aad9-4a81a5df5028	Persia	Amairani Arellano		mamirani06@hotmail.com	3221088892	2006-11-30 00:00:00		2025-05-03 20:50:50.25	2025-05-03 20:50:50.25	\N
57d4d4f2-39ab-449b-a57d-04bb98f58c58	Yerania	Montero Aguiar		yeraniamontero@hotmail.com	\N	1978-01-21 00:00:00		2025-05-03 20:50:50.25	2025-05-03 20:50:50.25	\N
196f4503-703b-482e-a19f-c727df9bf37f	Judith Karina	Ruelas García		ruelaskari@hotmail.com	\N	1978-09-25 00:00:00		2025-05-03 20:50:50.25	2025-05-03 20:50:50.25	\N
df5c2aa2-31a2-4d2e-b629-ac88b6d37af9	Roberto	García Rosales		j_roberto21@hotmail.com	\N	1979-02-24 00:00:00		2025-05-03 20:50:50.25	2025-05-03 20:50:50.25	\N
d4154ff8-3ef1-44bc-9a2b-86c98eebad15	Marta Beatriz	Moreno Gonzales		martha.moreno2963@hotmail.com	\N	1963-07-29 00:00:00		2025-05-03 20:50:50.251	2025-05-03 20:50:50.251	\N
0d6ead73-e3cb-40cb-ab6d-8d8bf46dfc6e	Juana	Rodríguez García		\N	\N	1950-05-23 00:00:00		2025-05-03 20:50:50.251	2025-05-03 20:50:50.251	\N
e6844bdf-5fb0-43b9-b908-0e40aad842ec	Maria del Rosario	Flores Vera		\N	\N	1979-04-15 00:00:00		2025-05-03 20:50:50.252	2025-05-03 20:50:50.252	\N
b36c8556-a9d4-428d-acda-6cfe691525be	Marta Luz	Rodriguez Nuñes		marta_luz813@hotmail.com	\N	1981-03-03 00:00:00		2025-05-03 20:50:50.252	2025-05-03 20:50:50.252	\N
f0bbbc1e-2690-4806-ba6a-c2fded0fe29e	Martin	Franques Santana		martin.gris@hotmail.com	\N	1966-01-23 00:00:00		2025-05-03 20:50:50.252	2025-05-03 20:50:50.252	\N
b777cfbe-26e5-4695-9f3e-e2eb735007d9	Romulo Leonardo	Luna Ruíz		\N	\N	2007-08-19 00:00:00		2025-05-03 20:50:50.253	2025-05-03 20:50:50.253	\N
c2b6c910-57da-41a9-bcdb-904ad77da0b4	Ricardo	Navarro Lopez		ananavarro15@yahoo.com.mx	\N	1963-12-10 00:00:00		2025-05-03 20:50:50.253	2025-05-03 20:50:50.253	\N
b26fe816-9079-4c8e-9a99-3d8c714924d7	Karina	Montero Hernández		kamohez@hotmail.com	\N	1980-09-20 00:00:00		2025-05-03 20:50:50.253	2025-05-03 20:50:50.253	\N
09927c5a-9cbe-436e-b1db-919c54227e78	Rodolfo	Meda Barraza		medas_rodo@hotmail.com	\N	1993-10-09 00:00:00		2025-05-03 20:50:50.254	2025-05-03 20:50:50.254	\N
86fbae3b-ba71-423d-8c40-e9fbaedc3499	Lourdes Abigail	Cruz Pelayo		\N	\N	1993-04-12 00:00:00		2025-05-03 20:50:50.254	2025-05-03 20:50:50.254	\N
4a681ac3-56dd-4542-8c57-abb69e42da4c	Tania	Cortez Macias		taniavallarta@gmail.com	\N	1977-08-27 00:00:00		2025-05-03 20:50:50.254	2025-05-03 20:50:50.254	\N
46965c18-e520-4315-a180-ea4c11fb2f8d	Patricia	Silva Cortez		paty.sc111@gmailcom	\N	1999-06-04 00:00:00		2025-05-03 20:50:50.255	2025-05-03 20:50:50.255	\N
7b163ec8-325c-4ab0-8a02-a8a7e91a1b1d	Juana	Caballero García		\N	\N	1961-05-06 00:00:00		2025-05-03 20:50:50.255	2025-05-03 20:50:50.255	\N
c43784e9-eda3-46cc-a81d-def783ab93d2	Yessica	Vedoy Briseño		adminpvr@dislac.mx	\N	1981-02-16 00:00:00		2025-05-03 20:50:50.255	2025-05-03 20:50:50.255	\N
f7b9b6f3-10f1-46e9-a641-5ef4115b7f0c	Queren	Gonzales Mesa		kerenxit@hotmail.com	\N	1994-03-09 00:00:00		2025-05-03 20:50:50.256	2025-05-03 20:50:50.256	\N
605f2291-fcb5-4a58-84c6-644eea05e309	Veronica	Famania Sanchez		vero_famania@hotmail.com	\N	1973-10-10 00:00:00		2025-05-03 20:50:50.256	2025-05-03 20:50:50.256	\N
d95f8d92-a98d-4860-83a3-499381cfe018	Maria Guadalupe	Nuñez Peña		\N	\N	1961-12-25 00:00:00		2025-05-03 20:50:50.256	2025-05-03 20:50:50.256	\N
c8725649-4d29-4217-bc91-2a869d9d0a9f	Mirell	Zarazua Elizalde		mirellzarazua@gmail.com	\N	1981-03-20 00:00:00		2025-05-03 20:50:50.257	2025-05-03 20:50:50.257	\N
ec2c0ce0-2cd0-41cd-b782-8d94efb1cd2c	Sandra	Juarez Vargas		\N	\N	1969-05-25 00:00:00		2025-05-03 20:50:50.258	2025-05-03 20:50:50.258	\N
d2837c9b-63cd-4321-93cd-39a3dd2e8d4e	Zeydy	Lorenzo Medina		verdezz@hotmail.com	\N	1991-02-09 00:00:00		2025-05-03 20:50:50.258	2025-05-03 20:50:50.258	\N
4de1736d-96b0-4a61-b635-50ac29c5aa93	Marisa	Plazola Razo		\N	\N	1970-06-12 00:00:00		2025-05-03 20:50:50.258	2025-05-03 20:50:50.258	\N
c2b93b39-b767-439b-ac05-04ca8bfaabc9	Karla Yasbeth	Cerda Chavez		yas.unika@gmail.com	\N	1983-12-26 00:00:00		2025-05-03 20:50:50.259	2025-05-03 20:50:50.259	\N
eced79f7-fbfb-4433-9b0a-d1bd3f15be27	Oscar	Orozco Orozco		orion2k69@gmail.com	\N	1973-03-18 00:00:00		2025-05-03 20:50:50.259	2025-05-03 20:50:50.259	\N
3a586849-eb53-45c1-bd72-d59b7870c1be	María del Rosario	Rodriguez González		mariposa211179@live.com	\N	1979-11-21 00:00:00		2025-05-03 20:50:50.259	2025-05-03 20:50:50.259	\N
0146debd-5b56-4f12-9c6c-d931f1d6724d	Salvador	Fuentes Hedges		sal@pvgeeks.com	\N	1974-07-14 00:00:00		2025-05-03 20:50:50.26	2025-05-03 20:50:50.26	\N
ea84343a-7e83-43dd-825d-7d701b15c0f9	Sergio	Arteaga Rodriguez		\N	\N	1954-12-18 00:00:00		2025-05-03 20:50:50.26	2025-05-03 20:50:50.26	\N
18ef25a7-ac00-4501-8be8-284a8ace33e9	Wendy Leilani	ArcePelayo		leilani_wen88@hotmail.com	\N	1988-12-28 00:00:00		2025-05-03 20:50:50.26	2025-05-03 20:50:50.26	\N
eb57d056-464d-4391-ab2a-18bdff51f743	Mayra Alejandra	Hernández Rivera		mayra_ahr@hotmail.com	\N	1998-08-25 00:00:00		2025-05-03 20:50:50.261	2025-05-03 20:50:50.261	\N
75e439a9-b557-4a55-a6eb-1279d2fea6c6	Noemí	Flóres Gutíerrez		pequeflor1@hotmail.com	\N	1973-09-17 00:00:00		2025-05-03 20:50:50.261	2025-05-03 20:50:50.261	\N
912334b8-468f-40bc-997b-93c18213b9dc	Marco Antonio	Alvarez Palafox		\N	\N	2002-09-29 00:00:00		2025-05-03 20:50:50.261	2025-05-03 20:50:50.261	\N
1347453b-49fa-45b0-a2d2-99c0882cced9	María Cecilia	Ayala Navarro		\N	\N	1946-02-16 00:00:00		2025-05-03 20:50:50.262	2025-05-03 20:50:50.262	\N
5b77428d-48bd-426b-8afd-0689489ee912	Saren Alejandra	Espinoza Perales		sarenperales@hotmail.com	\N	2001-09-22 00:00:00		2025-05-03 20:50:50.262	2025-05-03 20:50:50.262	\N
be5cb9e6-1c03-4663-815b-95a88c7e83ef	Salvador	Zetina Perez		fruteria_esmeralda@hotmail.com	\N	1971-05-23 00:00:00		2025-05-03 20:50:50.262	2025-05-03 20:50:50.262	\N
12202ffa-be4b-4647-a1c8-5ee4a476f332	Urbano	Godoy		rebecas2@prodigy.net.mx	\N	1970-04-27 00:00:00		2025-05-03 20:50:50.263	2025-05-03 20:50:50.263	\N
1e4bec3c-7eb8-4739-a9d8-ea612ae70b51	Rosa Lidia	Echevarria González		rosyechevarria@hotmail.com	3221490597	1972-04-23 00:00:00		2025-05-03 20:50:50.263	2025-05-03 20:50:50.263	\N
6cadcd20-fb55-40f1-b4ee-90d301151a54	Ofelia	Hernández Ibarria		ofeliahernandezi@hotmail.com	\N	1955-04-02 00:00:00		2025-05-03 20:50:50.263	2025-05-03 20:50:50.263	\N
d1191ecc-fe6b-4820-af3a-f171a4449bdd	Solia Rebeca	Alejandre Ascencio		\N	\N	1949-03-08 00:00:00		2025-05-03 20:50:50.264	2025-05-03 20:50:50.264	\N
3b7475f9-dc2b-4acd-81d9-29b631f76994	Leonardo	Luviano Vázquez		leonardo.luviano@gmail.com	\N	1993-08-11 00:00:00		2025-05-03 20:50:50.264	2025-05-03 20:50:50.264	\N
2f9acdb4-20e7-4f2c-8261-4fc3cb8f0e95	Maria Guadalupe	Cordoba  de Anda		\N	\N	1944-06-04 00:00:00		2025-05-03 20:50:50.264	2025-05-03 20:50:50.264	\N
b5a11597-ea80-431f-ac2a-06ee6cf5a538	Maria de los Angeles	Nuñez Peña.		\N	\N	1963-04-20 00:00:00		2025-05-03 20:50:50.265	2025-05-03 20:50:50.265	\N
c9dc6746-4590-44bb-ab44-a2048e8c0e17	Rigoberto	Gutierrez Uribe		pachuco_doriga@hotmail.com	\N	1992-02-24 00:00:00		2025-05-03 20:50:50.265	2025-05-03 20:50:50.265	\N
750706b6-4e06-4b4e-8fd8-ad49457953fc	Norma Adriana	Becerra Arroyo		tartavallarta@gmail.com	\N	1964-01-28 00:00:00		2025-05-03 20:50:50.265	2025-05-03 20:50:50.265	\N
390e169a-f4c8-4bcf-8178-4d6c9069d18c	Sherryl	Olson		sherryolson@hotmail.com.	\N	1961-02-10 00:00:00		2025-05-03 20:50:50.266	2025-05-03 20:50:50.266	\N
bee7f117-c4c9-4ed7-b5d3-44a9aa03c20f	Kimberlin Daniela	LLanos Villareal		\N	\N	1999-07-17 00:00:00		2025-05-03 20:50:50.266	2025-05-03 20:50:50.266	\N
0b510628-4be7-4e4d-90b3-631b7089eb65	Rosa	Rodriguez García		\N	\N	1952-11-09 00:00:00		2025-05-03 20:50:50.266	2025-05-03 20:50:50.266	\N
0514b00f-7f06-46c7-9ea3-2398c6348319	Sasha	Macias Pérez		\N	\N	2012-01-15 00:00:00		2025-05-03 20:50:50.267	2025-05-03 20:50:50.267	\N
d3f54e6a-00fd-4aa0-a8bb-ecd5e3185939	MIguel Angel	Bañuelo Godoy		anaisrg.06@hotmail.com	3227797406	1988-09-01 00:00:00		2025-05-03 20:50:50.267	2025-05-03 20:50:50.267	\N
9641cbd1-4ff4-4554-af49-92aeae6f896d	Susana	Zavala Mendosa		solorzano63@yahoo.com	\N	1963-02-19 00:00:00		2025-05-03 20:50:50.267	2025-05-03 20:50:50.267	\N
228340a2-d1dc-4047-b362-8a1597d53e05	Kevin Yahir	Macedo Venegas		\N	\N	2005-11-25 00:00:00		2025-05-03 20:50:50.268	2025-05-03 20:50:50.268	\N
3b2ce0ae-e154-4a79-bc4f-f7f540636ac2	Mariana Daniela	Herce Estrada		marianaherce@life.com	\N	1993-12-06 00:00:00		2025-05-03 20:50:50.268	2025-05-03 20:50:50.268	\N
aa2f70f7-3e46-46f1-b28f-a0ed8c25d007	Maria del Refugio	Gutierrez Fonseca		\N	\N	1974-06-18 00:00:00		2025-05-03 20:50:50.268	2025-05-03 20:50:50.268	\N
e9a5066c-91a9-47a8-a3f0-533780830c2e	Maria Carmen	Espino Guerrero		ahydee_urrutia@hotmail.com	\N	1953-09-13 00:00:00		2025-05-03 20:50:50.269	2025-05-03 20:50:50.269	\N
0157ccb9-9d6b-4851-88b7-1dbb706b509c	Kenia Miiam	Sanchez Gonzales		sagkenia@gmail.com	\N	1995-08-18 00:00:00		2025-05-03 20:50:50.269	2025-05-03 20:50:50.269	\N
4c8cb4b6-42ee-4261-8299-9e66749e5140	Maria Avelina	Gonzales Salcedo		\N	\N	1951-11-10 00:00:00		2025-05-03 20:50:50.269	2025-05-03 20:50:50.269	\N
8953ff82-c0fb-4b3a-8183-61e594ebac23	Sheila Belem	Vázquez Rodriguez		zheila1016@gmail.com	\N	1992-12-04 00:00:00		2025-05-03 20:50:50.27	2025-05-03 20:50:50.27	\N
0e857808-5df3-4161-8d37-877610a333a1	Lizbeth Yoselin	Arrizon Michelle		lis_suli_@hotmail.com	\N	1998-08-27 00:00:00		2025-05-03 20:50:50.27	2025-05-03 20:50:50.27	\N
a97010d2-141c-4ca7-a535-db1996906825	Ma. de la Luz	Jimenez García		lucyj@cuc.udg.mx	\N	1970-08-10 00:00:00		2025-05-03 20:50:50.27	2025-05-03 20:50:50.27	\N
ba275b0a-6b10-4bba-b4b1-7546d6bdc043	Miguel Angel	Dominguez Mora		migueldmz@gmail.com	\N	1984-11-12 00:00:00		2025-05-03 20:50:50.271	2025-05-03 20:50:50.271	\N
aacf1673-7863-41f3-acd5-1f9ae2ccad26	Mario Adrian	Martinez Becerra		shu.ma0603@gmai.com	\N	1992-03-06 00:00:00		2025-05-03 20:50:50.271	2025-05-03 20:50:50.271	\N
2203e475-5760-4c5a-916f-061937e533f4	Rosa	Alvarez Ruiz		ponchodagnino@hotmail.com	\N	1923-02-17 00:00:00		2025-05-03 20:50:50.271	2025-05-03 20:50:50.271	\N
b9d1007e-a2eb-4076-8707-36c66f915f2f	Ruth	Rubio Aguirre		\N	\N	\N		2025-05-03 20:50:50.272	2025-05-03 20:50:50.272	\N
bdcce5fc-0b5e-422a-8e6b-321e42493dcb	Maria Dalila	Lorenzo Crúz		\N	\N	1989-10-28 00:00:00		2025-05-03 20:50:50.272	2025-05-03 20:50:50.272	\N
6e4c1f37-b98d-4f7f-9647-c9586bfa4f16	Norma Gabriela	Placencia Salado		\N	\N	1977-11-17 00:00:00		2025-05-03 20:50:50.272	2025-05-03 20:50:50.272	\N
f142cbbd-8984-475c-bc61-4cdc84e18c49	Maria de la Luz	Casillas Estrada		david.villalobos@mx.schindler.com	\N	1962-05-18 00:00:00		2025-05-03 20:50:50.273	2025-05-03 20:50:50.273	\N
fca61ec4-4dfa-4151-ba85-b638d67f0fcd	Maria del Socorro	Segura		cocosegura1948@gmail.com	\N	1948-06-27 00:00:00		2025-05-03 20:50:50.273	2025-05-03 20:50:50.273	\N
5ecb6783-8866-4ce4-90e4-960dc1292ae9	Oscar	Tejedo García		oscar.tejed2@gmail.com	\N	1961-12-08 00:00:00		2025-05-03 20:50:50.273	2025-05-03 20:50:50.273	\N
1dd60362-b72b-4085-90f8-695e87acc9c2	Laura	Hurtado Muciño		laurahurtadomucino@gmail.com	\N	1966-02-19 00:00:00		2025-05-03 20:50:50.274	2025-05-03 20:50:50.274	\N
9121f2cb-154f-45a9-8390-fda15d2af849	Mitzi	Llanos Villareal		\N	3221305391	1992-10-02 00:00:00		2025-05-03 20:50:50.274	2025-05-03 20:50:50.274	\N
82c0d557-8e31-4e42-ae0c-d316ace2b5da	Rebeca	Becerra Ramímrez		rebeccabr@hotmail.com	\N	1970-06-07 00:00:00		2025-05-03 20:50:50.274	2025-05-03 20:50:50.274	\N
d6b8987a-bc72-4cd2-94a3-ca525f5d8bd4	Tania Guadalupe	Mendoza Cornejo		tania.mendoza22@hotmail.com	\N	1988-09-20 00:00:00		2025-05-03 20:50:50.275	2025-05-03 20:50:50.275	\N
9b27e6e9-4f96-4cdd-a068-aaeca375df78	Sheila	Allison		shebob@northwestel.net	\N	1956-07-04 00:00:00		2025-05-03 20:50:50.275	2025-05-03 20:50:50.275	\N
a4f27e9b-92ad-4eb6-9111-8af16d38bc66	Maria Elena	Quintero Rubio		\N	\N	1966-07-22 00:00:00		2025-05-03 20:50:50.275	2025-05-03 20:50:50.275	\N
63427d28-df1f-4665-8691-e3576f776171	Maria Dalinda	García Salgado		\N	\N	1974-05-17 00:00:00		2025-05-03 20:50:50.276	2025-05-03 20:50:50.276	\N
8b930af8-3e06-4d14-873d-5ed9e9793ded	Priscila Margarita	Zaragoza Mendía		rebecasvta@hotmail.com	\N	1971-02-20 00:00:00		2025-05-03 20:50:50.276	2025-05-03 20:50:50.276	\N
c8d0090b-ddbc-452f-a032-bfaaa33a35b6	Virginia	Loza Padilla		\N	\N	1959-01-31 00:00:00		2025-05-03 20:50:50.276	2025-05-03 20:50:50.276	\N
735ac92f-8b15-4cb1-be34-7a967094834c	Maria de los Angeles	Santana Amaral		\N	\N	1961-05-09 00:00:00		2025-05-03 20:50:50.276	2025-05-03 20:50:50.276	\N
3a093617-e072-49ce-909c-142adbf1e39f	Maria Dolores	Cuara Legorreta		\N	\N	\N		2025-05-03 20:50:50.277	2025-05-03 20:50:50.277	\N
032c970f-681e-462f-939e-8760eaf35a8e	Olga	Put		olga.pv@british.edu.mx	\N	1980-11-22 00:00:00		2025-05-03 20:50:50.277	2025-05-03 20:50:50.277	\N
46d53013-4e5b-4465-8a29-bf02bbf04940	Maria Guadalupe	Nuñes Peña		\N	\N	\N		2025-05-03 20:50:50.277	2025-05-03 20:50:50.277	\N
328dbf9d-7aeb-4d85-b9d6-07f76ff945aa	Laura Edith	Recendis Rubalcaba		laura.recendis@hotmail.com.	\N	1989-12-06 00:00:00		2025-05-03 20:50:50.278	2025-05-03 20:50:50.278	\N
592279ab-11a8-4635-93a0-c3fce7ccde3d	Mauro	Negrete Rojas		mauronegrete@yahoo.com.mx	3221750026	1981-05-25 00:00:00		2025-05-03 20:50:50.278	2025-05-03 20:50:50.278	\N
5fedd61e-3f79-48e9-8512-2be6946bba00	Victor Mariano	Chavez Preciado		caricaturajr@hotmail.com	\N	1986-11-21 00:00:00		2025-05-03 20:50:50.278	2025-05-03 20:50:50.278	\N
a3885b0e-bb24-42a0-87f8-35d388d14270	Rene	Medina Ramirez		medinaramirezrenee@gmail.com	3222441265	2000-11-02 00:00:00		2025-05-03 20:50:50.279	2025-05-03 20:50:50.279	\N
cd2c8eac-94b3-4edb-80e0-d8097e718851	Luis Manuel	Fonseca Delgado		\N	\N	1980-05-12 00:00:00		2025-05-03 20:50:50.279	2025-05-03 20:50:50.279	\N
fd4a6ac0-3e76-40cd-8a53-1510cc393f1b	Rocio	Recendis Luna		\N	\N	1999-05-24 00:00:00		2025-05-03 20:50:50.279	2025-05-03 20:50:50.279	\N
13a97f7c-f58e-482a-adbe-0b2da015fc75	Martha	Yañez Frias		\N	\N	1960-01-19 00:00:00		2025-05-03 20:50:50.28	2025-05-03 20:50:50.28	\N
2ea2a330-cb67-4f29-939a-427a5ffdbe9d	Terry	Holloway		\N	\N	1941-08-04 00:00:00		2025-05-03 20:50:50.28	2025-05-03 20:50:50.28	\N
c2cb51d9-16b3-4198-85db-21d3a18573d0	Melane	Amato		\N	\N	1965-10-11 00:00:00		2025-05-03 20:50:50.28	2025-05-03 20:50:50.28	\N
a510799d-c97a-44e8-ae1e-5fe9d81a5d6f	Lilian	Ramirez Garcia		\N	\N	\N		2025-05-03 20:50:50.281	2025-05-03 20:50:50.281	\N
706fe43c-5abf-43e3-b657-c4e687c56f52	Karina	Solorio Soto		karina12solorio@hotmail.com	\N	1997-11-08 00:00:00		2025-05-03 20:50:50.281	2025-05-03 20:50:50.281	\N
4b8df4f4-9ab0-4e64-b8d2-c58cbdd29dc2	Maria	Salazar Lopez		\N	\N	1967-03-16 00:00:00		2025-05-03 20:50:50.281	2025-05-03 20:50:50.281	\N
351ec59e-4dc5-4209-a1b1-c20808d05b26	Silvia Vanesa	Mariscal  Viorato		\N	\N	1982-10-11 00:00:00		2025-05-03 20:50:50.282	2025-05-03 20:50:50.282	\N
ee452233-e602-470e-b372-dd6826ce2639	Rocio	Orozco Santiago		\N	\N	1983-09-03 00:00:00		2025-05-03 20:50:50.282	2025-05-03 20:50:50.282	\N
6063a1f9-1806-4409-b00f-8de3cf28f796	Miriam de Jesus	Avitia Beltran		miriamavitia_@msn.com	\N	1968-03-02 00:00:00		2025-05-03 20:50:50.282	2025-05-03 20:50:50.282	\N
27cc1007-7244-450f-a3aa-dafc1ccade52	Paola Saray	Fregoso Cornejo		pao.fregoso.07@gmail.com	\N	1991-11-07 00:00:00		2025-05-03 20:50:50.283	2025-05-03 20:50:50.283	\N
2ee65f2e-4fca-43ad-946f-a38513ca86af	Yadira	Gonzalez Valadez		yadisss@hotmail.com	\N	1982-02-15 00:00:00		2025-05-03 20:50:50.283	2025-05-03 20:50:50.283	\N
c836d453-83a1-4302-82ff-10efd5065c1d	Karla Valeria	Flores Meza		\N	\N	2003-01-08 00:00:00		2025-05-03 20:50:50.283	2025-05-03 20:50:50.283	\N
ca259c4e-3652-4dc8-bb45-4b1f7fddd028	Luis	Robles Lopez		\N	3227797433	1969-03-14 00:00:00		2025-05-03 20:50:50.284	2025-05-03 20:50:50.284	\N
165c80a1-4c7e-4ad5-88a1-034c308bb4c9	Matilde	Reynoso Palomera		\N	\N	1966-05-28 00:00:00		2025-05-03 20:50:50.284	2025-05-03 20:50:50.284	\N
7e1c1ff4-c6ed-4d03-8889-9b985053f77f	Kevin Alexis	Santana Galiana		\N	\N	1996-11-03 00:00:00		2025-05-03 20:50:50.284	2025-05-03 20:50:50.284	\N
98f9bd1f-478a-4dbc-b333-6fa3bcb6d417	Pilar	Malo Villasante		pilar_labradores@hotmail.com	\N	1997-04-02 00:00:00		2025-05-03 20:50:50.284	2025-05-03 20:50:50.284	\N
585038b7-085a-47f9-bef7-8c702463df90	Saul	Bernal Licea		ulsapv@gmail.com	3221689415	1979-01-09 00:00:00		2025-05-03 20:50:50.285	2025-05-03 20:50:50.285	\N
c882b811-8e6a-4067-bf6a-c7bfcd9ca0e6	Maria Fernanda	EstradaLorenzo		dalaila89@gmail.com	\N	2012-05-22 00:00:00		2025-05-03 20:50:50.285	2025-05-03 20:50:50.285	\N
ebe26cb7-ef6b-42a3-816d-ea01703f6cf9	Pedro	Ramirez Padilla		jiram-mr@hotmail.com	\N	1929-07-01 00:00:00		2025-05-03 20:50:50.285	2025-05-03 20:50:50.285	\N
53286c34-57e8-482a-99a9-687a9b98e5b7	Tatjana	Hass		tatjanah@yahoo.com	\N	1968-09-21 00:00:00		2025-05-03 20:50:50.286	2025-05-03 20:50:50.286	\N
e69fe736-e110-4222-839d-4be50a42f711	Juan Manuel	Orozco Aguilera		\N	3221167610	1999-08-27 00:00:00		2025-05-03 20:50:50.286	2025-05-03 20:50:50.286	\N
14ff141d-1b23-4f69-bac3-9d9e7477bbcc	Rocio	Suarez Calvillo		\N	\N	1984-01-25 00:00:00		2025-05-03 20:50:50.286	2025-05-03 20:50:50.286	\N
956699ca-c1a6-45f3-b1db-9b6790673fc2	Matias Rigoberto	Ruiz Avila		\N	\N	2011-05-25 00:00:00		2025-05-03 20:50:50.287	2025-05-03 20:50:50.287	\N
e55529a2-9c91-487a-8fd7-fb40121b6a86	Ramiro	Partida Gonzales		\N	\N	1955-03-11 00:00:00		2025-05-03 20:50:50.287	2025-05-03 20:50:50.287	\N
db4ab32d-7008-4832-a5c8-8852bc745702	Regina	Dorantes Gutierrez		\N	\N	2004-05-21 00:00:00		2025-05-03 20:50:50.287	2025-05-03 20:50:50.287	\N
7dee439c-3f19-4df0-afd2-2fc40f24bd87	Marisol	Romero Mejia		\N	\N	1980-04-14 00:00:00		2025-05-03 20:50:50.288	2025-05-03 20:50:50.288	\N
6d309468-9c0e-45e5-934b-2738a16dcc01	Zeferino	Ramírez Orózco		\N	\N	1981-10-24 00:00:00		2025-05-03 20:50:50.288	2025-05-03 20:50:50.288	\N
2f706c1a-d47d-4ce8-9bee-fd3b2800d25b	Micaela Braulia	Mariche Vázquez		\N	\N	1960-03-26 00:00:00		2025-05-03 20:50:50.288	2025-05-03 20:50:50.288	\N
d3c97a3d-3c76-4133-8c62-67d047c3b23b	Raul	Mora Razo		raul.tsapixo@gmail.com	\N	1985-03-27 00:00:00		2025-05-03 20:50:50.288	2025-05-03 20:50:50.288	\N
6bd8f891-e971-4f6b-acce-3a81a76454e1	Omar	Villa Michell		\N	\N	1974-10-10 00:00:00		2025-05-03 20:50:50.289	2025-05-03 20:50:50.289	\N
9e647982-a830-4b6e-bf05-e2143f04dbd0	Juana	Fregoso Sanchez		\N	\N	1953-01-10 00:00:00		2025-05-03 20:50:50.289	2025-05-03 20:50:50.289	\N
219cb47f-70e4-427c-90e7-78c688b24806	Walter	Ramos Aceves		acm-pv@live.com	\N	1983-01-25 00:00:00		2025-05-03 20:50:50.289	2025-05-03 20:50:50.289	\N
87a4f18b-f98e-4137-8e21-dbf5429ed2c4	Lucia	Gómez Martínez		\N	\N	1956-06-20 00:00:00		2025-05-03 20:50:50.29	2025-05-03 20:50:50.29	\N
083c0dd6-242c-4cc4-9f29-e289d70a4973	Perla Angelica	Pelayo Colmenares		agustinpelayo2006@hotmail.com	\N	2001-02-02 00:00:00		2025-05-03 20:50:50.29	2025-05-03 20:50:50.29	\N
b7aca260-9673-4337-b977-9b0d059b582e	Nayeli	Campos Cisneros		hdzjuancarlos@hotmail.es	\N	1987-12-29 00:00:00		2025-05-03 20:50:50.29	2025-05-03 20:50:50.29	\N
ec53198b-e138-460f-b4b7-4b264e1ccefa	Sergio	Gomez Rodriguez		ays1610@gmail.com	\N	1979-07-06 00:00:00		2025-05-03 20:50:50.291	2025-05-03 20:50:50.291	\N
47c71d8d-e8e4-483b-8f87-cfec1600ebda	Victoria Marlen	Patrón Zepeda		marpatron@live.com.mx	\N	1980-03-12 00:00:00		2025-05-03 20:50:50.291	2025-05-03 20:50:50.291	\N
15382543-df64-4aad-bb5b-6a6284321c4b	Salvador	Moran Chavez		\N	\N	1961-09-11 00:00:00		2025-05-03 20:50:50.291	2025-05-03 20:50:50.291	\N
f52c74da-7a8b-44a2-bf63-a6c6f50446d7	Lucina	Hernandez Miranda		\N	\N	\N		2025-05-03 20:50:50.292	2025-05-03 20:50:50.292	\N
e7b39a97-7d55-4159-9cda-1a3417e26177	Julieta Cristina	Guerrero Villegas		julygro85@gmail.com	\N	1985-09-05 00:00:00		2025-05-03 20:50:50.292	2025-05-03 20:50:50.292	\N
7099c9c5-2f60-4bbb-8ce9-0a2d5043a666	Julieta	Villegas Sierra		july40564@hotmail.com	\N	1964-04-05 00:00:00		2025-05-03 20:50:50.292	2025-05-03 20:50:50.292	\N
2784ce8e-fea0-4f4c-b295-0e8971cab2b2	Nayely	Gonzalez Esparza		buceriaslaboral@hotmail.com	\N	1983-05-10 00:00:00		2025-05-03 20:50:50.293	2025-05-03 20:50:50.293	\N
25097d6d-a661-4c40-9117-61e709145062	Raúl	Segura Morales		raulseguramorales@hotmail.com	\N	1950-02-22 00:00:00		2025-05-03 20:50:50.293	2025-05-03 20:50:50.293	\N
31e9d4b9-7edb-4041-b022-85912aeffab5	Miguel Angel	Alonzo Villa		rmsahara@hotmail.com	\N	1978-05-07 00:00:00		2025-05-03 20:50:50.293	2025-05-03 20:50:50.293	\N
91438f18-6623-4645-b465-c1a65b9864cd	Mayte Guadalupe	Henaine  Vizcarra		\N	\N	2010-08-30 00:00:00		2025-05-03 20:50:50.293	2025-05-03 20:50:50.293	\N
ba2a7e37-cbc7-4fa2-b14b-44b276c329dd	Maria del Refugio	Ruelas Ramos		\N	\N	1963-03-27 00:00:00		2025-05-03 20:50:50.294	2025-05-03 20:50:50.294	\N
664c8c52-9c7e-4a86-a165-08081b62d9c3	Livier	Huerta Aguirre		\N	\N	1963-01-15 00:00:00		2025-05-03 20:50:50.294	2025-05-03 20:50:50.294	\N
3aed3301-7d48-44da-9450-d081b59e1b63	Paulina	Guzman Pichardo		\N	\N	2008-11-29 00:00:00		2025-05-03 20:50:50.295	2025-05-03 20:50:50.295	\N
5d6e4a09-7f58-42ae-878a-34f842f6982d	Rosa Estela	Ahumada González		d_dossi@hotmail.com	3221509858	1981-07-11 00:00:00		2025-05-03 20:50:50.295	2025-05-03 20:50:50.295	\N
011c3580-db83-46aa-a41e-d18e75a74584	Maria Ines	Sandoval Perez		inessandoval.1233@gmail.com	\N	1986-02-18 00:00:00		2025-05-03 20:50:50.295	2025-05-03 20:50:50.295	\N
8438a99a-d8c9-448e-9145-2460da5ae9cc	Maria Mercedez	Almaraz Díaz		\N	\N	1970-09-23 00:00:00		2025-05-03 20:50:50.295	2025-05-03 20:50:50.295	\N
097831e0-3c30-4cf9-84a9-45bd5c5fdcc3	Lilia Angelica	Gonzales Ornelas		\N	\N	1974-12-06 00:00:00		2025-05-03 20:50:50.296	2025-05-03 20:50:50.296	\N
6c97216f-462e-4131-bca0-dc546b3a921a	Sara	Ochoa  Chavez		sarapao2000@gmail.com	\N	2000-10-03 00:00:00		2025-05-03 20:50:50.296	2025-05-03 20:50:50.296	\N
4db50ccb-267f-4486-99f0-42047b156c0e	Thierry	Darmon		thierry.darmon@orange.fr	\N	1968-08-05 00:00:00		2025-05-03 20:50:50.296	2025-05-03 20:50:50.296	\N
fa94fa36-4df1-4562-98f4-dc73a3549753	Sarahi	Mendoza Sandoval		mendozasarahi21@gmail.com	\N	1993-09-21 00:00:00		2025-05-03 20:50:50.297	2025-05-03 20:50:50.297	\N
e6729440-2f04-4c01-96f1-131803cf8890	Teresa	Sanchez Ramos		\N	\N	1978-01-07 00:00:00		2025-05-03 20:50:50.297	2025-05-03 20:50:50.297	\N
82f3a860-cf65-4484-89b2-7d97f62b44ae	Mari Trini	Mesa		sotochaibez@hotmail.com	\N	1980-04-30 00:00:00		2025-05-03 20:50:50.297	2025-05-03 20:50:50.297	\N
53ab1f58-c35c-475e-9231-88756aebddd0	Maria Josefina	Briseño Curiel		marijosebriseno@hotmail.com	\N	2001-05-10 00:00:00		2025-05-03 20:50:50.298	2025-05-03 20:50:50.298	\N
0db0ed8a-31a2-45ee-bae5-1c4108f240dd	Maria Diana	García de Orozco		\N	\N	1958-01-01 00:00:00		2025-05-03 20:50:50.298	2025-05-03 20:50:50.298	\N
936bcd6f-b8ea-4d47-92d7-6294bdbaf237	Norma	Martínez Castro		normamc0321@hotmail.com	3221382111	1962-03-22 00:00:00		2025-05-03 20:50:50.298	2025-05-03 20:50:50.298	\N
2948d6be-08c6-4efe-a85e-9bae0456e358	Kenia Edith	Peña Davila		\N	\N	1993-11-09 00:00:00		2025-05-03 20:50:50.299	2025-05-03 20:50:50.299	\N
6c2e0e69-99d2-4476-b8db-65c51c2bfcb8	Victoria Elizabeth	Gonzales Ramirez		\N	\N	1989-11-08 00:00:00		2025-05-03 20:50:50.299	2025-05-03 20:50:50.299	\N
a2f5be64-7bdf-44b3-b3b5-df318a9cd50e	Maria Fernanda	Jimenez  Cendon		marifer1608@hotmail.com	\N	2002-07-16 00:00:00		2025-05-03 20:50:50.299	2025-05-03 20:50:50.299	\N
5b53907b-7a55-4850-b1ba-1dec842bf6e3	Luis  Fernando	Avelar Mondragon		cruz_mafer@hotmail.com	\N	1971-06-22 00:00:00		2025-05-03 20:50:50.3	2025-05-03 20:50:50.3	\N
b702032d-eba7-44a1-b4c2-aea16207738c	Teresa	Jimenez Gutierrez		terejgtz16@gmail.com	\N	1996-01-16 00:00:00		2025-05-03 20:50:50.3	2025-05-03 20:50:50.3	\N
db4e1444-255c-42d7-bd8b-ff67cef6c307	Norma	Mendiola Nonato		\N	\N	1974-04-12 00:00:00		2025-05-03 20:50:50.3	2025-05-03 20:50:50.3	\N
c5d033ac-6c5c-4896-9ba4-5db33073b7c9	Rafael	Beas Salas		\N	\N	1946-10-24 00:00:00		2025-05-03 20:50:50.301	2025-05-03 20:50:50.301	\N
a8e7f39d-e743-48f6-94d9-6b4dd36aa051	Lucia	Palomares Preciado		\N	\N	1963-01-11 00:00:00		2025-05-03 20:50:50.301	2025-05-03 20:50:50.301	\N
1bb5f26a-1cc5-4d2f-b677-7b89b8b70b1b	Susana	Monroy García		sussy.monroy@yahoo.com	\N	1987-11-22 00:00:00		2025-05-03 20:50:50.301	2025-05-03 20:50:50.301	\N
2be99947-18da-4e8a-8420-1defa09c06dc	Zury Saday	Rodriguez Alvarez		zurisaday85ra@hotmail.com	\N	1985-04-10 00:00:00		2025-05-03 20:50:50.302	2025-05-03 20:50:50.302	\N
f2e06256-8031-40bb-853c-fbc34a5bc9a7	Luis Aldo	Lopez Lopez		\N	\N	2010-05-21 00:00:00		2025-05-03 20:50:50.302	2025-05-03 20:50:50.302	\N
23677916-6c7f-427b-a5d1-b086a2f6de35	Livier	Barragan  Quintero		\N	3222000447	\N		2025-05-03 20:50:50.302	2025-05-03 20:50:50.302	\N
3903d563-fe4a-471e-8d7c-20d706857070	Maya	Peréz Román		\N	\N	1993-09-03 00:00:00		2025-05-03 20:50:50.302	2025-05-03 20:50:50.302	\N
50a6f6bb-f2c3-44ff-9f2a-1f55e547bedd	Maria Rufina	Mota Hernandez		\N	\N	1966-07-19 00:00:00		2025-05-03 20:50:50.303	2025-05-03 20:50:50.303	\N
e2874d03-33b8-4cb8-b455-03e2127d9579	Mario Santiago	Silva Toscano		BOBGOOFY@HOTMAIL.COM	\N	2012-07-25 00:00:00		2025-05-03 20:50:50.303	2025-05-03 20:50:50.303	\N
637b7df8-f91a-4d4a-8600-b7ef2b8277d3	Luna Isabela	Vazques Arellano		mary.designe37@gmail.com	\N	2014-05-17 00:00:00		2025-05-03 20:50:50.303	2025-05-03 20:50:50.303	\N
a29e7bb5-b08e-41d8-9ed9-5de0246a2657	Mayra	Ramirez		\N	\N	1975-12-25 00:00:00		2025-05-03 20:50:50.304	2025-05-03 20:50:50.304	\N
fbeeba9e-c945-410f-9951-8d6057efb72d	Ramona	Gutierrez Torres		\N	\N	1939-10-13 00:00:00		2025-05-03 20:50:50.304	2025-05-03 20:50:50.304	\N
5305a5c7-baf7-499c-b2e4-3024017a76c6	Rigoberto	Zepeda Padilla		\N	\N	1947-01-01 00:00:00		2025-05-03 20:50:50.304	2025-05-03 20:50:50.304	\N
7dd262e1-aa31-4407-944e-fa7b5aee1679	Mia Aim	Uribe de Jesus		\N	\N	2007-05-19 00:00:00		2025-05-03 20:50:50.305	2025-05-03 20:50:50.305	\N
a3ea24f6-3ba4-45a6-9dfc-c9e15483408d	Rafaela	Villagrana Ramirez		\N	\N	1959-05-16 00:00:00		2025-05-03 20:50:50.305	2025-05-03 20:50:50.305	\N
90e3637d-79a3-4e73-a1e7-32e40dd32693	Maria Magdalena	Machuca Busto		\N	\N	2007-06-23 00:00:00		2025-05-03 20:50:50.305	2025-05-03 20:50:50.305	\N
c7349a0a-b70b-4a66-8e4a-6e9ecb6676ee	Myriam Abigail	Martínez Mendez		miyi146169@gmail.com	\N	1961-01-14 00:00:00		2025-05-03 20:50:50.306	2025-05-03 20:50:50.306	\N
fa21019b-570a-4488-900f-38907a642a8d	Monica	Guadarrama Soto		monyguadarramasoto4576@gmail.com	\N	1976-05-04 00:00:00		2025-05-03 20:50:50.306	2025-05-03 20:50:50.306	\N
f34d3441-be21-4a05-9504-bb8f26c47c4b	Sabrina	Leyva Ruelas		\N	\N	1970-09-04 00:00:00		2025-05-03 20:50:50.306	2025-05-03 20:50:50.306	\N
7975934b-0dc5-4de2-aab4-5b021b92c1fa	Margart	Brough		\N	\N	1957-04-28 00:00:00		2025-05-03 20:50:50.307	2025-05-03 20:50:50.307	\N
2471229b-c0be-409a-a86c-2f680eae8cfb	Sofia	Medina García		taehyung.010997@gmail.com	\N	2002-12-05 00:00:00		2025-05-03 20:50:50.307	2025-05-03 20:50:50.307	\N
5384b0ee-124d-4408-bdf5-aa53193f4ecc	Maria Hortencia	Ponce Virgen		\N	\N	1961-11-03 00:00:00		2025-05-03 20:50:50.307	2025-05-03 20:50:50.307	\N
c30e29e4-5a8d-45bb-88b8-3b09328795bd	Oscar	Pacheco LeRoy		premiertitan@aul.com	\N	1951-04-20 00:00:00		2025-05-03 20:50:50.308	2025-05-03 20:50:50.308	\N
04cad002-f088-4ce1-9da4-30e96e8c1cb6	Susan	Fernandez Casillas		denilu_poncho@hotmail.com	\N	1982-04-13 00:00:00		2025-05-03 20:50:50.308	2025-05-03 20:50:50.308	\N
15a42720-034d-4717-9392-fa2a42cf0916	Norma	Valencia		\N	3222900224	1967-06-24 00:00:00		2025-05-03 20:50:50.309	2025-05-03 20:50:50.309	\N
214c1577-e1a0-4778-83e7-41cbbb98b720	Luis Enrrique	Arechiga Lopez		\N	3221119045	2011-05-04 00:00:00		2025-05-03 20:50:50.309	2025-05-03 20:50:50.309	\N
cba2d7b6-979f-4528-b2ca-f6a565649ec3	Maria	Galindo Verdin		\N	\N	1960-01-19 00:00:00		2025-05-03 20:50:50.309	2025-05-03 20:50:50.309	\N
2d54c908-d053-45be-8ae3-d59982a32e00	Marcel	Dupoint		\N	\N	1950-01-09 00:00:00		2025-05-03 20:50:50.31	2025-05-03 20:50:50.31	\N
a4e76bc7-367b-457e-8bc9-a3ec9ed0b718	Karen Nairobi	Calvillo López		kenia@banderasproterty.com	\N	2016-01-13 00:00:00		2025-05-03 20:50:50.31	2025-05-03 20:50:50.31	\N
a9fbbafb-a777-4bb2-a5c0-c83c40eb5ec2	Sofia Renata	Bañuelos Rubio		\N	\N	2009-09-16 00:00:00		2025-05-03 20:50:50.31	2025-05-03 20:50:50.31	\N
0a688ea2-a39f-46ee-a1be-db9a8807b551	Ruben	Gomez Espinoza		rubgomezes@gmail.com	\N	1990-09-05 00:00:00		2025-05-03 20:50:50.311	2025-05-03 20:50:50.311	\N
39846229-814a-486d-bf3e-5b772d3b721b	Maria de Jesus	Cubillos Moreno		majcubmor@gmail.com	\N	1987-08-27 00:00:00		2025-05-03 20:50:50.311	2025-05-03 20:50:50.311	\N
3dc575d8-5822-48ed-89db-c9c699d40f00	Paul	Martson		\N	+14156025880	1969-11-11 00:00:00		2025-05-03 20:50:50.311	2025-05-03 20:50:50.311	\N
94767caa-e65f-4eae-8805-8a9652a5ff2d	Maria Luisa	Cibrian Bravo		\N	\N	1956-08-09 00:00:00		2025-05-03 20:50:50.312	2025-05-03 20:50:50.312	\N
f62a5efb-8f0e-4aae-9953-6dcc95c8396c	Roberto	Medina García		\N	3221085415	2005-11-24 00:00:00		2025-05-03 20:50:50.312	2025-05-03 20:50:50.312	\N
600dbc4e-7268-4a51-bcb2-8e8818b5ae87	Mara Beatriz	García Escalante		mara@mundofiscal.com	\N	\N		2025-05-03 20:50:50.312	2025-05-03 20:50:50.312	\N
77dbac5d-e733-42b2-94c4-62ffbfadadba	Marcos	Perez Peñalosa		\N	\N	1965-03-19 00:00:00		2025-05-03 20:50:50.313	2025-05-03 20:50:50.313	\N
49a72188-13b6-4702-a4df-e879caaa7906	Marlon Saí	Mora Alvarado		\N	\N	2013-08-27 00:00:00		2025-05-03 20:50:50.313	2025-05-03 20:50:50.313	\N
c17a93b1-ed91-4705-9c48-71ecc24fdbe5	Octavio Armando	Becera Loza		octaviobecerra@hotmail.ocm	\N	1967-01-16 00:00:00		2025-05-03 20:50:50.313	2025-05-03 20:50:50.313	\N
3cdb605b-99eb-4237-b068-bc86c20f0380	Marìa Dolores	Espinoza Franco		\N	015929220530	2003-12-20 00:00:00		2025-05-03 20:50:50.314	2025-05-03 20:50:50.314	\N
e24d0a6d-5c72-41d5-82fd-0b319802b0b8	Luis Fernando	Azcanio Zaldivar		\N	\N	2004-08-31 00:00:00		2025-05-03 20:50:50.314	2025-05-03 20:50:50.314	\N
60a74c6d-06b7-48c7-ae8d-1fa816dc8b5d	Julio Cesar	Galdames de la Cruz		\N	0445591082010	2005-03-31 00:00:00		2025-05-03 20:50:50.314	2025-05-03 20:50:50.314	\N
642bc8f3-0c39-437f-b5e6-b315fb2952ba	Leticia	Alvarado Zabala		\N	0445520676766	2005-06-04 00:00:00		2025-05-03 20:50:50.315	2025-05-03 20:50:50.315	\N
ff4c4cad-b5c9-4e6a-ad64-031612b69bee	Socorro	Ornelas Lomeli		\N	\N	2005-07-27 00:00:00		2025-05-03 20:50:50.315	2025-05-03 20:50:50.315	\N
922ecde7-7399-405d-8979-feed626f397c	Miguel Anguel	Piña Carbajal		\N	\N	2005-07-29 00:00:00		2025-05-03 20:50:50.315	2025-05-03 20:50:50.315	\N
392f32ed-402f-4791-b72d-1ab64bc40ef5	Soledad	Carbajal Tejes		\N	\N	2005-07-29 00:00:00		2025-05-03 20:50:50.316	2025-05-03 20:50:50.316	\N
dcb43a20-abf8-446f-8b8e-990cfd3bace0	Ruben	Hernandez Monterrubio		\N	\N	2005-09-22 00:00:00		2025-05-03 20:50:50.316	2025-05-03 20:50:50.316	\N
71fb597b-2318-4078-bc8b-afb1d9daea99	Monica	Marquez Paulin		\N	\N	2005-09-22 00:00:00		2025-05-03 20:50:50.316	2025-05-03 20:50:50.316	\N
c81697c2-d138-4e97-af65-dc09cc4c2194	Margot Azucena	Balice Olgin		\N	\N	2005-09-22 00:00:00		2025-05-03 20:50:50.317	2025-05-03 20:50:50.317	\N
082cf75b-c690-4fea-b24f-1a9936bd88ae	Marcelino	Martinez Ortega		\N	\N	2005-09-23 00:00:00		2025-05-03 20:50:50.317	2025-05-03 20:50:50.317	\N
91fb68cb-ceef-4983-9a33-7253f1e270c6	Maria del Rocio	Martínez García		\N	\N	2005-10-05 00:00:00		2025-05-03 20:50:50.317	2025-05-03 20:50:50.317	\N
1fda9b72-fd67-468e-91b7-1127025b7ae9	Sugey	Hernández García.		\N	\N	2005-10-11 00:00:00		2025-05-03 20:50:50.318	2025-05-03 20:50:50.318	\N
b1538a95-5c09-40bc-85a1-2d120a6dcb42	leo	gonzales mtz		\N	\N	2005-11-30 00:00:00		2025-05-03 20:50:50.318	2025-05-03 20:50:50.318	\N
ca0e1edf-6f16-46f6-92a4-72763a16cced	Raul	Arroyo Garcìa		\N	\N	1960-05-07 00:00:00		2025-05-03 20:50:50.318	2025-05-03 20:50:50.318	\N
7dc6297d-9215-42f9-b904-057c0b4b5eb6	Leslie	Salcedo moreno		\N	\N	2006-03-03 00:00:00		2025-05-03 20:50:50.318	2025-05-03 20:50:50.318	\N
11ec1ba7-de9d-4662-892f-94fd5be61a6e	mario	no se sabe		\N	\N	2006-03-09 00:00:00		2025-05-03 20:50:50.319	2025-05-03 20:50:50.319	\N
aa2ae59f-f42b-49d5-a173-b1a73b1793f3	mario	mario		\N	\N	2006-03-09 00:00:00		2025-05-03 20:50:50.319	2025-05-03 20:50:50.319	\N
8be9fb5a-b7d3-4910-8da7-9ed2944881d8	mario	primera vez		\N	\N	2006-03-09 00:00:00		2025-05-03 20:50:50.319	2025-05-03 20:50:50.319	\N
ce717ecb-2623-4e2c-86f0-56b52da1c17e	Mariano	García Bermudes		\N	\N	2006-03-14 00:00:00		2025-05-03 20:50:50.32	2025-05-03 20:50:50.32	\N
00032508-ecfb-4229-b523-be68d10d23e5	Monica	Angeles Cervantes		\N	\N	2006-03-17 00:00:00		2025-05-03 20:50:50.32	2025-05-03 20:50:50.32	\N
d071f5f6-d277-4411-927f-a0b827b37459	Yasmín	Verdusco Alanis		\N	\N	2006-03-24 00:00:00		2025-05-03 20:50:50.32	2025-05-03 20:50:50.32	\N
e3e74c69-d035-4a59-97d7-350732ec5c82	Miguel Angel	Aguilar Gomez		mikememov2000@hotmail.com	\N	1984-03-06 00:00:00		2025-05-03 20:50:50.321	2025-05-03 20:50:50.321	\N
b2bbf632-0d0f-4983-842f-b1c757629e9e	Mariana	Estudillo García		\N	\N	2006-03-29 00:00:00		2025-05-03 20:50:50.321	2025-05-03 20:50:50.321	\N
34a2e209-799b-4bef-bc1c-d9482cd7c2d7	Roxana	Montes Huerta		\N	\N	2006-03-29 00:00:00		2025-05-03 20:50:50.321	2025-05-03 20:50:50.321	\N
b24a7fff-cec7-464d-928f-cf20e262b372	Nadxieli	Flores Salinas		\N	\N	2006-04-04 00:00:00		2025-05-03 20:50:50.322	2025-05-03 20:50:50.322	\N
4e8690e1-9982-4a4f-8340-7bfa1b1d1bcf	Ma. del Valle	Maza		\N	\N	2006-04-19 00:00:00		2025-05-03 20:50:50.322	2025-05-03 20:50:50.322	\N
f406e23a-fac2-4945-a57b-3b1cf50f5c6f	Ulises	Cervantes Acosta		\N	\N	2006-04-25 00:00:00		2025-05-03 20:50:50.322	2025-05-03 20:50:50.322	\N
10161989-1e30-4d1b-98c8-efad9396b04a	Seferina	Muñoz Peralta		\N	\N	2006-06-02 00:00:00		2025-05-03 20:50:50.323	2025-05-03 20:50:50.323	\N
738bd96a-74e4-425c-af16-f710f86735b9	Rufino	Vargas Avantes		\N	\N	2006-06-19 00:00:00		2025-05-03 20:50:50.323	2025-05-03 20:50:50.323	\N
9b2f464a-eb3c-48f4-950e-2c7346057666	Ursula	Mariscal Vargas		\N	\N	2006-06-20 00:00:00		2025-05-03 20:50:50.324	2025-05-03 20:50:50.324	\N
fc2d465b-eab5-4f3c-8393-951b45ab631b	Ruben Antonio	Cervantes García		\N	\N	2006-06-22 00:00:00		2025-05-03 20:50:50.324	2025-05-03 20:50:50.324	\N
5f25e750-2d46-42ab-9b97-214a2c8b860c	Ruben	Cervantes Rojas		\N	\N	2006-06-29 00:00:00		2025-05-03 20:50:50.324	2025-05-03 20:50:50.324	\N
943c1a0a-48de-43e9-bcb0-327390b750fb	Juan Manuel	Grey Parra		\N	\N	2006-07-10 00:00:00		2025-05-03 20:50:50.324	2025-05-03 20:50:50.324	\N
46409308-ce68-43cf-b21d-2dd2f41ae16e	Roberto	Morales Ruiz Adame		\N	\N	2006-07-13 00:00:00		2025-05-03 20:50:50.325	2025-05-03 20:50:50.325	\N
c1c03fdc-a6da-456a-a417-e2cbb5b4676e	Salvador	Camacho Medina		\N	\N	2006-07-20 00:00:00		2025-05-03 20:50:50.325	2025-05-03 20:50:50.325	\N
610cbff9-a11b-4a8c-a315-afa4e4dae3f4	Juana	Monterrubio Valdes		\N	\N	2006-07-27 00:00:00		2025-05-03 20:50:50.325	2025-05-03 20:50:50.325	\N
2b5642eb-cdf8-4d84-b37d-6c39ba687b59	Silvia	Guerrero lopez		\N	\N	2006-07-31 00:00:00		2025-05-03 20:50:50.326	2025-05-03 20:50:50.326	\N
6e85ef66-de57-44f4-a984-8bd08d2bf4d9	Paola	Ortega Hernandez Santarriaga		\N	\N	2006-08-05 00:00:00		2025-05-03 20:50:50.326	2025-05-03 20:50:50.326	\N
47c4200e-dd77-452e-95f6-da53df513990	Mariano	Garciá Lona		\N	\N	2006-08-16 00:00:00		2025-05-03 20:50:50.326	2025-05-03 20:50:50.326	\N
f62d52d4-9e7b-4a91-9784-924f56b483c6	Ruben	Hernandez de la Garza		\N	\N	2006-08-22 00:00:00		2025-05-03 20:50:50.327	2025-05-03 20:50:50.327	\N
228a7d24-c018-4759-a493-0df7d4c63ddf	Juana Maria	Noe calderon		\N	\N	2006-09-21 00:00:00		2025-05-03 20:50:50.327	2025-05-03 20:50:50.327	\N
c0718a96-f64d-4404-9180-a0f5547638dd	Monica	Castillo Rosas		\N	\N	2006-09-22 00:00:00		2025-05-03 20:50:50.327	2025-05-03 20:50:50.327	\N
54f6944d-384a-4f90-94ea-57210478e95f	Mariano	Urbina Millan		\N	\N	2006-10-09 00:00:00		2025-05-03 20:50:50.328	2025-05-03 20:50:50.328	\N
99ebbdfc-aa20-41f3-bd6f-e39348eea7dc	Mariza	Esqueda Huerta		\N	\N	2006-10-17 00:00:00		2025-05-03 20:50:50.328	2025-05-03 20:50:50.328	\N
c4df0c68-6de8-4477-99fc-7dc4824e0c50	Marisa	Esqueda Huerta		marhe33@yahoo.com.mx	\N	1970-02-17 00:00:00		2025-05-03 20:50:50.328	2025-05-03 20:50:50.328	\N
fb9095f9-9c25-4469-a403-b9c0b05dd817	Yolanda	Elorriaga Vazquez		\N	\N	2006-10-24 00:00:00		2025-05-03 20:50:50.329	2025-05-03 20:50:50.329	\N
d1f4e00b-e759-4ae1-a87d-863c3c7accd3	Katia Teresa	Aguirre Carmona		\N	\N	2006-11-07 00:00:00		2025-05-03 20:50:50.329	2025-05-03 20:50:50.329	\N
1669b436-bc8b-447c-9151-bafa5f56e16f	Ricardo	Mendez Curiel		\N	\N	2006-11-08 00:00:00		2025-05-03 20:50:50.33	2025-05-03 20:50:50.33	\N
01e93fa6-af3d-4b14-a6d6-3d7cc1ccca4a	Maria Teresa	Rodriguez Estrada		\N	\N	2006-11-09 00:00:00		2025-05-03 20:50:50.33	2025-05-03 20:50:50.33	\N
fc1f0d33-6a3d-4bf3-84cf-9971f8ad65c4	mercedes	Gonzalez García		\N	\N	2006-12-01 00:00:00		2025-05-03 20:50:50.33	2025-05-03 20:50:50.33	\N
735e932f-0982-4195-91c8-d0d542ed62f5	Ruth	Miranda Victoria		\N	\N	2006-12-18 00:00:00		2025-05-03 20:50:50.331	2025-05-03 20:50:50.331	\N
e626c59e-f41a-48f3-b3c0-723f12fb30b8	Monica	Cervantes Ceja		\N	\N	2006-12-28 00:00:00		2025-05-03 20:50:50.331	2025-05-03 20:50:50.331	\N
74c5e95d-58f7-473b-bb44-a3b28dee011f	susana	cristina ramos		\N	\N	2007-03-14 00:00:00		2025-05-03 20:50:50.331	2025-05-03 20:50:50.331	\N
0b62f2f3-5930-452f-8c57-f13af513dd1f	Rafael	Marcelino Hernández		\N	\N	2007-03-26 00:00:00		2025-05-03 20:50:50.332	2025-05-03 20:50:50.332	\N
95b599ff-202d-4490-991c-d7cbe3e5cf1a	Mama Dra	Valades		\N	\N	2007-04-18 00:00:00		2025-05-03 20:50:50.332	2025-05-03 20:50:50.332	\N
4494b910-0ff2-4ed6-8dfd-d14ca9f8f206	Ma. de Guadalupe	Roman Valladarez		\N	\N	2007-05-17 00:00:00		2025-05-03 20:50:50.333	2025-05-03 20:50:50.333	\N
d175d1ed-b700-4d3d-8870-5b50eb10aa88	Silvia	Zabala Rosales		\N	\N	2007-05-25 00:00:00		2025-05-03 20:50:50.333	2025-05-03 20:50:50.333	\N
a9fbe81a-ebde-4d06-8fb4-ba4d14e854d7	Vivek	Rajaram Prazad		\N	\N	2007-05-30 00:00:00		2025-05-03 20:50:50.333	2025-05-03 20:50:50.333	\N
e4f3181b-6f20-4d43-b5f4-67d2f8f94854	Ruben	Ovando Rodriguez		\N	\N	2007-06-08 00:00:00		2025-05-03 20:50:50.334	2025-05-03 20:50:50.334	\N
48de0f46-b11e-48a3-9fa3-0f81b77c2b53	Obed	Santiago Ramirez		\N	\N	2007-06-28 00:00:00		2025-05-03 20:50:50.334	2025-05-03 20:50:50.334	\N
6595e50f-4a69-4039-a830-933d9be8e828	Maria Elena	Vargas Quintanar		\N	\N	2007-07-13 00:00:00		2025-05-03 20:50:50.334	2025-05-03 20:50:50.334	\N
136d6956-78e2-43cf-a797-83a598994358	Manue	Hernandez Cornejo		\N	\N	2007-08-01 00:00:00		2025-05-03 20:50:50.335	2025-05-03 20:50:50.335	\N
f258a060-6dc4-48a9-8a06-c858d59c4b91	Julio Remberto	Ochoa Arreola		\N	\N	1974-07-28 00:00:00		2025-05-03 20:50:50.335	2025-05-03 20:50:50.335	\N
1903966b-775b-4818-b57e-50e67b640778	Manuel	Novoa Gutierrez		\N	\N	2007-11-10 00:00:00		2025-05-03 20:50:50.335	2025-05-03 20:50:50.335	\N
f66c383a-4ede-492e-9e53-8b96cefdab1c	Nubia Itzel	Aguilar Vera		\N	\N	2007-11-15 00:00:00		2025-05-03 20:50:50.336	2025-05-03 20:50:50.336	\N
4dcef000-661e-4e0b-92b7-3dc962e993c2	Yatana Abigail	Aguilar Vera		\N	\N	2007-11-15 00:00:00		2025-05-03 20:50:50.336	2025-05-03 20:50:50.336	\N
2966efa4-81b5-4939-92d3-7bf1a21ea046	Maria Patricia	Pulidop Jacobo		\N	\N	2007-12-03 00:00:00		2025-05-03 20:50:50.336	2025-05-03 20:50:50.336	\N
05687563-db90-4a67-a42a-c66913d36d81	Julian	Venegas Guzmán		\N	\N	2007-12-05 00:00:00		2025-05-03 20:50:50.337	2025-05-03 20:50:50.337	\N
2523ab42-f621-4df0-b1e7-e01ef8faf9f2	Rafael	Perez Mata		\N	\N	2007-12-07 00:00:00		2025-05-03 20:50:50.337	2025-05-03 20:50:50.337	\N
f966e416-fd3f-413e-a8a4-bcc353fd6999	Olga Alicia	Hernandez Becerra		\N	\N	2007-12-08 00:00:00		2025-05-03 20:50:50.337	2025-05-03 20:50:50.337	\N
6763c2d4-420a-4abb-9286-968d616459f6	Kine	Lundetaret Tveito		\N	\N	2007-12-22 00:00:00		2025-05-03 20:50:50.338	2025-05-03 20:50:50.338	\N
936c3236-e899-41e5-9196-ddc1680e1019	Rodrigo	Ledesma Gantarillas		\N	\N	2008-01-16 00:00:00		2025-05-03 20:50:50.338	2025-05-03 20:50:50.338	\N
73adfae0-8936-4698-9a8e-dc575eebcd78	Rodrigo	Ledesma García		\N	\N	2008-01-18 00:00:00		2025-05-03 20:50:50.338	2025-05-03 20:50:50.338	\N
dacce407-b873-47a3-aeb8-a6a75cc1efe8	Olga Alicia	Hdes. Becerra		\N	\N	2008-01-23 00:00:00		2025-05-03 20:50:50.339	2025-05-03 20:50:50.339	\N
abee043a-7e61-44c1-b368-22d7684982f1	Paullina	Barajas Glez		\N	\N	2008-01-25 00:00:00		2025-05-03 20:50:50.339	2025-05-03 20:50:50.339	\N
d8f58a48-f313-432a-9f5c-464a9d69e7a4	María Teresa	Barajas Glez.		\N	\N	2008-01-25 00:00:00		2025-05-03 20:50:50.34	2025-05-03 20:50:50.34	\N
a13549b5-c3ec-47a0-b9ab-1e38b4d126ca	Monica Amairani	Camacho Gonzalez		\N	\N	2008-01-25 00:00:00		2025-05-03 20:50:50.34	2025-05-03 20:50:50.34	\N
7a6a3b6b-6751-4a0f-9620-ed57cf4005f5	Maria Tereza	Barajas Gonzaez		\N	\N	2008-02-04 00:00:00		2025-05-03 20:50:50.34	2025-05-03 20:50:50.34	\N
7d404a25-1faa-4d07-b4d9-6725d726a582	Ken	Crawford Villanueva		\N	\N	2008-02-22 00:00:00		2025-05-03 20:50:50.34	2025-05-03 20:50:50.34	\N
21c40b45-345f-44cf-97e2-56ce8dc0af6e	Susana	Navarro Cartellanos		\N	\N	2008-03-08 00:00:00		2025-05-03 20:50:50.341	2025-05-03 20:50:50.341	\N
d5a7ec0c-71c3-4f9b-806f-742289533460	Sandra Valeria	Lopez glez.		\N	\N	2008-03-12 00:00:00		2025-05-03 20:50:50.341	2025-05-03 20:50:50.341	\N
d83f2285-7cdd-4e49-bed6-6effc437724a	Nelly	Galindo		\N	\N	2008-03-18 00:00:00		2025-05-03 20:50:50.341	2025-05-03 20:50:50.341	\N
75470ad7-95d3-4115-9270-7b004616a8c3	Nora Margarita	gonzalez Cortez		\N	\N	2008-03-19 00:00:00		2025-05-03 20:50:50.342	2025-05-03 20:50:50.342	\N
7741fd1b-fc6e-4da6-8f2a-2ad349bd8b15	Lina	Long Prie		\N	\N	2008-03-21 00:00:00		2025-05-03 20:50:50.342	2025-05-03 20:50:50.342	\N
f00fcc7c-14be-4fbf-b67b-d37de864957a	Tim	Longpre		\N	\N	2008-03-28 00:00:00		2025-05-03 20:50:50.342	2025-05-03 20:50:50.342	\N
7c595c01-eda7-403a-aea6-917dd459628d	Marie Nathalie	Martell		\N	\N	2008-04-04 00:00:00		2025-05-03 20:50:50.343	2025-05-03 20:50:50.343	\N
3e2c217f-38fd-411d-a651-2506704cbc6e	Rogelio Antonio	Ramirez Pera		\N	\N	2008-04-07 00:00:00		2025-05-03 20:50:50.343	2025-05-03 20:50:50.343	\N
e079cfe2-db4a-4273-82ee-766c6119d2dc	Monica	Albarran Medina		\N	\N	2008-04-29 00:00:00		2025-05-03 20:50:50.343	2025-05-03 20:50:50.343	\N
0e6926d1-a190-40f6-8d35-b93f912aed0f	Toño	Colin Mendoza		\N	\N	2008-05-06 00:00:00		2025-05-03 20:50:50.344	2025-05-03 20:50:50.344	\N
39b66b58-e730-42e3-a6bc-835e75bf53a8	Marco Antonio	Neira Gomez		\N	\N	2008-05-09 00:00:00		2025-05-03 20:50:50.344	2025-05-03 20:50:50.344	\N
93ddb85a-9a8d-4727-b6cd-1a5218d56f66	Rosario	Gonzalez Rosales		\N	\N	2008-05-27 00:00:00		2025-05-03 20:50:50.344	2025-05-03 20:50:50.344	\N
b6dae10f-b1e0-4f19-9735-3f9d48783d11	Michel	Albarran Ruiz		\N	\N	2008-05-28 00:00:00		2025-05-03 20:50:50.345	2025-05-03 20:50:50.345	\N
c1257fb7-9582-47aa-8906-fcd8d0fd9db3	Ma. de la Paz	Velazco Contreras		\N	3221270642	2008-05-29 00:00:00		2025-05-03 20:50:50.345	2025-05-03 20:50:50.345	\N
6100e4c5-84ae-4e98-b015-a2175ba85431	Sandra Pulina	Gutierres Glez.		\N	\N	2008-06-03 00:00:00		2025-05-03 20:50:50.345	2025-05-03 20:50:50.345	\N
e22dafe9-07bd-4379-b9e1-2b7bb5d7b4ca	Maricela	Lomeli Aguallo		\N	\N	2008-06-13 00:00:00		2025-05-03 20:50:50.346	2025-05-03 20:50:50.346	\N
d556873e-2156-4255-b379-9f4785acdc58	Ricardo	Navarro López		\N	\N	2008-06-25 00:00:00		2025-05-03 20:50:50.346	2025-05-03 20:50:50.346	\N
d01275f1-9bc6-4385-9588-e10f6fa1c909	Pablo	Gonzalez Avila		\N	\N	2008-06-28 00:00:00		2025-05-03 20:50:50.346	2025-05-03 20:50:50.346	\N
089ee454-fda7-4f99-a321-e93ca2a02fea	Paola Estefania	Navarro Rodriguez		\N	\N	2008-07-02 00:00:00		2025-05-03 20:50:50.346	2025-05-03 20:50:50.346	\N
60c12d63-cccc-417a-a6f4-b7512c000feb	Trinidad	Guzman Lazola		\N	\N	2008-07-22 00:00:00		2025-05-03 20:50:50.347	2025-05-03 20:50:50.347	\N
0239a929-0d76-44cc-b0c7-1fe782181ca4	Rufino	Osuna Lora		\N	\N	2008-08-14 00:00:00		2025-05-03 20:50:50.347	2025-05-03 20:50:50.347	\N
23a101d2-bcf9-44eb-8668-7a6fec84ec16	Maria Yanira	Vera Maya		\N	\N	2008-08-20 00:00:00		2025-05-03 20:50:50.347	2025-05-03 20:50:50.347	\N
a6b17942-348e-48a4-a924-530ea5311cae	Noemi	Diaz Grcía		\N	\N	2008-08-21 00:00:00		2025-05-03 20:50:50.348	2025-05-03 20:50:50.348	\N
55aa1ae0-a54d-4f7b-af69-0f0c388babc4	Steven	Lord		\N	\N	2008-09-01 00:00:00		2025-05-03 20:50:50.348	2025-05-03 20:50:50.348	\N
42216a11-b0a7-4c56-b0c7-308d68b13a38	Raul	Segura Morales		\N	\N	2008-09-03 00:00:00		2025-05-03 20:50:50.348	2025-05-03 20:50:50.348	\N
fa38f993-0bfb-4764-9dab-d060d028b26e	Katy	Trinh		\N	\N	2008-09-08 00:00:00		2025-05-03 20:50:50.349	2025-05-03 20:50:50.349	\N
e3a888cc-d3ee-4a04-bc1e-ffefdba65929	Robert Hector	Ibarra Jimenez		\N	\N	2008-09-12 00:00:00		2025-05-03 20:50:50.349	2025-05-03 20:50:50.349	\N
d03c0b8a-71b5-4a96-8511-aec09014a30a	Susana	Vazquez Aguilera		\N	\N	2008-09-15 00:00:00		2025-05-03 20:50:50.349	2025-05-03 20:50:50.349	\N
8739459b-7c7d-428b-b117-bb2effd27fc4	Ricardo	Feregrino Sezatti		\N	\N	2008-09-17 00:00:00		2025-05-03 20:50:50.35	2025-05-03 20:50:50.35	\N
9e373c5f-c218-42bb-b472-2086ccfef782	Roberta	Jones		\N	\N	2008-09-18 00:00:00		2025-05-03 20:50:50.35	2025-05-03 20:50:50.35	\N
55a52be3-359d-40c2-8aa5-578482365422	Susana	Gonzalez Baltazar		\N	\N	2008-09-19 00:00:00		2025-05-03 20:50:50.35	2025-05-03 20:50:50.35	\N
298934f3-301d-4a31-87a9-a9bf95dfa6a5	Maria de Carmen	Grageda Villa		\N	\N	2008-09-23 00:00:00		2025-05-03 20:50:50.351	2025-05-03 20:50:50.351	\N
42072116-284d-4ae8-a013-1d8b3f5a9994	Marisol	Perez Hernandez		\N	\N	2008-10-11 00:00:00		2025-05-03 20:50:50.351	2025-05-03 20:50:50.351	\N
52200433-0c9e-48ab-92df-2f5392969442	Teresa	Aragon Gonzalez		\N	\N	2008-10-21 00:00:00		2025-05-03 20:50:50.351	2025-05-03 20:50:50.351	\N
ef7c8ec8-12cc-4f91-a57e-51f575f0fd8b	Maria del Carmen	Grajeda Villa		mcgrajeda05@gmail.com	\N	1975-12-23 00:00:00		2025-05-03 20:50:50.351	2025-05-03 20:50:50.351	\N
dabca462-90a5-428f-95ae-e99c11f6a979	Maria Angelica	Lopéz Delgadilo		\N	\N	2008-11-04 00:00:00		2025-05-03 20:50:50.352	2025-05-03 20:50:50.352	\N
3ad40754-8590-49a0-889a-5ac635b60e7c	Tomas	Jhones		\N	\N	2008-11-18 00:00:00		2025-05-03 20:50:50.352	2025-05-03 20:50:50.352	\N
39957d9d-ed6e-4f22-b0b3-56787754245d	Juan Rafael	Padron Muñoz		\N	\N	2008-12-01 00:00:00		2025-05-03 20:50:50.352	2025-05-03 20:50:50.352	\N
109f3e0e-cdab-4e63-8df9-a381d77e9021	Miriam Elizabeth	Santana de Ramirez		\N	\N	2008-12-04 00:00:00		2025-05-03 20:50:50.353	2025-05-03 20:50:50.353	\N
ea129dad-b4a4-4534-94f3-06dcd368280b	Luz Maria	Tirado Martinez		\N	\N	2008-12-11 00:00:00		2025-05-03 20:50:50.353	2025-05-03 20:50:50.353	\N
15716f5d-92fe-4268-a586-a8c2f519e74f	Martin	Escurra Rios		\N	\N	2008-12-12 00:00:00		2025-05-03 20:50:50.353	2025-05-03 20:50:50.353	\N
dc2d314d-50c9-4259-bc2f-0394aef2b0b4	Ramiro	Zuñiga Estrada		\N	\N	2008-12-19 00:00:00		2025-05-03 20:50:50.354	2025-05-03 20:50:50.354	\N
4adccc68-c95c-4b93-8973-698125730b99	Lya	Hernandez Hernandez		\N	\N	2009-01-02 00:00:00		2025-05-03 20:50:50.354	2025-05-03 20:50:50.354	\N
80798cc2-6e18-4550-b2bf-c0cd9e3e185d	Nelly Lizeth	Pacheco Matínez		\N	\N	2009-01-03 00:00:00		2025-05-03 20:50:50.355	2025-05-03 20:50:50.355	\N
de01758c-6f55-43ba-8f7c-d2d6ba073a73	Nora Alejandra	Lerma Romero		\N	\N	2009-01-08 00:00:00		2025-05-03 20:50:50.355	2025-05-03 20:50:50.355	\N
aeacef1f-4679-4674-aa40-1cd10b02b199	Marck	Kloss de Leon Martinez		\N	\N	2009-01-09 00:00:00		2025-05-03 20:50:50.355	2025-05-03 20:50:50.355	\N
9350f47b-2e6b-441b-b327-b366438bde6b	Maria Guadalupe	Ledesma Cardoso		\N	\N	1956-09-01 00:00:00		2025-05-03 20:50:50.355	2025-05-03 20:50:50.355	\N
25f7fe85-8cae-4928-979d-77b232369e7a	Marck	De León Martínez		\N	\N	2009-01-30 00:00:00		2025-05-03 20:50:50.356	2025-05-03 20:50:50.356	\N
548c4271-de2e-4541-aceb-b09b8ad9565a	Mario	Valdivieso -García		\N	\N	2009-01-30 00:00:00		2025-05-03 20:50:50.356	2025-05-03 20:50:50.356	\N
b26961bf-09eb-4eb1-9a42-6f68e4161e8a	julio Cesar	Anaya Flores		\N	\N	2009-02-02 00:00:00		2025-05-03 20:50:50.356	2025-05-03 20:50:50.356	\N
fa8a912e-c07a-4bfa-8414-7b93f445e3c5	Veronica	Sanchez Gonzalez		\N	\N	2009-02-16 00:00:00		2025-05-03 20:50:50.357	2025-05-03 20:50:50.357	\N
c9412372-0ea6-4893-b4f6-cbf50d6c368c	Maria del Pilar	Platas García		\N	\N	2009-02-19 00:00:00		2025-05-03 20:50:50.357	2025-05-03 20:50:50.357	\N
bee4ef74-9022-4713-9b62-91cfc0700beb	Mackenzie	Krumme		\N	\N	2009-03-07 00:00:00		2025-05-03 20:50:50.357	2025-05-03 20:50:50.357	\N
1c0820d9-daaf-42bb-a83b-8a14bff76e59	Zoila Diana	López de Zarate		\N	\N	2009-03-13 00:00:00		2025-05-03 20:50:50.358	2025-05-03 20:50:50.358	\N
592e3748-4ab0-4b36-a34e-9dca0c1f71b5	Marco Alberto	Chavez Peña		\N	\N	2009-03-18 00:00:00		2025-05-03 20:50:50.358	2025-05-03 20:50:50.358	\N
5fd1221d-2541-4bf3-9bc6-b1bfbec43453	Teodoro	Mesa Pelayo		\N	\N	2009-03-28 00:00:00		2025-05-03 20:50:50.358	2025-05-03 20:50:50.358	\N
271a9a8f-5138-4bde-a03c-0733ca85a4a6	Nelida	Robles Chavez		\N	\N	2009-04-02 00:00:00		2025-05-03 20:50:50.359	2025-05-03 20:50:50.359	\N
35240878-438a-4fba-b8b4-a5f2b54a10f0	Martha Alicia	Sanchez López		\N	\N	1986-11-11 00:00:00		2025-05-03 20:50:50.359	2025-05-03 20:50:50.359	\N
5ec53a42-f7d8-4398-8f06-d1c112c40468	Marta Alicia	Sanchez López		\N	\N	2009-04-14 00:00:00		2025-05-03 20:50:50.359	2025-05-03 20:50:50.359	\N
f015eb44-8456-457e-afef-20b81d32e871	Rocio	Escobar Gomez		\N	\N	2009-04-15 00:00:00		2025-05-03 20:50:50.36	2025-05-03 20:50:50.36	\N
7b1740ce-c198-490f-820a-42ed6f3577d9	Omar	Ledesma Chavez		o.ledesma@hotmail.com	\N	1982-06-15 00:00:00		2025-05-03 20:50:50.36	2025-05-03 20:50:50.36	\N
a2f12a52-61e2-4a02-af21-b3386e1c023a	Marisol	Baustista Espinosa		\N	\N	2009-05-02 00:00:00		2025-05-03 20:50:50.36	2025-05-03 20:50:50.36	\N
d16d7715-02df-4f0f-92e5-a6bad556bcbd	Lus Maria	Bautista Espinosa		\N	\N	2009-05-02 00:00:00		2025-05-03 20:50:50.36	2025-05-03 20:50:50.36	\N
99a71b95-0b04-42c4-baa9-c16ebe5d0c71	Monica Leonor	Snchez Bautista		\N	\N	2009-05-05 00:00:00		2025-05-03 20:50:50.361	2025-05-03 20:50:50.361	\N
8bd0b09f-225c-4076-aea0-834da2ed67ce	Oscar	Lopez Gomes		\N	\N	2009-05-07 00:00:00		2025-05-03 20:50:50.361	2025-05-03 20:50:50.361	\N
324578f9-4198-49ba-98ed-ed627ece7d7a	Luz Maria	Bautista Espinoza		\N	\N	2009-05-11 00:00:00		2025-05-03 20:50:50.361	2025-05-03 20:50:50.361	\N
a2b875e7-ba28-45ea-a95a-184cbdcca52f	Violeta	Padilla Marrón		\N	\N	2009-05-25 00:00:00		2025-05-03 20:50:50.362	2025-05-03 20:50:50.362	\N
46674338-b329-4d62-b6c8-91394ef0806f	Yolanda	Barajas Guillen		\N	\N	2009-05-25 00:00:00		2025-05-03 20:50:50.362	2025-05-03 20:50:50.362	\N
c8b9be94-c73e-4bee-9f8f-19de61798360	Manuela	Davila Ureña		\N	\N	2009-06-02 00:00:00		2025-05-03 20:50:50.363	2025-05-03 20:50:50.363	\N
28945f4f-1663-4230-9461-cf9ac7c0c007	Maricarmen	Trijillo Hernandez		\N	\N	2009-06-05 00:00:00		2025-05-03 20:50:50.363	2025-05-03 20:50:50.363	\N
bb983e08-b624-4576-8a84-3a8f42cc8584	Marcell	Lebrun		\N	\N	2009-06-10 00:00:00		2025-05-03 20:50:50.363	2025-05-03 20:50:50.363	\N
21708965-f427-4c30-b5ce-be8a7fc126cd	Paulina	Alvares Cardenas		\N	\N	2009-06-10 00:00:00		2025-05-03 20:50:50.363	2025-05-03 20:50:50.363	\N
a6122a78-cc61-4add-8c1e-795540dd10cd	Luz Helena	Abarca Placencia		\N	\N	2009-06-17 00:00:00		2025-05-03 20:50:50.364	2025-05-03 20:50:50.364	\N
1a0daabe-9da9-4601-9d75-6802e4146924	Patricia	Cadena Muñoz		\N	\N	2009-06-18 00:00:00		2025-05-03 20:50:50.364	2025-05-03 20:50:50.364	\N
a7af77dc-15d5-4dab-bea5-ec9e153ef28c	Silvia Patricia	Cadena Muñoz		\N	\N	2009-06-18 00:00:00		2025-05-03 20:50:50.364	2025-05-03 20:50:50.364	\N
ccd956c6-51a3-43f3-b11b-469016089ff5	Roberto	Napoles Lopez		\N	\N	2009-06-25 00:00:00		2025-05-03 20:50:50.365	2025-05-03 20:50:50.365	\N
ec6d5009-5552-4dfe-b641-5a8fd07df347	Yesica	Crúz Araiza		\N	\N	2009-07-20 00:00:00		2025-05-03 20:50:50.365	2025-05-03 20:50:50.365	\N
716764c0-25de-49a4-b701-41195c79e872	karla Patricia	Sarate Muñoz		\N	\N	2009-07-28 00:00:00		2025-05-03 20:50:50.365	2025-05-03 20:50:50.365	\N
60ed4ef3-76fb-4316-8a30-ca8b5a07f521	Karla	Cervantes Topete		\N	\N	2009-07-29 00:00:00		2025-05-03 20:50:50.366	2025-05-03 20:50:50.366	\N
c9b4b2c5-eaea-422e-8a55-c07dd960c00c	roci	Nuñez Rojo		\N	\N	2009-08-04 00:00:00		2025-05-03 20:50:50.366	2025-05-03 20:50:50.366	\N
dfc38cd3-2a62-4f0d-9bcd-5733fa472196	Marlene	Borga Pineda		\N	\N	2009-09-03 00:00:00		2025-05-03 20:50:50.366	2025-05-03 20:50:50.366	\N
cedf5ae7-a248-43c8-b3c7-d721f8ea9c21	Manuel	Meneces Andrade		\N	\N	2009-09-08 00:00:00		2025-05-03 20:50:50.367	2025-05-03 20:50:50.367	\N
2fca3c63-8655-48ca-8a70-d43ee50f4af5	Ma. Gloria	Flores Salazar		\N	\N	2009-09-09 00:00:00		2025-05-03 20:50:50.367	2025-05-03 20:50:50.367	\N
328a534d-8960-405f-9076-2cf0f5517fe1	Sergio Miguel	Gomez López		\N	\N	2009-09-12 00:00:00		2025-05-03 20:50:50.367	2025-05-03 20:50:50.367	\N
6b48be69-2369-40b2-9e1e-fb95e47bc29c	Margarita	Delgado Sanchez		\N	\N	2009-09-25 00:00:00		2025-05-03 20:50:50.368	2025-05-03 20:50:50.368	\N
41c16105-506d-41c1-be0b-fa896ddbe00f	Maria Elena	Cortez Virgen		\N	\N	2009-10-26 00:00:00		2025-05-03 20:50:50.368	2025-05-03 20:50:50.368	\N
10b03ce8-689b-4cfd-b714-175bad79f952	Wendy	Bañuelos		\N	\N	2009-10-28 00:00:00		2025-05-03 20:50:50.368	2025-05-03 20:50:50.368	\N
cf2682be-c126-4cce-bb47-c6be0cd1e78e	Mayela	Bernal		\N	\N	2009-10-29 00:00:00		2025-05-03 20:50:50.369	2025-05-03 20:50:50.369	\N
f9d265f6-7777-4067-8a4e-080cd608e86f	Lino Arnoldo	Mendoza		\N	\N	2009-11-03 00:00:00		2025-05-03 20:50:50.369	2025-05-03 20:50:50.369	\N
7b12d9cc-c1b6-4cbb-8b98-1862b02d15db	Lino Arnoldo	Mendoza		\N	\N	2009-11-03 00:00:00		2025-05-03 20:50:50.369	2025-05-03 20:50:50.369	\N
94a347d2-1552-48b3-a41f-434215e56a32	Miguel	Alvarez Alfaro		\N	\N	2009-11-09 00:00:00		2025-05-03 20:50:50.369	2025-05-03 20:50:50.369	\N
9c3684d2-a1bd-48bd-9008-3e8d9049a9a2	Mariana	Morales Vazquez		\N	\N	2009-11-23 00:00:00		2025-05-03 20:50:50.37	2025-05-03 20:50:50.37	\N
d426b623-a6e7-4dfe-8daa-da018821bb36	Rosario	Galiondo Vega		\N	\N	2009-11-27 00:00:00		2025-05-03 20:50:50.37	2025-05-03 20:50:50.37	\N
674deb22-cd56-44c8-8d52-842f001d03b0	Paola	Davila Ramirez		\N	\N	2009-11-30 00:00:00		2025-05-03 20:50:50.37	2025-05-03 20:50:50.37	\N
c6469437-9dec-4f43-a9fd-3752e04a5368	María Juanita	casillas Gòmez		\N	\N	2009-12-07 00:00:00		2025-05-03 20:50:50.371	2025-05-03 20:50:50.371	\N
33e2f5c6-e136-4747-8a30-914ab587a32c	Maria Juanita	Casillas Gomes		\N	\N	2009-12-07 00:00:00		2025-05-03 20:50:50.371	2025-05-03 20:50:50.371	\N
8d47be29-f59b-47f6-afa4-0b0ef95cc671	Miguel Angel	Zamora Orozco		\N	\N	2009-12-10 00:00:00		2025-05-03 20:50:50.371	2025-05-03 20:50:50.371	\N
8d8a2bef-36c7-4025-8d9b-8059a2c777d1	Laura	Nevarez Reyes		lora_nevarez@hotmail.es.	\N	1977-03-23 00:00:00		2025-05-03 20:50:50.372	2025-05-03 20:50:50.372	\N
0a5c828a-1480-48c4-bee6-4d7373cc9277	Raúl	Morales Rivera.		\N	\N	2010-01-28 00:00:00		2025-05-03 20:50:50.372	2025-05-03 20:50:50.372	\N
1a089c68-3074-4485-88a6-c88ebd728208	Valentina	Ginzalez Días		\N	\N	2010-02-03 00:00:00		2025-05-03 20:50:50.372	2025-05-03 20:50:50.372	\N
21f33059-f81d-47e4-84db-602b58ef87e3	Maria Elena	Martinez Arteaga		\N	\N	2010-02-11 00:00:00		2025-05-03 20:50:50.373	2025-05-03 20:50:50.373	\N
e42d3374-9229-46dc-99c0-070c66a0ccfc	Santiago	Gabino Bautista		\N	\N	2010-02-17 00:00:00		2025-05-03 20:50:50.373	2025-05-03 20:50:50.373	\N
24b06eac-9bd9-4487-b839-4ee03bd67061	Oscar Adrían	Gonzalez Crúz		oscaradrian01@hotmail.com	3221071239	2010-02-18 00:00:00		2025-05-03 20:50:50.373	2025-05-03 20:50:50.373	\N
e0c00f16-ca97-47c7-9e0a-a5e10a0c4c05	Paloma	Lopez Pereda		\N	\N	2010-02-20 00:00:00		2025-05-03 20:50:50.374	2025-05-03 20:50:50.374	\N
0c67516b-415a-4320-8634-4d1de96c5a7e	Monica	Topete		\N	\N	2010-02-25 00:00:00		2025-05-03 20:50:50.374	2025-05-03 20:50:50.374	\N
64a0b495-0bca-4492-981a-fa4058df92cb	Laura Patricia	Flores Gonzalez		\N	\N	2010-03-03 00:00:00		2025-05-03 20:50:50.374	2025-05-03 20:50:50.374	\N
3403664d-ef88-45f4-95c2-8e1c24767762	Ramona	Urrutia Chavarin		moni.urrutia19@gmail.com	\N	1980-06-19 00:00:00		2025-05-03 20:50:50.375	2025-05-03 20:50:50.375	\N
bfb9eb1c-6c7f-4da2-a49e-0743cf1f8047	Rafael	Mora Negrete		\N	\N	2010-03-22 00:00:00		2025-05-03 20:50:50.375	2025-05-03 20:50:50.375	\N
f8edf142-66a6-4810-841b-1c360b39062c	Roxana	Castañeda Cervantes		\N	\N	2010-03-30 00:00:00		2025-05-03 20:50:50.375	2025-05-03 20:50:50.375	\N
eec592de-aae1-40b0-9b38-8d2a40b97015	Ulices	Peña Gonzales		\N	\N	2010-04-13 00:00:00		2025-05-03 20:50:50.375	2025-05-03 20:50:50.375	\N
f1ea9cd5-7055-4ab5-b677-7bfad7abd20a	Raul	Morales		biologica360@gmail.com	\N	1978-03-26 00:00:00		2025-05-03 20:50:50.376	2025-05-03 20:50:50.376	\N
34989204-f6de-49c7-9a8e-77042ffcbf54	Salvador	Arreola Ledesma		\N	\N	2010-04-15 00:00:00		2025-05-03 20:50:50.376	2025-05-03 20:50:50.376	\N
e85c0875-e917-415d-bbbe-1ca6a04bbdb7	Karla Samantha	Cervantes Topete		\N	\N	2010-04-26 00:00:00		2025-05-03 20:50:50.376	2025-05-03 20:50:50.376	\N
78fd4e79-e38e-42e4-8210-34c1a0f625cf	Sarah	Monroy Sanchez		\N	\N	2010-05-28 00:00:00		2025-05-03 20:50:50.377	2025-05-03 20:50:50.377	\N
432a3fce-7345-4069-a4ce-81b2684c3564	Maria Aurora	López Ruíz		\N	\N	2010-06-04 00:00:00		2025-05-03 20:50:50.377	2025-05-03 20:50:50.377	\N
d40b9b9b-2cbf-45b0-b941-ffbf2cfd9475	Tony	Toth		\N	\N	2010-07-26 00:00:00		2025-05-03 20:50:50.377	2025-05-03 20:50:50.377	\N
eb7ea1ef-0fab-41f6-93d4-8167dcbe67ac	Todd	Toth		\N	\N	2010-08-07 00:00:00		2025-05-03 20:50:50.378	2025-05-03 20:50:50.378	\N
b2e6f1e6-23ef-41d9-a260-92b85718155c	Samantha	Sarmiento Montilel		\N	\N	2010-08-21 00:00:00		2025-05-03 20:50:50.378	2025-05-03 20:50:50.378	\N
04397cbf-9545-4276-993e-d60eb72e3826	Lilian Raquel	Peña Palacios		\N	\N	2010-09-14 00:00:00		2025-05-03 20:50:50.378	2025-05-03 20:50:50.378	\N
dc9f427e-4920-462c-af8a-07a41ce95389	Karla Nereida	Perez Gonzalez		\N	\N	2010-09-17 00:00:00		2025-05-03 20:50:50.379	2025-05-03 20:50:50.379	\N
e608191d-363a-47ba-8f33-bae43b196ce7	Omar	Castillo Vega		\N	\N	2010-09-22 00:00:00		2025-05-03 20:50:50.379	2025-05-03 20:50:50.379	\N
000d9026-d808-4af1-b13d-d2514035e395	Maria Estela	Cardenas Velazco		\N	\N	2010-10-06 00:00:00		2025-05-03 20:50:50.379	2025-05-03 20:50:50.379	\N
5b4f878c-f8ec-4b10-a92f-43010fbac46b	Soledad	Contreras Piña		\N	\N	2010-10-21 00:00:00		2025-05-03 20:50:50.379	2025-05-03 20:50:50.379	\N
e38d260e-3685-4c3c-9e65-5f0668ebe4f7	Rafael	Muñoz		\N	\N	2010-10-25 00:00:00		2025-05-03 20:50:50.38	2025-05-03 20:50:50.38	\N
cc1814b0-95b6-4458-8034-531b164404e9	Rafael	Alatorre Castro		\N	\N	2010-11-05 00:00:00		2025-05-03 20:50:50.38	2025-05-03 20:50:50.38	\N
c947c8d4-b65f-4881-beb4-57ca120c90bf	Rosa	Cortez		\N	\N	2010-11-12 00:00:00		2025-05-03 20:50:50.381	2025-05-03 20:50:50.381	\N
213c78dd-6152-45c1-87c5-7412423c5178	Marisol	Gómez Hdéz.		\N	\N	2010-11-19 00:00:00		2025-05-03 20:50:50.381	2025-05-03 20:50:50.381	\N
73d15b55-9e77-4ebc-ae97-a64352dcb7b5	Marta	Dias Mendoza		\N	\N	2010-11-25 00:00:00		2025-05-03 20:50:50.381	2025-05-03 20:50:50.381	\N
d4dcf8b3-952b-441e-bfbe-f489231293f8	Martha	Reyes Martinez		\N	\N	2010-11-29 00:00:00		2025-05-03 20:50:50.382	2025-05-03 20:50:50.382	\N
caf22020-2f56-4ed7-bbf6-6186e52fd6a0	Maria Silvia	Palomares		\N	\N	2010-12-06 00:00:00		2025-05-03 20:50:50.382	2025-05-03 20:50:50.382	\N
add33b8a-8a6e-46f6-82cb-9f071c4b0319	Leonardo	Zuñiga Rodríguez		\N	\N	2010-12-10 00:00:00		2025-05-03 20:50:50.382	2025-05-03 20:50:50.382	\N
76f7668f-1c00-4b4b-a917-ad6f86a31c40	Rodrigo	Soberón		\N	\N	2010-12-14 00:00:00		2025-05-03 20:50:50.383	2025-05-03 20:50:50.383	\N
7d014224-1ca7-491f-971e-9ef468b3b394	Virginia	Cueva Franco		\N	\N	2011-01-12 00:00:00		2025-05-03 20:50:50.383	2025-05-03 20:50:50.383	\N
125ef895-652c-447d-ad7c-c3635721d5d0	Mellissa	Martinez		\N	\N	2011-01-13 00:00:00		2025-05-03 20:50:50.383	2025-05-03 20:50:50.383	\N
9c712bff-ed8b-431a-9102-4cc34891b1fa	Terecita	Corrales Suarez		\N	\N	2011-01-13 00:00:00		2025-05-03 20:50:50.384	2025-05-03 20:50:50.384	\N
3a28d4cd-5f56-4d39-a52b-08898b3b7eab	Lucia	Huerta Perez		\N	\N	2011-01-26 00:00:00		2025-05-03 20:50:50.384	2025-05-03 20:50:50.384	\N
b4dfca25-0719-4b75-a51b-7789188c08e5	Karina Lideth	Roble Lopez		\N	\N	2011-01-28 00:00:00		2025-05-03 20:50:50.384	2025-05-03 20:50:50.384	\N
2f8e8aae-e395-4724-962a-8dbe68928419	Tania	Cortez Macias		\N	\N	2011-01-28 00:00:00		2025-05-03 20:50:50.384	2025-05-03 20:50:50.384	\N
7d3104e4-f7b1-41ec-8ab2-c332270f2acc	Leticia	Saldivar Aramburu		\N	\N	2011-02-08 00:00:00		2025-05-03 20:50:50.385	2025-05-03 20:50:50.385	\N
8d59ded4-e79d-4b02-a6bf-645c95d5bcdd	Mary Cruz	Rosales Perez		\N	\N	2011-02-09 00:00:00		2025-05-03 20:50:50.385	2025-05-03 20:50:50.385	\N
4d7a2b98-1e63-43c0-ba0b-e92b6337e059	Marlene	Navarro Rendon		\N	\N	2011-02-09 00:00:00		2025-05-03 20:50:50.385	2025-05-03 20:50:50.385	\N
3291e582-e141-4048-aac4-ef9c05db6599	Lisethe	Escandon		\N	\N	2011-02-12 00:00:00		2025-05-03 20:50:50.386	2025-05-03 20:50:50.386	\N
df4c3d2b-c126-49f6-87b2-0ef3bf5d894e	Magda	Gonzalez		\N	\N	2011-02-14 00:00:00		2025-05-03 20:50:50.386	2025-05-03 20:50:50.386	\N
da2844db-c95d-44e4-b874-8d3d4b09f253	Miguel Anguel	Gomez Sanchez		\N	\N	2011-02-18 00:00:00		2025-05-03 20:50:50.386	2025-05-03 20:50:50.386	\N
9d23fc1b-c9c1-4e2a-9e84-a1ff9383bf39	Maunel	Martinez		\N	\N	2011-02-21 00:00:00		2025-05-03 20:50:50.387	2025-05-03 20:50:50.387	\N
7d7e304e-1236-4e66-8978-3d85d41707f6	Yadira	Vera Gomez		yadiraveragomez@gmail.com	\N	1973-11-27 00:00:00		2025-05-03 20:50:50.387	2025-05-03 20:50:50.387	\N
af44f792-c11e-473a-81ed-e3f9e18bfa84	Marlen	Miranda Castillo		\N	\N	2011-02-24 00:00:00		2025-05-03 20:50:50.387	2025-05-03 20:50:50.387	\N
285b9862-d094-4f66-a4c1-4b82cb1df58d	Titi	Bernal		\N	\N	2011-02-25 00:00:00		2025-05-03 20:50:50.388	2025-05-03 20:50:50.388	\N
4f9136f0-60cd-43ae-88a8-c2029fac5da8	Maria de la pa<	Yarik Abadilla		\N	\N	2011-02-28 00:00:00		2025-05-03 20:50:50.388	2025-05-03 20:50:50.388	\N
ac4dc71d-adb6-4f1b-9e92-f7724f7170d1	Wendy	VanCenhyyfttyn		\N	\N	2011-03-03 00:00:00		2025-05-03 20:50:50.388	2025-05-03 20:50:50.388	\N
f07a35f9-6a89-41dd-8174-d75f07773bf4	Leticia	Valverde Gonzalez		\N	\N	2011-03-17 00:00:00		2025-05-03 20:50:50.389	2025-05-03 20:50:50.389	\N
8fceb49c-70d6-4071-834e-ad52dfc570af	Santiago	Ramos		\N	\N	2011-03-23 00:00:00		2025-05-03 20:50:50.389	2025-05-03 20:50:50.389	\N
f2cf3dab-1893-4ce1-a73e-e0809d46daa5	Ricardo	Trujillo Aparicio		\N	\N	2011-03-28 00:00:00		2025-05-03 20:50:50.389	2025-05-03 20:50:50.389	\N
87024ac0-15c0-40b3-8b19-0eca041c505e	Rubi	Romero Ahumada		\N	\N	2011-03-30 00:00:00		2025-05-03 20:50:50.39	2025-05-03 20:50:50.39	\N
c3ca4abf-5026-427e-ab91-3c5e14b8e9fc	Leobardo Arturo	Ribera Cazares		\N	\N	2011-04-01 00:00:00		2025-05-03 20:50:50.39	2025-05-03 20:50:50.39	\N
b55b7f0e-5778-4739-a763-5b55f4da8b0a	Mayra Karina	Jimenez Castro		\N	\N	2011-04-07 00:00:00		2025-05-03 20:50:50.39	2025-05-03 20:50:50.39	\N
a4d3acc1-0760-4bab-a6dd-eb74221846f3	Rene	Rodriguez Rodriguez		\N	\N	2011-04-07 00:00:00		2025-05-03 20:50:50.391	2025-05-03 20:50:50.391	\N
66623041-a5f4-4970-a25d-8db6eca66ad7	Yahir Alejandro	Gomez Sanchez		\N	\N	2011-04-08 00:00:00		2025-05-03 20:50:50.391	2025-05-03 20:50:50.391	\N
1b5a6a95-efd8-4a79-8f95-9eaf251bca49	Pablo Michael	Gomez Sanchez		\N	\N	2011-04-08 00:00:00		2025-05-03 20:50:50.391	2025-05-03 20:50:50.391	\N
ff218d2d-90c6-4a0c-a842-3a26ad3a60e4	Rosa Maria	Ribera de Morales		\N	\N	2011-04-09 00:00:00		2025-05-03 20:50:50.392	2025-05-03 20:50:50.392	\N
c091ed8d-1955-4eb9-a21e-c7c0a87969e8	Miguel Angel	Gomez Vazquez		\N	\N	2011-04-09 00:00:00		2025-05-03 20:50:50.392	2025-05-03 20:50:50.392	\N
4eb145cb-d6f6-46e8-94d9-451d65a399b5	laura	xxx		\N	\N	2011-04-19 00:00:00		2025-05-03 20:50:50.392	2025-05-03 20:50:50.392	\N
d99c036a-ba86-4863-8120-8f5a35f7e093	Maida	Jimenez		mai_freakinqueen@hotmail.com	\N	1983-04-30 00:00:00		2025-05-03 20:50:50.393	2025-05-03 20:50:50.393	\N
037ee895-2130-43cf-b1fa-7b6d94d04666	RICARDO	Martínez Calderon		\N	\N	2011-05-25 00:00:00		2025-05-03 20:50:50.393	2025-05-03 20:50:50.393	\N
186cae14-9b6b-4ab4-81a0-bfdaf1a6972c	Miguel Angel	Rodriguez Padilla		\N	\N	2011-05-30 00:00:00		2025-05-03 20:50:50.393	2025-05-03 20:50:50.393	\N
e86801ff-181e-4e44-8613-0e6b6716b159	Maysam Han	Gonzalez Palomera		\N	\N	2011-06-10 00:00:00		2025-05-03 20:50:50.394	2025-05-03 20:50:50.394	\N
08522896-b1fb-4514-b4f5-1c446546295f	Sergio Enrrique	Garc{ia Rúiz		\N	\N	2011-06-14 00:00:00		2025-05-03 20:50:50.394	2025-05-03 20:50:50.394	\N
6f1fa457-bcc6-4a72-af86-51b9cf883128	MARI	FLORES RAMIREZ		\N	\N	2011-06-15 00:00:00		2025-05-03 20:50:50.394	2025-05-03 20:50:50.394	\N
12c1cc0b-193d-4b48-aec9-08e1fc7bd953	Maria Alma	Morales Aceves		\N	\N	2011-06-15 00:00:00		2025-05-03 20:50:50.395	2025-05-03 20:50:50.395	\N
2ceee89b-8eb2-4c68-a4e4-e21ace968963	Miguel	Santana		\N	\N	2011-06-15 00:00:00		2025-05-03 20:50:50.395	2025-05-03 20:50:50.395	\N
304a7508-57a6-42aa-a36a-f1ea360dbec4	Rose Marie	Morales		\N	+15124122541	2011-06-16 00:00:00		2025-05-03 20:50:50.395	2025-05-03 20:50:50.395	\N
e895abb8-6a45-4869-a3f5-9ded74e5ed0f	Maria del Carmen	Ayon		\N	\N	2011-06-16 00:00:00		2025-05-03 20:50:50.396	2025-05-03 20:50:50.396	\N
48f0486e-5beb-4110-92c6-e94a1a1090b7	Pamela	Hernandes Espinosa		\N	\N	2011-06-17 00:00:00		2025-05-03 20:50:50.396	2025-05-03 20:50:50.396	\N
4034e750-81ce-4aa1-88c5-5a4bf5b5b1a9	Nestora	Cordova Rodriguez		\N	\N	2011-06-20 00:00:00		2025-05-03 20:50:50.396	2025-05-03 20:50:50.396	\N
4f96ea93-c493-495c-a8c7-98f0a191cb86	Sara	Romero		rmsahara@telcel.blackberry.net.	\N	1975-06-05 00:00:00		2025-05-03 20:50:50.397	2025-05-03 20:50:50.397	\N
b2db75a3-e47a-4d14-bec2-05041a995958	Ramos Contreras	Mauricio		\N	\N	2011-06-24 00:00:00		2025-05-03 20:50:50.397	2025-05-03 20:50:50.397	\N
a6f92e7b-f793-4221-aab1-4196db26c425	Patricia	García		\N	\N	2011-06-27 00:00:00		2025-05-03 20:50:50.397	2025-05-03 20:50:50.397	\N
21c7bc41-070c-4ab2-8416-610ae4dd099a	Rosa	Villaseñor García		\N	\N	2011-06-30 00:00:00		2025-05-03 20:50:50.398	2025-05-03 20:50:50.398	\N
ff2d1e9f-36d4-4a07-bf31-22074ca7dcdb	Mario	Barrera Suchil		\N	\N	\N		2025-05-03 20:50:50.398	2025-05-03 20:50:50.398	\N
0273edfc-f45d-4ef7-a16b-0d325af6f4ac	Stand	Gabruk		\N	\N	\N		2025-05-03 20:50:50.398	2025-05-03 20:50:50.398	\N
c5eb4aa5-1391-4224-9120-a9bdebd3a607	Saida	Contreras Espinoza		\N	\N	\N		2025-05-03 20:50:50.399	2025-05-03 20:50:50.399	\N
afa3a2c7-7700-4d4a-b5e5-f87106772749	Veronica	Sanchez		\N	\N	1983-09-07 00:00:00		2025-05-03 20:50:50.399	2025-05-03 20:50:50.399	\N
4f02b59b-10b1-49a7-85d0-2be67c29a691	Priciliano	Guzmán Sánchez		\N	\N	\N		2025-05-03 20:50:50.399	2025-05-03 20:50:50.399	\N
d96e573c-3960-4888-9384-cc623c9f45a3	Paola Esetfania	Navarro Rodríguez		\N	\N	\N		2025-05-03 20:50:50.399	2025-05-03 20:50:50.399	\N
ee83085f-1ab4-4e7e-a843-2cc958b252bf	Ron	Senbenbearg		\N	\N	\N		2025-05-03 20:50:50.4	2025-05-03 20:50:50.4	\N
b72dba64-6ff6-4c72-a3bb-8e3c6f106e23	Ron	Vandenberg		ron@ronvandenberg.ca	3292695115	1944-03-06 00:00:00		2025-05-03 20:50:50.4	2025-05-03 20:50:50.4	\N
a43fb52a-1cb6-45ca-83a2-b967c300bbad	Sandra	Stern		\N	\N	1965-08-08 00:00:00		2025-05-03 20:50:50.4	2025-05-03 20:50:50.4	\N
ce3090cc-26f2-4497-ac4a-4d02a3788731	Marta	Flores Cervantes		\N	\N	1954-12-16 00:00:00		2025-05-03 20:50:50.401	2025-05-03 20:50:50.401	\N
79b10bdf-3766-421b-abd7-35f156e64375	Oscar Raymundo	Rodriguez Perez		\N	\N	1979-03-15 00:00:00		2025-05-03 20:50:50.401	2025-05-03 20:50:50.401	\N
c088a481-bde0-418f-93ea-84372bc72ddb	Rodrigo	Soberon Verastegui		soberon.verastegui@gmail.com	\N	1993-04-05 00:00:00		2025-05-03 20:50:50.401	2025-05-03 20:50:50.401	\N
2fdbc262-61e0-4d5e-8859-0e57290c8f8b	xx	xx		\N	\N	\N		2025-05-03 20:50:50.402	2025-05-03 20:50:50.402	\N
308f94f4-091a-4911-bea6-ff6bae48744d	María Monserrat	Olmedo Villaseñor		\N	\N	1978-06-30 00:00:00		2025-05-03 20:50:50.402	2025-05-03 20:50:50.402	\N
f1f39923-ecea-4850-a1e6-0dd7491a581a	Martin	Lampreabe		\N	3221359461	1954-05-06 00:00:00		2025-05-03 20:50:50.402	2025-05-03 20:50:50.402	\N
17f585c4-eaaf-40d9-a2c5-8c00a0fe1694	Sergio	Delfino Ruíz		\N	3221140548	1978-09-01 00:00:00		2025-05-03 20:50:50.403	2025-05-03 20:50:50.403	\N
8355072e-6a88-4201-8529-c5160ef31b7f	Lilian	García		\N	\N	1974-04-22 00:00:00		2025-05-03 20:50:50.403	2025-05-03 20:50:50.403	\N
51c9a929-2aa8-4d7d-8631-1319f8dc1259	Michelle	Todd		\N	\N	\N		2025-05-03 20:50:50.403	2025-05-03 20:50:50.403	\N
46813481-97b5-47d8-8703-6db7241500d0	Nairobi	Otero Estern		\N	\N	\N		2025-05-03 20:50:50.403	2025-05-03 20:50:50.403	\N
272d12c4-03ae-49fc-b90f-d9df65e01c1d	Rami	Zein		\N	\N	1970-12-25 00:00:00		2025-05-03 20:50:50.404	2025-05-03 20:50:50.404	\N
1c9de270-da90-45a9-bdf5-60213ef6beec	Marta	Esquibel Nuñez		\N	\N	1962-10-03 00:00:00		2025-05-03 20:50:50.404	2025-05-03 20:50:50.404	\N
88b1f16a-5e1a-47fb-9680-c8fad6f8b576	Miguel	Alonzo Villa		\N	\N	1978-05-07 00:00:00		2025-05-03 20:50:50.405	2025-05-03 20:50:50.405	\N
0a44b558-358a-4af9-8c13-d55b991ccc5b	Rodolfo	Gomez Bello		\N	\N	1969-12-17 00:00:00		2025-05-03 20:50:50.405	2025-05-03 20:50:50.405	\N
80b57a25-3f2f-4d0b-9b52-dabb5757fea9	Karyme Guadalupe	Cuevas Contreras		\N	\N	\N		2025-05-03 20:50:50.405	2025-05-03 20:50:50.405	\N
83320831-9919-46c0-8032-1bcf80e6bc4a	Rios Torres	Temis Jaqueline		\N	\N	\N		2025-05-03 20:50:50.406	2025-05-03 20:50:50.406	\N
fe5e065c-31d8-43d6-9e3f-d12f17dfca5d	Patricia	Garfio López		\N	\N	\N		2025-05-03 20:50:50.406	2025-05-03 20:50:50.406	\N
b75a2bc5-8e0a-4267-bab2-d01b6c71623a	Margarita	Camberos Arias		magykamberos@hotmail.com	\N	1982-05-27 00:00:00		2025-05-03 20:50:50.406	2025-05-03 20:50:50.406	\N
6b79d729-bff2-4f63-a4ac-30e34f802ce7	Marta Cecilia	Mercado Aranda		\N	3221824853	1965-11-22 00:00:00		2025-05-03 20:50:50.407	2025-05-03 20:50:50.407	\N
5b41eae4-2ca8-4b2a-9b8e-4369bb41e669	Maria Ana Patricia	Garfio López		patricia_garfio@yahoo.com	\N	1971-07-22 00:00:00		2025-05-03 20:50:50.407	2025-05-03 20:50:50.407	\N
d10531f6-0e1b-481e-a4f9-35ebc7b3c72c	Nayeli Gpe.	Hernández Lugones		\N	\N	\N		2025-05-03 20:50:50.407	2025-05-03 20:50:50.407	\N
477a3a1f-dd27-494f-922a-3fe0080c38ab	Norma	Alonzo Villa		\N	\N	\N		2025-05-03 20:50:50.407	2025-05-03 20:50:50.407	\N
92e1710b-f286-4b4f-a2ff-5dece7e03534	Trinidad	Cervantes		\N	\N	\N		2025-05-03 20:50:50.408	2025-05-03 20:50:50.408	\N
9a9ce133-f8fa-49c4-86e6-42725583014a	Rosa Amelia	Villaseñor García		\N	\N	\N		2025-05-03 20:50:50.408	2025-05-03 20:50:50.408	\N
63eeda0e-9b15-4df2-9b3b-6ea1e7d3e77d	Ramona	Mendoza Sanchez		\N	\N	\N		2025-05-03 20:50:50.408	2025-05-03 20:50:50.408	\N
d2833ff0-dd8d-49d0-96eb-bcad9ad51e32	Rosa angelica	Campos Vazquez		angelicampos@live.com.mx	\N	1987-10-20 00:00:00		2025-05-03 20:50:50.409	2025-05-03 20:50:50.409	\N
49191e96-8288-4536-93ad-dfe6d7da80cf	Tony	Visona		\N	\N	1931-05-11 00:00:00		2025-05-03 20:50:50.409	2025-05-03 20:50:50.409	\N
13d26057-43ff-4c52-ae69-f90c4885537d	Sarai	García Padilla		\N	\N	\N		2025-05-03 20:50:50.409	2025-05-03 20:50:50.409	\N
9ae9a8dc-fda3-4da2-b935-753aa9e2b5da	Tonatiu	Fajardo Dupuis		tocefa@gmail.com	3227792005	1978-05-12 00:00:00		2025-05-03 20:50:50.41	2025-05-03 20:50:50.41	\N
df148222-e1ce-4551-98d0-c2c2765f9b4d	Maria del Refugio	Ibarra		\N	\N	\N		2025-05-03 20:50:50.41	2025-05-03 20:50:50.41	\N
856fb57e-9ea6-4baf-be59-8e54e9d5843f	Victor	Argumedo Acero		\N	\N	\N		2025-05-03 20:50:50.41	2025-05-03 20:50:50.41	\N
448419d9-b54c-4970-9c1b-033ff330b1cd	Olga	Ongay Perez		\N	\N	\N		2025-05-03 20:50:50.411	2025-05-03 20:50:50.411	\N
54ad0575-50a4-4cee-8c36-92f11b5e1b8b	Paulina	Huerta Silva		phey_hs@hotmail.com	\N	1993-03-15 00:00:00		2025-05-03 20:50:50.411	2025-05-03 20:50:50.411	\N
9c91326a-23fa-477c-a191-b29f4f6ad126	Zaidel	Gonzales		\N	\N	\N		2025-05-03 20:50:50.411	2025-05-03 20:50:50.411	\N
b2693a5e-b540-49dc-99d1-dbf34f444622	Roxanna	Morgante		\N	3222942273	1974-07-10 00:00:00		2025-05-03 20:50:50.412	2025-05-03 20:50:50.412	\N
6c4487e7-7570-428e-8bf4-f37b4052dbeb	Nancy	Goowill		\N	\N	\N		2025-05-03 20:50:50.412	2025-05-03 20:50:50.412	\N
b3d910de-9820-40cb-959f-710581e79103	Maria	Piñon		\N	\N	\N		2025-05-03 20:50:50.412	2025-05-03 20:50:50.412	\N
356168ff-4b2d-4254-8f7f-3d162814cbdf	Paola	Valencia		\N	\N	\N		2025-05-03 20:50:50.413	2025-05-03 20:50:50.413	\N
b75f52ab-baf2-4b28-8580-d01c2ef19bdb	Maria	Gutieres de Covarrubias		\N	\N	\N		2025-05-03 20:50:50.413	2025-05-03 20:50:50.413	\N
de8532f6-5f59-4c2e-9de7-0d09c1ca90e3	Miguel	Ruiz Ortiz		\N	\N	\N		2025-05-03 20:50:50.413	2025-05-03 20:50:50.413	\N
0ac3686f-cba2-4a24-951d-47ae479cba06	karina	Macias		\N	\N	\N		2025-05-03 20:50:50.413	2025-05-03 20:50:50.413	\N
9a52ef6e-ef0a-4b4d-a7b3-8a613051488a	Ruth	Alvarez Torres		ruth_nat@hotmail.com	\N	1985-12-26 00:00:00		2025-05-03 20:50:50.414	2025-05-03 20:50:50.414	\N
0bd03527-c03d-49f6-92c3-7d4e9389eb0e	Roberto	Mejia		\N	\N	\N		2025-05-03 20:50:50.414	2025-05-03 20:50:50.414	\N
2159c2f0-57a4-4706-b7f8-99ad6bcba135	Kiara Rocksand	Alatorre Edgar		maribel_edgar@hotmail.com	3292965031	1998-08-09 00:00:00		2025-05-03 20:50:50.414	2025-05-03 20:50:50.414	\N
f432a3db-c8c0-43c7-a8ea-e58c0614a929	Omar	Guzmán García		\N	\N	1979-12-07 00:00:00		2025-05-03 20:50:50.415	2025-05-03 20:50:50.415	\N
87af9c0d-8a56-44d1-9844-61b446a4d7fd	Maria Estefani	Zapata Galvan		\N	\N	\N		2025-05-03 20:50:50.415	2025-05-03 20:50:50.415	\N
8cb0c68d-e9b1-4e65-98cb-2211e0317da7	Patricia	de la Lama Treviño		\N	\N	1956-03-09 00:00:00		2025-05-03 20:50:50.415	2025-05-03 20:50:50.415	\N
23d2e765-cc10-49a5-ac33-2a18a7adc6bc	Rigoberto	Montero Tello		rigo_montero@hotmail.com	\N	1953-04-14 00:00:00		2025-05-03 20:50:50.416	2025-05-03 20:50:50.416	\N
6b2b49ca-93c9-48c1-a794-3070d248b6fb	Maria de Jesús	Leaños Arellano		\N	\N	\N		2025-05-03 20:50:50.416	2025-05-03 20:50:50.416	\N
a5dd41a5-3908-4c50-be4a-011bca61fb22	Maricela	Carrillo Villaseñor		\N	\N	\N		2025-05-03 20:50:50.416	2025-05-03 20:50:50.416	\N
d33fba09-0fc2-4a16-9c69-c7263704c924	Mayra Iris	Cervantes Avalos		avaos95@hotmail.com	\N	1979-08-29 00:00:00		2025-05-03 20:50:50.417	2025-05-03 20:50:50.417	\N
340cdc80-1796-4791-9b1c-b3c7f4482fd6	Madai	Ovalle		\N	\N	\N		2025-05-03 20:50:50.417	2025-05-03 20:50:50.417	\N
8e2b9af5-a0cc-4e4d-970d-93ece89ca949	Madai	Ovalle Telles		enfermeramadai@gmail.com	\N	1987-05-25 00:00:00		2025-05-03 20:50:50.417	2025-05-03 20:50:50.417	\N
1146c537-9721-4fd8-af11-4982d1841123	Maria del Rosario	Franco Crúz		\N	\N	\N		2025-05-03 20:50:50.417	2025-05-03 20:50:50.417	\N
c391ad22-bc52-40e5-81d1-b5d4c30f2d29	Laura	Sigon		xlaurix@hotmail.com	\N	1962-05-20 00:00:00		2025-05-03 20:50:50.418	2025-05-03 20:50:50.418	\N
34d0c9d6-4d2c-46f2-a2a1-b3d88a69070c	Ma Guadalupe	Sanchez Cordova		africazyw@hotmail.com	3221358113	1964-06-08 00:00:00		2025-05-03 20:50:50.418	2025-05-03 20:50:50.418	\N
ef2a080b-bf6b-47a1-a43a-69b782f3116f	Marcelina	Rodriguez Rodriguez		\N	\N	1958-07-13 00:00:00		2025-05-03 20:50:50.419	2025-05-03 20:50:50.419	\N
bb257175-5a99-460e-897f-56cf9d25b503	Tania	Aleman de la Crúz		tanialeman_80@hotmail.com	3292981087	1980-07-30 00:00:00		2025-05-03 20:50:50.419	2025-05-03 20:50:50.419	\N
d949f01d-ea21-4b39-95a3-54a2db077e4b	Laura	Hernandez		\N	\N	\N		2025-05-03 20:50:50.419	2025-05-03 20:50:50.419	\N
aa8e230a-2f3f-400c-bf5e-8cfb1afde5cb	Rodolfo	Tello Lazcano		\N	\N	1941-08-12 00:00:00		2025-05-03 20:50:50.419	2025-05-03 20:50:50.419	\N
fd7c7ef1-5399-4360-8040-8353980fd967	Lisette Areceli	Murillo Tobar		\N	\N	\N		2025-05-03 20:50:50.42	2025-05-03 20:50:50.42	\N
6b028334-a42d-40eb-8947-777b7d76eff7	Maria Luisa	Crúz		\N	\N	\N		2025-05-03 20:50:50.42	2025-05-03 20:50:50.42	\N
4cb85ec4-4d01-4b87-8c92-c2197b2afdf9	Maria del Rocio	Jardinez Marin		\N	\N	1963-07-25 00:00:00		2025-05-03 20:50:50.42	2025-05-03 20:50:50.42	\N
5ba7fc22-a7a5-4849-a061-18071587d70e	Rafael	Arciniega		\N	\N	\N		2025-05-03 20:50:50.421	2025-05-03 20:50:50.421	\N
8339a792-57b9-4070-b751-926bf38900c7	Roberto	Gallardo Ramires		\N	\N	\N		2025-05-03 20:50:50.421	2025-05-03 20:50:50.421	\N
103e54c3-f6b2-4d36-8c06-d655fcf338de	Victor Hugo	Fernandez Haró		vicski72@me.com	\N	1972-12-18 00:00:00		2025-05-03 20:50:50.421	2025-05-03 20:50:50.421	\N
06e7f3fe-6652-405e-8ebb-2f44302d936f	Mari Cruz	Rosales		\N	\N	\N		2025-05-03 20:50:50.422	2025-05-03 20:50:50.422	\N
47b59f44-22e4-4930-92eb-eea82198d235	Martha	Lerma		\N	\N	\N		2025-05-03 20:50:50.422	2025-05-03 20:50:50.422	\N
5b5512c4-ac1e-43a5-ba23-b30b74e07256	Patricia	Mendez Moreno		patuca_511@hotmail.com	\N	1984-11-05 00:00:00		2025-05-03 20:50:50.422	2025-05-03 20:50:50.422	\N
15453101-ee69-415d-9b46-4dd8cb971a14	Rosalia	Lozano		\N	\N	\N		2025-05-03 20:50:50.423	2025-05-03 20:50:50.423	\N
5ba047f3-ed98-477f-a016-452422ae7265	Paula	Peña Esparza		\N	\N	\N		2025-05-03 20:50:50.423	2025-05-03 20:50:50.423	\N
c34d9b25-cd84-46d0-ad1a-a14fff3fc4b8	Maria	Pasillas		\N	\N	1955-05-14 00:00:00		2025-05-03 20:50:50.423	2025-05-03 20:50:50.423	\N
9ee2487f-a49c-489b-aed3-83134935b757	Nicolas	Hervd		\N	\N	\N		2025-05-03 20:50:50.423	2025-05-03 20:50:50.423	\N
4c309342-7a9b-4083-99a4-ec53cd68469b	Mallela	García Chavez		\N	\N	\N		2025-05-03 20:50:50.424	2025-05-03 20:50:50.424	\N
d6ea674e-6597-4b95-aed5-c86f3f99a9d3	Ramon Edgar	Perez peña		rpsmailey@gma.com	\N	1983-07-17 00:00:00		2025-05-03 20:50:50.424	2025-05-03 20:50:50.424	\N
4b3f9629-e9ad-4bc9-855b-f2445f75295f	Wayne	York		\N	3222797790	1968-09-20 00:00:00		2025-05-03 20:50:50.424	2025-05-03 20:50:50.424	\N
704aef43-0cfd-437c-a9f2-7c5d08d51e91	Tabata	Sanchez montaño		\N	\N	\N		2025-05-03 20:50:50.425	2025-05-03 20:50:50.425	\N
838466b7-8fcb-4574-8338-8cc0b67d6a11	Ofelia	García Piqué		\N	\N	1953-12-09 00:00:00		2025-05-03 20:50:50.425	2025-05-03 20:50:50.425	\N
3c272f8f-37a1-49b8-8997-a890c55dbfbd	Maria Guadalupe	Valdez López		\N	\N	1980-12-07 00:00:00		2025-05-03 20:50:50.425	2025-05-03 20:50:50.425	\N
03028ef6-eb5e-495d-99b5-4921a245b1eb	Liz	Olivares Pelayo		\N	\N	1981-05-26 00:00:00		2025-05-03 20:50:50.426	2025-05-03 20:50:50.426	\N
eecc1586-7ccf-4691-a5ea-842699fb66d2	Marcos	Castañeda Ramirez		maico.cr_07_@gmail.com	\N	1984-03-07 00:00:00		2025-05-03 20:50:50.426	2025-05-03 20:50:50.426	\N
9500d9f6-ff04-420d-8446-15b732fa9180	Martha Elena	Orta Cabrera		luna_azul02@hotmail.cm	\N	1973-11-10 00:00:00		2025-05-03 20:50:50.426	2025-05-03 20:50:50.426	\N
f70d07bb-88fe-478e-8a2f-d9be1ebda40d	Yesenia	Mendoza Gomez		\N	\N	\N		2025-05-03 20:50:50.427	2025-05-03 20:50:50.427	\N
e203e279-b229-4813-bcf5-725554f24d00	Karina	Carmona Alejandre		soliakarina@hotmail.com	\N	1982-10-23 00:00:00		2025-05-03 20:50:50.427	2025-05-03 20:50:50.427	\N
1d720eb9-bbf3-44cb-b03f-c55219ed6905	Luis	Rincon		rincon.lg@gmail.com	3292982460	1948-09-24 00:00:00		2025-05-03 20:50:50.427	2025-05-03 20:50:50.427	\N
51046dcb-1572-4c30-ab0f-e2706903727e	Karen	Alvarez Sambran		karenalza@hotmail.com	3292985057	\N		2025-05-03 20:50:50.428	2025-05-03 20:50:50.428	\N
63567733-091c-4811-aa45-079d821d5057	Octavio	Victal García		\N	\N	\N		2025-05-03 20:50:50.428	2025-05-03 20:50:50.428	\N
3dd733c2-ba05-4187-aef0-0bbaf9e8e2da	Sergio	Velasquez Bonilla		\N	\N	1976-09-07 00:00:00		2025-05-03 20:50:50.428	2025-05-03 20:50:50.428	\N
0a551c40-b0d3-421d-8815-deaf6d478bfe	Laurence	Tanguey		\N	\N	\N		2025-05-03 20:50:50.429	2025-05-03 20:50:50.429	\N
1b34da1a-3a97-4d2c-9dfc-e9d5a9dce823	Keren	Troy		\N	\N	\N		2025-05-03 20:50:50.43	2025-05-03 20:50:50.43	\N
e08369bc-84a7-4c93-97dd-1126af529431	Luis Federico	Jimenez Betancurt		\N	\N	\N		2025-05-03 20:50:50.43	2025-05-03 20:50:50.43	\N
45d855ae-25fc-429c-9542-d3f59db2d606	Pablo	Bajonero R.		\N	\N	\N		2025-05-03 20:50:50.431	2025-05-03 20:50:50.431	\N
361b8df5-6399-47b6-8e10-bf2ea5df42fa	Sandra NoemI	Sanchez Perez		\N	\N	\N		2025-05-03 20:50:50.431	2025-05-03 20:50:50.431	\N
3755a4d5-c40a-4fbf-bcc6-7024cc1a4394	Marta Victoria	Martínez Villalobos		mvmvictoria@msn.com	\N	\N		2025-05-03 20:50:50.431	2025-05-03 20:50:50.431	\N
a1b8cbcf-7d22-4184-b400-febf2c4b3551	Rosmary	Morales		\N	\N	\N		2025-05-03 20:50:50.432	2025-05-03 20:50:50.432	\N
28c76fdd-b58b-4f92-b621-9309253b6eb8	Pedro adan	Villaseñor Lascano		\N	\N	2007-01-23 00:00:00		2025-05-03 20:50:50.432	2025-05-03 20:50:50.432	\N
b0151079-c583-4670-8783-dfeeb8dafc26	Ruth	hinckfus		\N	\N	\N		2025-05-03 20:50:50.432	2025-05-03 20:50:50.432	\N
78bf7445-1407-4e7b-9dc6-603f3343d69a	Marco Antonio	Vazques		\N	\N	1979-08-13 00:00:00		2025-05-03 20:50:50.432	2025-05-03 20:50:50.432	\N
cae0970c-95c1-48eb-b306-d0a79f2a40eb	Mariana	Martinez Madero		mmm_824@hotmail.com	\N	1982-06-04 00:00:00		2025-05-03 20:50:50.433	2025-05-03 20:50:50.433	\N
93137880-60d7-4639-80e9-1c2c0be1485c	Sara	willkins		princesasarita@gmail.com	\N	1974-07-06 00:00:00		2025-05-03 20:50:50.433	2025-05-03 20:50:50.433	\N
ba040662-58cb-4c16-8ecd-a3f7d7bbed41	Veronica	Villalobos Moreno		\N	\N	\N		2025-05-03 20:50:50.433	2025-05-03 20:50:50.433	\N
9e770a2a-68a0-492b-82d5-96c6856fd4f7	Paricia	de fer		\N	\N	\N		2025-05-03 20:50:50.434	2025-05-03 20:50:50.434	\N
640b4233-fd3f-4b8f-92d7-099cf4c9e8d3	Susy	Bargas		\N	\N	\N		2025-05-03 20:50:50.434	2025-05-03 20:50:50.434	\N
60394fa5-7265-4a54-bce3-779800bc1b54	Norma	Portillo Gutierrez		normaportillog@hotmail.com	\N	1969-02-08 00:00:00		2025-05-03 20:50:50.434	2025-05-03 20:50:50.434	\N
7664f510-0e06-4a35-a59e-8b71d6c58af7	Maryli	Branch		mbranch3@cox.net	3222215511	1936-01-13 00:00:00		2025-05-03 20:50:50.435	2025-05-03 20:50:50.435	\N
5544d362-2013-41fe-8497-03dcb384796c	Patricia	Jimenes		\N	\N	\N		2025-05-03 20:50:50.435	2025-05-03 20:50:50.435	\N
c6c5c618-0378-409e-8646-0aaad0145e3b	Martha	Ruelas Garcia		yita1211@hotmail.com	\N	1966-11-10 00:00:00		2025-05-03 20:50:50.435	2025-05-03 20:50:50.435	\N
90b198c9-fc23-405c-8c94-847ea83b2211	Ruben Omar	Mico		rubenmicomex@hotmail.com	3221168357	1964-10-23 00:00:00		2025-05-03 20:50:50.436	2025-05-03 20:50:50.436	\N
d52f0c67-84e2-4f01-a4fe-a2be3a183fd2	Julio Cesar	Jimenez		\N	\N	\N		2025-05-03 20:50:50.436	2025-05-03 20:50:50.436	\N
27667e49-36ab-4721-ab0b-47ca562ade88	Norberto	Torres Magaña		\N	\N	\N		2025-05-03 20:50:50.436	2025-05-03 20:50:50.436	\N
4ab52a80-9d63-4284-b8e2-facd85014d6e	Maria del Consuelo	Rodriguez Rodriguez		\N	\N	1950-08-27 00:00:00		2025-05-03 20:50:50.437	2025-05-03 20:50:50.437	\N
1bc2a190-93c6-4d44-a5c9-cfa1d1c33ef2	Ramon	Marmolejo		\N	\N	\N		2025-05-03 20:50:50.437	2025-05-03 20:50:50.437	\N
0f7d1cbb-bdc6-44da-834c-a5953f2b5626	Simone	Dulac		\N	\N	1935-12-18 00:00:00		2025-05-03 20:50:50.437	2025-05-03 20:50:50.437	\N
51753845-971d-4662-8a17-3a4b683169d8	Vicky	Adams		\N	\N	\N		2025-05-03 20:50:50.437	2025-05-03 20:50:50.437	\N
78684ddd-3def-4dee-88a5-e8094aa7d24e	Maria Isabel	Zavala Chavez		isabel.2084@hotmail.com	\N	1984-02-20 00:00:00		2025-05-03 20:50:50.438	2025-05-03 20:50:50.438	\N
440fb79f-66e8-49a9-80c8-753bdfd5a0eb	Rosario	jara Avalos		\N	\N	1971-04-29 00:00:00		2025-05-03 20:50:50.438	2025-05-03 20:50:50.438	\N
6727fdc2-811a-481c-92f5-4f5ac2ff9af8	Kay	Almeida		\N	\N	1977-07-05 00:00:00		2025-05-03 20:50:50.438	2025-05-03 20:50:50.438	\N
ecaf27e0-efb0-48c6-ae4f-586554e50da3	Miguel	Salazar Riso		rizzosami@hotmail.com	\N	1959-11-01 00:00:00		2025-05-03 20:50:50.439	2025-05-03 20:50:50.439	\N
78920333-ed22-40c5-8391-ae56516a2574	Monic	Chagmon		\N	\N	\N		2025-05-03 20:50:50.439	2025-05-03 20:50:50.439	\N
d8fc8f19-6ac8-46a1-99e3-bc6ccc1db674	Monique	Chagnon		chagnon67@videotron.ca	\N	\N		2025-05-03 20:50:50.439	2025-05-03 20:50:50.439	\N
1457a23d-740d-4170-8e96-eb97e0b430f7	Rocio	Lopez		rociolopezlepe@gmail.com	\N	1982-11-01 00:00:00		2025-05-03 20:50:50.44	2025-05-03 20:50:50.44	\N
e523ac44-e5c2-4a55-aec3-a716d837c264	Maria Francisca	Hermosillo Rivera		\N	\N	\N		2025-05-03 20:50:50.44	2025-05-03 20:50:50.44	\N
94d190cc-b4f0-4392-9573-a59bc5f33c3c	Neil	Thomassen		nealthomassen@hotmail.com	\N	1952-04-05 00:00:00		2025-05-03 20:50:50.44	2025-05-03 20:50:50.44	\N
5b6f0491-981a-4d6f-bf54-a40fb4cb420a	Judiht	Almazan Acuña		\N	\N	\N		2025-05-03 20:50:50.441	2025-05-03 20:50:50.441	\N
761963db-62a8-4c87-a38a-facdd8422c3b	Larry	Stanberg		larry158958@gmail.com	3222383281	\N		2025-05-03 20:50:50.441	2025-05-03 20:50:50.441	\N
87565517-3f18-4507-8da6-52aa4f5ab24c	Rosa Isela	Diaz Gaytan		\N	3221140555	\N		2025-05-03 20:50:50.441	2025-05-03 20:50:50.441	\N
b7653de0-4dc2-42bc-acb4-65ed8b0c84af	Tania	Gomez Navarro		\N	\N	1987-05-01 00:00:00		2025-05-03 20:50:50.442	2025-05-03 20:50:50.442	\N
f9542603-42fc-4720-b910-23573f85c8de	Julio Enrrique	Abando Cardenas		\N	\N	1982-04-13 00:00:00		2025-05-03 20:50:50.442	2025-05-03 20:50:50.442	\N
cd7ab8c9-531a-4eb8-91c9-32f0d255fcc2	Rosa Elena	Orta Cabrera		\N	\N	1973-11-10 00:00:00		2025-05-03 20:50:50.442	2025-05-03 20:50:50.442	\N
93a029e3-1c4f-4645-8a01-fd88bc904f29	Pablo	Colmenares Ruíz		pablocolmenares49@yahoo.com.mx	\N	1975-10-13 00:00:00		2025-05-03 20:50:50.443	2025-05-03 20:50:50.443	\N
500d4d96-66ec-44c9-88d3-cdbb834205e7	Susana	Ceja Contreras		\N	\N	\N		2025-05-03 20:50:50.443	2025-05-03 20:50:50.443	\N
f54cc370-cc0e-42e4-a2be-3145de389f61	Karla	Martinez Lopez		siomarahernandez@autlook.com.mx	\N	1981-05-14 00:00:00		2025-05-03 20:50:50.443	2025-05-03 20:50:50.443	\N
83b8793e-2d9c-450a-8b7e-b816d0dcacf2	Lorena	Caballero Moreno		\N	\N	\N		2025-05-03 20:50:50.443	2025-05-03 20:50:50.443	\N
3df8c151-8fef-47ac-baaf-f3265f2dde4c	Marisol	Rodriguez Castillo		marisol-0911@hotmail.com	\N	1985-09-11 00:00:00		2025-05-03 20:50:50.444	2025-05-03 20:50:50.444	\N
6f392ffe-e122-4dd9-b4fa-d07b6eb2da2a	Maricela	Santana Figeroa		marisantana_@hotmail.com	\N	1980-12-08 00:00:00		2025-05-03 20:50:50.444	2025-05-03 20:50:50.444	\N
5289cc54-423c-4100-bce8-9608d5cfb836	Rosendo	Villegas		\N	\N	1968-08-03 00:00:00		2025-05-03 20:50:50.444	2025-05-03 20:50:50.444	\N
92a0def7-8c48-4157-b69d-7792c92b01d4	Ludivina	Gabrielli Arellano		ludy_gabrielli@hotmil.com	\N	1990-02-13 00:00:00		2025-05-03 20:50:50.445	2025-05-03 20:50:50.445	\N
0398c159-86ef-4e74-94fa-fd80dd97571c	Julia Anahï	López Ponce		\N	\N	1997-08-17 00:00:00		2025-05-03 20:50:50.445	2025-05-03 20:50:50.445	\N
58b36772-6206-4ceb-921b-91927c3ee3ac	Regina	Ruíz Zepeda		\N	\N	1955-02-07 00:00:00		2025-05-03 20:50:50.446	2025-05-03 20:50:50.446	\N
0b750ff3-c852-4e19-9952-449327f43771	Kritzia	Barrientos Eggers		kritzia.b.b.e@gmail.com	\N	1991-06-06 00:00:00		2025-05-03 20:50:50.446	2025-05-03 20:50:50.446	\N
42c3ea1f-bcb5-44b6-ac1d-3d2311658e13	Rosario	Galindo Vega		\N	\N	1973-12-29 00:00:00		2025-05-03 20:50:50.446	2025-05-03 20:50:50.446	\N
3cc98aeb-2389-4ac3-8d36-106e25e68adb	Oneida	Curiel Castro		oneida.castro.@gmail.cm	\N	1984-01-06 00:00:00		2025-05-03 20:50:50.446	2025-05-03 20:50:50.446	\N
0998c8fb-2f26-4de9-a663-3e17eef018b2	Robert	Bussinger		rbussiinger@hotmail.com	\N	1968-03-16 00:00:00		2025-05-03 20:50:50.447	2025-05-03 20:50:50.447	\N
3d667f3a-00f8-41ab-9924-5d891479998f	Kitzia Denisse	Acosta Payan		\N	\N	1999-01-17 00:00:00		2025-05-03 20:50:50.447	2025-05-03 20:50:50.447	\N
8d7dc0f5-986e-422f-a5a7-2e14e985e767	Maria Fernanda	Arjona Mercado		\N	\N	\N		2025-05-03 20:50:50.447	2025-05-03 20:50:50.447	\N
2aa4e544-b166-467d-9314-b47982551490	Maria Fernanda	Vera Mendoza		\N	\N	\N		2025-05-03 20:50:50.448	2025-05-03 20:50:50.448	\N
68ff8c40-5e01-45ad-8236-addd0c4dede1	Rosa María	García Radillo		\N	\N	1954-07-11 00:00:00		2025-05-03 20:50:50.448	2025-05-03 20:50:50.448	\N
9f724ca7-183f-4e4a-b6e1-83aaf6da21b5	Paloma	Becerra		\N	\N	\N		2025-05-03 20:50:50.448	2025-05-03 20:50:50.448	\N
9d1cae91-f443-4ae2-a6eb-c4cd3ef11d34	Luis Alberto	Rámirez Ipiales		\N	3221482137	1972-08-26 00:00:00		2025-05-03 20:50:50.449	2025-05-03 20:50:50.449	\N
fd4c25e7-fed7-4c74-ac3f-01fb52dc8c00	Leticia	Cervantes Zepeda		\N	\N	1965-11-04 00:00:00		2025-05-03 20:50:50.449	2025-05-03 20:50:50.449	\N
4e868171-1fe4-4c70-acac-de6530a50bff	Maria Luisa	Viteri  Gonzales		luisaviteri@gmail.com	3292912088	1960-02-03 00:00:00		2025-05-03 20:50:50.449	2025-05-03 20:50:50.449	\N
fb5ecc3b-7bec-4e4e-9a00-f010318c060d	Nicole	Vallieres		vallieresnic@hotmail.com	\N	1952-04-21 00:00:00		2025-05-03 20:50:50.45	2025-05-03 20:50:50.45	\N
639e43bd-2176-4258-a37d-13dc2282ca74	Oscar	Garcia		\N	\N	\N		2025-05-03 20:50:50.45	2025-05-03 20:50:50.45	\N
7f338a21-50b9-4d85-9d7e-284d52fd97cc	Lizette yajaira	García Aragón		\N	\N	2001-09-01 00:00:00		2025-05-03 20:50:50.45	2025-05-03 20:50:50.45	\N
cfc16a7a-dbeb-4028-8b14-f27ba8bb7091	María José	Castro Tomati		cote2106@gmail.com	\N	1979-06-25 00:00:00		2025-05-03 20:50:50.451	2025-05-03 20:50:50.451	\N
aa80ef36-ad8b-4c5a-9935-7a564e99babc	Walther	Cervantes Torres		\N	\N	1983-03-27 00:00:00		2025-05-03 20:50:50.451	2025-05-03 20:50:50.451	\N
efd3d719-bb53-44fe-a68e-86d593553e63	Sonny	Viteri Chenery		sunny.viteri@gmail.com	3221355150	1980-10-10 00:00:00		2025-05-03 20:50:50.451	2025-05-03 20:50:50.451	\N
f357da82-a4ab-409f-8172-2553749775e1	Maria de Jesus	Monteon		\N	\N	\N		2025-05-03 20:50:50.451	2025-05-03 20:50:50.451	\N
687c14c1-c212-4db7-81ea-467fb5ae2c44	Maribel	Sanciprian López		msleluxa@gmail.com	3221812769	1986-10-04 00:00:00		2025-05-03 20:50:50.452	2025-05-03 20:50:50.452	\N
4aff0f5a-6ead-4f97-92dd-8a82076c39ec	Rodolfo	Rabadan		\N	\N	\N		2025-05-03 20:50:50.452	2025-05-03 20:50:50.452	\N
af40773e-7b66-43f0-804c-996bb198671b	Tomas	Morales		\N	\N	\N		2025-05-03 20:50:50.452	2025-05-03 20:50:50.452	\N
bd260811-a068-49eb-bd4e-03a8a962978a	Rosa Idalia	Rojas Casillas		\N	\N	\N		2025-05-03 20:50:50.453	2025-05-03 20:50:50.453	\N
7525b948-897d-4ebc-916f-db9306c108f2	Liliana	Adame Mondragon		liliana70mx@hotmail.com	\N	1977-04-03 00:00:00		2025-05-03 20:50:50.453	2025-05-03 20:50:50.453	\N
c1ea8ad1-1616-4bc3-b4dd-ef573a16e2f9	Martha Maria	Flores Aguirre		\N	\N	1977-11-07 00:00:00		2025-05-03 20:50:50.453	2025-05-03 20:50:50.453	\N
352cfa93-a46a-4bd8-9fc3-88a6ce5b602c	Rosario	Alonzo Villa		\N	\N	\N		2025-05-03 20:50:50.454	2025-05-03 20:50:50.454	\N
f886fa50-1529-4a98-bb1e-d24c8dab7f97	Raúl	Plumaperez Millan		plumaperez@hotmail.com	3222890769	1976-04-22 00:00:00		2025-05-03 20:50:50.454	2025-05-03 20:50:50.454	\N
e9a47f9f-68b4-4c5f-bf5c-bbadc56b4b0f	Trinidad	Davila Gonzalez		\N	\N	1980-05-18 00:00:00		2025-05-03 20:50:50.454	2025-05-03 20:50:50.454	\N
c99649e4-6e89-4a9e-a460-abaff8bcb295	Marlene	Cavangh Dawson		\N	\N	\N		2025-05-03 20:50:50.455	2025-05-03 20:50:50.455	\N
5100ce1a-423e-4e3f-9dae-a2ab69cd7e45	Luis Francisco	Martinez Medina		paco.lorearte@gmail.com	\N	\N		2025-05-03 20:50:50.455	2025-05-03 20:50:50.455	\N
14060238-7697-4409-8dca-a3222f34e6c1	Lorena Elizabeth	Barreto Hernández		\N	\N	1985-10-31 00:00:00		2025-05-03 20:50:50.455	2025-05-03 20:50:50.455	\N
6d186505-dc79-4930-a380-055c38e687e4	Maria de Jesus	Monteon Peréz		\N	\N	\N		2025-05-03 20:50:50.456	2025-05-03 20:50:50.456	\N
99de8f90-0c99-4e76-8ded-625b037533e4	Victor Hugo	Espino Rivera		espinov5569@yahoo.com	\N	1971-10-04 00:00:00		2025-05-03 20:50:50.456	2025-05-03 20:50:50.456	\N
f6c2b134-5386-406d-8269-0e0336f49363	Leonardo Gamaliel	Gutierrez Pérez		dekoramueblerias@hotmil.com	\N	1979-05-07 00:00:00		2025-05-03 20:50:50.456	2025-05-03 20:50:50.456	\N
98160e34-3275-4304-9a06-2c653aa80167	Marta Victoria	Martinez Villalobos		\N	\N	\N		2025-05-03 20:50:50.457	2025-05-03 20:50:50.457	\N
f283411b-cbf1-4c51-acef-8e8dad27c5c0	Oscar Adrian	Rolon García		elalubno777@gmail.com	\N	1982-06-20 00:00:00		2025-05-03 20:50:50.457	2025-05-03 20:50:50.457	\N
e40071a0-991b-45b2-aaa6-f1daf67956a3	Sandra Ester	Ramirez Sanches		sandraramire@yahoo.com.mx	3222977231	1961-12-20 00:00:00		2025-05-03 20:50:50.457	2025-05-03 20:50:50.457	\N
015d66fa-e483-435d-92ba-d4ee16200c7b	Santos	Avila Ponce		\N	\N	\N		2025-05-03 20:50:50.457	2025-05-03 20:50:50.457	\N
df061f47-14fc-4e03-a999-0d79877edd59	Nueriel	Stilson		\N	\N	\N		2025-05-03 20:50:50.458	2025-05-03 20:50:50.458	\N
6ef2261b-9c30-48ac-a0f2-1f067820a5a3	Maribel	Avila Saldivar		maribelavila@autlook.es	\N	1974-12-13 00:00:00		2025-05-03 20:50:50.458	2025-05-03 20:50:50.458	\N
40be434c-6534-4c77-ab4b-f7e6eec17a1b	Susan	Macey		bmacey@telusplanet.net	3223804336	1961-08-28 00:00:00		2025-05-03 20:50:50.458	2025-05-03 20:50:50.458	\N
5c94688b-c311-4683-b244-ca8fba4f8375	Maria del Refugio	Verdin Felix		\N	\N	\N		2025-05-03 20:50:50.459	2025-05-03 20:50:50.459	\N
54f98021-3b8c-4559-9b6f-b783da644624	Silver	Laberdi		\N	\N	\N		2025-05-03 20:50:50.459	2025-05-03 20:50:50.459	\N
72b0c40f-6e8b-48c8-b1df-ae2b224f0219	Maria del Pilar	Cabrera de Orta		\N	\N	1945-12-30 00:00:00		2025-05-03 20:50:50.46	2025-05-03 20:50:50.46	\N
549098f3-4589-4334-8830-e758e30ee6f6	Roseanna	Singh   Doobay		\N	\N	\N		2025-05-03 20:50:50.46	2025-05-03 20:50:50.46	\N
6745d324-a2e5-4db7-b8bf-713ff0677e55	Mari Cruz	Aguilar Velasquez		\N	\N	1985-04-25 00:00:00		2025-05-03 20:50:50.46	2025-05-03 20:50:50.46	\N
35cbe204-e147-4dd5-a866-183d215f4a14	Mario	Gutierrez García		\N	\N	1952-12-05 00:00:00		2025-05-03 20:50:50.46	2025-05-03 20:50:50.46	\N
9fe382bd-1601-4442-a0bf-edf6b3e8a838	Kenneth	Gingerich		juslidat@gmail.com	3221813740	1944-02-10 00:00:00		2025-05-03 20:50:50.461	2025-05-03 20:50:50.461	\N
55c31323-bdb8-4462-892d-e5271bc0f4bf	María Olivia	Perez Palomera		\N	\N	1957-10-18 00:00:00		2025-05-03 20:50:50.461	2025-05-03 20:50:50.461	\N
72d582df-dcf1-44f7-8031-2f2d1ca04e1a	Maclovio	Castellón Morales		mc-castellon@hotmail.com	3221491439	1978-11-27 00:00:00		2025-05-03 20:50:50.461	2025-05-03 20:50:50.461	\N
8619cccb-1cf1-4dfc-9888-ecd9171f00e4	Tadis Yanely	Reyes Vergara		\N	\N	2009-07-14 00:00:00		2025-05-03 20:50:50.462	2025-05-03 20:50:50.462	\N
6ec29def-969f-4654-9a26-a7c0c100a348	Luis Antonio	Miranda Borrayo		luisambo35@gmail.com	\N	1994-09-15 00:00:00		2025-05-03 20:50:50.462	2025-05-03 20:50:50.462	\N
3860b825-f547-438f-afe8-ff66418e2794	Luis Felipe	Macias Reynoso		freestyle1999@live.com.mx	\N	1999-07-26 00:00:00		2025-05-03 20:50:50.462	2025-05-03 20:50:50.462	\N
f0afd4d9-7dda-40b7-83ed-6d34dfb04c22	Pedro	Lee		\N	\N	1985-07-06 00:00:00		2025-05-03 20:50:50.463	2025-05-03 20:50:50.463	\N
67040687-da74-40e6-9b89-a45fbe4f19b6	Victor	Wollman		mechvic@yahoo.com	\N	1955-11-21 00:00:00		2025-05-03 20:50:50.463	2025-05-03 20:50:50.463	\N
362a21ff-ee33-46c3-8904-9a54db0e7dba	Rosa Isela	Espinoza Razo		\N	\N	1974-10-24 00:00:00		2025-05-03 20:50:50.463	2025-05-03 20:50:50.463	\N
87f62423-68e3-4794-b4c8-8bee0870d961	Luis Antonio	Castillo Gómez		\N	3222992029	\N		2025-05-03 20:50:50.464	2025-05-03 20:50:50.464	\N
218f2b66-bccf-44e5-8c30-f263e8aa02ec	Julieta	Centeno Montero		\N	\N	\N		2025-05-03 20:50:50.464	2025-05-03 20:50:50.464	\N
4b17ab8d-8557-49b9-a1bf-f37d3715f589	Miriam	Olivares Perez		miri04_@hotmail.com	\N	1985-12-04 00:00:00		2025-05-03 20:50:50.464	2025-05-03 20:50:50.464	\N
a5b7b8ca-f6b5-4727-8fd1-f426effc2e64	Victor	García Palomera		victor_garcia_palomera@hotmai.com	\N	1987-12-23 00:00:00		2025-05-03 20:50:50.464	2025-05-03 20:50:50.464	\N
7278f8d2-da41-4194-88ac-68c2dca080bf	Yadira	Peña Lomeli		\N	\N	\N		2025-05-03 20:50:50.465	2025-05-03 20:50:50.465	\N
dceae533-6a8b-4cb2-92db-2de2d7bb9bcb	Karla	Muñoz Gonzalez		\N	\N	\N		2025-05-03 20:50:50.465	2025-05-03 20:50:50.465	\N
4bef9517-3afe-4998-89e5-965a35071715	Teresa	Zamora Torrez		\N	\N	\N		2025-05-03 20:50:50.465	2025-05-03 20:50:50.465	\N
b83fdfb6-36d1-4aaa-a9fe-d12d80263815	Mario Oscar	Sandoval Gomez		\N	3222247158	\N		2025-05-03 20:50:50.466	2025-05-03 20:50:50.466	\N
dcdb3277-c04e-4c1d-833f-ec8685e96511	Segio Fernando	López Cortez.		\N	\N	1962-07-06 00:00:00		2025-05-03 20:50:50.466	2025-05-03 20:50:50.466	\N
8b1016b5-6839-45a0-bfab-2eaaa12b178c	Telesforo	Manzano Gonzalez		\N	\N	1934-05-22 00:00:00		2025-05-03 20:50:50.466	2025-05-03 20:50:50.466	\N
00f61d75-36ee-44b7-9bea-3f00da46cfc9	Perla Esmeralda	Sandoval Rodriguez		perlasdivinas18@hotmail.com	\N	2000-11-18 00:00:00		2025-05-03 20:50:50.467	2025-05-03 20:50:50.467	\N
fb42c0c9-f518-4d00-beae-6d4373a53b2c	Mercedes	Duran Uribe		merceditas1801@hotmail.com	\N	1971-01-18 00:00:00		2025-05-03 20:50:50.467	2025-05-03 20:50:50.467	\N
65317286-ea0e-4b34-b865-e6a8fb833f45	Nurit Itzal	Crúz Montes		\N	\N	2011-02-16 00:00:00		2025-05-03 20:50:50.467	2025-05-03 20:50:50.467	\N
85a54d96-bf61-48ec-90ec-0f9db702cb73	Sergio Fernando	Lopéz Córtez		sergio_optico@hotmail.com	3221819940	1962-07-06 00:00:00		2025-05-03 20:50:50.467	2025-05-03 20:50:50.467	\N
2411379f-ab07-4f93-9dc6-a25bbb76e99c	Pamela	Zepeda Delvalle		pzepedav@gmail.com	523221384061	1987-03-03 00:00:00		2025-05-03 20:50:50.468	2025-05-03 20:50:50.468	\N
1d42dd8e-c620-4567-8fd9-6ef9e6676ff0	Juan Pablo	Macias Verdusco		maciasjp@hotmail.com	\N	1974-03-31 00:00:00		2025-05-03 20:50:50.468	2025-05-03 20:50:50.468	\N
25b07111-4c89-476d-9b83-4fcca6f18170	Laura Araceli	Gonzales Carrillo		\N	\N	1980-08-17 00:00:00		2025-05-03 20:50:50.468	2025-05-03 20:50:50.468	\N
2b8f2e10-ee55-4c3e-8713-88f32526aaee	Laura Elena	Zamora Zatarain		karliligz@hotmail.com	\N	1964-02-07 00:00:00		2025-05-03 20:50:50.469	2025-05-03 20:50:50.469	\N
03c17121-bf37-4ba2-a08f-18d4b31ec5b4	Mauricio	Vargas Gonzales		\N	\N	1955-02-28 00:00:00		2025-05-03 20:50:50.469	2025-05-03 20:50:50.469	\N
97c4b6dd-e45d-48ce-b3cd-ad5419413f84	Soledad	Rivera Santana		\N	\N	1931-12-20 00:00:00		2025-05-03 20:50:50.469	2025-05-03 20:50:50.469	\N
01a1f1a7-f3e3-44af-8074-468e4003bc84	Maria Victoria	Frias Curiel		vikyfrias@hotmail.com	013292965037	1964-01-08 00:00:00		2025-05-03 20:50:50.47	2025-05-03 20:50:50.47	\N
ebc44b39-c853-42ca-9375-b17839f0e23d	Sebastian	Martinez Valades		\N	\N	\N		2025-05-03 20:50:50.47	2025-05-03 20:50:50.47	\N
7956065e-df26-4c05-a596-82c4751e37d7	Nicolas	Rosas Ortiz		nicorx1@live.com	\N	1983-10-29 00:00:00		2025-05-03 20:50:50.47	2025-05-03 20:50:50.47	\N
919b9cf9-dbd1-4a8e-9374-2c087fce6025	Maria del Refugio	Placito Amaral		\N	\N	1966-07-28 00:00:00		2025-05-03 20:50:50.471	2025-05-03 20:50:50.471	\N
1bc9b04c-111d-4876-9778-a2b26790281d	Susan	Conmarck		skcormack@shaw.ca	\N	1957-04-15 00:00:00		2025-05-03 20:50:50.471	2025-05-03 20:50:50.471	\N
1c5e4738-da90-4ae0-856d-13a1f641928a	Lilia Kristhell	Reyes Gonzalez		\N	\N	1996-04-15 00:00:00		2025-05-03 20:50:50.471	2025-05-03 20:50:50.471	\N
bb6a585c-8daf-492a-934f-7920540708dd	Maria Carmen	Perez Saucedo		\N	\N	1963-01-16 00:00:00		2025-05-03 20:50:50.471	2025-05-03 20:50:50.471	\N
6e76fbb4-f3c5-4629-ad8d-8f3b40c3f770	Luis	Hewart		\N	\N	\N		2025-05-03 20:50:50.472	2025-05-03 20:50:50.472	\N
0734375e-e456-4146-9ac7-abff737bee94	Louisa	Huard		louisehuard9@hotmail.com	\N	\N		2025-05-03 20:50:50.472	2025-05-03 20:50:50.472	\N
ec245d0c-7c94-46f7-b779-214e65e9b90a	Nayely	Hernández  Lugones		\N	3221267897	1989-10-26 00:00:00		2025-05-03 20:50:50.473	2025-05-03 20:50:50.473	\N
95099ba5-242f-4a73-9c08-86ebf0eaf00f	Leobardo	Ferrer Ortiz		\N	\N	1970-07-24 00:00:00		2025-05-03 20:50:50.473	2025-05-03 20:50:50.473	\N
fe7f70b6-a80e-4e84-a268-dd531c60af36	Raul	Diaz Rueda		\N	\N	\N		2025-05-03 20:50:50.473	2025-05-03 20:50:50.473	\N
c6d06efa-a31b-4c90-938a-29bb121baf03	Maite	Gonzalez Torres		\N	\N	1987-06-02 00:00:00		2025-05-03 20:50:50.473	2025-05-03 20:50:50.473	\N
651284f3-fe9c-46e8-825e-ae5711254219	Miguel	Castellanos Contreras		\N	\N	\N		2025-05-03 20:50:50.474	2025-05-03 20:50:50.474	\N
f9dd7e20-5cdb-4bd6-8dba-6d588c4d4e69	Luis Alberto	Sanchez Anguiar		\N	\N	1986-04-08 00:00:00		2025-05-03 20:50:50.474	2025-05-03 20:50:50.474	\N
14cd91fb-b4f8-4609-84b7-b479758bb06f	Karina	Guitierrez Benitez		carissurf1@hotmail.com	\N	1979-02-24 00:00:00		2025-05-03 20:50:50.474	2025-05-03 20:50:50.474	\N
2ed033a9-7add-4947-8e2b-7df76b74b541	Lucia	Aguilar Gonzales		\N	\N	1972-12-13 00:00:00		2025-05-03 20:50:50.475	2025-05-03 20:50:50.475	\N
58113f53-8c97-4b66-9362-1eb628b069f2	Manuel Maximiliano	Guerrero Aguilar		\N	\N	2006-10-20 00:00:00		2025-05-03 20:50:50.475	2025-05-03 20:50:50.475	\N
e2aa3c17-47e4-4c4a-9804-48427ef7addb	Nicanor	Alejandro López		nick_pumas@hotmail.com	\N	1991-05-22 00:00:00		2025-05-03 20:50:50.475	2025-05-03 20:50:50.475	\N
b888bbb6-9f93-4825-ac49-ed7504222286	Luisa	Jimenez Castillo		\N	\N	1963-04-05 00:00:00		2025-05-03 20:50:50.476	2025-05-03 20:50:50.476	\N
4fd88f3f-2756-4faa-b59f-2e23a9490b88	Maria	Ruiz Vazquez		\N	\N	1969-03-20 00:00:00		2025-05-03 20:50:50.476	2025-05-03 20:50:50.476	\N
9ff9db94-128d-4edc-a73e-76de372efcd6	Marie	Laurent		\N	\N	1948-06-18 00:00:00		2025-05-03 20:50:50.476	2025-05-03 20:50:50.476	\N
80396b29-9a5c-40b6-ad58-bc24a525399d	Salvador	Torres Gonzalez		\N	3221366987	\N		2025-05-03 20:50:50.477	2025-05-03 20:50:50.477	\N
e67be18e-3efb-487e-810a-68a54688d9f0	Luis	Rodriguez Juarez		\N	\N	\N		2025-05-03 20:50:50.477	2025-05-03 20:50:50.477	\N
89e8c96e-2be4-4e22-8b4a-0550bc608e18	Maximiliano	Pitzolo		\N	\N	\N		2025-05-03 20:50:50.477	2025-05-03 20:50:50.477	\N
6acb3e97-29b3-4a91-9a18-cee2039fdeee	Marco Antonio	Becerra García		marco_polo_931902@hotmail.com	\N	1993-02-19 00:00:00		2025-05-03 20:50:50.477	2025-05-03 20:50:50.477	\N
02d9c1b7-ad4b-4fd3-8e05-0528366da6b0	Nancy LIzette	Maldonado Ruiz		\N	\N	\N		2025-05-03 20:50:50.478	2025-05-03 20:50:50.478	\N
49c5db4f-1fd7-4483-8e5f-abee3863e542	Rogelio	Alcalá Corona		\N	\N	1989-11-22 00:00:00		2025-05-03 20:50:50.478	2025-05-03 20:50:50.478	\N
5056e599-bb09-4038-b0c6-17b0ab9b660e	Patricia	Cortez Ceballos		patacortes@hotmail.com	\N	1954-10-03 00:00:00		2025-05-03 20:50:50.478	2025-05-03 20:50:50.478	\N
e3363fc9-78e3-49f0-a08f-3eaa1ab4fc2e	Paloma	Monteón Peréz		paloma130186@live.com.mx	\N	1986-01-13 00:00:00		2025-05-03 20:50:50.479	2025-05-03 20:50:50.479	\N
297f4b5a-bf8e-48d8-831c-5da305f32ac8	Rodrigo	Cortes Fernandez		\N	\N	\N		2025-05-03 20:50:50.479	2025-05-03 20:50:50.479	\N
b0282e14-1861-43b2-be11-520a0fb46422	Roberto	García Reyna		\N	\N	1973-06-13 00:00:00		2025-05-03 20:50:50.479	2025-05-03 20:50:50.479	\N
eb6bd33f-cfb8-4983-8888-b4703829f373	Paola	Sansores López		\N	\N	1971-08-17 00:00:00		2025-05-03 20:50:50.48	2025-05-03 20:50:50.48	\N
8ea1f5f9-ae41-4074-b364-94a2a59f54ec	Sergio	Ramírez López		seramloz79@hotmail.com	\N	1979-06-17 00:00:00		2025-05-03 20:50:50.48	2025-05-03 20:50:50.48	\N
3d472d90-6574-48d8-8997-6b2cc11c36dc	Susana	Goche Diaz		karygoche@hotmail.com	3221337258	1979-10-25 00:00:00		2025-05-03 20:50:50.48	2025-05-03 20:50:50.48	\N
39928218-e20e-4682-8537-299af10d6369	Juan Manuel	Michel Santana		juansas44@hotmail.com	\N	1985-02-27 00:00:00		2025-05-03 20:50:50.481	2025-05-03 20:50:50.481	\N
06983817-e1e8-4169-b655-5c51c9422ff2	Marta Susana	Guerrero Flores		\N	\N	1999-05-08 00:00:00		2025-05-03 20:50:50.481	2025-05-03 20:50:50.481	\N
c98b3599-752e-418d-8862-05349e852605	Paulino	Aguilar		\N	\N	\N		2025-05-03 20:50:50.481	2025-05-03 20:50:50.481	\N
b33db317-1fb6-4d4f-87f9-7f81b8c184ed	Judit	Borrallo Bañuelos		\N	\N	\N		2025-05-03 20:50:50.481	2025-05-03 20:50:50.481	\N
5f36626e-a264-4c6c-8c47-1503830ae4d8	Martin	Pulido		\N	\N	\N		2025-05-03 20:50:50.482	2025-05-03 20:50:50.482	\N
2fbe42e1-72e9-48e1-a0e1-e3463f169948	Noe	Guevara		\N	\N	1990-11-07 00:00:00		2025-05-03 20:50:50.482	2025-05-03 20:50:50.482	\N
07095421-b826-49f9-8407-c3d36a05d223	Laurel	Carrillo Ventura		\N	\N	\N		2025-05-03 20:50:50.482	2025-05-03 20:50:50.482	\N
4ffde8e2-52a4-40ab-8fd0-0dbbc999949b	Patricia	Proulx		\N	\N	\N		2025-05-03 20:50:50.483	2025-05-03 20:50:50.483	\N
2f7e1e2b-0780-4429-bd83-ab6606119961	Michel	Martines Escobar		\N	\N	\N		2025-05-03 20:50:50.483	2025-05-03 20:50:50.483	\N
5922f515-457b-42a7-b012-c2afa499a8c8	Pierrette	Lemay		pierrettelemay@live.ca	\N	1954-09-12 00:00:00		2025-05-03 20:50:50.483	2025-05-03 20:50:50.483	\N
56ddda75-40a5-4af4-9c91-8cdecd07cd31	Shara	León Maya		\N	3221316697	1995-09-02 00:00:00		2025-05-03 20:50:50.484	2025-05-03 20:50:50.484	\N
7d4db3d9-b5ee-4a67-b865-608951a74160	Liliana	Lara		liliana.lara.guzman@hotmail.com	\N	1973-11-16 00:00:00		2025-05-03 20:50:50.484	2025-05-03 20:50:50.484	\N
edba5641-e7b9-4fb7-aa96-c2ab46695d24	Tracy	Chioros		tracychioros@rogers.com	\N	1963-04-28 00:00:00		2025-05-03 20:50:50.484	2025-05-03 20:50:50.484	\N
7b5083c6-e2ec-4f83-9b02-7c43feb97658	Ricardo	Vargas Santos		\N	\N	1996-10-08 00:00:00		2025-05-03 20:50:50.485	2025-05-03 20:50:50.485	\N
ad4e27af-c423-4bca-a18b-860bba7a3dde	Maria de Jesus	Gomez Brambila		\N	\N	\N		2025-05-03 20:50:50.485	2025-05-03 20:50:50.485	\N
5eaed810-0b6e-4fe8-b2fa-65affa9713da	Viridiana	Conde Alonzo		aliz2016@hotmail.com	\N	1989-02-17 00:00:00		2025-05-03 20:50:50.485	2025-05-03 20:50:50.485	\N
2daa87ec-4237-4322-b2c0-e9d20da80c3c	Sarha Paola	Nava Ayala		\N	\N	\N		2025-05-03 20:50:50.485	2025-05-03 20:50:50.485	\N
828329c9-a76b-49cc-a5c6-1cda1bae5488	Sara Paola	Nava Ayala		laurano113@hotmail.com	\N	2002-12-25 00:00:00		2025-05-03 20:50:50.486	2025-05-03 20:50:50.486	\N
ebaffd3c-df76-46fa-bc79-5ce50f5759e8	Luis Fernando	Dominguez Mora		dominguez.luisf@gmail.com	\N	1977-05-13 00:00:00		2025-05-03 20:50:50.486	2025-05-03 20:50:50.486	\N
8393cc01-0357-41cb-af25-7c3e82eb1606	Norma Leticia	Diaz Sarellano		\N	\N	1965-11-17 00:00:00		2025-05-03 20:50:50.487	2025-05-03 20:50:50.487	\N
2d7b5dc1-d683-419b-98a5-8b14dc15d68d	Maria Elena	Macias Espinosa		\N	\N	\N		2025-05-03 20:50:50.487	2025-05-03 20:50:50.487	\N
9850e3c4-21da-4a17-8a73-2f4749519fd3	Yakari	Meraz Villalvazo		\N	\N	\N		2025-05-03 20:50:50.487	2025-05-03 20:50:50.487	\N
5c510bf0-f5de-4465-9384-ffcb573fe945	Sandra	Melendez Beltran		sandy_melendez@hotmail.com	\N	1988-12-27 00:00:00		2025-05-03 20:50:50.487	2025-05-03 20:50:50.487	\N
c255be9b-39ef-437a-9b14-4d7bacf7df9b	Luis Alberto	Briseño Maigre		\N	\N	1989-09-07 00:00:00		2025-05-03 20:50:50.488	2025-05-03 20:50:50.488	\N
81b4fdd4-a5f4-45a4-bbb4-33a54858ab76	Juana	Sanchez Córtez		\N	\N	\N		2025-05-03 20:50:50.488	2025-05-03 20:50:50.488	\N
273669dc-5444-4d89-a7dd-2dd309ca9b6b	Luis Arturo	Garcia Pulido		artpull@hotmail.com	\N	1972-06-29 00:00:00		2025-05-03 20:50:50.488	2025-05-03 20:50:50.488	\N
80e7c3ac-044f-4c83-89b5-9348b62ab376	Lia	Zuñiga Partida		quetzy_lizu@hotmail.com	\N	\N		2025-05-03 20:50:50.489	2025-05-03 20:50:50.489	\N
881c0dea-ca94-4eea-9ff1-d3deebfd3b35	Lizett Aracely	Murillo Tobar		lizatt.murilo69@hotmail.com	\N	1969-11-05 00:00:00		2025-05-03 20:50:50.489	2025-05-03 20:50:50.489	\N
bd1230ce-bd8f-4be1-9ff3-205bde40f7b9	Patricia	Medina López		\N	\N	1980-07-22 00:00:00		2025-05-03 20:50:50.489	2025-05-03 20:50:50.489	\N
13c5c02a-81f8-4489-b51d-5aa3ceb043c3	Yolanda	Cardenaz Sosa		\N	\N	1966-01-16 00:00:00		2025-05-03 20:50:50.49	2025-05-03 20:50:50.49	\N
f31b5875-8cfa-4aec-888c-19d7e9470f17	Lorena	Martínez Mares		\N	\N	1979-01-17 00:00:00		2025-05-03 20:50:50.49	2025-05-03 20:50:50.49	\N
c3c1a582-68f7-491f-949b-dd9d820df48d	Nancy Katalina	Goche Días.		\N	\N	\N		2025-05-03 20:50:50.49	2025-05-03 20:50:50.49	\N
cd2443b1-395c-40f8-ac4c-874e3a7217fb	Victoria Sofia	Mendez Gonzalez		\N	\N	\N		2025-05-03 20:50:50.491	2025-05-03 20:50:50.491	\N
2f43ced7-535e-4f15-80bc-cb890ead0418	Omar	Perez Ibarra		\N	\N	1985-05-20 00:00:00		2025-05-03 20:50:50.491	2025-05-03 20:50:50.491	\N
8824fd42-bc5f-435a-91cd-f4c2acbaf869	Kevin	Magaña Bernal		li_li_2703@hotmail.com	\N	2000-12-01 00:00:00		2025-05-03 20:50:50.491	2025-05-03 20:50:50.491	\N
03c8e2fd-412b-4bb4-bfbb-4cdc653ae7d6	Karla Agueda	Aguilar Rivera		\N	3221175252	\N		2025-05-03 20:50:50.492	2025-05-03 20:50:50.492	\N
314668db-3d8b-4d96-a41a-25454e9fd7f2	Penny	Timms		\N	\N	1959-03-31 00:00:00		2025-05-03 20:50:50.492	2025-05-03 20:50:50.492	\N
2246c417-7da2-4f38-9400-c8b3b3f686cb	Ueli	Roethlisberger		ueliroethlisberger@hotmail.com	\N	1945-07-08 00:00:00		2025-05-03 20:50:50.492	2025-05-03 20:50:50.492	\N
eeb6a382-5dd3-49b8-a711-1d84dae17600	Kassandra	Del Castillo Jasso		edelcastillo15@gmail.com	\N	2011-07-04 00:00:00		2025-05-03 20:50:50.492	2025-05-03 20:50:50.492	\N
7e6986da-59aa-41db-ada4-127554e5b551	Natascha	Schiller		nataschaschiller@swissonline.ch	\N	1968-08-14 00:00:00		2025-05-03 20:50:50.493	2025-05-03 20:50:50.493	\N
c8bb44a4-1df4-4649-bd1d-9a798e723560	Sthefano	Ventura  Hernández		sthefanoventura@hotmail.com	3292980419	1999-03-02 00:00:00		2025-05-03 20:50:50.493	2025-05-03 20:50:50.493	\N
74785d7b-01fe-49d6-a5e3-feed57183ba9	Valleryn	Ventura Hernández		\N	3292980419	2004-06-30 00:00:00		2025-05-03 20:50:50.493	2025-05-03 20:50:50.493	\N
5d824d1a-fee4-4e0b-98aa-6df5e7b4b651	Zaida	Contreras Espinoza		\N	\N	1987-10-04 00:00:00		2025-05-03 20:50:50.494	2025-05-03 20:50:50.494	\N
004f1567-7eea-4430-89ba-168d5e849855	Travis Guillermo	De la Rosa Flippen		traviss360@hotmail.com	\N	1981-03-30 00:00:00		2025-05-03 20:50:50.494	2025-05-03 20:50:50.494	\N
86aac6d6-bd7d-4889-b3a1-01c966834614	Michell	Bolle		\N	\N	\N		2025-05-03 20:50:50.494	2025-05-03 20:50:50.494	\N
19fdbc66-90a9-4bb2-ba0d-b00b9f652eca	Leonardo	Soriano Camarillo		leonardocucea2008@gmail.com	\N	1985-06-14 00:00:00		2025-05-03 20:50:50.495	2025-05-03 20:50:50.495	\N
9d3a007e-ab54-4b45-9027-46f66e8c663b	Laura Elena	Casillas Espinoza		laura05ce@hotmail.com	\N	1987-05-26 00:00:00		2025-05-03 20:50:50.495	2025-05-03 20:50:50.495	\N
d4b5c2af-2539-4c66-bb43-ba67bb36bc64	Pedro Daniel	De los Santos Arechiga		isaacmariscal30@hotmail.com	\N	1989-01-28 00:00:00		2025-05-03 20:50:50.495	2025-05-03 20:50:50.495	\N
9351e132-8504-4c54-b6cb-f59490b50223	Luis Edison	Vallejo		marcela1821997@hotmail.com	\N	1966-04-25 00:00:00		2025-05-03 20:50:50.496	2025-05-03 20:50:50.496	\N
35df811f-bae8-4a6d-8202-917551c1bdf4	Sandra Guadaluoe	Bautista Rojas		\N	\N	1985-11-18 00:00:00		2025-05-03 20:50:50.496	2025-05-03 20:50:50.496	\N
ce1d7faa-e88c-4d64-8816-4f53ae364daf	Maria Luisa	Mora de los Santos		\N	\N	1949-05-18 00:00:00		2025-05-03 20:50:50.496	2025-05-03 20:50:50.496	\N
a5deccb9-d19c-4033-86a9-76b598c6b119	Vicente	Carmona Hernández		estadio4736@hotmail.com	\N	1947-06-07 00:00:00		2025-05-03 20:50:50.497	2025-05-03 20:50:50.497	\N
a6d9bc4d-81f4-4ca3-a990-c5b9f1eefde4	Solia Karina	Carmona Alejandre		\N	\N	\N		2025-05-03 20:50:50.497	2025-05-03 20:50:50.497	\N
fb118086-a3bf-4ff2-99ed-73b6253e1404	Maria	Nuñez Peña		\N	\N	\N		2025-05-03 20:50:50.497	2025-05-03 20:50:50.497	\N
87da996f-667d-4c6d-9b17-19deca7d56c9	Victor	Gomez Ramirez		\N	\N	1957-12-26 00:00:00		2025-05-03 20:50:50.498	2025-05-03 20:50:50.498	\N
af305065-095c-480e-bb6f-949c9c6c5f0f	Pedro Alberto	Oliva Cortéz		oliva1978ncr@hotmail.com	3227795296	1978-12-06 00:00:00		2025-05-03 20:50:50.498	2025-05-03 20:50:50.498	\N
8bac0976-4996-47fc-b6fa-6992db15855e	Juan Manuel	Alvarez Quiroz		\N	\N	\N		2025-05-03 20:50:50.498	2025-05-03 20:50:50.498	\N
ec49ec2b-3846-4705-94b6-270347726ba5	Marisol	Rodriguez Ramirez		sun69metztli@gmail.com	\N	1973-11-12 00:00:00		2025-05-03 20:50:50.498	2025-05-03 20:50:50.498	\N
a1f40eef-de86-4976-a62a-41ca4e8ce6de	Ronold	Kurylyk		\N	\N	1959-03-08 00:00:00		2025-05-03 20:50:50.499	2025-05-03 20:50:50.499	\N
8039184b-1f32-466b-b11c-b06d0ede5f2c	Sergio Valente	Soto Villela		\N	\N	1984-11-30 00:00:00		2025-05-03 20:50:50.499	2025-05-03 20:50:50.499	\N
7d620abb-cce4-4440-8236-7aee7a1cadc3	Marcos	Silva Astorga		siammarco@hotmail.com	\N	1956-02-21 00:00:00		2025-05-03 20:50:50.499	2025-05-03 20:50:50.499	\N
bd125a67-1513-406a-a2a6-aba37460cff1	Ramon	Cuevas  Barba		\N	\N	\N		2025-05-03 20:50:50.5	2025-05-03 20:50:50.5	\N
7a2241d6-ae16-4f3f-80fc-0783333283d7	Luz María	Rodriguez Fuentes		malu-yadier@outlook	\N	1957-01-20 00:00:00		2025-05-03 20:50:50.5	2025-05-03 20:50:50.5	\N
a4a5f767-ff3b-47b4-a5da-11830aacf75d	Osbaldo Miguel	Valenzuela Franquez		\N	3221838895	\N		2025-05-03 20:50:50.501	2025-05-03 20:50:50.501	\N
e305665b-daa5-44a4-a877-472afb2b57e4	Rolando	Flores Ibarra		topogral61@hotmail.com	\N	1961-05-06 00:00:00		2025-05-03 20:50:50.501	2025-05-03 20:50:50.501	\N
26a55e8b-dfb7-4ab2-a422-3823ee9ba4fe	Norman	Poulin		normandpoulin07@yahoo.ca	\N	1946-05-07 00:00:00		2025-05-03 20:50:50.501	2025-05-03 20:50:50.501	\N
a73f5adb-5644-430d-815b-9d4b12ac8819	Oscar Rogelio	Silva Sanchez		\N	\N	\N		2025-05-03 20:50:50.501	2025-05-03 20:50:50.501	\N
c292ee18-3b51-4051-970d-218afc6a2b19	Norma Iveth	Martínez Galván		normamg23@hotail.com	\N	1978-05-23 00:00:00		2025-05-03 20:50:50.502	2025-05-03 20:50:50.502	\N
4d43ebc7-c09d-49aa-8495-37c289414288	Lorena	Fernández		jann.michell@GMAIL.COM	\N	1967-05-21 00:00:00		2025-05-03 20:50:50.502	2025-05-03 20:50:50.502	\N
7a8d6f7a-fc45-422c-8266-1b597cf24545	Ricardo	Gonzalez		\N	\N	\N		2025-05-03 20:50:50.502	2025-05-03 20:50:50.502	\N
6854a7e8-4916-4ae1-87cc-ffc8711b74fe	Juan Pablo	Monroy		\N	\N	\N		2025-05-03 20:50:50.503	2025-05-03 20:50:50.503	\N
2c2022f2-3269-4a19-899c-51aeffda7cf2	Modesta	Macias Navarro		\N	\N	1954-02-24 00:00:00		2025-05-03 20:50:50.503	2025-05-03 20:50:50.503	\N
1b3f7618-93b4-4081-b5dd-461511a9e256	Susana	Elizondo		\N	\N	1984-12-09 00:00:00		2025-05-03 20:50:50.503	2025-05-03 20:50:50.503	\N
83c38f72-f752-4280-82d4-bcdac6e18a46	Nataly	Diaz Machuca		\N	\N	\N		2025-05-03 20:50:50.504	2025-05-03 20:50:50.504	\N
d02d5e03-20d3-4beb-8ba1-df2e65d61f41	Martinez Galvan	Norma Iveth		normamg23@hotmail.com	\N	1978-05-23 00:00:00		2025-05-03 20:50:50.504	2025-05-03 20:50:50.504	\N
db52aa44-1ccc-417f-9fb4-e582c0f0d3a3	Manuel	Bogado		bogadomanuel@hotmail.com	3221142847	1971-09-26 00:00:00		2025-05-03 20:50:50.504	2025-05-03 20:50:50.504	\N
8452133c-6248-499f-bb92-fb3e62de894b	Maria D Jesus	Marin Becerra		\N	\N	\N		2025-05-03 20:50:50.505	2025-05-03 20:50:50.505	\N
d37eb403-1025-4f3d-83a6-73d79b4e79ea	Martha Belinda	Jimenez Delgado		\N	3223060940	\N		2025-05-03 20:50:50.505	2025-05-03 20:50:50.505	\N
ca3d59c8-19a7-4bd8-b585-9d1f89f37fcb	Marcos Ivan	Rosas Gurrola		marcoslitibu@gmail.com	\N	\N		2025-05-03 20:50:50.505	2025-05-03 20:50:50.505	\N
3c626a22-7ad5-4a20-a066-3fd6120202e4	Maria	Salazar Rosalines		\N	\N	\N		2025-05-03 20:50:50.506	2025-05-03 20:50:50.506	\N
b74ab529-5512-4ed2-a738-0490be1fcc22	Ma. Gertrudis	Verduzco Galvan		\N	\N	1964-11-16 00:00:00		2025-05-03 20:50:50.506	2025-05-03 20:50:50.506	\N
b526c1b0-32f8-4906-8cee-c599f0ba37a7	Oscar Noel	García Cuara		elmediador@hotmail.com	\N	1979-12-25 00:00:00		2025-05-03 20:50:50.506	2025-05-03 20:50:50.506	\N
fdfdee29-2efe-4268-82fc-623bc8f6ea22	Kevin Alejandro	Torres García		\N	\N	2010-08-26 00:00:00		2025-05-03 20:50:50.506	2025-05-03 20:50:50.506	\N
cd11a0d9-7533-48c4-b943-43b68018fdc8	Rene	Chavez Oropeza		\N	\N	\N		2025-05-03 20:50:50.507	2025-05-03 20:50:50.507	\N
732fe9ab-98bb-49d6-bf5a-1c0061426906	Oscar Daniel	Chamorro Quintero		\N	\N	2010-02-09 00:00:00		2025-05-03 20:50:50.507	2025-05-03 20:50:50.507	\N
c7d28e3b-d515-44de-b8cf-2ab8e8bdd8e4	Patricia	Martlew		johnpat@twincomm.ca	\N	1943-04-12 00:00:00		2025-05-03 20:50:50.507	2025-05-03 20:50:50.507	\N
e7febf6c-d911-4cdc-9bca-8a45a735a22b	Naim Guadalupe	Rodriguez Carmona		\N	\N	\N		2025-05-03 20:50:50.508	2025-05-03 20:50:50.508	\N
a736c233-d8f8-4104-bbc4-357c19dccdf6	Tsunami	Venegas Ramos		\N	\N	2009-09-20 00:00:00		2025-05-03 20:50:50.508	2025-05-03 20:50:50.508	\N
7607d0cc-1e06-4cdc-8b5a-96fde034335d	Santiago Israel	Carrillo Vázquez		\N	\N	2010-05-20 00:00:00		2025-05-03 20:50:50.508	2025-05-03 20:50:50.508	\N
7559980e-d77a-424c-9c61-65fb632d898f	Karla Vianey	García Hernández		neyka.0585@gmail.com	\N	1984-12-05 00:00:00		2025-05-03 20:50:50.509	2025-05-03 20:50:50.509	\N
76c460b3-010e-4e1a-9b38-f5675ff312ba	Manuel	Resendis Ramiréz		resendis_5j37@hotmail.com	\N	1987-02-17 00:00:00		2025-05-03 20:50:50.509	2025-05-03 20:50:50.509	\N
374542e1-40aa-4406-956f-7d0e32ce3598	Mario	Arredondo Ramirez		\N	\N	\N		2025-05-03 20:50:50.509	2025-05-03 20:50:50.509	\N
8ac4190d-16ef-4692-aa7e-a4685c7949fb	Lorena	Sanchez Sanchez		losan8563@yahoo.com	\N	1985-03-01 00:00:00		2025-05-03 20:50:50.509	2025-05-03 20:50:50.509	\N
f2412079-8127-4271-8129-041eff6167af	Marco Antonio	Morales Sanchez		\N	\N	\N		2025-05-03 20:50:50.51	2025-05-03 20:50:50.51	\N
1ad16365-7a1d-486d-9467-b47cc571127e	Maria Louisa	Perez Perez		\N	\N	1960-01-28 00:00:00		2025-05-03 20:50:50.51	2025-05-03 20:50:50.51	\N
1820245f-a610-42f0-80ef-c58d479bf2ee	Manuel	Chang de la Crúz		\N	013291021141	2001-07-24 00:00:00		2025-05-03 20:50:50.51	2025-05-03 20:50:50.51	\N
936a2c5f-6cdf-4c5f-a48d-5cd091457afd	Nadia Natali	Cuvarrubia Dorame		\N	\N	\N		2025-05-03 20:50:50.511	2025-05-03 20:50:50.511	\N
b10e35b8-d584-48c3-9283-96d4a83cc14a	Octavio	Campos de la Gama		\N	\N	1961-08-13 00:00:00		2025-05-03 20:50:50.511	2025-05-03 20:50:50.511	\N
439de14c-76f4-4cf6-97b1-c7ed32d1343d	Ximena	Campos Pastrana		campost727@gmail.com	\N	1998-01-10 00:00:00		2025-05-03 20:50:50.511	2025-05-03 20:50:50.511	\N
5040061b-fc92-43d9-8aab-a365ee881ea1	Juan Manuel	Castañeda García		\N	\N	\N		2025-05-03 20:50:50.512	2025-05-03 20:50:50.512	\N
a6311ce8-0732-43a9-b4bf-7e79ffdc4862	Maria Elena	Pagua Rosalez		\N	\N	1957-05-26 00:00:00		2025-05-03 20:50:50.512	2025-05-03 20:50:50.512	\N
19dc1a82-de50-4783-8cbe-79218f0f9aea	Mariana	Campos Pastrana		\N	\N	1995-12-07 00:00:00		2025-05-03 20:50:50.512	2025-05-03 20:50:50.512	\N
53e55076-83d6-4ae5-8f11-c287bbfdb7b1	Omar	Morales		\N	\N	\N		2025-05-03 20:50:50.513	2025-05-03 20:50:50.513	\N
d9f96abb-5ae3-4393-a3ac-603b4e25542f	Lina	Luna García		\N	3292982618	1973-09-23 00:00:00		2025-05-03 20:50:50.513	2025-05-03 20:50:50.513	\N
dce00319-7a31-4b5f-bafc-a1fa5af6a9bf	Katia	Galindo		katgalalbre@yahoo.com	\N	1972-06-03 00:00:00		2025-05-03 20:50:50.513	2025-05-03 20:50:50.513	\N
ae1360ea-38e4-4577-82a4-48b7758b7d63	Norberto	Chagala		noy_2315@hotmail.com	\N	1989-06-06 00:00:00		2025-05-03 20:50:50.513	2025-05-03 20:50:50.513	\N
ab79e94d-a50a-4bf0-a415-94c7755726f8	Kasey	Passen		kaseypassen@gmail.com	3124771354	1981-08-04 00:00:00		2025-05-03 20:50:50.514	2025-05-03 20:50:50.514	\N
df3c3944-b0f2-4bcb-98e8-0c836e246cae	Rodolfo	Cuevas		\N	\N	\N		2025-05-03 20:50:50.514	2025-05-03 20:50:50.514	\N
17d2a557-7280-4ffd-b4b3-81b8d9a5695e	Luis Eduardo	León Serrano		eddyberry@live.com	\N	1994-06-23 00:00:00		2025-05-03 20:50:50.515	2025-05-03 20:50:50.515	\N
7aadada6-745e-47b6-8d1f-420bc8ba7257	Rogelia Gpe.	Mendoza Sanchez		snoopy1_142@hotmail.com	\N	1982-02-25 00:00:00		2025-05-03 20:50:50.515	2025-05-03 20:50:50.515	\N
841a98cb-885d-4b92-a3be-1c56a533cd4d	Penelope	Parkes		\N	\N	\N		2025-05-03 20:50:50.515	2025-05-03 20:50:50.515	\N
e9c44b0d-72e9-4a31-94e3-592abbb729ce	Norma Angelica	Sanchez Nuñez		\N	\N	1970-06-15 00:00:00		2025-05-03 20:50:50.516	2025-05-03 20:50:50.516	\N
e348121e-df2a-4f4d-97d0-e395c38942b4	Samuel	Cruz Vazquez		\N	\N	2010-10-15 00:00:00		2025-05-03 20:50:50.516	2025-05-03 20:50:50.516	\N
6fd15ef9-3e8c-4678-949e-442450aba891	Marco	Simeone		m.simeoni86@hotmail.com	\N	1986-06-01 00:00:00		2025-05-03 20:50:50.516	2025-05-03 20:50:50.516	\N
840c887f-8540-4ff7-a251-d7ccfa6a5753	Miranda Paola	Oliva		oliva1978ncr@hotmail.com	\N	2001-07-06 00:00:00		2025-05-03 20:50:50.516	2025-05-03 20:50:50.516	\N
d17b22dd-c764-45d1-95d3-89ee8f35bac9	Miranda Paola	Oliva García		oliva1978ncr@hotmail.com	\N	2001-07-06 00:00:00		2025-05-03 20:50:50.517	2025-05-03 20:50:50.517	\N
9d014c7e-42c0-4540-a349-ab77c0a709f6	Luis Angel	Abarca Cipres		luiscipres@life.com	\N	1993-03-15 00:00:00		2025-05-03 20:50:50.517	2025-05-03 20:50:50.517	\N
3a09017d-708b-487d-ac61-f1a07b5b88fd	Sandra	Peréz Rodriguez		oliva1978ncr@hotmail.com	\N	1983-12-01 00:00:00		2025-05-03 20:50:50.517	2025-05-03 20:50:50.517	\N
c6650f96-f1f5-4517-89c1-59d22255f921	Rafael	Medina		rafael.medina.flores@hotmail.com	\N	1963-11-09 00:00:00		2025-05-03 20:50:50.518	2025-05-03 20:50:50.518	\N
3f6ecd75-d35f-4915-b874-1dad03525918	Sergio	Morelos Garnica		srgmorelos@gmail.com	\N	1988-03-31 00:00:00		2025-05-03 20:50:50.518	2025-05-03 20:50:50.518	\N
175eb480-aaa3-4d5d-aaf5-8f588d854529	Maria Rosario	Peña Hernández		charitoph@hotmail.com	\N	1971-02-02 00:00:00		2025-05-03 20:50:50.518	2025-05-03 20:50:50.518	\N
4d9534c8-2f60-4162-93dc-fb5995ef333b	Paul	Croteau		\N	\N	1943-12-21 00:00:00		2025-05-03 20:50:50.519	2025-05-03 20:50:50.519	\N
ed549c40-374a-4c60-8fc2-7231ea52ab17	Katia	Heino		katjamarika@yahoo.com	\N	1973-11-11 00:00:00		2025-05-03 20:50:50.519	2025-05-03 20:50:50.519	\N
a848b805-e023-46b8-85ed-4f34cbe308ef	Sara Elissa	Urias		crisa_12_13@hotmail.com	\N	1992-11-17 00:00:00		2025-05-03 20:50:50.519	2025-05-03 20:50:50.519	\N
732b976e-0ace-48c3-9cb7-57e24b0a44ce	Nelson Enrrique	Lallanes		\N	\N	1990-01-03 00:00:00		2025-05-03 20:50:50.519	2025-05-03 20:50:50.519	\N
f19614ed-d009-4076-8ba7-d7eaf54ce8f2	Roxana	Ramírez Vazquez		\N	\N	1986-11-02 00:00:00		2025-05-03 20:50:50.52	2025-05-03 20:50:50.52	\N
45a6fec3-9a39-486e-a8ee-152f24421927	Olivia	Spiller		\N	\N	\N		2025-05-03 20:50:50.52	2025-05-03 20:50:50.52	\N
cf7fde33-6f26-4b40-a91f-4682cd247048	Martha Olivia	Spiller González		\N	3222893378	1972-05-26 00:00:00		2025-05-03 20:50:50.52	2025-05-03 20:50:50.52	\N
a4d9f2c3-67ad-49a1-b852-a7ed3bb5303c	Wsebolod	Galvan Berberoff		\N	\N	\N		2025-05-03 20:50:50.521	2025-05-03 20:50:50.521	\N
843178ff-8450-4737-b45f-77f9174d1e7a	Yameli del Rocio	Carrillo Hernandéz		flyies.yc@gmail.com	\N	1985-06-02 00:00:00		2025-05-03 20:50:50.521	2025-05-03 20:50:50.521	\N
79250a33-b530-46fe-9e4f-18f03ab20b66	Paolina Isabel	García Berumen		monarcavta@gmail.com	3221069132	1987-06-09 00:00:00		2025-05-03 20:50:50.521	2025-05-03 20:50:50.521	\N
96b0d58b-c15f-4e55-ab88-ec60130e74af	Rocio	Nuñes Rivera		\N	\N	\N		2025-05-03 20:50:50.522	2025-05-03 20:50:50.522	\N
05890e41-a0b3-45da-9133-c3a96a0f7e74	Tim	Thorburn		tim@fhfw.ca	\N	\N		2025-05-03 20:50:50.522	2025-05-03 20:50:50.522	\N
510f26b7-4d89-4d98-9000-53c01e56eb3c	Paula	Thorburn		paulathorburn@hotmail.com	6122129550	1954-03-30 00:00:00		2025-05-03 20:50:50.522	2025-05-03 20:50:50.522	\N
d44fe9a5-b2d9-44a0-8a84-07aaf33e76f5	Michelle	Garnica Fregoso		michelle_gf@hotmail.com	\N	1984-12-15 00:00:00		2025-05-03 20:50:50.523	2025-05-03 20:50:50.523	\N
abb6c742-b3ff-40ea-862a-ba4c67eaf5b2	Rosa Azucena	Flores Amezquita		azucena.flores.00@gmail.com	3222243631	1976-09-16 00:00:00		2025-05-03 20:50:50.523	2025-05-03 20:50:50.523	\N
03461657-41cf-4b2f-b7e4-53f8a1cd5c8c	Lazaro Javier	Franco Salcedo		\N	\N	\N		2025-05-03 20:50:50.523	2025-05-03 20:50:50.523	\N
70fd5a15-1b02-4ff6-98ea-c95bf20c1e68	Maria Elena	Garza Treviño		\N	3223073520	1955-11-10 00:00:00		2025-05-03 20:50:50.524	2025-05-03 20:50:50.524	\N
9ec621b8-7824-4f7c-b3a2-7b3ecbd9628a	Misael	López Martinez		mazewayz@gmail.com	\N	1987-10-06 00:00:00		2025-05-03 20:50:50.524	2025-05-03 20:50:50.524	\N
a29aed92-a41e-47a6-b1fe-f2d1ff05fde2	Otilia	Vaca Viera		\N	\N	1950-05-10 00:00:00		2025-05-03 20:50:50.524	2025-05-03 20:50:50.524	\N
2716a33d-adc2-4425-8267-58cedf472d68	soleil	ho		\N	\N	\N		2025-05-03 20:50:50.524	2025-05-03 20:50:50.524	\N
950041e6-9a0f-4df2-ad3f-8e7c0807a3ce	Trinidad	Torres Almaras		\N	\N	\N		2025-05-03 20:50:50.525	2025-05-03 20:50:50.525	\N
e145c3d0-5c8a-462b-807b-893094d09dcf	Lucie	Aubry		luciole209@live.ca	\N	1950-05-04 00:00:00		2025-05-03 20:50:50.525	2025-05-03 20:50:50.525	\N
38d0cda9-2921-40da-89b7-377ca3d96cc6	Yemali Samara	Tomatis Rodriguez		\N	\N	\N		2025-05-03 20:50:50.525	2025-05-03 20:50:50.525	\N
80a49cf3-8dee-46e0-98ff-ab7352564435	Micheline	Goulet		\N	3223700996	1954-09-05 00:00:00		2025-05-03 20:50:50.526	2025-05-03 20:50:50.526	\N
58a58ca0-c203-4597-ac84-50f60e26e07e	Lise	Francoeur		\N	\N	1963-06-25 00:00:00		2025-05-03 20:50:50.526	2025-05-03 20:50:50.526	\N
8271e188-d91c-4397-8aac-974d4dad3121	Roberto	Ruelas Guzman		lic.robertoruelasg@hotmail.com	\N	1982-06-23 00:00:00		2025-05-03 20:50:50.526	2025-05-03 20:50:50.526	\N
d8e63b73-d119-4f1b-b777-e1186d1bc9d4	Vallet	Rogriguez George		girasoljardineria@gmail.com	\N	1978-05-25 00:00:00		2025-05-03 20:50:50.527	2025-05-03 20:50:50.527	\N
fa4de11b-caeb-4c04-b296-63f88bda3816	Marielle	Laforest		mariy.laforest@hotmail.com	\N	1943-07-22 00:00:00		2025-05-03 20:50:50.527	2025-05-03 20:50:50.527	\N
9bf2e0d2-c6ff-466b-b731-3a1a556cd83d	Rafael	Juarez Camacho		jcrafaelherbalife@hotmail.com	\N	1954-06-29 00:00:00		2025-05-03 20:50:50.527	2025-05-03 20:50:50.527	\N
a2325911-947b-4f43-a673-189f0ee7cfa0	Pablo	Salazar Henriquez		\N	\N	1991-04-17 00:00:00		2025-05-03 20:50:50.528	2025-05-03 20:50:50.528	\N
1e2a1878-0039-42d4-927d-97f56e5d3cab	Scott	Parker		\N	\N	\N		2025-05-03 20:50:50.528	2025-05-03 20:50:50.528	\N
bf18048f-ec15-4f74-9ef3-68168be837fc	Paulina	Guerrero  Sandoval		pauguerrero6@gmail.com	\N	1986-10-15 00:00:00		2025-05-03 20:50:50.528	2025-05-03 20:50:50.528	\N
42993ca1-c692-4955-9c4f-31ee6d8f2732	Maria	Verduzco Galban		\N	\N	1964-11-16 00:00:00		2025-05-03 20:50:50.529	2025-05-03 20:50:50.529	\N
78e6325b-1388-4578-8bfc-a789ec9bc82e	Miriam	Grijalba Verduzco		\N	\N	1986-08-04 00:00:00		2025-05-03 20:50:50.529	2025-05-03 20:50:50.529	\N
e7899432-05e1-467c-8fbc-ceca46f13c59	Max	Bendenoun Garbe		\N	\N	2001-05-12 00:00:00		2025-05-03 20:50:50.529	2025-05-03 20:50:50.529	\N
473d2aee-4de1-470c-8e53-01c233806202	Sasha	Bendenoun Garbe		\N	\N	2001-05-12 00:00:00		2025-05-03 20:50:50.53	2025-05-03 20:50:50.53	\N
424cefb5-6919-4f30-b877-7d9db3663a2c	Yvon	Bonneville		\N	\N	\N		2025-05-03 20:50:50.53	2025-05-03 20:50:50.53	\N
4331abfb-4f6d-4b45-8550-0b94cab3e4d9	Peter	Miksche		\N	\N	1947-05-02 00:00:00		2025-05-03 20:50:50.53	2025-05-03 20:50:50.53	\N
5633440e-a505-4ba9-9992-f34b39140058	Maria Luisa	Valenzuela Robles		\N	\N	1941-09-04 00:00:00		2025-05-03 20:50:50.531	2025-05-03 20:50:50.531	\N
722cd232-ee04-4117-9cad-eb1fe396abba	Stephane	Plante		stef775@hotmail.com.com	\N	1975-04-30 00:00:00		2025-05-03 20:50:50.531	2025-05-03 20:50:50.531	\N
375de54b-de12-4ad8-96d2-936667cfc7f6	Paola Alejandra	Palacios Medina		\N	\N	1997-12-19 00:00:00		2025-05-03 20:50:50.531	2025-05-03 20:50:50.531	\N
c4ad2ad6-5712-4b80-9585-1072ae590567	Margaret	Mclaughlin		margmcl@shaw.ca	\N	1955-06-20 00:00:00		2025-05-03 20:50:50.532	2025-05-03 20:50:50.532	\N
73bac9ba-d2e2-4057-8ac0-20afebdce77b	Thomas Edward	Mclahughlin		\N	\N	\N		2025-05-03 20:50:50.532	2025-05-03 20:50:50.532	\N
8a6c479a-ca28-4f0b-9f3c-3ac1dca4ac56	Rocio	Nuñez Rivera		rocin_u@hotmail.com	\N	1987-09-28 00:00:00		2025-05-03 20:50:50.532	2025-05-03 20:50:50.532	\N
9652b684-8c34-4df8-be68-95c2d3d8e2d4	Kuyen	Goméz Morgante		kuyengomezcvis@gmail.com	+573136220945	2002-09-13 00:00:00		2025-05-03 20:50:50.533	2025-05-03 20:50:50.533	\N
0ad0a9c2-4513-468e-ab12-da1bd9fc8a27	Karina	Coppola		karinavcoppola@yahoo.com.ar.	3222933713	\N		2025-05-03 20:50:50.533	2025-05-03 20:50:50.533	\N
d7dd009c-3b3a-4212-b177-4fde22a30aa8	Leonardo	Sanchez Hernandez		\N	\N	2006-02-22 00:00:00		2025-05-03 20:50:50.533	2025-05-03 20:50:50.533	\N
7d64f925-dc32-4133-a375-d4b86fc50c05	Miguel	Pérez Montiel		\N	\N	1957-05-10 00:00:00		2025-05-03 20:50:50.533	2025-05-03 20:50:50.533	\N
4de52a5c-9648-45c0-a93d-ae558c91abc7	Marcela	Rubio Flores		\N	\N	1987-06-22 00:00:00		2025-05-03 20:50:50.534	2025-05-03 20:50:50.534	\N
3d54c995-4d84-4a2b-b3df-15dea072b94d	Narda	Peña Aguirre		\N	\N	\N		2025-05-03 20:50:50.534	2025-05-03 20:50:50.534	\N
d40602e5-87b0-4167-866c-1a9d95c2dad3	Lizeth	Peña Aguirre		n.lizzeth@hotmail.com	\N	1994-09-11 00:00:00		2025-05-03 20:50:50.534	2025-05-03 20:50:50.534	\N
36d7323f-5620-4810-ae8c-8ff9ddacec9f	Martin	Garcia Jacobo		\N	\N	1966-09-15 00:00:00		2025-05-03 20:50:50.535	2025-05-03 20:50:50.535	\N
0c704d9e-87d8-48b9-bdfd-93e1036bf81c	Maria Eugenia	Guzman		\N	\N	1956-05-02 00:00:00		2025-05-03 20:50:50.535	2025-05-03 20:50:50.535	\N
ef5ff783-1ec3-44a1-8fda-8366971b55ca	Tom	Reynolds		treynolds@rogers.com	\N	1947-12-14 00:00:00		2025-05-03 20:50:50.535	2025-05-03 20:50:50.535	\N
3b41e746-155d-4a0a-9cc9-f19f0226a7c3	Stephane	Beaudry		tattoocronic@icloud.com	\N	1975-07-18 00:00:00		2025-05-03 20:50:50.536	2025-05-03 20:50:50.536	\N
3a696432-d775-4a04-9511-d1938773517d	Oscar Eduardo	Cruz Reyes		\N	\N	1993-06-17 00:00:00		2025-05-03 20:50:50.536	2025-05-03 20:50:50.536	\N
04de56f1-4253-40c0-8526-3807d8ebe8c2	Margarita	Muños Macias		\N	\N	1947-03-16 00:00:00		2025-05-03 20:50:50.536	2025-05-03 20:50:50.536	\N
5d61e012-3d7e-4036-85a0-fd51de051d67	Marcel	Poulin		marcelpoulin@yahoo.com	\N	1947-10-24 00:00:00		2025-05-03 20:50:50.537	2025-05-03 20:50:50.537	\N
b263c05b-1ac4-4a7c-8572-f9351a4fe8f5	Mariela	Sandoval  Cobarrubias		\N	\N	1961-08-13 00:00:00		2025-05-03 20:50:50.537	2025-05-03 20:50:50.537	\N
70a872e1-48b7-4f77-85e9-b37206c1ca16	Melissa Christie	Chrsitie  Sandoval		melissa.christie.s@gmail.com	\N	1988-03-25 00:00:00		2025-05-03 20:50:50.537	2025-05-03 20:50:50.537	\N
2cb81160-4000-40c1-a483-65732facf236	Juan Marcos	Morillo Morales		\N	\N	\N		2025-05-03 20:50:50.538	2025-05-03 20:50:50.538	\N
8d2fd517-71b9-42e1-9bb5-770d14b20118	Liliana	Lara Guzman		liana.lra.guzman@gmnail.com	\N	1973-11-26 00:00:00		2025-05-03 20:50:50.538	2025-05-03 20:50:50.538	\N
ac5a9e61-3fe0-4168-9e28-914051d138cb	Roberto Carlos	Flores Fernandez		robertote434@gmail.com	\N	1986-04-27 00:00:00		2025-05-03 20:50:50.538	2025-05-03 20:50:50.538	\N
9d0c8858-5518-476b-8025-de195058a3c2	Miguel	Aguirre Gómez		\N	\N	1989-02-10 00:00:00		2025-05-03 20:50:50.539	2025-05-03 20:50:50.539	\N
99033835-f8ef-4ec3-8ba0-54912173c19a	Samuel	Cruz Vazquez		\N	\N	\N		2025-05-03 20:50:50.539	2025-05-03 20:50:50.539	\N
0262a40d-0611-4a83-b4a3-16abf754b1a7	Osvaldo	Padilla Sánchez		elsabio1485@gmail.com	\N	1985-08-08 00:00:00		2025-05-03 20:50:50.539	2025-05-03 20:50:50.539	\N
b9ae3947-8d26-4a61-a749-59fdaa254c26	Paola Alejandra	Grajeda Torres		\N	\N	2004-06-15 00:00:00		2025-05-03 20:50:50.54	2025-05-03 20:50:50.54	\N
e5e82aef-9895-4f88-b1ba-0cbca1f32dcf	Lyudmila	Butok		\N	\N	1983-09-15 00:00:00		2025-05-03 20:50:50.54	2025-05-03 20:50:50.54	\N
99c37e92-c22d-46ae-b0fb-35f0ab956676	Manuel	Renteria Lopez		\N	\N	1951-01-02 00:00:00		2025-05-03 20:50:50.54	2025-05-03 20:50:50.54	\N
7da6efaf-b179-435c-915c-1470d7664bda	Misbel	Rodríguez		misbel1788@gmail.com	\N	1988-05-14 00:00:00		2025-05-03 20:50:50.541	2025-05-03 20:50:50.541	\N
65343dcf-a80d-420f-b177-7ce431bfa13e	Yailis	Lorente		misbel1788@gmail.com	\N	1976-10-17 00:00:00		2025-05-03 20:50:50.541	2025-05-03 20:50:50.541	\N
182e7577-0ec4-4f2f-952a-cfed18a6e993	Maria delos Angeles	Nuñes Peña		\N	\N	\N		2025-05-03 20:50:50.541	2025-05-03 20:50:50.541	\N
bc1cd884-89ee-4ece-acca-82fc0df89f3a	Vianey Sarahi	Hernandez Diaz		\N	\N	1990-05-19 00:00:00		2025-05-03 20:50:50.541	2025-05-03 20:50:50.541	\N
ec9b0b09-7832-4e9c-b7e5-aa32ffe1267b	Maria Florentina	Estrella Martinez		\N	\N	1967-01-26 00:00:00		2025-05-03 20:50:50.542	2025-05-03 20:50:50.542	\N
1ed81141-e4ee-4ca3-b953-dfc583aec171	Socorro Gabriela	Quiles Peña		gqp21@hotmail.com	\N	1971-06-21 00:00:00		2025-05-03 20:50:50.542	2025-05-03 20:50:50.542	\N
c8a34b37-8b55-4d5d-bf3f-1467dc23bdcf	Victoria	García  Jiménez		\N	\N	1954-03-23 00:00:00		2025-05-03 20:50:50.543	2025-05-03 20:50:50.543	\N
42958ce7-1f00-4ee4-abf3-c6000aec411b	Magdiel Eglaim	Figeroa Fernandez		\N	\N	\N		2025-05-03 20:50:50.543	2025-05-03 20:50:50.543	\N
2b614baa-cd46-4790-877b-66c42c1ef65c	Raul	Salas Reta		alfaromeo536@gmail.com	\N	1979-04-16 00:00:00		2025-05-03 20:50:50.543	2025-05-03 20:50:50.543	\N
8dc07ce4-ac7b-4a52-bbb5-ff18b63205cb	Ramon	Suarez Lopez		lp_sandravlz@hotmail.com	\N	1986-07-14 00:00:00		2025-05-03 20:50:50.543	2025-05-03 20:50:50.543	\N
6c367a54-147e-4034-b9af-ee57ef674770	Sonia	Ortíz Torres		jaqueline1926@yahoo.com.mx	\N	1977-08-22 00:00:00		2025-05-03 20:50:50.544	2025-05-03 20:50:50.544	\N
14d4cb32-b8b3-4d8f-bc78-eaa6cb75ae2e	Maria	Magaña		mmagana86@att.net	\N	1986-05-15 00:00:00		2025-05-03 20:50:50.544	2025-05-03 20:50:50.544	\N
ee1ea72c-82cf-4cf6-ba3c-3680e4402628	Leticia	Gutierrez  Villalobos		leticiagutierrezvillalobos@yahoo.com.mx	\N	1974-01-14 00:00:00		2025-05-03 20:50:50.544	2025-05-03 20:50:50.544	\N
42fe55db-6591-454b-b13d-737643369959	Maria de Lourdes	Valdez Alvarez		\N	\N	\N		2025-05-03 20:50:50.545	2025-05-03 20:50:50.545	\N
5dec14fc-b563-47f3-9af7-7123ff8e069f	Victor Eduardo	Acebes Padilla		\N	\N	1975-09-12 00:00:00		2025-05-03 20:50:50.545	2025-05-03 20:50:50.545	\N
c0a7f5a7-6828-4920-a235-db7751be0ca3	Melissa	Mosto		lmosto@aol.com	3222280779	1995-10-17 00:00:00		2025-05-03 20:50:50.545	2025-05-03 20:50:50.545	\N
9c215a8f-d53b-4c90-bb3f-bb3ebc9fea76	Juliana	Gallardo Becerra		\N	\N	\N		2025-05-03 20:50:50.546	2025-05-03 20:50:50.546	\N
18d864ea-f3f6-4bfc-b63e-3efdde6357de	Pamela	Moss		ppmoss@gmail.com	\N	1937-08-10 00:00:00		2025-05-03 20:50:50.546	2025-05-03 20:50:50.546	\N
8ba7a584-c3b6-4d12-8930-dd8cd9f2c674	Justine	Richey		justinerichey1@yahoo.com	\N	\N		2025-05-03 20:50:50.546	2025-05-03 20:50:50.546	\N
c2746364-8b08-4747-8562-99e604c51519	Luis Angel	Moran Crúz		angel.nia.2626@gmail.com	\N	1994-04-26 00:00:00		2025-05-03 20:50:50.547	2025-05-03 20:50:50.547	\N
0101beb3-26de-4a2c-afb1-e9fe5ee2e6a3	Yadira	Palacio Huerta		\N	\N	1980-02-01 00:00:00		2025-05-03 20:50:50.547	2025-05-03 20:50:50.547	\N
e65453d8-3bb7-4d85-a4cc-40abbe35c840	Noé	Meza Pérez		\N	\N	\N		2025-05-03 20:50:50.547	2025-05-03 20:50:50.547	\N
864dd455-25e5-44cd-adea-e1561d85aeb1	Luna Valentina	Lorenzo Torres		\N	\N	2013-02-28 00:00:00		2025-05-03 20:50:50.548	2025-05-03 20:50:50.548	\N
3d164f9b-792c-4b75-899c-32b2239f610f	Manuel	Gonzalez Cuellar		gonzalescuellar1@gmail.com	\N	1982-10-07 00:00:00		2025-05-03 20:50:50.548	2025-05-03 20:50:50.548	\N
8b3c420c-f128-4a4c-9e26-1fb303a3c4e2	Victor  Eduardo	Aceves Padilla		\N	\N	1975-09-12 00:00:00		2025-05-03 20:50:50.548	2025-05-03 20:50:50.548	\N
c3f1ee26-a20b-4dad-b449-b781d1279d7b	Marcelino	Jara Gutierrez		\N	3272742023	1950-07-14 00:00:00		2025-05-03 20:50:50.549	2025-05-03 20:50:50.549	\N
caaa4a42-9fb9-4419-9265-6fa6f44bda42	Mario	Velez Velazco		\N	\N	1960-01-19 00:00:00		2025-05-03 20:50:50.549	2025-05-03 20:50:50.549	\N
b7cfe736-3570-439f-97f3-dede4c18cff9	Juneth	Rojo Martinez		june_m23@hotmail.com	\N	1992-04-23 00:00:00		2025-05-03 20:50:50.549	2025-05-03 20:50:50.549	\N
dfa461b2-0f8e-4f78-abcf-cadc9e348da6	Lindsey	Roark		lindseyannroark@gmail.com	\N	1986-04-08 00:00:00		2025-05-03 20:50:50.549	2025-05-03 20:50:50.549	\N
9d6a107a-e3ff-4e28-9bc0-05662770b2d5	Lucia	Arreola Perez		\N	\N	1967-03-12 00:00:00		2025-05-03 20:50:50.55	2025-05-03 20:50:50.55	\N
af1e7330-97e8-4c00-a446-830683e4e39c	Pedro	Soto Robles		\N	\N	1958-06-18 00:00:00		2025-05-03 20:50:50.55	2025-05-03 20:50:50.55	\N
00395273-e3e8-460b-9ba2-857c1d424e4a	Manuel	Lopez		\N	\N	\N		2025-05-03 20:50:50.55	2025-05-03 20:50:50.55	\N
2e0b9d65-caee-4964-9566-73ee1da8f35d	Rafael	Santana Reyes		bvvp@hotmail.com	3292984293	1973-06-12 00:00:00		2025-05-03 20:50:50.551	2025-05-03 20:50:50.551	\N
1897c065-8f23-4b59-b086-60d2979ebb62	SHEILA	LUNA		sheila@sheilamoon.com	\N	1964-10-14 00:00:00		2025-05-03 20:50:50.551	2025-05-03 20:50:50.551	\N
633a99ac-7444-42fb-90c6-24c3f97301cc	Llilia	Gonzalez Garcia		\N	\N	\N		2025-05-03 20:50:50.551	2025-05-03 20:50:50.551	\N
b4f107f9-9f70-4477-98e3-4ff3d722e7e0	Maribel	Soltero  García		\N	\N	1983-03-25 00:00:00		2025-05-03 20:50:50.552	2025-05-03 20:50:50.552	\N
74d38812-da65-447e-ae1c-8a586176c512	Nataniel	Andrade Ramírez		bluesky06@life.com.mx	\N	1988-12-06 00:00:00		2025-05-03 20:50:50.552	2025-05-03 20:50:50.552	\N
e07a5fa6-4845-414c-a707-0f53a3b2683b	Maria Luisa	Morales Pelcastre		marilumorapel@hotmail.com	\N	1949-05-20 00:00:00		2025-05-03 20:50:50.552	2025-05-03 20:50:50.552	\N
0cc3a139-201c-4282-8c1f-ada64417a83e	Yulma	Olvera		yulma.o@yahoo.com.	\N	1977-05-29 00:00:00		2025-05-03 20:50:50.553	2025-05-03 20:50:50.553	\N
702c402b-8461-46f8-a7c4-9b77ed0ecbf7	Luis Fernando	Quezada Prieto		luis.quezada@gmail.com	\N	1981-04-06 00:00:00		2025-05-03 20:50:50.553	2025-05-03 20:50:50.553	\N
c9a6a4dd-3d8e-4a86-b6c3-0a44c3d38b7c	Maribel	Grajeda  Villa		moore_yo@hotmail.com	\N	1974-09-02 00:00:00		2025-05-03 20:50:50.553	2025-05-03 20:50:50.553	\N
34a9d84a-c074-4301-ae68-3ed548e64916	Rosa Elvira	Montes Garcia		\N	\N	1969-01-20 00:00:00		2025-05-03 20:50:50.553	2025-05-03 20:50:50.553	\N
5ef81919-7f14-49a3-824a-4ca6ca75e571	Nadia Elizabeth	Torres Ramírez		nadia.torres.ramirez@gmail.com	\N	1991-10-09 00:00:00		2025-05-03 20:50:50.554	2025-05-03 20:50:50.554	\N
69c8b0aa-de91-4897-82fd-36e5127facca	Mario	Sánchez Goméz		\N	\N	1968-05-26 00:00:00		2025-05-03 20:50:50.554	2025-05-03 20:50:50.554	\N
8d4dde01-aaad-4c36-9d2b-b5df9ca404f3	Victor Arturo	Gutierrez Ortiz		vitochaso@aol.com	\N	1988-02-09 00:00:00		2025-05-03 20:50:50.554	2025-05-03 20:50:50.554	\N
97f6019b-04cd-4ef3-bf5d-7b4541636775	Rio	Chenery		riochenery@gmail.com	\N	1982-06-25 00:00:00		2025-05-03 20:50:50.555	2025-05-03 20:50:50.555	\N
f4855ecf-e894-44a5-8881-bc6796a556f8	Rosario	Vazquez Ramírez		vzrmzros@hotmail.com	\N	1972-07-05 00:00:00		2025-05-03 20:50:50.555	2025-05-03 20:50:50.555	\N
624a9899-bc2f-4ae1-9173-106a6210ad2a	Ricardo	Nicolas Lucio		\N	\N	1993-05-13 00:00:00		2025-05-03 20:50:50.555	2025-05-03 20:50:50.555	\N
3592da20-1984-4533-8a07-5f58c794f4b3	Marcea	Ordaz  Thomas		\N	\N	\N		2025-05-03 20:50:50.556	2025-05-03 20:50:50.556	\N
a22522de-3b99-4f0d-a0b7-f54b9ebf0ad1	Maria del Carmen	Correa Rodriguez		mcnenita09@hotmail.com	\N	1980-09-14 00:00:00		2025-05-03 20:50:50.556	2025-05-03 20:50:50.556	\N
e1d82008-4d46-4942-ad3f-6964554bc90f	Kevin Humberto	Palomera García		\N	\N	1989-07-07 00:00:00		2025-05-03 20:50:50.556	2025-05-03 20:50:50.556	\N
6d5574c8-4b03-4cf7-a36f-5fa27434565a	Ricardo	Culebro Morales		\N	\N	1970-02-27 00:00:00		2025-05-03 20:50:50.557	2025-05-03 20:50:50.557	\N
4b3aa647-5a53-4ec9-b960-23812bd0a2ec	Miiriam	GOMEZ RAMIRES		\N	\N	\N		2025-05-03 20:50:50.557	2025-05-03 20:50:50.557	\N
12aea59f-3bff-4ce0-ba04-53a2fe496d84	Pierret	Varin		aroy_papy@outlook.com	\N	1959-12-24 00:00:00		2025-05-03 20:50:50.558	2025-05-03 20:50:50.558	\N
4b23d33e-4451-40f4-bdc6-f4a3a593d792	Rocio Lizeth	Gomez Loza		chiolizgomez1984@gmail.com	\N	1984-01-12 00:00:00		2025-05-03 20:50:50.558	2025-05-03 20:50:50.558	\N
a608f452-819e-459c-a430-c4fe3e39ea1c	Sergio	De Anda Colin		kittoki1982@hotmail.com	\N	1982-01-07 00:00:00		2025-05-03 20:50:50.558	2025-05-03 20:50:50.558	\N
63ed6347-3315-4d8a-8913-fc9bc64edf38	Martha	Angeles Hernandez		cacaoreal@hotmail.com	\N	1946-07-09 00:00:00		2025-05-03 20:50:50.558	2025-05-03 20:50:50.558	\N
3eb88e10-10cb-4095-b114-23d6edbb810a	Yessenia	Alvarez Gutierrez		\N	\N	2009-08-22 00:00:00		2025-05-03 20:50:50.559	2025-05-03 20:50:50.559	\N
1985102a-7b34-4b70-a94c-6f559c638429	Luc	Simard		lucandree1972@hotmail.ca	\N	1950-07-29 00:00:00		2025-05-03 20:50:50.559	2025-05-03 20:50:50.559	\N
cd9e6314-66ce-4e3a-b5fa-6ec953a2cba5	Valeria Anahis	Zuniga Chaire		\N	\N	1992-10-15 00:00:00		2025-05-03 20:50:50.559	2025-05-03 20:50:50.559	\N
13f7443e-3b3f-4c11-be60-461ee6c96785	Rosa Maria	Becerra  Salinas		\N	\N	1966-03-31 00:00:00		2025-05-03 20:50:50.56	2025-05-03 20:50:50.56	\N
8a5bf04c-528d-4d31-885c-9bb01778e530	Maya Sofia	Camarena Cortez		\N	\N	2010-12-17 00:00:00		2025-05-03 20:50:50.56	2025-05-03 20:50:50.56	\N
0dd4d4c0-1870-4fb4-b28d-3028172bae6b	Thea	Cumming		thea_102@hotmail.com	\N	1987-09-11 00:00:00		2025-05-03 20:50:50.56	2025-05-03 20:50:50.56	\N
ccace457-19b9-4f0e-bff9-65e38a51ba33	Maricela	Gomez Martinez		\N	\N	1965-09-02 00:00:00		2025-05-03 20:50:50.561	2025-05-03 20:50:50.561	\N
be007180-122a-4448-b777-14becb29976f	Jude	Mireault		\N	\N	1955-06-10 00:00:00		2025-05-03 20:50:50.561	2025-05-03 20:50:50.561	\N
5107de65-ee50-4178-8b1c-ced96d15530f	Maria Eloisa	Collin Tetlacuilo		\N	\N	1970-12-02 00:00:00		2025-05-03 20:50:50.561	2025-05-03 20:50:50.561	\N
db46c090-b7f9-4212-aeef-d557a99dfc94	Mirna Luz	Contreras Montalvo		\N	\N	1957-09-23 00:00:00		2025-05-03 20:50:50.562	2025-05-03 20:50:50.562	\N
4ed0e442-2b52-4bc4-9ba9-0ed825df1cb0	Reginald	Williams		williamsreginldg@icloud.com	\N	1957-07-05 00:00:00		2025-05-03 20:50:50.562	2025-05-03 20:50:50.562	\N
018b4ebd-6970-494b-95e3-5d21f5aa4db6	Melanie	Amato		info@melvidesigngrpoup.ca	\N	\N		2025-05-03 20:50:50.562	2025-05-03 20:50:50.562	\N
fb345adf-0405-488c-9e63-26365da6681b	Vito	Amato		info@melvidesigmgroup.ca	\N	1958-04-03 00:00:00		2025-05-03 20:50:50.563	2025-05-03 20:50:50.563	\N
eba8d7c9-934b-4a71-86ea-b4606045caea	Leo	Targeon		\N	\N	1953-07-09 00:00:00		2025-05-03 20:50:50.563	2025-05-03 20:50:50.563	\N
491ea719-cb36-4348-87ca-e3a2890e0f89	Line|	Chiasson		linechiasson60@hotmail.com	\N	1960-07-30 00:00:00		2025-05-03 20:50:50.563	2025-05-03 20:50:50.563	\N
34f4dfa4-caa4-4d74-948e-c68e3ec612ba	Placido	Estrada Marquez		placidoestrada@hotmail.com	\N	1963-05-22 00:00:00		2025-05-03 20:50:50.564	2025-05-03 20:50:50.564	\N
ddeaa03e-d2a5-4199-a036-f15925973dd5	Pierrette	Deschamps		pierrette.deschamps01@gmail.com	\N	1951-01-15 00:00:00		2025-05-03 20:50:50.564	2025-05-03 20:50:50.564	\N
826144b9-ff90-484f-9129-b14086071651	Silvia	Flores Jaimes		\N	\N	1993-09-05 00:00:00		2025-05-03 20:50:50.564	2025-05-03 20:50:50.564	\N
35e42ca4-f808-4908-a3f1-88d889d69f96	Juan Luis	Rodriguez Juarez		\N	3222100265	\N		2025-05-03 20:50:50.565	2025-05-03 20:50:50.565	\N
db586975-7fcf-470e-a626-f7d32137434b	Lynda	Michaud		lmlaforme1961@gmail.com	\N	1961-09-27 00:00:00		2025-05-03 20:50:50.565	2025-05-03 20:50:50.565	\N
c059211a-cf7c-44c5-ad3b-61cc1e3575a9	Maria Guadalupe	Rodriguez Contreras		\N	\N	1988-12-12 00:00:00		2025-05-03 20:50:50.565	2025-05-03 20:50:50.565	\N
aa9db660-f734-4864-9b0e-c6da69595760	Regina  Elizabeth	Cruz Vasquez		\N	\N	2012-09-03 00:00:00		2025-05-03 20:50:50.566	2025-05-03 20:50:50.566	\N
3131a11e-c277-471f-99b7-3eee4839c830	Maria Cruz	Placencia Barreto		\N	\N	1960-05-03 00:00:00		2025-05-03 20:50:50.566	2025-05-03 20:50:50.566	\N
571ffb93-15c1-46f4-8035-3bfde16e1efa	Kenia	López Ramos		kenia@banderasproperty.com	\N	1990-02-01 00:00:00		2025-05-03 20:50:50.566	2025-05-03 20:50:50.566	\N
43dd1e67-8f1b-4243-aa44-51fe0bb752be	Roberto	Celiz Carrera		\N	\N	\N		2025-05-03 20:50:50.567	2025-05-03 20:50:50.567	\N
41c7e1f1-bf0b-4861-8d6a-802f05b2b779	Martin	Sandoval Montes		\N	\N	1977-11-11 00:00:00		2025-05-03 20:50:50.567	2025-05-03 20:50:50.567	\N
d5cfb66f-2542-400a-a54f-d08ff10d4de3	Maria de los Angeles	Mejia Alvarez		\N	\N	1970-05-26 00:00:00		2025-05-03 20:50:50.568	2025-05-03 20:50:50.568	\N
508ee83a-ddc3-423e-a0d4-861d5de9debb	Valeria	Garrido Velazco		claudia.garrido2618@albnos.udg.mx	\N	2005-12-29 00:00:00		2025-05-03 20:50:50.568	2025-05-03 20:50:50.568	\N
169dcf84-9829-4d5c-8c2e-392b9a2c7f84	Michel	Boileau		michele.boileau@gmail.com	\N	1950-04-06 00:00:00		2025-05-03 20:50:50.568	2025-05-03 20:50:50.568	\N
185f591e-ed94-4527-834e-b85a6b8b743d	Shelley	Stankovich		\N	\N	1964-12-25 00:00:00		2025-05-03 20:50:50.568	2025-05-03 20:50:50.568	\N
ca8729be-cffd-4af5-b875-4961b8329c11	Odet	Cuevas Monroy		\N	\N	1982-02-21 00:00:00		2025-05-03 20:50:50.569	2025-05-03 20:50:50.569	\N
cfb3e547-eee0-4b67-b8ab-c957634854a5	Maria de LosAngeles	Valencia Morales		\N	\N	\N		2025-05-03 20:50:50.569	2025-05-03 20:50:50.569	\N
2ec6dad3-4e8a-4502-b5b9-30c187b1f1c2	Pedro	Ontiveros Levario		\N	\N	\N		2025-05-03 20:50:50.569	2025-05-03 20:50:50.569	\N
f0662350-1c69-42f9-9058-1b57c4c03276	Sergio	Ibarra  Facebook		\N	\N	1973-06-13 00:00:00		2025-05-03 20:50:50.57	2025-05-03 20:50:50.57	\N
ab8d7716-cb1b-4284-a97b-99169fcaa71b	Luis Alfonso	Romero Mejia		\N	\N	\N		2025-05-03 20:50:50.57	2025-05-03 20:50:50.57	\N
1149d5c1-cf3b-449f-9b79-a502571945b2	Linda	Pelletier		\N	\N	\N		2025-05-03 20:50:50.57	2025-05-03 20:50:50.57	\N
eede4258-d346-4ccf-b4a5-dcd5697fd622	Tom	Mclaughlin		tomjr403@gmail.com	\N	1980-11-22 00:00:00		2025-05-03 20:50:50.571	2025-05-03 20:50:50.571	\N
b50907e9-3c52-4db8-8460-6cc970dd6bf6	Raul	Morales Acevez		drmorales1999@gmail.com	\N	\N		2025-05-03 20:50:50.571	2025-05-03 20:50:50.571	\N
46b9473c-07c7-470d-b519-5b85b5dded75	Robert	Burke		centauto03@zgmail.com	\N	1954-01-07 00:00:00		2025-05-03 20:50:50.571	2025-05-03 20:50:50.571	\N
528036d4-5066-49e1-a1d3-3976721b51a2	Pierre	Chartrand		pierrechartrand.60@hotmail.com	\N	1948-12-04 00:00:00		2025-05-03 20:50:50.572	2025-05-03 20:50:50.572	\N
914da5fa-0bac-4c01-92b9-f34f01aaa6c9	Marcel	Asselin		\N	\N	\N		2025-05-03 20:50:50.572	2025-05-03 20:50:50.572	\N
565774bf-e7ea-457f-9a87-3d02ceebcaaf	Noe	Delos Santos Garcia		\N	\N	\N		2025-05-03 20:50:50.572	2025-05-03 20:50:50.572	\N
a8affbc3-0fcf-43b2-8268-792e1678a838	Raymond	Couturier		\N	\N	1956-05-10 00:00:00		2025-05-03 20:50:50.573	2025-05-03 20:50:50.573	\N
7f489024-7acd-4dc3-9274-1d18443b377d	Maria de los Angeles	Lopez Lopez		\N	\N	1961-09-01 00:00:00		2025-05-03 20:50:50.573	2025-05-03 20:50:50.573	\N
f930f70c-cfca-4c0e-b536-45d7a9b3cca1	Pablo	Castellanos Toledano		\N	\N	1992-08-15 00:00:00		2025-05-03 20:50:50.573	2025-05-03 20:50:50.573	\N
b767ae4f-2b8d-4cf4-8de8-471971fd919b	Marc	Copeland		pastor@pjpc.net	\N	1967-02-19 00:00:00		2025-05-03 20:50:50.574	2025-05-03 20:50:50.574	\N
711c5e9d-6831-470f-be1c-8e7269e344de	Maria José	Vega Vázquez		\N	\N	1995-10-23 00:00:00		2025-05-03 20:50:50.574	2025-05-03 20:50:50.574	\N
fa799e64-2589-41c3-b352-2f9032fbe4f1	Misael	Montes Saenz		asim1008@hotmail.com	\N	1982-03-04 00:00:00		2025-05-03 20:50:50.574	2025-05-03 20:50:50.574	\N
35dc18a1-c973-40d4-894d-303640072561	Manon	Maltais		manon.maltais@securite180.com	\N	1953-12-04 00:00:00		2025-05-03 20:50:50.574	2025-05-03 20:50:50.574	\N
add5a771-fb65-427c-89d3-9689bc926191	Melanie	Copeland		\N	\N	\N		2025-05-03 20:50:50.575	2025-05-03 20:50:50.575	\N
d8187022-445e-45fa-99f6-b87ae3430ff1	Maritrini	Meza		\N	\N	\N		2025-05-03 20:50:50.575	2025-05-03 20:50:50.575	\N
2b73924d-f339-418f-aa15-6071505e08b4	Suparna	Ferreida		\N	\N	1970-07-13 00:00:00		2025-05-03 20:50:50.575	2025-05-03 20:50:50.575	\N
d4ec1a22-b10d-4f0c-bab0-bcf9be849a3b	Rosario	Martinez Gallardo		\N	\N	\N		2025-05-03 20:50:50.576	2025-05-03 20:50:50.576	\N
0784affb-f642-4bf2-af73-22a211870b8e	Maria  DEL REFUGIO	Ruelas Ramos		\N	3222607605	1963-03-27 00:00:00		2025-05-03 20:50:50.576	2025-05-03 20:50:50.576	\N
e40266c8-0ee0-469c-94e9-8b05f5c55eae	Lievier	Huerta Aguirre		\N	\N	\N		2025-05-03 20:50:50.576	2025-05-03 20:50:50.576	\N
938844ba-ea64-40a5-bdec-b3987ae8b664	Serafin	Aviles Medina		marioschingale@hotmail.com	\N	1976-09-09 00:00:00		2025-05-03 20:50:50.577	2025-05-03 20:50:50.577	\N
7c4cc842-2113-422e-8c47-2fda6b1c65d2	Stanly	Tod		\N	3222231685	\N		2025-05-03 20:50:50.577	2025-05-03 20:50:50.577	\N
83985ca4-d739-4ce0-9ed3-e1dcbe10a56c	Maricela	Albor Gabiño		\N	\N	\N		2025-05-03 20:50:50.577	2025-05-03 20:50:50.577	\N
bbe72862-6019-4114-b41f-ce044c5f42f3	Teresa	Enciso		\N	\N	\N		2025-05-03 20:50:50.578	2025-05-03 20:50:50.578	\N
3bbd9cdb-94a9-43da-afbd-57fdac3419ca	Veronica	Flores Arriagada		focver@yahoo.com	3112584571	1972-01-02 00:00:00		2025-05-03 20:50:50.578	2025-05-03 20:50:50.578	\N
eb21439a-6677-4dd6-91f9-02cd32f34121	Yesenia	Rodriguez Lopez		\N	\N	\N		2025-05-03 20:50:50.578	2025-05-03 20:50:50.578	\N
66fde74c-b1ee-4c27-8f06-58ff918d4e3e	Lucia	Ruiz Rios		\N	\N	1972-12-15 00:00:00		2025-05-03 20:50:50.579	2025-05-03 20:50:50.579	\N
8583aac5-7d22-4a6d-b572-e2ccc3cbdb77	Marilu	Dihos		aguilaelectrica7@gmail.com	\N	1986-11-29 00:00:00		2025-05-03 20:50:50.579	2025-05-03 20:50:50.579	\N
41a244ed-28ed-4215-85da-56d3dd235b6a	Yesenia Gpe.	Resendiz Padrón		yeseniarespa@outlloock.com	\N	1991-02-28 00:00:00		2025-05-03 20:50:50.579	2025-05-03 20:50:50.579	\N
426427b9-f943-49a0-aa40-d0adcbbe5a3f	Wendy Leanne	Retureta Oliva		\N	\N	1992-11-23 00:00:00		2025-05-03 20:50:50.58	2025-05-03 20:50:50.58	\N
47655e70-1171-4132-9f8b-c53a11a65921	Miguel	Galindo Diaz		miguelgalindod@hotmail.com	\N	1984-03-08 00:00:00		2025-05-03 20:50:50.58	2025-05-03 20:50:50.58	\N
d6f41993-f3cc-4773-89c4-843a5ed3044a	Rosa Gpe.	Cordiva Barraza		rosaderosas21@gmail.com	\N	1988-09-02 00:00:00		2025-05-03 20:50:50.58	2025-05-03 20:50:50.58	\N
2ed2d037-0460-48a8-bd15-2f0ad959a5b0	Luis Manuel	Spiller Bravo		luisspiler72@gmail.com	\N	1972-08-20 00:00:00		2025-05-03 20:50:50.581	2025-05-03 20:50:50.581	\N
2feaee96-135f-4534-9803-77ce736a67aa	Samanta	Lopez		\N	\N	\N		2025-05-03 20:50:50.581	2025-05-03 20:50:50.581	\N
5e659ce1-128d-42a2-be12-824829b62b65	Veronica Karina	Sandoval Peña		karysandp@aotloock.es	3222273270	1999-05-08 00:00:00		2025-05-03 20:50:50.581	2025-05-03 20:50:50.581	\N
e2c548ea-22be-429a-ad57-a169d655adfe	Nicoletta	Rubino		nicolettarubino@yahoo.com	\N	1967-01-09 00:00:00		2025-05-03 20:50:50.581	2025-05-03 20:50:50.581	\N
beaa76ad-802a-45fc-9ab5-933b00839639	Maricela	ZuñigA Moreno		maja_43@hotmail.com	\N	1965-03-05 00:00:00		2025-05-03 20:50:50.582	2025-05-03 20:50:50.582	\N
54b59578-80a7-4458-b89f-6ac3918f1d7f	Zied	Berrayes		\N	\N	1977-02-05 00:00:00		2025-05-03 20:50:50.582	2025-05-03 20:50:50.582	\N
2c29454e-5d9a-4a3d-8b07-7609fa4e6f70	Yesi	Silva Rangel		\N	\N	\N		2025-05-03 20:50:50.582	2025-05-03 20:50:50.582	\N
c3c57fc9-74ea-4afb-9305-8716ce3d7e4f	Ma. delos Angeles	Delgadillo		\N	\N	1972-05-08 00:00:00		2025-05-03 20:50:50.583	2025-05-03 20:50:50.583	\N
e5799644-d89a-40c0-92ae-3d2d976e3d32	Maria de los Angeles	Delgadillo Inda		angelesgarcia72@hotmail.com	\N	1972-05-08 00:00:00		2025-05-03 20:50:50.583	2025-05-03 20:50:50.583	\N
92fb68d1-264e-4349-b590-9b89b421aa87	Norma	Mendiola Nonato		\N	\N	\N		2025-05-03 20:50:50.583	2025-05-03 20:50:50.583	\N
6407e2b8-870e-464b-a514-899abf9f1f86	Rodolfo	Samudio Hernández		rzh22@aol.com	\N	1953-04-16 00:00:00		2025-05-03 20:50:50.584	2025-05-03 20:50:50.584	\N
77064746-082e-49a4-8729-28c6c9f064cc	Manuel	Rivas Castañeda		\N	\N	\N		2025-05-03 20:50:50.584	2025-05-03 20:50:50.584	\N
4fba4dc3-b036-4077-bc8e-6c36d7dfc324	Silviano	Galindo Morquecho		licgalindo500@hotmail.com	\N	1970-07-16 00:00:00		2025-05-03 20:50:50.584	2025-05-03 20:50:50.584	\N
cabf4a95-6d56-4b0b-b146-18a3941af907	Sergio Julian	Luna Murillo		checobombero@hotmail.com	\N	1958-06-25 00:00:00		2025-05-03 20:50:50.585	2025-05-03 20:50:50.585	\N
49eb0add-adef-4cc2-a13c-62637983acd6	Tirza Miranda	Gracida Alcántara		\N	3221140572	2012-06-30 00:00:00		2025-05-03 20:50:50.585	2025-05-03 20:50:50.585	\N
c6bd9bc5-ed8b-4413-89ae-ee545fc7c784	Nereida Rubi	Lopéz Grijalba		\N	\N	2004-01-03 00:00:00		2025-05-03 20:50:50.585	2025-05-03 20:50:50.585	\N
b7833300-5301-4a78-8eb9-32a54e033b81	Nicolas	Grimbert		\N	\N	1988-11-22 00:00:00		2025-05-03 20:50:50.586	2025-05-03 20:50:50.586	\N
6ffee4d6-2ef5-4ca4-99f1-249294ebefdc	Veronica	Llanos Cervantes		\N	\N	\N		2025-05-03 20:50:50.586	2025-05-03 20:50:50.586	\N
00dac51f-0a44-47c5-96ef-4bf5c10d44e1	Marusa	Rodriguez Valenzuela		\N	\N	\N		2025-05-03 20:50:50.587	2025-05-03 20:50:50.587	\N
fb0b4253-1fde-4776-82b0-703eba2bce72	Victor Manuel	Martinez		\N	\N	\N		2025-05-03 20:50:50.587	2025-05-03 20:50:50.587	\N
869d7e3f-901d-455e-b68f-26f93bfbcf4c	Maria	Lopez Franco		\N	\N	1973-04-30 00:00:00		2025-05-03 20:50:50.587	2025-05-03 20:50:50.587	\N
013e37ca-4f8e-49fc-88b0-3405b6c1c0fa	Stephanie	Zepeda Camacho		stephanie.zepeda@hidrocalidos.com	3222994832	\N		2025-05-03 20:50:50.588	2025-05-03 20:50:50.588	\N
2989327c-8c4e-4df6-8ecf-393bb7028203	Raul	Rodriguez Troncozo		\N	\N	1963-08-06 00:00:00		2025-05-03 20:50:50.588	2025-05-03 20:50:50.588	\N
ec87cd76-e877-4727-9c25-8fcb251b419c	Ramon	Salmeron Chavez		\N	\N	1966-11-27 00:00:00		2025-05-03 20:50:50.588	2025-05-03 20:50:50.588	\N
cf3c78fa-e005-4b18-8a29-ab2b79ece48c	Maria de los Angeles	Hernández Castillo		morgan22_angie24@hotmail.com	\N	1987-09-27 00:00:00		2025-05-03 20:50:50.589	2025-05-03 20:50:50.589	\N
b8d1edaa-c994-49a6-b66a-ec5acb065d53	Tim	xxx		\N	\N	\N		2025-05-03 20:50:50.589	2025-05-03 20:50:50.589	\N
26dfa391-d6cd-4208-8158-da16dbd933d4	Laura Xitallit	Ayala López		barbyelovely@live.com.mx	6869066006	1986-02-07 00:00:00		2025-05-03 20:50:50.589	2025-05-03 20:50:50.589	\N
49f56412-107c-40ac-a3ed-413fc8769f2d	Santa	Vargas Miranda		\N	\N	1957-04-16 00:00:00		2025-05-03 20:50:50.59	2025-05-03 20:50:50.59	\N
62d61cea-515d-4db0-9120-77653da4494d	Nubia Ibeth	Matamoros Hernandez		\N	\N	1981-11-18 00:00:00		2025-05-03 20:50:50.59	2025-05-03 20:50:50.59	\N
b34a9eb8-3c0a-44d2-8eda-b62dcb7c82f1	Timothy	Horn		\N	+18432412553	\N		2025-05-03 20:50:50.59	2025-05-03 20:50:50.59	\N
b7effe88-6193-4a17-a433-c3a53d9bd759	Rosa	Aguirre Sanchez		\N	\N	\N		2025-05-03 20:50:50.591	2025-05-03 20:50:50.591	\N
2f85fea5-e804-4aa4-8210-ba14b6303aa1	Olga	Hill		olgabest28@msn.com	\N	1974-08-10 00:00:00		2025-05-03 20:50:50.591	2025-05-03 20:50:50.591	\N
95178b2a-0b47-4843-9ed6-48b4e2fda5d5	Juan Orlando	Quezada Lara		\N	\N	\N		2025-05-03 20:50:50.591	2025-05-03 20:50:50.591	\N
fd6c4cee-2a0b-42f5-abf7-c4f049fe26c4	Vania	Rodriguez Barraza		\N	\N	1999-10-13 00:00:00		2025-05-03 20:50:50.592	2025-05-03 20:50:50.592	\N
2ae5f204-4380-4668-9532-efaa586b3d93	Maria de la Cruz	Medel García		\N	\N	1971-03-29 00:00:00		2025-05-03 20:50:50.592	2025-05-03 20:50:50.592	\N
d8221453-1fdf-4ba5-9725-887351edc977	Noemi	Joya		\N	\N	\N		2025-05-03 20:50:50.592	2025-05-03 20:50:50.592	\N
986e5e5f-27bb-416d-9274-573c3d1fea26	Perla Rubi	Torres Martinez		\N	\N	1984-02-10 00:00:00		2025-05-03 20:50:50.593	2025-05-03 20:50:50.593	\N
eb1c6909-efc5-4ec6-8536-68aeb0fa8f35	Rosa	Garcia Flores		\N	3221344969	1962-09-11 00:00:00		2025-05-03 20:50:50.593	2025-05-03 20:50:50.593	\N
7b095687-19fb-4183-9e86-734618785691	Leslye	Castillo		ly.castle.k@outoock.com	\N	1993-05-17 00:00:00		2025-05-03 20:50:50.593	2025-05-03 20:50:50.593	\N
e25caa51-ae14-42e2-943f-afc7d540b065	Odilo	Jurgrn dr Voe		\N	\N	1944-11-30 00:00:00		2025-05-03 20:50:50.593	2025-05-03 20:50:50.593	\N
81041ff7-592f-4e0a-9894-20dfd9f98116	Laura	Soberanis Stephens		lasos52@gmail.com	\N	1958-07-11 00:00:00		2025-05-03 20:50:50.594	2025-05-03 20:50:50.594	\N
c00516bf-f334-4451-b4da-2c1516eba65d	Rene	Camirand		\N	\N	1945-06-09 00:00:00		2025-05-03 20:50:50.594	2025-05-03 20:50:50.594	\N
b2d280ab-9176-419d-bc27-6bb8b657da1a	Marta	Reinaga Hdz.		marluidan@htmail.com	\N	1965-08-21 00:00:00		2025-05-03 20:50:50.594	2025-05-03 20:50:50.594	\N
8112776f-8f41-4d9b-908b-f6e39b6163c3	Maria	Gomez Aguilar		\N	\N	1968-06-21 00:00:00		2025-05-03 20:50:50.595	2025-05-03 20:50:50.595	\N
16729cf5-554c-4dcc-a801-0661a3e716b4	Perla Jasmin	Lopez Arechiga		\N	\N	1997-03-30 00:00:00		2025-05-03 20:50:50.595	2025-05-03 20:50:50.595	\N
c218c863-6597-4d3c-a8d7-c7f99e856d0a	Rosa Elena	Beltran Reynaga		rosa35.2@hotmail.com	3222690315	1968-04-18 00:00:00		2025-05-03 20:50:50.595	2025-05-03 20:50:50.595	\N
9a080fa4-0799-4824-810f-73561f580881	Santa	Rodriguez dela Garza		\N	\N	\N		2025-05-03 20:50:50.596	2025-05-03 20:50:50.596	\N
d72adb1d-65a8-4233-b73a-be6442d7fd3e	Norma Aracely	Macedo Arce		\N	\N	1974-07-07 00:00:00		2025-05-03 20:50:50.596	2025-05-03 20:50:50.596	\N
0e8f3d67-abe4-4bd4-a6e6-dc070e0f8cd0	Maria del Carmen	Sat  Jimenez		\N	\N	1955-04-15 00:00:00		2025-05-03 20:50:50.596	2025-05-03 20:50:50.596	\N
7feceb80-d38c-401a-b5ca-cbd3dd6dbd4f	Karen Monserrat	Quintero Araiza		\N	\N	1992-11-13 00:00:00		2025-05-03 20:50:50.597	2025-05-03 20:50:50.597	\N
b92b3bf3-3739-4561-9389-368e49c12d86	Maria	Sanchez Pelayo		\N	\N	1961-08-09 00:00:00		2025-05-03 20:50:50.597	2025-05-03 20:50:50.597	\N
5baa84ad-0c6a-4841-9698-ec0fb88dbad9	Lauro	Perez Ruiz		lauroperez@gmail.com	3223194147	1963-01-02 00:00:00		2025-05-03 20:50:50.597	2025-05-03 20:50:50.597	\N
fdff0c78-2d82-49e7-b017-126a0ee7cda5	Pablo Alberto	Perez Otamendi		\N	3222032353	2007-03-27 00:00:00		2025-05-03 20:50:50.598	2025-05-03 20:50:50.598	\N
24ece1fc-0a59-4624-9d0e-51e29fd58b86	Marcel	Frian		\N	\N	\N		2025-05-03 20:50:50.598	2025-05-03 20:50:50.598	\N
0e81d781-ecd8-47f4-9f09-4b76366c0684	Paulina	Guerrero Sandoval		\N	\N	\N		2025-05-03 20:50:50.598	2025-05-03 20:50:50.598	\N
3996bd37-a8d7-4039-84ea-353b7751b7ab	Rosario	Ramirez Tapia		olmosros@yahoo.com	\N	1976-08-28 00:00:00		2025-05-03 20:50:50.599	2025-05-03 20:50:50.599	\N
039ee5df-7477-468d-a873-7dc9bf9ab209	Rogeiro	Rodriguez Haro		\N	\N	1969-08-13 00:00:00		2025-05-03 20:50:50.599	2025-05-03 20:50:50.599	\N
ce634f80-3710-4d23-a575-fcd957bca816	Laura Fernanda	Perez Otamendi		\N	\N	2004-09-06 00:00:00		2025-05-03 20:50:50.599	2025-05-03 20:50:50.599	\N
7cc7bb1a-d4ab-4648-ab89-e69c401279db	Liduvina	Estrada Robles		\N	\N	\N		2025-05-03 20:50:50.6	2025-05-03 20:50:50.6	\N
0fa41dae-0b92-476d-957d-d59b1124583f	Patricia	Wynn  Milne		wynnpm2000@yahoo.com	\N	1944-10-21 00:00:00		2025-05-03 20:50:50.6	2025-05-03 20:50:50.6	\N
d5aea676-3a2e-4775-ae83-0e3b10747311	Ketie	Tran		\N	\N	\N		2025-05-03 20:50:50.601	2025-05-03 20:50:50.601	\N
80d093e4-b901-4e1e-9847-dc839c9f89df	Pablo	Martines Vivar		\N	\N	\N		2025-05-03 20:50:50.601	2025-05-03 20:50:50.601	\N
8a50fa65-8994-4cd5-96eb-3a86ec4cef48	Marta Leticia	Gonzales Ramirez		\N	\N	1965-07-29 00:00:00		2025-05-03 20:50:50.601	2025-05-03 20:50:50.601	\N
6de90e4e-92f5-4402-8a3f-a59df917f547	Nadia Elena	Colmenares Gutierrez		redkey820@gmail.com	\N	1979-02-11 00:00:00		2025-05-03 20:50:50.602	2025-05-03 20:50:50.602	\N
fb3a8ff4-b4e5-4e26-bf92-2f1d119e58c6	Shadie	Akram AbedKader		shadkader4@gmail.com	\N	1985-01-08 00:00:00		2025-05-03 20:50:50.602	2025-05-03 20:50:50.602	\N
d39c50d4-98e6-49ed-a176-8ddf2ea1d249	Martin	Milne		martinmilne@hotmail.com	\N	1968-04-15 00:00:00		2025-05-03 20:50:50.602	2025-05-03 20:50:50.602	\N
d28ed15a-37e0-465a-aa65-7274601156a6	Sofia Elena	García Sánchez		teresa_80@yahoo.com	\N	2008-04-29 00:00:00		2025-05-03 20:50:50.603	2025-05-03 20:50:50.603	\N
93a3cc12-24d3-4b63-b5c1-1c60afd62267	Lizbeth	Ramos Jimenez		\N	\N	\N		2025-05-03 20:50:50.603	2025-05-03 20:50:50.603	\N
2391fc1b-7553-4b4b-86b4-4cfca0cf4980	Susana	Hernández Vivanco		\N	\N	1984-12-20 00:00:00		2025-05-03 20:50:50.603	2025-05-03 20:50:50.603	\N
0b0c9b04-2142-4362-a309-6df60603f7b9	Rosa Linda	Masedo de Hernández		\N	\N	1966-04-11 00:00:00		2025-05-03 20:50:50.604	2025-05-03 20:50:50.604	\N
e85fb11d-9e70-4b13-a432-a27d4adda202	Maura Gardrnia	Felix Castillo		garnedia1516@hotmail.com	\N	1984-11-28 00:00:00		2025-05-03 20:50:50.604	2025-05-03 20:50:50.604	\N
b23022fe-abd6-4467-a972-78d2390a216f	Lorraine	Vibert		\N	\N	\N		2025-05-03 20:50:50.604	2025-05-03 20:50:50.604	\N
ec1680c9-2878-4c95-bfb5-05fed37187fe	Monique	Trudel		funniface2000@hotmail.com	\N	1948-07-27 00:00:00		2025-05-03 20:50:50.605	2025-05-03 20:50:50.605	\N
679bf35c-6836-40e2-9c1a-7f9200ede95f	Lucinda	Heywwod		\N	\N	\N		2025-05-03 20:50:50.605	2025-05-03 20:50:50.605	\N
0f0dd453-1cda-4830-8861-00907cee4ee1	Victor	Perez Hernandez		\N	\N	1985-10-17 00:00:00		2025-05-03 20:50:50.605	2025-05-03 20:50:50.605	\N
5ca5e8aa-a110-4eb2-bed3-116e0597f65f	Sylvain	Tremblay		sylvain1955@bell.net	\N	1955-08-12 00:00:00		2025-05-03 20:50:50.605	2025-05-03 20:50:50.605	\N
30a6771f-1f14-423b-bcd4-9fae048860cc	Mario	Sanchez  Hait		\N	3221410989	1967-10-08 00:00:00		2025-05-03 20:50:50.606	2025-05-03 20:50:50.606	\N
71bbf014-c5a8-4454-a328-c1cad78ef4eb	Karina	González Rodriguez		\N	\N	\N		2025-05-03 20:50:50.606	2025-05-03 20:50:50.606	\N
352e265f-4452-450f-a8d0-a6329c0b888f	Laura	Muños Castro		\N	\N	1969-01-01 00:00:00		2025-05-03 20:50:50.606	2025-05-03 20:50:50.606	\N
487a5dfa-c0f8-4bd5-af68-f2ed23dbf3c1	Monica	Topete Cortez		\N	\N	\N		2025-05-03 20:50:50.607	2025-05-03 20:50:50.607	\N
b86dd1fa-5eba-4e66-8ee8-982ef0d465e8	Marisol	Fonseca Pacheco		\N	\N	1996-06-05 00:00:00		2025-05-03 20:50:50.607	2025-05-03 20:50:50.607	\N
b4bd3ffd-d43d-4b2d-9045-c0d49c716a58	Rose	Maltais		manon.maltais@securite180.com	\N	1941-11-06 00:00:00		2025-05-03 20:50:50.607	2025-05-03 20:50:50.607	\N
44587f10-fd9d-4da9-8bd5-c3801eaff11e	Louis	Matew		\N	\N	\N		2025-05-03 20:50:50.608	2025-05-03 20:50:50.608	\N
aff7cb3d-448c-4495-aa6d-5c29d52e3fe3	Monica	Torres Andrade		\N	\N	1984-04-28 00:00:00		2025-05-03 20:50:50.608	2025-05-03 20:50:50.608	\N
44ae422e-519e-4896-bae3-cfb0b48d940c	NESTOR	OSUNA LEYBA		oslynn16@gmail.com	\N	1990-11-23 00:00:00		2025-05-03 20:50:50.608	2025-05-03 20:50:50.608	\N
83c5f3c5-4963-4806-a5c1-602299999e6a	Luana	Matthews		luanamatt@icloud.com	\N	1977-10-10 00:00:00		2025-05-03 20:50:50.609	2025-05-03 20:50:50.609	\N
df34e690-8303-4730-b657-fae50e620bde	Yesenia	Alvarez Gutierrez		\N	\N	\N		2025-05-03 20:50:50.609	2025-05-03 20:50:50.609	\N
dfd15f22-a631-4661-917f-0cc3eb15ed6b	Maria Guadalupe	Rodriguez Wente		marilupita2@gmail.com	\N	1980-02-18 00:00:00		2025-05-03 20:50:50.609	2025-05-03 20:50:50.609	\N
2ba8ae26-73ab-4442-8686-7c07f770cbf2	kimberly	Rios Escatel		anahidescatel@gmail.com	\N	2012-07-21 00:00:00		2025-05-03 20:50:50.609	2025-05-03 20:50:50.609	\N
a5f98b9d-82ff-40ec-aab1-aa3cb624afb9	Rafael	Horwood Sanchez		\N	\N	2001-11-10 00:00:00		2025-05-03 20:50:50.61	2025-05-03 20:50:50.61	\N
fa18fe78-1ebc-41cc-a26f-3d96b2340a40	Maricela	Luis Valdez		\N	\N	1986-11-17 00:00:00		2025-05-03 20:50:50.61	2025-05-03 20:50:50.61	\N
6dcd5cef-9d8b-4992-89be-6927c8e0fe08	Renata	Murez		\N	\N	\N		2025-05-03 20:50:50.61	2025-05-03 20:50:50.61	\N
e9df3f06-e8d5-4d54-b48c-6b977630dae8	Maria De Jesus	Escalante Perez		\N	\N	\N		2025-05-03 20:50:50.611	2025-05-03 20:50:50.611	\N
8c115965-b8bf-4536-b427-c7bf470a3419	Rigoberto	Bañulos López		rgobl_2487@hotmail.com	\N	1987-09-24 00:00:00		2025-05-03 20:50:50.611	2025-05-03 20:50:50.611	\N
049d258b-4533-4ca7-8503-bdd1f1b5f32e	Marie France	Gasse		\N	\N	\N		2025-05-03 20:50:50.612	2025-05-03 20:50:50.612	\N
1385028b-ea59-4277-9827-303fc71273b5	Ricardo Guadalupe	Hernández Becerra		ricardo.h7@gmail.com	\N	1996-12-12 00:00:00		2025-05-03 20:50:50.612	2025-05-03 20:50:50.612	\N
791d4508-22fe-42fd-b4f5-c272e0e77245	Landy Raquel	Sanchez Garcia		landyraquelsanchezgarcia@gmail.com	\N	2000-03-11 00:00:00		2025-05-03 20:50:50.612	2025-05-03 20:50:50.612	\N
6658e3f7-109c-4f68-b10a-1994b395d926	Louise	Mullins		\N	\N	\N		2025-05-03 20:50:50.613	2025-05-03 20:50:50.613	\N
b234a3d7-5bd9-4c1a-9d1d-184ea33e579e	Richard	Paquette		\N	\N	\N		2025-05-03 20:50:50.613	2025-05-03 20:50:50.613	\N
5d968b04-afe0-4800-9e01-7e083a688ea0	Marial del Carmen	Cancinos Zarate		\N	\N	1980-01-15 00:00:00		2025-05-03 20:50:50.613	2025-05-03 20:50:50.613	\N
689a0f64-503d-4734-86ad-c232a78ae799	Pedro	Tavares		pedro_tabares@hotmail.com	\N	1984-05-14 00:00:00		2025-05-03 20:50:50.613	2025-05-03 20:50:50.613	\N
1bb995da-d620-4de0-85c6-451c45bc3a86	Patric	Greene		\N	\N	1944-03-15 00:00:00		2025-05-03 20:50:50.614	2025-05-03 20:50:50.614	\N
47f132ee-aedf-4988-8981-224ba51bd17f	Osca	Leroyd		\N	\N	\N		2025-05-03 20:50:50.614	2025-05-03 20:50:50.614	\N
a7145866-c20b-4ec8-8aa1-ceeb83b7f4d0	Lise	Vailleux		\N	\N	1955-01-11 00:00:00		2025-05-03 20:50:50.614	2025-05-03 20:50:50.614	\N
fd6c08d5-111a-4a20-9dc8-0dc92b1923a9	Marquis	Rodrigue		\N	\N	1954-01-07 00:00:00		2025-05-03 20:50:50.615	2025-05-03 20:50:50.615	\N
070061b3-4d1f-41af-a134-4fc2e77e5632	Laura Veronica	Ku		\N	\N	1982-08-01 00:00:00		2025-05-03 20:50:50.615	2025-05-03 20:50:50.615	\N
061b6b92-b88d-42d7-8806-e37ec5714840	Santiago	Valenzuela León.		chichuvalenzuela@gmail.com	\N	1978-06-17 00:00:00		2025-05-03 20:50:50.615	2025-05-03 20:50:50.615	\N
415e271c-01bb-4a90-9ffa-eebccde61c42	Said Eduardo	Arias Rodriguez		\N	\N	\N		2025-05-03 20:50:50.616	2025-05-03 20:50:50.616	\N
324cce50-af98-4fcc-9470-f0d8651fb1c6	Kathryn	Karp		\N	\N	\N		2025-05-03 20:50:50.616	2025-05-03 20:50:50.616	\N
4c2faa2c-a0f1-48e4-ac15-0969b1474592	Maria Elena	Torres Monteón		elenamonteon@gmail.com	\N	1985-12-23 00:00:00		2025-05-03 20:50:50.616	2025-05-03 20:50:50.616	\N
a90b2cb1-8b85-427a-bcac-716b9fcae211	Kimberrly Mayte	Iñigues Espinosa		\N	\N	2012-11-06 00:00:00		2025-05-03 20:50:50.617	2025-05-03 20:50:50.617	\N
8a1724ec-a976-4f73-be82-0867bbb13fcc	Santos Giorvani	Rivera Solorzano		anseewoo334@gmail.com	\N	2003-01-07 00:00:00		2025-05-03 20:50:50.617	2025-05-03 20:50:50.617	\N
3c7a247a-866b-4682-b398-77525d95d9ea	Yvon	Henr		\N	\N	1953-07-15 00:00:00		2025-05-03 20:50:50.617	2025-05-03 20:50:50.617	\N
eed73fb4-c998-4152-b093-ede9a146cf1a	Monica	Manzo Rincon		manzo.ciages2011@gmail.com	\N	1985-10-27 00:00:00		2025-05-03 20:50:50.618	2025-05-03 20:50:50.618	\N
6c7028da-32aa-4a35-b6bc-f3b2a8489887	Patrick	Mason		o.vmason@sasktel.net	\N	1965-03-20 00:00:00		2025-05-03 20:50:50.618	2025-05-03 20:50:50.618	\N
fd885e53-0a3c-4c5d-832a-24b367e1bf68	Rocio	Ochoa del Rio		\N	\N	1952-10-09 00:00:00		2025-05-03 20:50:50.618	2025-05-03 20:50:50.618	\N
f5ba608d-379f-4ca4-8b71-9b5dcc4b09bc	Ma. de Jesus	Castillo Acuña		\N	\N	1967-07-31 00:00:00		2025-05-03 20:50:50.619	2025-05-03 20:50:50.619	\N
54025d50-15cf-4a37-a128-3d837809fab8	Sandra	Rush		cameofacials7@yahoo.ca	\N	1971-02-28 00:00:00		2025-05-03 20:50:50.619	2025-05-03 20:50:50.619	\N
498be89b-1651-4250-90ff-32323ffe74cc	Melissa Jaqueline	Martinez Curiel		cgaviota79@hotmail.com	\N	2007-09-20 00:00:00		2025-05-03 20:50:50.619	2025-05-03 20:50:50.619	\N
e56bdcb9-783b-4425-8616-fd684b920061	Nadim	Flores Yamaui		nadimflores@gmail.com	5574072349	1989-10-08 00:00:00		2025-05-03 20:50:50.619	2025-05-03 20:50:50.619	\N
359db201-908e-4fe9-b5e6-1151e88d8858	Susan Diane	Moore		dianemooresc@gmail.com	\N	1956-11-21 00:00:00		2025-05-03 20:50:50.62	2025-05-03 20:50:50.62	\N
e09377ee-4a7c-4f3f-8a85-fa3db8f3830d	Victoria	Leroy		\N	\N	\N		2025-05-03 20:50:50.62	2025-05-03 20:50:50.62	\N
b0905038-3aa7-49b2-a17d-3cdeff75cc4c	Natalia	PERALTA MORALES		nataliap100@yahoo.com.mx	\N	1957-02-05 00:00:00		2025-05-03 20:50:50.62	2025-05-03 20:50:50.62	\N
ae19c93d-3c55-4733-9bee-4e97d979791f	Lorena	Hernández López		\N	\N	1990-05-18 00:00:00		2025-05-03 20:50:50.621	2025-05-03 20:50:50.621	\N
1fcae229-4cbe-4484-a33c-d3062186ace3	Viviana	Olivares Bañuelos		\N	\N	1971-07-05 00:00:00		2025-05-03 20:50:50.621	2025-05-03 20:50:50.621	\N
7771d5fd-0485-4dd9-93a2-3289a4a3109e	Maria Minerva	Salinas Rodriguez		\N	\N	\N		2025-05-03 20:50:50.621	2025-05-03 20:50:50.621	\N
141c7f23-4988-4069-8f04-22669905a85b	Mikell	Millar		\N	\N	\N		2025-05-03 20:50:50.622	2025-05-03 20:50:50.622	\N
80cf9692-97f0-44fd-8e8b-bc720cb9adb2	Leonardo Ismael	Perez del Villar		Bere_bp13@hotmail.com	\N	2014-06-11 00:00:00		2025-05-03 20:50:50.622	2025-05-03 20:50:50.622	\N
f7e5e234-fd63-437b-b105-b27e4e835ded	Luz Maria	Cobian Gutierrez		\N	\N	1994-05-24 00:00:00		2025-05-03 20:50:50.623	2025-05-03 20:50:50.623	\N
71f64ac5-adae-4a38-b9a5-a4f0f2f1f15b	Teresa	Torres Alvarado		\N	\N	1969-10-03 00:00:00		2025-05-03 20:50:50.623	2025-05-03 20:50:50.623	\N
8fae0513-fb2e-4bc4-8f5e-39acb075c97d	Kimberly	Nistet		kimnisbet@yahoo.com	\N	1968-09-04 00:00:00		2025-05-03 20:50:50.623	2025-05-03 20:50:50.623	\N
45046d59-8410-43b8-ab06-35f3a6f867da	Norma Irene	Suzán Fontanillo		\N	\N	1991-07-15 00:00:00		2025-05-03 20:50:50.624	2025-05-03 20:50:50.624	\N
bdf2d722-2bf8-41c1-bbc7-41ed0b73c64e	Salvador	Mendez Cachu		\N	\N	\N		2025-05-03 20:50:50.624	2025-05-03 20:50:50.624	\N
29b9f6ac-3560-46bd-a690-71f70e01fc91	Wemdy	Zarate Solis		\N	\N	\N		2025-05-03 20:50:50.624	2025-05-03 20:50:50.624	\N
3957a63a-2b9a-40e9-8189-ef8f52e822aa	Prisciliano	Guzman Sanchez		\N	\N	\N		2025-05-03 20:50:50.624	2025-05-03 20:50:50.624	\N
9dc4bfc1-4d37-40a6-b73d-9d5e4a697a76	Silvia	Morales Ramos		\N	\N	1962-01-28 00:00:00		2025-05-03 20:50:50.625	2025-05-03 20:50:50.625	\N
053c671d-7395-4a3c-ad88-dc5a4e46c760	Valeria Renata	Fernandez Vazquez		\N	3222033493	2013-01-18 00:00:00		2025-05-03 20:50:50.625	2025-05-03 20:50:50.625	\N
c41f2138-03c9-43a2-b531-6361c17ba306	Santiago Israel	Carrillo Vazquez		\N	\N	2010-05-20 00:00:00		2025-05-03 20:50:50.625	2025-05-03 20:50:50.625	\N
362fd965-f30e-4542-908e-f3baa01877ef	Line Marie	Lemieux		line_lemieux@hotmail.com	\N	1959-02-24 00:00:00		2025-05-03 20:50:50.626	2025-05-03 20:50:50.626	\N
66e113c7-e7e5-4955-802d-2d7280da59c1	Veronica	Dominguez Arista		\N	\N	1989-04-08 00:00:00		2025-05-03 20:50:50.626	2025-05-03 20:50:50.626	\N
3d0aeaaa-11ba-4262-b1b4-e8a437122eeb	Maribel	Peréz		pejmore@gmail.com	\N	1974-04-13 00:00:00		2025-05-03 20:50:50.626	2025-05-03 20:50:50.626	\N
16132427-9c8d-4dee-bfa1-eb6c54e90621	Rafael Antonio	Garcia Martinez		rafaelantonio09072003@gmail.com	\N	2003-07-09 00:00:00		2025-05-03 20:50:50.627	2025-05-03 20:50:50.627	\N
6215d446-49e2-416c-bd73-fd66f0787c8f	Julio	Bellanger		\N	\N	\N		2025-05-03 20:50:50.627	2025-05-03 20:50:50.627	\N
41a0620b-2ec7-4a8e-9506-63ddd4d1f0b1	Suzanne	Julian		\N	+13035056046	\N		2025-05-03 20:50:50.627	2025-05-03 20:50:50.627	\N
0404be00-fe29-41bf-8d9e-8730a0406d0f	Laurel	Taub		todoslaurel@yahoo.com	\N	1951-11-03 00:00:00		2025-05-03 20:50:50.627	2025-05-03 20:50:50.627	\N
fec401ac-f2e4-4d71-aac6-ddb854692996	Larry	Furlong		\N	\N	1939-12-07 00:00:00		2025-05-03 20:50:50.628	2025-05-03 20:50:50.628	\N
1cf30d29-51bf-4a17-9623-e7b830674200	Michellel	League		\N	\N	1981-02-04 00:00:00		2025-05-03 20:50:50.628	2025-05-03 20:50:50.628	\N
ada8acad-bf2c-4c8b-a8a9-4ba0512e8617	Richard	Fescet		\N	\N	\N		2025-05-03 20:50:50.628	2025-05-03 20:50:50.628	\N
b8130561-689f-49d2-b6a6-41a7e4771c9d	Salvador	Briones		\N	\N	\N		2025-05-03 20:50:50.629	2025-05-03 20:50:50.629	\N
5910723f-df9d-4ce4-9164-70d0cd87919a	Ruben Edgarin	Avilar Hernandez		rubenavilahernandez@hotmail.com	\N	1977-02-14 00:00:00		2025-05-03 20:50:50.629	2025-05-03 20:50:50.629	\N
adc304bb-b183-46d0-9db5-742be1297511	Luis  Antonio	Castillo Gomez		luis_152000@live.com	3222992029	1995-02-15 00:00:00		2025-05-03 20:50:50.629	2025-05-03 20:50:50.629	\N
02324110-beda-473e-98b2-77e766a35ac5	Ruben	Rojas Fernandez		\N	3222256742	1973-07-29 00:00:00		2025-05-03 20:50:50.63	2025-05-03 20:50:50.63	\N
cdd6e4e9-4742-4319-8059-06784f6b9b4b	Zury	Rodriguez		\N	\N	\N		2025-05-03 20:50:50.63	2025-05-03 20:50:50.63	\N
50d8eff0-81fd-4646-88f4-42725ed5a20d	Leticia	Aguiar Becerra		\N	\N	1999-04-11 00:00:00		2025-05-03 20:50:50.63	2025-05-03 20:50:50.63	\N
e334fdfa-3e45-49f1-81a4-9473cbb0fc1a	Simon	Desjardins		Simonbeaulne@hotmail.com	+15149707597	1971-03-05 00:00:00		2025-05-03 20:50:50.631	2025-05-03 20:50:50.631	\N
13529445-1bc4-499d-a293-ea0ac10c2f54	Sandy Jimena	Guardado dela Rosa		\N	\N	\N		2025-05-03 20:50:50.631	2025-05-03 20:50:50.631	\N
9d9ebd5b-5d14-480d-84ac-fb800f491a11	Maria	Campos Luna		\N	\N	\N		2025-05-03 20:50:50.631	2025-05-03 20:50:50.631	\N
7b16427c-6c44-4a4d-8a29-3a67cbada61b	Valerie	Beltran		valerie@Beltransinc.com	\N	1970-03-09 00:00:00		2025-05-03 20:50:50.631	2025-05-03 20:50:50.631	\N
6d899314-e601-4db8-a0ed-2a8fccbe0e54	Stefany	Lukiny		\N	\N	1984-10-12 00:00:00		2025-05-03 20:50:50.632	2025-05-03 20:50:50.632	\N
9dace432-8dcf-4b2f-919a-097e9a1a59cd	Sandra	Gomez		gogasami24@gmail.com	\N	1977-06-24 00:00:00		2025-05-03 20:50:50.632	2025-05-03 20:50:50.632	\N
18015ef4-ddff-49e4-b0db-3d2b6d0fed2b	Linda	Rodriguez Rodruigez		CRISELRGUEZ@GMAIL.COM	\N	1991-10-09 00:00:00		2025-05-03 20:50:50.632	2025-05-03 20:50:50.632	\N
a1ab9c28-0ee3-40d1-a127-ccc120f25b8d	Nina	Raynolds		\N	\N	\N		2025-05-03 20:50:50.633	2025-05-03 20:50:50.633	\N
56ddf6ea-6853-4452-9fa5-03221c65fb56	Noermi	Guerrero Uribe		\N	\N	\N		2025-05-03 20:50:50.633	2025-05-03 20:50:50.633	\N
c242bff9-a807-4ac0-8560-0cafb6e02367	Marina	Ramos Rubino		\N	\N	\N		2025-05-03 20:50:50.633	2025-05-03 20:50:50.633	\N
1b297af0-257c-4b89-858a-c2f82e55ae39	Pedro	Mendoza		\N	\N	\N		2025-05-03 20:50:50.634	2025-05-03 20:50:50.634	\N
11afc9e9-c5bb-4b6d-a612-cfeea0eb5576	Julieta	Lopez Garcia		julietalg24@gmail.com	\N	1987-10-24 00:00:00		2025-05-03 20:50:50.634	2025-05-03 20:50:50.634	\N
cc67e1b7-9182-45d0-b7a4-9fe079eb4369	Oscar	Garcia Martinez		\N	\N	\N		2025-05-03 20:50:50.634	2025-05-03 20:50:50.634	\N
b4d2d90b-58db-476d-95a0-fe23696bf2c5	Luis Alberto	Celis Nava		\N	\N	1995-01-16 00:00:00		2025-05-03 20:50:50.634	2025-05-03 20:50:50.634	\N
88b4ee15-8d77-44e2-b7e1-d91885acf7a1	Monica Yareli	Gradilla Gonzalez		moyaregg93@gmail.com	\N	1993-12-06 00:00:00		2025-05-03 20:50:50.635	2025-05-03 20:50:50.635	\N
392d8e20-ffc7-400f-84d9-cbfd3d088cb7	Maria del Carmen	Barba Hernandez		\N	3221143055	1991-06-09 00:00:00		2025-05-03 20:50:50.635	2025-05-03 20:50:50.635	\N
102f2f09-e910-470b-98f6-cb54f9ba48df	Yared	Cueva Lima		\N	\N	\N		2025-05-03 20:50:50.635	2025-05-03 20:50:50.635	\N
777107d8-3591-4242-b276-13d863a7175d	Mauricio	Arellano Cabrera		ujafet321@gmail.com	\N	1970-05-08 00:00:00		2025-05-03 20:50:50.636	2025-05-03 20:50:50.636	\N
41d00d97-f512-42e6-8aab-78ac5e8b0dd5	Valeria	Guerrero Osorio		\N	\N	\N		2025-05-03 20:50:50.636	2025-05-03 20:50:50.636	\N
26bec225-de02-49c0-be0b-d618ae7ddbec	Melany	Rivera Jimenez		\N	\N	2015-05-07 00:00:00		2025-05-03 20:50:50.637	2025-05-03 20:50:50.637	\N
24b82035-4bdf-4e1f-9963-b09c55563079	Tina	Berge		\N	\N	\N		2025-05-03 20:50:50.637	2025-05-03 20:50:50.637	\N
681aa422-d66d-4a7d-a6f0-75b0e75f8a54	Maria	Dimas Reyna		\N	\N	1986-04-13 00:00:00		2025-05-03 20:50:50.637	2025-05-03 20:50:50.637	\N
527c9a98-986a-4b55-9de3-508919422dce	Maria del Rosario	Juarez Hdéz.		\N	\N	1980-08-25 00:00:00		2025-05-03 20:50:50.638	2025-05-03 20:50:50.638	\N
6fa7b4a0-97b4-4d19-b623-16ebe972a262	Kenia Edith	Peña gadiila		\N	\N	\N		2025-05-03 20:50:50.638	2025-05-03 20:50:50.638	\N
5a8af955-8a63-4563-a5e7-5578a41e2770	Rosalba	Gradilla Bravo		\N	\N	1962-08-05 00:00:00		2025-05-03 20:50:50.638	2025-05-03 20:50:50.638	\N
e59cad1c-ff55-4c45-94c3-bd74ea67c45c	Teresa de Jesus	Jimenez Gómez		\N	3221523273	1981-04-17 00:00:00		2025-05-03 20:50:50.638	2025-05-03 20:50:50.638	\N
4be4dd16-3eb0-4fb9-9fee-be5f8eb45855	Maria Belen	Rodriguez Garcia		\N	\N	1961-01-28 00:00:00		2025-05-03 20:50:50.639	2025-05-03 20:50:50.639	\N
26093c74-de9b-4a67-881f-e68d78f6dd82	Victor Manuel	Parra Catillón		\N	\N	1953-07-23 00:00:00		2025-05-03 20:50:50.639	2025-05-03 20:50:50.639	\N
87fb4ab6-6aa6-41b9-8e12-4a0f87ee1f33	Maurilia	Villanueva Barroso		\N	\N	1960-01-15 00:00:00		2025-05-03 20:50:50.639	2025-05-03 20:50:50.639	\N
0d582e75-7402-4f2a-a1ec-bf932a87fc29	Rosendo	Jimenez Arredondo		\N	\N	1940-02-23 00:00:00		2025-05-03 20:50:50.64	2025-05-03 20:50:50.64	\N
c95d9c20-90e6-4d38-899a-92ffdaeecaa9	Ryan	Sidhoo		r.sidhoo@gmail.com	\N	1988-10-14 00:00:00		2025-05-03 20:50:50.64	2025-05-03 20:50:50.64	\N
5aedd427-4a38-4613-a88d-4d1ded50c065	Norma Alicia	Robles Barragan		\N	\N	\N		2025-05-03 20:50:50.64	2025-05-03 20:50:50.64	\N
f54f0ece-e110-4eb7-b710-808a2bc850bd	Rodolfo	Valenzuela		\N	3221851511	\N		2025-05-03 20:50:50.641	2025-05-03 20:50:50.641	\N
792585bc-2262-4639-9551-e4a9af5fdebf	Tyler	Austin		Tyleraustinsir@gmail.com	\N	1993-01-10 00:00:00		2025-05-03 20:50:50.641	2025-05-03 20:50:50.641	\N
4609b9fe-eb79-4266-b564-5209a248d93a	Marisol	Gonzales  Perez		\N	\N	1982-10-16 00:00:00		2025-05-03 20:50:50.641	2025-05-03 20:50:50.641	\N
2d72b4b2-0e7b-4971-b46b-900308c6b5c6	Mario	Larocque		larocquem1@hotmail.com	3222660019	1959-09-11 00:00:00		2025-05-03 20:50:50.642	2025-05-03 20:50:50.642	\N
43681a38-c0f3-4f4a-84b3-0ff2811df780	Rebeca	Escalante  Herrera		\N	3222921731	1933-12-18 00:00:00		2025-05-03 20:50:50.642	2025-05-03 20:50:50.642	\N
63ff894f-68af-43ef-b9fa-283bf99ef2dc	Julian Alexander	Hernandez Medina		\N	\N	\N		2025-05-03 20:50:50.642	2025-05-03 20:50:50.642	\N
308b4978-fcd6-401d-99bc-ba63695c9217	Luis Fernando	Ramirez Amezquita		\N	\N	\N		2025-05-03 20:50:50.642	2025-05-03 20:50:50.642	\N
e34bedc6-26a1-4792-9f60-d63f85e19e8c	MIguel	Alquiciras Jiménez		adikfamily@gmail.com	3221530760	1993-01-19 00:00:00		2025-05-03 20:50:50.643	2025-05-03 20:50:50.643	\N
26b4d2f3-3bc7-47d4-b28f-be650dd3c612	Patricia	Blanco Fernández		\N	3222903399	1962-04-27 00:00:00		2025-05-03 20:50:50.643	2025-05-03 20:50:50.643	\N
10c704bc-c327-4118-9cc2-de54657248c9	Lizbeth	Torres Soler		lizsoler1986@gmail.com	\N	1986-11-27 00:00:00		2025-05-03 20:50:50.643	2025-05-03 20:50:50.643	\N
070fffff-7069-44e1-a14b-c130519d1962	Paola	Marino Valente		\N	\N	2008-10-22 00:00:00		2025-05-03 20:50:50.644	2025-05-03 20:50:50.644	\N
c5852729-a7c2-4d6f-8ef7-016131cc9f63	Montserrat	Limón López		montselimon@aotloock.com	3221785667	1999-09-08 00:00:00		2025-05-03 20:50:50.644	2025-05-03 20:50:50.644	\N
ac738dcd-af52-456e-9154-60e7ee3a531b	Martha Rosario	Palacios Torres		palaciosmr88@gmail.com	3228895404	1988-01-12 00:00:00		2025-05-03 20:50:50.644	2025-05-03 20:50:50.644	\N
f620d6d5-4d83-411a-883b-95ccf5c0ae66	Perla	de la Rosa Rodríguez		perla_delarosa3@hotmail.com	\N	1992-04-03 00:00:00		2025-05-03 20:50:50.645	2025-05-03 20:50:50.645	\N
ede66b0d-f048-40eb-8a4d-c3e958c91862	Ya Ya	Huag		\N	\N	1960-03-08 00:00:00		2025-05-03 20:50:50.645	2025-05-03 20:50:50.645	\N
dd095aa2-3e26-4e06-a05d-26dcd0385e5b	Julio	Gonzalez		jcgroscoe@gmail.com	\N	1982-10-09 00:00:00		2025-05-03 20:50:50.645	2025-05-03 20:50:50.645	\N
0bef84d9-4d1c-41c8-9407-b12a7e3d60b2	Luz Elena	Miguez Sendiz		liz.miguez@hotmail.com	3221186587	1990-08-11 00:00:00		2025-05-03 20:50:50.646	2025-05-03 20:50:50.646	\N
c3584f63-7c59-4ee2-9c38-6db2db807b7d	Will	Chong		massiveattk95@gmail.com	\N	1995-09-11 00:00:00		2025-05-03 20:50:50.646	2025-05-03 20:50:50.646	\N
083867be-69e0-4550-bfac-dfaa3ee55b8e	Sheyla	Prosterman		\N	\N	1950-08-26 00:00:00		2025-05-03 20:50:50.646	2025-05-03 20:50:50.646	\N
0fe5982e-caf8-405a-841f-eab1664dbaa0	MaryMichell	Boileau		m_boileau@hotmail.com	\N	1984-06-29 00:00:00		2025-05-03 20:50:50.647	2025-05-03 20:50:50.647	\N
db3d7c78-38b6-4a8b-b7c0-ef452313b9cd	Oscar	Arce Dueñas		oaarce1@gamil.com	3227797104	1974-02-08 00:00:00		2025-05-03 20:50:50.647	2025-05-03 20:50:50.647	\N
355b434b-2e49-40bb-aeaa-a408dc96ec78	Maira	Castellanos Mesa		mairiscm@gmail.com	\N	1988-03-12 00:00:00		2025-05-03 20:50:50.647	2025-05-03 20:50:50.647	\N
ce51ed41-1411-4347-96ba-b6e4e86a6d69	Ya ya	Huang		\N	3222259595	1960-03-08 00:00:00		2025-05-03 20:50:50.647	2025-05-03 20:50:50.647	\N
ed1bee21-6517-4b1e-8421-54bf86d8f974	Marisol	Rodrigues Ramirez		\N	\N	\N		2025-05-03 20:50:50.648	2025-05-03 20:50:50.648	\N
41577291-5e66-42d3-b112-53a50b12743f	Paola Edith	Alvarez Cardenas		paolaalvarezcardenas@gmail.com	\N	1975-04-20 00:00:00		2025-05-03 20:50:50.648	2025-05-03 20:50:50.648	\N
09827d65-c2ae-4a5b-ba27-f39f0d9e9913	Lyne	Gagne		rodlyne@hotmail.com	\N	1951-05-07 00:00:00		2025-05-03 20:50:50.648	2025-05-03 20:50:50.648	\N
7af34e26-1e2a-46b7-b841-ed80f106b5f2	Wendy	Miler		wendymiller@gmail.com	\N	1969-07-08 00:00:00		2025-05-03 20:50:50.649	2025-05-03 20:50:50.649	\N
e79ba630-6f52-4547-8ccc-bc7cf1f566c7	Marjolaine	Beaulieu		\N	\N	\N		2025-05-03 20:50:50.649	2025-05-03 20:50:50.649	\N
823c4f8c-16cd-45ab-aa0d-adc0be62e720	Lucia Lizbeth	Parra Lomeli		\N	\N	1988-03-14 00:00:00		2025-05-03 20:50:50.649	2025-05-03 20:50:50.649	\N
cb1f88db-2eb6-4a50-adc9-a17d3bdfa4c9	Rejean	Brunet		\N	\N	1942-08-14 00:00:00		2025-05-03 20:50:50.65	2025-05-03 20:50:50.65	\N
53231691-25e5-4038-a4a4-33f70ce4c386	Shelly	Willson		\N	\N	\N		2025-05-03 20:50:50.65	2025-05-03 20:50:50.65	\N
69f740e9-bf19-482f-8372-1d906faadeed	Olga Maria	Vargas Rodríguez		\N	\N	1978-01-07 00:00:00		2025-05-03 20:50:50.65	2025-05-03 20:50:50.65	\N
46e310f4-fea9-4555-a853-c24803f3407a	Juan Pablo	Contreras Hernández		\N	3222252610	1987-09-14 00:00:00		2025-05-03 20:50:50.651	2025-05-03 20:50:50.651	\N
ca733638-1821-4ce3-8e0a-f1e704433031	maria	prueba		\N	\N	\N		2025-05-03 20:50:50.651	2025-05-03 20:50:50.651	\N
1c4e565f-c09a-4b66-b7b3-5a8235096e06	maria	prueba		\N	\N	\N		2025-05-03 20:50:50.651	2025-05-03 20:50:50.651	\N
d9caeaba-735d-4094-b6f3-4438e0eec194	maria	prueba prueba		\N	\N	\N		2025-05-03 20:50:50.652	2025-05-03 20:50:50.652	\N
91ea3037-5abf-4a91-bd32-cdf32727e604	maria	prueba prueba		\N	\N	\N		2025-05-03 20:50:50.652	2025-05-03 20:50:50.652	\N
a2884f0d-9101-4859-b653-602ccd666dad	Lourdes	Perez Alonzo		\N	\N	1962-07-22 00:00:00		2025-05-03 20:50:50.652	2025-05-03 20:50:50.652	\N
7bf61e4d-b733-4517-8eae-ddda5d9b209d	Shelley	Wilson		shelleywilson18@gmail.com	\N	1961-02-18 00:00:00		2025-05-03 20:50:50.653	2025-05-03 20:50:50.653	\N
0d6944d9-5e5c-47ae-9bd9-d39631c0701e	Maria Gabriela	Hernádez Koesling		gabiotadelmar@hotmail.com	\N	1987-09-10 00:00:00		2025-05-03 20:50:50.653	2025-05-03 20:50:50.653	\N
ec8d582a-6302-41e6-bf4a-62a3278ec395	Manon	Delisle		\N	\N	\N		2025-05-03 20:50:50.653	2025-05-03 20:50:50.653	\N
7742db24-2afd-4cb4-9430-3db64785ef82	Sebas	prueba		\N	\N	\N		2025-05-03 20:50:50.654	2025-05-03 20:50:50.654	\N
89b9602c-dfc4-4fcc-8986-98ddd173a41f	Yuridia	Ramirez		yuridia_007@hotmail.com	\N	1989-07-05 00:00:00		2025-05-03 20:50:50.654	2025-05-03 20:50:50.654	\N
f14f0cfe-16f1-4888-991f-6f4a48cd42fc	Kenia	Perez de la Cruz		\N	\N	1998-04-18 00:00:00		2025-05-03 20:50:50.654	2025-05-03 20:50:50.654	\N
c0f3b464-2e61-4a97-9819-734267d1b1e8	Pablo	Zalazaar Resendi		\N	\N	\N		2025-05-03 20:50:50.655	2025-05-03 20:50:50.655	\N
48e7cfb3-5144-4573-8b53-2d70b26b251a	Macario	Sermeño Miranda		macarioser@hotmail.com	\N	1964-06-16 00:00:00		2025-05-03 20:50:50.655	2025-05-03 20:50:50.655	\N
b090f1a5-8942-4e4b-8476-ae333d94fa3c	Yolanda	Mendoza Ordaz		yolandamendozaordaz@hotmail.com	\N	1966-07-31 00:00:00		2025-05-03 20:50:50.655	2025-05-03 20:50:50.655	\N
6da4b9d8-9998-46ab-a94d-3385804d2c04	Yanina Beatriz	Joseph Villegas		\N	\N	\N		2025-05-03 20:50:50.656	2025-05-03 20:50:50.656	\N
8f41f60b-00ce-4ae7-bda7-27159768ef16	Liliane	Champagne Breton		liliane139@gamil.com	\N	1954-06-22 00:00:00		2025-05-03 20:50:50.656	2025-05-03 20:50:50.656	\N
b0e0dacc-cbeb-4d09-b875-a67d87e62bb2	Nathalie	Beaudin		\N	\N	\N		2025-05-03 20:50:50.656	2025-05-03 20:50:50.656	\N
9eb5431a-321d-48aa-8c13-ff637cc7e1bc	Julia Lucero	Alvarado Torres		julyalvarado8462327@gmail.com	\N	1989-12-20 00:00:00		2025-05-03 20:50:50.656	2025-05-03 20:50:50.656	\N
93b88534-bbed-4d99-aecc-c6dc3bd95976	Vianey	Gudiño Gonzales		gvianey98@gmail.com	\N	1998-08-08 00:00:00		2025-05-03 20:50:50.657	2025-05-03 20:50:50.657	\N
b71ac530-c39d-4bbd-b690-2b92a0cc0ca1	Marie- Jose	Coussard		coussardmj@hotmail.com	\N	1958-06-19 00:00:00		2025-05-03 20:50:50.657	2025-05-03 20:50:50.657	\N
b70d6346-605e-4a93-b03c-73f41269d7ca	Patrick	Savard		49patricks@gmail.com	\N	1949-05-20 00:00:00		2025-05-03 20:50:50.657	2025-05-03 20:50:50.657	\N
3090bdc3-167a-43f3-94fb-0e802b64683e	Mitcheline	Vachon		mitchvac56@gmail.com	\N	1956-05-20 00:00:00		2025-05-03 20:50:50.658	2025-05-03 20:50:50.658	\N
0aea1cda-53e3-4675-af61-e78ffb344dc5	Omar	Santa María		omarsantamaría22@gmail.com	\N	2020-02-22 00:00:00		2025-05-03 20:50:50.658	2025-05-03 20:50:50.658	\N
c4e4d3b7-dcaf-4023-858b-c29667f40a0d	Lucía	Rodriguez Robledo		luciarr_69@hotmail.com	\N	1969-12-13 00:00:00		2025-05-03 20:50:50.658	2025-05-03 20:50:50.658	\N
4feee7e2-79a1-4aca-8aa2-00af4b3152f1	Rejean	Villleneuve		\N	\N	1949-09-19 00:00:00		2025-05-03 20:50:50.659	2025-05-03 20:50:50.659	\N
dce61e62-0180-4f75-81fc-730142e601db	Nicole	Roy		nroypaquette@gamil.com	\N	1956-02-20 00:00:00		2025-05-03 20:50:50.659	2025-05-03 20:50:50.659	\N
fbc716a0-fcfb-4400-b887-f33ee67c964b	Marie	Borris		captmprudh56@hotmail.com	\N	1951-01-07 00:00:00		2025-05-03 20:50:50.659	2025-05-03 20:50:50.659	\N
9f598439-86fa-4b79-ace1-98d8f92cfd63	Rejean	Villeneuve		\N	\N	1949-09-19 00:00:00		2025-05-03 20:50:50.66	2025-05-03 20:50:50.66	\N
41617425-b099-41d9-b4cd-ecd57abc68c1	Vanesa	Nuñez Corona		\N	\N	1993-03-02 00:00:00		2025-05-03 20:50:50.66	2025-05-03 20:50:50.66	\N
a47f75dc-9849-4d01-8de4-cd039d701ee2	Marcela Benerenica	Vera Ramiírez		marcela.verarmz@gmail.ocm	\N	1994-08-17 00:00:00		2025-05-03 20:50:50.66	2025-05-03 20:50:50.66	\N
d0934c95-da15-4366-9dd7-695150ecdbe3	Patricia	Medina Lopez		\N	\N	1980-06-22 00:00:00		2025-05-03 20:50:50.661	2025-05-03 20:50:50.661	\N
2f5380e8-de84-4998-90c0-dc15466c65ac	Marco Antonio	Caudillo Ramírez		\N	\N	1969-12-25 00:00:00		2025-05-03 20:50:50.661	2025-05-03 20:50:50.661	\N
dbeb031c-6858-464e-8113-e7633c106bfc	Lucas	Sinópoli		lucas.sinopoli@gmail.com	\N	1982-10-10 00:00:00		2025-05-03 20:50:50.661	2025-05-03 20:50:50.661	\N
ce7d3e36-8f4a-45bc-bac2-400c8e47a0ed	Patricia	Guerrero Brito		\N	\N	1969-03-17 00:00:00		2025-05-03 20:50:50.662	2025-05-03 20:50:50.662	\N
2b4d5a2c-85ad-4e51-b0d6-dd03712d8fda	Karina	Sanchez Bautista		\N	\N	\N		2025-05-03 20:50:50.662	2025-05-03 20:50:50.662	\N
b1a96c23-733a-49fa-b26f-5869ceaecc26	Laorie	Wistman		\N	3226886758	\N		2025-05-03 20:50:50.662	2025-05-03 20:50:50.662	\N
029845d6-4e74-4d9f-8063-9bd9a340ed6a	Raynald	Lavoie		raunaldlavoie@hotmail.com	\N	1948-07-09 00:00:00		2025-05-03 20:50:50.662	2025-05-03 20:50:50.662	\N
c3615258-be7c-4fa7-8303-b75377dcf182	Lidia	Sanchez Sanchez		\N	\N	1971-08-03 00:00:00		2025-05-03 20:50:50.663	2025-05-03 20:50:50.663	\N
dd469605-4af6-4c80-993a-eea2721d5bd4	Nora Ivonne	Sanchez Alemán		nors17@gmail.com	\N	1966-11-27 00:00:00		2025-05-03 20:50:50.663	2025-05-03 20:50:50.663	\N
709f0306-5146-4237-9c77-a0c6c6514192	Obdulia	Perez Zatarain		\N	3222252600	1948-03-09 00:00:00		2025-05-03 20:50:50.663	2025-05-03 20:50:50.663	\N
9489effd-f2a5-44a4-a568-2a627d6c4aa9	Philip Graham	Hosien		\N	\N	1945-02-28 00:00:00		2025-05-03 20:50:50.664	2025-05-03 20:50:50.664	\N
22716b9f-3a59-427c-b038-233fa7788c39	Mendoza Sandoval	Sarahi		mendozasarahi21@gmai.com	\N	1993-09-21 00:00:00		2025-05-03 20:50:50.664	2025-05-03 20:50:50.664	\N
1ac3bb00-834b-4609-b39d-6038b9a857a5	Ventura	Cabrera Loya		\N	\N	\N		2025-05-03 20:50:50.664	2025-05-03 20:50:50.664	\N
5387174b-eb3e-4a1c-8634-0feae674592c	Tania	Cienfuegos Peralta		taniacienfuegos@hotmail.com	\N	1978-04-24 00:00:00		2025-05-03 20:50:50.665	2025-05-03 20:50:50.665	\N
95b4a3f2-2b9a-4b77-97cb-4a7570162019	Marina	Bautista Zgaip		\N	3222975922	1939-09-02 00:00:00		2025-05-03 20:50:50.665	2025-05-03 20:50:50.665	\N
6a5ed14c-7332-44de-a7af-765c0ecca01e	Silvia Paula	Waldman		paulaswaldman@gmail.com	\N	1951-01-13 00:00:00		2025-05-03 20:50:50.665	2025-05-03 20:50:50.665	\N
5784c2ca-4f21-4252-87f0-80e705b6f2b0	Violeta	Pacheo Rojas		\N	\N	1989-01-04 00:00:00		2025-05-03 20:50:50.666	2025-05-03 20:50:50.666	\N
a56d55af-3d24-4b7f-be32-e87b3c951366	Victor Manuel	Perez Medina		\N	\N	1997-11-16 00:00:00		2025-05-03 20:50:50.666	2025-05-03 20:50:50.666	\N
cd83ec02-d08d-468e-b9ee-96300b921e7b	Peggy	Clarck		peggyclark1111@gmail.com	\N	1963-04-30 00:00:00		2025-05-03 20:50:50.666	2025-05-03 20:50:50.666	\N
0ad3dfbf-6046-4d34-a8ba-0f1e55af6e27	Marco	Murgia Sanchez		survivor1282@hotmail.com	\N	1982-12-12 00:00:00		2025-05-03 20:50:50.666	2025-05-03 20:50:50.666	\N
2f0262d5-b55d-44e8-baed-0d5d79b8b6b2	Natalia	Cabildo Rodriguez		nataliacabildo24@gmail.com	\N	2003-03-04 00:00:00		2025-05-03 20:50:50.667	2025-05-03 20:50:50.667	\N
f08b7600-9a1e-4412-886a-4aa06fc2ee81	Robert	Reed Bergman		\N	\N	1967-07-24 00:00:00		2025-05-03 20:50:50.667	2025-05-03 20:50:50.667	\N
3af09bb7-d648-487d-981e-6922e3e1befb	Maria Dolores	Ruelas Gutierrez		maryruelas001@gmail.com	\N	1979-02-08 00:00:00		2025-05-03 20:50:50.667	2025-05-03 20:50:50.667	\N
bda6164a-38b8-4e09-8ca1-7acf68b312de	Karina	Morales Glez		\N	\N	1994-05-20 00:00:00		2025-05-03 20:50:50.668	2025-05-03 20:50:50.668	\N
691799b8-49d0-4465-848c-c4a70b9d341f	Nancy	Maldonado Araque		\N	\N	\N		2025-05-03 20:50:50.668	2025-05-03 20:50:50.668	\N
919ffcb3-3c29-4a97-b06a-4d6accf69b62	Juan Salvador	Magaña Carranza		\N	\N	2012-11-15 00:00:00		2025-05-03 20:50:50.668	2025-05-03 20:50:50.668	\N
1e376f4a-f32c-4233-87fc-4cef99a4bf9b	Maria Reneé	Moral Muriel		\N	\N	1984-02-29 00:00:00		2025-05-03 20:50:50.668	2025-05-03 20:50:50.668	\N
67f8213d-8791-4307-8027-aaa01be7565b	Linda Nanci	Estrada Flores		\N	\N	1974-05-10 00:00:00		2025-05-03 20:50:50.669	2025-05-03 20:50:50.669	\N
afdc7b3b-4294-4322-8660-4aeddb095e5f	Monica Matilde	Cruz Perez		monycruz.bcp@gmail.com	\N	1975-04-14 00:00:00		2025-05-03 20:50:50.669	2025-05-03 20:50:50.669	\N
d2b485c9-b602-44ee-b3f3-afcd0bec3e92	Yessenia Gpe.	Recendis Padron		yeseniarespa@outlloock.com	\N	1991-02-28 00:00:00		2025-05-03 20:50:50.669	2025-05-03 20:50:50.669	\N
c5fd4873-4a18-42e9-ab7b-b9e450cd1d79	Kamila Victoria	Rodriguez Martinez		\N	\N	2008-06-14 00:00:00		2025-05-03 20:50:50.669	2025-05-03 20:50:50.669	\N
8990efc3-5c64-4bf3-b95f-3ba3ec05e09f	Maximo	Ortiz Providenza		\N	\N	2011-09-30 00:00:00		2025-05-03 20:50:50.67	2025-05-03 20:50:50.67	\N
7af124a4-2168-45da-be52-27914daca5ee	Livier	Nazarth		\N	3222253088	1960-07-30 00:00:00		2025-05-03 20:50:50.67	2025-05-03 20:50:50.67	\N
0878890a-99fe-4a45-b317-c7b8025114b6	Maria Dolores	Perez de Sermeño		\N	3222224978	1963-03-27 00:00:00		2025-05-03 20:50:50.67	2025-05-03 20:50:50.67	\N
94f4111d-c3e3-4aa5-b305-a0987836d4da	Yareli	Lopez Cardoso		\N	3223214105	2015-10-18 00:00:00		2025-05-03 20:50:50.671	2025-05-03 20:50:50.671	\N
851fa8e7-adde-4369-a197-edbc84bfabd2	Maximus Cudberto	Hernandez Santos		\N	\N	\N		2025-05-03 20:50:50.671	2025-05-03 20:50:50.671	\N
593ec34e-5b18-455f-808f-fd23221066a7	Martha Olivia	Hernández  Santos		\N	\N	\N		2025-05-03 20:50:50.672	2025-05-03 20:50:50.672	\N
b69892c2-61d0-4d75-83d2-6182ed7ed8be	Natanael	Blanco Chavarin		\N	\N	1998-10-29 00:00:00		2025-05-03 20:50:50.673	2025-05-03 20:50:50.673	\N
615164d0-3fc3-4aac-bbe7-91972901d2d0	Manuel	Bravo Roci		mbrtavo@gmail.com	\N	1957-03-11 00:00:00		2025-05-03 20:50:50.673	2025-05-03 20:50:50.673	\N
c8199baa-8af9-404c-9365-9c3540f55ed6	Karen Naivi	Heredia Lopez		\N	3222789574	1993-03-29 00:00:00		2025-05-03 20:50:50.673	2025-05-03 20:50:50.673	\N
957aa0e3-5f37-4c8e-bc3f-b7a4e7c1bfab	Samuel	Hernandez Canela		\N	\N	\N		2025-05-03 20:50:50.674	2025-05-03 20:50:50.674	\N
3cbe62e6-7367-4ef6-a589-dc052d044776	Miguel	Ramirez		\N	\N	\N		2025-05-03 20:50:50.674	2025-05-03 20:50:50.674	\N
98772c72-aab8-4780-9376-1725567f1b6c	Miguel Angel	Saavedra Martinez		\N	\N	\N		2025-05-03 20:50:50.674	2025-05-03 20:50:50.674	\N
449a967b-c254-4ca5-9562-1fc09b5c4dd2	Karenina	Escobedo Ibarra		kareninaescobedo@gmail.com	\N	1992-09-19 00:00:00		2025-05-03 20:50:50.674	2025-05-03 20:50:50.674	\N
4b751b54-8373-455e-a15e-74a6eec86d68	Miguel Angel	Savedra		\N	\N	\N		2025-05-03 20:50:50.675	2025-05-03 20:50:50.675	\N
607adccc-8902-4be6-91f7-31980e3a05e3	Yaretzi Paola	Gomez García		\N	3222970199	2004-05-18 00:00:00		2025-05-03 20:50:50.675	2025-05-03 20:50:50.675	\N
81f9cbc3-e48a-4046-a09c-c77b09998aa9	Wendy Guadalupe	Lopez Ramirez		wendyplastica@gmail.com	3222220376	1978-10-10 00:00:00		2025-05-03 20:50:50.675	2025-05-03 20:50:50.675	\N
d37b4220-a89d-4ff0-b2e8-e50a5973152e	Maria Gpe.	Cardoso Barranco		\N	\N	1989-04-03 00:00:00		2025-05-03 20:50:50.676	2025-05-03 20:50:50.676	\N
e02a92eb-504a-4fc8-b31b-2d63efdc22cf	Sophie	Cazeaux		\N	\N	\N		2025-05-03 20:50:50.676	2025-05-03 20:50:50.676	\N
7a83bfdf-11bf-46c2-afae-89fb485df1c1	Patrica	Cruz Perez		patycruz01@hotmail.com	3222936170	1970-11-24 00:00:00		2025-05-03 20:50:50.676	2025-05-03 20:50:50.676	\N
24f81a8b-2a06-4e32-9599-57e25b3f020c	Kreisa Sofia	Lopez Gonzales		\N	\N	2001-12-05 00:00:00		2025-05-03 20:50:50.677	2025-05-03 20:50:50.677	\N
22426d94-0fd2-4d59-8146-a458d7c22ebc	Luis Alejandro	Marquez Moreno		luis-9020@hotmail.com	\N	1990-10-02 00:00:00		2025-05-03 20:50:50.677	2025-05-03 20:50:50.677	\N
bd4968bd-e150-4302-a8bf-ecbbc3e0621f	Manuel Alejandro	Arreola Bernal		\N	\N	2004-04-05 00:00:00		2025-05-03 20:50:50.677	2025-05-03 20:50:50.677	\N
ec868803-a731-4539-8d11-44d90026586d	Juan Rogelio	Meza Guerrero		\N	3221971283	1995-11-16 00:00:00		2025-05-03 20:50:50.678	2025-05-03 20:50:50.678	\N
a43c09b8-d0d7-4396-ab7f-0af3785f7ae0	Richard	VanDenHuf		\N	\N	1972-01-16 00:00:00		2025-05-03 20:50:50.678	2025-05-03 20:50:50.678	\N
5209fc35-2217-4706-8f80-1d65c8a3b29c	Valeria	Ramirez De Leon y Peña		valdleon@gmail.com	\N	1994-03-13 00:00:00		2025-05-03 20:50:50.678	2025-05-03 20:50:50.678	\N
ecf7900b-3915-4d6c-8c8a-de8571351806	Karla Dareli	Hernadez Martínez		\N	\N	2013-03-13 00:00:00		2025-05-03 20:50:50.679	2025-05-03 20:50:50.679	\N
fcffb221-f849-40f1-b286-839c4978a804	Tiana	Oneill		oneill.tiana@gmail.com	\N	1987-04-12 00:00:00		2025-05-03 20:50:50.679	2025-05-03 20:50:50.679	\N
173c1feb-e4e7-488d-a724-bcf721272215	Martin	Lucas		\N	\N	\N		2025-05-03 20:50:50.68	2025-05-03 20:50:50.68	\N
7d3bf4dc-a534-4656-bb92-31c84265ca03	Zuri Darali	Benigno Hernandez		\N	\N	2013-12-27 00:00:00		2025-05-03 20:50:50.68	2025-05-03 20:50:50.68	\N
bb3494ee-2b9d-4f7b-927d-980fdc04387a	Maria Guadalupe	Cardozo Barranco		\N	3221495072	1989-04-03 00:00:00		2025-05-03 20:50:50.68	2025-05-03 20:50:50.68	\N
3d0dacca-46ec-49b9-86ae-90c476932c73	Marco	Perez Peñaloza		\N	\N	1965-03-19 00:00:00		2025-05-03 20:50:50.68	2025-05-03 20:50:50.68	\N
560d8add-dd3e-469e-a9d9-bf7e3f28c938	Juliana	Lopez Martínez		\N	\N	1990-07-28 00:00:00		2025-05-03 20:50:50.681	2025-05-03 20:50:50.681	\N
63749c9f-9fa6-4d16-b054-33f4d641ce53	Santiago	Valenzuela Leon		\N	3222401080	\N		2025-05-03 20:50:50.681	2025-05-03 20:50:50.681	\N
b5fec422-9921-4cdb-8e68-49e4807b386c	Lidia Maria	Eguiarte		lmel60@hotmail.com	3221130522	1967-04-06 00:00:00		2025-05-03 20:50:50.681	2025-05-03 20:50:50.681	\N
69cb27dd-0f1d-4021-a1af-9463e19fd96d	Ma. Obdulia	Llano Sanchez		\N	3221088632	1958-01-02 00:00:00		2025-05-03 20:50:50.682	2025-05-03 20:50:50.682	\N
b5a42f19-e1f7-4ea5-b37c-390ec249d516	Oscar Gabriel	Santos Hernández		\N	\N	2007-06-22 00:00:00		2025-05-03 20:50:50.682	2025-05-03 20:50:50.682	\N
e639fe31-72eb-4586-a2d5-438fad219420	Rebeca	Lopez Gallardo		\N	\N	2005-08-25 00:00:00		2025-05-03 20:50:50.682	2025-05-03 20:50:50.682	\N
69f0ee73-ce4c-4d56-a69f-7a3ebc427892	Nazareth Galilea	Villanueva González		\N	3222254391	\N		2025-05-03 20:50:50.683	2025-05-03 20:50:50.683	\N
79aa521a-7819-48b6-ba76-7a3d4ddc17eb	Victoria	Álvarez Flores		\N	\N	1974-06-17 00:00:00		2025-05-03 20:50:50.683	2025-05-03 20:50:50.683	\N
1aafa0af-b4f2-4c8d-a753-fa173c28fc4f	pedro caca	xaxa		\N	\N	\N		2025-05-03 20:50:50.684	2025-05-03 20:50:50.684	\N
ae35ad48-264f-4c13-8939-3037173391b5	Mercedes	Calvo		\N	\N	1980-10-18 00:00:00		2025-05-03 20:50:50.684	2025-05-03 20:50:50.684	\N
f88d88f8-371f-4f36-b0b0-190d0a5385d7	Karla	Centeno Nolazco		karlaolivia190603@gmail.com	3222250347	2003-06-19 00:00:00		2025-05-03 20:50:50.684	2025-05-03 20:50:50.684	\N
832de281-8fdc-4544-b2ed-ca8c4b45d1e2	Michael	Kuljis		kuljis.m@gmail.com	\N	1969-04-17 00:00:00		2025-05-03 20:50:50.685	2025-05-03 20:50:50.685	\N
8143d9d7-d2ba-4f33-9d4f-65cc23b5cb4f	Kimberly	Casterline		\N	+17168607839	\N		2025-05-03 20:50:50.685	2025-05-03 20:50:50.685	\N
bf349dee-105c-4844-b552-b7d3855737ba	Rodrigo	Mendoza Castillo		\N	\N	1974-03-05 00:00:00		2025-05-03 20:50:50.685	2025-05-03 20:50:50.685	\N
cd736f4b-b823-48ea-9c09-489250d8339a	Trinidad	Lara Pelayo		\N	3221332549	1987-06-14 00:00:00		2025-05-03 20:50:50.686	2025-05-03 20:50:50.686	\N
480624d5-d51d-4312-b125-d491d0a1d2cf	Mike	Pashley		\N	\N	\N		2025-05-03 20:50:50.686	2025-05-03 20:50:50.686	\N
b97fc00b-e617-498a-8bd9-57346758e90d	Rosario	Amaui de Flores		\N	3223651060	1958-07-31 00:00:00		2025-05-03 20:50:50.686	2025-05-03 20:50:50.686	\N
144304a3-ef70-4e71-84f1-e5175ec354e1	Violeta	Torres Andrade		\N	\N	1961-02-02 00:00:00		2025-05-03 20:50:50.687	2025-05-03 20:50:50.687	\N
f1b3ac74-40af-48b4-baf9-675c4a675d98	Rocio	Alvarez Hernandes		\N	\N	1987-09-22 00:00:00		2025-05-03 20:50:50.687	2025-05-03 20:50:50.687	\N
af262dbe-4081-4c67-a73a-0e8d73a9ab7e	Kreisa Elizeth	Gonzalez Gonzalez		kreygg@gmail.com	3222903649	1976-01-07 00:00:00		2025-05-03 20:50:50.687	2025-05-03 20:50:50.687	\N
76d544c0-89e7-4dd5-b899-95291e7cbd0a	Laura Lilian	Juarez Sanchez		\N	\N	1997-09-01 00:00:00		2025-05-03 20:50:50.688	2025-05-03 20:50:50.688	\N
f817be0c-e998-4880-92a3-c7799e6a34ea	Paula	Jimenez Hernández		\N	3222230538	1965-06-29 00:00:00		2025-05-03 20:50:50.688	2025-05-03 20:50:50.688	\N
d88287b6-e1ac-4325-b75e-eb54fbc73f30	Rafael Agustin	Medina Flores		rafael.medina.flores@hotmail.com	\N	1963-11-09 00:00:00		2025-05-03 20:50:50.688	2025-05-03 20:50:50.688	\N
ec3fa5f5-fc01-4a4e-8439-c461ade8332e	Maria Aime	Osejo Frias		\N	\N	1974-04-25 00:00:00		2025-05-03 20:50:50.689	2025-05-03 20:50:50.689	\N
3cad5870-ec0b-4744-bc72-87e7c8ec9cd4	Roberto	Castellanos Omaña		roberto@novamas.net	3221368752	1962-10-04 00:00:00		2025-05-03 20:50:50.689	2025-05-03 20:50:50.689	\N
06cf42cc-171e-4bc1-af35-30a1e509365f	Tina	Kofmach		tina.k@seebetterlab.com	\N	1974-03-22 00:00:00		2025-05-03 20:50:50.689	2025-05-03 20:50:50.689	\N
2c25dbdd-ad8c-426f-b711-86a41c565701	Robert	Kosmach		Rkosmach@gmail.com	\N	1965-01-12 00:00:00		2025-05-03 20:50:50.69	2025-05-03 20:50:50.69	\N
e14d9dda-d466-46ab-8843-64ab2b70df4d	Nancy	Perez Macedo		nancyqfb@hotmail.com	3222227873	1968-07-20 00:00:00		2025-05-03 20:50:50.69	2025-05-03 20:50:50.69	\N
795bbae9-7483-47ad-8ece-9c7e3b218cfc	Moana	x		\N	\N	\N		2025-05-03 20:50:50.69	2025-05-03 20:50:50.69	\N
a8281440-82d2-4cd1-8f47-c19636e7b5c6	Ofelia	de Romo		\N	\N	1944-01-17 00:00:00		2025-05-03 20:50:50.691	2025-05-03 20:50:50.691	\N
0a78d538-fc7c-4ee0-ba78-0c06aec5b43e	Samuel	Soltero Romero		solterosamuel0@gmail.com	\N	1977-09-16 00:00:00		2025-05-03 20:50:50.691	2025-05-03 20:50:50.691	\N
3c6b820c-8328-4b78-adf8-02c714c677dd	Yesica	Abreu Ramírez		yesicaabreuramirez@gmail.com	\N	1996-08-28 00:00:00		2025-05-03 20:50:50.691	2025-05-03 20:50:50.691	\N
a58bdc89-85c8-4107-86aa-d05e137a1565	Rosa Maria	Vera Sobreyra		\N	\N	1956-07-14 00:00:00		2025-05-03 20:50:50.692	2025-05-03 20:50:50.692	\N
dce640c4-569e-4451-9ebb-d14cb254f153	Stephane	Neloni		\N	\N	\N		2025-05-03 20:50:50.692	2025-05-03 20:50:50.692	\N
53e8cfe1-0b18-40b1-8bf8-71fad7dd2d99	Nathalia	Alvarez Rivera		jservinp40@gmail.com	\N	2016-02-18 00:00:00		2025-05-03 20:50:50.692	2025-05-03 20:50:50.692	\N
6476e9ec-905b-492b-aae3-e1b33d905a51	Oswualdo	Pérez		\N	\N	\N		2025-05-03 20:50:50.693	2025-05-03 20:50:50.693	\N
afe31ab3-0789-42b7-b353-68f5a175ffcf	Laura	Marquez López		marquezlaura0205@gmail.com	\N	1988-05-02 00:00:00		2025-05-03 20:50:50.693	2025-05-03 20:50:50.693	\N
403417b9-c4f9-4169-a0e5-fca47c0a6321	Maria de Jesús	Luna Gonzalez		maria24luna@gmail.com	\N	1991-12-24 00:00:00		2025-05-03 20:50:50.693	2025-05-03 20:50:50.693	\N
2fafa548-079c-4e4b-9b0c-1756c6d39c7d	Silvia	Vazquez Orozco		\N	\N	1957-01-03 00:00:00		2025-05-03 20:50:50.694	2025-05-03 20:50:50.694	\N
d76fd025-e06f-4fcd-8730-1cf2bc61e73e	Noe Abiud	Díaz Melchor		\N	3222051856	\N		2025-05-03 20:50:50.694	2025-05-03 20:50:50.694	\N
91268bd1-c0f6-4ba9-b370-2d968d7e5434	Moises	Carrillo		\N	\N	1960-04-22 00:00:00		2025-05-03 20:50:50.694	2025-05-03 20:50:50.694	\N
a0aea02b-f838-412c-9154-3472f5e85821	Yahel	Perez Montero		\N	\N	\N		2025-05-03 20:50:50.695	2025-05-03 20:50:50.695	\N
8a77a176-80a2-41d2-a963-77da5104c410	Maria de Jesus	Paniagua Casillas		mary.josmar.@gmail.com	\N	1961-10-23 00:00:00		2025-05-03 20:50:50.695	2025-05-03 20:50:50.695	\N
0e0ca8a1-b0e1-4825-a211-a7966c3950b9	Maricela	Gonzalez Rodriguez		\N	\N	1955-09-10 00:00:00		2025-05-03 20:50:50.695	2025-05-03 20:50:50.695	\N
fa19b010-9cc9-4e6b-a3ca-a325c6d99d6e	Lorenzo	Rovtcleia		\N	\N	1981-07-12 00:00:00		2025-05-03 20:50:50.696	2025-05-03 20:50:50.696	\N
09368674-df79-4b83-97e2-a7f72f32b8da	Miguel Angel	Ramirez Hervert		\N	\N	1994-03-08 00:00:00		2025-05-03 20:50:50.696	2025-05-03 20:50:50.696	\N
e0e4bc2d-a633-4e1d-931f-540c1d34d7dc	Lugalzagessi	Minjarez Velazco		lugalzagessi@outloock.es	3292983015	2001-10-28 00:00:00		2025-05-03 20:50:50.696	2025-05-03 20:50:50.696	\N
580458c0-f411-47f8-9c1f-1bff69278842	Prisciliano	Rodriguez Gutierrez		\N	\N	1954-03-23 00:00:00		2025-05-03 20:50:50.697	2025-05-03 20:50:50.697	\N
e53f5939-3639-473f-9d66-6121df684919	Karen Samara Bethzabe	Barba López		\N	\N	1988-02-23 00:00:00		2025-05-03 20:50:50.697	2025-05-03 20:50:50.697	\N
bc5afbf1-dceb-4b3a-8122-8784b815cdad	Luis	Sandoval Hernandez		\N	\N	1987-05-17 00:00:00		2025-05-03 20:50:50.697	2025-05-03 20:50:50.697	\N
3e794923-3eff-4000-8a97-ab146072c7e6	Olga Leticia	Estrada Jaymes		olej1848@hotmail.com	\N	1954-02-09 00:00:00		2025-05-03 20:50:50.698	2025-05-03 20:50:50.698	\N
743b223f-2f27-40f0-8a30-47dc3876e26a	Omar	Ramos Díaz		\N	\N	1984-07-28 00:00:00		2025-05-03 20:50:50.698	2025-05-03 20:50:50.698	\N
053bd557-7f3c-4e76-b0c1-5f3e6d4f6819	Julieta	Castellón Aguilar		\N	\N	1987-03-10 00:00:00		2025-05-03 20:50:50.699	2025-05-03 20:50:50.699	\N
d23511a7-d418-4e25-9893-29a0c1b09f12	Noemí	Aguilar Gonzalez		\N	\N	1960-09-09 00:00:00		2025-05-03 20:50:50.699	2025-05-03 20:50:50.699	\N
ba57423e-6aab-489c-8cb1-fbf86087cb4f	Marcos	Guzman Pascual		\N	\N	1980-04-25 00:00:00		2025-05-03 20:50:50.699	2025-05-03 20:50:50.699	\N
a927b6a2-0142-4bb9-85af-f2535ad3aaab	Lidia Ruth	Carrillo Hidalgo		\N	3312660917	1962-10-11 00:00:00		2025-05-03 20:50:50.7	2025-05-03 20:50:50.7	\N
c0091a8f-75cd-4f97-aa39-19cf2197bd1a	Rosa Elvia	Sánchez Quiñonez		\N	\N	1970-08-23 00:00:00		2025-05-03 20:50:50.7	2025-05-03 20:50:50.7	\N
6095a501-e821-4120-8ad2-2f9e0ad1ef6c	Peter	Bouman		peterbouman@gmail.com	\N	1961-04-03 00:00:00		2025-05-03 20:50:50.7	2025-05-03 20:50:50.7	\N
7bf9b7c5-1f23-4796-9cb2-d89b839344ca	Veronica	Barrios González		\N	\N	1995-09-12 00:00:00		2025-05-03 20:50:50.701	2025-05-03 20:50:50.701	\N
ed210da8-e327-45f0-9469-857c2d345335	Lucia	Gomez Martinez		\N	3221933691	1956-06-20 00:00:00		2025-05-03 20:50:50.701	2025-05-03 20:50:50.701	\N
7d361ed8-6d40-4efe-9fec-614b3b692b43	Sofia	Reed Maldonado		\N	\N	2000-01-18 00:00:00		2025-05-03 20:50:50.701	2025-05-03 20:50:50.701	\N
eccbc699-c29e-4ffc-9d14-879c5ef94eed	Soraya	Achhab		achhabachhabsoraya@gmail.com	\N	1998-10-13 00:00:00		2025-05-03 20:50:50.701	2025-05-03 20:50:50.701	\N
a0308147-3942-4157-9671-021d13e945ae	Yunuem Estefania	Garrido Velazco		\N	3222598652	2009-11-28 00:00:00		2025-05-03 20:50:50.702	2025-05-03 20:50:50.702	\N
4d78379a-d0dd-4911-9947-ad005704fc41	Víctor Hugo	Ochoa Benitez		\N	\N	1972-09-09 00:00:00		2025-05-03 20:50:50.702	2025-05-03 20:50:50.702	\N
448296ff-9057-4d2f-a787-faf08085630a	Maria Eugenia	Guzmán Ruelas		mariaeugeniaguzman1@hotmail.com	\N	1956-05-02 00:00:00		2025-05-03 20:50:50.702	2025-05-03 20:50:50.702	\N
cc2b1819-fd25-4f94-8027-05a78b792ea9	Roman	Servin Rubio		\N	3222240901	1947-08-24 00:00:00		2025-05-03 20:50:50.703	2025-05-03 20:50:50.703	\N
76f345b1-384e-4edc-b3f4-6d29d8c9eef4	Mario Jonas	Romero Avitia		alguienbonito1987@gmail.com	\N	1987-11-17 00:00:00		2025-05-03 20:50:50.703	2025-05-03 20:50:50.703	\N
0b18c2a2-bcd0-46f7-928c-7c9cb89a54a0	Maria Fernanda	Robles Ortega		\N	\N	\N		2025-05-03 20:50:50.703	2025-05-03 20:50:50.703	\N
22fdef6e-68d9-4aff-bed1-d661b35766c8	Maria Fernanda	Robles Ortega		\N	6471199554	1997-05-04 00:00:00		2025-05-03 20:50:50.704	2025-05-03 20:50:50.704	\N
aeae69a3-ac1f-4e32-8daf-8e45bb594e42	Rafael	Castellanos Soto		\N	\N	1958-02-09 00:00:00		2025-05-03 20:50:50.704	2025-05-03 20:50:50.704	\N
c566cc66-a924-424d-b6a2-4c64aed72c43	Raquel Alicia	Machuca Zepeda		\N	\N	1966-11-04 00:00:00		2025-05-03 20:50:50.704	2025-05-03 20:50:50.704	\N
a26eb889-f49e-43ff-9ed2-6caf61a09f85	Victor	Gonzalez Salcedo		\N	3221046940	1966-06-12 00:00:00		2025-05-03 20:50:50.705	2025-05-03 20:50:50.705	\N
31652bd8-a2f3-4674-ba99-aa91fc456efb	Karen Michele	Gonzales Machuca		karengonzalezmm@gmail.com	\N	1996-09-24 00:00:00		2025-05-03 20:50:50.705	2025-05-03 20:50:50.705	\N
8884092d-57a0-45fb-b56e-66d9713f0ace	Magnolia Sandibel	Diaz Hernandez		magnoliadh13@icloud.com	\N	1993-11-13 00:00:00		2025-05-03 20:50:50.705	2025-05-03 20:50:50.705	\N
21e1aa00-b831-4f34-b594-e9efd802ea82	Saul	Morales Castro		\N	\N	1992-08-21 00:00:00		2025-05-03 20:50:50.706	2025-05-03 20:50:50.706	\N
7e2b09fe-d912-445b-b075-4d9ab60f671d	Sergio Sahid	Reyes Ortiz		\N	\N	2006-03-16 00:00:00		2025-05-03 20:50:50.706	2025-05-03 20:50:50.706	\N
b52218a5-e396-4ae6-8d0a-091b377189d5	Renata	Garcia Arreola		\N	\N	\N		2025-05-03 20:50:50.706	2025-05-03 20:50:50.706	\N
58530ae3-e625-47d4-ba4f-f2b63389ba60	Luis	Rodriguez Saez		mexicaneando03luiszaes@gmail.com	\N	1961-01-17 00:00:00		2025-05-03 20:50:50.707	2025-05-03 20:50:50.707	\N
41dbedaa-ff78-452b-9266-172e43c931b0	Maria Cita	Madero Garcia		\N	3222230291	\N		2025-05-03 20:50:50.707	2025-05-03 20:50:50.707	\N
2b8b0c7a-fe01-4fff-b1b6-e94b5692d5fc	Rosa	Renteria Fonseca		\N	\N	1953-08-30 00:00:00		2025-05-03 20:50:50.707	2025-05-03 20:50:50.707	\N
c0bcfc83-0ad3-4958-9c80-fcbf2c4e5c04	Martha Himelda	Vrstán Espino		\N	3222246835	1995-01-06 00:00:00		2025-05-03 20:50:50.708	2025-05-03 20:50:50.708	\N
ac08cdea-fb0f-47cb-8c03-549664658835	Oscar	Perez Moreno		\N	\N	1958-11-20 00:00:00		2025-05-03 20:50:50.708	2025-05-03 20:50:50.708	\N
42cb3ece-e888-429d-8b02-6cf4f83105b5	Keilani Ariatne	Martinez Amaya		vaamaya18@gmail.com	\N	2014-11-18 00:00:00		2025-05-03 20:50:50.708	2025-05-03 20:50:50.708	\N
3a37e4f2-ce4c-479c-a448-823ffd1cf14f	Ramiro	Mesa Arce		\N	\N	1956-03-11 00:00:00		2025-05-03 20:50:50.709	2025-05-03 20:50:50.709	\N
dbb16b16-0d91-4e44-9b5d-54a64f8e639c	Rodolfo	Moreno Gonzalez		\N	\N	1971-11-07 00:00:00		2025-05-03 20:50:50.709	2025-05-03 20:50:50.709	\N
921824ca-c398-4044-90ce-6074db31daf8	Oscar Manuel	Carmona saenz		oscarcaronasaenz@hotmail.com	\N	1964-07-03 00:00:00		2025-05-03 20:50:50.709	2025-05-03 20:50:50.709	\N
2c147eda-c0de-475a-941c-13765ff9d376	Norma	Solis Espoinoza		\N	\N	\N		2025-05-03 20:50:50.71	2025-05-03 20:50:50.71	\N
58a2238c-b4b1-40bb-aa49-968a8583a78f	Octavio	Maass Saad		\N	\N	1972-03-13 00:00:00		2025-05-03 20:50:50.71	2025-05-03 20:50:50.71	\N
dedb4216-0790-4762-be95-be7a07098e7f	Marnay	Ruiz Quezada		flakitamarnay@gmail.com	\N	1994-09-29 00:00:00		2025-05-03 20:50:50.71	2025-05-03 20:50:50.71	\N
cac186fa-847b-488a-855f-888c4ef3a10a	Juli	Rivera Valdes		yaluj_85@hotmail.com	\N	1985-04-26 00:00:00		2025-05-03 20:50:50.711	2025-05-03 20:50:50.711	\N
a3e6dc9f-09fa-442d-b0f0-7cb7e8dacfba	Paola	Herrera López		paoma2224@gmail.com	3221367710	1996-02-22 00:00:00		2025-05-03 20:50:50.711	2025-05-03 20:50:50.711	\N
67e90935-2df1-4040-9178-4660e91dc7f3	Veronica	Portillo Flores		\N	\N	\N		2025-05-03 20:50:50.711	2025-05-03 20:50:50.711	\N
ae34e11f-bfb9-4b99-8a61-97da2fc77d61	Lidia Isabel	Guillen Gonzalez		\N	\N	1957-06-11 00:00:00		2025-05-03 20:50:50.712	2025-05-03 20:50:50.712	\N
0b0bc7a6-b8ac-445d-b9ae-9b59a69917e0	Suzanne	Julian		\N	\N	1962-07-20 00:00:00		2025-05-03 20:50:50.712	2025-05-03 20:50:50.712	\N
e6f3916c-0826-4ff1-a198-0b447326d3c4	Shaula Adahara	Hernandez Jimenez		shaulaa98@gmail.com	8332462573	1998-10-27 00:00:00		2025-05-03 20:50:50.712	2025-05-03 20:50:50.712	\N
93c90ee3-fbe8-43dd-878d-2f7b144ff867	Line	Dumont		\N	\N	\N		2025-05-03 20:50:50.713	2025-05-03 20:50:50.713	\N
ebfe23f2-b303-4437-a756-7a51dcb115e0	Kyle	Thurnburn		kylethornburn@hotmail.com	\N	1979-12-21 00:00:00		2025-05-03 20:50:50.713	2025-05-03 20:50:50.713	\N
e2af3a6f-0e46-4643-90df-470ddf4adedf	Monica	Acca		accamonica@yahoo.it	\N	\N		2025-05-03 20:50:50.713	2025-05-03 20:50:50.713	\N
4ea81be4-8e7f-4296-b140-88d6458e5790	kevin	badalia		\N	\N	\N		2025-05-03 20:50:50.714	2025-05-03 20:50:50.714	\N
173b96f6-2cb5-4e13-862c-8f0431ec0e59	Solanch	xx		\N	\N	\N		2025-05-03 20:50:50.714	2025-05-03 20:50:50.714	\N
91bedbe4-311c-4a9c-ae10-805f6a4c8ff6	Sury Roberta	Cuevas Velazcquez		\N	\N	2018-02-18 00:00:00		2025-05-03 20:50:50.714	2025-05-03 20:50:50.714	\N
b0a9ece3-158b-4f5b-92ad-ffdeccfd9ae5	Kevin	Bandalian		\N	\N	\N		2025-05-03 20:50:50.715	2025-05-03 20:50:50.715	\N
98a6337c-6824-48b4-8eff-1d1b0468d9d7	Teresa de Jesus	Romero Ramírez		\N	3222985164	1958-10-15 00:00:00		2025-05-03 20:50:50.715	2025-05-03 20:50:50.715	\N
e8a64b38-4e32-4f5f-b055-0e035a79c112	Miguel Anguel	Alvarado Barragan		angel.alvarado.barragan12@hotmail.com	\N	1999-01-10 00:00:00		2025-05-03 20:50:50.715	2025-05-03 20:50:50.715	\N
83ed6b81-77b1-45c2-96bd-b12a65934ed2	Sergio	Gomez Urrutia		urrutia_81@hotmail.com	\N	1981-04-12 00:00:00		2025-05-03 20:50:50.716	2025-05-03 20:50:50.716	\N
68dbc54a-a92e-4a55-bc53-ecd02c198147	TAYELL	KIM		\N	\N	\N		2025-05-03 20:50:50.716	2025-05-03 20:50:50.716	\N
a227cd4d-328c-4609-9f5a-7139b1ccbe5e	Karol Romina	Valle Hernández		\N	\N	2005-06-21 00:00:00		2025-05-03 20:50:50.716	2025-05-03 20:50:50.716	\N
a63f51ef-77e5-483c-bdf7-397923470397	Kristof Ramses	Valle Hernandez		\N	\N	2010-04-13 00:00:00		2025-05-03 20:50:50.716	2025-05-03 20:50:50.716	\N
69a57fdf-3a8b-4899-ad3d-1b477db3259a	Walther	Grego		waltergego@gmai.com	\N	1951-07-16 00:00:00		2025-05-03 20:50:50.717	2025-05-03 20:50:50.717	\N
5e2a3467-07b2-40bf-8d12-81b69dcc6fed	Blanca	Morales	Gomez	1@gmail.com	+523221356485	1973-07-28 00:00:00		2025-05-06 00:19:44.64	2025-05-06 00:19:44.64	\N
3c84bbcb-ea47-46eb-a5b7-17ca5765148d	Maria del Rosario	Rodriguez Gonzalez		charytina_123@hotmail.com	3221344437	1979-11-21 00:00:00		2025-05-03 20:50:50.717	2025-05-03 20:50:50.717	\N
75926416-bcc5-464e-83a4-569f1e419350	MARIBEL	PLACA		\N	3223652481	\N		2025-05-03 20:50:50.717	2025-05-03 20:50:50.717	\N
3aa0e3a7-0241-4296-8f0a-94173b82fdfe	Lizaa	Grego		\N	\N	1961-03-18 00:00:00		2025-05-03 20:50:50.718	2025-05-03 20:50:50.718	\N
f6566d48-1cb9-4340-9fb4-386ce9273162	Mickel	Campesino		\N	\N	\N		2025-05-03 20:50:50.718	2025-05-03 20:50:50.718	\N
e14367c7-d644-48c4-8a39-96ccdfa9f187	Rene	Ayála López		rene.meka30@gmail.com	3223682860	1984-08-30 00:00:00		2025-05-03 20:50:50.718	2025-05-03 20:50:50.718	\N
0eb3ee7a-7ab8-46f9-82a3-c09c6fcd3e6a	Laura Neftali	Noyola Montoya		\N	\N	1978-09-01 00:00:00		2025-05-03 20:50:50.719	2025-05-03 20:50:50.719	\N
b4c63af7-3b6b-4318-8861-03138c620a35	Teresa	Aguilar Jimenez		\N	3221746393	1961-02-21 00:00:00		2025-05-03 20:50:50.719	2025-05-03 20:50:50.719	\N
82ab82c5-1994-4c52-84ab-14ec4c411bc7	Tara	Siwak		siwak75@hotmail.com	\N	1975-06-12 00:00:00		2025-05-03 20:50:50.719	2025-05-03 20:50:50.719	\N
31e1bc1d-53fc-416c-bdd0-15544aff30af	Samanta Liliana	Beltran Rivera		sbeltranrivera@gmail.com	3221141543	1997-11-13 00:00:00		2025-05-03 20:50:50.72	2025-05-03 20:50:50.72	\N
39f29b21-c5f3-4141-b66e-e8aadb2d635f	Martha Imeda	Tristán Espino		tiem1955@yahoo.cpm.mx	3222246835	1955-01-06 00:00:00		2025-05-03 20:50:50.72	2025-05-03 20:50:50.72	\N
574dac46-cbe1-4569-b1bc-b46437612092	SIlvia	Savala Mendez		\N	\N	\N		2025-05-03 20:50:50.72	2025-05-03 20:50:50.72	\N
128bb218-9558-4245-a449-a514f924b517	Mahnu	Villaseñor Zavala		\N	3221883643	\N		2025-05-03 20:50:50.721	2025-05-03 20:50:50.721	\N
2a81738c-aca8-4cbe-b492-d0c07ced4fec	Lorenza	Perez Castro		lolopeca05@hotmail.com	\N	1957-11-05 00:00:00		2025-05-03 20:50:50.721	2025-05-03 20:50:50.721	\N
58b03c9d-61d2-438f-bfb5-586c9b7027af	Tania Gpe.	Aleque Avalos		taniagpealegeavalos@gmail.com	3221935542	1993-09-10 00:00:00		2025-05-03 20:50:50.721	2025-05-03 20:50:50.721	\N
e5f72c90-12de-48bb-9aa1-99efbb38af3e	Maria Mildred	Beaz Flores		mildredfz.6712@gmai.com	3222940711	\N		2025-05-03 20:50:50.722	2025-05-03 20:50:50.722	\N
d875a8dd-a7f1-45b8-8395-cb8d9469a598	Yaya	Huang		\N	3223191210	\N		2025-05-03 20:50:50.722	2025-05-03 20:50:50.722	\N
05ccc99f-d0b1-4677-8e58-31020947829f	Ramón Antonio	Medina Flores		ramonmedina105@gmail.com	3221472159	1950-08-18 00:00:00		2025-05-03 20:50:50.722	2025-05-03 20:50:50.722	\N
c10c950d-8413-4cfe-92f0-7592cb1a7766	Koldo	Valdes Joos		koldovaldes@gmail.com	\N	2003-10-09 00:00:00		2025-05-03 20:50:50.722	2025-05-03 20:50:50.722	\N
780a6ea2-c1ab-4b1d-b56b-692efceefc57	Rogelio	Zepeda Gonzalez		\N	\N	1971-06-25 00:00:00		2025-05-03 20:50:50.723	2025-05-03 20:50:50.723	\N
acaa3ca7-42e3-4f88-832e-293c518f4db0	Maria de la Luz	Arellano Benitez		mariadelaluzarellanobenitez@gmai.com	\N	1963-02-22 00:00:00		2025-05-03 20:50:50.723	2025-05-03 20:50:50.723	\N
363adcb7-ae18-43e7-802d-92dd7a50f77b	Simon	Taylor		\N	3221648011	\N		2025-05-03 20:50:50.723	2025-05-03 20:50:50.723	\N
f17c3112-3914-4487-9fa1-4dd94946df9c	Karen Iliana	Arce Zepeda		\N	3221754366	\N		2025-05-03 20:50:50.724	2025-05-03 20:50:50.724	\N
721eb9f0-3d71-4848-b2b4-296a1653381f	Sebastian	Prueba		\N	\N	\N		2025-05-03 20:50:50.724	2025-05-03 20:50:50.724	\N
4c64a6ab-62ea-47e6-a2e3-cf3bf28a54f3	Maria del Carmen	Corna Rivera		\N	3222949547	\N		2025-05-03 20:50:50.724	2025-05-03 20:50:50.724	\N
43e671b8-c544-47f6-b746-77cccdf29977	Petya	Stoyanova		\N	3221200947	\N		2025-05-03 20:50:50.725	2025-05-03 20:50:50.725	\N
c25b6ccf-7e06-4c9f-83cd-7ccfcb7da7d8	Ma. Patrocinio	Berúmen Coréa		\N	3222011781	\N		2025-05-03 20:50:50.725	2025-05-03 20:50:50.725	\N
544d2fff-3b59-4cef-838f-56959955bbb5	Ramon Antonio	Medina Flores		\N	3221472159	\N		2025-05-03 20:50:50.725	2025-05-03 20:50:50.725	\N
9004299c-f49c-429f-9b83-7cac588c10fb	Oscar Eduardo	Flores Ulloa		oscar.floresulloa@hotmail.com	3222167119	\N		2025-05-03 20:50:50.725	2025-05-03 20:50:50.725	\N
b0e51ed7-7178-4eb7-b829-1fd9d3f46f51	María Lorena	Gutierrez Fabian		\N	3312660917	\N		2025-05-03 20:50:50.726	2025-05-03 20:50:50.726	\N
9e841d02-b071-4d89-b407-c27702c0a5c1	Kyrios Emmanuel	Yañez Ramos		\N	3222371607	\N		2025-05-03 20:50:50.726	2025-05-03 20:50:50.726	\N
27ea1c20-a566-4920-b0a8-16b945473678	Lia Isamar	Yañez Ramos		\N	3222371602	\N		2025-05-03 20:50:50.726	2025-05-03 20:50:50.726	\N
c084ee1c-dacd-4abe-a032-1721f8587554	Luis Alejandro	Hernández Michel		\N	6623370582	\N		2025-05-03 20:50:50.726	2025-05-03 20:50:50.726	\N
b9e46c90-a7e2-49d7-bb62-63dbf04c9852	Valeria  Renata	Fernandez Váquez		\N	3222033493	\N		2025-05-03 20:50:50.727	2025-05-03 20:50:50.727	\N
8ca9bf99-95a8-45e5-8b28-cc845c690f1b	Lauren	Evans		\N	+19019496415	\N		2025-05-03 20:50:50.727	2025-05-03 20:50:50.727	\N
ddfe54b3-72d5-4937-a012-cde82eabe751	Michele	Vargas Pesqueira		\N	3221470259	\N		2025-05-03 20:50:50.727	2025-05-03 20:50:50.727	\N
90f980db-e015-4ded-bc8b-bd366da7321a	Salvador	Vilaseños Garcia		\N	3222014703	\N		2025-05-03 20:50:50.727	2025-05-03 20:50:50.727	\N
b993b5c1-68af-409d-b912-6ecf8106952b	marieve	rioux		\N	3221306122	\N		2025-05-03 20:50:50.728	2025-05-03 20:50:50.728	\N
0ca1a292-1974-4045-8978-8c504e1ec997	mila	portillo		\N	+15147950225	\N		2025-05-03 20:50:50.728	2025-05-03 20:50:50.728	\N
257bca77-a606-4420-b904-bd0a56936c8e	Michelle	Vargas Pesqueira		\N	3221470259	\N		2025-05-03 20:50:50.728	2025-05-03 20:50:50.728	\N
e2a6909b-7bca-491a-b112-f806795f1bb8	Marco Antonio	Rodriguez Camargo		\N	3221914781	1969-10-26 00:00:00		2025-05-03 20:50:50.729	2025-05-03 20:50:50.729	\N
c8c316c9-4551-43ba-9fe3-dafd02b2894c	Lia Isamar	Yañez Ramos		\N	3221534357	\N		2025-05-03 20:50:50.729	2025-05-03 20:50:50.729	\N
011bb0bd-8004-4735-8aa8-491aaf7e82c7	Marco Antonio	Rodríguez  Camargo		\N	3221914781	\N		2025-05-03 20:50:50.729	2025-05-03 20:50:50.729	\N
b4bb8a0c-1964-495c-8143-c652529fffe7	Luis Alberto	Cuevas García		\N	0014042769498	\N		2025-05-03 20:50:50.73	2025-05-03 20:50:50.73	\N
b616b2d6-1c7e-4ef1-a257-b9d2ef62e0c6	Sara	Goodwin		\N	523311030969	\N		2025-05-03 20:50:50.73	2025-05-03 20:50:50.73	\N
759c5631-3882-4cfc-8c70-180b4abdb4cf	Maria Guadalupe	Cruz Franco		\N	3221600803	\N		2025-05-03 20:50:50.73	2025-05-03 20:50:50.73	\N
140ff672-4399-4096-8568-eaa559e4683f	Octavio	Vargas Galvan		\N	3223444632	\N		2025-05-03 20:50:50.731	2025-05-03 20:50:50.731	\N
6b248feb-5d90-4ad6-af61-14b4780dda6b	Maria Fernanda	Salcedo Bautista		anavrcd@hotmail.com	3221824830	\N		2025-05-03 20:50:50.731	2025-05-03 20:50:50.731	\N
306167ce-7c14-41ee-91dd-7b477a7bff35	paolina	Sermeño Perez		\N	3221069585	\N		2025-05-03 20:50:50.731	2025-05-03 20:50:50.731	\N
b8f4e20b-b372-42fe-8377-547af920b5ed	Sarah	Goodwill		alof1@yahoo.com	+523311030969	\N		2025-05-03 20:50:50.732	2025-05-03 20:50:50.732	\N
6b19d3e4-b960-467a-af0f-9d5233b0a895	Renata Camila	García Flores		\N	3111320097	\N		2025-05-03 20:50:50.732	2025-05-03 20:50:50.732	\N
85fbd47e-cc0e-43ce-81d0-5896313bf7f3	nallely	cruz joya		nalle2180@hotmail.com	+523221092771	\N		2025-05-03 20:50:50.732	2025-05-03 20:50:50.732	\N
fcbae0c7-4c8d-4a73-8137-cedfe5de1296	Vida Paola	villaceja aceves		\N	3222208667	\N		2025-05-03 20:50:50.732	2025-05-03 20:50:50.732	\N
128ce11c-7d83-4d6a-ad32-acbfdc9960a8	Mariana Lisandra	Zopfy Miranda		chocomaskamari88@gmail.com	+523316295959	\N		2025-05-03 20:50:50.733	2025-05-03 20:50:50.733	\N
65b450c0-5e27-4cfd-a427-eb2140f69dbe	Marty	Brady		\N	0019047429583	\N		2025-05-03 20:50:50.733	2025-05-03 20:50:50.733	\N
e7abf2f2-68f4-4520-9b65-7ca306abcddd	Norma Angelica	Corral Loya		\N	6142307844	\N		2025-05-03 20:50:50.733	2025-05-03 20:50:50.733	\N
b68895aa-a8a7-4965-9d30-6b8f94f01215	Maria Isabel	Vital Angeles		\N	7711435910	\N		2025-05-03 20:50:50.734	2025-05-03 20:50:50.734	\N
76dac12b-bb3b-499b-ad43-a0b2e2ea6d51	Socorro	Salcedo Curiel		\N	3221112247	\N		2025-05-03 20:50:50.734	2025-05-03 20:50:50.734	\N
72072f07-5d1f-41ba-bd80-9733f24d88f3	Monserrat	Castrejon Chavez		\N	5563389801	\N		2025-05-03 20:50:50.734	2025-05-03 20:50:50.734	\N
616e90ed-562f-4d28-853b-68aed8c8efe7	Rita Esthela	Navarrete Sandoval		\N	3223565148	\N		2025-05-03 20:50:50.735	2025-05-03 20:50:50.735	\N
e1827d43-5bf7-4295-a452-296288568be2	Selena	Ruelas Dueña		\N	3221006435	\N		2025-05-03 20:50:50.735	2025-05-03 20:50:50.735	\N
4ecc4b94-556a-4c2a-b220-13f742d9ac0a	Monica	Palomera		monicapalomera1995@gmail.com	+523227792634	\N		2025-05-03 20:50:50.735	2025-05-03 20:50:50.735	\N
f8e2501b-53e5-42de-8b3f-c46ad350acd3	leví Ericel	Galegos García		\N	3221979400	\N		2025-05-03 20:50:50.736	2025-05-03 20:50:50.736	\N
5c78e67a-49b0-4abe-b8af-cc538dee46fe	Marionny	Cortes		q8cg8t47mk@privaterelay.appleid.com	+523222054378	\N		2025-05-03 20:50:50.736	2025-05-03 20:50:50.736	\N
48485edf-f103-470b-9706-c54575dc8fc2	Monica Alejandra	Palomera Pelayo		\N	3227792634	\N		2025-05-03 20:50:50.736	2025-05-03 20:50:50.736	\N
9194902b-610a-41dd-ae68-fc219e42b95d	Rosy	Echevarria		rosyechevarria@hotmail.com	+523221490597	\N		2025-05-03 20:50:50.737	2025-05-03 20:50:50.737	\N
0dfc360c-81e5-4ca5-b5c2-e9b4b8bc3201	Yarit	Rodriguez		rdyarit@gmail.com	+13239264998	\N		2025-05-03 20:50:50.737	2025-05-03 20:50:50.737	\N
9bcd6d93-a24a-4585-9076-083a5aa88667	Marcy	Brady		\N	3222052582	\N		2025-05-03 20:50:50.737	2025-05-03 20:50:50.737	\N
27426923-8dd2-40bd-a093-c2a2a45d7049	Ricardo	Flores Ruano		\N	3221579657	\N		2025-05-03 20:50:50.737	2025-05-03 20:50:50.737	\N
31532526-cd63-4e49-93b2-a444c5f17242	Marion	fonville		\N	+18025561904	\N		2025-05-03 20:50:50.738	2025-05-03 20:50:50.738	\N
32ee26d1-e5dd-4450-8f31-37a93ee3ac6c	Norma Alicia	Mercado López		\N	3221374995	\N		2025-05-03 20:50:50.738	2025-05-03 20:50:50.738	\N
e880f02b-36ce-4db7-81cd-9388578af701	Luis Rodrigo	Aguilar Salmerón		luroaguilar@hotmail.com	+523223510061	\N		2025-05-03 20:50:50.738	2025-05-03 20:50:50.738	\N
e1798fdd-811b-430e-a805-8b2cbd44ea79	Lucia	Zepeda Zavalza		\N	6121501556	\N		2025-05-03 20:50:50.739	2025-05-03 20:50:50.739	\N
ff05a5ca-9023-4707-ab7e-6ac35dd7ec77	Maria Lorena	Gutierrez Fabian		\N	3312660917	\N		2025-05-03 20:50:50.739	2025-05-03 20:50:50.739	\N
36251ee8-bee7-4f81-bf1b-807ace2e7916	Saúl	Alvarado Vázquez		avsaul@hotmail.com	+523221205139	\N		2025-05-03 20:50:50.739	2025-05-03 20:50:50.739	\N
80f30300-ae77-4eaf-89b3-db12aaf88a7e	Wanda	Jackson		\N	\N	\N		2025-05-03 20:50:50.74	2025-05-03 20:50:50.74	\N
51218f0f-c62b-4035-a124-5d633016f66f	Santiago	Lopez del Valle		\N	5527079744	\N		2025-05-03 20:50:50.74	2025-05-03 20:50:50.74	\N
36607ad7-a4fc-4b26-925e-b74b74640793	Wanda	Jacson		\N	\N	\N		2025-05-03 20:50:50.74	2025-05-03 20:50:50.74	\N
064b34af-5187-4e9f-949f-6b55a2f225fd	Liceth	Palacios Cevallos		\N	3221351642	\N		2025-05-03 20:50:50.741	2025-05-03 20:50:50.741	\N
bcf720e8-3f7c-44fc-ba78-207c24596d8a	Yolanda Esther	Luna Islas		\N	3221507756	\N		2025-05-03 20:50:50.741	2025-05-03 20:50:50.741	\N
ba23aa4e-062b-4d38-a032-0c6ea5786c87	Stefan	Aigner		\N	+523224005952	\N		2025-05-03 20:50:50.741	2025-05-03 20:50:50.741	\N
4bb706a0-f968-4008-9b9b-04c5b6eaaf76	Oscar	Campos Rivera		\N	3333535974	\N		2025-05-03 20:50:50.742	2025-05-03 20:50:50.742	\N
09404edf-7b6d-41de-88ae-63709aee02df	Stefan	Aisner		\N	\N	\N		2025-05-03 20:50:50.742	2025-05-03 20:50:50.742	\N
7f92d939-46a0-400e-9aa2-6b6a2af112af	Ken	Russel		\N	3223488983	\N		2025-05-03 20:50:50.742	2025-05-03 20:50:50.742	\N
f002edfe-b147-4d8b-8eb8-0fbc325e1067	Marc	Murphy		\N	3221355176	\N		2025-05-03 20:50:50.743	2025-05-03 20:50:50.743	\N
c5f825f9-9434-42bc-a6ce-e6131da88f56	Regina	Basurto Romero		\N	3222741332	\N		2025-05-03 20:50:50.743	2025-05-03 20:50:50.743	\N
4363b318-a2e8-41b7-ad41-e47f1300e45c	Omar	Morales		\N	3338201512	\N		2025-05-03 20:50:50.743	2025-05-03 20:50:50.743	\N
3039eade-3394-4400-b3b5-3ec833a3259f	Karina	Andrade Zuñiga		karina.andrade98@outlook.com	+527732333618	1998-07-08 00:00:00		2025-05-03 20:50:50.744	2025-05-03 20:50:50.744	\N
5c8f9185-1eff-4062-8b63-3776d2972e56	Rubén	Nuñez cham		cham.ruben@gmail.com	3222784041	\N		2025-05-03 20:50:50.744	2025-05-03 20:50:50.744	\N
0226fc1c-1c0b-4780-9295-ef8e655a8131	Will	Chong		\N	3223191210	\N		2025-05-03 20:50:50.744	2025-05-03 20:50:50.744	\N
4a97d0e7-8989-4590-bb28-2f6ca8690833	Sarahi	Martinez Soloro		\N	3222401937	\N		2025-05-03 20:50:50.744	2025-05-03 20:50:50.744	\N
e1dcafeb-2c78-49e1-ac41-55c34fd7f771	Susana herminia	Perez  González		susan_hermi@hotmail.com	3221204462	\N		2025-05-03 20:50:50.745	2025-05-03 20:50:50.745	\N
cba9e113-afec-40c5-9279-5a4f4e14897c	Nora Emilia	Aleman Alvarez		\N	5527552135	\N		2025-05-03 20:50:50.745	2025-05-03 20:50:50.745	\N
2fa53e6b-7c41-496c-9168-25cdb5aa37d4	Miguel	Centeno Otiveros		\N	3221821090	\N		2025-05-03 20:50:50.745	2025-05-03 20:50:50.745	\N
0b87b58a-bd77-4f14-8b7f-bd45e6895e1d	Miriam Lizbeth	Muñoz Velazquez		\N	2226564741	\N		2025-05-03 20:50:50.746	2025-05-03 20:50:50.746	\N
5f515c79-9ab0-424f-95af-b1fb568886c6	Roberto Valentín	Lopez Navarro		jorovalona@gmail.com	+525511511453	\N		2025-05-03 20:50:50.746	2025-05-03 20:50:50.746	\N
b73ea2b7-d5a4-4a57-b256-6089bbcceb63	Rosalva	Silva Avalos		\N	4381076354	\N		2025-05-03 20:50:50.746	2025-05-03 20:50:50.746	\N
a694dd68-967a-451a-93c8-4ff35564f315	Michelle	Goulet		\N	3223700996	\N		2025-05-03 20:50:50.747	2025-05-03 20:50:50.747	\N
55dd349f-3f26-47b5-9a5a-a8a9bce14cff	Karen Naivy	Heredia López		\N	3222789574	\N		2025-05-03 20:50:50.747	2025-05-03 20:50:50.747	\N
7474aca2-dd39-496d-945a-cd126ea4d2c4	Mary Jean	Granon		\N	3222019044	\N		2025-05-03 20:50:50.747	2025-05-03 20:50:50.747	\N
680c7e64-175a-4e7e-a994-cd29da5aedb3	Pedro Damian	Gazca GarcíA		\N	3228890811	\N		2025-05-03 20:50:50.748	2025-05-03 20:50:50.748	\N
7d492228-0e3c-4671-bb9e-a38861896716	Ricardo Efrain	Campos Leyva		\N	3221747523	\N		2025-05-03 20:50:50.748	2025-05-03 20:50:50.748	\N
44dcd829-ac06-4e8e-83ca-e77c0f71daa0	Ricardo Efrain	Campos Leiva		audioservicios@yahoo.com.mx	3221747523	\N		2025-05-03 20:50:50.748	2025-05-03 20:50:50.748	\N
322471e5-2133-4c20-a75a-99d95c997e64	Roxana	Flores		\N	3111320097	\N		2025-05-03 20:50:50.749	2025-05-03 20:50:50.749	\N
fcf39083-52b8-489b-b2a8-ccc3eca2bb9e	Laura	Nuñez Parra		\N	3221505781	\N		2025-05-03 20:50:50.749	2025-05-03 20:50:50.749	\N
c0ca349e-26b4-4ce9-90ea-7fe50fc31736	Vincent	Grenon		\N	3222019044	\N		2025-05-03 20:50:50.749	2025-05-03 20:50:50.749	\N
a683f6fb-ab8a-4088-87a0-cd6599bf72de	Stefany Juseph	Espinoza Delgado		fanydelgado2611@gmail.com	+523222636136	\N		2025-05-03 20:50:50.749	2025-05-03 20:50:50.749	\N
34efbd36-de5f-4f52-83e7-7fcecc3fb051	Kevin	Castillo		Castilloluissi48@gmail.com	+523221601927	\N		2025-05-03 20:50:50.75	2025-05-03 20:50:50.75	\N
5c858f41-8668-488f-968b-1b7760432436	Yolanda	Trejo Diaz		\N	3221115634	\N		2025-05-03 20:50:50.75	2025-05-03 20:50:50.75	\N
e11cb0fd-a09a-418d-beca-639559149e42	Matthew	Kolb		\N	+15172301552	\N		2025-05-03 20:50:50.75	2025-05-03 20:50:50.75	\N
e58c153d-2d32-4629-8750-a80c4597a5bd	Laura Elena	Nuñez Parra		\N	3221505781	\N		2025-05-03 20:50:50.751	2025-05-03 20:50:50.751	\N
8bb53001-f220-4e48-b6e5-7cfeb8e9a692	Maggie	Wall		\N	+12038073772	\N		2025-05-03 20:50:50.751	2025-05-03 20:50:50.751	\N
f8163f25-c49f-4bc0-b54c-21023e3a5210	Yunuen	Rios Ortega		\N	+15129984968	\N		2025-05-03 20:50:50.751	2025-05-03 20:50:50.751	\N
cbcbefd3-d6ec-415d-85ba-1729c00ff324	Julian	kristian		\N	3224295782	\N		2025-05-03 20:50:50.752	2025-05-03 20:50:50.752	\N
b8f05236-79f9-4443-a8d7-694101a8b995	Rosa Elba	Yañez		\N	3330603555	\N		2025-05-03 20:50:50.752	2025-05-03 20:50:50.752	\N
011a591b-63b8-4208-afaa-9a6a8077ad5e	Satya	Herrera muñiz		celesteschroeder@hotmail.com	+15702348691	\N		2025-05-03 20:50:50.752	2025-05-03 20:50:50.752	\N
efbd276e-c0c6-41e2-8f10-fe344963fb17	Zaira	Tapia		bkfvnvjpvt@privaterelay.appleid.com	+525534467628	\N		2025-05-03 20:50:50.753	2025-05-03 20:50:50.753	\N
4e911eb1-aa69-4d3b-911a-f028d0cfeee6	Manuel Alejandro	Ayala Bernal		\N	3221384199	\N		2025-05-03 20:50:50.753	2025-05-03 20:50:50.753	\N
82215423-bcbc-4762-950b-82769e6a1b7b	Rene	Sandoval		sandoval819@gmail.com	+12082509065	\N		2025-05-03 20:50:50.753	2025-05-03 20:50:50.753	\N
84e1a65f-7e00-4928-8cc0-16f3ec5bb5e1	Joseph	Pillion		\N	3223039300	\N		2025-05-03 20:50:50.754	2025-05-03 20:50:50.754	\N
f8092322-83aa-4851-8936-d15106a57287	Magnolia	Sanchez Jara		\N	3311519046	\N		2025-05-03 20:50:50.754	2025-05-03 20:50:50.754	\N
6889601c-6a2e-4577-9f54-0a4c3e3354aa	VEronica	Palomera Guzman		\N	3222629845	\N		2025-05-03 20:50:50.754	2025-05-03 20:50:50.754	\N
9548aeb7-0d08-4250-9d55-f88bf9e3aa2b	Oscar	Regla Castillon		\N	3221727299	\N		2025-05-03 20:50:50.754	2025-05-03 20:50:50.754	\N
f5d9b406-c9d2-4a94-9b96-0ce913a1793d	Ruby	Medina Ramírez		\N	4461048823	\N		2025-05-03 20:50:50.755	2025-05-03 20:50:50.755	\N
33dc4f24-c3d3-4d0f-88c3-254011a2b78f	Julian	Alatriste Flores		\N	5521287794	\N		2025-05-03 20:50:50.755	2025-05-03 20:50:50.755	\N
be09dae9-6517-4aa9-9b58-2240a19a4a69	Matthew	Cassell		\N	+447756578557	\N		2025-05-03 20:50:50.756	2025-05-03 20:50:50.756	\N
50961250-6471-456e-a448-ff6c0d2f4355	Marco  Antonio	Diaz Ruiz		\N	3222781884	\N		2025-05-03 20:50:50.756	2025-05-03 20:50:50.756	\N
bd06d874-f174-4c6e-816f-6bc1f434c943	Timm	Tomburn		\N	6122742066	\N		2025-05-03 20:50:50.756	2025-05-03 20:50:50.756	\N
1e67189d-56aa-4a3d-bf2c-ddcf973a827f	Mauricio	Torres Lopez		\N	5578431479	\N		2025-05-03 20:50:50.757	2025-05-03 20:50:50.757	\N
ff082075-5ddc-4a87-bcc9-26a84831a029	Tania	Rico Velazquez		\N	3224291031	\N		2025-05-03 20:50:50.757	2025-05-03 20:50:50.757	\N
5b9f563e-bdee-4ab9-bfce-a6e2dd63c457	Rolando	Castelo Mora		\N	3222941938	\N		2025-05-03 20:50:50.757	2025-05-03 20:50:50.757	\N
74b485bf-01bb-4772-bbaa-e652bcdd62db	Maria Jose	Maldonado Peña		\N	3221396919	\N		2025-05-03 20:50:50.758	2025-05-03 20:50:50.758	\N
420f456e-4d79-4c34-a37d-308f81c4b8fa	Victor	Villareal Gutierres		\N	3318347069	\N		2025-05-03 20:50:50.758	2025-05-03 20:50:50.758	\N
1d7e9c41-4aa8-490f-8db7-3cd261aaede9	Oscar Ivan	Carmona Bojorques		\N	3222165156	\N		2025-05-03 20:50:50.758	2025-05-03 20:50:50.758	\N
e4d7223e-de33-433c-9157-8d09e0fcdd34	Juana	Romero Colmenares		\N	3222013024	\N		2025-05-03 20:50:50.758	2025-05-03 20:50:50.758	\N
65ce41a5-4a6c-4eaf-8d2c-2bc9165a14ad	Mark	Sanchez		AlphaWolf@poquitoloco.com	+523223781718	\N		2025-05-03 20:50:50.759	2025-05-03 20:50:50.759	\N
bc5606ec-7d07-4d7e-b1bb-b5c637067e7d	Susana	Romero Ramírez		\N	3222741897	\N		2025-05-03 20:50:50.759	2025-05-03 20:50:50.759	\N
3168ec4c-2966-419e-b671-000b01aeaee4	Liliana	Sandoval		\N	+12096489809	\N		2025-05-03 20:50:50.759	2025-05-03 20:50:50.759	\N
d224c0e1-65e3-49b6-8674-be99d8ebf0cf	Mariana	Macedo		\N	5569619441	\N		2025-05-03 20:50:50.76	2025-05-03 20:50:50.76	\N
c4d17d19-ce3d-4037-a103-69a663bd7b29	Line	Letendre		\N	9841839749	\N		2025-05-03 20:50:50.76	2025-05-03 20:50:50.76	\N
02e8398a-5921-45b6-9ec2-7140e74ac023	Stheben JOseph	Curiel Flores		\N	3221685021	\N		2025-05-03 20:50:50.76	2025-05-03 20:50:50.76	\N
875d383d-ba6d-4dda-8815-7413bae49273	Lucille	Dowssonn		\N	+16135819232	\N		2025-05-03 20:50:50.761	2025-05-03 20:50:50.761	\N
49ff496d-630e-46cc-8a50-95a1d30f2171	Wayne	Austin		\N	+14046602821	\N		2025-05-03 20:50:50.761	2025-05-03 20:50:50.761	\N
653a4703-ea5f-4e0b-821d-ce064e4b38f1	Monica Maria	Vera Lagos		\N	9841664504	\N		2025-05-03 20:50:50.761	2025-05-03 20:50:50.761	\N
c78dcc58-2b1e-4386-9e6f-46b1d414a5db	Nestor Fernando	callejas		\N	+19524513215	\N		2025-05-03 20:50:50.761	2025-05-03 20:50:50.761	\N
6e100888-0b29-4bbf-b994-41211e39d745	Noemi	Cueva Rubio		cuevarubionoemi@gmail.com	+523222746735	\N		2025-05-03 20:50:50.762	2025-05-03 20:50:50.762	\N
8a25f40d-368c-4366-bb5f-af178864e791	michelin	Basant		\N	3222383623	\N		2025-05-03 20:50:50.762	2025-05-03 20:50:50.762	\N
333e75a0-db3b-4cce-bb9d-e65b06a9c1d5	Monica	Cruz Pérez		monycruz.bcp@gmail.com	+523221090879	\N		2025-05-03 20:50:50.762	2025-05-03 20:50:50.762	\N
a51e0ee1-2ca1-4b80-b6cc-403ff69de399	Suzanne	Dupont		suzanne.dupont@gmail.com	+15142413014	\N		2025-05-03 20:50:50.763	2025-05-03 20:50:50.763	\N
38c68474-d617-493b-b4a9-98ac3d9e7e50	Luis Horacio	Diaz Cataldo		\N	+15142415911	\N		2025-05-03 20:50:50.763	2025-05-03 20:50:50.763	\N
2d152021-8240-4e44-a030-676b048e4754	Ron	Vandeberg		\N	3222306668	\N		2025-05-03 20:50:50.763	2025-05-03 20:50:50.763	\N
4ba40c7f-f9cb-40f3-826e-7468828bd436	Luis	Jimenez		paulina.anguiano2001@gmail.com	+522292074554	\N		2025-05-03 20:50:50.764	2025-05-03 20:50:50.764	\N
5e2f5227-c93b-40fe-88d3-b846a4604f6b	Miriam	Ruíz Saldivar		\N	3221906671	\N		2025-05-03 20:50:50.764	2025-05-03 20:50:50.764	\N
a400c18a-7d0d-406e-85af-0a7852eeb320	Maria Jose	Zavala Rubio		\N	3221883643	\N		2025-05-03 20:50:50.764	2025-05-03 20:50:50.764	\N
243665d3-bc0e-4524-9dad-cc519357a8bf	Mariana	Torres Saenz		\N	3222168592	\N		2025-05-03 20:50:50.765	2025-05-03 20:50:50.765	\N
4180957c-45dd-4f24-b5e4-6badd74729de	Luis	Diaz		luisdiazmtl@yahoo.com	+15142415911	\N		2025-05-03 20:50:50.765	2025-05-03 20:50:50.765	\N
d980e492-6f08-4a62-b6fe-c73b5a78f575	Vanessa	Higuera Torijano		\N	5522719755	\N		2025-05-03 20:50:50.765	2025-05-03 20:50:50.765	\N
ea8ad6fd-4626-4dc3-a147-5b6e9c5c8ea3	Maryel	Noé salinas		maryel_76@hotmail.com	+523221925231	\N		2025-05-03 20:50:50.766	2025-05-03 20:50:50.766	\N
3f85a7d6-34f7-47a9-8a56-62d4bf9d7677	Scott	Baquie		\N	3223040816	\N		2025-05-03 20:50:50.766	2025-05-03 20:50:50.766	\N
9494daf7-56f0-4ee6-be58-0079e3cf2d90	Yovany	Beltran Glez.		\N	3951209730	\N		2025-05-03 20:50:50.766	2025-05-03 20:50:50.766	\N
b5de92ce-9997-47df-806e-7dbc7ad66aaf	Monica Osmara	Salgero Galves		\N	3171011629	\N		2025-05-03 20:50:50.767	2025-05-03 20:50:50.767	\N
f76c6c3d-5881-4fd1-b2aa-eed895267ee4	Rebeca	Sanchez		sofia.rod9912@gmail.com	+523222002786	\N		2025-05-03 20:50:50.767	2025-05-03 20:50:50.767	\N
1cc67183-e86a-46eb-bff1-cef880c4d20f	jose	Ponce		\N	3222790118	\N		2025-05-03 20:50:50.767	2025-05-03 20:50:50.767	\N
e8ac83be-e4f3-4fcb-8dcf-1830fb0b8a0b	Pedro Alberto	Oliva Cortes		oliva1978ncr@gmail.com	+523227795296	\N		2025-05-03 20:50:50.767	2025-05-03 20:50:50.767	\N
3f645a06-e944-45da-819d-210968ce2489	Karen Ileana	Arce Zepeda		Iliana.arce.01@gmail.com	3221754366	\N		2025-05-03 20:50:50.768	2025-05-03 20:50:50.768	\N
581f28d2-7bce-4650-98e3-8204f8d099a0	Marco Antonio	Rodriguez Gil		markoagil@gmail.com	+523221201551	\N		2025-05-03 20:50:50.768	2025-05-03 20:50:50.768	\N
4d3e56cf-7562-41eb-9b53-2fd9785838ee	Mariano	Bescoz		milaneza91@icloud.com	+526461454339	\N		2025-05-03 20:50:50.768	2025-05-03 20:50:50.768	\N
78fa0764-0e35-470c-b248-0d4abe8735e6	Marissa	Juarez Figueroa		\N	3221384693	\N		2025-05-03 20:50:50.769	2025-05-03 20:50:50.769	\N
45020b33-e087-4f98-8945-d6c4176aae23	Lidwig	de la parra		\N	3222352400	\N		2025-05-03 20:50:50.769	2025-05-03 20:50:50.769	\N
7982caf0-e022-4139-acb5-4325790e8efc	Karla	Arevalo Amezcua		\N	3222922759	\N		2025-05-03 20:50:50.77	2025-05-03 20:50:50.77	\N
76673ace-5204-4bb2-8dc7-9dd6ad7b558e	Ludwig	De la Parra Muñoz		\N	3223031677	\N		2025-05-03 20:50:50.77	2025-05-03 20:50:50.77	\N
b6754eda-7de2-4946-a803-33ccfe033ad6	Julio Albeto	Salgado Alvarez		\N	3221750893	\N		2025-05-03 20:50:50.77	2025-05-03 20:50:50.77	\N
383ba5d6-42b5-4cbe-a39d-1aae9793d6e0	Miguel Adolfo	Peña Estrella		\N	3221804599	\N		2025-05-03 20:50:50.77	2025-05-03 20:50:50.77	\N
7408086c-ab92-4f5e-b289-6c8a147c6a24	Magnolia	Sanchez		magnoliaderocha@gmail.com	+523311519046	\N		2025-05-03 20:50:50.771	2025-05-03 20:50:50.771	\N
c9249547-9696-41bd-a671-8c23cc104fe6	Oscar	Solis		\N	6561964451	\N		2025-05-03 20:50:50.771	2025-05-03 20:50:50.771	\N
ca25cb15-0c98-44c0-aa2b-97b350d89b17	Karla	Soria Alcazar		\N	3316073347	\N		2025-05-03 20:50:50.771	2025-05-03 20:50:50.771	\N
1f4e8045-24f4-45e7-abbf-3b251ea64400	Patric	prentece		\N	0015099516840	\N		2025-05-03 20:50:50.772	2025-05-03 20:50:50.772	\N
7e3603de-bd93-450a-813b-b6cfccc16f4d	María Mildred	Beaz Flores		mildredbf.6712@gmail.com	+523222940711	\N		2025-05-03 20:50:50.772	2025-05-03 20:50:50.772	\N
c0f11157-b9d2-4f56-893d-74ca0993503a	Kareli Jaqueline	Meza Romero		\N	3221745125	\N		2025-05-03 20:50:50.772	2025-05-03 20:50:50.772	\N
23a26e0c-a0a2-4e46-9699-3bafeff201b6	Pariss	Del Rio Ballesteros		\N	+524151145535	1984-02-16 00:00:00		2025-05-03 20:50:50.773	2025-05-03 20:50:50.773	\N
99f70c69-b6c0-40b6-b014-b33122ea81c9	Patrick	Prentice		\N	+15099516840	\N		2025-05-03 20:50:50.773	2025-05-03 20:50:50.773	\N
15780bd0-3edd-4c1f-8e68-0e04721dd15f	Lizbeth	Ramos Jiménez		\N	3222057528	\N		2025-05-03 20:50:50.773	2025-05-03 20:50:50.773	\N
01253de6-c001-497a-98aa-3520b5c863dd	Yolanda	Trejo Diaz		ibarriaflamingos13@hotmail.com	+523221115634	\N		2025-05-03 20:50:50.774	2025-05-03 20:50:50.774	\N
ef49a31f-9f10-47cb-b4c4-d68e96089c2f	Luis	Ortiz		\N	3222066721	\N		2025-05-03 20:50:50.774	2025-05-03 20:50:50.774	\N
95084963-ea97-46c4-8652-1b717f549acc	Valeria Paulina	Salgado Juarez		\N	3221073231	\N		2025-05-03 20:50:50.774	2025-05-03 20:50:50.774	\N
4484374b-ea84-46d6-88e6-6064dffbd006	Julia	Villela		\N	3223100146	\N		2025-05-03 20:50:50.775	2025-05-03 20:50:50.775	\N
ed4d387f-6d44-4fe6-a2e3-2a42d2a28727	Miroslava	Beltrán  Sanchez		\N	3221050988	\N		2025-05-03 20:50:50.775	2025-05-03 20:50:50.775	\N
7c46756a-5a5f-43a6-ac0e-bc430e14ef85	Leonel	Romero Sanchez		\N	17198210654	\N		2025-05-03 20:50:50.775	2025-05-03 20:50:50.775	\N
874b3741-f7b0-4ac1-853b-c6232032770f	Miguel	Navarro		\N	3221112535	\N		2025-05-03 20:50:50.775	2025-05-03 20:50:50.775	\N
a1d7165e-aaf1-4eaa-8f61-b6911099ef97	Linda Sahily	Solorio Espinosa		\N	3222948330	\N		2025-05-03 20:50:50.776	2025-05-03 20:50:50.776	\N
94090d08-13a8-49c4-8ae8-39100627db18	Julian Alexis	Barrios Navarro		\N	3223212765	\N		2025-05-03 20:50:50.777	2025-05-03 20:50:50.777	\N
2a7a33ee-37a9-4c5f-a019-4507853fa6e6	Ricardo	Moreno		rykardo.Celayaieraae@gmail.com	+523741098811	\N		2025-05-03 20:50:50.777	2025-05-03 20:50:50.777	\N
c3cab612-bc36-4bb6-a967-eef70c8e95f8	Martin	Lampreabe		\N	3221359461	\N		2025-05-03 20:50:50.777	2025-05-03 20:50:50.777	\N
b5cfd2c5-08c0-4491-b950-a09c9c445d44	Laurie	Weed		LAURIEWEED@gmail.com	+17072285331	\N		2025-05-03 20:50:50.778	2025-05-03 20:50:50.778	\N
67950ca1-948e-4fd0-a27c-244ed54378b5	Nancy	Quiroz Hernandez		\N	2221060677	\N		2025-05-03 20:50:50.778	2025-05-03 20:50:50.778	\N
1d184c00-ad46-4b2f-be19-218f98028744	Mariana	Salas Estrada		\N	3221468435	\N		2025-05-03 20:50:50.778	2025-05-03 20:50:50.778	\N
3055371c-6702-4897-acbd-f0cd92798f37	MAURO	SILLER		msillerelizalde@gmail.com	+528441186848	\N		2025-05-03 20:50:50.778	2025-05-03 20:50:50.778	\N
dc464afe-69ad-4569-bc28-87b1f1ba9aa7	LUCERO NAYELI	VAZQUEZ ANTONIO		\N	+524441427555	\N		2025-05-03 20:50:50.779	2025-05-03 20:50:50.779	\N
62e0a785-a37d-4d67-8bb9-08533c931894	Juan Ramon	Ibarria Lopez		\N	3223292017	\N		2025-05-03 20:50:50.779	2025-05-03 20:50:50.779	\N
4d8ea5b9-1a0a-420a-a7da-4ec2af8cc066	Nick	.		\N	+447791853793	\N		2025-05-03 20:50:50.779	2025-05-03 20:50:50.779	\N
99fc748e-23ac-4940-99ec-8d98a243ec47	Karen	Velez flores		Sufrida1994@icluod.com	+523221508724	\N		2025-05-03 20:50:50.78	2025-05-03 20:50:50.78	\N
b74edaa7-4c2a-4fad-a4ac-65e0dd7c23f0	Paulette	De Los Reyes Flores		paulette.rf@hotmail.com	+525532694191	\N		2025-05-03 20:50:50.78	2025-05-03 20:50:50.78	\N
65c5fd11-0638-4d0e-b366-b28366fc0332	Ximena	Hernández  García		\N	3221205819	\N		2025-05-03 20:50:50.78	2025-05-03 20:50:50.78	\N
5daff24f-3e2f-4cbe-9edc-b0e6602de041	Teresita de Jesus	Rodriguez Castañeda		\N	3222089954	\N		2025-05-03 20:50:50.781	2025-05-03 20:50:50.781	\N
b794d0dd-f390-4df5-b1e4-75d14f574969	Rafael	Vasquez		houseofrafael@gmail.com	+14804060178	\N		2025-05-03 20:50:50.781	2025-05-03 20:50:50.781	\N
d532417d-988d-4461-8495-844412211e5d	RICARDO	PEREZ ARCE		ricardo170405@gmail.com	+523221169466	\N		2025-05-03 20:50:50.781	2025-05-03 20:50:50.781	\N
738bd91d-5f0f-4fd8-ba5d-33ff425e7a7e	Livier	Barragan Quintero		\N	3222000447	\N		2025-05-03 20:50:50.782	2025-05-03 20:50:50.782	\N
df7ccd66-1887-4be3-bfdd-f305a0a1aae5	Luz Maria	Romero Rúiz		\N	3326277422	\N		2025-05-03 20:50:50.782	2025-05-03 20:50:50.782	\N
c4e2909a-f847-40d8-80c7-5df0369e0959	Roberto	Medina Mendiola		\N	3221110550	\N		2025-05-03 20:50:50.782	2025-05-03 20:50:50.782	\N
72d13d16-848d-4609-b389-a3d9790be7bf	Rosa Mercedes	Espinosa Chirino		rosechirino90@gmail.com	+529625295241	\N		2025-05-03 20:50:50.783	2025-05-03 20:50:50.783	\N
9b577ec9-52cc-4526-8876-5dc9d5b6c596	MARIA DEL ROCIO	VALDES MOLINA		rocio.science29@gmail.com	+527226542865	\N		2025-05-03 20:50:50.783	2025-05-03 20:50:50.783	\N
da7f405d-2cb8-42ac-96fd-a077b86ef521	Oscar Alonso	Rodriguez Guerrero		\N	3221424082	\N		2025-05-03 20:50:50.783	2025-05-03 20:50:50.783	\N
af8910bb-9862-43ce-ae53-a0b2475d3fba	Rosario	Alonso Estrella		rostrellaalons@gmail.com	+523223834906	\N		2025-05-03 20:50:50.784	2025-05-03 20:50:50.784	\N
96411f0c-13cf-4bc5-bd93-79fc3006a61d	MA.Obdulia	Llanos Sánchez		llanosyuya@gmail.com	+523221088632	\N		2025-05-03 20:50:50.784	2025-05-03 20:50:50.784	\N
02c2440d-d7c6-47cb-854e-89aed88ad136	Stephen	Rapson		\N	3223531014	\N		2025-05-03 20:50:50.784	2025-05-03 20:50:50.784	\N
5f328713-e60f-4a35-b3b7-f1c662e45fcb	Roberto	Maciel Miranda		\N	7442234913	\N		2025-05-03 20:50:50.785	2025-05-03 20:50:50.785	\N
6def0421-8cc6-4a55-87d1-c4791be82ad4	Katherine	Garbe		\N	3221374502	\N		2025-05-03 20:50:50.785	2025-05-03 20:50:50.785	\N
0116411c-c779-4a0b-b7c8-51722fffd0c8	Maria Teresa	Rodriguez Fuentes		\N	3221099939	\N		2025-05-03 20:50:50.785	2025-05-03 20:50:50.785	\N
c25c6c08-d49c-4e3e-807f-6e28f6d2b680	Monserrat Guadalupe	Madero Maciel		\N	3224347595	\N		2025-05-03 20:50:50.786	2025-05-03 20:50:50.786	\N
6e6056ba-831e-464f-b086-19f9e52b5c88	Maria de Jesus	De Anda de Anda		machu1934@hotmail.com	+523329373436	\N		2025-05-03 20:50:50.786	2025-05-03 20:50:50.786	\N
feb828b1-7026-4fc6-9292-a8efa0ee436e	Natalia	PlumaperezAreyano		\N	3222890769	\N		2025-05-03 20:50:50.786	2025-05-03 20:50:50.786	\N
0f84d39b-0035-4459-b193-ca2257c21156	Maricruz	Valecia Andrade		\N	3221168126	\N		2025-05-03 20:50:50.787	2025-05-03 20:50:50.787	\N
93aba8c1-c2fa-4a24-895b-d2a3810f1fab	María Citlalli	Sanchez Garcia		Citlallygarrr11@gmail.com	+523222668740	\N		2025-05-03 20:50:50.787	2025-05-03 20:50:50.787	\N
7d4b77cc-e8b4-4bcc-9a51-18445ec30384	KAREN	ORTEGA AYALA		karenort700@gmail.com	+523221220720	\N		2025-05-03 20:50:50.787	2025-05-03 20:50:50.787	\N
e3ca25c6-de60-4fc2-802d-9620adc3f3d4	Luz Patricia	Soto Trillo		ikamatsot@gmail.com	+523221184627	\N		2025-05-03 20:50:50.788	2025-05-03 20:50:50.788	\N
4264d0d4-a032-40c2-b90d-04f76a21c934	Marian	Ridriguez Perez		\N	3221072602	\N		2025-05-03 20:50:50.788	2025-05-03 20:50:50.788	\N
e07eaa7f-c21e-4ebf-b545-5d43df06b58d	Jose Alberto	Casa López		\N	3221429735	\N		2025-05-03 20:50:50.788	2025-05-03 20:50:50.788	\N
f3908210-7c8f-4257-b833-3b53a51ac4fd	Laura	Serrano		dra.serranocirujana@gmail.com	+525548637142	\N		2025-05-03 20:50:50.789	2025-05-03 20:50:50.789	\N
ba5801cc-d060-4731-b731-4457d645bbee	Marisol	Aguilar Calvario		\N	3221167111	\N		2025-05-03 20:50:50.789	2025-05-03 20:50:50.789	\N
0e3b3fb2-c50b-4b75-980b-1a4b4c4c66c4	Mateo	Pluma Perez		\N	3222890769	\N		2025-05-03 20:50:50.789	2025-05-03 20:50:50.789	\N
1d986e5a-cc97-4950-b1d9-f12a5eb2676e	Rafael	Raigoza Pinedo		\N	+16123879572	\N		2025-05-03 20:50:50.789	2025-05-03 20:50:50.789	\N
14f4b73a-3b02-4084-bb7b-5e077cd978e1	Roxana	Jimenez		dz7r2dfbwy@privaterelay.appleid.com	+523221902963	\N		2025-05-03 20:50:50.79	2025-05-03 20:50:50.79	\N
8ab28bb9-1c34-40c2-a103-fa2bafc9ef5a	Liam	Villa Ruiz		\N	3221505293	\N		2025-05-03 20:50:50.79	2025-05-03 20:50:50.79	\N
3151bc77-e4ac-454d-8157-e4581a40cda2	zuriana	López Coróna		\N	3221925150	\N		2025-05-03 20:50:50.79	2025-05-03 20:50:50.79	\N
3de37b18-61eb-46b2-af3b-8b593ec213cc	Juan Carlos	Orozco Montelongo		\N	3222291474	\N		2025-05-03 20:50:50.791	2025-05-03 20:50:50.791	\N
7f35edff-a037-4472-b8e7-d91110da4652	Maria Teresa	Martinez Cisneros		\N	3221993205	\N		2025-05-03 20:50:50.791	2025-05-03 20:50:50.791	\N
87df1730-267d-401d-8c74-ae884bf0bf9a	Ruben	Valero Padilla		\N	3227285604	\N		2025-05-03 20:50:50.791	2025-05-03 20:50:50.791	\N
de4d1019-cece-4243-8e7f-e072251e2a98	Silvia	Conrriques		\N	523221681688	\N		2025-05-03 20:50:50.792	2025-05-03 20:50:50.792	\N
554f6fc8-54c4-4d9c-aea2-e91b30ed66d8	Tomas	Rehacek		\N	5547735002	\N		2025-05-03 20:50:50.792	2025-05-03 20:50:50.792	\N
f1e885eb-b23c-4a4a-894d-7e678980c32b	Sandra	Perez Rodríguez		\N	3221742876	\N		2025-05-03 20:50:50.792	2025-05-03 20:50:50.792	\N
e8fffe89-ace0-4424-8d24-720f29420179	Sstacie Ann	Boudros		\N	3223238251	\N		2025-05-03 20:50:50.793	2025-05-03 20:50:50.793	\N
a68f6698-e21a-477d-ab39-418b0497b097	Stacie Ann	Boudros		\N	3223238251	\N		2025-05-03 20:50:50.793	2025-05-03 20:50:50.793	\N
298a7eb9-7f15-4d4d-935e-5338df2e29ba	Omar	Morales Rivera		\N	3338201512	\N		2025-05-03 20:50:50.793	2025-05-03 20:50:50.793	\N
00a8543e-395d-4fbd-806c-6eea40c8d208	Rubio Avalos	Eberardo		\N	3223512268	\N		2025-05-03 20:50:50.793	2025-05-03 20:50:50.793	\N
ca8ffb10-1c1c-4f6a-8b5c-08cd678f89dd	Mararely	Deloya Alarcon		carlrod5261@gmail.com	7224431744	\N		2025-05-03 20:50:50.794	2025-05-03 20:50:50.794	\N
0cf65995-dca2-451e-b1c5-a40a438b5447	Juan Carlos	Gomez Rivera		\N	3223788231	\N		2025-05-03 20:50:50.794	2025-05-03 20:50:50.794	\N
f9031b82-5a65-4e97-aac8-f86f7be67dbb	Lizeth	Garcia		suvama2004@gmail.com	+523223306960	\N		2025-05-03 20:50:50.794	2025-05-03 20:50:50.794	\N
5d8f9d8d-27a1-4f0f-9a2c-ada6f44c17ae	MAGNOLIA	Sanchez Jará		magnoliasajara@hotmail.com	+523311519046	1982-11-15 00:00:00		2025-05-03 20:50:50.795	2025-05-03 20:50:50.795	\N
738adc17-0647-4da1-9552-7dfe83411940	Llano Villarreal	Mitzi		\N	3221305391	\N		2025-05-03 20:50:50.795	2025-05-03 20:50:50.795	\N
bc55f210-1937-4378-8442-7f30ab12ebde	Ruben	Hernandez Monterubio		\N	4423546018	\N		2025-05-03 20:50:50.795	2025-05-03 20:50:50.795	\N
91ab6fbc-3580-455f-ad45-13eca7ff10e0	Oscar manuel	Flores arreola		lupillin1@hotmail.com	+523221936462	\N		2025-05-03 20:50:50.796	2025-05-03 20:50:50.796	\N
90db6f93-514a-44a0-a8a3-2144d95cae38	Lopez Rivera	Jobita		contemporanea.jardin@gmail.com	3222749458	\N		2025-05-03 20:50:50.796	2025-05-03 20:50:50.796	\N
d293c44d-89a8-450b-88a1-28dc4a4586ee	Perla	Regla		perla.nrj@gmail.com	+523221225207	\N		2025-05-03 20:50:50.796	2025-05-03 20:50:50.796	\N
842dafb2-f06e-447c-a484-0f9108f2c2cc	Rodriguez  García	Tereza de jesus		\N	3221970752	\N		2025-05-03 20:50:50.797	2025-05-03 20:50:50.797	\N
44ef8dfb-9a52-45d3-9045-a91bf2b19751	Joseph	Phillion		r.jphillion@gmail.com	+523223039300	\N		2025-05-03 20:50:50.797	2025-05-03 20:50:50.797	\N
5b5a9fdb-580e-487b-a13c-f4f569ba9c23	Sandi	Bassett		\N	+16725133075	\N		2025-05-03 20:50:50.797	2025-05-03 20:50:50.797	\N
8a11a48d-acd2-45ba-a4d9-890bf82b054d	Luis Miguel	Tovar Hernández		\N	3223749947	\N		2025-05-03 20:50:50.798	2025-05-03 20:50:50.798	\N
7a3a6766-fd96-477c-8c1d-801b60ab6768	Roxana	Morgante		\N	3222942273	\N		2025-05-03 20:50:50.798	2025-05-03 20:50:50.798	\N
a14df979-184a-4c4a-b6dc-7ddd81ee4f4e	Roxana	Morgante		rmorgante7@hotmail.com	3222942273	2025-03-10 00:00:00		2025-05-03 20:50:50.798	2025-05-03 20:50:50.798	\N
3fb82069-3f72-4cf3-bef7-3e4930e58fa7	Ramon	Llanos Sanchez		\N	3221971216	\N		2025-05-03 20:50:50.799	2025-05-03 20:50:50.799	\N
fae2ae1e-49a4-43c1-88de-a8cac8fe7202	Sofia	Medina García		\N	3221085415	\N		2025-05-03 20:50:50.799	2025-05-03 20:50:50.799	\N
719d77cc-744c-4391-aada-d41c43427e25	Samantha	Conrriques Bravo		\N	3222456884	\N		2025-05-03 20:50:50.799	2025-05-03 20:50:50.799	\N
c9c2471e-153a-4292-8513-bf9b204c140a	Raul Jhonattan	Sandoval Hernandez		\N	3311483794	\N		2025-05-03 20:50:50.8	2025-05-03 20:50:50.8	\N
f0926081-7987-4ef9-bc3a-d032674c0e19	Roberto	Maciel cuevas		\N	3223490213	\N		2025-05-03 20:50:50.8	2025-05-03 20:50:50.8	\N
334694c2-d1eb-489a-a3e0-de583a8e3b59	Roberto	Maciel		cronos28@gmail.com	+523223490213	\N		2025-05-03 20:50:50.8	2025-05-03 20:50:50.8	\N
53e7de92-96cc-4bfd-a6da-1ce416432a42	Wendy Alejandra	Gonzalez Beltran		wendyale01@gmail.com	+523222756065	\N		2025-05-03 20:50:50.801	2025-05-03 20:50:50.801	\N
e4027315-2572-462a-9e1f-056c407a22ce	María Dolores	Ramos Macias		Ramacmd@hotmail.com	+523221307592	\N		2025-05-03 20:50:50.801	2025-05-03 20:50:50.801	\N
82067276-9715-4cce-90f0-810b5e8f2269	Kelly	Odia		\N	+18053401232	\N		2025-05-03 20:50:50.801	2025-05-03 20:50:50.801	\N
eba7e828-c9a4-4416-bb29-0ff79db7fb63	Miriam	Lopez Nol		\N	3222052336	\N		2025-05-03 20:50:50.802	2025-05-03 20:50:50.802	\N
79a29803-3cde-47d3-912c-08c5263e334a	Tapia Hermocillo	Jose		\N	3223330013	\N		2025-05-03 20:50:50.802	2025-05-03 20:50:50.802	\N
561249e7-ec43-48d7-84d3-80ae6cc7eca2	Juan Ismael	Vergara Montoya		juan.vergara@docplanner.com	+525611722894	\N		2025-05-03 20:50:50.802	2025-05-03 20:50:50.802	\N
5552a923-4a69-47fd-ab5a-4643587db8ae	Joshara	Barcenas Gonzalez		\N	3222204383	\N		2025-05-03 20:50:50.803	2025-05-03 20:50:50.803	\N
3556ce8c-88e6-4f77-bb1a-dd1482071c2b	Yahir	Villareal Moran		\N	3221928347	\N		2025-05-03 20:50:50.803	2025-05-03 20:50:50.803	\N
fe77ea84-6679-4b19-96ec-19913ac95997	Rosa	Palomera Morales		saulamador@gmail.com	+523221312585	\N		2025-05-03 20:50:50.803	2025-05-03 20:50:50.803	\N
b5cd9f2a-8479-493a-848d-9b6defdbfa48	Saul	Amador		saulamador@gmail.com	3221312585	\N		2025-05-03 20:50:50.803	2025-05-03 20:50:50.803	\N
67b28ced-5420-4714-be83-3243409399e5	Magaña García	Rebeca Dessire		\N	3339683092	\N		2025-05-03 20:50:50.804	2025-05-03 20:50:50.804	\N
28ef689a-7e8b-4cd9-b44f-1ba3966211ed	Maria Ofelia	Topete Basurto		ofeliatopete01@gmail.com	+523221372030	\N		2025-05-03 20:50:50.804	2025-05-03 20:50:50.804	\N
ce64cc5d-cb28-42fe-8807-3b34e919f62a	Tonathiu	Fajardo		msleluxa@gmail.com	3227792005	2024-05-12 00:00:00		2025-05-03 20:50:50.804	2025-05-03 20:50:50.804	\N
770244ba-6ba6-4d6d-a23c-8cb6313cbe0d	Valeria	Salgado		\N	3221073231	\N		2025-05-03 20:50:50.805	2025-05-03 20:50:50.805	\N
2d7a5f99-82fa-426a-b92c-7eb0773ee424	Juan Manuel	Rivas Rodriguez		\N	3223100190	\N		2025-05-03 20:50:50.805	2025-05-03 20:50:50.805	\N
3087aef8-8fbb-4818-a28a-b2bf68c98e64	Juan	Salgado		jsalgad@gmail.com	+523227797377	\N		2025-05-03 20:50:50.805	2025-05-03 20:50:50.805	\N
f93ebaff-5a52-47fc-96f8-f65f31b90062	vucicevic	Sacha		\N	+17789384304	\N		2025-05-03 20:50:50.806	2025-05-03 20:50:50.806	\N
9c7d3672-b4ee-4ea7-9de9-63702369f97e	Nuria	Castellanos Aguirre		\N	3221219098	\N		2025-05-03 20:50:50.806	2025-05-03 20:50:50.806	\N
66f0b894-eb46-47f9-a8d3-0ffdb1d354db	Lua	Boudros		\N	3223238251	\N		2025-05-03 20:50:50.806	2025-05-03 20:50:50.806	\N
acf0f7ea-19f2-4d11-8767-65d3fd6569a0	Maria Fernanda	Arjona Mercado		\N	3222940343	\N		2025-05-03 20:50:50.807	2025-05-03 20:50:50.807	\N
9b410702-bdb7-4a61-9baa-304e2c33bc2b	shonn	Enasoglw		\N	+12066198723	\N		2025-05-03 20:50:50.807	2025-05-03 20:50:50.807	\N
9eaa0f71-ee97-452c-ab51-51fb5985c61c	Mariana	Vazquez Fuentes		\N	3316717096	\N		2025-05-03 20:50:50.807	2025-05-03 20:50:50.807	\N
c2842d69-f702-44dd-88b6-71567c9373bf	Ruiz Ramirez	Samuel		\N	3222412618	\N		2025-05-03 20:50:50.808	2025-05-03 20:50:50.808	\N
d01f26d6-e15a-4e52-8ee9-cbf64be9bb36	Sandra	Hernández García		sandyspace52@gmail.com	+523221027934	\N		2025-05-03 20:50:50.808	2025-05-03 20:50:50.808	\N
a9e38084-7696-41e5-8d16-c3f6f68a9e2c	silvia	Aceves		\N	3313258446	\N		2025-05-03 20:50:50.808	2025-05-03 20:50:50.808	\N
937baf9a-a834-4d42-b04c-f10c32e1c727	Roberto	Salas Santana		\N	3222432456	\N		2025-05-03 20:50:50.809	2025-05-03 20:50:50.809	\N
82a23b70-55d6-4713-bf4e-b0e5315fcd80	Segio	Galvan		\N	3222942307	\N		2025-05-03 20:50:50.809	2025-05-03 20:50:50.809	\N
38e1cb9b-95a3-4c2c-ad0f-0b9a7c2ca4fa	Mark	Ogden		arolop1234@gmail.com	+523223077809	\N		2025-05-03 20:50:50.809	2025-05-03 20:50:50.809	\N
40b90443-2b29-4383-b3db-d0e2e69a66f4	Sergio Martin	Galvan Quiroga		\N	3222942307	\N		2025-05-03 20:50:50.81	2025-05-03 20:50:50.81	\N
2b759a5f-83ae-4330-a3ef-9dc346e71ee4	Luz Aurora	Chavarin Zepeda		\N	3222110980	\N		2025-05-03 20:50:50.81	2025-05-03 20:50:50.81	\N
c7015a29-665c-4f66-bc41-8f577ab1937e	Rosa	Morales Palomera		saulamador@gmail.com	+523221312585	\N		2025-05-03 20:50:50.81	2025-05-03 20:50:50.81	\N
98c98983-5194-420e-88fb-0f599a3998de	Marisa	Landero		marmunland@gmail.com	+19563573587	\N		2025-05-03 20:50:50.811	2025-05-03 20:50:50.811	\N
6152bb3a-bc91-4592-9ef9-0a1652f2db95	Maria Eugenia	Coronado Dehesa		\N	3223505787	\N		2025-05-03 20:50:50.811	2025-05-03 20:50:50.811	\N
95823037-2e47-4ad9-8e7b-96d3d0013a27	Valeria	Palacios Valenzuela		valee.palacioos@gmail.com	+523223277887	\N		2025-05-03 20:50:50.811	2025-05-03 20:50:50.811	\N
3864c700-1b24-4c18-a802-60c52587b26c	Rebeccah	moore		\N	3221393311	\N		2025-05-03 20:50:50.812	2025-05-03 20:50:50.812	\N
96a6ea5a-d5d1-40cf-a20b-f21520e93287	Julian	Lesama Morales		\N	3221338841	\N		2025-05-03 20:50:50.812	2025-05-03 20:50:50.812	\N
69368c83-c226-4293-939f-1ea4c2dd9c45	Osbaldo	Matian Benites		\N	523221524505	\N		2025-05-03 20:50:50.812	2025-05-03 20:50:50.812	\N
a83e52c9-731b-448b-9cae-9ff49c1d4614	Paulina	Casilla		\N	3221478281	\N		2025-05-03 20:50:50.813	2025-05-03 20:50:50.813	\N
53074d7a-6841-42b3-acde-f565f53b60b3	Mayra Guadalupe	Garcia Palomares		\N	3221396826	\N		2025-05-03 20:50:50.813	2025-05-03 20:50:50.813	\N
63552d07-d476-4e2e-b1e7-d2d2f08dea32	Roberto	Cantu		\N	8442924971	\N		2025-05-03 20:50:50.813	2025-05-03 20:50:50.813	\N
0ad158ba-a134-44b4-a02c-8efe97f3c366	Lourdes	Jaimes		lourdesjaime21@gmail.com	+524621079899	\N		2025-05-03 20:50:50.813	2025-05-03 20:50:50.813	\N
44a2f56a-2ad3-403f-b42c-2597e4ba9a2e	Ximena	Delgado Gomez		ximej21@gmail.com	+526647324582	2003-03-22 00:00:00		2025-05-03 20:50:50.814	2025-05-03 20:50:50.814	\N
c0199df0-2cbc-4802-bc2f-f3d91713e476	Karla Elizth	Flores Chavez		ymora50@yahoo.com	3221368107	\N		2025-05-03 20:50:50.814	2025-05-03 20:50:50.814	\N
e6c91869-2f11-4a2f-a43b-0fc98616b019	María Fernanda	Gonzalez Gradilla		fersstar20@gmail.com	+523222753233	\N		2025-05-03 20:50:50.814	2025-05-03 20:50:50.814	\N
b2ff1c1d-0aa9-4b52-8e6e-5ddf92ad6b0d	Luis Edgardo	Godoy López		\N	3222169452	\N		2025-05-03 20:50:50.815	2025-05-03 20:50:50.815	\N
d2fe80d9-bdf1-4118-b237-20518d6d331a	Manuel de Jesus	Hernandez Robles		manuel.hernandez.robles10@gmail.com	+523310979282	\N		2025-05-03 20:50:50.815	2025-05-03 20:50:50.815	\N
5ceebc65-2e06-41b6-bcee-8e35ba0e783c	Jose Rafael	Rubio Vasquez		\N	3111216292	\N		2025-05-03 20:50:50.815	2025-05-03 20:50:50.815	\N
d3dcb151-92ca-4d2d-80ea-4180097d5b31	Maribel	Sanciprián		msleluxa@gmail.com	+523221812769	2024-10-04 00:00:00		2025-05-03 20:50:50.816	2025-05-03 20:50:50.816	\N
13373268-afb7-448f-91f2-c351ef683ef3	Laura Luz	Quintero Peña		\N	3221396081	\N		2025-05-03 20:50:50.816	2025-05-03 20:50:50.816	\N
47818307-7566-4f1e-bcf4-b2cdd436991e	Urrea Jimenez	Isabella		\N	3222742356	\N		2025-05-03 20:50:50.816	2025-05-03 20:50:50.816	\N
eb02e038-1745-4cc6-bc29-6a3c1d12ce63	Per	Westlund		\N	+15593812009	\N		2025-05-03 20:50:50.816	2025-05-03 20:50:50.816	\N
a8d7545d-9449-4f23-bdc0-972f03cc5a1d	Marisol	Orozco Robles		\N	3221815556	\N		2025-05-03 20:50:50.817	2025-05-03 20:50:50.817	\N
e7043e0c-ab4f-47a8-95e6-334102a4055f	Marisol	Orozco Robles		\N	3221815556	\N		2025-05-03 20:50:50.817	2025-05-03 20:50:50.817	\N
a57d867b-2e97-4c3e-a3cf-92f82cd40a2b	Margarita	Arango Henriquez		marthamn@hotmail.com	+528180277174	\N		2025-05-03 20:50:50.817	2025-05-03 20:50:50.817	\N
43b99848-02e1-47df-9ed1-a849433429b0	Simon	Desjardins		\N	+15149707597	\N		2025-05-03 20:50:50.818	2025-05-03 20:50:50.818	\N
bda028a1-0baf-4344-8688-7a2c7f95e620	Óscar Fernando	Vázquez Díaz		pamela69roja@gmail.com	+523221811583	\N		2025-05-03 20:50:50.818	2025-05-03 20:50:50.818	\N
c32c8767-40ff-40a5-8ae7-b5ec68af9ac9	Livier	Arechiga Leon		\N	3221510496	\N		2025-05-03 20:50:50.818	2025-05-03 20:50:50.818	\N
9132f702-fd34-48c5-b59f-182839ff536b	Ulices	Peña Gonzalez		\N	3315207954	\N		2025-05-03 20:50:50.819	2025-05-03 20:50:50.819	\N
babab732-afa2-4bfa-a059-b0593cbfd342	Sofia	Medina		garciarg@hotmail.com	+523221085415	\N		2025-05-03 20:50:50.819	2025-05-03 20:50:50.819	\N
d042304c-184d-4bad-bce1-e078e4d9c8f2	Veronica Marlen	Hidalgo Ramirez		tdt87jmnnr@privaterelay.appleid.com	+523222002800	\N		2025-05-03 20:50:50.819	2025-05-03 20:50:50.819	\N
d35c0ec3-6301-4b26-841d-1918ddd0cbf0	Mildret Monserrat	Martínez Mendoza		monse011001@outlook.es	+523112835560	\N		2025-05-03 20:50:50.819	2025-05-03 20:50:50.819	\N
a91798bd-8449-44c3-9f70-1b435b2de505	Yesenia	Rivera		yeseniarivera821@gmail.com	+523221219810	\N		2025-05-03 20:50:50.82	2025-05-03 20:50:50.82	\N
e81bfc64-2c77-46d2-8be4-12864fc9e676	Naomi	Ruiz Ramirez		\N	3223845310	\N		2025-05-03 20:50:50.82	2025-05-03 20:50:50.82	\N
2184639c-6af9-47d4-9502-b7ee400c7ef6	Mark	Ogden		arolop4@bluetiehome.com	+523223077809	\N		2025-05-03 20:50:50.82	2025-05-03 20:50:50.82	\N
e4954b22-bf37-48af-885b-144bdec98a88	Juan Luis	Rodriguez		rodriguezjuanluis21@gmail.com	+523222100265	\N		2025-05-03 20:50:50.821	2025-05-03 20:50:50.821	\N
0dfadddd-ff42-4419-8cd5-1850e777fb64	Raúl	López Gutierrez		\N	3314198564	\N		2025-05-03 20:50:50.821	2025-05-03 20:50:50.821	\N
38049e32-9570-4065-860d-d6a62c9db68f	Sara	Torres Xolocotzi		\N	3221050968	\N		2025-05-03 20:50:50.821	2025-05-03 20:50:50.821	\N
1aab1969-34b8-4e89-9f7d-ecb97f5fc40b	Paola	Gutierrez Buena		\N	3221549011	\N		2025-05-03 20:50:50.822	2025-05-03 20:50:50.822	\N
b31cc161-a81f-472d-a9e6-87270bc4f73f	Rosario	Yamahui de Flores		\N	525574072349	\N		2025-05-03 20:50:50.822	2025-05-03 20:50:50.822	\N
eefe3d77-4225-4b6b-9aa1-f17fb46d20b5	Vanessa	Ruelas Cisneros		\N	3221599212	\N		2025-05-03 20:50:50.822	2025-05-03 20:50:50.822	\N
fbd88c8e-726a-4d6d-aead-c76982240065	Raziel	Galvan Morales		\N	7751061200	\N		2025-05-03 20:50:50.823	2025-05-03 20:50:50.823	\N
339aaa70-e848-494d-a68c-f5f19dcf08b4	Rafael	Medina Ramirez		\N	3221356892	\N		2025-05-03 20:50:50.823	2025-05-03 20:50:50.823	\N
1c43abdb-1ffe-477d-b7ad-ed9c38b24a3c	reynaldo	Arce Palomera		\N	3221399438	\N		2025-05-03 20:50:50.823	2025-05-03 20:50:50.823	\N
c6849ecf-622b-4a74-8237-58fe67066577	Luz Maria	Romero Ruiz		ernestinagromero@gmail.com	+523221932410	\N		2025-05-03 20:50:50.824	2025-05-03 20:50:50.824	\N
64c4faab-0535-44b9-9f51-01a945706b04	Julio	ContrerasGutierrez		julio11contreras@gmail.com	+15106773524	\N		2025-05-03 20:50:50.824	2025-05-03 20:50:50.824	\N
16701cf7-d698-49f4-8177-cbba97ab4b6b	Lázaro Javier	Franco Salcedo		\N	3221356684	\N		2025-05-03 20:50:50.824	2025-05-03 20:50:50.824	\N
14e0042a-ad24-4c15-afb4-5949f4802649	Richard	Macphee		\N	+17808867647	\N		2025-05-03 20:50:50.825	2025-05-03 20:50:50.825	\N
16e266a5-1f1e-4e88-a0fb-93f5b1ea6a21	Mayela	Del Campo Irizar		\N	3221552322	\N		2025-05-03 20:50:50.825	2025-05-03 20:50:50.825	\N
62b1c4e4-87f1-4fc9-988f-423d720f03bd	Renee	Coleman		\N	+19106741902	\N		2025-05-03 20:50:50.825	2025-05-03 20:50:50.825	\N
c2080a00-c761-474c-a408-e462051e2949	Oyiki	Gutierrez URRUTIA		\N	3227797052	\N		2025-05-03 20:50:50.825	2025-05-03 20:50:50.825	\N
7dbeb3f1-69b4-4c2a-a739-1cac38e67308	Oyiki	Gutierrez URRUTIA		\N	3227797052	\N		2025-05-03 20:50:50.826	2025-05-03 20:50:50.826	\N
4324455c-e91d-4f3a-9544-d4dc701a1caf	Oyiki	Gutierrez URRUTIA		\N	3227797052	\N		2025-05-03 20:50:50.826	2025-05-03 20:50:50.826	\N
22dcc3e9-87ab-4498-9038-eb7fb6464d37	Raziel	Galvan		raziel5ainge@gmail.com	+527751061200	\N		2025-05-03 20:50:50.826	2025-05-03 20:50:50.826	\N
a84735e0-79e3-4c04-a67e-9981ac52c867	Oyiki	Gutierrez URRUTIA		\N	3227797052	\N		2025-05-03 20:50:50.827	2025-05-03 20:50:50.827	\N
328a830a-54d4-44fa-95ad-722765d48ea9	Oyiki	Gutierrez URRUTIA		\N	3227797052	\N		2025-05-03 20:50:50.827	2025-05-03 20:50:50.827	\N
16a13e24-d834-4998-9bdf-c71bf87e213b	Paola Patricia	Rivera Saucedo		\N	3222322712	\N		2025-05-03 20:50:50.827	2025-05-03 20:50:50.827	\N
319b31ed-69d3-4353-aa7a-3df79cfde1da	Yazmin	David		\N	+523221089431	\N		2025-05-03 20:50:50.828	2025-05-03 20:50:50.828	\N
186b4241-2c67-4a27-b142-122bd67c2bb6	Oyiki	Gutierrez Urrutia		\N	3227797052	\N		2025-05-03 20:50:50.828	2025-05-03 20:50:50.828	\N
8fcef729-1616-473f-b66f-b509ab651444	Robyn	Hober		\N	+16786030474	\N		2025-05-03 20:50:50.828	2025-05-03 20:50:50.828	\N
b5dbbf08-499e-44ff-aca4-6fd2a4cea37e	Marco	Huizar Robles		\N	3221366563	\N		2025-05-03 20:50:50.828	2025-05-03 20:50:50.828	\N
39cf1520-dfef-430d-988a-5f86dc2a0a2e	Julie	Tucaro		\N	0017808383378	\N		2025-05-03 20:50:50.829	2025-05-03 20:50:50.829	\N
f948ea72-5dce-466f-9f2c-52f9141be421	Mya	Eidelbes		\N	+12186845241	\N		2025-05-03 20:50:50.829	2025-05-03 20:50:50.829	\N
72ed6de4-0e53-4770-afff-c8d15c01548a	Mariana	Vargas		\N	8713974239	\N		2025-05-03 20:50:50.829	2025-05-03 20:50:50.829	\N
97c29ac8-8ef6-4852-b36a-b092398614e9	Laura Esther	Sanchez Orozco		\N	3221310779	\N		2025-05-03 20:50:50.83	2025-05-03 20:50:50.83	\N
938e8c02-60a3-421e-8fa6-98935bffb3bd	Victor  Axel	Franco Herrera		\N	5621880413	\N		2025-05-03 20:50:50.83	2025-05-03 20:50:50.83	\N
bcb9a8c1-4620-4943-9676-0cde61cd5418	Veronica	Chavez Rubino		\N	3312602170	\N		2025-05-03 20:50:50.83	2025-05-03 20:50:50.83	\N
5bbf0148-9141-4b26-b2dd-de6d212b172a	Sabrina	Munian		\N	+19174035195	\N		2025-05-03 20:50:50.831	2025-05-03 20:50:50.831	\N
4f678b88-fc4f-42ba-9c67-54bf677fafd6	Julia	Marron Santana		\N	3221089638	\N		2025-05-03 20:50:50.831	2025-05-03 20:50:50.831	\N
a71654a2-d14a-4d27-8ab3-1e27155744a5	Minke	Martinez Chavez		\N	5527113130	\N		2025-05-03 20:50:50.831	2025-05-03 20:50:50.831	\N
db289b48-7ed5-46c3-800d-638100867470	Silvia Guadalupe	Salazar Ramirez		\N	3311759251	\N		2025-05-03 20:50:50.831	2025-05-03 20:50:50.831	\N
89426629-e142-48a2-be2e-af6797da68f1	Manuel	Cadle		\N	+17802451366	\N		2025-05-03 20:50:50.832	2025-05-03 20:50:50.832	\N
ceb1dd34-fc47-4f29-b495-e8adcc6b1ee4	Villalpando Guzmann	Victor Raul		\N	3221601739	\N		2025-05-03 20:50:50.832	2025-05-03 20:50:50.832	\N
e227faf9-cdd0-4400-9763-6b36276cbfa1	Luz Maria	Covian Gutierrez		\N	3221233264	\N		2025-05-03 20:50:50.832	2025-05-03 20:50:50.832	\N
e5b37016-6205-4826-b8fc-78fb3a42c063	Osmar Izac	Perez Romero		\N	3221166768	\N		2025-05-03 20:50:50.833	2025-05-03 20:50:50.833	\N
8988ff89-f2a3-486a-b5c3-9309b6390ab4	Lorie	Boulduc		\N	+17056651941	\N		2025-05-03 20:50:50.833	2025-05-03 20:50:50.833	\N
76dc1a48-bbbd-495c-a93a-2f1810c934da	Luz Maria	Cobian Gutierrez		\N	3221233264	\N		2025-05-03 20:50:50.833	2025-05-03 20:50:50.833	\N
17bb7569-cc8c-4c56-b920-ad369bb49250	Robert	Bolduc		\N	+17056651941	\N		2025-05-03 20:50:50.834	2025-05-03 20:50:50.834	\N
5b7830cf-c556-4abf-b076-284ef83e30a3	Monzerrat	Bañuelos		ambg_monze@hotmail.com	+523221801462	1998-04-14 00:00:00		2025-05-03 20:50:50.834	2025-05-03 20:50:50.834	\N
7f417f8e-6b5a-4c5c-9253-e727f466571b	Paul	Fouler		\N	+15056039528	\N		2025-05-03 20:50:50.834	2025-05-03 20:50:50.834	\N
6d627ffd-a44e-45c0-a13f-3c45a547d9b8	Vanessa	Vidal		Vidal.Vanessa.1gv@gmail.com	+526643668729	2001-05-21 00:00:00		2025-05-03 20:50:50.835	2025-05-03 20:50:50.835	\N
9c35ed5b-ad29-4b24-a71c-45c953751e1b	Silvia	Hernandez Renteria		\N	3221091216	\N		2025-05-03 20:50:50.835	2025-05-03 20:50:50.835	\N
95b797f5-67ef-4d04-b536-2a7ee0752d0a	manuel	Saucedo Delgado		\N	3223704824	\N		2025-05-03 20:50:50.835	2025-05-03 20:50:50.835	\N
54f357f7-25cd-4b9a-a15f-4aadb2ba3239	Nilsa Teresa	Gonzalez Roriguez		\N	3331325769	\N		2025-05-03 20:50:50.836	2025-05-03 20:50:50.836	\N
75c40236-7084-4840-bdd8-16136d953866	Luis jesus	Ramirez Olivera		\N	3221226921	\N		2025-05-03 20:50:50.836	2025-05-03 20:50:50.836	\N
db505d22-54ba-4039-bfc6-dc1bc1db986b	Rosa Candelaria	Perez Campos		\N	3222055397	\N		2025-05-03 20:50:50.836	2025-05-03 20:50:50.836	\N
28728f8d-ea69-48c9-a280-3becf0972673	Kathy	Glover		\N	\N	\N		2025-05-03 20:50:50.836	2025-05-03 20:50:50.836	\N
0b6505b7-b58a-4d05-a667-ed93391e93ae	Maria	Ponce Cabrera		\N	3223734420	\N		2025-05-03 20:50:50.837	2025-05-03 20:50:50.837	\N
cb525c86-96b7-45be-b88e-6943b62eeaad	Marcos	Gonzalez Campos		\N	3311935709	\N		2025-05-03 20:50:50.837	2025-05-03 20:50:50.837	\N
332cb1e8-6ab1-4bef-a788-dbf32e7bf697	Nora	Gutierrez		\N	3221564556	\N		2025-05-03 20:50:50.837	2025-05-03 20:50:50.837	\N
ae62dec0-6a65-4aca-8aff-d6ea5c4bf443	Lina	Dueñas		\N	3313659774	\N		2025-05-03 20:50:50.838	2025-05-03 20:50:50.838	\N
d02465e0-1588-434b-be69-f1ad1e0d1f85	Josefina	Valdes		\N	\N	\N		2025-05-03 20:50:50.838	2025-05-03 20:50:50.838	\N
2efd8035-c62e-4e89-8a54-0a9bf0025db0	Sandra	Hernandez Garcia		Jenniffercelisamezcua@gmail.com	+523221027934	1980-11-16 00:00:00		2025-05-03 20:50:50.839	2025-05-03 20:50:50.839	\N
2589bf2f-4e97-41fc-9794-b7c9fc3576e2	Victor	Arciga		\N	8122936467	\N		2025-05-03 20:50:50.839	2025-05-03 20:50:50.839	\N
704b06b1-21c7-4594-ae4e-56fdd7c98aa5	Mariane	Hernandez Hernandez		\N	3123025876	\N		2025-05-03 20:50:50.839	2025-05-03 20:50:50.839	\N
9a31a5d9-87f4-4556-9262-eb129a641f83	Paul	Fowler		\N	+15056039528	\N		2025-05-03 20:50:50.84	2025-05-03 20:50:50.84	\N
dddc6c8c-1175-4b24-9d44-467ece431080	Maria Belem	Gonzalez	Diaz		+523222039013	2005-08-13 00:00:00		2025-05-03 20:50:50.838	2025-05-04 01:03:35.478	\N
5a98a02b-1783-4e5b-8ea9-63f202d62778	Blanca	Morales	Gomez	aa123@gmail.com	+523221356485	1973-07-28 00:00:00		2025-05-06 00:21:29.435	2025-05-06 00:21:29.435	\N
dfd9deeb-c65b-48e2-bb38-3acaaa98301d	Eugenie	Tebe	x	eugenie_tebe@yahoo.fr	+14046685693	\N		2025-05-07 15:37:14.721	2025-05-07 15:37:14.721	\N
5e4fa9bd-8612-4fe4-8488-86a898ae87ce	Eugenie	Tebe	x	eugenie_tebe@yahoo.fr	+1446685693	\N		2025-05-07 15:40:54.855	2025-05-07 15:40:54.855	\N
b7222740-dd9e-43a7-b971-d8851deec0a6	Eugenie	Tebe	x	eugenie_tebe@yahoo.fr	+1446685693	2025-05-07 00:00:00	usa	2025-05-07 15:42:33.231	2025-05-07 15:42:33.231	\N
18dddb87-9220-4dcd-974a-41bb834e7b5b	Veronica	Ulloa 	Ruiz	vernica@gmail.com	+523221597410	2025-05-08 00:00:00		2025-05-08 19:42:30.527	2025-05-08 19:42:30.527	\N
b08bf7a8-0aa1-4d52-9510-72242d4142a2	Fernando	Rodriguez	Vega	anavrcd@hotmail.com	+523221507767	\N	Ave. Manuel Lepe Macedo	2025-05-16 00:16:55.62	2025-05-16 00:16:55.62	\N
\.


--
-- Data for Name: Payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Payment" (id, "patientId", amount, method, status, description, "createdAt", "updatedAt") FROM stdin;
0d3b3343-9b33-48e9-ac5a-f2ccc4bbdea3	f0920fd1-e258-4588-9b07-9e544792ede3	1900	CASH	PENDING	restan 2100	2025-05-06 21:36:20.664	2025-05-06 21:36:20.664
\.


--
-- Data for Name: Permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Permission" (id, name, description, "createdAt", "updatedAt") FROM stdin;
inicio	inicio	Acceso a la página de inicio	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
pacientes	pacientes	Gestión de pacientes	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
citas	citas	Gestión de citas	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
pagos	pagos	Gestión de pagos	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
consentimientos	consentimientos	Gestión de consentimientos	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
servicios	servicios	Gestión de servicios	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
reportes	reportes	Acceso a reportes	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
comunicacion	comunicacion	Gestión de comunicación	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
portal_paciente	portal_paciente	Acceso al portal de pacientes	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
pagos_odontologos	pagos_odontologos	Gestión de pagos a odontólogos	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
configuracion	configuracion	Acceso a la configuración	2025-05-09 23:13:44.849	2025-05-09 23:13:44.849
\.


--
-- Data for Name: Service; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Service" (id, name, type, duration, price, description, "createdAt", "updatedAt", color) FROM stdin;
6a3234a7-ead6-47e6-9dec-b735f92a8f24	Implantología	General	30	0	Implantología	2025-05-03 19:11:57.962	2025-05-03 19:11:57.962	\N
a8f8c773-8f1f-4560-a636-b296fe3bd0fa	Rehabilitación bucal	General	30	0	Rehabilitación bucal	2025-05-03 19:11:57.962	2025-05-03 19:11:57.962	\N
5e677aa9-b50b-4195-a1cb-ffaed39141de	Terapia Láser para manejo del dolor	General	30	0	Terapia Láser para manejo del dolor	2025-05-03 19:11:57.962	2025-05-03 19:11:57.962	\N
78e9336d-706a-4592-a93e-98c4bc5b9775	Aplicación de ácido hialurónico	General	30	0	Aplicación de ácido hialurónico	2025-05-03 19:11:57.962	2025-05-05 13:28:30.247	#610a51
248a1a0d-1d6c-425b-8ef3-98edf8abe025	Aplicación de toxina botulínica (Botox)	General	30	0	Aplicación de toxina botulínica (Botox)	2025-05-03 19:11:57.962	2025-05-05 13:28:37.294	#079759
646ba4cc-2a97-4ffd-987f-c70a8bcefe94	Retratamiento de Conductos	General	30	4800	Retratamiento de Conductos	2025-05-03 19:11:57.962	2025-05-06 21:53:33.18	#30bcdf
5e88ef73-218b-4d28-a9fb-e97d1d1e7376	Consulta en línea	General	30	0	Consulta en línea	2025-05-03 19:11:57.962	2025-05-05 13:28:51.515	#b08e11
38f83905-3a90-4d5b-b3f7-ec5646de6f4f	Consulta mensual de ortodoncia	General	30	800	Consulta mensual de ortodoncia	2025-05-03 19:11:57.962	2025-05-06 21:54:58.975	#00d5ff
2c49f463-d2d1-402c-b947-2773d048cf54	Extracción dental	General	30	0	Extracción dental	2025-05-03 19:11:57.962	2025-05-05 13:29:26.614	#ff5900
15ac41c0-0bd7-4b77-b9b9-5e7ca87c5263	Rehabilitación protésica para implante	General	30	0	Rehabilitación protésica para implante	2025-05-03 19:11:57.962	2025-05-06 00:14:30.293	#0061ff
d606d483-81de-4adc-88ed-0248a307845e	Tratamiento de Endodoncia	General	30	4200	Tratamiento de Endodoncia	2025-05-03 19:11:57.962	2025-05-06 21:32:25.783	#48aaf4
c330366a-91fe-4373-9008-0fb7bc2ee5c8	Toma de impresión dental	General	30	0	Toma de impresión dental	2025-05-03 19:11:57.962	2025-05-06 21:30:45.702	#ece9e9
03d03b88-ef9b-4339-9ca6-394b1b403e85	Corona metal porcelana	General	30	5250	Corona metal porcelana	2025-05-03 19:11:57.962	2025-05-06 21:39:43.792	#fff5f5
e9e71042-0e34-4f10-87c7-f8e1957e70ee	Coronas dentales de zirconio	General	30	7250	Coronas dentales de zirconio	2025-05-03 19:11:57.962	2025-05-06 21:39:57.199	#eae1e1
00f6ec17-8303-457f-8f9d-b5a159d7031e	Guarda oclusal	General	30	1200	Guarda oclusal	2025-05-03 19:11:57.962	2025-05-06 21:40:32.304	#ffffff
a97018a1-609a-4baf-a77c-3dfec05c9163	Limpieza dental	General	30	1050	Limpieza dental	2025-05-03 19:11:57.962	2025-05-06 21:40:59.04	#ffb3d1
55a88233-6967-43f4-8882-76ad44bc72f8	Profilaxis	Preventivo	35	750	Limpieza dental para niños	2025-05-04 01:20:26.281	2025-05-06 21:42:30.947	#77bb41
88e5204f-6490-4030-8962-cee034b92bbc	Aclaramiento dental	General	30	3200	Aclaramiento dental	2025-05-03 19:11:57.962	2025-05-06 21:44:44.995	#d1cb29
5d10eb55-3bee-4f96-870b-0e8d86170a20	Resinas dentales	General	60	1050	Resinas dentales	2025-05-03 19:11:57.962	2025-05-06 21:45:45.674	#38d22d
1a6a7af6-e85c-4f99-90c5-759dacfe8364	Sedación consciente con óxido nitroso	General	45	4500	Sedación consciente con óxido nitroso	2025-05-03 19:11:57.962	2025-05-06 21:47:56.307	#ffffff
302235da-4fad-46ef-8ced-d9f02692ced6	Visita Odontología	General	30	0	Visita Odontología	2025-05-03 19:11:57.962	2025-05-06 21:51:37.983	#ff80d0
cd98c738-b188-4e51-8f1f-65a5c4fa5463	Cirugía del tercer molar	General	30	0	Cirugía del tercer molar	2025-05-03 19:11:57.962	2025-05-06 21:52:20.959	#ff7300
8edeccc7-e4d7-4e14-b3db-4aaccce9c7a9	Prótesis dental fija y removible	General	30	0	Prótesis dental fija y removible	2025-05-03 19:11:57.962	2025-05-06 21:52:40.703	#a59c9c
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, email, password, name, role, "createdAt", "updatedAt", speciality, license, phone, "isActive", "lastNameMaterno", "lastNamePaterno") FROM stdin;
55e7a281-cab1-4155-9db2-71167deeb665	anavrcd@hotmail.com	$2b$10$TJZpnerEDo.IDmg7zkqnVuICBRep5dqtwk93.NMra/qYaXf0X/flu	C.D Ana Isabel	ADMIN	2025-05-03 19:59:41.735	2025-05-09 23:25:07.622	\N	\N	\N	t	Rabasa	Valades
43393c65-c4b1-4b6d-9df1-dcbe568cde72	admin@odontos.com	$2b$10$pVswvK0NisFz5DZcAma7muCV12ncCgTpoTSTjlhcNkXYjTlcG6eFK	Ivan	ADMIN	2025-04-30 19:52:02.296	2025-05-09 23:26:01.978	\N	\N	\N	t	Admin	Anaya
\.


--
-- Data for Name: UserPermission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserPermission" (id, "userId", "permissionId", "createdAt", "updatedAt") FROM stdin;
57bc65b2-8d6b-4e97-84e5-a5505127b960	55e7a281-cab1-4155-9db2-71167deeb665	inicio	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
3da5658b-477c-407f-9dee-7cbc30a01a66	55e7a281-cab1-4155-9db2-71167deeb665	pacientes	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
cecdb434-6451-40cd-a1c3-40c8bcf1775f	55e7a281-cab1-4155-9db2-71167deeb665	citas	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
4ab8948b-bf4f-478a-97f6-0a8f5e428dda	55e7a281-cab1-4155-9db2-71167deeb665	pagos	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
256db404-ae99-4470-a0de-a0954788e3de	55e7a281-cab1-4155-9db2-71167deeb665	consentimientos	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
0d915c72-2d4a-44cc-88e9-2538c958ac55	55e7a281-cab1-4155-9db2-71167deeb665	servicios	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
8ab2c20a-59c4-42f0-9570-62fae89f5aa2	55e7a281-cab1-4155-9db2-71167deeb665	reportes	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
9a6ad916-248f-4951-80ea-5db1bb91db9a	55e7a281-cab1-4155-9db2-71167deeb665	comunicacion	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
26fa6c96-d2c2-41dd-b96c-41c0132da66e	55e7a281-cab1-4155-9db2-71167deeb665	portal_paciente	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
77bbe84c-f32b-4645-a7d5-af9e7c698e9b	55e7a281-cab1-4155-9db2-71167deeb665	pagos_odontologos	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
b07d16da-d2c3-4e3d-8fec-58c287c7ba77	55e7a281-cab1-4155-9db2-71167deeb665	configuracion	2025-05-09 23:25:07.632	2025-05-09 23:25:07.632
8f138dee-fe56-4828-b220-521f504e5efa	43393c65-c4b1-4b6d-9df1-dcbe568cde72	inicio	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
dabbc676-a6f0-4a0f-b4e8-2aeed7210746	43393c65-c4b1-4b6d-9df1-dcbe568cde72	pacientes	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
a88a9e03-43d3-4c89-99e5-2aea4fd4e923	43393c65-c4b1-4b6d-9df1-dcbe568cde72	citas	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
c3b7a964-5237-4fce-b637-18e6daa0d9ff	43393c65-c4b1-4b6d-9df1-dcbe568cde72	pagos	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
f6d8ab84-98d5-4c3b-87c4-6ea6d0f924b2	43393c65-c4b1-4b6d-9df1-dcbe568cde72	consentimientos	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
b4674187-4625-48d5-b7fd-6f3938d23c99	43393c65-c4b1-4b6d-9df1-dcbe568cde72	servicios	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
4d1f197e-4773-4ac2-9e0c-3807e86aeb11	43393c65-c4b1-4b6d-9df1-dcbe568cde72	reportes	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
b6288c4a-bf77-479b-8aa9-d3d76abaf78f	43393c65-c4b1-4b6d-9df1-dcbe568cde72	comunicacion	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
c78b975b-ce5c-4229-a04a-be47e3c71998	43393c65-c4b1-4b6d-9df1-dcbe568cde72	portal_paciente	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
58b8ecbe-3e8e-416f-858d-477287e0098a	43393c65-c4b1-4b6d-9df1-dcbe568cde72	pagos_odontologos	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
481b8215-008f-4f1b-8a5d-1c86ed19ed90	43393c65-c4b1-4b6d-9df1-dcbe568cde72	configuracion	2025-05-09 23:26:01.984	2025-05-09 23:26:01.984
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
2c47fe60-0ca8-4d37-a9fa-e8dbd5b7b0ed	d009879280f64b5e8e031722cc1cb04325e21691d38459d74464194d6726744e	2025-04-30 19:51:56.957439+00	20250430195156_init	\N	\N	2025-04-30 19:51:56.940812+00	1
f0824fa2-9526-4206-8145-8dbf599d7e75	a0a44826e52243617fadc323ccc426c428285748928d69045315538567d830a6	2025-04-30 21:15:57.249687+00	20250430211556_add_clinic_config	\N	\N	2025-04-30 21:15:57.247079+00	1
a521081e-6a02-4f33-a878-de503b1a0030	28a73b57583e80758b32deb6931f79ad87feb81817727f7daa9a75db02177210	2025-05-02 17:25:58.500348+00	20250502172558_add_duration_and_end_date_to_appointment	\N	\N	2025-05-02 17:25:58.498153+00	1
654521a1-1a22-4f80-a8e7-20238dd4d7bd	b7bc6a39fdceffc34b9f12ca1e142343ad15b6cff314426f20e1ef8905c69f62	2025-05-03 02:42:13.996979+00	20250503024213_patient_without_user_required	\N	\N	2025-05-03 02:42:13.995801+00	1
44bf1faf-9b2c-49f2-848a-d3edc8cb690f	80ac2740ece7ac674dc83d5550e20434d3350f022133c5549b9059870ca0d42c	2025-05-03 18:58:31.282156+00	20250503185830_add_service_model	\N	\N	2025-05-03 18:58:31.277114+00	1
121743d1-b888-44b7-94ee-19be09ec93d7	58112a80ddfa154a8dbc691470ffd5bb070e6d3a86a47fad0240f03e9a90c2a1	2025-05-03 19:50:09.671703+00	20250503195009_add_user_apellidos	\N	\N	2025-05-03 19:50:09.669956+00	1
fde17a8c-79d7-4036-8763-8a4605c8aec1	220e4b0ebeea2ea3a9aa1b0513464c7aec9b1737dbec385ce2da71cfe896d786	2025-05-03 20:19:41.846949+00	20250503201941_add_dentist_payment	\N	\N	2025-05-03 20:19:41.843378+00	1
768d215e-25cf-4c75-a940-7c76d8105e3c	8269c216caebb351d345f0e448a12fe86098b874b5926c7d14213e4554202e32	2025-05-03 21:04:21.969151+00	20250503210421_add_campos_historial_clinico	\N	\N	2025-05-03 21:04:21.965546+00	1
0f2cb58e-fd9a-42d1-aa7c-bf5705f8a17b	213f86e1d9b63115e2158438ac4b509d8dc7a95ebdef7f0450370dcab4bc2697	2025-05-03 21:51:42.172775+00	20250503215141_add_campos_historial_clinico	\N	\N	2025-05-03 21:51:42.168574+00	1
ffe96983-10ce-49f3-887b-10c1a0465b13	59f3b000ae5e28844425e725f99fdea9f5d8708df31a9c67600c6005e2c2b10a	2025-05-03 22:42:29.211214+00	20250503224228_add_service_to_appointment	\N	\N	2025-05-03 22:42:29.207564+00	1
59dc6af3-e79a-4700-a7bb-39a207f9d222	a459f8d775ec70ad3013a225b4bfd85fb1a7bb0300aa0f351b5334f434c5c874	2025-05-03 22:51:48.580016+00	20250503225148_remove_assigned_schedules_from_service	\N	\N	2025-05-03 22:51:48.578143+00	1
1f210499-0399-4b3d-a1eb-3094322b0852	99b38bd5e82df7f1db2f9127454ac888841d61a4e0ca59929197d6bf2a1b35bb	2025-05-04 01:23:47.114409+00	20250504012346_add_color_to_service	\N	\N	2025-05-04 01:23:47.112305+00	1
16de37cc-7c34-499f-90c6-f9a870addb98	e53412abdd475e36566c6c3c62265ab742c2c631c816d6e1274a4c4e68b9f2b2	2025-05-09 23:13:45.387954+00	20250508230246_add_permissions	\N	\N	2025-05-09 23:13:43.842201+00	1
07488fd4-efa1-45b4-9b4c-d903568a69f3	4eb9afa75ad19e51a66ffea8b10e09370d37efa8326c611f7a96d835fe4afc2b	2025-05-09 23:13:45.400005+00	20250508230247_add_new_permissions	\N	\N	2025-05-09 23:13:45.390904+00	1
e7803743-fe7a-44bd-bca4-2ac01784a52a	cb24396fdca1440869a8efb425625e86ca3a8b9d639bc20217f5786cf30f5003	\N	20250508230248_add_permissions_and_roles	A migration failed to apply. New migrations cannot be applied before the error is recovered from. Read more about how to resolve migration issues in a production database: https://pris.ly/d/migrate-resolve\n\nMigration name: 20250508230248_add_permissions_and_roles\n\nDatabase error code: 42710\n\nDatabase error:\nERROR: constraint "UserPermission_userId_fkey" for relation "UserPermission" already exists\n\nDbError { severity: "ERROR", parsed_severity: Some(Error), code: SqlState(E42710), message: "constraint \\"UserPermission_userId_fkey\\" for relation \\"UserPermission\\" already exists", detail: None, hint: None, position: None, where_: None, schema: None, table: None, column: None, datatype: None, constraint: None, file: Some("tablecmds.c"), line: Some(8978), routine: Some("ATExecAddConstraint") }\n\n   0: sql_schema_connector::apply_migration::apply_script\n           with migration_name="20250508230248_add_permissions_and_roles"\n             at schema-engine/connectors/sql-schema-connector/src/apply_migration.rs:113\n   1: schema_commands::commands::apply_migrations::Applying migration\n           with migration_name="20250508230248_add_permissions_and_roles"\n             at schema-engine/commands/src/commands/apply_migrations.rs:91\n   2: schema_core::state::ApplyMigrations\n             at schema-engine/core/src/state.rs:225	\N	2025-05-09 23:13:45.403149+00	0
\.


--
-- Data for Name: odontogram; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.odontogram (id, "patientId", data, "updatedAt", "createdAt") FROM stdin;
b85d0261-0f3a-4fe5-9627-4c16210ffff8	e2b4cfb8-307c-42d8-869a-412583f4d6d2	{"11": {"note": "", "state": ""}, "12": {"note": "", "state": ""}, "13": {"note": "", "state": ""}, "14": {"note": "", "state": ""}, "15": {"note": "", "state": ""}, "16": {"note": "", "state": ""}, "17": {"note": "", "state": ""}, "18": {"note": "", "state": ""}, "21": {"note": "", "state": ""}, "22": {"note": "", "state": ""}, "23": {"note": "", "state": ""}, "24": {"note": "", "state": "sano"}, "25": {"note": "", "state": "sano"}, "26": {"note": "", "state": "sano"}, "27": {"note": "", "state": ""}, "28": {"note": "", "state": ""}, "31": {"note": "", "state": ""}, "32": {"note": "", "state": ""}, "33": {"note": "", "state": ""}, "34": {"note": "", "state": ""}, "35": {"note": "", "state": ""}, "36": {"note": "", "state": ""}, "37": {"note": "", "state": ""}, "38": {"note": "", "state": ""}, "41": {"note": "", "state": ""}, "42": {"note": "", "state": ""}, "43": {"note": "", "state": ""}, "44": {"note": "", "state": ""}, "45": {"note": "", "state": ""}, "46": {"note": "", "state": ""}, "47": {"note": "", "state": ""}, "48": {"note": "", "state": ""}, "51": {"note": "", "state": ""}, "52": {"note": "", "state": ""}, "53": {"note": "", "state": ""}, "54": {"note": "", "state": ""}, "55": {"note": "", "state": ""}, "61": {"note": "", "state": ""}, "62": {"note": "", "state": ""}, "63": {"note": "", "state": ""}, "64": {"note": "", "state": ""}, "65": {"note": "", "state": ""}, "71": {"note": "", "state": ""}, "72": {"note": "", "state": ""}, "73": {"note": "", "state": ""}, "74": {"note": "", "state": ""}, "75": {"note": "", "state": ""}, "81": {"note": "", "state": ""}, "82": {"note": "", "state": ""}, "83": {"note": "", "state": ""}, "84": {"note": "", "state": ""}, "85": {"note": "", "state": ""}}	2025-05-06 00:51:18.818	2025-05-03 22:25:59.899
\.


--
-- Name: Appointment Appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointment"
    ADD CONSTRAINT "Appointment_pkey" PRIMARY KEY (id);


--
-- Name: ClinicConfig ClinicConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ClinicConfig"
    ADD CONSTRAINT "ClinicConfig_pkey" PRIMARY KEY (id);


--
-- Name: Consultation Consultation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Consultation"
    ADD CONSTRAINT "Consultation_pkey" PRIMARY KEY (id);


--
-- Name: DentistPayment DentistPayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DentistPayment"
    ADD CONSTRAINT "DentistPayment_pkey" PRIMARY KEY (id);


--
-- Name: DentistSchedule DentistSchedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DentistSchedule"
    ADD CONSTRAINT "DentistSchedule_pkey" PRIMARY KEY (id);


--
-- Name: MedicalHistory MedicalHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MedicalHistory"
    ADD CONSTRAINT "MedicalHistory_pkey" PRIMARY KEY (id);


--
-- Name: Patient Patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Patient"
    ADD CONSTRAINT "Patient_pkey" PRIMARY KEY (id);


--
-- Name: Payment Payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_pkey" PRIMARY KEY (id);


--
-- Name: Permission Permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Permission"
    ADD CONSTRAINT "Permission_pkey" PRIMARY KEY (id);


--
-- Name: Service Service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Service"
    ADD CONSTRAINT "Service_pkey" PRIMARY KEY (id);


--
-- Name: UserPermission UserPermission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPermission"
    ADD CONSTRAINT "UserPermission_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: odontogram odontogram_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odontogram
    ADD CONSTRAINT odontogram_pkey PRIMARY KEY (id);


--
-- Name: DentistSchedule_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "DentistSchedule_userId_key" ON public."DentistSchedule" USING btree ("userId");


--
-- Name: MedicalHistory_patientId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "MedicalHistory_patientId_key" ON public."MedicalHistory" USING btree ("patientId");


--
-- Name: Patient_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Patient_userId_key" ON public."Patient" USING btree ("userId");


--
-- Name: Permission_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Permission_name_key" ON public."Permission" USING btree (name);


--
-- Name: UserPermission_userId_permissionId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UserPermission_userId_permissionId_key" ON public."UserPermission" USING btree ("userId", "permissionId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: odontogram_patientId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "odontogram_patientId_key" ON public.odontogram USING btree ("patientId");


--
-- Name: Appointment Appointment_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointment"
    ADD CONSTRAINT "Appointment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public."Patient"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Appointment Appointment_serviceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointment"
    ADD CONSTRAINT "Appointment_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES public."Service"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Appointment Appointment_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointment"
    ADD CONSTRAINT "Appointment_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Consultation Consultation_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Consultation"
    ADD CONSTRAINT "Consultation_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public."Patient"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DentistPayment DentistPayment_dentistId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DentistPayment"
    ADD CONSTRAINT "DentistPayment_dentistId_fkey" FOREIGN KEY ("dentistId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DentistSchedule DentistSchedule_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DentistSchedule"
    ADD CONSTRAINT "DentistSchedule_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: MedicalHistory MedicalHistory_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MedicalHistory"
    ADD CONSTRAINT "MedicalHistory_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public."Patient"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Patient Patient_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Patient"
    ADD CONSTRAINT "Patient_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Payment Payment_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public."Patient"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: UserPermission UserPermission_permissionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPermission"
    ADD CONSTRAINT "UserPermission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES public."Permission"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserPermission UserPermission_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPermission"
    ADD CONSTRAINT "UserPermission_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: odontogram odontogram_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odontogram
    ADD CONSTRAINT "odontogram_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public."Patient"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

