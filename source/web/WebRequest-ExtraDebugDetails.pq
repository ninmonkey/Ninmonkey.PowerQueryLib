
/* 2025-01-16
About: This outputs excessive details for debugging web responses
- It shows: headers, status code, full raw URL, content types
- detect if response is valid json,
- response decoded as plain text ( before json or other parsing can error )
*/

let
    GoodJson = Web.Contents(
        "https://httpbin.org", [
            RelativePath = "json"
        ]
    ),
    Force200 = Web.Contents(
        "https://httpbin.org", [
            RelativePath = "status/200",
            ManualStatusHandling = { 404, 409, 500 }
        ]
    ),
    ForceError409 = Web.Contents(
        "https://httpbin.org", [
            RelativePath = "status/409",
            ManualStatusHandling = { 404, 409, 500 }
        ]
    ),
    FormatResponse = (request as binary) =>
    let
        /*  Make it easier to view the HTTP Error codes, and other info */
        TemplateFancyStatus = Text.Combine(
            // List.Select(
                {
                "#[iconIsGood] #[status] #[isJson]",
                "Size: #[size] bytes",
                "ContentType: #[contentType]",
                "#[url]",
                "#[errorMessage]"
            },
            // }, each _ is text and _ = ""),
            "#(cr,lf)"
        ),

        TemplateFancyError = Text.Combine(
            // List.Select(
                {
                "Reason: #[reason]",
                "Message: #[message]",
                "Detail: #[detail]",
                "Message.Format = #[messageFormat]",
                "Message.Parameters = #[messageParameters]",
                "ErrorCode: #[errorCode]",
                "ScriptExtent: #[scriptExtent]"
            },
            // }, each _ is text and _ = ""),
            "#(cr,lf)"
        ),

        Row = [
            Summary = Text.Format(
                TemplateFancyStatus,
                [
                    iconIsGood   = if HadError then "❌" else "✔️",
                    status       = StatusCode,
                    isJson       = if IsJson then "| Json" else "",
                    url          = Url,
                    contentType  = ContentType,
                    size         = SizeBytes,
                    errorMessage =
                        if ErrorMessage = null then null
                        else "Error: " & ErrorMessage
                ]
            ),
            StatusCode  = Meta[Response.Status],
            Url         = Meta[Content.Uri](),
            ContentType = Meta[Content.Type]?,

            RawText = Text.FromBinary( Content ),
            Json    = Json.Document( Content ),

            ScriptExtent =
                let stack =
                    if ErrorRecord = null
                    then null
                    else Value.Metadata( try Json catch (e) => e )[Expression.Stack]?
                in  Text.FromBinary( Json.FromValue( stack ?? {} ) ),


            FancyError =
                if HadError = null then null
                else Text.Format(
                    TemplateFancyError,
                    [
                        reason            = ErrorRecord[Reason]?,
                        message           = ErrorRecord[Message]?,
                        detail            = ErrorRecord[Detail]?,
                        messageFormat     = ErrorRecord[Message.Format]?,
                        messageParameters = ErrorRecord[Message.Parameters]?,
                        errorCode         = ErrorRecord[ErrorCode]?,
                        scriptExtent      = ScriptExtent
                    ]
            ),

            Headers        = Meta[Headers],
            RequestOptions = Meta[Request.Options],

            ErrorMessage   =
                if not HadError then null
                else try Json
                    catch (e) => e[Message],

            ErrorRecord =
                if not HadError then null
                else try Json catch (e) => e,

            ContentName = Meta[Content.Name]?,
            SizeBytes   = Binary.Length( Content ),

            IsJson      = not ( try Json)[HasError],
            Meta        = Value.Metadata( Content ),
            HadError    = (try Json)[HasError],
            Content     = request                     // the raw bytes
        ],
        // ApplyColumnTypes = Table.TransformColumnTypes(
        //         ,{{"StatusCode", Int64.Type}}),
        Return = Row

    in Return,

    Data = {
        FormatResponse( GoodJson ),
        FormatResponse( Force200 ),
        FormatResponse( ForceError409 )
    },
    FinalTable = Table.FromRecords( Data, null, MissingField.Error ),
    GuiCache = Table.Buffer( FinalTable, [BufferMode = BufferMode.Delayed ]) // makes PBI preview mode update faster. Not used by the service
in
    GuiCache
