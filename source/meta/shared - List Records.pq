let
    /* this generates 'List Record.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "Record" ),
    t1 = Table.RemoveColumns(
        Source,
        {"TypeNameText"}),

    t2 = Table.Sort(
        t1,
        { {"Name", Order.Ascending}, {"Value", Order.Ascending}})
in
    t2
