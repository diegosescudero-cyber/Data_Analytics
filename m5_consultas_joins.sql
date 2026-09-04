-- ============================================================
-- m5_consultas_joins.sql
-- Proyecto: RetailPro
-- Módulo 5 - Consultas con JOINs
-- Base de datos: Ventas_Tech_DB (esquema del Checkpoint M3, ventas_tech_db.sql)
-- Motor: SQL Server (T-SQL)
-- ============================================================

-- ------------------------------------------------------------
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Combina Ventas con Clientes, Productos y Categorías para
-- obtener, en una sola fila, todo lo que necesita Power BI.
-- Columna para agrupar: Nombre_Categoria.
-- Columna para filtrar: Ciudad.
-- ------------------------------------------------------------
SELECT
    v.Fecha_Venta,
    v.ID_Cliente,
    c.Nombre_Cliente,
    c.Ciudad,
    p.Nombre_Producto,
    cat.Nombre_Categoria,
    v.Cantidad,
    p.Precio                       AS Precio_Unitario,
    (v.Cantidad * p.Precio)        AS Total_Venta
FROM Ventas v
INNER JOIN Clientes c     ON v.ID_Cliente = c.ID_Cliente
INNER JOIN Productos p    ON v.ID_Producto = p.ID_Producto
INNER JOIN Categorias cat ON p.ID_Categoria = cat.ID_Categoria;


-- ------------------------------------------------------------
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Clientes registrados que todavía no realizaron ninguna compra.
-- ------------------------------------------------------------
SELECT
    c.Nombre_Cliente,
    c.Email,
    c.Fecha_Registro
FROM Clientes c
LEFT JOIN Ventas v ON c.ID_Cliente = v.ID_Cliente
WHERE v.ID_Venta IS NULL;

-- ------------------------------------------------------------
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Productos del catálogo que nunca tuvieron movimiento.
-- ------------------------------------------------------------
SELECT
    p.Nombre_Producto,
    cat.Nombre_Categoria,
    p.Precio
FROM Productos p
INNER JOIN Categorias cat ON p.ID_Categoria = cat.ID_Categoria
LEFT JOIN Ventas v        ON p.ID_Producto = v.ID_Producto
WHERE v.ID_Venta IS NULL;


-- ------------------------------------------------------------
-- Consulta 4: Consolidado por canal (UNION ALL)
-- La columna "canal" no existe en el modelo: se genera como
-- valor de texto fijo en cada SELECT. Se separa por la ciudad
-- del cliente (Córdoba vs. resto), a modo de "sucursal".
-- Las dos consultas devuelven las mismas columnas, en el mismo
-- orden y con tipos compatibles (fecha, numérico, texto).
-- ------------------------------------------------------------
SELECT
    canal,
    SUM(total)   AS total_facturado,
    COUNT(*)     AS cantidad_ventas
FROM (
    SELECT
        v.Fecha_Venta,
        (v.Cantidad * p.Precio)   AS total,
        'Sucursal Córdoba'        AS canal
    FROM Ventas v
    INNER JOIN Productos p ON v.ID_Producto = p.ID_Producto
    INNER JOIN Clientes c  ON v.ID_Cliente = c.ID_Cliente
    WHERE c.Ciudad = 'Córdoba'

    UNION ALL

    SELECT
        v.Fecha_Venta,
        (v.Cantidad * p.Precio)   AS total,
        'Otras Sucursales'        AS canal
    FROM Ventas v
    INNER JOIN Productos p ON v.ID_Producto = p.ID_Producto
    INNER JOIN Clientes c  ON v.ID_Cliente = c.ID_Cliente
    WHERE c.Ciudad <> 'Córdoba'
) AS ventas_por_canal
GROUP BY canal;
