USE db_proyecto;

DELIMITER //

CREATE PROCEDURE registrar_propiedad_segura(
    IN p_direccion VARCHAR(100),
    IN p_precio DECIMAL(12,2),
    IN p_tipo INT,
    IN p_estado INT,
    IN p_ciudad INT
)
BEGIN
    DECLARE error_sql CHAR(5);
    DECLARE codigo_sql INT;
    DECLARE mensaje_sql TEXT;
    DECLARE existe INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            error_sql = RETURNED_SQLSTATE,
            codigo_sql = MYSQL_ERRNO,
            mensaje_sql = MESSAGE_TEXT;

        INSERT INTO logs_error (
            tabla_afectada, procedimiento, tipo_objeto,
            codigo_error, mensaje, fecha_registro
        )
        VALUES (
            'propiedad',
            'registrar_propiedad_segura',
            'PROCEDURE',
            codigo_sql,
            mensaje_sql,
            NOW()
        );

        RESIGNAL;
    END;

    IF p_precio <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio de la propiedad debe ser mayor a cero';
    END IF;

    IF p_direccion IS NULL OR TRIM(p_direccion) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La direccion no puede estar vacia';
    END IF;

    SELECT COUNT(*) INTO existe FROM tipo_propiedad WHERE id_tipo_propiedad = p_tipo;
    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de propiedad indicado no existe';
    END IF;

    SET existe = 0;
    SELECT COUNT(*) INTO existe FROM ciudad WHERE id_ciudad = p_ciudad;
    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La ciudad indicada no existe en el sistema';
    END IF;

    INSERT INTO propiedad (direccion, precio, id_tipo_propiedad, id_estado_propiedad, id_ciudad)
    VALUES (p_direccion, p_precio, p_tipo, p_estado, p_ciudad);

END //

DELIMITER ;