
let
    /*
    Asserts if columns are valid, return their names as a list
    otherwise throw

        in:  { "Name", "Id" }
        out: good
            { "Name", "Id"}
        out: bad
            error Exception for missing columns

    */
        Columns.ThatExist = (
            source      as table,
            columnNames as list
        ) as any => [

            actual_columnNames = Table.ColumnNames(source),
            all_exist = List.ContainsAll( actual_columnNames, columnNames, Comparer.Ordinal ),
            assert     = all_exist,
            valid_data = columnNames,

            error_missingMandatory =
                // The ErrorRecord from Err.InvalidColumnNames contains
                // Message.Parameters, if you want  to drill down into columnNames, and table
                Err.InvalidColumnNames( source, columnNames )
                meta [
                    NinAssertName = "Columns.ThatExist",
                    Activity      = Diagnostics.ActivityId() ],
            return =
                if assert then valid_data
                else error error_missingMandatory

        ][return]
    in
        Columns.ThatExist