    let
        /*
        Example using this url:
            https://www.metaweather.com/api/location/search?lattlong=36.96,-122.02

            WebRequest(
                "https://www.metaweather.com",
                "api/location/search",
                [ lattlong = "36.96,-122.02" ]
            )

        Details on preventing "Refresh Errors", using 'Query' and 'RelativePath':
            - Not using Query and Relative path cause refresh errors:
                <https://blog.crossjoin.co.uk/2016/08/23/web-contents-m-functions-and-dataset-refresh-errors-in-power-bi/>

            - You can opt-in to Skip-Test:
                <https://blog.crossjoin.co.uk/2019/04/25/skip-test-connection-power-bi-refresh-failures/>

            - Debugging and tracing the HTTP requests
                <https://blog.crossjoin.co.uk/2019/11/17/troubleshooting-web-service-refresh-problems-in-power-bi-with-the-power-query-diagnostics-feature/>

        */
        WebRequest = (
            staticPath as text,                 // domain
            relativePath as text,               // basically use everything after ".com" to "?"
            optional query as nullable record,  // url query string, key value pairs after the "?"
            optional asRaw as nullable logical, // use true if content is not Json
            optional headers as nullable record // optional HTTP headers as a record
        ) as any =>
            let
                query = query ?? [],
                asRaw = asRaw ?? false, // toggles calling Json.Document() or not
                headers = headers ?? [
                    Accept="application/json"
                ],

                baseUrl = staticPath,
                options = [
                    RelativePath = relativePath,
                    Headers = headers,
                    Query = query
                    // optionally toggle handling errors for specific HTTP Status codes
                    // ManualStatusHandling = {400, 404}
                ],
                // wrap 'Response' in 'Binary.Buffer' if you are using it multiple times
                response = Web.Contents(staticPath, options),
                metadata = Value.Metadata(response),
                buffered = Binary.Buffer(response),
                result = Json.Document(buffered)
            in
                [
                    response = if asRaw then buffered else result,
                    status_code = metadata[Response.Status],
                    metadata = metadata
                ]
    in
        WebRequest
