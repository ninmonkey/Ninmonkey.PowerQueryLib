let
    Text.ReplaceMapping =
        "see if I can find a new trick in the url

        https://blog.crossjoin.co.uk/2014/06/25/using-list-generate-to-make-multiple-replacements-of-words-in-text-in-power-query/
        ",

    Source = "The cat in the hat.",
    mapping = {
        {"Cat", "#(0001f408)"},
        {" ", "#(cr,lf)" },
        {"hat", "matte" },
        {".", "?" }
    },
    // expects a list of pairs of text
    Text.ReplaceMany = ( source as text, mapping as list ) as text =>
        let
            result = List.Accumulate(
                mapping, source,
                ( state, cur ) => Text.Replace( state, cur{0}, cur{1} ))
        in
            result,

    output = Text.ReplaceMany( Source, mapping ),
    Summary = [
        Map = mapping,
        Source = Source,
        Final = output

    ]
in
    Summary
