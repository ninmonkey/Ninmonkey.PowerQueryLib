let
    /* this generates 'List_Constants-All.csv' */
    Source = Table.SelectRows( #"List Globals" ,
        each List.Contains(
            { "text", "number" },
            [TypeNameText] )
    ),
    t1 = Table.RemoveColumns(
        Source,
        {"TypeNameText"}),

    t2 = Table.Sort(t1,
        {{"Name", Order.Ascending},
        {"Value", Order.Ascending}}
    )
in
    t2
