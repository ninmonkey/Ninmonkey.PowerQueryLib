let
    /*
    This is a stand alone example showing how to read response metadata
    See: https://ninmonkeys.com/blog/2024/05/31/power-query-capturing-response-metadata-from-web-contents
    */
    RequestSummary = [
        base_url = "https://httpbin.org",
        // if not set, these functions default to TextEncoding.Utf8 .
        // That's the most common encoding for the web
        RawBytes     = Web.Contents( base_url, [ RelativePath = "/json" ]), // type is: binary|error
        ResponseMeta = Value.Metadata( RawBytes ), // type is: record
        Json         = Json.Document( RawBytes ),  // type is: record/list/error

        // We Can Detect if JSON parsed correctly
        IsJson = not (try Json)[HasError],  // type is: logical

        // Decoding the response as raw text is useful for debugging.
        // say the api returns HTML when you expect JSON. That causes Json.Document to error
        // RawText still works, making it easy to check if it's actually returning CSV/JSON/HTML/etc.
        RawText      = Text.FromBinary( RawBytes ), // type is: text/error

        // Lets strip newlines, making it easier to preview text in the UI
        TextWithoutNewLines = Text.Remove( RawText, { "#(lf)", "#(cr)" } ), // type is: text

        // Now lets grab important fields by drilling into the ResponseMeta record

        // Http Status Codes are explained here: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>
        StatusCode     = ResponseMeta[Response.Status]?, // type is: text

        // Content.Uri is a function that returns the full filepath for files, or url for web requests
        FullRequestUrl = ResponseMeta[Content.Uri]() // type is: text
    ]
in
    RequestSummary