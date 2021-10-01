
let
    
    /*
    Wrapper for Web.Contents  returns response metadata 
        for options, see: <https://docs.microsoft.com/en-us/powerquery-m/web-contents#__toc360793395>

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
                ManualStatusHandling = options[ManualStatusHandling]? ?? { 400, 404 },
                Headers = headers
            ],
        
            bytes = Web.Contents(base_url, merged_options),
            response = Binary.Buffer(bytes),
            response_metadata = Value.Metadata( bytes ),
            status_code = response_metadata[Response.Status]?,
            json = Json.Document(response),
            Final = [
                request_url = metadata[Content.Uri](),
                status_code = status_code,
                metadata = response_metadata,
                IsJson = not (try json)[HasError],
                response = response,
                json = json
            ]
        in 
            Final,

    tests = {
        WebRequest_Simple("https://httpbin.org", "json"), // expect: json
        WebRequest_Simple("https://www.google.com")       // expect: html
    },

    FinalResults = Table.FromRecords(tests,
        type table[
            status_code = text, request_url = text, metadata = record,
            response = binary, IsJson = logical, json = any],
        MissingField.Error
    )    
in
    FinalResults