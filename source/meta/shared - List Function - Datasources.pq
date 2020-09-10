let
    /* this generates 'List Datasurce Functions.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "Function" ),
    t1 = Table.RemoveColumns(
        Source,
        {"TypeNameText"}),

    t2 = Table.Sort(
        t1,
        { {"Name", Order.Ascending}}),
    #"Added Custom" = Table.SelectRows( t2, each Function.IsDataSource( [Value] ) )
in
    #"Added Custom"
