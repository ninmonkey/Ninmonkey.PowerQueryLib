    Table.RemoveBlankColumns = (source as table, optional options as nullable record) as any =>//as table =>
        let
            blankColumns = Table.FindBlankColumns( source ),
            cols_to_keep = Table.SelectRows( blankColumns, each [ContainsNonBlank] = true )[ColumnName],
            drop_emptyCols = Table.SelectColumns( source, cols_to_keep )
        in
            drop_emptyCols,