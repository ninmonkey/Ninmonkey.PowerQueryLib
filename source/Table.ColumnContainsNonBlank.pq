
    Table.ColumnContainsNonBlank = (source as table, columnName as text) as logical =>
        // Test.ColumnIsBlank
        // future: source could optionally be a list, then drop the colukmn name args
        let
            col = Table.Column(source, columnName),
            containsNonBlank = List.MatchesAny( col, each _ <> null)
        in
            containsNonBlank,