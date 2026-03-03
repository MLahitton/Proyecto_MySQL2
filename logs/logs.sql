USE db_proyecto;

DELIMITER //


CREATE PROCEDURE escribir_log(
    IN p_tabla VARCHAR(45),
    IN p_origen VARCHAR(45),
    IN p_tipo_accion VARCHAR(45),
    IN p_detalle TEXT
)
BEGIN
    INSERT INTO logs (tabla_afectada, procedimiento, accion, descripcion, fecha_registro)
    VALUES (
        p_tabla,
        p_origen,
        p_tipo_accion,
        CONCAT('[', CURRENT_USER(), '] ', p_detalle),
        NOW()
    );
END //



CREATE TRIGGER al_registrar_propiedad
AFTER INSERT ON propiedad
FOR EACH ROW
BEGIN
    DECLARE nombre_ciudad VARCHAR(45);

    SELECT nombre INTO nombre_ciudad
    FROM ciudad
    WHERE id_ciudad = NEW.id_ciudad;

    CALL escribir_log(
        'propiedad',
        'al_registrar_propiedad',
        'INSERT',
        CONCAT(
            'Nueva propiedad en ', COALESCE(nombre_ciudad, 'ciudad desconocida'),
            ': "', NEW.direccion, '"',
            ' | Precio: $', FORMAT(NEW.precio, 0),
            ' | ID: ', NEW.id_propiedad
        )
    );
END //

DELIMITER ;