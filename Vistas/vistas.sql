CREATE VIEW vw_propiedades_resumen AS
SELECT
    pr.id_propiedad,
    pr.direccion,
    pr.precio,
    tp.nombre AS tipo,
    ep.nombre AS estado,
    cd.nombre AS ciudad
FROM tipo_propiedad tp
INNER JOIN propiedad pr
    ON tp.id_tipo_propiedad = pr.id_tipo_propiedad
INNER JOIN estado_propiedad ep
    ON pr.id_estado_propiedad = ep.id_estado_propiedad
INNER JOIN ciudad cd
    ON pr.id_ciudad = cd.id_ciudad;


CREATE VIEW vw_detalle_contratos AS
SELECT
    ct.id_contrato,
    pr.direccion AS inmueble,
    CONCAT(pc.nombre, ' ', pc.apellido) AS nombre_cliente,
    CONCAT(pa.nombre, ' ', pa.apellido) AS nombre_agente,
    ct.fecha_inicio,
    ct.total
FROM contrato ct
INNER JOIN propiedad pr
    ON ct.propiedad_id = pr.id_propiedad
INNER JOIN cliente cl
    ON ct.cliente_id = cl.id_cliente
INNER JOIN personas pc
    ON cl.id_cliente = pc.id_persona
INNER JOIN agente ag
    ON ct.agente_id = ag.id_agente
INNER JOIN personas pa
    ON ag.id_agente = pa.id_persona;


CREATE VIEW vw_estado_financiero_contratos AS
SELECT
    ct.id_contrato,
    ct.total AS valor_contrato,
    COALESCE(pg.total_pagado, 0) AS total_pagado,
    ct.total - COALESCE(pg.total_pagado, 0) AS saldo_pendiente
FROM contrato ct
LEFT JOIN (
    SELECT
        f.contrato_id,
        SUM(p.monto) AS total_pagado
    FROM factura f
    LEFT JOIN pago p
        ON f.id_factura = p.factura_id
    GROUP BY f.contrato_id
) pg
ON ct.id_contrato = pg.contrato_id;