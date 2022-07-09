let
    /*

    see also:
        WebRequest_simple.pq

    Wrapper for Web.Contents, exposes  returns response metadata
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
    //Web.SimpleRequest("https://httpbin.org", "/get", [ Text = "hi-world"] )
    Web.SimpleRequest.Type = type function (
        baseUrl as ( // future: maybe use url type?
            type text meta [
                Documentation.FieldCaption = "Minimum Base Url",
                Documentation.FieldDescription = "This includes the url up until the first slash after a domain. The rest goes into queyr string",
                Documentation.SampleValues = {"", "Bat"}
            ]
        )
    ),
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

                bytes = Web.Contents( baseUrl, merged_options ),
                response = Binary.Buffer( bytes ) ,
                response_metadata = Value.Metadata( bytes ),
                response_text = Text.Combine( Lines.FromBinary(
                    response,null,null, encoding ), "" ),
                    // depends on if I want to consume the errors from Json, usually it's
                    // content, but, sometimes it may be useful.
                // Json = try Json.Document(response, encoding) catch (e) => null,
                // Json = Json.Document(response, encoding),
                // this part is new, not sure if it's 100% logically equivalent to the prev test
                Json =
                    try
                        Json.Document( response, encoding)
                    catch (e) =>
                        null meta [Exception = e], // null for simple usability, but preserve
                // IsJson = Json <> null, //try false <> Json catch (e) => false,
                // IsJson2 = try false <> Json catch (e) => false,
                Final = [
                    RequestUrl = response_metadata[Content.Uri](),
                    ResponseText = response_text,
                    RequestHeaders = response_text[Headers]? ?? null,
                    RequestOptions = response_text[Request.Options]? ?? [], // []

                    StatusCode = response_metadata[Response.Status]?,
                    MetaData = response_metadata,
                    IsJson = Json <> null,
                    // IsJson2 = IsJson,
                    Response = response,
                    Json = Json

                    // json = if IsJson then json else null
                ]
            in
                Final
    in Web.SimpleRequest