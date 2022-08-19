// lib
let
    LibType = let
    /* experimenting with a different style of indentation
*/
        Uni  = [
            Delim = { "#(000021e2)", "#(0000205e)", "#(00002510)", "#(000021fd)" },
            NullSymbol = "#(00002400)"
        ] meta [Text.Serialized = true],
        Now = ()
            as datetime => DateTime.LocalNow(),



        Ms = (milliseconds as number)
            as duration =>
                #duration(0, 0, 0, 1) / 1000 * milliseconds,

        // alpha table, to time table add column, to test buffers performance hit
        Source = Table.FromList(
            { "a".."z" } & {"A".."Z"},
            null, type table[Char = text],
            null, ExtraValues.Error ),

        Quote = (source as any)
            as text =>
                "'" & Text.From(source) & "'",


        // Generates type name by expecting Text.From to throw,
        // Then using the serialized name in the exception
        // if that fails, final fallback string is "<␀>" null symbol
        Value.TypeNameAsText = (source as any) =>
                let
                    typeInfo =
                        try
                            Text.From(Value.Type(source))
                        catch (e) =>
                            e[Message.Parameters]?{0}?
                            ?? "<#(00002400)>"
                in
                    typeInfo,

        NowMsIter3 = (optional options as nullable record) as text =>
            let

                options = Record.Combine({ defaults, (options ?? []) }),
                defaults = [
                    Template0 = "#[ms] ms (of #[sec] #[delim] #[ms] )",
                    Template = "#[sec] #[delim] #[ms] ms",
                    Culture = Culture.Current,
                    Comparer.Ordinal = Comparer.OrdinalIgnoreCase
                ],
                now = Now(),
                fin = Text.Format(
                    options[Template],
                    [
                        ms = DateTime.ToText( now, [ Culture = options[Culture], Format = "fff"]),
                        sec = DateTime.ToText( now, [ Culture = options[Culture], Format = "m:s"]),
                        delim = Uni[Delim]{0}
                    ],
                    options[Culture]
                )
            in fin ,

    exports = [
        Ms = Ms,
        Now = Now,
        Uni = Uni,
        Value.TypeNameAsText = Value.TypeNameAsText,
        NowMs.ToText = NowMsIter3,
        NowAsText = NowMs.ToText,
        Quote = Quote,
        SampleTable = Source
    ]
in
    if false then
        {
            exports[NowMs.ToText](),
            exports[NowMs.ToText]( [ Template = "#[ms] ms (of #[sec] #[delim] #[ms] )" ] ),
            exports[NowMs.ToText]( [ Template = "#[sec] #[ms] " ] )
        }
    else
        exports
in
    LibType meta [
        Docs = ...
    ]