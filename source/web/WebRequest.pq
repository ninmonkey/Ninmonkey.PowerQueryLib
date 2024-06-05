let
    /*
    Yet another web request implementation
    */
    WebRequest = (
        urlBase,          // text or uri
        config           as record,
        optional options as nullable record
    ) as record =>
        let return = [
            defaults = [ Buffer = false ],
            options = Record.Combine({ defaults, options ?? [] }),

            bytes   =
                // this could be simplifeid with a shadowed ref
                if   options[Buffer]? ?? false
                then Binary.Buffer( Web.Contents( urlBase, config ) )
                else                Web.Contents( urlBase, config ),

            Data   = if not IsJson then null else Json{0}?[Data]?,
            AsText = Text.FromBinary( bytes, TextEncoding.Utf8 ),
            Json   = Json.Document( bytes, TextEncoding.Utf8 ),
            IsJson = not (try Json)[HasError]?,
            Meta   = Value.Metadata( bytes ),

            Response.Status   = Meta[Response.Status],
            Infer.ContentType = Binary.InferContentType( bytes ),
            TotalBytes        = Binary.ApproximateLength( bytes ),
            Url               = Meta[Content.Uri]()

        ],  returnFields = {
            "Response.Status",
            "Url", "Infer.ContentType", "TotalBytes",
            "Meta", "Data", "AsText", "Json", "IsJson",
            "bytes"  }
        in
            Record.SelectFields(return, returnFields, MissingField.Error),

in WebRequest