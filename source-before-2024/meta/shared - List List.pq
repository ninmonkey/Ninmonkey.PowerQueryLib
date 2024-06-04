let
    /* this generates 'List Lists.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "list" ),
    t1 = Table.RemoveColumns(
        Source,
        {"TypeNameText"}),

    t2 = Table.Sort(
        t1,
        { {"Name", Order.Ascending}, {"Value", Order.Ascending}}),
    t3 = Table.RemoveColumns( t2, {"Value"})
in
    t3
