let
        Duration.FromCustomText.Type = type function (
            source as duration
        ) as duration meta [
            Documentation.Name = "Duration.FromCustomText",
            Documentation.LongDescription = Text.Combine({
                "Call <code>Splitter.SplitDigitWithSuffix()</code>.","",
                "Pick out pairs of 'd', 'h', 'm', 's' and 'd' using <code>List.SelectBySuffix()</code>",
                "returns type <code>duration</code>"
            }, "<br>")
        ],

        Duration.FromCustomText.Func = (source as text) as duration => [
            clean = Text.Trim( Text.Lower( source, Culture.Current ) ),
            s_segs = Text.Split(clean, " "),
            s_pairs = List.Transform( s_segs, (pair) => Splitter.SplitDigitWithSuffix( pair )),

            Days =
                Number.From( List.SelectBySuffix( s_pairs, "d" ) ) ?? 0,
            Hours =
                Number.From( List.SelectBySuffix( s_pairs, "h" ) ) ?? 0,
            Minutes =
                Number.From( List.SelectBySuffix( s_pairs, "m" ) ) ?? 0,
            Seconds =
                Number.From( List.SelectBySuffix( s_pairs, "s" ) ) ?? 0,

            inst =
                #duration( Days, Hours, Minutes, Seconds )
        ][inst]
    in
        Value.ReplaceType( Duration.FromCustomText.Func, Duration.FromCustomText.Type)
    // Duration.FromCustomText = Value.ReplaceType( Duration.FromCustomText.Func, Duration.FromCustomText.Type),