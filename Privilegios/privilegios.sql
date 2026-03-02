CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'AdminPassword123!';
GRANT ALL PRIVILEGES ON db_proyecto.* TO 'adminnistrador'@'localhost';



CREATE USER 'contador'@'localhost' IDENTIFIED BY 'ContadorPassword789!';

-- Permisos financieros
GRANT SELECT, INSERT, UPDATE ON dbb_proyecto.factura TO 'contador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON dbb_proyecto.pago TO 'contador'@'localhost';
GRANT SELECT, INSERT ON db_proyecto.tipo_pago TO 'contador'@'localhost';

-- Permisos de lectura para contexto y reportes
GRANT SELECT ON db_proyecto.contrato TO 'contador'@'localhost';
GRANT SELECT ON db_proyecto.vw_saldo_contratos TO 'contador'@'localhost';
GRANT SELECT ON db_proyecto.reporte_pagos_mensual TO 'contador'@'localhost';

CREATE USER 'agente_inmobiliario'@'localhost' IDENTIFIED BY 'AgentePassword456!';

-- Permisos de lectura/escritura en tablas operativas
GRANT SELECT, INSERT, UPDATE ON db_proyecto.propiedad TO 'agente_inmobiliario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_proyecto.contrato TO 'agente_inmobiliario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_proyecto.personas TO 'agente_inmobiliario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_proyecto.cliente TO 'agente_inmobiliario'@'localhost';

-- Permisos de solo lectura para tablas de catálogo
GRANT SELECT ON db_proyecto.tipo_propiedad TO 'agente_inmobiliario'@'localhost';
GRANT SELECT ON db_proyecto.estado_propiedad TO 'agente_inmobiliario'@'localhost';
GRANT SELECT ON db_proyecto.ciudad TO 'agente_inmobiliario'@'localhost';

FLUSH PRIVILEGES;