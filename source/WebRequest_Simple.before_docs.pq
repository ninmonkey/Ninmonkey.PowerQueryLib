// WebRequest_Simple
// not clippy🐵
let

    /*
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


    - embed M expression -> to comments like
    add final [Documentation.Examples] file

            for this url#(cr,lf)#(cr,lf)    https://httpbin.org/get?Text=hi-world#(cr,lf)#(cr,lf)the way you split args is the same as Web.Contents, other than the 2nd parameter being#(cr,lf)the [RelativePath] value. you would use:#(cr,lf)#(cr,lf)Web.SimpleRequest( ""https://httpbin.org"", ""/get"", [#(cr,lf)    Query = [#(cr,lf)        Text = ""hi-world""#(cr,lf)    ]#(cr,lf))

    */
    WebRequest_Simple
        =  (
            base_url as text,
            optional relative_path as nullable text,
            optional options       as nullable record
        )
        as record =>
        let

            headers = options[Headers]?, //or: ?? [ Accept = "application/json" ],

            merged_options = [
                Query = options[Query]?,
                RelativePath = relative_path,
                ManualStatusHandling = options[ManualStatusHandling]? ?? { 400, 404, 406 },
                Headers = headers
            ],

            bytes = Web.Contents(base_url, merged_options),
            response = Binary.Buffer(bytes),
            response_metadata = Value.Metadata( bytes ),
            status_code = response_metadata[Response.Status]?,
            response_text = Text.Combine( Lines.FromBinary(response,null,null, TextEncoding.Utf8), "" ),
            json = Json.Document(response),
            IsJsonX = not (try json)[HasError],
            Final = [
                request_url = metadata[Content.Uri](),
                response_text = response_text,
                status_code = status_code,
                metadata = response_metadata,
                IsJson = IsJsonX,
                response = response,

                json = if IsJsonX then json else null
            ]
        in
            Final,

    tests = {
        WebRequest_Simple("https://httpbin.org", "json"), // expect: json
        WebRequest_Simple("https://www.google.com"),       // expect: html
        WebRequest_Simple("https://httpbin.org", "/headers"),
        WebRequest_Simple("https://httpbin.org", "/status/codes/406"), // exect 404
        WebRequest_Simple("https://httpbin.org", "/status/406"), // exect 406
        WebRequest_Simple("https://httpbin.org", "/get", [ Text = "Hello World"])
    },

    FinalResults = Table.FromRecords(tests,
        type table[
            status_code = Int64.Type, request_url = text,
            metadata = record,
            response_text = text,
            IsJson = logical, json = any,
            response = binary
        ],
        MissingField.Error
    )
in
    FinalResults
