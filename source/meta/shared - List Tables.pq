let
    /* this generates 'List Tables.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "Table" ),
    t1 = Table.RemoveColumns(
        Source,
        {"TypeNameText"}),

    t2 = Table.Sort(
        t1,
        { {"Name", Order.Ascending}}),

    colSchema = Table.AddColumn(
        t2, "Schema", each
            Table.Schema( [Value] )),

    t3 = Table.RemoveColumns( colSchema, {"Value"})
in
    t3
