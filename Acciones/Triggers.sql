DELIMITER $$

CREATE TRIGGER trg_auditoria_estado_propiedad
AFTER UPDATE ON propiedad
FOR EACH ROW
BEGIN
    IF OLD.id_estado_propiedad <> NEW.id_estado_propiedad THEN
        INSERT INTO logs (
            tabla_afectada,
            procedimiento,
            accion,
            descripcion,
            fecha_registro
        )
        VALUES (
            'propiedad',
            'UPDATE_ESTADO',
            'CAMBIO_ESTADO',
            CONCAT(
                'Propiedad ',
                OLD.id_propiedad,
                ' cambió de estado ',
                OLD.id_estado_propiedad,
                ' a ',
                NEW.id_estado_propiedad
            ),
            NOW()
        );
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_registro_nuevo_contrato
AFTER INSERT ON contrato
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        tabla_afectada,
        procedimiento,
        accion,
        descripcion,
        fecha_registro
    )
    VALUES (
        'contrato',
        'INSERT_CONTRATO',
        'NUEVO_CONTRATO',
        CONCAT(
            'Se creó el contrato ',
            NEW.id_contrato,
            ' para la propiedad ',
            NEW.propiedad_id
        ),
        NOW()
    );
END$$

DELIMITER ;