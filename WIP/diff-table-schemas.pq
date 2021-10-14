// CompareTableCols
let
    source1 = let
        miguel = #table(
            type table[Label = text, Num = number],
            { {"A", 1} }
        ),
        /*
        this step is mostly redundant because I declared a table type (ie: schema)
        But -- this next step actually converts the values, and uses the current locale
        for converting text to numbers/dates/times/etc
        */
        miguel_typed  = Table.TransformColumnTypes(
            miguel, { {"Num", type number} }
        ),
        FinalTable = Table.AddColumn(
            miguel_typed,
            "New",
            (row as record) as number =>
                Number.Acos( row[Num] ),
                Int64.Type
        )
    in
        FinalTable,
    source2 = let
        miguel = #table(
            type table[Label = text, Num = Int64.Type],
            { {"B", 1} }
        ),
        /*
        this step is mostly redundant because I declared a table type (ie: schema)
        But -- this next step actually converts the values, and uses the current locale
        for converting text to numbers/dates/times/etc
        */
        miguel_typed  = Table.TransformColumnTypes(
            miguel, { {"Num", Int64.Type} }
        ),
        FinalTable = Table.AddColumn(
            miguel_typed,
            "New",
            (row as record) as number =>
                Number.Acos( row[Num] ),
                Int64.Type
        )
    in
        FinalTable,
    raw_list = {source1, source2},
    Custom1 = Table.Combine(raw_list),
    #"add schema" = List.Transform(raw_list, (t as table) => Table.AddColumn(t, "schema", each Table.Schema(t), Table.Type) ),
    Custom2 = Table.Combine( #"add schema" ),
    #"Expanded schema" = Table.ExpandTableColumn(Custom2, "schema", {"Name", "Position", "TypeName", "Kind", "IsNullable", "NativeTypeName"}, {"Name", "Position", "TypeName", "Kind", "IsNullable", "NativeTypeName"}),
    #"Sorted Rows" = Table.Sort(#"Expanded schema",{{"Label", Order.Ascending}, {"Position", Order.Ascending}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Sorted Rows",{{"Kind", type text}, {"Label", type text}, {"Num", Int64.Type}, {"New", Int64.Type}, {"Name", type text}, {"Position", Int64.Type}, {"TypeName", type text}, {"IsNullable", type logical}, {"NativeTypeName", type any}}),
    #"Sorted Rows1" = Table.Sort(#"Changed Type",{{"Name", Order.Ascending}, {"Label", Order.Ascending}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Sorted Rows1",{"TypeName", "Label", "Num", "New", "Name", "Position", "Kind", "IsNullable", "NativeTypeName"})
            // each Number.Acos( [Column1] ),
            // (__) as number =>  Number.Acos( [Column1] ),
            // (__) as number =>  Number.Acos( [Column1] ),
            // type any

in
    #"Reordered Columns"