Código M para Dim_Clientes
Fragmento de código
let
    // Conexión a la fuente Excel e ingreso a la hoja clientes
    Origen = Excel.Workbook(File.Contents("C:\Ruta\Pipeline_ETL_Dataset.xlsx"), null, true),
    Hoja_Clientes = Origen{[Item="clientes",Kind="Sheet"]}[Data],
    
    // Promoción de la primera fila como encabezados de columna
    Encabezados_Promovidos = Table.PromoteHeaders(Hoja_Clientes, [PromoteAllScalars=true]),
    
    // Desduplicación por PK para garantizar la unicidad de dimensión y evitar relaciones varios a varios
    Clientes_Desduplicados = Table.Distinct(Encabezados_Promovidos, {"id_cliente"}),
    
    // Imputación de nulos en atributos opcionales para preservar integridad sin sesgar el conteo de entidades
    Email_Nulos_Tratados = Table.ReplaceValue(Clientes_Desduplicados, null, "Sin Email", Replacer.ReplaceValue, {"email"}),
    Ciudad_Nulos_Tratados = Table.ReplaceValue(Email_Nulos_Tratados, null, "Sin Especificar", Replacer.ReplaceValue, {"ciudad"}),
    
    // Tipado explícito de columnas para optimizar el motor VertiPaq en Power BI
    Tipos_Datos_Asignados = Table.TransformColumnTypes(Ciudad_Nulos_Tratados,{
        {"id_cliente", Int64.Type}, 
        {"nombre_cliente", type text}, 
        {"email", type text}, 
        {"ciudad", type text}, 
        {"pais", type text}, 
        {"segmento", type text}, 
        {"fecha_registro", type date}
    })
in
    Tipos_Datos_Asignados
Código M para Dim_Productos
Fragmento de código
let
    // Conexión a la fuente Excel e ingreso a la hoja productos
    Origen = Excel.Workbook(File.Contents("C:\Ruta\Pipeline_ETL_Dataset.xlsx"), null, true),
    Hoja_Productos = Origen{[Item="productos",Kind="Sheet"]}[Data],
    
    // Promoción de la primera fila como encabezados de columna
    Encabezados_Promovidos = Table.PromoteHeaders(Hoja_Productos, [PromoteAllScalars=true]),
    
    // Desduplicación por PK id_producto para cumplir el esquema en estrella
    Productos_Desduplicados = Table.Distinct(Encabezados_Promovidos, {"id_producto"}),
    
    // Imputación contextual de categoría faltante basada en la subcategoría 'Laptops'
    Categoria_Imputada = Table.ReplaceValue(Productos_Desduplicados, null, "Computación", Replacer.ReplaceValue, {"categoria"}),
    
    // Imputación de precio faltante basado en valor de mercado/inventario para mantener consistencia financiera
    Precio_Imputado = Table.ReplaceValue(Categoria_Imputada, null, 110.0, Replacer.ReplaceValue, {"precio"}),
    
    // Cast estructural de tipos de datos previo al modelado relacional
    Tipos_Datos_Asignados = Table.TransformColumnTypes(Precio_Imputado,{
        {"id_producto", Int64.Type}, 
        {"nombre_producto", type text}, 
        {"categoria", type text}, 
        {"subcategoria", type text}, 
        {"precio", type number}, 
        {"costo", Int64.Type}, 
        {"stock", Int64.Type}, 
        {"activo", Int64.Type}
    })
in
    Tipos_Datos_Asignados