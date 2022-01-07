let
    /*
    latest version: <https://github.com/ninmonkey/Ninmonkey.PowerQueryLib>
    */
    GenerateSelectorList_Function = (
            selector as text,
            count as number
        ) as list => let
            numbers = List.Numbers( 1, count, 1),
            ListResult = List.Transform(
                numbers,
                each {
                    "Column" & Text.From(_),
                    selector & " :nth-child(" & Text.From(_) & ")"
                }
            )
            in
        ListResult,

    GenerateSelectorList_Type =
        type function (
            selector as (type text meta [
                Documentation.FieldCaption = "CSS Selector to prefix generated children",
                Documentation.FieldDescription = "CSS Selector to prefix generated children",
                Documentation.SampleValues = { "TABLE.table > * > TR >" },
                Formatting.IsMultiLine = true
            ]),
            count as (type number meta[
                Documentation.FieldCaption = "Number of Columns",
                Documentation.FieldDescription = "Number of Columns",
                Documentation.SampleValues = {3, 5, 10}

            ])
        ) as list meta [
            Documentation.Name = "Html.GenerateSelectorList",
            Documentation.LongDescription = "Dynamically generates a list of CSS selectors.
Used to scrape tables with Web.Page()",
            Documentation.Examples = {[
                Description = "Generate one value",
                Code = "
Html.GenerateSelectorList(
    ""TABLE.table > * > TR >"",
    3
)",
                Result = "
{
    {
        ""Column1"",
        ""TABLE.table > * > TR > :nth-child(1)""
    },
    {
        ""Column2"",
        ""TABLE.table > * > TR > :nth-child(2)""
    },
    {
        ""Column3"",
        ""TABLE.table > * > TR > :nth-child(3)""
    }
}
"
            ]}

        ],
    Html.GenerateSelectorList = Value.ReplaceType( GenerateSelectorList_Function, GenerateSelectorList_Type )
in
    Html.GenerateSelectorList