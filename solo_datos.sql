SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict O7kEeGYB7ewUKJgm9GteobZhNLwvSsyeqg41ZEiFkylxTLoFWRfMAdYscsTrtHj

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', 'e0526546-2790-407a-b41c-14f910cb7ed9', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"adminmerca@plazamayor.com","user_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","user_phone":""}}', '2026-01-15 10:11:21.993777+00', ''),
	('00000000-0000-0000-0000-000000000000', '898772eb-eace-4528-8677-107b0dea09ab', '{"action":"login","actor_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","actor_username":"adminmerca@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-15 10:33:52.787444+00', ''),
	('00000000-0000-0000-0000-000000000000', '50ef47f3-a9dc-4486-8c69-d0ac2920b0fb', '{"action":"login","actor_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","actor_username":"adminmerca@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-15 10:34:01.70197+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a8887005-fa1d-4361-bba2-f1ef170c031c', '{"action":"logout","actor_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","actor_username":"adminmerca@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-15 11:02:40.95161+00', ''),
	('00000000-0000-0000-0000-000000000000', '995605cf-3c17-4f51-867f-760093ca8c83', '{"action":"login","actor_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","actor_username":"adminmerca@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-15 11:02:51.787215+00', ''),
	('00000000-0000-0000-0000-000000000000', '5af10039-dd14-4212-a95a-c0707bc9eac8', '{"action":"token_refreshed","actor_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","actor_username":"adminmerca@plazamayor.com","actor_via_sso":false,"log_type":"token"}', '2026-01-15 12:11:48.566719+00', ''),
	('00000000-0000-0000-0000-000000000000', '23246129-c8bd-45c9-9f26-5da430db1674', '{"action":"token_revoked","actor_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","actor_username":"adminmerca@plazamayor.com","actor_via_sso":false,"log_type":"token"}', '2026-01-15 12:11:48.568374+00', ''),
	('00000000-0000-0000-0000-000000000000', '0b5428d7-3173-447d-aba0-fd5f9dc120b3', '{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"adminmerca@plazamayor.com","user_id":"ee05ac63-b882-4baa-abd1-be9ce776a073","user_phone":""}}', '2026-01-24 13:06:27.738009+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ef4ce632-d596-41f0-8435-da69cba5cf05', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin@cotizador.com","user_id":"724828da-3326-4570-ab45-d7215e51fbc2","user_phone":""}}', '2026-01-24 13:06:44.276909+00', ''),
	('00000000-0000-0000-0000-000000000000', '706a4b01-3d59-4d16-8bce-de9705b6fa91', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-24 13:07:42.315598+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ffd111c1-c035-452a-a244-77fbcb42199a', '{"action":"token_refreshed","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-01-25 09:53:19.389978+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dd63527e-b43d-4681-a658-18d8cbeb7c41', '{"action":"token_revoked","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-01-25 09:53:19.392128+00', ''),
	('00000000-0000-0000-0000-000000000000', '158fec5c-13e7-4952-a923-29382cfc1460', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 10:03:58.520825+00', ''),
	('00000000-0000-0000-0000-000000000000', '91e68028-f687-4bb8-aaf4-0cc7eafa1742', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin@casadepiedra.com","user_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","user_phone":""}}', '2026-01-25 10:50:59.64583+00', ''),
	('00000000-0000-0000-0000-000000000000', '8d0d10bb-8140-444f-b918-987a5dc29873', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin@plazamayor.com","user_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","user_phone":""}}', '2026-01-25 10:51:16.04315+00', ''),
	('00000000-0000-0000-0000-000000000000', '6f922812-1ae7-4e8a-88df-7c59be2dc1cb', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 10:53:16.156506+00', ''),
	('00000000-0000-0000-0000-000000000000', '48cfb5dd-1009-4ce2-8a3f-891bd51e3f52', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 10:53:26.743943+00', ''),
	('00000000-0000-0000-0000-000000000000', '53ae1fb3-a6dc-4f85-9f32-52edd06e2f74', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 10:54:00.846418+00', ''),
	('00000000-0000-0000-0000-000000000000', '2cec6020-d853-46f7-951d-ff61e05e9136', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 10:54:14.926332+00', ''),
	('00000000-0000-0000-0000-000000000000', '4c69b50a-bd8c-44e4-b411-e9a6c689cc79', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 11:34:00.433541+00', ''),
	('00000000-0000-0000-0000-000000000000', '2cc25e65-f9b1-41da-8f6c-91c4139d7c36', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 11:34:14.999562+00', ''),
	('00000000-0000-0000-0000-000000000000', '4b9cbb87-394e-495f-ac4e-eb700e1c0c70', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 11:39:59.65106+00', ''),
	('00000000-0000-0000-0000-000000000000', '87c81b6c-87f5-4c8e-9e63-30885e489c02', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 11:40:09.885846+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e5362f30-ad38-4528-a117-cf51f14cad51', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 11:40:27.208328+00', ''),
	('00000000-0000-0000-0000-000000000000', 'aec63992-2dfb-4e5d-8a4c-961141a210b1', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 11:40:41.262941+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a82bc792-c7a9-4c87-a46f-9ee766daf05c', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 11:54:33.07075+00', ''),
	('00000000-0000-0000-0000-000000000000', '3c264db5-6565-4baa-b44c-1e031d2c3e28', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 11:56:52.798023+00', ''),
	('00000000-0000-0000-0000-000000000000', '9e7685b7-6ed5-4438-8527-50250a1131db', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 11:57:02.659818+00', ''),
	('00000000-0000-0000-0000-000000000000', '602d1419-c394-4151-a5ee-d605b5313fc2', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 11:57:11.201019+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e20e3bc0-e651-4867-8951-b6df53774af8', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:02:11.926135+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd35e7e18-978a-45d7-a419-0b985d616421', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:02:18.665696+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e237b062-b93f-402f-a0a0-dc4fc89052d5', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:02:27.966476+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b31e0d91-03ad-4045-8d51-fcf40a23d275', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:24:38.409974+00', ''),
	('00000000-0000-0000-0000-000000000000', '557cbc79-b5b8-456d-9916-2eac9033ab9f', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:24:49.006622+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd95e4fd3-a274-42b0-9f0c-e9e03368e4ff', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:25:22.052716+00', ''),
	('00000000-0000-0000-0000-000000000000', 'be175f2a-6804-465a-95d5-3f80f6a98f23', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:25:45.993364+00', ''),
	('00000000-0000-0000-0000-000000000000', '6ca39bbc-42df-4ddd-acee-6f20df2b81ff', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:25:57.740791+00', ''),
	('00000000-0000-0000-0000-000000000000', '63100c18-2311-4315-b86d-d038eddd70bb', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:26:21.246237+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b4ce08b7-059d-4771-9cdd-72917a0765c4', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:27:29.789351+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f8bd6fdf-a058-42fa-83ce-912e03e79da4', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:29:38.497633+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dc5f8e38-6f47-4d7e-812c-0d219db2cc72', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:29:47.727991+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b12321ff-bfd4-473d-92d6-f9120893f90b', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:29:58.266471+00', ''),
	('00000000-0000-0000-0000-000000000000', '3beba0ad-f45d-49ed-84c4-7db3f7b92a33', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:30:06.339605+00', ''),
	('00000000-0000-0000-0000-000000000000', '4ee3a5f0-79dd-4b6d-86bb-61d632d6d7df', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:30:24.105973+00', ''),
	('00000000-0000-0000-0000-000000000000', 'df488bf8-79db-4587-ba18-3d961908c284', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:30:36.566261+00', ''),
	('00000000-0000-0000-0000-000000000000', '336a0d05-211e-49ea-af96-68e14ac1c032', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:35:16.248539+00', ''),
	('00000000-0000-0000-0000-000000000000', '585eaaee-1db0-47e6-aa6d-add8f855f31c', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:35:28.743209+00', ''),
	('00000000-0000-0000-0000-000000000000', '57f6dae3-8c89-4205-b0f9-e3fedd1225ad', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:46:15.181099+00', ''),
	('00000000-0000-0000-0000-000000000000', '4dd4f0a1-695d-4cfc-a451-a0f50a6a0b90', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:46:24.313455+00', ''),
	('00000000-0000-0000-0000-000000000000', '8822e98c-1f76-4527-8819-554d77ac0616', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:47:11.295449+00', ''),
	('00000000-0000-0000-0000-000000000000', '86342769-a24d-49c9-8ff1-a31fc16bfaa5', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:47:17.931426+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dab1df11-5f24-49c6-be16-00361eb9ea57', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 12:47:52.119696+00', ''),
	('00000000-0000-0000-0000-000000000000', '50b01acf-3eef-4d22-be54-e10c906f5714', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:48:04.885617+00', ''),
	('00000000-0000-0000-0000-000000000000', '13bd22b6-23f4-4814-b316-344389a90e33', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 12:51:55.068482+00', ''),
	('00000000-0000-0000-0000-000000000000', '6d74b88b-6773-4084-bb92-d1abd1a4f466', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 13:11:52.34336+00', ''),
	('00000000-0000-0000-0000-000000000000', '81d29007-5846-4a62-b90f-89ff9c7f4ac5', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 13:12:00.054038+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd116c0dc-df38-4ac5-97d0-daae5c12862d', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 13:12:08.234927+00', ''),
	('00000000-0000-0000-0000-000000000000', '88d15781-9dbc-4af5-a9ed-9fdc3e4a5454', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 13:14:00.289856+00', ''),
	('00000000-0000-0000-0000-000000000000', '3a5eebdc-c00b-4265-bf20-0df791f493f7', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 13:14:10.066599+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dc2ca42b-bc40-452f-917c-b9b139db8a1e', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 13:22:41.462065+00', ''),
	('00000000-0000-0000-0000-000000000000', '57f3b70e-74da-47f3-b7d8-940da45b0e7d', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 13:22:57.571841+00', ''),
	('00000000-0000-0000-0000-000000000000', '46dcf084-8d75-43e3-a06b-0107b7ecf0c1', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-25 13:31:40.700635+00', ''),
	('00000000-0000-0000-0000-000000000000', '7c3b0ea4-d495-4b14-8912-d676f038afb1', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-25 13:31:51.821314+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cd1bce52-e2e9-46ed-b5c7-ea354fbd941f', '{"action":"token_refreshed","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"token"}', '2026-01-26 21:41:23.238056+00', ''),
	('00000000-0000-0000-0000-000000000000', '3e23b7b1-aaeb-4926-a06f-2ed7c71d39eb', '{"action":"token_revoked","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"token"}', '2026-01-26 21:41:23.239952+00', ''),
	('00000000-0000-0000-0000-000000000000', '76bb3545-d3cf-4e09-b042-966eac01662e', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-26 21:41:38.766603+00', ''),
	('00000000-0000-0000-0000-000000000000', '215bedfb-312f-48a0-b33a-323a5faa0a5b', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-26 21:42:40.474882+00', ''),
	('00000000-0000-0000-0000-000000000000', '1ce0c437-fa09-469c-9fb2-65f298e5a35e', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-26 22:03:14.336387+00', ''),
	('00000000-0000-0000-0000-000000000000', '13b377f5-b196-49bf-9200-065e438676ef', '{"action":"token_refreshed","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-01-26 23:24:20.576878+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a4cc20de-a803-48a9-a415-b6bb1d2f8db6', '{"action":"token_revoked","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-01-26 23:24:20.577949+00', ''),
	('00000000-0000-0000-0000-000000000000', 'bb27718c-f064-41e2-90da-d1ab71b9d684', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-26 23:36:46.675098+00', ''),
	('00000000-0000-0000-0000-000000000000', '007178d8-653d-4ed9-a0c2-fde23af42a2a', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-26 23:37:02.453333+00', ''),
	('00000000-0000-0000-0000-000000000000', '923b4f30-7263-4dfa-89aa-93a0c65810ff', '{"action":"token_refreshed","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-01-27 03:47:56.158028+00', ''),
	('00000000-0000-0000-0000-000000000000', '16e47484-70f6-495b-a303-9cee882216c7', '{"action":"token_revoked","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-01-27 03:47:56.158787+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f8f2739c-5ccf-48a2-8951-64c2f7f50db9', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:04:52.915519+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd7a16adc-626d-47a3-ae98-4c36b8b07742', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:05:06.309038+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ad713ac7-497e-4d3b-a98e-4ae4a1c6613f', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:09:04.451545+00', ''),
	('00000000-0000-0000-0000-000000000000', '428a6d32-0354-4d4e-876b-66abca58194c', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:09:15.438689+00', ''),
	('00000000-0000-0000-0000-000000000000', '2439a876-5eaf-4325-8a59-9ba6c59c97d3', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:32:29.877539+00', ''),
	('00000000-0000-0000-0000-000000000000', '37b0cc87-3d93-4c1d-ace5-737a9f33171e', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:32:33.162528+00', ''),
	('00000000-0000-0000-0000-000000000000', '3cee58c2-9238-41d0-a276-b16a0332ff47', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:37:14.423953+00', ''),
	('00000000-0000-0000-0000-000000000000', '91eb48aa-c800-43d3-beb8-8a04f28f3024', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:37:18.349271+00', ''),
	('00000000-0000-0000-0000-000000000000', '67ad8229-cdd9-4671-ade7-66a28f07e74b', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:37:22.206083+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd96d3d10-3ae9-494e-8d75-3c3c24428a00', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:37:24.283282+00', ''),
	('00000000-0000-0000-0000-000000000000', '4b8d0851-e1c8-4175-a15a-fbd552538ee0', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:40:29.004178+00', ''),
	('00000000-0000-0000-0000-000000000000', '50f2b611-9326-4643-9fe6-3600807166f9', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:40:31.10328+00', ''),
	('00000000-0000-0000-0000-000000000000', '46724792-7bcd-493f-8f0d-cfb3d3262c8d', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 04:45:19.733358+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a3baab3f-32db-4ac2-ac77-22ec41f35472', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 04:45:22.934125+00', ''),
	('00000000-0000-0000-0000-000000000000', '69779712-85cb-441a-930b-e8eaed547ea7', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:15:31.138058+00', ''),
	('00000000-0000-0000-0000-000000000000', 'feab6359-6d38-4d43-a438-211061d8827c', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:15:38.195132+00', ''),
	('00000000-0000-0000-0000-000000000000', '7f4552cf-ec18-4b34-8fd4-ba4f4063fae9', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:17:10.803003+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e543f18f-3d21-4818-a027-35a586d7a973', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:17:13.670195+00', ''),
	('00000000-0000-0000-0000-000000000000', '17e5155d-1c4f-434e-beb9-efcb123ffd72', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:17:32.192359+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f0be77ed-5a14-45d9-b5c9-940796353938', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:17:33.827302+00', ''),
	('00000000-0000-0000-0000-000000000000', 'aa2c117e-63ef-4aab-82c1-6387be2b419d', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:19:35.822669+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fbd9da70-06c4-4119-b3bf-f734626c79c3', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:19:48.857913+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e1dd99d1-4667-46ff-9425-48562ff06986', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:20:05.425796+00', ''),
	('00000000-0000-0000-0000-000000000000', '2c7a0e3a-1681-44fd-81bc-4e66ff7e5530', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:20:08.713148+00', ''),
	('00000000-0000-0000-0000-000000000000', 'aa4dd3a2-240e-4547-a436-bb504cc77f91', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:41:15.878762+00', ''),
	('00000000-0000-0000-0000-000000000000', '68d2ab67-bb07-4f7f-b9e3-6ab589b88032', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:41:29.484919+00', ''),
	('00000000-0000-0000-0000-000000000000', '0e3f2cdc-b8b7-42aa-b429-5a137d867d47', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 05:43:09.588975+00', ''),
	('00000000-0000-0000-0000-000000000000', '0817034d-7ea8-48b9-9436-68b8e6b260e8', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 05:43:12.673461+00', ''),
	('00000000-0000-0000-0000-000000000000', 'dfb91e94-1fa2-46c2-b0d6-37f7377fe1db', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 06:09:32.831941+00', ''),
	('00000000-0000-0000-0000-000000000000', '02869672-da24-4fa3-8c20-08adcffa57c9', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 06:09:35.060201+00', ''),
	('00000000-0000-0000-0000-000000000000', '1a7e0842-1d13-49f4-8919-dc1f82a16744', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 06:18:53.460911+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a330e2d5-4c86-4fcb-85f7-4aedcc242f69', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 06:28:39.21261+00', ''),
	('00000000-0000-0000-0000-000000000000', '9c5359ca-493c-4888-aa83-5a1b99aa168c', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 06:29:00.283795+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b5062e86-386c-4596-aa43-4c138b029a74', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 06:51:20.821614+00', ''),
	('00000000-0000-0000-0000-000000000000', '834995db-b5e3-4665-985b-d456104967b6', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 06:51:25.13408+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ffa72e9d-35be-4af2-9ab6-a1d05b36ef40', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 06:59:23.676802+00', ''),
	('00000000-0000-0000-0000-000000000000', '5264ab55-ec9e-4fe1-b0b6-c4359acbf6c6', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 06:59:27.354869+00', ''),
	('00000000-0000-0000-0000-000000000000', '5e29f060-f22a-4423-9094-6ca454e4fdf0', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 07:04:47.808938+00', ''),
	('00000000-0000-0000-0000-000000000000', '3f3e74d9-913b-41c1-86ce-b6a4c34c0867', '{"action":"login","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 07:04:54.112364+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ff6d0b50-b8cf-4268-ac14-28176575e048', '{"action":"logout","actor_id":"ff511a68-a84f-48cf-8227-0669e60d2b9f","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 07:17:49.357494+00', ''),
	('00000000-0000-0000-0000-000000000000', '25d6a3e2-6f89-4903-8a76-083e67e2a6c5', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 07:17:54.424588+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f142d5ab-dc59-4db3-9968-7df75f24007c', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 07:18:27.475501+00', ''),
	('00000000-0000-0000-0000-000000000000', '7ccd4c59-3053-40b8-b651-177a78716638', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 07:18:30.80485+00', ''),
	('00000000-0000-0000-0000-000000000000', '42dd0cdd-ee39-4b12-80c6-3dc04605645c', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 07:26:00.245326+00', ''),
	('00000000-0000-0000-0000-000000000000', '0e42b9f1-8f05-468a-ba58-86a3e1ce0c6b', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 07:26:03.187367+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f550aa3f-eb50-4600-a900-f956a0fb96e7', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 07:26:05.701242+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ecdcd6d7-c8ef-4f40-8ed5-a0f08f4928e6', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 07:26:08.613701+00', ''),
	('00000000-0000-0000-0000-000000000000', '01d0695f-2c69-4d74-941c-fcff7d70a8fc', '{"action":"token_refreshed","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"token"}', '2026-01-27 22:32:35.304977+00', ''),
	('00000000-0000-0000-0000-000000000000', '344ef3fc-5dfd-44c6-b7e9-a3b36ca2b792', '{"action":"token_revoked","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"token"}', '2026-01-27 22:32:35.30627+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f21d2c1f-b87f-46fe-bc65-78cc5ffd1426', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 22:32:37.853268+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a106743e-df86-4371-8eff-d8a451db2f87', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 22:32:43.603892+00', ''),
	('00000000-0000-0000-0000-000000000000', '9e5199c4-90c9-42ec-8d16-bc8f981b9256', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 22:39:38.660667+00', ''),
	('00000000-0000-0000-0000-000000000000', '7ff51d35-cca6-4092-9f3e-1a89c1cc5ed9', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 22:39:40.652179+00', ''),
	('00000000-0000-0000-0000-000000000000', '52498a32-d9b8-445a-84a1-66d392c20c1c', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 22:41:35.072879+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b9fb7e01-1b53-4f72-b76d-6c8759870114', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 22:43:51.664148+00', ''),
	('00000000-0000-0000-0000-000000000000', '1e1cdf95-f56c-4679-8122-7ce6b7f62ce8', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 22:44:52.844577+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a0d7d556-fab2-4b55-b412-d17b13c5ac45', '{"action":"login","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 22:45:21.535472+00', ''),
	('00000000-0000-0000-0000-000000000000', '0bfeec56-0207-4eed-8468-b6c9c71e5187', '{"action":"logout","actor_id":"724828da-3326-4570-ab45-d7215e51fbc2","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 22:45:32.976895+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b4b7fde4-9cad-4596-bb94-35dad3db198a', '{"action":"login","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-01-27 22:45:37.053642+00', ''),
	('00000000-0000-0000-0000-000000000000', '2939cdda-867d-45b7-83ec-3f628f098d78', '{"action":"logout","actor_id":"5c1674bb-74fc-43b4-b81a-38cfa32e0ba3","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-01-27 22:45:49.2715+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', 'authenticated', 'authenticated', 'admin@casadepiedra.com', '$2a$10$n0XJomuGmAgG15fMlB5tcOHCfCRr4.rX9CNzLwpdwoMAGpgEinowe', '2026-01-25 10:50:59.647447+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-01-27 22:45:37.054436+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-01-25 10:50:59.639912+00', '2026-01-27 22:45:37.05633+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'ff511a68-a84f-48cf-8227-0669e60d2b9f', 'authenticated', 'authenticated', 'admin@plazamayor.com', '$2a$10$29CUQTv6vazbw0IwOBk6oOXL3sXLwSnb19trYLCpU/N6kMWbPqqEW', '2026-01-25 10:51:16.044378+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-01-27 07:04:54.113302+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-01-25 10:51:16.040431+00', '2026-01-27 07:04:54.115885+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '724828da-3326-4570-ab45-d7215e51fbc2', 'authenticated', 'authenticated', 'admin@cotizador.com', '$2a$10$LK44eQ5SPj8KmPpeiMdMZOS.fKSeek0xfvmgCvQd8PRiGmBrSVWye', '2026-01-24 13:06:44.277819+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-01-27 22:45:21.536326+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-01-24 13:06:44.273404+00', '2026-01-27 22:45:21.538358+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('724828da-3326-4570-ab45-d7215e51fbc2', '724828da-3326-4570-ab45-d7215e51fbc2', '{"sub": "724828da-3326-4570-ab45-d7215e51fbc2", "email": "admin@cotizador.com", "email_verified": false, "phone_verified": false}', 'email', '2026-01-24 13:06:44.276198+00', '2026-01-24 13:06:44.276223+00', '2026-01-24 13:06:44.276223+00', '25769ae8-83c1-4a70-8aa7-16e7bb7d755e'),
	('5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', '{"sub": "5c1674bb-74fc-43b4-b81a-38cfa32e0ba3", "email": "admin@casadepiedra.com", "email_verified": false, "phone_verified": false}', 'email', '2026-01-25 10:50:59.644883+00', '2026-01-25 10:50:59.64491+00', '2026-01-25 10:50:59.64491+00', '487af1ac-8c2e-494b-966c-2e326c04ec16'),
	('ff511a68-a84f-48cf-8227-0669e60d2b9f', 'ff511a68-a84f-48cf-8227-0669e60d2b9f', '{"sub": "ff511a68-a84f-48cf-8227-0669e60d2b9f", "email": "admin@plazamayor.com", "email_verified": false, "phone_verified": false}', 'email', '2026-01-25 10:51:16.042515+00', '2026-01-25 10:51:16.042538+00', '2026-01-25 10:51:16.042538+00', '86347fca-9539-44b9-b1ac-b3b09af09811');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: clientes; Type: TABLE DATA; Schema: finanzas; Owner: supabase_admin
--

INSERT INTO "finanzas"."clientes" ("id", "nombre_completo", "telefono", "correo", "rfc", "created_at", "updated_at") VALUES
	('2997e5c2-62c3-40ec-8c1f-1da0c20380ae', 'Johan Jacob Paz Valadez', '4771631661', 'johan_paz@hotmail.es', 'PAVJ011113PB6', '2026-01-26 23:37:50.548335+00', '2026-01-26 23:37:50.548335+00');


--
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas; Owner: supabase_admin
--

INSERT INTO "finanzas"."conceptos_catalogo" ("id", "nombre", "precio_sugerido", "activo", "created_at") VALUES
	(2, 'Modificación manual', 0, true, '2025-12-19 08:30:52.173681+00'),
	(1, 'Limpieza', 0, true, '2025-12-19 08:29:59.031025+00'),
	(3, 'Mobiliario', 0, true, '2025-12-19 08:30:57.056834+00'),
	(5, 'Instalación', 0, true, '2025-12-19 08:36:01.791921+00'),
	(4, 'Seguridad', 500, true, '2025-12-19 08:31:41.47937+00');


--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas; Owner: supabase_admin
--

INSERT INTO "finanzas"."espacios" ("id", "created_at", "clave", "nombre", "tipo", "descripcion", "requisitos", "imagen_url", "activo", "precio_base", "ajuste_tipo", "ajuste_porcentaje", "activa", "impuestos_ids", "color") VALUES
	(20, '2025-12-20 07:39:01.375808+00', 'Z6-1', 'Cristales laterales de escaleras Banana Republic', 'publicidad', 'Ubicación: Zona 6 en el pasillo principal frente a Banana Republic, Stradivarius, etc.
Material: Autoadherible', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216659300_imagen20251220014417844png', true, 45000, 'ninguno', 0, true, '[1]', '#ff2600'),
	(9, '2025-12-20 07:08:59.400205+00', 'Z1-9', 'Muro espectacular entre Zara y Massimo Dutti', 'publicidad', 'Ubicación: En zona 3, frente a Sears, de cara al domo principal
Medidas: 13.0m x 3.0m
Materiales: Vinil sobre bastidor', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766214856684_imagen20251220011415040png', true, 50000, 'ninguno', 0, true, '[1]', '#ff0000'),
	(19, '2025-12-20 07:36:54.875585+00', 'Z5-2', 'Elevador panorámico', 'publicidad', 'Ubicación: en zona 5 frente al acceso del pórtico 4 y acceso a segunda planta hacia Cinemex.
Medidas: 2.14m x 9.77m
Material: Vinil autoadherible.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216533024_imagen20251220014212080png', true, 45000, 'ninguno', 0, true, '[1]', '#cf7207'),
	(18, '2025-12-20 07:34:54.80137+00', 'Z4-3', 'Cristal superior zona de cajeros', 'publicidad', 'Ubicación: en zona 6, frente a H&M de cara a explanada de fuente y diversas islas. ', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216412874_imagen20251220014009864png', true, 30000, 'ninguno', 0, true, '[1]', '#58c80e'),
	(12, '2025-12-20 07:23:15.460771+00', 'Z3-6', 'Paquete de 10 pendones interiores', 'publicidad', 'Ubicación: en los principales pasillos de zona 3, visibles desde primer y segundo piso.
Medidas: 70cmx500cm
Material: Lona', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766215713100_imagen20251220012812931png', true, 49000, 'ninguno', 0, true, '[1]', '#0760ed'),
	(13, '2025-12-20 07:25:00.035535+00', 'Z3-8', 'Puente en pasillo principal', 'publicidad', 'Ubicación: pasillo principal de zona , visible desde primer y segundo piso.
Medidas 7.28m x 1.19m
Material: Lona sobre bastidor', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766215817189_imagen20251220013015489png', true, 40000, 'ninguno', 0, true, '[1]', '#0d59d3'),
	(10, '2025-12-20 07:16:40.474455+00', 'Z 2-1', 'Antepecho pasillo a C&A', 'publicidad', 'Ubicación: en el pasillo de salida de zona 2 y entrada a zona 1 por la pista de hielo.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766215317886_imagen20251220012155657png', true, 55700, 'ninguno', 0, true, '[1]', '#1f3db2'),
	(26, '2025-12-20 07:55:00.58807+00', 'PENDIENTE', 'Escaleras eléctricas subterráneo Liverpool ( 2 caras)', 'publicidad', 'Ubicación: en zona 7 a la salida del subterráneo que da a la a Liverpool y al foro de Zona Moda.
Material: Vinil autoadherible.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217618974_imagen20251220015926537png', true, 32000, 'ninguno', 0, true, '[1]', '#8affb7'),
	(7, '2025-12-20 07:04:29.567599+00', 'Z1-2', 'Muro a un lado de Coloso y Zara', 'publicidad', 'Ubicado: En zona 1 en el acceso a zona 3, a un costado de Coloso y Zara', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766214586090_imagen20251220010849656png', true, 26250, 'ninguno', 10, true, '[1]', '#d270ff'),
	(22, '2025-12-20 07:46:17.354029+00', 'Z4-2 VAR 3', 'Cristal exterior de escaleras eléctricas', 'publicidad', 'Ubicación: en zona 4 frente a H&M en el acceso a Zona Moda.
Material: Vinil autoadherible.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217095246_imagen20251220015133888png', true, 35000, 'ninguno', 0, true, '[1]', '#f26363'),
	(15, '2025-12-20 07:29:08.693861+00', 'Z3-21', 'Ave en domo principal', 'publicidad', 'Ubicación: debajo del domo principal en zona 3.
Material: Lona sobre bastidor.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216066701_imagen20251220013425693png', true, 49000, 'ninguno', 0, true, '[1]', '#00a8f0'),
	(11, '2025-12-20 07:20:50.282639+00', 'Z3-5', 'Escaleras del domo principal (2 caras)', 'publicidad', 'Ubicación: en zona 3, frente a Sears, Zara, Liverpool y la isla de Starbucks', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766215567220_imagen20251220012604931png', true, 45000, 'ninguno', 0, true, '[1]', '#02d911'),
	(6, '2025-12-20 06:58:46.890044+00', 'ZM-1', 'Puente entre Banamex y Sanborn´s', 'publicidad', 'Ubicación: entre Banamex y Sanborn´s de cara al portico 1
Material: Lona', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766214243593_imagen20251220010357151png', true, 40000, 'ninguno', 0, true, '[1]', '#8400f0'),
	(23, '2025-12-20 07:48:01.2117+00', 'Z7-12', 'Puente central de pasillo', 'publicidad', 'Ubicación: en zona 6 frente a H&M y Vans, de cara a zona de cajeros.
Material: Vinil autoadherible.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217199183_imagen20251220015317364png', true, 39500, 'ninguno', 0, true, '[1]', '#e511e8'),
	(28, '2025-12-20 07:58:56.189177+00', 'EST 254 E-G', 'Paquete de 10 plumas de estacionamiento', 'publicidad', 'Variedad de salidas de estacionamiento
Material: Vinil', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217854335_imagen20251220020412393png', true, 40000, 'ninguno', 0, true, '[1]', '#e6a800'),
	(24, '2025-12-20 07:49:58.602475+00', 'Z7-12 VAR 2', 'Puente central de pasillo', 'publicidad', 'Ubicación: en zona 6, frente a H&M y Vans de cara a escaleras eléctricas.
Mateial: Vinil autoadherible.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217316454_imagen20251220015510982png', true, 39500, 'ninguno', 0, true, '[1]', '#0042ad'),
	(25, '2025-12-20 07:51:35.184942+00', 'Z6-4', 'Dorso de elevador zona 6', 'publicidad', 'Ubicación: en zona 6 a la salida del subterráneo, de cara al pasillo principal.
Material: Vinil autoadherible.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217412858_imagen20251220015651800png', true, 50000, 'ninguno', 0, true, '[1]', '#5a00a3'),
	(14, '2025-12-20 07:26:51.569723+00', 'Z3-12', 'Espectacular sobre balcón Sears', 'publicidad', 'Ubicación: en zona 1, entre Zara y Massimo Dutti, con vista al pórtico 1.
Material: Lona sobre bastidor.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766215929057_imagen20251220013207013png', true, 45000, 'ninguno', 0, true, '[1]', '#045be7'),
	(16, '2025-12-20 07:31:25.215651+00', 'Z4-1', 'Cristales interiores de escaleras eléctricas', 'publicidad', 'Ubicación: En zona 4, frente al acceso del pórtico 4 y acceso a planta hacia Cinemex.
Material: Vinil autoadherible. ', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216203386_imagen20251220013641995png', true, 40000, 'ninguno', 0, true, '[1]', '#59ff00'),
	(8, '2025-12-20 07:07:16.189218+00', 'Z1-3', 'Ave en Domo Suburbia', 'publicidad', 'Ubicado: debajo del domo principal en zona 1', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766214753659_imagen20251220011228684png', true, 49000, 'ninguno', 0, true, '[1]', '#e65c00'),
	(17, '2025-12-20 07:33:33.864034+00', 'Z4-2', 'Cristales exteriores de escaleras eléctricas', 'publicidad', 'Ubicación: en zona 4, frente al acceso del pórtico 4 y acceso a segunda planta hacia Cinemex.
Medidas: 2.77m x 3.65m
Material: Vinil autoadherible', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216331433_imagen20251220013850324png', true, 45000, 'ninguno', 0, true, '[1]', '#29d1c6'),
	(21, '2025-12-20 07:41:29.823064+00', 'Z4-2 VAR 2', 'Cristales exteriores de escaleras eléctricas', 'publicidad', 'Ubicación: en zona 4 frente a Zara home en el centro de Zona Moda.
Medidas: 2.77m x 3.65m
Material: Vinil autoadherible', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766216807958_imagen20251220014559453png', true, 40000, 'ninguno', 0, true, '[1]', '#ff0000'),
	(27, '2025-12-20 07:56:55.879847+00', 'EST 253 E-F', 'Paquete de 5 pendones de estacionamiento', 'publicidad', 'Variedad de zonas y tamaños
Material: Lona en bastidor.', NULL, 'https://rrgxsjbyezvrebmzbdxj.supabase.co/storage/v1/object/public/espacios/1766217734218_imagen20251220020210676png', true, 25000, 'ninguno', 0, true, '[1]', '#2f75e4'),
	(32, '2026-01-27 07:19:48.939331+00', '344', 'Prueba', 'publicidad', 'prueba', NULL, NULL, true, 9999, 'ninguno', 0, true, '[]', '#374151');


--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas; Owner: supabase_admin
--

INSERT INTO "finanzas"."cotizaciones" ("id", "created_at", "creado_por", "espacio_id", "espacio_nombre", "espacio_clave", "cliente_nombre", "cliente_rfc", "cliente_contacto", "cliente_email", "cliente_telefono", "fecha_inicio", "fecha_fin", "precio_final", "desglose_precios", "status", "numero_orden", "numero_contrato", "factura_pdf_url", "factura_xml_url", "contrato_url", "url_cotizacion_final", "url_orden_compra", "fecha_orden_compra", "datos_fiscales", "conceptos_adicionales", "tipo_ajuste", "valor_ajuste", "ajuste_es_porcentaje", "desglose_impuestos", "historial_pagos", "datos_factura", "cliente_id") VALUES
	('d5040989-e79a-41b3-80f5-37b05232806a', '2026-01-27 07:20:05.005498+00', '724828da-3326-4570-ab45-d7215e51fbc2', 32, 'Prueba', '344', 'Johan Jacob Paz Valadez', 'PAVJ011113PB6', '4771631661', 'johan_paz@hotmail.es', NULL, '2026-01-28', '2026-01-31', 9999, '{"impuestos_detalle": [], "subtotal_antes_impuestos": 9999}', 'finalizada', 'ORD-20260127-8681', '23452', 'd5040989-e79a-41b3-80f5-37b05232806a/facturas/1769498629001_factura.pdf', 'd5040989-e79a-41b3-80f5-37b05232806a/facturas/1769498629001_factura.xml', 'd5040989-e79a-41b3-80f5-37b05232806a/1769498618264_contrato_firmado.pdf', 'd5040989-e79a-41b3-80f5-37b05232806a/cotizacion_aprobada_1769498431627.pdf', 'd5040989-e79a-41b3-80f5-37b05232806a/orden_compra_1769498476801.pdf', '2026-01-27 07:21:16.836+00', '{"razon_social": "JOHAN JACOB PAZ VALADEZ", "rfc_receptor": "PAVJ011113PB6", "uuid_factura": "c762f894-a03d-4ccb-8efc-7574eade43af"}', '[]', 'ninguno', 0, false, '[]', '[{"bank": "BBVA Bancomer", "date": "2026-01-27T07:21:27.457Z", "amount": 9999, "account": "0123456789", "concept": "Pago 1 / Prueba", "file_path": "d5040989-e79a-41b3-80f5-37b05232806a/recibos/Recibo_ORD-20260127-8681_1769498487121.pdf", "reference": "ORD-20260127-8681"}]', '{"rfc": "PAVJ011113PB6", "uuid": "c762f894-a03d-4ccb-8efc-7574eade43af", "total": 9999, "nombre": "JOHAN JACOB PAZ VALADEZ"}', '2997e5c2-62c3-40ec-8c1f-1da0c20380ae');


--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas; Owner: supabase_admin
--

INSERT INTO "finanzas"."impuestos" ("id", "nombre", "porcentaje", "activo", "created_at", "impuestos_aplicados") VALUES
	(1, 'IVA', 16, true, '2025-12-20 05:00:37.668293+00', NULL);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

INSERT INTO "finanzas_casadepiedra"."clientes" ("id", "nombre_completo", "telefono", "correo", "rfc", "created_at", "updated_at") VALUES
	('b51df6c1-e0f1-4860-904d-8b03cd055d79', 'Johan Jacob Paz Valadez', '4771631661', 'johanjacobpazvaladez@gmail.com', 'PAVJ011113PB6', '2026-01-26 23:50:37.517036+00', '2026-01-26 23:50:37.517036+00');


--
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

INSERT INTO "finanzas_casadepiedra"."conceptos_catalogo" ("id", "nombre", "precio_sugerido", "activo", "created_at") VALUES
	(1, 'Limpieza', 0, true, '2026-01-27 03:55:21+00'),
	(2, 'Seguridad', 0, true, '2026-01-27 03:55:31+00'),
	(4, 'Generador de energía', 0, true, '2026-01-27 03:55:58+00'),
	(3, 'Carpa SANMARINO', 100, true, '2026-01-27 03:55:45+00');


--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: supabase_admin
--



--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

INSERT INTO "finanzas_casadepiedra"."espacios" ("id", "created_at", "clave", "nombre", "tipo", "descripcion", "requisitos", "imagen_url", "activo", "precio_base", "ajuste_tipo", "ajuste_porcentaje", "activa", "impuestos_ids", "color") VALUES
	(1, '2026-01-25 10:40:36.543168+00', '898', 'Salon Principal', 'espacio', '', NULL, NULL, true, 99999, 'ninguno', 0, true, '[]', '#374151'),
	(2, '2026-01-27 06:19:23.498178+00', '346543', 'Salón Pavoreales', 'espacio', '', NULL, NULL, true, 35343, 'ninguno', 0, true, '[]', '#374151'),
	(3, '2026-01-27 06:19:41.120497+00', '3465', 'Terraza del Mezquite', 'espacio', '', NULL, NULL, true, 645364, 'ninguno', 0, true, '[1]', '#374151'),
	(4, '2026-01-27 06:19:51.858826+00', '123412', 'Jardín Principal', 'espacio', '', NULL, NULL, true, 43452, 'ninguno', 0, true, '[1]', '#374151');


--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

INSERT INTO "finanzas_casadepiedra"."impuestos" ("id", "nombre", "porcentaje", "activo", "created_at", "impuestos_aplicados") VALUES
	(1, 'IVA', 16, true, '2026-01-25 10:41:36+00', NULL);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO "public"."profiles" ("id", "email", "username", "role", "tenant", "app_metadata", "created_at", "updated_at", "allowed_tenants") VALUES
	('ff511a68-a84f-48cf-8227-0669e60d2b9f', 'admin@plazamayor.com', 'Usuario Plaza Mayor', 'plaza_mayor', 'Plaza Mayor', '{}', '2026-01-25 10:51:16.040207+00', '2026-01-27 22:31:27.928293+00', '{plaza_mayor}'),
	('5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', 'admin@casadepiedra.com', 'Usuario Casa De Piedra', 'casa_de_piedra', 'Casa de Piedra', '{}', '2026-01-25 10:50:59.639559+00', '2026-01-27 22:31:37.051661+00', '{casa_de_piedra}'),
	('724828da-3326-4570-ab45-d7215e51fbc2', 'admin@cotizador.com', 'Admin', 'admin', 'plaza_mayor', '{}', '2026-01-24 13:06:44.273196+00', '2026-01-27 22:31:43.132857+00', '{plaza_mayor,casa_de_piedra}');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id", "type") VALUES
	('Espacios', 'Espacios', NULL, '2026-01-15 10:40:43.194536+00', '2026-01-15 10:40:43.194536+00', true, false, NULL, NULL, NULL, 'STANDARD'),
	('documentos', 'documentos', NULL, '2026-01-25 10:48:25.699732+00', '2026-01-25 10:48:25.699732+00', false, false, NULL, NULL, NULL, 'STANDARD'),
	('documentos-cp', 'documentos-cp', NULL, '2026-01-25 10:49:44.008495+00', '2026-01-25 10:49:44.008495+00', false, false, NULL, NULL, NULL, 'STANDARD');


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata", "level") VALUES
	('8c57c058-8142-406b-b7ee-4bc1e9d93922', 'Espacios', 'logo.png', NULL, '2026-01-15 10:42:47.358523+00', '2026-01-15 10:42:47.358523+00', '2026-01-15 10:42:47.358523+00', '{"eTag": "\"189b7282a08d0fc31f336fe194328005\"", "size": 428193, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-15T10:42:47.333Z", "contentLength": 428193, "httpStatusCode": 200}', 'fe86b477-ebd3-43e3-88d0-d38926436e51', NULL, NULL, 1),
	('eb1cf227-9c2d-4fff-867b-ada4c427c53c', 'Espacios', 'logocp.png', NULL, '2026-01-26 22:01:40.173311+00', '2026-01-26 22:01:40.173311+00', '2026-01-26 22:01:40.173311+00', '{"eTag": "\"aa6bfe91878cc3f091e99c33aaf9680b\"", "size": 130281, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-26T22:01:40.166Z", "contentLength": 130281, "httpStatusCode": 200}', '8876e2e5-e073-487d-ba7b-b8063b91c075', NULL, NULL, 1),
	('924c58d3-3191-483d-8663-f9bc26834da0', 'documentos-cp', 'a930824d-9279-454d-991e-8473cbcff57c/cotizacion_aprobada_1769497427060.pdf', '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', '2026-01-27 07:03:47.095013+00', '2026-01-27 07:03:47.095013+00', '2026-01-27 07:03:47.095013+00', '{"eTag": "\"42bfdedea9a1e5097f03b4294d98c5f8\"", "size": 1016277, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:03:47.085Z", "contentLength": 1016277, "httpStatusCode": 200}', '3d161d0b-9ec9-4309-ae30-68a7d15872d2', '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', '{}', 2),
	('b8cbd208-136f-412d-9346-fd16e8ce0dbc', 'documentos-cp', 'a930824d-9279-454d-991e-8473cbcff57c/orden_compra_1769497442845.pdf', '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', '2026-01-27 07:04:02.864079+00', '2026-01-27 07:04:02.864079+00', '2026-01-27 07:04:02.864079+00', '{"eTag": "\"110ac88dd8796cfb122f36f6ae636667\"", "size": 239474, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:04:02.858Z", "contentLength": 239474, "httpStatusCode": 200}', '317ab33f-9591-4aa4-983d-662871df9dc2', '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3', '{}', 2),
	('d7931ffb-2259-4489-a592-c7e5b93c2751', 'documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/cotizacion_aprobada_1769498431627.pdf', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:20:31.694357+00', '2026-01-27 07:20:31.694357+00', '2026-01-27 07:20:31.694357+00', '{"eTag": "\"c07dd813e0bba9955f4fc26da77eb6cf\"", "size": 951044, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:20:31.684Z", "contentLength": 951044, "httpStatusCode": 200}', '9bcf516c-f101-4439-97d2-a336ab153135', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 2),
	('53ec689d-281c-45ba-ab09-bbf5723f8c65', 'documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/orden_compra_1769498476801.pdf', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:21:16.825555+00', '2026-01-27 07:21:16.825555+00', '2026-01-27 07:21:16.825555+00', '{"eTag": "\"0e816aac478c0b747b4d89c0e6971096\"", "size": 190456, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:21:16.818Z", "contentLength": 190456, "httpStatusCode": 200}', 'e2fd5ddf-1d84-4f16-bd71-dc2510db456e', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 2),
	('76cb8bc1-5e34-4148-8a8a-c660c9a8279f', 'documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/recibos/Recibo_ORD-20260127-8681_1769498487121.pdf', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:21:27.444592+00', '2026-01-27 07:21:27.444592+00', '2026-01-27 07:21:27.444592+00', '{"eTag": "\"22c519fe56600d578e0a47a0da0b9a51\"", "size": 239635, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:21:27.438Z", "contentLength": 239635, "httpStatusCode": 200}', 'cf91fba8-0c59-478b-a76d-c4a805fe87bb', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 3),
	('4e4e0d7e-c541-42f7-bbe2-2a2e628948e4', 'documentos', 'templates_contratos/PLAZA MAYOR.html', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:23:01.36481+00', '2026-01-27 07:23:01.36481+00', '2026-01-27 07:23:01.36481+00', '{"eTag": "\"7ae671e800bd6adaea82b8fcaad70f48\"", "size": 6533, "mimetype": "text/html", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:23:01.359Z", "contentLength": 6533, "httpStatusCode": 200}', '215a3adb-22ec-4e71-a926-3d96cf6f3d5e', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 2),
	('f00b888a-2e29-4f1c-ae50-4ba288075060', 'documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/1769498618264_contrato_firmado.pdf', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:23:38.284051+00', '2026-01-27 07:23:38.284051+00', '2026-01-27 07:23:38.284051+00', '{"eTag": "\"d684dc57443c6840c2a4ed2ef939c70b\"", "size": 176277, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:23:38.278Z", "contentLength": 176277, "httpStatusCode": 200}', 'b4904af5-4fce-4ef0-8c24-1f7ae9007b55', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 2),
	('d3e275a3-0752-4e5c-a8e9-b96ccfc10d9e', 'documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/facturas/1769498629001_factura.xml', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:23:49.0249+00', '2026-01-27 07:23:49.0249+00', '2026-01-27 07:23:49.0249+00', '{"eTag": "\"e68422d4d3d1a700efd2db42e06a32f0\"", "size": 5060, "mimetype": "text/xml", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:23:49.020Z", "contentLength": 5060, "httpStatusCode": 200}', 'ff120921-8740-467e-b6bf-36b2352f7d4f', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 3),
	('586a9a89-c480-4235-8281-77c355eccd06', 'documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/facturas/1769498629001_factura.pdf', '724828da-3326-4570-ab45-d7215e51fbc2', '2026-01-27 07:23:49.051132+00', '2026-01-27 07:23:49.051132+00', '2026-01-27 07:23:49.051132+00', '{"eTag": "\"22c519fe56600d578e0a47a0da0b9a51\"", "size": 239635, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2026-01-27T07:23:49.044Z", "contentLength": 239635, "httpStatusCode": 200}', 'f82b4e6b-25d1-4495-82bc-f33194eee46a', '724828da-3326-4570-ab45-d7215e51fbc2', '{}', 3);


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."prefixes" ("bucket_id", "name", "created_at", "updated_at") VALUES
	('documentos-cp', 'a930824d-9279-454d-991e-8473cbcff57c', '2026-01-27 07:03:47.095013+00', '2026-01-27 07:03:47.095013+00'),
	('documentos', 'd5040989-e79a-41b3-80f5-37b05232806a', '2026-01-27 07:20:31.694357+00', '2026-01-27 07:20:31.694357+00'),
	('documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/recibos', '2026-01-27 07:21:27.444592+00', '2026-01-27 07:21:27.444592+00'),
	('documentos', 'templates_contratos', '2026-01-27 07:23:01.36481+00', '2026-01-27 07:23:01.36481+00'),
	('documentos', 'd5040989-e79a-41b3-80f5-37b05232806a/facturas', '2026-01-27 07:23:49.0249+00', '2026-01-27 07:23:49.0249+00');


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 133, true);


--
-- Name: conceptos_catalogo_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: supabase_admin
--

SELECT pg_catalog.setval('"finanzas"."conceptos_catalogo_id_seq"', 6, true);


--
-- Name: espacios_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: supabase_admin
--

SELECT pg_catalog.setval('"finanzas"."espacios_id_seq"', 32, true);


--
-- Name: impuestos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: supabase_admin
--

SELECT pg_catalog.setval('"finanzas"."impuestos_id_seq"', 2, true);


--
-- Name: conceptos_catalogo_id_seq; Type: SEQUENCE SET; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

SELECT pg_catalog.setval('"finanzas_casadepiedra"."conceptos_catalogo_id_seq"', 4, true);


--
-- Name: espacios_id_seq; Type: SEQUENCE SET; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

SELECT pg_catalog.setval('"finanzas_casadepiedra"."espacios_id_seq"', 4, true);


--
-- Name: impuestos_id_seq; Type: SEQUENCE SET; Schema: finanzas_casadepiedra; Owner: supabase_admin
--

SELECT pg_catalog.setval('"finanzas_casadepiedra"."impuestos_id_seq"', 1, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

-- \unrestrict O7kEeGYB7ewUKJgm9GteobZhNLwvSsyeqg41ZEiFkylxTLoFWRfMAdYscsTrtHj

RESET ALL;
