    // find columns with non=-disstinct

    Table.FindSingleValueColumns = (source as table) as any =>
            let
                columnNames = Table.ColumnNames(source),
                t = Table.FromList(
                        columnNames, null,
                        type table[ColumnName = text]),
                col_SingleOrNone = wip
                col_containsTest = Table.AddColumn(
                        t,  "SingleOr",
                        (row) =>
                                        // List.Count( Table.Column(source, ) )
                            List.Count(
                                Table.Column( source, row[ColumnName]  ) <= 1
                                source, row[ColumnName]
                            ),
                        type text
                    )

            in
                col_containsTest,