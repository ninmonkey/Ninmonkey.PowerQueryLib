let
    /*
    future code
        get: Number of Table Rows
        test: Table.IsDistinct()
        additional metadata of table
            which primary keys are set

            generate record of table schema, then ToString()

    */
    options = [
        IgnoreQueries = {"Lib", "Listing of Queries"},
        HideNonTables = false
    ],
    Query.Summarize = (optional options as nullable record) =>
        let
            options = [
                IgnoreQueries = {"Lib", "Listing Of Queries"},
                HideNonTables = false
            ] & options,

            Source = Record.RemoveFields( #sections[Section1], options[IgnoreQueries] ),
            base = Record.ToTable( Source ),
            renamed_columns = Table.RenameColumns(base,
                { {"Name", "Query Name"} }),

            add_QueryType = Table.AddColumn(
                renamed_columns, "Query Type",
                (row) => Type.ToText( row[Value]  ),
                type text
            ),
            optional_removeNonTables =
                if not options[HideNonTables] then add_QueryType
                else Table.SelectRows( add_QueryType, each ([Query Type] = "Table" or [Value] is table)),

            add_Schema = Table.AddColumn(
                optional_removeNonTables, "Schema",
                (row) =>
                    if not (row[Value] is table) then null
                    else
                        try Table.Schema( row[Value]  )
                        catch (e) => error Error.Record(
                            "InnerException", "Table.Schema() failed",
                            e),
                type table
            ),
            add_Profile = Table.AddColumn(
                add_Schema, "Profile",
                (row) =>
                    if not (row[Value] is table) then null
                    else
                        try Table.Profile( row[Value]  )
                        catch (e) => error Error.Record(
                            "InnerException", "Table.Profile() failed",
                            e),
                type table
            ),
            sort_type = Table.Sort( add_Profile, {
                {"Query Type", Order.Descending}} ),

            final = sort_type,

            // converts values to typenames as text
            Type.ToText = (typeInfo as any) as text =>
                    let
                        name =
                            if typeInfo is null then "Null"
                            else if typeInfo is type then "Type"
                            else if typeInfo is binary then "Binary"
                            else if typeInfo is number then "Number"
                            else if typeInfo is function then "Function"
                            else if typeInfo is list then "List"
                            else if typeInfo is table then "Table"
                            else if typeInfo is record then "Record"
                            else "Other" meta [ ValueType = typeInfo ]
                    in
                        name
            in
                final
    in
    Query.Summarize