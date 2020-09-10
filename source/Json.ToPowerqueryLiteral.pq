let
    /* converts JSON to a pastable PowerQuery Literal

    Usage:
        TableToJson( TableName )

    */
    JsonToLiteral = (json as text) as text =>
        let
            doubleQuote = """",
            escapeQuotes = Text.Replace(
                json, doubleQuote,
                ( doubleQuote & doubleQuote)
            )
        in
            escapeQuotes
in
    JsonToLiteral
