DELIMITER $$

CREATE PROCEDURE registrar_propiedad (
    IN v_direccion VARCHAR(100),
    IN v_precio DECIMAL(15,2),
    IN v_tipo_propiedad INT,
    IN v_estado_propiedad INT,
    IN v_ciudad INT
)
BEGIN
    -- Variables para captura de error
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errno INT;
    DECLARE v_mensaje TEXT;

    -- Manejador de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate = RETURNED_SQLSTATE,
            v_errno    = MYSQL_ERRNO,
            v_mensaje  = MESSAGE_TEXT;

        INSERT INTO logs_error (
            tabla_afectada,
            procedimiento,
            tipo_objeto,
            codigo_error,
            mensaje,
            fecha_registro
        )
        VALUES (
            'propiedad',
            'sp_registrar_propiedad_controlado',
            'PROCEDURE',
            v_errno,
            v_mensaje,
            NOW()
        );

        RESIGNAL;
    END;

    -- Inserción principal
    INSERT INTO propiedad (
        direccion,
        precio,
        id_tipo_propiedad,
        id_estado_propiedad,
        id_ciudad
    )
    VALUES (
        v_direccion,
        v_precio,
        v_tipo_propiedad,
        v_estado_propiedad,
        v_ciudad
    );

END$$

DELIMITER ;