let
    XRay = (source as any) as text => [
        // see also: Xray, ToJson, Csv
        bytes = Json.FromValue( source, TextEncoding.Utf8 ),
        json  = Text.FromBinary( bytes, TextEncoding.Utf8 )
    ][json]

    /* or Jsonify

    // Convert to Json, then decode as a string. sometime useful because the UI auto decodes
    Jsonify = (source as any, optional options as nullable record) as text => let
        encoding    = options[encoding]? ?? TextEncoding.Utf8,
        messageArgs = source,
        bytes       = Json.FromValue( messageArgs, encoding ),
        render      = Text.FromBinary( bytes, encoding)
    in render,
    */

in XRay