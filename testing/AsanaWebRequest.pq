
    // Get metadata for a Web.Contents call
    WebRequest_ToRecord = (response as binary) as record  =>
        let
            metaData = Value.Metadata( response ),
            maybeErr = try metaData[Content.Type],
            r2 = Record.AddField(metaData, "Binary", response, null ),
            r3 = Record.AddField(r2, "Response.Error",
                if maybeErr[HasError] then maybeErr[Error] else null,
                null
            ),
            result = Record.AddField(r3, "Url", metaData[Content.Uri]() )
        in
            result,

    Asana_WebRequest = (path as text, optional options as nullable record)
    as any =>
        let
            /* options
            Query, ManualStatusHandling, Headers
            */
            headers = [
                Authorization = "Bearer " & "Token"
            ],
            options = [
                RelativePath = "api/1.0/" & path,
                Query = options[Query]? ?? null,
                ManualStatusHandling =  options[ManualStatusHandling]? ?? {404, 400, 500},
                Headers = options[Headers]? ?? headers
                // ApiKeyName = "Bearer"
            ],
            response = Web.Contents( "https://app.asana.com", options),
            maybeJson = try Json.Document(response, 65001),
            json =
                if maybeJson[HasError] then maybeJson[Error][Message]
                else maybeJson[Value],
            result = [
                Response = response,
                Json = json
            ]
        in
            result,

    //  try_request = Asana_WebRequest(shared_options),
     try_request = Asana_WebRequest("users/me"),
    // try_request = Asana_WebRequest(shared_options),
    Json = try_request[Json],
    // try_request = Asana_WebRequest(shared_options),
    Value = Json[Value],
    // try_request = Asana_WebRequest(shared_options),
    data = Value[data]
in
    Asana_WebRequest
