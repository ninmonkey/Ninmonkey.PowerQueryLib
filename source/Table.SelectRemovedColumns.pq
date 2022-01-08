let
    // For when you're using Table.SelectColumns(), easily view only the removed columns
    Table.SelectRemovedColumns = (source as table, previousTable as table) as any =>
        let
            sourceCols = Table.ColumnNames(source),
            prevCols = Table.ColumnNames(previousTable),
            deltaCols = List.RemoveMatchingItems(sourceCols, prevCols),
            selectMissing = Table.SelectColumns( source, deltaCols ),
            return = [
                deltaCols = deltaCols,
                selectMissing = selectMissing
            ]
        in
            selectMissing
in
    Table.SelectRemovedColumns