Markdown
# RetailPro - Proyecto de Data Analytics

Este repositorio contiene los entregables y recursos desarrollados para el proyecto **RetailPro** en el marco de la carrera de Data Analytics. El objetivo principal es estructurar, procesar y analizar los datos comerciales de la empresa para optimizar la toma de decisiones mediante consultas relacionales y tableros interactivos de Business Intelligence.

---

## 🛠️ Herramientas Utilizadas

* **Gestión de Base de Datos:** T-SQL / Microsoft SQL Server
* **Business Intelligence & Visualización:** Power BI (`.pbix`)
* **Control de Versiones:** Git & GitHub

---

## 📁 Estructura del Repositorio

* `ventas_tech_db.sql`: Script de creación de la base de datos y esquemas de tablas para el modelo transaccional.
* `m4_consultas_negocio.sql`: Consultas SQL enfocadas en responder preguntas clave de negocio (métricas de ventas, clientes y productos).
* `m5_consultas_joins.sql`: Consultas avanzadas utilizando combinaciones de tablas (`INNER JOIN`, `LEFT JOIN`, etc.) para análisis relacional.
* `Pipeline_ETL_Escudero_Diego.pbix`: Archivo de Power BI con la extracción, transformación y carga (ETL) de los datos.
* `Escudero_Diego_Checkpoint2.pbix`: Tablero e informes interactivos de Power BI.

---

## 🚀 Cómo Ejecutar los Scripts SQL

Para replicar la base de datos y ejecutar las consultas en **Microsoft SQL Server Management Studio (SSMS)** u otro cliente compatible, sigue estos pasos:

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/diegosescudero-cyber/Data_Analytics.git](https://github.com/diegosescudero-cyber/Data_Analytics.git)
Crear la Base de Datos y Tablas:

Abre SSMS y conéctate a tu servidor local o remoto.

Abre el archivo ventas_tech_db.sql.

Ejecuta el script (F5) para crear la estructura de la base de datos e insertar los datos iniciales.

Ejecutar Consultas de Negocio y Joins:

Asegúrate de seleccionar la base de datos creada mediante el comando:

SQL
USE ventas_tech_db;
Abre y ejecuta m4_consultas_negocio.sql para obtener las métricas descriptivas clave del negocio.

Abre y ejecuta m5_consultas_joins.sql para analizar las relaciones entre las distintas entidades del modelo.

📊 Informes en Power BI
Para explorar las visualizaciones e informes interactivos:

Abre Microsoft Power BI Desktop.

Carga los archivos .pbix (Pipeline_ETL_Escudero_Diego.pbix y Escudero_Diego_Checkpoint2.pbix).

Actualiza el origen de datos en caso de requerir reconexión con tu servidor SQL local.
