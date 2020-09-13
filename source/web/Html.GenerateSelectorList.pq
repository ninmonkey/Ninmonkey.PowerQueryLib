let
    /*

    Example:
        Html.GenerateSelectorList(
            "TABLE.table > * > TR >",
            3
        )

    output:

        {
            {
                "Column1",
                "TABLE.table > * > TR > :nth-child(1)"
            },
            {
                "Column2",
                "TABLE.table > * > TR > :nth-child(2)"
            },
            {
                "Column3",
                "TABLE.table > * > TR > :nth-child(3)"
            }
        }


    */
    Html.GenerateSelectorList = (selector as text, count as number) as list => let
        numbers = List.Numbers( 1, count, 1),
        ListResult = List.Transform(
            numbers,
            each {
                "Column" & Text.From(_),
                selector & " :nth-child(" & Text.From(_) & ")"
            }
        )
    in
        ListResult

in
    Html.GenerateSelectorList