let

    x1 =
    let
        Table.MergeDimensionTable = (source as table, dim as table, optional options as nullable record
        ) =>
            let
                t_join = Table.NestedJoin( source, {"Phone"}, dim, {"Phone"}, "Result", JoinKind.LeftOuter ),
                t_expand = Table.ExpandTableColumn( t_join, "Result", {"Id"}, {"Phone Id"})
            in  t_expand

    in
        Table.MergeDimensionTable,


    x2 = let
            Source = Table.FromRecords({
                [ Phone = "1234", User = "Bob"  ],
                [ Phone = "1234", User = "Jen"  ],
                [ Phone = "2234", User = "Fred" ],
                [ Phone = "3234", User = "Penny"],
                [ Phone = "4234", User = "Gary" ]
            }, type table[Phone = text, User = text], MissingField.Error),

        Table.ToDimensionTable = (source as table, column as text) =>
            let t0 = Table.Distinct( Table.SelectColumns(source, column, MissingField.Error) ),
                col_id = Table.AddIndexColumn(t0, "Id", 0)
            in  col_id,

        dimPhone = Table.ToDimensionTable( Source, "Phone" ),
        dimUser = Table.ToDimensionTable( Source, "User" ),
        // t0 = Table.Distinct( Table.SelectColumns( Source, {"Phone"}) ),
        // dimTable_Phone = Table.AddIndexColumn(t0, "Index", 0, 1, Int64.Type)
        Summary = [
            Source = Source,
            dimPhone = dimPhone,
            dimUser = dimUser
        ]
    in
        Summary
in
    x2