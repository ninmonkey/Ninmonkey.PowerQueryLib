let
    /* converts JSON string to a pastable PowerQuery Literal
    Otherwise you have to escape values

    Usage:
        Text_JsonToPowerQuery(
            Table_ToJson( TableName )
        )

    */
    Text_JsonToPowerQuery = (json as text) as text =>
        let
            doubleQuote = """",
            escapeQuotes = Text.Replace(
                json, doubleQuote,
                ( doubleQuote & doubleQuote)
            )
        in
            escapeQuotes
in
    Text_JsonToPowerQuery