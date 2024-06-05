let
    GroupBy.ShowCounts = (
        source      as table,
        columnNames as list

    ) as table => [

        columnNames = Columns.ThatExist(source, columnNames ),
        grouped     = Table.Group( source, columnNames, {
            {   "Distinct",
                each Table.RowCount( Table.Distinct( _, columnNames ) ),
                Int64.Type },

            {   "Count",
                each Table.RowCount(_),
                Int64.Type }
        }),
        return = grouped

    ][return]

/*
    //   distinct_per_pair = Table.Group(Source, {"Species", "Region"}, {{"Distinct", each Table.RowCount(Table.Distinct(_, {"Species", "Region"})), Int64.Type}, {"Count", each Table.RowCount(_), Int64.Type}})


*/
in GroupBy.ShowCounts