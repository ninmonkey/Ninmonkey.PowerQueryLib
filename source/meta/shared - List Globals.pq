let
    Source = #shared,
    t1 = Record.ToTable(Source),
    #"Remove Self" = Table.SelectRows( t1, each [Name] <> "List Globals" ),
    t2 = Table.Sort(
        #"Remove Self",
        {{"Name", Order.Ascending}}),

    colTypeNameText = Table.AddColumn(
        t2,
        "TypeNameText",
        each Type.ToText( Value.Type([Value]) ),
        type text)
in
    colTypeNameText
