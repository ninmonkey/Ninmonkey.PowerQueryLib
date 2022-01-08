let
    /*
        find a better name that describes it will not return a collection?
        Html.FirstValue to be consistant ?
     */
    Html.GetScalar = (html as any, selector as text,
        optional default as nullable any) as text =>
        let
            html = Html.Table(
                html,
                {
                    { "title", selector }
                },
                null
            )
        in
            Table.FirstValue(html, default)

in
    Html.GetScalar