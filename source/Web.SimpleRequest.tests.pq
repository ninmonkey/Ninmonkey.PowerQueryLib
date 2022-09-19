let

    Web.SimpleRequest = #"WebRequest New",
    FinalTable = Table.FromRecords(tests,
        type table[
            StatusCode = Int64.Type,
            RequestUrl = text,
            MetaData = record,
            ResponseText = text,
            IsJson = logical,
            Json = nullable record,
            Response = binary
        ],
        MissingField.Error
    ),
    tests = { // todo: remove
        Web.SimpleRequest("https://httpbin.org", "json"),   // expected: json
        Web.SimpleRequest("https://www.google.com"),        // expected: html
        Web.SimpleRequest("https://main.ddrv8e4fbmhdv.amplifyapp.com", "/api/timezonemap"),
        Web.SimpleRequest("https://main.ddrv8e4fbmhdv.amplifyapp.com", "/api/timezonemap",
             [ManualStatusHandling = {404..406, 500}]),
        Web.SimpleRequest("https://httpbin.org", "/headers"),
        Web.SimpleRequest("https://httpbin.org", "/status/codes/406"),  // expected: 404
        Web.SimpleRequest("https://httpbin.org", "/status/406"),        // expected: 406
        Web.SimpleRequest("https://httpbin.org", "/get", [ Text = "hi-world"] )
    },
    // record.c
    #"Include Metadata" = Table.AddColumn(FinalTable, "JsonErrorMetadata",
        (row) =>
            let
                maybeMeta = Value.Metadata( row[Json] ),
                metaCount = Record.FieldCount( maybeMeta )
            in
                if metaCount = 0 then null
                else maybeMeta,
        type record),

    singleMeta = RealFinal{7}[MetaData]? ?? "meta",
    superVerbose = true,
    VerboseFinal = #"Changed Type",
    #"Expanded MetaData" = Table.ExpandRecordColumn(RealFinal, "MetaData", {"Content.Type", "Content.Uri", "Content.Name", "Headers", "Request.Options", "Response.Status"}, {"MetaData.Content.Type", "MetaData.Content.Uri", "MetaData.Content.Name", "MetaData.Headers", "MetaData.Request.Options", "MetaData.Response.Status"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded MetaData",{{"StatusCode", Int64.Type}}),
    RealFinal = #"Include Metadata",


    Summary = [
        tests = tests,
        FinalTable = FinalTable,
        RealFinal = RealFinal,
        singleMeta = #"Include Metadata"
    ]
in
    Summary