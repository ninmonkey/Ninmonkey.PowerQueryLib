let
    Web.SimpleRequest = #"WebRequest New",
    FinalTable = Table.FromRecords(tests,
        type table[
            StatusCode = Int64.Type, RequestUrl = text,
            MetaData = record,
            ResponseText = text,
            IsJson = logical, Json = any,
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
    Final = FinalResults,
    Summary = [
        tests = tests,
        Final = Final,
        FinalResults = FinalResults
    ],
    tests1 = Summary[tests],
    tests2 = tests1{4}
in
    tests2