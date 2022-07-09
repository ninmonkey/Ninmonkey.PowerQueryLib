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
        Web.SimpleRequest("https://httpbin.org", "/get", [ Text = "Hello World"])
    },
    #"Include Metadata" = Table.AddColumn(FinalTable, "Custom", each Value.Metadata( [Json] ), type record),
    Summary = [
        tests = tests,
        FinalTable = FinalTable,
        RealFinal = #"Include Metadata"
    ],
    RealFinal = Summary[RealFinal]
in
    RealFinal