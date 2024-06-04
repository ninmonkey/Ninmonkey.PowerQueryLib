let
    /* this generates 'ListTypes.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "type" ),
    t1 = Table.RemoveColumns(
        Source,
        {"Value", "TypeNameText"}),

    t2 = Table.Sort(
        t1,
        {{"Name", Order.Ascending}})
in
    t2
