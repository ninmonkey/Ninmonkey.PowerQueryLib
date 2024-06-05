let
    // takes any type, converts it to json, then expands json into multiple lines
    ToJson = (
        source as any, // a value thats passed to Json.FromValue
        optional options as nullable record
    ) as text => [

        // see also: Xray, ToJson, Csv
        defaults = [
            Encoding = TextEncoding.Utf8,
            Expand   = true
        ],
        config = Record.Combine({
            options ?? [],
            defaults
        }),
        json = Text.FromBinary( Json.FromValue( source, config[Encoding] ) , config[Encoding] ),

        json_expanded = Text.Replace( json, "},{", "},#(cr,lf){"),

        return =
            if config[Expand] then json_expanded
                              else json

    ][return]

in ToJson