-- ============================================================
-- Archivo:  ventas_tech_db.sql
-- ============================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Ventas_Tech_DB')
BEGIN
    CREATE DATABASE Ventas_Tech_DB;
END;
GO

------------------------------------------------------------------------------
use Ventas_Tech_DB
go

-- ============================================================
-- SECCIÓN 0: Limpieza previa (para poder re-ejecutar el script)
-- Se eliminan primero las tablas "hijas"/hechos y al final las
-- tablas "padre"/dimensiones, para no romper las Foreign Keys.
-- ============================================================
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Categorias;

-- ============================================================
-- SECCIÓN 1: DEFINICIÓN DEL ESQUEMA (DDL)
-- Orden: primero las tablas de dimensiones, al final la tabla
-- de hechos (Ventas), que depende de las demás.
-- ============================================================

-- ------------------------------------------------------------
-- Tabla: Categorias
-- ------------------------------------------------------------
CREATE TABLE Categorias (
    ID_Categoria     INTEGER PRIMARY KEY,
    Nombre_Categoria VARCHAR(50) NOT NULL,
    Descripcion VARCHAR (200)
);

-- ------------------------------------------------------------
-- Tabla: Productos
-- Se separa la categoría en su propia tabla (3NF): Productos
-- no guarda el texto de la categoría, sino su ID_Categoria.
-- ------------------------------------------------------------
CREATE TABLE Productos (
    ID_Producto      INTEGER PRIMARY KEY,
    Nombre_Producto  VARCHAR(100) NOT NULL,
    ID_Categoria     INTEGER NOT NULL,
    Precio           DECIMAL(10, 2) NOT NULL,
    Stock            INTEGER DEFAULT 0,
    Activo           SMALLINT DEFAULT 1,
       CONSTRAINT fk_producto_categoria
        FOREIGN KEY (ID_Categoria) REFERENCES Categorias (ID_Categoria)
        );

-- ------------------------------------------------------------
-- Tabla: Clientes
-- ------------------------------------------------------------
CREATE TABLE Clientes (
    ID_Cliente     INTEGER PRIMARY KEY,
    Nombre_Cliente VARCHAR(100) NOT NULL,
    Email          VARCHAR(100) NOT NULL UNIQUE,
    Ciudad         VARCHAR(50),
    fecha_registro	DATE	NOT NULL
);

-- ------------------------------------------------------------
-- Tabla: Ventas (tabla de hechos)
-- Conecta Clientes y Productos. Las Foreign Keys garantizan
-- que no se pueda registrar una venta de un cliente o producto
-- que no exista.
-- ------------------------------------------------------------
CREATE TABLE Ventas (
    ID_Venta     INTEGER PRIMARY KEY,
    ID_Cliente   INTEGER NOT NULL,
    ID_Producto  INTEGER NOT NULL,
    Cantidad     INTEGER NOT NULL,
    precio_unitario	DECIMAL(10,2)	NOT NULL,
    fecha_venta	 DATE	NOT NULL,
    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (ID_Cliente) REFERENCES Clientes (ID_Cliente),
    CONSTRAINT fk_venta_producto
        FOREIGN KEY (ID_Producto) REFERENCES Productos (ID_Producto)
);

-- ============================================================
-- SECCIÓN 2: RESTRICCIONES DE INTEGRIDAD
-- (ya declaradas dentro de cada CREATE TABLE de la Sección 1)
--   - PRIMARY KEY en las 4 tablas.
--   - FOREIGN KEY en Productos -> Categorias.
--   - FOREIGN KEY en Ventas -> Clientes y Ventas -> Productos.
--   - NOT NULL en campos críticos: Nombre_Categoria,
--     Nombre_Producto, Precio, Nombre_Cliente, Fecha, Cantidad.
-- ============================================================

-- ============================================================
-- SECCIÓN 3: CARGA INICIAL DE DATOS (DML)
-- Orden: primero dimensiones, al final hechos (Ventas),
-- para respetar las Foreign Keys.
-- ============================================================

-- ------------------------------------------------------------
-- Categorías (4)
--------------------------------------------------------------
INSERT INTO Categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO Categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO Categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO Categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

-- ------------------------------------------------------------
-- Productos (6, distribuidos en las 4 categorías)
-- ------------------------------------------------------------
INSERT INTO Productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO Productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO Productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO Productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO Productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO Productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

--------------------------------------------------------------
-- Clientes (5)
--------------------------------------------------------------
INSERT INTO Clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO Clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO Clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO Clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO Clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');
-- ------------------------------------------------------------
-- Ventas (10 transacciones)
--------------------------------------------------------------
INSERT INTO Ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO Ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO Ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO Ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO Ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO Ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO Ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO Ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO Ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

---------------------------------------------------------------------------------------------------------------------------


