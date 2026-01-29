SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict ObPs1fAMnc7tQF8HHRuNLnTATHh9od4wuVif5DrIFsg5LvjgtwZs0S0TDAZDPoy

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
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO "finanzas"."conceptos_catalogo" ("id", "nombre", "precio_sugerido", "activo", "created_at") VALUES
	(2, 'Modificación manual', 0, true, '2025-12-19 08:30:52.173681+00'),
	(5, 'Instalación', 500, true, '2025-12-19 08:36:01.791921+00'),
	(1, 'Limpieza', 300, true, '2025-12-19 08:29:59.031025+00'),
	(3, 'Mobiliario', 600, true, '2025-12-19 08:30:57.056834+00'),
	(4, 'Seguridad', 250, true, '2025-12-19 08:31:41.47937+00'),
	(6, 'Nuevo', 5000, true, '2026-01-14 22:45:00.942779+00');


--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas; Owner: postgres
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
	(29, '2026-01-06 03:49:29.561186+00', 'L1', 'prueba de local', 'local', 'prueba', NULL, NULL, true, 10000, 'ninguno', 0, true, '[2]', '#025ef2'),
	(30, '2026-01-06 03:49:57.316351+00', 'I1', 'Prueba de isla', 'isla', 'prueba', NULL, NULL, true, 9999, 'ninguno', 0, true, '[]', '#374151'),
	(31, '2026-01-06 03:50:55.607418+00', 'E1', 'Prueba de espacio', 'espacio', 'prueba', NULL, NULL, true, 10000, 'ninguno', 0, false, '[1, 2]', '#374151');


--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO "finanzas"."cotizaciones" ("id", "created_at", "creado_por", "espacio_id", "espacio_nombre", "espacio_clave", "cliente_nombre", "cliente_rfc", "cliente_contacto", "fecha_inicio", "fecha_fin", "precio_final", "desglose_precios", "status", "cliente_email", "numero_orden", "numero_contrato", "factura_pdf_url", "factura_xml_url", "datos_fiscales", "conceptos_adicionales", "tipo_ajuste", "valor_ajuste", "ajuste_es_porcentaje", "desglose_impuestos", "historial_pagos", "cliente_telefono", "contrato_url", "datos_factura", "url_cotizacion_final", "url_orden_compra", "fecha_orden_compra") VALUES
	('0f7b5881-5fbf-4a72-8a4c-0be18049936b', '2026-01-12 22:05:28.177469+00', 'b6086cb7-5ed6-4abe-bc5b-e2f7821a21cf', 30, 'Prueba de isla', 'I1', 'Pedro', 'werwerwerwe', '4771234567', '2026-01-05', '2026-02-01', 9999, '{"impuestos_detalle": [], "subtotal_antes_impuestos": 9999}', 'finalizada', 'prueba@prueba.com.mx', 'ORD-20260112-3557', '121354', '0f7b5881-5fbf-4a72-8a4c-0be18049936b/facturas/1768255938622_factura.pdf', '0f7b5881-5fbf-4a72-8a4c-0be18049936b/facturas/1768255938622_factura.xml', '{"razon_social": "JOHAN JACOB PAZ VALADEZ", "rfc_receptor": "PAVJ011113PB6", "uuid_factura": "c762f894-a03d-4ccb-8efc-7574eade43af"}', '[]', 'ninguno', 0, false, '[]', '[{"bank": "BBVA Bancomer", "date": "2026-01-12T22:09:34.294Z", "amount": 5600, "account": "0123456789", "concept": "Pago 1 / Prueba de isla", "file_path": "0f7b5881-5fbf-4a72-8a4c-0be18049936b/recibos/Recibo_ORD-20260112-3557_1768255773287.pdf", "reference": "ORD-20260112-3557"}, {"bank": "BBVA Bancomer", "date": "2026-01-12T22:09:50.491Z", "amount": 4399, "account": "0123456789", "concept": "Pago 2 / Prueba de isla", "file_path": "0f7b5881-5fbf-4a72-8a4c-0be18049936b/recibos/Recibo_ORD-20260112-3557_1768255789397.pdf", "reference": "ORD-20260112-3557"}]', NULL, '0f7b5881-5fbf-4a72-8a4c-0be18049936b/1768255738677_contrato_firmado.pdf', '{"rfc": "PAVJ011113PB6", "uuid": "c762f894-a03d-4ccb-8efc-7574eade43af", "total": 9999, "nombre": "JOHAN JACOB PAZ VALADEZ"}', '0f7b5881-5fbf-4a72-8a4c-0be18049936b/cotizacion_aprobada_1768255571587.pdf', NULL, NULL),
	('4e12da0e-32e8-4c6c-86e5-e4db1a5a843c', '2026-01-14 22:43:29.440916+00', NULL, 14, 'Espectacular sobre balcón Sears', 'Z3-12', 'IYUOIÑHIO', '', '4771631661', '2026-01-05', '2026-01-23', 52200, '{"pct": 0, "base": 45000, "type": "ninguno", "tax_total": 7200}', 'pendiente', 'infopmayor@gmail.com', NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', NULL, NULL, '{}', NULL, NULL, NULL),
	('0a4c272b-9f04-44f3-ba4a-d15e00053908', '2026-01-14 22:26:05.382412+00', '148e502e-5204-4287-9570-bc4e48b2f054', 30, 'Prueba de isla', 'I1', 'Prueba', 'jñjlkjlk', '4771631661', '2026-02-02', '2026-02-02', 9999, '{"impuestos_detalle": [], "subtotal_antes_impuestos": 9999}', 'finalizada', 'mkasdm@akmsdkam.com', 'ORD-20260114-5473', '1156548', '0a4c272b-9f04-44f3-ba4a-d15e00053908/facturas/1768429983186_factura.pdf', '0a4c272b-9f04-44f3-ba4a-d15e00053908/facturas/1768429983186_factura.xml', '{"razon_social": "JOHAN JACOB PAZ VALADEZ", "rfc_receptor": "PAVJ011113PB6", "uuid_factura": "c762f894-a03d-4ccb-8efc-7574eade43af"}', '[]', 'ninguno', 0, false, '[]', '[{"bank": "Santander", "date": "2026-01-14T22:29:03.676Z", "amount": 5000, "account": "12355616510", "concept": "Pago 1 / Prueba de isla", "file_path": "0a4c272b-9f04-44f3-ba4a-d15e00053908/recibos/Recibo_ORD-20260114-5473_1768429741224.pdf", "reference": "ORD-20260114-5473"}, {"bank": "BBVA ", "date": "2026-01-14T22:29:32.005Z", "amount": 4999, "account": "12355616510", "concept": "Pago 2 / Prueba de isla", "file_path": "0a4c272b-9f04-44f3-ba4a-d15e00053908/recibos/Recibo_ORD-20260114-5473_1768429770132.pdf", "reference": "ORD-20260114-5473"}]', NULL, '0a4c272b-9f04-44f3-ba4a-d15e00053908/1768429924838_contrato_firmado.pdf', '{"rfc": "PAVJ011113PB6", "uuid": "c762f894-a03d-4ccb-8efc-7574eade43af", "total": 9999, "nombre": "JOHAN JACOB PAZ VALADEZ"}', '0a4c272b-9f04-44f3-ba4a-d15e00053908/cotizacion_aprobada_1768429680165.pdf', NULL, NULL);


--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO "finanzas"."impuestos" ("id", "nombre", "porcentaje", "activo", "created_at", "impuestos_aplicados") VALUES
	(1, 'IVA', 16, true, '2025-12-20 05:00:37.668293+00', NULL),
	(2, 'ISR', 15, true, '2025-12-22 23:57:37.817488+00', NULL);


--
-- Name: conceptos_catalogo_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('"finanzas"."conceptos_catalogo_id_seq"', 6, true);


--
-- Name: espacios_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('"finanzas"."espacios_id_seq"', 31, true);


--
-- Name: impuestos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('"finanzas"."impuestos_id_seq"', 2, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict ObPs1fAMnc7tQF8HHRuNLnTATHh9od4wuVif5DrIFsg5LvjgtwZs0S0TDAZDPoy

RESET ALL;
