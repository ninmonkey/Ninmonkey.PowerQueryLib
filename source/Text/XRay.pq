let
    XRay = (source as any) as text => [
        // see also: Xray, ToJson, Csv
        bytes = Json.FromValue( source, TextEncoding.Utf8 ),
        json  = Text.FromBinary( bytes, TextEncoding.Utf8 )
    ][json]

in XRay