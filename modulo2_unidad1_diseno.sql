-- ============================================================
-- Archivo: modulo2_unidad1_diseno.sql
-- Objetivo: Definir la estructura (esquema) de un sistema de
-- gestion de ventas: tablas "clientes" y "productos".
-- Motor objetivo: PostgreSQL (se indican equivalencias para
-- SQL Server en los comentarios, donde el tipo de dato difiere).
--
-- Nota: las restricciones de integridad (PRIMARY KEY, FOREIGN KEY)
-- se agregaran en la proxima unidad junto con las relaciones
-- entre tablas; este script solo define columnas y tipos de dato.
-- ============================================================

-- -----------------------------------------------------
-- Tabla: clientes
-- -----------------------------------------------------
CREATE TABLE clientes (
    -- INT: es un identificador de conteo, no se realizan
    -- operaciones matematicas sobre el (nunca se "suman" dos
    -- IDs de cliente).
    id_cliente INT,

    -- VARCHAR(100): nombre de longitud acotada y predecible.
    -- Se evita VARCHAR(MAX)/TEXT para no reservar memoria de mas
    -- ni ralentizar busquedas (Error 1 de la teoria de la unidad).
    nombre VARCHAR(100),

    -- TEXT: una biografia o nota puede tener una longitud muy
    -- variable e impredecible, a diferencia del nombre. Un
    -- VARCHAR con limite fijo podria quedarse corto.
    -- Equivalencia en SQL Server: VARCHAR(MAX).
    perfil_bio TEXT,

    -- DATE: se guarda como fecha real, no como texto (VARCHAR).
    -- Esto permite que herramientas como Power BI reconozcan el
    -- dato como fecha y habiliten funciones de tiempo automaticas
    -- (agrupar por mes, año, etc.), tal como señala la Unidad.
    fecha_registro DATE
);

SELECT* FROM clientes
-- -----------------------------------------------------
-- Tabla: productos
-- -----------------------------------------------------
CREATE TABLE productos (
    -- INT: identificador de conteo, mismo criterio que id_cliente.
    id_producto INT,

    -- VARCHAR(255): suficiente para una descripcion corta de
    -- producto sin desperdiciar espacio como lo haria TEXT.
    descripcion VARCHAR(255),

    -- DECIMAL(10,2), NO FLOAT: FLOAT almacena aproximaciones
    -- binarias y puede introducir errores de redondeo en valores
    -- monetarios (ej. 19.99 podria guardarse como 19.989999...).
    -- DECIMAL(10,2) admite hasta 10 digitos en total (2 de ellos
    -- decimales) con precision EXACTA, que es lo que se necesita
    -- para representar dinero. NUMERIC(10,2) es sinonimo valido.
    precio DECIMAL(10,2),

    -- BOOLEAN: esta_activo es un dato binario (a la venta / no a
    -- la venta) por naturaleza. Se prefiere BOOLEAN sobre un
    -- numero pequeño (TINYINT) o texto ('si'/'no') porque deja
    -- explicita la intencion del campo y evita valores invalidos
    -- (con TINYINT nada impediria cargar, por error, un 5 o un -1).
    -- Equivalencia en SQL Server: BIT (0 = false, 1 = true), ya
    -- que ese motor no tiene un tipo BOOLEAN nativo.
    esta_activo BIT 
);

SELECT* FROM productos 