let
    Text.ReplaceMany
        = ( source as text, mapping as list ) as text =>
            let
                result = List.Accumulate(
                    mapping, source,
                    ( state, cur ) => Text.Replace(state, cur{0}, cur{1} ))
            in
                result,
    Text.ReplaceMany.Type = type function(
        source as (
            type text meta [
                Documentation.FieldCaption = "source",
                Documentation.FieldDescription = "List to search and replace multiple values"
        ]),
        mapping as (type list meta[
            Documentation.FieldCaption = "List of {oldText, newText} replacement Pairs",
            Documentation.FieldDescription = "A list of {oldText, newText} pairs, to search and then replace values"
        ]))
        as (type text meta [
            Documentation.Name = "Text.ReplaceMany",
            Documentation.LongDescription = "A list of {oldText, newText} pairs,<br></br><br>#(cr,lf)#(cr,lf) to search case-sensitive, and then replace values",
            /*

                example:
                    map = {
                        {"cat hat", "cat in the hat"},
                        {"cat", "#(0001f408)"},
                        {"bat", "hat"},
                        {"THE", "the"}
                    },
                    Text.ReplaceMany( "The cat hat")

                output:
                    "The 🐈 in the hat"
            */
            Documentation.Examples = {
                [   Description = "cat to emoji",
                    Code = "{0..4}",
                    Result = "none" ],
                [   Description = "cat to emoji",
                    Code = "{0..4}",
                    Result = "none" ]
            }
        ])
in
    Value.ReplaceType( Text.ReplaceMany, Text.ReplaceMany.Type )