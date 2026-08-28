-- ============================================================
-- m4_consultas_negocio.sql
-- Proyecto: RetailPro
-- Módulo 4 - Consultas SQL de negocio
-- Base de datos: Ventas_Tech_DB
-- Tabla: ventas (id_cliente, id_producto, cantidad, precio_unitario, fecha_venta)
-- ============================================================


-- ------------------------------------------------------------
-- Consulta 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, por mes
-- ------------------------------------------------------------

SELECT
    DATEPART(MONTH, fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND (AVG(cantidad * precio_unitario),2) AS ticket_promedio
FROM Ventas
GROUP BY DATEPART(MONTH, fecha_venta)
ORDER BY mes;


-- ------------------------------------------------------------
-- Consulta 2: Ranking de productos
-- Top 5 de productos por total facturado, con unidades vendidas
-- ------------------------------------------------------------

SELECT TOP 5
    id_producto,
    SUM(cantidad)                          AS unidades_vendidas,
    SUM(cantidad * precio_unitario)        AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- ------------------------------------------------------------
-- Consulta 3: Clientes recurrentes
-- Clientes con más de un pedido, cantidad de pedidos y total gastado
-- ------------------------------------------------------------
SELECT
    id_cliente,
    COUNT(*)                               AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)        AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- ------------------------------------------------------------
-- Consulta 4: Meses por encima / por debajo del promedio
-- Total facturado por mes, comparado contra el promedio mensual general
-- ------------------------------------------------------------


WITH facturacion_mensual AS (
    SELECT
        DATEPART(MONTH, fecha_venta)       AS mes,
        SUM(cantidad * precio_unitario)    AS total_facturado
    FROM ventas
    GROUP BY DATEPART(MONTH, fecha_venta)
),
comparacion_promedio AS (
    SELECT 
        mes,
        total_facturado,
        AVG(total_facturado) OVER()        AS promedio_global
    FROM facturacion_mensual
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > promedio_global THEN 'Por encima'
        ELSE 'Por debajo'
    END                                    AS comparacion_promedio
FROM comparacion_promedio
ORDER BY mes;
-- ============================================================
-- Hallazgos
-- ============================================================
-- 1. ¿qué mes tuvo el pico de facturación y
--    qué porcentaje del total representa? 
-- 2. ¿cuán concentrado está el negocio en
--    pocos productos?
-- 3. ¿qué proporción de clientes son
--    recurrentes y cuánto representan en facturación frente a los de compra única?
-- ============================================================
