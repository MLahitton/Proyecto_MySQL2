USE db_proyecto;

DELIMITER //


CREATE FUNCTION calcular_comision(p_id_contrato INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE valor_contrato DECIMAL(12,2) DEFAULT 0;
    DECLARE pct_agente DECIMAL(5,2) DEFAULT 0;
    DECLARE pct_final DECIMAL(5,2) DEFAULT 0;

    SELECT c.total, a.comision
    INTO valor_contrato, pct_agente
    FROM contrato c
    INNER JOIN agente a ON c.agente_id = a.id_agente
    WHERE c.id_contrato = p_id_contrato;

    IF valor_contrato IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El contrato indicado no existe';
    END IF;

    SET pct_final = CASE
        WHEN pct_agente > 10.00 THEN 10.00
        ELSE pct_agente
    END;

    RETURN ROUND(valor_contrato * pct_final / 100, 2);
END //




CREATE FUNCTION calcular_deuda(p_id_contrato INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE existe INT DEFAULT 0;
    DECLARE deuda_total DECIMAL(12,2) DEFAULT 0;
    DECLARE valor_contrato DECIMAL(12,2) DEFAULT 0;
    DECLARE total_pagado DECIMAL(12,2) DEFAULT 0;

    SELECT COUNT(*) INTO existe
    FROM contrato
    WHERE id_contrato = p_id_contrato;

    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontro el contrato';
    END IF;

    SELECT total INTO valor_contrato
    FROM contrato
    WHERE id_contrato = p_id_contrato;

    SELECT COALESCE(SUM(p.monto), 0) INTO total_pagado
    FROM pago p
    INNER JOIN factura f ON p.factura_id = f.id_factura
    WHERE f.contrato_id = p_id_contrato
    AND p.monto > 0;

    SET deuda_total = valor_contrato - total_pagado;

    IF deuda_total < 0 THEN
        SET deuda_total = 0;
    END IF;

    RETURN deuda_total;
END //



CREATE FUNCTION disponibles_por_tipo(p_tipo INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE tipo_existe INT DEFAULT 0;
    DECLARE cantidad INT DEFAULT 0;

    SELECT COUNT(*) INTO tipo_existe
    FROM tipo_propiedad
    WHERE id_tipo_propiedad = p_tipo;

    IF tipo_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de propiedad no existe en el catalogo';
    END IF;

    SELECT COUNT(*) INTO cantidad
    FROM propiedad
    WHERE id_tipo_propiedad = p_tipo
    AND id_estado_propiedad = 1;

    RETURN cantidad;
END //

DELIMITER ;