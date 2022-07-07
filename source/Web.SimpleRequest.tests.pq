let
    Web.SimpleRequest = #"WebRequest New",
    FinalTable = Table.FromRecords(tests,
        type table[
            StatusCode = Int64.Type,
            RequestUrl = text,
            MetaData = record,
            ResponseText = text,
            IsJson = logical,
            Json = any,
            Response = binary
        ],
        MissingField.Error
    ),
    tests = { // todo: remove
        Web.SimpleRequest("https://httpbin.org", "json"), // expect: json
        Web.SimpleRequest("https://www.google.com"),       // expect: html
        Web.SimpleRequest("https://main.ddrv8e4fbmhdv.amplifyapp.com", "/api/timezonemap"),       // expect: html
        Web.SimpleRequest("https://main.ddrv8e4fbmhdv.amplifyapp.com", "/api/timezonemap", [ManualStatusHandling = {404..406, 500}]),       // expect: html
        Web.SimpleRequest("https://httpbin.org", "/headers"),
        Web.SimpleRequest("https://httpbin.org", "/status/codes/406"), // exect 404
        Web.SimpleRequest("https://httpbin.org", "/status/406"), // exect 406
        Web.SimpleRequest("https://httpbin.org", "/get", [ Text = "Hello World"])
    },
    #"Include Metadata" = Table.AddColumn(FinalTable, "JsonDecodeMessage", each Value.Metadata( [Json] ), type record),
    #"Include ErrorMessage" = Table.AddColumn(#"Include Metadata", "JsonDecodeMessage", each Value.Metadata( [Json] ), type record),
    Summary = [
        tests = tests,
        FinalTable = FinalTable,
        RealFinal = #"Include ErrorMessage"
    ],
    RealFinal = Summary[RealFinal]
in
    RealFinal