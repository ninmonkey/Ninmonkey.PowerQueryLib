let
    ReplaceMultipleValues = (originalTable as table, targetColumnName as text, valuePairs as any )  =>

    let

        //check whether the valuePairs is table or list and convert to a table:
        VP = if Value.Is(valuePairs, List.Type)
            then Table.FromRows(valuePairs, {"Original", "New"})
            else valuePairs,

        // Store the type of the original column,
        // which we will use later to convert
        // the value to the appropriate type
        OriginalType = Type.TableColumn(
            Value.Type(originalTable),
            targetColumnName
        ),

        // Get the column which contains the original,
        // to-be-repalced values
        R1 = Table.FromList(
            Table.Column(
                originalTable,
                targetColumnName
            )
        ),

        // Add a field of type _list_ with value pairs
        AddLookup = Table.AddColumn(
                VP,
                "Lookup",
                each
                {
                Record.Field(_, Table.ColumnNames(VP){0}),
                Record.Field(_, Table.ColumnNames(VP){1})
                }
        ),

        // Transform the original value field to a field of type list
        // with only one element
        R2 = Table.AddColumn(
                R1,
                "__OriginalValueAsList",
                each (
                Text.Split(
                    Record.Field(_, Table.ColumnNames(R1){0}),
                    "")
                )
        ),

        // Execute the replace using the two lists
        R3 = Table.AddColumn(R2, "Replaced Values",
            each Text.Combine(
                    List.ReplaceMatchingItems(
                            [__OriginalValueAsList],
                            AddLookup[Lookup]),
                    ""
                    ),
                OriginalType
                ),

        // Drop columns which we don't need anymore
        // What is left is a table with one column which contains the replaced values only
        R4 = Table.RemoveColumns(
            R3,
            {"Column1", "__OriginalValueAsList"}
        ),

        //Remove original column from the original table
        T1 = Table.RemoveColumns(
            originalTable,
            targetColumnName
        ),

        // Add the new column with replaced values
        T2 = Table.FromColumns(
            Table.ToColumns(T1) & Table.ToColumns(R4),
            Table.ColumnNames(T1) & {targetColumnName}
        )

    in
        // And return it from the function
        T2,

    documentation = [
    Documentation.Name = "ReplaceMultipleValues",
    Documentation.Description = "Replaces all values in targetColumnName column  using the valuePairs lookup table",
    Documentation.LongDescription = "Replaces all values in targetColumnName column in originalTable table using the valuePairs lookup table. valuePairs lookup table could be either a list or a table and should contain at least two columns and each replacement pair is a record in the table",
    Documentation.Category = "Miscellaneous functions",
    Documentation.Source = "TBD.",
    Documentation.Version = "1.0",
    Documentation.Author = "Peter Budai: http://www.pbimaster.com",
    Documentation.Examples = {[Description = " ",
    Code = "ReplaceMultipleValues(originalTable table, Area as text, { {""WE"", ""Western Europe""}, {""DE"", ""Germany""} } as table)",
    Result = "table (as table)"]}]
in

    Value.ReplaceType(ReplaceMultipleValues, Value.ReplaceMetadata(Value.Type(ReplaceMultipleValues), documentation))
