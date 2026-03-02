-- 1. Tabla de reporte (estructura equivalente)
CREATE TABLE reporte_mensual (
    id_reporte INT NOT NULL AUTO_INCREMENT,
    fecha_pago DATETIME NOT NULL,
    contrato_id INT NOT NULL,
    saldo_pendiente DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_reporte)
);

DELIMITER $$

CREATE EVENT control_mensual_saldos
ON SCHEDULE
    EVERY 1 MONTH
    STARTS (
        DATE_ADD(
            LAST_DAY(CURRENT_DATE),
            INTERVAL 1 DAY
        )
    )
DO
BEGIN
    DECLARE fecha_actual DATETIME;

    SET fecha_actual = NOW();

    INSERT INTO reporte_mensual (
        fecha_pago,
        contrato_id,
        saldo_pendiente
    )
    SELECT
        fecha_actual,
        c.id_contrato,
        deuda_calculada.saldo
    FROM contrato c
    INNER JOIN (
        SELECT
            id_contrato,
            fn_calcular_deuda(id_contrato) AS saldo
        FROM contrato
    ) AS deuda_calculada
        ON c.id_contrato = deuda_calculada.id_contrato
    WHERE deuda_calculada.saldo > 0;
END$$

DELIMITER ;