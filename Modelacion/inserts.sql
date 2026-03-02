USE db_proyecto;

-- =====================================================
-- 1. PERSONAS Y CONTACTO
-- =====================================================

-- Documentos
INSERT INTO documento (tipo, numero) VALUES
('CC',  '10'),
('CC',  '20'),
('CE',  '30'),
('NIT', '40'),
('PAS', '50');

-- Emails
INSERT INTO email (dominio, nombre_email) VALUES
('gmail.com',   'manuel.l'),
('outlook.com', 'ximena.a'),
('yahoo.com',   'wendy.v'),
('hotmail.com', 'alejo.e'),
('icloud.com',  'tomas.m');

-- Personas (ESTE BLOQUE SE MANTIENE IGUAL EN NOMBRES)
INSERT INTO personas (nombre, apellido, documento_id_documento, email_id_email) VALUES
('Manuel',    'Lahitton',  1, 1),
('Ximena',    'Afanador',  2, 2),
('Wendy',     'Vega',      3, 3),
('Alejandro', 'Escobar',   4, 4),
('Tomas',     'Medina',    5, 5);

-- Teléfonos
INSERT INTO telefono (codigo, numero, tipo_telefono, personas_id_persona) VALUES
('+57', '3110001', 'Movil', 1),
('+57', '3220002', 'Fijo',  2),
('+57', '3330003', 'Movil', 3),
('+57', '3440004', 'Movil', 4),
('+57', '3550005', 'Fijo',  5);

-- Clientes
INSERT INTO cliente (id_cliente) VALUES
(1), (2), (3), (4), (5);

-- Agentes
INSERT INTO agente (id_agente, comision) VALUES
(1, 6.50),
(2, 5.25),
(3, 4.00),
(4, 7.00),
(5, 5.50);

-- =====================================================
-- 2. CATÁLOGOS DE PROPIEDADES Y OPERACIONES
-- =====================================================

INSERT INTO tipo_propiedad (nombre) VALUES
('casas'),
('apartamentos'),
('locales');

INSERT INTO estado_propiedad (nombre) VALUES
('disponible'),
('arrendada'),
('vendida');

INSERT INTO ciudad (nombre) VALUES
('Bogotá'),
('Cali'),
('Medellín'),
('Santa Marta'),
('Pereira');

INSERT INTO tipo_contrato (nombre) VALUES
('venta'),
('arriendo');

INSERT INTO estado_factura (nombre) VALUES
('pagado'),
('pendiente');

INSERT INTO tipo_pago (nombre) VALUES
('efectivo'),
('transferencia'),
('tarjeta'),
('consignación');

-- =====================================================
-- 3. PROPIEDADES
-- =====================================================

INSERT INTO propiedad (direccion, precio, id_tipo_propiedad, id_estado_propiedad, id_ciudad) VALUES
('Carrera 10 #12-30', 420000000.00, 1, 1, 1),
('Av Siempre Viva 45', 180000000.00, 2, 2, 2),
('Centro Empresarial Norte', 910000000.00, 3, 3, 3),
('Conjunto Sol y Mar', 260000000.00, 1, 1, 4),
('Zona Comercial Plaza', 350000000.00, 2, 2, 5);

-- =====================================================
-- 4. CONTRATOS
-- =====================================================

INSERT INTO contrato (
    tipo_contrato_id,
    propiedad_id,
    fecha_inicio,
    fecha_fin,
    total,
    cliente_id,
    agente_id
) VALUES
(2, 1, '2025-03-01', '2026-03-01', 420000000.00, 1, 1),
(1, 2, '2025-04-15', '2026-04-15', 180000000.00, 2, 2),
(2, 3, '2025-05-10', '2026-05-10', 910000000.00, 3, 3),
(1, 4, '2025-06-01', '2027-06-01', 260000000.00, 4, 4),
(2, 5, '2025-07-20', '2026-07-20', 350000000.00, 5, 5);

-- =====================================================
-- 5. FACTURACIÓN
-- =====================================================

INSERT INTO factura (contrato_id, estado_factura_id, fecha_emision) VALUES
(1, 2, '2025-03-05'),
(2, 1, '2025-04-20'),
(3, 2, '2025-05-15'),
(4, 1, '2025-06-10'),
(5, 2, '2025-07-25');

-- =====================================================
-- 6. PAGOS
-- =====================================================

INSERT INTO pago (factura_id, tipo_pago_id, monto, fecha_pago) VALUES
(1, 2, 0.00,            NULL),
(2, 1, 180000000.00, '2025-04-25'),
(3, 3, 0.00,            NULL),
(4, 4, 260000000.00, '2025-06-15'),
(5, 2, 0.00,            NULL);