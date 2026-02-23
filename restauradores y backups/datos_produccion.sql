--
-- PostgreSQL database dump
--

\restrict 1R0f1uIC9upbTwQd9fOib8QviOa4M55JFQbf5VQpwToXSjc6bUYWE4Iz3ZTAOB7

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

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE auth.audit_log_entries DISABLE TRIGGER ALL;

INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'db6843a8-964f-416a-8bfc-bbd000735c84', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin@cotizador.com","user_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","user_phone":""}}', '2026-02-14 21:12:20.652115+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '73d7fab6-e888-46f4-9d9f-2482150766df', '{"action":"login","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-14 21:12:27.187437+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '614e7993-519d-49f2-9e1c-37fd5838d3fe', '{"action":"login","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-15 09:23:27.673824+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '599e31c8-b101-4d6e-af93-86369e1fd02b', '{"action":"logout","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-02-15 09:25:26.397374+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '9c3f762a-4d24-4c18-a524-92bca734c98b', '{"action":"login","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-15 09:25:32.72583+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'b2b53055-b6a4-447c-8b5f-125cc4d0872d', '{"action":"login","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 17:48:25.259297+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'ec30c267-98fe-4f22-880a-474e64010f2a', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-16 18:47:41.769562+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '1972f5f4-2979-44f8-8b8e-61139b542713', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-16 18:47:41.782281+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'b70e56d2-42be-43bd-86a1-e1bf1b789c3d', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-16 19:46:47.504717+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '390d805f-747e-4439-9e46-c9712841a670', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-16 19:46:47.506475+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'a4da7124-c27c-4e03-9f5d-fd5bc0538560', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-16 20:48:14.347207+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '0f03e768-f077-4b4d-9f60-7eb4a358a9e4', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-16 20:48:14.349412+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'e62889f0-7a9e-4fb6-a891-b50800abdcd9', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin@plazamayor.com","user_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","user_phone":""}}', '2026-02-16 21:40:39.263787+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'a5469f03-4ad3-492d-a8e6-901ff9356972', '{"action":"logout","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 21:40:44.713231+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '964d2aa0-7039-4b93-8339-9b471edb30ff', '{"action":"login","actor_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 21:41:00.318538+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'ee7d8190-5c92-4d7f-9fb1-928f84014765', '{"action":"logout","actor_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 21:41:29.124333+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'bacc6d66-fb25-46a9-9401-8dee4199ca95', '{"action":"login","actor_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 22:22:28.226584+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '5f93f494-eec7-469a-9616-c4adaef3b3ef', '{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin@casadepiedra.com","user_id":"1b099fcd-164b-49dc-af4a-c64f4b16961d","user_phone":""}}', '2026-02-16 22:36:58.19672+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '7b800c0d-48a5-40eb-b9af-b55eadd28237', '{"action":"logout","actor_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 22:38:31.342051+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'e347fb7d-2517-4534-b6ec-d6180432d94b', '{"action":"login","actor_id":"1b099fcd-164b-49dc-af4a-c64f4b16961d","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 22:38:42.289287+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '80ed6f46-b954-4951-b3c5-63b9ae7a655d', '{"action":"logout","actor_id":"1b099fcd-164b-49dc-af4a-c64f4b16961d","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 22:47:45.148694+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'e48a2c57-d379-4e57-b4c5-7c9ccb89bd28', '{"action":"login","actor_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 22:47:49.790493+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '4535226c-6250-4da4-93b8-e2b6fa7e0b24', '{"action":"logout","actor_id":"9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0","actor_username":"admin@plazamayor.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 22:50:11.154903+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'd2517421-efeb-48b1-b6ca-33df234580ab', '{"action":"login","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 22:50:17.09513+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'f3f61fbd-d1f3-4ca1-a4e2-87cdc1de5bd2', '{"action":"logout","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 22:52:07.671066+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '498b44c7-1c86-4ac5-ae42-badf1f1c8d4d', '{"action":"login","actor_id":"1b099fcd-164b-49dc-af4a-c64f4b16961d","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 22:52:12.699237+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '9c96b49d-4fd7-4bf0-af2e-43191ec20a06', '{"action":"logout","actor_id":"1b099fcd-164b-49dc-af4a-c64f4b16961d","actor_username":"admin@casadepiedra.com","actor_via_sso":false,"log_type":"account"}', '2026-02-16 23:06:20.693904+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '30b6100d-f11e-45c8-b449-e9b7e355a5e7', '{"action":"login","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-02-16 23:06:27.59878+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '3af32257-ee20-44a7-a4c3-328e74ce48d7', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-18 21:16:33.343211+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '9235b95e-324e-4e2c-9bba-25d6cd23c0a7', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-18 21:16:33.352483+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '7d1b3840-739e-4332-853d-9a124793cada', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 19:31:28.918596+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '47ef23ab-e769-4766-947b-789971cbd5c6', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 19:31:28.971339+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'a4bb6a4c-c191-4646-9b9b-cb537c3cf2ed', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 20:30:56.098577+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '7336b6b6-3424-425d-baa2-3cd3998f60f5', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 20:30:56.100229+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'ab429c1c-a181-4e37-9243-92ad03550421', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 21:29:29.404434+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '9bec2f00-b159-4477-90c4-d5ee8d693f21', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 21:29:29.406628+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '9041cab9-2e20-4dd6-9669-d909cf135499', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 22:27:31.491789+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'f82cef7d-9bba-4919-9ce2-9a3a066876c9', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 22:27:31.496447+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '8cf92781-a388-4cc3-81d0-f994aa948619', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 23:26:11.158636+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'f3a68fef-f236-4b87-861b-1934df8086fa', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-19 23:26:11.168536+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '9e1d56b5-4d40-4a75-b077-d5b4394dc4cb', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 00:25:05.879758+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '24afebc8-c04f-4221-a423-253605f12951', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 00:25:05.887009+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'b4ccd5ad-3077-4c41-898a-2e14d9af2de6', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 19:23:03.005598+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '73687178-ed8a-4ef7-b7e4-40a82030a1b9', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 19:23:03.007889+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '5dc668bc-28f3-4ab3-8107-196130fbf65f', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 20:21:08.611298+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'e8e66ca9-cbbf-4034-b024-82d37c435eb3', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 20:21:08.611953+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '7bdf60ab-03e3-4d41-8e31-10c94756adda', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 21:42:23.566579+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '68ec64cf-6d9e-4536-9c02-4997766daad4', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-20 21:42:23.568087+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '861b1f14-ddd4-4fc6-8ebe-b5b71e87b421', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 19:22:57.419163+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '853fea13-8dce-4d27-b1dd-0fe6ae6c45f0', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 19:22:57.421626+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'c6842629-82f3-4348-8a19-4ce543147691', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 21:49:55.309633+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '4f59f89f-23d1-487b-92c0-ac533894632c', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 21:49:55.312355+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '26405c01-fe24-47ac-afd3-50ca9bee9e32', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 22:48:11.458505+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'f242cd63-82c4-43cf-9aa6-01d3e8d4ece2', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 22:48:11.483556+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '830e3cdb-9762-42b8-a029-e9020dcc074f', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 23:47:55.886651+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'e40cd795-66fb-481e-8bec-fe6e381ac5cf', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-21 23:47:55.888041+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '936d38e3-0ae7-477c-8c1b-3b9aca566b73', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-22 00:47:12.948775+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'f58d54fd-9d21-4847-9069-d4d2a60420a1', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-22 00:47:12.952031+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '80a0c37e-a181-41dc-a922-0083617feacd', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-22 01:45:25.372304+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'e324005d-a3da-4745-b9e1-dc1c7ef84318', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-22 01:45:25.375256+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'f819ae97-667c-415e-8b4f-a55bcf26b4c4', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-22 21:58:23.081556+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '0f57f046-b360-4acf-a5a2-2d8f56705ad1', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-22 21:58:23.086359+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', '2c8778d4-7e3a-4558-9342-b2124ed00dd3', '{"action":"token_refreshed","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-23 13:19:07.493238+00', '');
INSERT INTO auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) VALUES ('00000000-0000-0000-0000-000000000000', 'd2629cea-6f23-4230-9657-060009bf665f', '{"action":"token_revoked","actor_id":"2d353feb-16d5-43fb-9529-d1334f4c6059","actor_username":"admin@cotizador.com","actor_via_sso":false,"log_type":"token"}', '2026-02-23 13:19:07.501049+00', '');


ALTER TABLE auth.audit_log_entries ENABLE TRIGGER ALL;

--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state DISABLE TRIGGER ALL;



ALTER TABLE auth.flow_state ENABLE TRIGGER ALL;

--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users DISABLE TRIGGER ALL;

INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', '9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0', 'authenticated', 'authenticated', 'admin@plazamayor.com', '$2a$10$c7sQRjMmvT1wkycMS4cP3OQpQeazHwVIGigusfiHnKfmoI/sLM67K', '2026-02-16 21:40:39.269764+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-02-16 22:47:49.793702+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-02-16 21:40:39.199911+00', '2026-02-16 22:47:49.801613+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', '1b099fcd-164b-49dc-af4a-c64f4b16961d', 'authenticated', 'authenticated', 'admin@casadepiedra.com', '$2a$10$dACIeFDOpmNSpnTFq.3w9eFgkD44GuwHRRB/PLLPdv5nLi33TjRNK', '2026-02-16 22:36:58.203281+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-02-16 22:52:12.700844+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-02-16 22:36:58.18393+00', '2026-02-16 22:52:12.705347+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', '2d353feb-16d5-43fb-9529-d1334f4c6059', 'authenticated', 'authenticated', 'admin@cotizador.com', '$2a$10$Q3ftpiGxXHCMuIGH0Z7BI.KFU6zrVJCNv/7hL5GsDpGfJQCwS4oGO', '2026-02-14 21:12:20.675521+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-02-16 23:06:27.601263+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-02-14 21:12:20.567887+00', '2026-02-23 13:19:07.510251+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


ALTER TABLE auth.users ENABLE TRIGGER ALL;

--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities DISABLE TRIGGER ALL;

INSERT INTO auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) VALUES ('2d353feb-16d5-43fb-9529-d1334f4c6059', '2d353feb-16d5-43fb-9529-d1334f4c6059', '{"sub": "2d353feb-16d5-43fb-9529-d1334f4c6059", "email": "admin@cotizador.com", "email_verified": false, "phone_verified": false}', 'email', '2026-02-14 21:12:20.639345+00', '2026-02-14 21:12:20.639754+00', '2026-02-14 21:12:20.639754+00', 'cbdaa093-acfc-4740-902e-381bbd6fc375');
INSERT INTO auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) VALUES ('9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0', '9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0', '{"sub": "9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0", "email": "admin@plazamayor.com", "email_verified": false, "phone_verified": false}', 'email', '2026-02-16 21:40:39.259102+00', '2026-02-16 21:40:39.259625+00', '2026-02-16 21:40:39.259625+00', '8bcc7013-a598-44c7-b9d0-77b7c0220616');
INSERT INTO auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) VALUES ('1b099fcd-164b-49dc-af4a-c64f4b16961d', '1b099fcd-164b-49dc-af4a-c64f4b16961d', '{"sub": "1b099fcd-164b-49dc-af4a-c64f4b16961d", "email": "admin@casadepiedra.com", "email_verified": false, "phone_verified": false}', 'email', '2026-02-16 22:36:58.193872+00', '2026-02-16 22:36:58.193934+00', '2026-02-16 22:36:58.193934+00', '75cd4b7f-bab8-40ca-9b89-7c25fa7d08a4');


ALTER TABLE auth.identities ENABLE TRIGGER ALL;

--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances DISABLE TRIGGER ALL;



ALTER TABLE auth.instances ENABLE TRIGGER ALL;

--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.oauth_clients DISABLE TRIGGER ALL;



ALTER TABLE auth.oauth_clients ENABLE TRIGGER ALL;

--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions DISABLE TRIGGER ALL;

INSERT INTO auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) VALUES ('d4f782a5-d244-47fe-8dbc-c0b87f97e58d', '2d353feb-16d5-43fb-9529-d1334f4c6059', '2026-02-16 23:06:27.601371+00', '2026-02-23 13:19:07.516146+00', NULL, 'aal1', NULL, '2026-02-23 13:19:07.515895', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 OPR/127.0.0.0 (Edition std-2)', '172.18.0.1', NULL, NULL, NULL, NULL, NULL);


ALTER TABLE auth.sessions ENABLE TRIGGER ALL;

--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims DISABLE TRIGGER ALL;

INSERT INTO auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) VALUES ('d4f782a5-d244-47fe-8dbc-c0b87f97e58d', '2026-02-16 23:06:27.606452+00', '2026-02-16 23:06:27.606452+00', 'password', '6a768e2c-06a7-4597-adc5-621dab28145e');


ALTER TABLE auth.mfa_amr_claims ENABLE TRIGGER ALL;

--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors DISABLE TRIGGER ALL;



ALTER TABLE auth.mfa_factors ENABLE TRIGGER ALL;

--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges DISABLE TRIGGER ALL;



ALTER TABLE auth.mfa_challenges ENABLE TRIGGER ALL;

--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.oauth_authorizations DISABLE TRIGGER ALL;



ALTER TABLE auth.oauth_authorizations ENABLE TRIGGER ALL;

--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.oauth_client_states DISABLE TRIGGER ALL;



ALTER TABLE auth.oauth_client_states ENABLE TRIGGER ALL;

--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.oauth_consents DISABLE TRIGGER ALL;



ALTER TABLE auth.oauth_consents ENABLE TRIGGER ALL;

--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens DISABLE TRIGGER ALL;



ALTER TABLE auth.one_time_tokens ENABLE TRIGGER ALL;

--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens DISABLE TRIGGER ALL;

INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 14, '3q4e5ufd3jto', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-16 23:06:27.604074+00', '2026-02-18 21:16:33.354873+00', NULL, 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 15, '74mph6sxiwtj', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-18 21:16:33.35702+00', '2026-02-19 19:31:28.975503+00', '3q4e5ufd3jto', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 16, 'e6qxkw7e3oit', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-19 19:31:28.990002+00', '2026-02-19 20:30:56.100923+00', '74mph6sxiwtj', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 49, 'dcfpbjjjaxj4', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-19 20:30:56.10216+00', '2026-02-19 21:29:29.407287+00', 'e6qxkw7e3oit', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 50, '7utk7armcyi2', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-19 21:29:29.408304+00', '2026-02-19 22:27:31.501047+00', 'dcfpbjjjaxj4', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 51, 'l5yahykucozd', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-19 22:27:31.509526+00', '2026-02-19 23:26:11.172535+00', '7utk7armcyi2', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 52, 'abrf43cflqhj', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-19 23:26:11.178419+00', '2026-02-20 00:25:05.88916+00', 'l5yahykucozd', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 53, 'v2z3bct5jkgf', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-20 00:25:05.892918+00', '2026-02-20 19:23:03.008477+00', 'abrf43cflqhj', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 54, 'hgyf5kivyvdg', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-20 19:23:03.009043+00', '2026-02-20 20:21:08.612398+00', 'v2z3bct5jkgf', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 55, 'mwnqnu3q7qg2', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-20 20:21:08.61288+00', '2026-02-20 21:42:23.569124+00', 'hgyf5kivyvdg', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 56, 'ksveh2nrqw2i', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-20 21:42:23.570622+00', '2026-02-21 19:22:57.422261+00', 'mwnqnu3q7qg2', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 57, 'ljoswak2laz3', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-21 19:22:57.422944+00', '2026-02-21 21:49:55.313635+00', 'ksveh2nrqw2i', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 58, 'mkdx2zykrsyo', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-21 21:49:55.318743+00', '2026-02-21 22:48:11.504011+00', 'ljoswak2laz3', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 59, 'l2qg3umyajop', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-21 22:48:11.528709+00', '2026-02-21 23:47:55.888785+00', 'mkdx2zykrsyo', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 60, 'izr2dxsja5kt', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-21 23:47:55.891354+00', '2026-02-22 00:47:12.953668+00', 'l2qg3umyajop', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 61, 'uarjxsnref6f', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-22 00:47:12.96257+00', '2026-02-22 01:45:25.376251+00', 'izr2dxsja5kt', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 62, 'ggfdncukq5ly', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-22 01:45:25.37781+00', '2026-02-22 21:58:23.088268+00', 'uarjxsnref6f', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 63, 'yuctgxr4sssv', '2d353feb-16d5-43fb-9529-d1334f4c6059', true, '2026-02-22 21:58:23.092004+00', '2026-02-23 13:19:07.503354+00', 'ggfdncukq5ly', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');
INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 64, 'z265vzutskil', '2d353feb-16d5-43fb-9529-d1334f4c6059', false, '2026-02-23 13:19:07.505598+00', '2026-02-23 13:19:07.505598+00', 'yuctgxr4sssv', 'd4f782a5-d244-47fe-8dbc-c0b87f97e58d');


ALTER TABLE auth.refresh_tokens ENABLE TRIGGER ALL;

--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers DISABLE TRIGGER ALL;



ALTER TABLE auth.sso_providers ENABLE TRIGGER ALL;

--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers DISABLE TRIGGER ALL;



ALTER TABLE auth.saml_providers ENABLE TRIGGER ALL;

--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states DISABLE TRIGGER ALL;



ALTER TABLE auth.saml_relay_states ENABLE TRIGGER ALL;

--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations DISABLE TRIGGER ALL;

INSERT INTO auth.schema_migrations (version) VALUES ('20171026211738');
INSERT INTO auth.schema_migrations (version) VALUES ('20171026211808');
INSERT INTO auth.schema_migrations (version) VALUES ('20171026211834');
INSERT INTO auth.schema_migrations (version) VALUES ('20180103212743');
INSERT INTO auth.schema_migrations (version) VALUES ('20180108183307');
INSERT INTO auth.schema_migrations (version) VALUES ('20180119214651');
INSERT INTO auth.schema_migrations (version) VALUES ('20180125194653');
INSERT INTO auth.schema_migrations (version) VALUES ('00');
INSERT INTO auth.schema_migrations (version) VALUES ('20210710035447');
INSERT INTO auth.schema_migrations (version) VALUES ('20210722035447');
INSERT INTO auth.schema_migrations (version) VALUES ('20210730183235');
INSERT INTO auth.schema_migrations (version) VALUES ('20210909172000');
INSERT INTO auth.schema_migrations (version) VALUES ('20210927181326');
INSERT INTO auth.schema_migrations (version) VALUES ('20211122151130');
INSERT INTO auth.schema_migrations (version) VALUES ('20211124214934');
INSERT INTO auth.schema_migrations (version) VALUES ('20211202183645');
INSERT INTO auth.schema_migrations (version) VALUES ('20220114185221');
INSERT INTO auth.schema_migrations (version) VALUES ('20220114185340');
INSERT INTO auth.schema_migrations (version) VALUES ('20220224000811');
INSERT INTO auth.schema_migrations (version) VALUES ('20220323170000');
INSERT INTO auth.schema_migrations (version) VALUES ('20220429102000');
INSERT INTO auth.schema_migrations (version) VALUES ('20220531120530');
INSERT INTO auth.schema_migrations (version) VALUES ('20220614074223');
INSERT INTO auth.schema_migrations (version) VALUES ('20220811173540');
INSERT INTO auth.schema_migrations (version) VALUES ('20221003041349');
INSERT INTO auth.schema_migrations (version) VALUES ('20221003041400');
INSERT INTO auth.schema_migrations (version) VALUES ('20221011041400');
INSERT INTO auth.schema_migrations (version) VALUES ('20221020193600');
INSERT INTO auth.schema_migrations (version) VALUES ('20221021073300');
INSERT INTO auth.schema_migrations (version) VALUES ('20221021082433');
INSERT INTO auth.schema_migrations (version) VALUES ('20221027105023');
INSERT INTO auth.schema_migrations (version) VALUES ('20221114143122');
INSERT INTO auth.schema_migrations (version) VALUES ('20221114143410');
INSERT INTO auth.schema_migrations (version) VALUES ('20221125140132');
INSERT INTO auth.schema_migrations (version) VALUES ('20221208132122');
INSERT INTO auth.schema_migrations (version) VALUES ('20221215195500');
INSERT INTO auth.schema_migrations (version) VALUES ('20221215195800');
INSERT INTO auth.schema_migrations (version) VALUES ('20221215195900');
INSERT INTO auth.schema_migrations (version) VALUES ('20230116124310');
INSERT INTO auth.schema_migrations (version) VALUES ('20230116124412');
INSERT INTO auth.schema_migrations (version) VALUES ('20230131181311');
INSERT INTO auth.schema_migrations (version) VALUES ('20230322519590');
INSERT INTO auth.schema_migrations (version) VALUES ('20230402418590');
INSERT INTO auth.schema_migrations (version) VALUES ('20230411005111');
INSERT INTO auth.schema_migrations (version) VALUES ('20230508135423');
INSERT INTO auth.schema_migrations (version) VALUES ('20230523124323');
INSERT INTO auth.schema_migrations (version) VALUES ('20230818113222');
INSERT INTO auth.schema_migrations (version) VALUES ('20230914180801');
INSERT INTO auth.schema_migrations (version) VALUES ('20231027141322');
INSERT INTO auth.schema_migrations (version) VALUES ('20231114161723');
INSERT INTO auth.schema_migrations (version) VALUES ('20231117164230');
INSERT INTO auth.schema_migrations (version) VALUES ('20240115144230');
INSERT INTO auth.schema_migrations (version) VALUES ('20240214120130');
INSERT INTO auth.schema_migrations (version) VALUES ('20240306115329');
INSERT INTO auth.schema_migrations (version) VALUES ('20240314092811');
INSERT INTO auth.schema_migrations (version) VALUES ('20240427152123');
INSERT INTO auth.schema_migrations (version) VALUES ('20240612123726');
INSERT INTO auth.schema_migrations (version) VALUES ('20240729123726');
INSERT INTO auth.schema_migrations (version) VALUES ('20240802193726');
INSERT INTO auth.schema_migrations (version) VALUES ('20240806073726');
INSERT INTO auth.schema_migrations (version) VALUES ('20241009103726');
INSERT INTO auth.schema_migrations (version) VALUES ('20250717082212');
INSERT INTO auth.schema_migrations (version) VALUES ('20250731150234');
INSERT INTO auth.schema_migrations (version) VALUES ('20250804100000');
INSERT INTO auth.schema_migrations (version) VALUES ('20250901200500');
INSERT INTO auth.schema_migrations (version) VALUES ('20250903112500');
INSERT INTO auth.schema_migrations (version) VALUES ('20250904133000');
INSERT INTO auth.schema_migrations (version) VALUES ('20250925093508');
INSERT INTO auth.schema_migrations (version) VALUES ('20251007112900');
INSERT INTO auth.schema_migrations (version) VALUES ('20251104100000');
INSERT INTO auth.schema_migrations (version) VALUES ('20251111201300');
INSERT INTO auth.schema_migrations (version) VALUES ('20251201000000');
INSERT INTO auth.schema_migrations (version) VALUES ('20260115000000');
INSERT INTO auth.schema_migrations (version) VALUES ('20260121000000');


ALTER TABLE auth.schema_migrations ENABLE TRIGGER ALL;

--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains DISABLE TRIGGER ALL;



ALTER TABLE auth.sso_domains ENABLE TRIGGER ALL;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

ALTER TABLE finanzas.clientes DISABLE TRIGGER ALL;

INSERT INTO finanzas.clientes (id, nombre_completo, telefono, correo, rfc, created_at, updated_at) VALUES ('2997e5c2-62c3-40ec-8c1f-1da0c20380ae', 'Johan Jacob Paz Valadez', '4771631661', 'johan_paz@hotmail.es', 'PAVJ011113PB6', '2026-01-26 23:37:50.548335+00', '2026-01-26 23:37:50.548335+00');


ALTER TABLE finanzas.clientes ENABLE TRIGGER ALL;

--
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

ALTER TABLE finanzas.conceptos_catalogo DISABLE TRIGGER ALL;

INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (1, 'Limpieza', 0, true, '2025-12-19 08:29:59.031025+00');
INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (3, 'Mobiliario', 0, true, '2025-12-19 08:30:57.056834+00');
INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (4, 'Seguridad', 500, true, '2025-12-19 08:31:41.47937+00');
INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (5, 'Instalación', 0, true, '2025-12-19 08:36:01.791921+00');


ALTER TABLE finanzas.conceptos_catalogo ENABLE TRIGGER ALL;

--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

ALTER TABLE finanzas.espacios DISABLE TRIGGER ALL;

INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (7, '2025-12-20 07:04:29.567599+00', 'Z1-2', 'Muro a un lado de Samsung y Zara', 'publicidad', 'Ubicación: En zona 1 en el acceso a zona 3, a un costado de Coloso y Zara.
Material: Por definir.
Medidas: Por definir.', NULL, NULL, true, 26250, 'ninguno', 10, true, '[1]', '#d270ff', '["Muro", "Pasillo"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (9, '2025-12-20 07:08:59.400205+00', 'Z1-9', 'Muro espectacular entre Zara y Massimo Dutti', 'publicidad', 'Ubicación: En zona 3, frente a Sears, de cara al domo principal.
Material: Vinil sobre bastidor.
Medidas: 13.0m x 3.0m.', NULL, NULL, true, 50000, 'ninguno', 0, true, '[1]', '#ff0000', '["Muro", "Espectacular", "Pasillo", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (10, '2025-12-20 07:16:40.474455+00', 'Z 2-1', 'Antepecho pasillo a C&A', 'publicidad', 'Ubicación: En el pasillo de salida de zona 2 y entrada a zona 1 por la pista de hielo.
Material: Por definir.
Medidas: Por definir.', NULL, NULL, true, 55700, 'ninguno', 0, true, '[1]', '#1f3db2', '["Antepecho", "Pasillo"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (11, '2025-12-20 07:20:50.282639+00', 'Z3-5', 'Escaleras del domo principal (2 caras)', 'publicidad', 'Ubicación: En zona 3, frente a Sears, Zara, Liverpool y la isla de Starbucks.
Material: Por definir.
Medidas: Por definir.', NULL, NULL, true, 45000, 'ninguno', 0, true, '[1]', '#02d911', '["Escaleras", "Domo"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (12, '2025-12-20 07:23:15.460771+00', 'Z3-6', 'Paquete de 10 pendones interiores', 'publicidad', 'Ubicación: En los principales pasillos de zona 3, visibles desde primer y segundo piso.
Material: Lona.
Medidas: 70cm x 500cm.', NULL, NULL, true, 49000, 'ninguno', 0, true, '[1]', '#0760ed', '["Pendones", "Paquete", "Aéreo", "Lona"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (13, '2025-12-20 07:25:00.035535+00', 'Z3-8', 'Puente en pasillo principal', 'publicidad', 'Ubicación: Pasillo principal de zona 3, visible desde primer y segundo piso.
Material: Lona sobre bastidor.
Medidas: 7.28m x 1.19m.', NULL, NULL, true, 40000, 'ninguno', 0, true, '[1]', '#0d59d3', '["Puente", "Aéreo", "Pasillo", "Lona"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (14, '2025-12-20 07:26:51.569723+00', 'Z3-12', 'Espectacular sobre balcón Sears', 'publicidad', 'Ubicación: En zona 1, entre Zara y Massimo Dutti, con vista al pórtico 1.
Material: Lona sobre bastidor.
Medidas: Por definir.', NULL, NULL, true, 45000, 'ninguno', 0, true, '[1]', '#045be7', '["Espectacular", "Aéreo", "Lona"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (15, '2025-12-20 07:29:08.693861+00', 'Z3-21', 'Ave en domo principal', 'publicidad', 'Ubicación: Debajo del domo principal en zona 3.
Material: Lona sobre bastidor.
Medidas: Por definir.', NULL, NULL, true, 49000, 'ninguno', 0, true, '[1]', '#00a8f0', '["Aéreo", "Domo", "Lona"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (16, '2025-12-20 07:31:25.215651+00', 'Z4-1', 'Cristales interiores de escaleras eléctricas', 'publicidad', 'Ubicación: En zona 4, frente al acceso del pórtico 4 y acceso a planta hacia Cinemex.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 40000, 'ninguno', 0, true, '[1]', '#59ff00', '["Cristal", "Escaleras", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (18, '2025-12-20 07:34:54.80137+00', 'Z4-3', 'Cristal superior zona de cajeros', 'publicidad', 'Ubicación: En zona 6, frente a H&M de cara a explanada de fuente y diversas islas.
Material: Por definir.
Medidas: Por definir.', NULL, NULL, true, 30000, 'ninguno', 0, true, '[1]', '#58c80e', '["Cristal", "Muro"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (27, '2025-12-20 07:56:55.879847+00', 'EST 253 E-F', 'Paquete de 5 pendones de estacionamiento', 'publicidad', 'Ubicación: Variedad de zonas y tamaños en estacionamiento.
Material: Lona en bastidor.
Medidas: Por definir.', NULL, NULL, true, 25000, 'ninguno', 0, true, '[1]', '#2f75e4', '["Estacionamiento", "Pendones", "Paquete", "Lona"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (6, '2025-12-20 06:58:46.890044+00', 'ZM-1', 'Puente entre Banamex y Sanborns', 'publicidad', 'Ubicación: Entre Banamex y Sanborns de cara al pórtico 1.
Material: Lona.
Medidas: Por definir.', NULL, NULL, true, 40000, 'ninguno', 0, true, '[1]', '#8400f0', '["Puente", "Aéreo", "Lona"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (8, '2025-12-20 07:07:16.189218+00', 'Z1-3', 'Ave en Domo Suburbia', 'publicidad', 'Ubicación: Debajo del domo principal en zona 1.
Material: Por definir.
Medidas: Por definir.', NULL, NULL, true, 49000, 'ninguno', 0, true, '[1]', '#e65c00', '["Aéreo", "Domo"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (17, '2025-12-20 07:33:33.864034+00', 'Z4-2', 'Cristales exteriores de escaleras eléctricas', 'publicidad', 'Ubicación: En zona 4, frente al acceso del pórtico 4 y acceso a segunda planta hacia Cinemex.
Material: Vinil autoadherible.
Medidas: 2.77m x 3.65m.', NULL, NULL, true, 45000, 'ninguno', 0, true, '[1]', '#29d1c6', '["Cristal", "Escaleras", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (19, '2025-12-20 07:36:54.875585+00', 'Z5-2', 'Elevador panorámico', 'publicidad', 'Ubicación: En zona 5 frente al acceso del pórtico 4 y acceso a segunda planta hacia Cinemex.
Material: Vinil autoadherible.
Medidas: 2.14m x 9.77m.', NULL, NULL, true, 45000, 'ninguno', 0, true, '[1]', '#cf7207', '["Elevador", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (20, '2025-12-20 07:39:01.375808+00', 'Z6-1', 'Cristales laterales de escaleras Banana Republic', 'publicidad', 'Ubicación: Zona 6 en el pasillo principal frente a Banana Republic, Stradivarius, etc.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 45000, 'ninguno', 0, true, '[1]', '#ff2600', '["Cristal", "Escaleras", "Pasillo", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (21, '2025-12-20 07:41:29.823064+00', 'Z4-2 VAR 2', 'Cristales exteriores de escaleras eléctricas', 'publicidad', 'Ubicación: En zona 4 frente a Zara home en el centro de Zona Moda.
Material: Vinil autoadherible.
Medidas: 2.77m x 3.65m.', NULL, NULL, true, 40000, 'ninguno', 0, true, '[1]', '#ff0000', '["Cristal", "Escaleras", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (22, '2025-12-20 07:46:17.354029+00', 'Z4-2 VAR 3', 'Cristal exterior de escaleras eléctricas', 'publicidad', 'Ubicación: En zona 4 frente a H&M en el acceso a Zona Moda.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 35000, 'ninguno', 0, true, '[1]', '#f26363', '["Cristal", "Escaleras", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (23, '2025-12-20 07:48:01.2117+00', 'Z7-12', 'Puente central de pasillo', 'publicidad', 'Ubicación: En zona 6 frente a H&M y Vans, de cara a zona de cajeros.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 39500, 'ninguno', 0, true, '[1]', '#e511e8', '["Puente", "Aéreo", "Pasillo", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (24, '2025-12-20 07:49:58.602475+00', 'Z7-12 VAR 2', 'Puente central de pasillo', 'publicidad', 'Ubicación: En zona 6, frente a H&M y Vans de cara a escaleras eléctricas.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 39500, 'ninguno', 0, true, '[1]', '#0042ad', '["Puente", "Aéreo", "Pasillo", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (25, '2025-12-20 07:51:35.184942+00', 'Z6-4', 'Dorso de elevador zona 6', 'publicidad', 'Ubicación: En zona 6 a la salida del subterráneo, de cara al pasillo principal.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 50000, 'ninguno', 0, true, '[1]', '#5a00a3', '["Elevador", "Subterráneo", "Pasillo", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (26, '2025-12-20 07:55:00.58807+00', 'PENDIENTE', 'Escaleras eléctricas subterráneo Liverpool (2 caras)', 'publicidad', 'Ubicación: En zona 7 a la salida del subterráneo que da a Liverpool y al foro de Zona Moda.
Material: Vinil autoadherible.
Medidas: Por definir.', NULL, NULL, true, 32000, 'ninguno', 0, true, '[1]', '#8affb7', '["Escaleras", "Subterráneo", "Vinil"]');
INSERT INTO finanzas.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, etiquetas) VALUES (28, '2025-12-20 07:58:56.189177+00', 'EST 254 E-G', 'Paquete de 10 plumas de estacionamiento', 'publicidad', 'Ubicación: Variedad de salidas de estacionamiento.
Material: Vinil.
Medidas: Por definir.', NULL, NULL, true, 40000, 'ninguno', 0, true, '[1]', '#e6a800', '["Estacionamiento", "Paquete", "Vinil"]');


ALTER TABLE finanzas.espacios ENABLE TRIGGER ALL;

--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

ALTER TABLE finanzas.cotizaciones DISABLE TRIGGER ALL;

INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('539b8961-8237-45ed-85eb-0b7eec808ee1', '2026-02-22 00:55:17.325073+00', NULL, 10, 'Antepecho pasillo a C&A', 'Z 2-1', 'Johan Jacob Paz Valadez', '', '345345', '345', NULL, '2026-02-21', '2026-02-28', 64611.99999999999, '{"tax_total": 8911.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 55700}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);
INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('27bbfb0a-4e36-474e-b380-c1f6b5a590ef', '2026-02-22 01:04:14.315613+00', NULL, 10, 'Antepecho pasillo a C&A', 'Z 2-1', 'Johan Paz', '', '4774440417', 'arris14b2@gmail.com', NULL, '2026-02-27', '2026-02-27', 64611.99999999999, '{"tax_total": 8911.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 55700}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);
INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('ddb6ce65-38a9-46cc-b543-f9f98f77b03b', '2026-02-22 01:32:33.556743+00', NULL, 10, 'Antepecho pasillo a C&A', 'Z 2-1', 'Mónica Hernández Gutiérrez', '', '4791041881', 'piki_sandia@outlook.com', NULL, '2026-02-24', '2026-02-25', 64611.99999999999, '{"tax_total": 8911.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 55700}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);
INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('cf60b7ab-31b2-4ce4-83e1-cb1ecd3bab4d', '2026-02-22 01:37:46.508813+00', NULL, 8, 'Ave en Domo Suburbia', 'Z1-3', 'Andrea Alcantar', '', '4727385294', 'andrea_tienda99@outlook.com', NULL, '2026-02-28', '2026-02-28', 56839.99999999999, '{"tax_total": 7839.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 49000}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);


ALTER TABLE finanzas.cotizaciones ENABLE TRIGGER ALL;

--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

ALTER TABLE finanzas.impuestos DISABLE TRIGGER ALL;

INSERT INTO finanzas.impuestos (id, nombre, porcentaje, activo, created_at, impuestos_aplicados) VALUES (1, 'IVA', 16, true, '2025-12-20 05:00:37.668293+00', NULL);


ALTER TABLE finanzas.impuestos ENABLE TRIGGER ALL;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

ALTER TABLE finanzas_casadepiedra.clientes DISABLE TRIGGER ALL;

INSERT INTO finanzas_casadepiedra.clientes (id, nombre_completo, telefono, correo, rfc, created_at, updated_at) VALUES ('b51df6c1-e0f1-4860-904d-8b03cd055d79', 'Johan Jacob Paz Valadez', '4771631661', 'johanjacobpazvaladez@gmail.com', 'PAVJ011113PB6', '2026-01-26 23:50:37.517036+00', '2026-01-26 23:50:37.517036+00');
INSERT INTO finanzas_casadepiedra.clientes (id, nombre_completo, telefono, correo, rfc, created_at, updated_at) VALUES ('a3299bd7-16d6-45aa-b187-8a5856697255', 'Emma Valadez Medina', '4772309481', 'adsasdasd@asdads.com', 'PAVJ011113PB4', '2026-02-12 05:24:40.57242+00', '2026-02-12 05:24:40.57242+00');


ALTER TABLE finanzas_casadepiedra.clientes ENABLE TRIGGER ALL;

--
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

ALTER TABLE finanzas_casadepiedra.conceptos_catalogo DISABLE TRIGGER ALL;

INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (1, 'Limpieza', 0, true, '2026-01-27 03:55:21+00');
INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (2, 'Seguridad', 0, true, '2026-01-27 03:55:31+00');
INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (3, 'Carpa SANMARINO', 100, true, '2026-01-27 03:55:45+00');
INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (4, 'Generador de energía', 0, true, '2026-01-27 03:55:58+00');


ALTER TABLE finanzas_casadepiedra.conceptos_catalogo ENABLE TRIGGER ALL;

--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

ALTER TABLE finanzas_casadepiedra.cotizaciones DISABLE TRIGGER ALL;



ALTER TABLE finanzas_casadepiedra.cotizaciones ENABLE TRIGGER ALL;

--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

ALTER TABLE finanzas_casadepiedra.espacios DISABLE TRIGGER ALL;

INSERT INTO finanzas_casadepiedra.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, precios_por_dia, dias_bloqueados, etiquetas) VALUES (1, '2026-01-25 10:40:36.543168+00', '898', 'Salón Principal', 'espacio', 'Un espacio privado y agradable, techado, con gran iluminación y delimitado por elegantes muros apanelados, con capacidad para 1000 personas, se convierte en el escenario perfecto para eventos como bodas, xv años, conferencias y eventos corporativos.

Ubicación: Por definir.
Medidas: Por definir.', NULL, 'http://127.0.0.1:55551/storage/v1/object/public/Espacios/espacios/1771267532568.png', true, 119000, 'ninguno', 0, true, '[]', '#374151', '[{"max": 400, "min": 1, "precios": {"lunes": 47000, "jueves": 47000, "martes": 47000, "sabado": 96000, "domingo": 36500, "viernes": 79000, "miercoles": 47000}}, {"max": 800, "min": 401, "precios": {"lunes": 60000, "jueves": 60000, "martes": 60000, "sabado": 119000, "domingo": 48500, "viernes": 85000, "miercoles": 60000}}]', '[]', '["Salón", "Gran Formato", "Techado"]');
INSERT INTO finanzas_casadepiedra.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, precios_por_dia, dias_bloqueados, etiquetas) VALUES (3, '2026-01-27 06:19:41.120497+00', '3465', 'Terraza del Mezquite', 'espacio', 'Al aire libre y enmarcada por hermosos arcos coloniales y fuentes minimalistas que ofrecen un ambiente de relajación y vistas elegantes y acogedoras. Con una capacidad para 200 personas, este lugar es el espacio ideal para eventos como despedidas de soltera, fiestas de cumpleaños, primeras comuniones, bautizos, fiestas infantiles y reuniones corporativas.

Ubicación: Por definir.
Medidas: Por definir.', NULL, 'http://127.0.0.1:55551/storage/v1/object/public/Espacios/espacios/1771267580304.png', true, 36500, 'ninguno', 0, true, '[]', '#374151', '[{"max": 150, "min": 1, "precios": {"lunes": 18000, "jueves": 18000, "martes": 18000, "sabado": 0, "domingo": 11000, "viernes": 36500, "miercoles": 18000}}]', '["sabado"]', '["Terraza", "Al aire libre", "Social"]');
INSERT INTO finanzas_casadepiedra.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, precios_por_dia, dias_bloqueados, etiquetas) VALUES (2, '2026-01-27 06:19:23.498178+00', '346543', 'Salón Pavoreales', 'espacio', 'Un salón privado, que pareciera una hermosa réplica de nuestro salón principal, con ambientación delicada y elegante y la privacidad necesaria para reuniones sociales o empresariales. Cuenta con una capacidad para 70 personas en un evento empresarial, y con un montaje estilo auditorio, la capacidad incrementa para 100 personas.

Ubicación: Por definir.
Medidas: Por definir.', NULL, 'http://127.0.0.1:55551/storage/v1/object/public/Espacios/espacios/1771267563277.png', true, 24000, 'ninguno', 0, true, '[]', '#374151', '[{"max": 90, "min": 1, "precios": {"lunes": 12000, "jueves": 12000, "martes": 12000, "sabado": 24000, "domingo": 6000, "viernes": 18000, "miercoles": 12000}}]', '[]', '["Salón", "Privado", "Empresarial"]');
INSERT INTO finanzas_casadepiedra.espacios (id, created_at, clave, nombre, tipo, descripcion, requisitos, imagen_url, activo, precio_base, ajuste_tipo, ajuste_porcentaje, activa, impuestos_ids, color, precios_por_dia, dias_bloqueados, etiquetas) VALUES (4, '2026-01-27 06:19:51.858826+00', '123412', 'Jardín Principal', 'espacio', 'Un espacio abierto, rodeado de la icónica arquitectura de la Ex-Hacienda aunado de una increíble vegetación. Cuenta con capacidad máxima para 1500 personas, es el único recinto en la ciudad de León que permite albergar a este gran número de comensales. El jardín de Casa de Piedra es el escenario perfecto para realizar eventos al aire libre en donde la naturaleza interviene como uno de los principales elementos para brindarte un ambiente encantador.

Ubicación: Por definir.
Medidas: Por definir.', NULL, 'http://127.0.0.1:55551/storage/v1/object/public/Espacios/espacios/1771267607940.png', true, 145000, 'ninguno', 0, true, '[]', '#374151', '[{"max": 300, "min": 1, "precios": {"lunes": 36000, "jueves": 36000, "martes": 36000, "sabado": 75000, "domingo": 22000, "viernes": 50000, "miercoles": 36000}}, {"max": 900, "min": 301, "precios": {"lunes": 58000, "jueves": 58000, "martes": 58000, "sabado": 110000, "domingo": 36500, "viernes": 81500, "miercoles": 58000}}, {"max": 1500, "min": 901, "precios": {"lunes": 77000, "jueves": 77000, "martes": 77000, "sabado": 145000, "domingo": 47500, "viernes": 110500, "miercoles": 77000}}]', '[]', '["Jardín", "Al aire libre", "Gran Formato"]');


ALTER TABLE finanzas_casadepiedra.espacios ENABLE TRIGGER ALL;

--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

ALTER TABLE finanzas_casadepiedra.impuestos DISABLE TRIGGER ALL;

INSERT INTO finanzas_casadepiedra.impuestos (id, nombre, porcentaje, activo, created_at, impuestos_aplicados) VALUES (1, 'IVA', 16, true, '2026-01-25 10:41:36+00', NULL);


ALTER TABLE finanzas_casadepiedra.impuestos ENABLE TRIGGER ALL;

--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles DISABLE TRIGGER ALL;

INSERT INTO public.profiles (id, email, username, role, tenant, app_metadata, created_at, updated_at, allowed_tenants) VALUES ('2d353feb-16d5-43fb-9529-d1334f4c6059', 'admin@cotizador.com', 'admin', 'admin', 'plaza_mayor', '{}', '2026-02-14 21:12:20.560271+00', '2026-02-14 21:14:51.558573+00', '{plaza_mayor,casa_de_piedra}');
INSERT INTO public.profiles (id, email, username, role, tenant, app_metadata, created_at, updated_at, allowed_tenants) VALUES ('1b099fcd-164b-49dc-af4a-c64f4b16961d', 'admin@casadepiedra.com', 'admin Casa de Piedra', 'casa_de_piedra', 'casa_de_piedra', '{}', '2026-02-16 22:36:58.182798+00', '2026-02-16 22:47:20.699165+00', '{casa_de_piedra}');
INSERT INTO public.profiles (id, email, username, role, tenant, app_metadata, created_at, updated_at, allowed_tenants) VALUES ('9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0', 'admin@plazamayor.com', 'admin plaza mayor', 'plaza_mayor', 'plaza_mayor', '{}', '2026-02-16 21:40:39.19873+00', '2026-02-16 22:47:34.161357+00', '{plaza_mayor}');


ALTER TABLE public.profiles ENABLE TRIGGER ALL;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 64, true);


--
-- Name: conceptos_catalogo_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.conceptos_catalogo_id_seq', 6, true);


--
-- Name: espacios_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.espacios_id_seq', 32, true);


--
-- Name: impuestos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.impuestos_id_seq', 2, true);


--
-- Name: conceptos_catalogo_id_seq; Type: SEQUENCE SET; Schema: finanzas_casadepiedra; Owner: postgres
--

SELECT pg_catalog.setval('finanzas_casadepiedra.conceptos_catalogo_id_seq', 4, true);


--
-- Name: espacios_id_seq; Type: SEQUENCE SET; Schema: finanzas_casadepiedra; Owner: postgres
--

SELECT pg_catalog.setval('finanzas_casadepiedra.espacios_id_seq', 4, true);


--
-- Name: impuestos_id_seq; Type: SEQUENCE SET; Schema: finanzas_casadepiedra; Owner: postgres
--

SELECT pg_catalog.setval('finanzas_casadepiedra.impuestos_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 1R0f1uIC9upbTwQd9fOib8QviOa4M55JFQbf5VQpwToXSjc6bUYWE4Iz3ZTAOB7

