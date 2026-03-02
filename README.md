# Proyecto MySQL

## Base de datos de inmobiliaria

### Normalizacion 

Para la normalizacion se realizaron 18 tablas en total de las cuales 2 son los logs tanto del sistema como de errores y las demas son orientadas ya a los atributos del negocio, esta seccion como tal se puede dividir en 3 partes: La primera son las personas en las cuales se encuentran tanto clientes como los agentes, se dividio de esta manera para asi poder ubicar atributos unicos como lo son la comision que pertenece unicamente a los agentes, no se realizaron apartados de administrador o contador debido a que estos dos actores van en la parte de permisos pero no tienen una relacion con los demas atributos de la base de datos. La segunda parte es la propiedad en la cual estaran registrados los campos necesarios para su correcto tratamiento. Por ultimo se encuentra la parte de facturacion y pago en la cual las tablas principales son justamente: Contrato, factura y pago, en este caso siendo la tabla principal el contrato debido a que es a traves de este que se juntan todos los actores, por decirlo de cierta manera es el eje central de esta base de datos siendo la razon su alta relevancia. Esto se puede apreciar en la siguiente imagen:

[Texto alternativo](image.png)

---

### 1-Modelacion 

#### 1.1- Create_DB

En este archivo se realiza la creación de la base de datos `db_proyecto` y todas las tablas necesarias según la normalización previamente definida, incluyendo las claves primarias, foráneas y particiones para las tablas `logs` y `logs_error`.

#### 1.2 Indexado

En este archivo se crean los índices necesarios para optimizar las consultas.  
Se indexan:

- Personas: documento, email, telefono y nombre.
- Propiedad: ciudad, estado y tipo.
- Contrato: cliente, agente y propiedad.
- Factura: contrato.
- Pago: factura y fecha_pago.

---

### 2 Funciones

En el archivo `funciones.sql` se encuentran 3 funciones:

#### 2.1 Obtener comisión por agente

`fn_obtener_comision_agente`

Calcula la comisión que le corresponde al agente según el contrato recibido como parámetro.

#### 2.2 Deuda del contrato

`fn_deuda_contrato`

Calcula el saldo pendiente de un contrato restando el total pagado al total general del contrato.

#### 2.3 Total de propiedades

`fn_total_propiedades_libres`

Realiza un conteo de propiedades disponibles según el tipo recibido como parámetro.

---

### Vistas

En el archivo `Vistas.sql` se crean tres vistas:

- `vw_propiedades_resumen`
- `vw_detalle_contratos`
- `vw_estado_financiero_contratos`

Estas vistas permiten visualizar de forma clara las relaciones entre tablas sin necesidad de realizar consultas complejas manualmente.

---

### Triggers

En el archivo `Triggers.sql` se crean dos desencadenantes:

- `auditoria_estado_propiedad`
- `registro_nuevo_contrato`

Ambos registran automáticamente información en la tabla `logs` cuando:

- Se cambia el estado de una propiedad.
- Se inserta un nuevo contrato.

---

### Procedimiento con manejo de errores

En el archivo `logs_errores.sql` se crea el procedimiento:

`registrar_propiedad`

Este procedimiento permite insertar una propiedad controlando posibles errores y registrándolos automáticamente en la tabla `logs_error`.

---

### Logs adicionales

En el archivo `logs.sql` se incluye:

- Procedimiento `sp_registrar_log`
- Trigger `trg_insert_propiedad`

Estos permiten registrar automáticamente inserciones en la tabla `propiedad`.

---

### Eventos 

En el archivo `reportes.sql` se crea:

- La tabla `reporte_mensual`
- El evento `control_mensual_saldos`

Este evento se ejecuta automáticamente cada mes y registra en la tabla `reporte_mensual` los contratos que presentan saldo pendiente utilizando la función `fn_deuda_contrato`.

---

## Instrucciones de Instalación

### Requisitos Previos

- MySQL 8.x
- MySQL Workbench (recomendado)
- Permisos para crear bases de datos, eventos y usuarios

---

### Orden Correcto de Ejecución

Para evitar errores por dependencias, se debe ejecutar en el siguiente orden:

1. `create_db.sql`
2. `Indexado.sql`
3. `funciones.sql`
4. `Vistas.sql`
5. `logs.sql`
6. `logs_errores.sql`
7. `Triggers.sql`
8. `reportes.sql`
9. `privilegios.sql` (opcional, si se desea crear usuarios)
10. `Inserts.sql` (dataset de prueba)

El archivo `Inserts.sql` contiene un dataset de prueba que permite verificar el funcionamiento completo del sistema.

---

## Explicación del Modelo

El modelo se divide en tres bloques principales:

1. Personas (cliente y agente)
2. Propiedades
3. Facturación y pagos

La tabla `contrato` actúa como eje central del sistema, conectando personas, propiedades y operaciones financieras.

Se garantiza integridad referencial mediante claves foráneas y se implementa auditoría y control de errores mediante triggers, procedimientos y logs.

---

## Ejemplos de Consultas
##### Consultar todas las propiedades
SELECT * FROM vw_propiedades_resumen;

##### Consultar detalle de contratos
SELECT * FROM vw_detalle_contratos;

##### Consultar estado financiero de contratos
SELECT * FROM vw_estado_financiero_contratos;

##### Calcular comisión de un agente
SELECT fn_obtener_comision_agente(1);

##### Calcular deuda de un contrato
SELECT fn_deuda_contrato(2);

##### Contar propiedades disponibles por tipo
SELECT fn_total_propiedades_libres(1);

##### Ver registros de auditoría (logs del sistema)
SELECT * FROM logs;

##### Ver registros de errores controlados
SELECT * FROM logs_error;

##### Probar el procedimiento de inserción controlada
CALL registrar_propiedad(
    'Nueva Dirección 123',
    500000000.00,
    1,
    1,
    1
);

##### Ver reporte mensual generado por el evento
SELECT * FROM reporte_mensual;