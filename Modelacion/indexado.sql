CREATE INDEX persona_documento ON personas(documento_id_documento);
CREATE INDEX persona_email ON personas(email_id_email);
CREATE INDEX telefono_persona ON telefono(personas_id_persona)
CREATE INDEX personas_nombre ON personas (nombre);CREATE INDEX propiedad_ciudad_estado ON propiedad(id_ciudad, id_estado_propiedad);
CREATE INDEX propiedad_tipo ON propiedad(id_tipo_propieda)
CREATE INDEX contrato_cliente ON contrato(cliente_id);
CREATE INDEX contrato_agente ON contrato(agente_id);
CREATE INDEX contrato_propiedad ON contrato(propiedad_id)
CREATE INDEX factura_contrato ON factura(contrato_id);
CREATE INDEX pago_factura ON pago(factura_id);
CREATE INDEX pago_fecha ON pago(fecha_pago);