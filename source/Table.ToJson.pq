let
    Documentation = type function (
        source as (type table meta [
            Documentation.FieldCaption = "Input Table",
            Documentation.FieldDescription = "Input Table"
        ]),
        optional encoding as (type nullable number meta [
            Documentation.FieldCaption = "Text Encoding",
            Documentation.FieldDescription = "Text Encoding",
            Documentation.AllowedValues = { TextEncoding.Ascii, TextEncoding.BigEndianUnicode, TextEncoding.Unicode, TextEncoding.Utf16, TextEncoding.Utf8, TextEncoding.Windows }
        ])
    ) as table meta [
            Documentation.Name = "TableToJson",
            Documentation.LongDescription = "Converts a table to JSON. (The reverse of using 'Enter Data'). Currently this does not save schema other than JSON types",
            Documentation.Examples = {[
                Description = "Generate one value",
                Code = "TableToJson( #table({""Animal"", ""Id""}, {{""Cat"", 1}, {""Turtle"", 2}}) )",
                Result = "[{""Animal"":""Cat"",""Id"":1},{""Animal"":""Turtle"",""Id"":2}]"
            ]}
        ],

    TableToJson = (source as table, optional encoding as nullable number) as text =>
        let
            encoding = encoding ?? TextEncoding.Utf8,
            bin = Json.FromValue(source, encoding),
            jsonAsText = Text.FromBinary(bin, encoding)
        in
            jsonAsText
in
    Value.ReplaceType( TableToJson, Documentation)
