let
    Table_FindNotDistinctRows = (source as table, columnNames as list) as table =>
        let
            grouped = Table.Group(source, columnNames, {
                    {
                        "Count",
                        each Table.RowCount(_), Int64.Type},
                        {
                            "Rows", each _, Value.Type(source)
                        }
                    }
            ),
            find_repeats = Table.SelectRows(grouped, each [Count] > 1)
        in
            find_repeats
in
    Table_FindNotDistinctRows