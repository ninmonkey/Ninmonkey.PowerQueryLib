let
    // expects a list of pairs of 2 elements, first is the digit, 2nd is the unit

        List.SelectBySuffix.Func = ( items as list, unit as text ) as any =>
            List.First(
                List.Select( items,
                    (i) => i{1} = unit ), null ){0}?,

        List.SelectBySuffix.Type = type function (
            items as (type { text }),
            unit as text
        ) as text meta [
            Documentation.Name = "List.SelectBySuffix",
            Documentation.LongDescription = Text.Combine({
                "After calling <code>Splitter.SplitDigitWithSuffix()</code>, this function will choose one item from the pair", "", "#(tab)<b>Example</b>:  For the text <code>'2m 3s'</code> find <code>'2'<code> if unit is <code>'m'<code>"
            }, "<br>"),
            Documentation.Examples = {
                [
                    Description = "Selects the first item in a list that ends with the specified suffix",
                    Code = Format.DocExpand( "List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)" ),
                    Result = Format.DocExpand("3")
                ],
                [
                    Description = "Selects the first item in a list that ends with the specified suffix",
                    Code = Format.DocExpand( "List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞d␞)" ),
                    Result = Format.DocExpand("2")
                ]
            }
        ]
    in
        Value.ReplaceType( List.SelectBySuffix.Func, List.SelectBySuffix.Type )

