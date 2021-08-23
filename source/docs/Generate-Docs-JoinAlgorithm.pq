let
    // generates docs for join type. sorta generic.

    GenerateDocs_JoinAlgorithm = (sourceType as type) =>
    let
        root = Value.Metadata( sourceType ),
        desc = root[Description]? ?? null,
        docsLong_Html = root[Documentation.LongDescription]? ?? null,
        Custom1 = Table,

        Html_simple = Html.Table(
            docsLong_Html, { { "Item", "li"} }
        ),
        Html_details = Html.Table(
            docsLong_Html,
            { { "li", "li", (x) as record => x, type record } } ),
            // The last list value appears to be the type of it?

        SelectedHtml = Html_simple,
        split_header = Table.SplitColumn(
            SelectedHtml, "Item",
            Splitter.SplitTextByEachDelimiter({": "}, QuoteStyle.Csv, false),
            {"JoinAlgorithm.Type", "Description"}
        )
    in
        split_header,

    docs = GenerateDocs_JoinAlgorithm( JoinAlgorithm.Type )
in
    docs