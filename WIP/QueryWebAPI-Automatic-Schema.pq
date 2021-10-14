// WebRequest_ProjectById
let
    // fake API response
    testing_enabled = false,
    RequestPortfolio = (id as any) as table =>
        // fake API response
        let
            Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WSkwzNjJJTEtT0lEqLikF04ZKsbEA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [ProjectId = _t, Label = _t, Id = _t]),
            #"Changed Type1" = Table.TransformColumnTypes(Source,{{"Id", Int64.Type}})
        in
            Source,
    testing = RequestPortfolio( 0 )
in
   if testing_enabled = true
   then testing
   else RequestPortfolio

// flat schema
let
    Source = Table.FromList( {0..5} , Splitter.SplitByNothing(), type table[Id = number], null),

    // tableSchema = Value.Type( )
    // add_col = Table.AddColumn(Source, "Projects", each Datasource( [Id] ), Table.Type),
    schema_orig = Value.Type( Source{0} ),

    duplicate = WebRequest_ProjectById(0),
    table_schema = Value.Type( duplicate ),

    add_col = Table.AddColumn(Source, "Projects",
        (row) as table =>
            let
                x = WebRequest_ProjectById( row[Id] )
            in
                x,
            table_schema
            // Table.Type
    ),

    add_withoutShema = () as table =>
        let
            base = Source,
            response_t = WebRequest_ProjectById(0),
            table_schema = Value.Type(response_t),
            final_table = Table.AddColumn(
                base, "DynamicType",
                (row) as table =>
                    WebRequest_ProjectById( row[Id] ),
                table_schema
            )
        in
            final_table,

    // without_schema = Table.AddColumn(Source, "WithoutSchema",
    //     (row) as table =>
    //         let
    //             x = Datasource( row[Id] )
    //         in
    //             x,
    //         table_schema
    //         // Table.Type
    // ),

    #"Expanded Projects" = Table.ExpandTableColumn(add_col, "Projects", {"ProjectId", "Label", "Id"}, {"ProjectId", "Label", "Id.1"}),
    Final_WithoutSchema = add_withoutShema(),
    #"Expanded DynamicType" = Table.ExpandTableColumn(Final_WithoutSchema, "DynamicType", {"ProjectId", "Label", "Id"}, {"ProjectId", "Label", "Id.1"})
in
    #"Expanded DynamicType"

// dynamic_schema
let
    // project Id list
    Source = Table.FromList( {0..5} , Splitter.SplitByNothing(), type table[Id = number], null),

    // request 1 project, to get the schema
    first_arg = Source{0}[Id],
    first_request = WebRequest_ProjectById( first_arg ),
    request_schema = Value.Type( first_request ),

    // normal requests
    merged_responses = Table.AddColumn(
        Source, "DynamicTableType",
        (row) as table =>
            WebRequest_ProjectById( row[Id] ),
        request_schema
    ),

    final = merged_responses,
    #"Expanded DynamicTableType" = Table.ExpandTableColumn(
        final, "DynamicTableType", {"ProjectId", "Label", "Id"}, {"ProjectId", "Label", "Id.1"})
in
    #"Expanded DynamicTableType"

// dynamic_overcomplicated
let
    // project Id list
    Source = Table.FromList( {0..5} , Splitter.SplitByNothing(), type table[Id = number], null),

    // wrapper that applies Table.AddColumn with the table's schema
    Web_ProjectData = (source as table) as table =>
        // table has an [Id] column that's passed to the web request
        let
            // fetch the first result from the query, to test the schema
            first_arg = source{0}[Id],
            api_response = WebRequest_ProjectById(first_arg),
            table_schema = Value.Type(api_response),

            // the first project one ends up being queried twice
            final_table = Table.AddColumn(
                source, "DynamicTableType",
                (row) as table =>
                    WebRequest_ProjectById( row[Id] ),
                table_schema
            )
        in
            final_table,

    web_response = Web_ProjectData( Source ),
    expand_preserving_schema = Table.ExpandTableColumn(
        web_response, "DynamicTableType",
        {"ProjectId", "Label", "Id"}, {"ProjectId", "Label", "Id.1"}
    )
in
    expand_preserving_schema