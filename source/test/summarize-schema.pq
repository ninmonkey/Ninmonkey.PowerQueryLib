let
    Source = AllRecords,
    Schema = Table.Schema( Source ),

    #"Drop Most Properties" = Table.ReorderColumns(
        Schema,{"Name", "TypeName", "Kind", "IsNullable", "Position", "NumericPrecisionBase",
        "NumericPrecision", "NumericScale", "DateTimePrecision", "MaxLength", "IsVariableLength",
        "NativeTypeName", "NativeDefaultExpression", "NativeExpression", "Description", "IsWritable", "FieldCaption"}),

    // summarizes column types and name as a string
    SummarizeSchemaColumn =
        (column as record,
        optional options as nullable record) as any =>
            let
                options = Record.Combine({default, options ?? []}),
                default = [
                    Template = "[#[AscribedTypeName]]: #[ColName]#[Nullability] = #[TypeName]#[Nullability]"
                ],
                render  = Text.Format(
                    options[Template],
                    [
                        AscribedTypeName = column[TypeName],
                        TypeName = column[Kind],
                        ColName = column[Name],
                        Nullability = if column[IsNullable] then "?" else ""
                    ]
                )
            in
                render,

    #"Removed Other Columns" = Table.SelectColumns(
        #"Drop Most Properties",{"Name", "TypeName", "Kind", "IsNullable", "Position"}),

    #"Summarized Cols" = Table.AddColumn(
        #"Removed Other Columns",
        "Summary",
        (row as record) as any =>
            try SummarizeSchemaColumn( row ) catch (e) => e,
        type text
    ),
    Summary = #"Summarized Cols",
    #"Reordered Columns" = Table.ReorderColumns(Summary,{"Summary", "Name", "TypeName", "Kind", "IsNullable", "Position"})
in
    #"Reordered Columns"