USE db_proyecto;


CREATE VIEW catalogo_propiedades AS
SELECT
    p.id_propiedad,
    p.direccion,
    FORMAT(p.precio, 0) AS precio_formateado,
    tp.nombre AS tipo,
    ep.nombre AS estado,
    c.nombre AS ciudad,
    CASE
        WHEN co.id_contrato IS NOT NULL THEN 'Si'
        ELSE 'No'
    END AS tiene_contrato,
    COALESCE(CONCAT(pa.nombre, ' ', pa.apellido), 'Sin asignar') AS agente_asignado
FROM propiedad p
INNER JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id_tipo_propiedad
INNER JOIN estado_propiedad ep ON p.id_estado_propiedad = ep.id_estado_propiedad
INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad
LEFT JOIN contrato co ON p.id_propiedad = co.propiedad_id
LEFT JOIN personas pa ON co.agente_id = pa.id_persona;


CREATE VIEW resumen_contratos AS
SELECT
    co.id_contrato,
    tc.nombre AS modalidad,
    p.direccion AS propiedad,
    CONCAT(pc.nombre, ' ', pc.apellido) AS cliente,
    CONCAT(pa.nombre, ' ', pa.apellido) AS agente,
    co.fecha_inicio,
    co.fecha_fin,
    co.total,
    DATEDIFF(co.fecha_fin, CURRENT_DATE) AS dias_restantes,
    COALESCE(pagos.pagado, 0) AS total_pagado,
    ROUND(COALESCE(pagos.pagado, 0) / co.total * 100, 1) AS porcentaje_pagado
FROM contrato co
INNER JOIN tipo_contrato tc ON co.tipo_contrato_id = tc.id_tipo_contrato
INNER JOIN propiedad p ON co.propiedad_id = p.id_propiedad
INNER JOIN personas pc ON co.cliente_id = pc.id_persona
INNER JOIN personas pa ON co.agente_id = pa.id_persona
LEFT JOIN (
    SELECT f.contrato_id, SUM(pg.monto) AS pagado
    FROM pago pg
    INNER JOIN factura f ON pg.factura_id = f.id_factura
    WHERE pg.monto > 0
    GROUP BY f.contrato_id
) pagos ON co.id_contrato = pagos.contrato_id;


CREATE VIEW estado_financiero AS
SELECT
    co.id_contrato,
    co.total AS valor_total,
    COALESCE(pagos.total_pagado, 0) AS pagado,
    co.total - COALESCE(pagos.total_pagado, 0) AS pendiente,
    CASE
        WHEN co.total - COALESCE(pagos.total_pagado, 0) <= 0 THEN 'Al dia'
        WHEN co.total - COALESCE(pagos.total_pagado, 0) < co.total * 0.5 THEN 'Deuda baja'
        ELSE 'Deuda alta'
    END AS clasificacion
FROM contrato co
LEFT JOIN (
    SELECT f.contrato_id, SUM(pg.monto) AS total_pagado
    FROM pago pg
    INNER JOIN factura f ON pg.factura_id = f.id_factura
    WHERE pg.monto > 0
    GROUP BY f.contrato_id
) pagos ON co.id_contrato = pagos.contrato_id;