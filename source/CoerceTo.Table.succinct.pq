// CoerceToTable
let
    // sugar to convert types to table, else text
    CoerceToTable =
        (source as any) as any => // as table =>
            let
                sourceType = Value.Type(source)
            in
                if Type.Is(sourceType, Record.Type) then
                    Record.ToTable(source) as table
                else if Type.Is(sourceType, Table.Type) then
                    source as table
                else if Type.Is(sourceType, Text.Type) then
                    #table(1, {source}) as table
                else
                    error Error.Record( "UnhandledTypeConversion", "UnhandledType", sourceType )
in
    CoerceToTable