--
-- PostgreSQL database dump
--

\restrict a7jWMe59lsUrb51vP7aQqdrQfAqy1j8mFOuctbKlWXqWGlw9NUebCJBHVuaw8WZ

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
-- Data for Name: clientes; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO finanzas.clientes (id, nombre_completo, telefono, correo, rfc, created_at, updated_at) VALUES ('2997e5c2-62c3-40ec-8c1f-1da0c20380ae', 'Johan Jacob Paz Valadez', '4771631661', 'johan_paz@hotmail.es', 'PAVJ011113PB6', '2026-01-26 23:37:50.548335+00', '2026-01-26 23:37:50.548335+00');


--
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (1, 'Limpieza', 0, true, '2025-12-19 08:29:59.031025+00');
INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (3, 'Mobiliario', 0, true, '2025-12-19 08:30:57.056834+00');
INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (4, 'Seguridad', 500, true, '2025-12-19 08:31:41.47937+00');
INSERT INTO finanzas.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (5, 'Instalación', 0, true, '2025-12-19 08:36:01.791921+00');


--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

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


--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('539b8961-8237-45ed-85eb-0b7eec808ee1', '2026-02-22 00:55:17.325073+00', NULL, 10, 'Antepecho pasillo a C&A', 'Z 2-1', 'Johan Jacob Paz Valadez', '', '345345', '345', NULL, '2026-02-21', '2026-02-28', 64611.99999999999, '{"tax_total": 8911.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 55700}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);
INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('27bbfb0a-4e36-474e-b380-c1f6b5a590ef', '2026-02-22 01:04:14.315613+00', NULL, 10, 'Antepecho pasillo a C&A', 'Z 2-1', 'Johan Paz', '', '4774440417', 'arris14b2@gmail.com', NULL, '2026-02-27', '2026-02-27', 64611.99999999999, '{"tax_total": 8911.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 55700}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);
INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('ddb6ce65-38a9-46cc-b543-f9f98f77b03b', '2026-02-22 01:32:33.556743+00', NULL, 10, 'Antepecho pasillo a C&A', 'Z 2-1', 'Mónica Hernández Gutiérrez', '', '4791041881', 'piki_sandia@outlook.com', NULL, '2026-02-24', '2026-02-25', 64611.99999999999, '{"tax_total": 8911.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 55700}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);
INSERT INTO finanzas.cotizaciones (id, created_at, creado_por, espacio_id, espacio_nombre, espacio_clave, cliente_nombre, cliente_rfc, cliente_contacto, cliente_email, cliente_telefono, fecha_inicio, fecha_fin, precio_final, desglose_precios, status, numero_orden, numero_contrato, factura_pdf_url, factura_xml_url, contrato_url, url_cotizacion_final, url_orden_compra, fecha_orden_compra, datos_fiscales, conceptos_adicionales, tipo_ajuste, valor_ajuste, ajuste_es_porcentaje, desglose_impuestos, historial_pagos, datos_factura, cliente_id) VALUES ('cf60b7ab-31b2-4ce4-83e1-cb1ecd3bab4d', '2026-02-22 01:37:46.508813+00', NULL, 8, 'Ave en Domo Suburbia', 'Z1-3', 'Andrea Alcantar', '', '4727385294', 'andrea_tienda99@outlook.com', NULL, '2026-02-28', '2026-02-28', 56839.99999999999, '{"tax_total": 7839.999999999993, "impuestos_detalle": [], "subtotal_antes_impuestos": 49000}', 'pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', '[]', 'ninguno', 0, false, '[]', '[]', '{}', NULL);


--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

INSERT INTO finanzas.impuestos (id, nombre, porcentaje, activo, created_at, impuestos_aplicados) VALUES (1, 'IVA', 16, true, '2025-12-20 05:00:37.668293+00', NULL);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

INSERT INTO finanzas_casadepiedra.clientes (id, nombre_completo, telefono, correo, rfc, created_at, updated_at) VALUES ('b51df6c1-e0f1-4860-904d-8b03cd055d79', 'Johan Jacob Paz Valadez', '4771631661', 'johanjacobpazvaladez@gmail.com', 'PAVJ011113PB6', '2026-01-26 23:50:37.517036+00', '2026-01-26 23:50:37.517036+00');
INSERT INTO finanzas_casadepiedra.clientes (id, nombre_completo, telefono, correo, rfc, created_at, updated_at) VALUES ('a3299bd7-16d6-45aa-b187-8a5856697255', 'Emma Valadez Medina', '4772309481', 'adsasdasd@asdads.com', 'PAVJ011113PB4', '2026-02-12 05:24:40.57242+00', '2026-02-12 05:24:40.57242+00');


--
-- Data for Name: conceptos_catalogo; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (1, 'Limpieza', 0, true, '2026-01-27 03:55:21+00');
INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (2, 'Seguridad', 0, true, '2026-01-27 03:55:31+00');
INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (3, 'Carpa SANMARINO', 100, true, '2026-01-27 03:55:45+00');
INSERT INTO finanzas_casadepiedra.conceptos_catalogo (id, nombre, precio_sugerido, activo, created_at) VALUES (4, 'Generador de energía', 0, true, '2026-01-27 03:55:58+00');


--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--



--
-- Data for Name: espacios; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

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


--
-- Data for Name: impuestos; Type: TABLE DATA; Schema: finanzas_casadepiedra; Owner: postgres
--

INSERT INTO finanzas_casadepiedra.impuestos (id, nombre, porcentaje, activo, created_at, impuestos_aplicados) VALUES (1, 'IVA', 16, true, '2026-01-25 10:41:36+00', NULL);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.profiles (id, email, username, role, tenant, app_metadata, created_at, updated_at, allowed_tenants) VALUES ('2d353feb-16d5-43fb-9529-d1334f4c6059', 'admin@cotizador.com', 'admin', 'admin', 'plaza_mayor', '{}', '2026-02-14 21:12:20.560271+00', '2026-02-14 21:14:51.558573+00', '{plaza_mayor,casa_de_piedra}');
INSERT INTO public.profiles (id, email, username, role, tenant, app_metadata, created_at, updated_at, allowed_tenants) VALUES ('1b099fcd-164b-49dc-af4a-c64f4b16961d', 'admin@casadepiedra.com', 'admin Casa de Piedra', 'casa_de_piedra', 'casa_de_piedra', '{}', '2026-02-16 22:36:58.182798+00', '2026-02-16 22:47:20.699165+00', '{casa_de_piedra}');
INSERT INTO public.profiles (id, email, username, role, tenant, app_metadata, created_at, updated_at, allowed_tenants) VALUES ('9eccd179-b0b6-4ee1-b37a-f9fb2e1771a0', 'admin@plazamayor.com', 'admin plaza mayor', 'plaza_mayor', 'plaza_mayor', '{}', '2026-02-16 21:40:39.19873+00', '2026-02-16 22:47:34.161357+00', '{plaza_mayor}');


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

\unrestrict a7jWMe59lsUrb51vP7aQqdrQfAqy1j8mFOuctbKlWXqWGlw9NUebCJBHVuaw8WZ

