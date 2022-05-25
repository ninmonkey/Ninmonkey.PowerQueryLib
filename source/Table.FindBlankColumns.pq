
    Table.FindBlankColumns = (source as table) as table =>
        let
            columnNames = Table.ColumnNames(source),
            t = Table.FromList(
                    columnNames, null,
                    type table[ColumnName = text]),

            col_containsTest = Table.AddColumn(
                    t,  "ContainsNonBlank",
                    (row) =>
                        Table.ContainsNonBlank( source, row[ColumnName] ),
                    type text
                )

        in
            col_containsTest,
