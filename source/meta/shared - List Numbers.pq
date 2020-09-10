let
    /* this generates 'ListNumbers.csv' */
    Source = Table.SelectRows( #"List Globals" , each [TypeNameText] = "number" ),
    t1 = Table.TransformColumnTypes(
        Source,
        {{"Value", type number}}),
    t2 = Table.RemoveColumns(t1,{"TypeNameText"}),
    Final = Table.Sort( t2,
        {{"Name", Order.Ascending}, {"Value", Order.Ascending}})
in
    Final
