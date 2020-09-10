let
    /* converts existing table to Json
    May require extra cleanup depending on datatype compatibility with Json

    Usage:
        TableToJson( TableName )

    */
    TableToJson = (source as table, optional encoding as nullable number) as text =>
        let
            encoding = if encoding <> null then encoding else TextEncoding.Utf8,
            bin = Json.FromValue(source, encoding),
            jsonAsText = Text.FromBinary(bin, encoding)
        in
            jsonAsText
in
    TableToJson
