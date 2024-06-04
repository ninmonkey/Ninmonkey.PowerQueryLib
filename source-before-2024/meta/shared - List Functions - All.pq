let
    /* this generates 'List Functions - All.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "Function" ),
    t1 = Table.RemoveColumns(
        Source,
        {"TypeNameText"}),

    t2 = Table.Sort(
        t1,
        { {"Name", Order.Ascending}}),
    #"Added Custom" = Table.AddColumn(t2, "IsDataSource", each Function.IsDataSource( [Value] ))
in
    #"Added Custom"
