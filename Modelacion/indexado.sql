-- 1. Optimización en Personas y sus relaciones
CREATE INDEX persona_documento ON personas(documento_id_documento);
CREATE INDEX persona_email ON personas(email_id_email);
CREATE INDEX telefono_persona ON telefono(personas_id_person
-- 2. Optimizn en Propiedades (Muy importante para búsquedas de clientes)
-- Índice comto para filtrar por ciudad y estado rápidamente
CREATE INDEX propiedad_ciudad_estado ON propiedad(id_ciudad, id_estado_propiedad);
CREATE INDEX propiedad_tipo ON propiedad(id_tipo_propieda)
-- 3. Optimizn en Contratos (Crucial para reportes y facturación)
CREATE INDEX contrato_cliente ON contrato(cliente_id);
CREATE INDEX contrato_agente ON contrato(agente_id);
CREATE INDEX contrato_propiedad ON contrato(propiedad_i)
-- 4. Optimizn en Facturación y Pagos
CREATE INDEX factura_contrato ON factura(contrato_id);
CREATE INDEX pago_factura ON pago(factura_id);
CREATE INDEX pago_fecha ON pago(fecha_pago);