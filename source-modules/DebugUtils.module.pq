[
    /*
    Created: 2024-06-04
    About:
        If you're trying to quickly experiment with queries in interactive mode
        Then this module gives you alias as shorthand for functions that are useful for debugging

        Should run without any external functions or dependencies
    */

    // aliases mainly for interactive use when debugging
    Str.Contains = Text.Contains.CI,
    Str.EndsWith = Text.EndsWith.CI,
    Buff         = BufferAny,
    BuffTable    = TableDelayedBuffer,
    Json         = ToJson,
    xray = ToJson, XRAY = xray,

    // meta of value
    Meta      = (source as any) as record => Value.Metadata( source ),
    // type of value
    Tinfo     = (source as any) as type   => Value.Type( source ),
    // meta of typedata
    TinfoMeta = (source as any) as record => Value.Metadata( Value.Type( source ) ),
    // inspect type, meta, and typedata meta
    TinfoAll  = (source as any) as record => [ // not optimized, redundant expression, but it's a debug tool
        Type      = Tinfo( source ),
        Meta      = Meta( source ),
        TypeMeta  = TinfoMeta( source ),
        Source    = source
    ],

    // get an abstract syntax tree
    Ast = (source as any) as nullable record => Value.Expression( source ),

    // always case-insensitive
    Text.Contains.CI = ( source as nullable text, substring as text) as nullable logical =>
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase ),

    // always case-insensitive
    Text.EndsWith.CI = (source as nullable text, substring as text) as nullable logical =>
        Text.EndsWith( source, substring, Comparer.OrdinalIgnoreCase ),

    // stop folding without forcing buffer or index column enumerations
    StopFold = (source as table) as table => Table.StopFolding(source),

    // example output: [ Core = "2.129.255.0" ]
    Versions.Module = Module.Versions(),

    // see: https://blog.crossjoin.co.uk/2023/12/10/getting-different-versions-of-data-with-value-versions-in-power-query/
    Versions       = (value as any) as table => Value.Versions( value ),

    // see: https://blog.crossjoin.co.uk/2023/12/10/getting-different-versions-of-data-with-value-versions-in-power-query/
    Versions.Which = (value as any) as any   => Value.VersionIdentity( value ),

    // IIRC this only affects evaluation when using the query editor. so if you have a lot of sketches, this may help there. YMMV
    TableDelayedBuffer = (source as table) as table =>
        Table.Buffer(source, [ BufferMode = BufferMode.Delayed ] ),

    // auto buffer by type
    BufferAny = (source as any) as any =>
        if source       is table    then Table.Buffer(source, [ BufferMode = BufferMode.Delayed ])
        else if source  is list     then List.Buffer(source)
        else if source  is binary   then Binary.Buffer(source)
        else error [
            Message.Format = "Unexpected Type: parameter was not a List, Table, or Binary",
            Message.Parameters = { Value.Type(source) },
            Detail = source
        ],

    // renders object as jsonified text, with some formatting
    ToJson = (source as any, optional options as nullable record ) as text => [
        defaults = [
            Encoding = TextEncoding.Utf8,
            Expand = true
        ],
        config = Record.Combine({
            defaults,
            ( options ?? [] )
        }),
        json = Text.FromBinary( Json.FromValue( source, config[Encoding] ) , config[Encoding] ),
        json_expanded = Text.Replace( json, "},{", "},#(cr,lf){"),
        return = if config[Expand] then json_expanded else json
    ][return],

    // takes a string of json, replaces values to simplify it
    SimplifyJson = (
        source           as text,
        optional options as nullable record

    ) as text => [

        // make defaults param
        options = options ?? [
            PadKeyValue              = true,
            KeyValueDelim            = " ▸ ",
            PadBraceEnding           = true,
            TrimDoubleQuotes         = true,
            ReplaceDoubleQuoteString = " ",
            TrimPrefixSuffixBrace    = false
        ],
        // Str = [ DoubleQuote = "#(0022)" ],
        keyValueDelim_1 = " ▸ ",
        keyValueDelim   = ": ",
        acc0            = source,
        // acc1 = Text.Replace( acc0, "#(0022):{#(0022)", " => " ),
        acc1 =
            if not options[PadKeyValue]
            then acc0
            else
                Text.Replace( acc0, "#(0022):", options[KeyValueDelim] ),

        acc2 =
            if not options[TrimDoubleQuotes]
            then acc1
            else
                Text.Replace( acc1, "#(0022)", options[ReplaceDoubleQuoteString] ),
        acc3 =
            if not options[PadBraceEnding] then acc2
            else
                Text.Replace( acc2, "}", " }" ),
        acc4 = // this only strips the final instance because of acc3 running first
                // should instead be a replace first and last occurence instead
            if not options[TrimPrefixSuffixBrace] then acc3
            else
                [
                    trimSpace = Text.Trim( acc3 ),
                    trimStart = Text.TrimStart( trimSpace, "{" ),
                    trimEnd   = Text.TrimEnd( trimStart, "}" ),
                    return    = trimEnd

                ][return],

        return = acc3

    ][return]
]