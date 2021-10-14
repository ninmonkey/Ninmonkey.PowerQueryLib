// VerifyTableSchema_SingleColumn
let
    enable_testing = false, // toggles testing
    json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMlTSUTIyMDLUNzDUNzQBcpRidSCiqBIgUWO4kIm+kSmmvAm6PFjUFGKWUmwsAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [ProjectId = _t, EndDate = _t, Sub_EndDate = _t]),
    Source = Table.TransformColumnTypes(json,{{"Sub_EndDate", type date}, {"EndDate", type date}}),
    schema_table = Table.Schema( Source ), 

    VerifyTableColumn_Schema = (source as table, columnName as text, optional options as nullable record) =>    
    let     
        defaultOptions = [
            filterResults = false ,
            expandSchemaColumn = true
        ],
        options = Record.Combine({ defaultOptions, options ?? [] }),

        source_schema = Table.SelectColumns(
            Table.Schema( source ),
            { "Name", "Position", "TypeName", "Kind", "IsNullable" }
        ),
        // error early if validation fails
        source = if Table.HasColumns(source, columnName)
            then source
            else error Error.Record("MissingColumnError", "Column does not exist in table", columnName),

        // future: inspect metadata
        add_TypeInfo  = Table.AddColumn( 
            source, "Type", 
            (row) =>
                Value.Type( 
                    Record.Field(row, columnName)
                ),
            Type.Type
        ),

        add_TypeString  = Table.AddColumn( 
            add_TypeInfo, "TypeString", 
            (row) =>
                Value_ToPowerQuery(
                    row[Type]
                ),            
            type text
        ),

        add_Schema = Table.AddColumn(
            add_TypeString, "Schema", 
            (row) =>
                 Table.First( Table.SelectRows(schema_table, each [Name] = columnName ), "error" ),
            type record
        ),
        
        expand_Schema = let 
            t1 = Table.ExpandRecordColumn(
                    add_Schema, "Schema",
                    {"Name", "TypeName", "NativeTypeName"},
                    {"Name", "TypeName", "NativeTypeName"}),   
            t2 = Table.TransformColumnTypes( t1 ,
                {{"Name", type text},
                {"TypeName", type text},
                {"NativeTypeName", type text}}
            )
        in  
            t2,


        final = if options[expandSchemaColumn]
            then expand_Schema 
            else add_Schema
    in
        final,

    // test_1 = VerifyTableSchema( Source, "EndDate", "Sub_EndDate"),
    test_0 = VerifyTableColumn_Schema( Source, "EndDate", [expandSchemaColumn = false] ),
    test_1 = VerifyTableColumn_Schema( Source, "EndDate" ),
    fin = test_1
in
    if enable_testing then test_1 else VerifyTableColumn_Schema