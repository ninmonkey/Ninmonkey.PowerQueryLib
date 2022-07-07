let
    /*

    see also:
        WebRequest_simple.pq


    Wrapper for Web.Contents  returns response metadata
        for options, see: <https://docs.microsoft.com/en-us/powerquery-m/web-contents#__toc360793395>

    Details on preventing "Refresh Errors", using 'Query' and 'RelativePath':
        - Not using Query and Relative path cause refresh errors:
            <https://blog.crossjoin.co.uk/2016/08/23/web-contents-m-functions-and-dataset-refresh-errors-in-power-bi/>

        - You can opt-in to Skip-Test:
            <https://blog.crossjoin.co.uk/2019/04/25/skip-test-connection-power-bi-refresh-failures/>

        - Debugging and tracing the HTTP requests
            <https://blog.crossjoin.co.uk/2019/11/17/troubleshooting-web-service-refresh-problems-in-power-bi-with-the-power-query-diagnostics-feature/>
    update:
        - MaybeErrResponse: Quick example of parsing an error result.
        - Raw text is returned, this is useful when there's an error
        - now response[json] does not throw, when the data isn't json to begin with (false errors)

    */
    Web.SimpleRequest = // WebRequest_Simple
        (   baseUrl as text,
            optional relative_path as nullable text,
            optional options       as nullable record
        ) as record =>
            let
                encoding = options[Encoding]? ?? TextEncoding.Utf8,
                headers = options[Headers]?, //or: ?? [ Accept = "application/json" ],
                manualStatusHandling = options[ManualStatusHandling]? ?? {400, 404..406, 500},
                merged_options = [
                    // is null, blank, or [], more reliable? Some hosts and versions
                    //  can differ on how they may implicitly join query strings
                    // test: is there a different between null paths verses the fields removed from the record?
                    Query = options[Query]?, //?? [],
                    RelativePath = relative_path,
                    ManualStatusHandling = manualStatusHandling,
                    Headers = headers
                ],

                bytes = Web.Contents( baseUrl, merged_options),
                response = Binary.Buffer( bytes ) ,
                response_metadata = Value.Metadata( bytes ),
                response_text = Text.Combine( Lines.FromBinary( response,null,null, encoding ), "" ),
                json = Json.Document(response, encoding),
                // this part is new, not sure if it's 100% logically equivalent to the prev test
                IsJson = try false <> json catch (e) => false,
                Final = [
                    RequestUrl = response_metadata[Content.Uri](),
                    ResponseText = response_text,
                    StatusCode = response_metadata[Response.Status]?,
                    MetaData = response_metadata,
                    IsJson = IsJson,
                    Response = response,
                    Json = try json catch (e) => null meta [Exception = e]

                    // json = if IsJson then json else null
                ]
            in
                Final

//     FinalResults = Table.FromRecords(tests,
//         type table[
//             StatusCode = Int64.Type, RequestUrl = text,
//             MetaData = record,
//             ResponseText = text,
//             IsJson = logical, json = any,
//             Response = binary
//         ],
//         MissingField.Error
//     ),
//     tests = { // todo: remove
//         Web.SimpleRequest("https://httpbin.org", "json"), // expect: json
//         Web.SimpleRequest("https://www.google.com"),       // expect: html
//         Web.SimpleRequest("https://main.ddrv8e4fbmhdv.amplifyapp.com", "/api/timezonemap"),       // expect: html
//         Web.SimpleRequest("https://main.ddrv8e4fbmhdv.amplifyapp.com", "/api/timezonemap", [ManualStatusHandling = {404..406, 500}]),       // expect: html
//         Web.SimpleRequest("https://httpbin.org", "/headers"),
//         Web.SimpleRequest("https://httpbin.org", "/status/codes/406"), // exect 404
//         Web.SimpleRequest("https://httpbin.org", "/status/406"), // exect 406
//         Web.SimpleRequest("https://httpbin.org", "/get", [ Text = "Hello World"])
//     },
//     Web.SimpleRequest.Type = null
// in
//     FinalResults
    in Web.SimpleRequest