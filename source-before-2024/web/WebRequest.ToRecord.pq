let
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
            r4 = Record.AddField(r3, "Url", metaData[Content.Uri]() )
        in
            r4
in
    WebRequest_ToRecord
