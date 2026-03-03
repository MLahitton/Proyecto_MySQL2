USE db_proyecto;

DELIMITER $$

CREATE TRIGGER vigilar_propiedad
BEFORE UPDATE ON propiedad
FOR EACH ROW
BEGIN
    DECLARE cambio_detectado BOOLEAN DEFAULT FALSE;
    DECLARE resumen TEXT DEFAULT '';

    SET cambio_detectado = (OLD.id_estado_propiedad != NEW.id_estado_propiedad);

    IF cambio_detectado THEN
        SET resumen = JSON_OBJECT(
            'propiedad_id', OLD.id_propiedad,
            'direccion', OLD.direccion,
            'estado_previo', (SELECT nombre FROM estado_propiedad WHERE id_estado_propiedad = OLD.id_estado_propiedad),
            'estado_actual', (SELECT nombre FROM estado_propiedad WHERE id_estado_propiedad = NEW.id_estado_propiedad),
            'ciudad', (SELECT nombre FROM ciudad WHERE id_ciudad = OLD.id_ciudad),
            'momento', NOW()
        );

        CALL escribir_log(
            'propiedad',
            'vigilar_propiedad',
            'CAMBIO_ESTADO',
            resumen
        );
    END IF;
END$$


CREATE TRIGGER capturar_contrato
BEFORE INSERT ON contrato
FOR EACH ROW
BEGIN
    DECLARE info TEXT DEFAULT '';
    DECLARE dias_duracion INT DEFAULT 0;

    SET dias_duracion = DATEDIFF(NEW.fecha_fin, NEW.fecha_inicio);

    SET info = JSON_OBJECT(
        'contrato_id', NEW.id_contrato,
        'cliente', (
            SELECT CONCAT_WS(' ', p.nombre, p.apellido)
            FROM personas p
            WHERE p.id_persona = NEW.cliente_id
        ),
        'agente', (
            SELECT CONCAT_WS(' ', p.nombre, p.apellido)
            FROM personas p
            WHERE p.id_persona = NEW.agente_id
        ),
        'propiedad', (
            SELECT JSON_OBJECT('direccion', pr.direccion, 'ciudad', c.nombre)
            FROM propiedad pr
            INNER JOIN ciudad c ON pr.id_ciudad = c.id_ciudad
            WHERE pr.id_propiedad = NEW.propiedad_id
        ),
        'modalidad', (
            SELECT nombre
            FROM tipo_contrato
            WHERE id_tipo_contrato = NEW.tipo_contrato_id
        ),
        'valor_total', NEW.total,
        'duracion_dias', dias_duracion,
        'vigencia', JSON_OBJECT(
            'desde', DATE_FORMAT(NEW.fecha_inicio, '%d/%m/%Y'),
            'hasta', DATE_FORMAT(NEW.fecha_fin, '%d/%m/%Y')
        )
    );

    CALL escribir_log(
        'contrato',
        'capturar_contrato',
        'REGISTRO',
        info
    );
END$$

DELIMITER ;