let
    // Sanity = let
    var = [
        dimIdList = #"dim Unit"[Unit Id],
        factIdList = Rations[Unit Id],
        source = Rations
    ],
    sanityTest = List.Transform(
        var[factIdList],
        (item) =>
            let
                exists = List.Contains( var[dimIdList], item)
            in
                if exists then item
                else error Error.Record(
                    "SanityFailed", "Id exists in fact table but not dim table!", item )
    ),
    base_table = Table.FromList(sanityTest, Splitter.SplitByNothing(), type table[Id = Int64.Type], null, ExtraValues.Error),
    #"Kept Errors" = Table.SelectRowsWithErrors(base_table),

    error_integrity =
        if Table.RowCount( #"Kept Errors" ) > 0 then
        error Table.First( #"Kept Errors" )
        else base_table,

    error_isDistinct =
        if Table.IsDistinct( var[source], {"Date", "Unit Id"} ) then true
        else error Error.Record("TableNotDistinct", "Columns {Date, Unit Id}", var[source] ),

    error_list = List.Select(
        { try error_integrity, try error_isDistinct},
        (item) => item[HasError]
    ),

    error_table = Table.FromRecords(error_list),
    #"Added Custom" = Table.AddColumn(error_table, "MaybeError", each if not [HasError] then "ok" else error Error.Record("had error", "error", error [Error] ))
in
    #"Added Custom"

    // sanityTable = Table.FromList(
    //     sanityTest

    // ),

//     final = Table.AddColumn(
//         sanityTable, "Valid",
//         each
//             if [Exists] then true else
//             error Error.Record("SanityFailed", "Id exists in fact table but not dim table!", [Id] )),
//     #"Kept Errors" = Table.SelectRowsWithErrors(final)


// in
//     #"Kept Errors"