USE db_proyecto;

CREATE INDEX buscar_por_documento ON personas(documento_id_documento);
CREATE INDEX buscar_por_correo ON personas(email_id_email);
CREATE INDEX ordenar_personas ON personas(apellido, nombre);
CREATE INDEX contacto_telefono ON telefono(personas_id_persona);

CREATE INDEX filtro_propiedad_tipo ON propiedad(id_tipo_propiedad);
CREATE INDEX filtro_propiedad_estado_ciudad ON propiedad(id_estado_propiedad, id_ciudad);

CREATE INDEX fk_contrato_cliente ON contrato(cliente_id);
CREATE INDEX fk_contrato_agente ON contrato(agente_id);
CREATE INDEX fk_contrato_propiedad ON contrato(propiedad_id);
CREATE INDEX contrato_rango_fechas ON contrato(fecha_inicio, fecha_fin);

CREATE INDEX fk_factura_contrato ON factura(contrato_id);
CREATE INDEX fk_pago_factura ON pago(factura_id);
CREATE INDEX pago_rango_temporal ON pago(fecha_pago, monto);