DELIMITER $$

CREATE FUNCTION fn_obtener_comision_agente (
    p_contrato INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE monto_total DECIMAL(12,2);
    DECLARE porcentaje DECIMAL(5,2);

    IF NOT EXISTS (
        SELECT 1
        FROM contrato
        WHERE id_contrato = p_contrato
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contrato no existe';
    END IF;

    SELECT c.total, a.comision
    INTO monto_total, porcentaje
    FROM contrato c
    INNER JOIN agente a
        ON c.agente_id = a.id_agente
    WHERE c.id_contrato = p_contrato;

    RETURN monto_total * porcentaje / 100;
END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION fn_deuda_contrato (
    p_contrato_id INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total_contrato DECIMAL(12,2);
    DECLARE total_pagado DECIMAL(12,2);

    SELECT total
    INTO total_contrato
    FROM contrato
    WHERE id_contrato = p_contrato_id;

    IF total_contrato IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contrato no válido';
    END IF;

    SELECT COALESCE(SUM(p.monto), 0)
    INTO total_pagado
    FROM pago p
    WHERE p.factura_id IN (
        SELECT f.id_factura
        FROM factura f
        WHERE f.contrato_id = p_contrato_id
    );

    RETURN total_contrato - total_pagado;
END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION fn_total_propiedades_libres (
    p_tipo_propiedad INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM propiedad pr
        WHERE pr.id_tipo_propiedad = p_tipo_propiedad
        AND pr.id_estado_propiedad = 1
    );
END$$

DELIMITER ;