// CoerceToTable
let
    CoerceToTable =
        (source as any) as any =>
            // as table =>
            let
                // currently these are redundant as case statements, but I may use multiple later
                isRecord = Type.Is(sourceType, Record.Type),
                isTable = Type.Is(sourceType, Table.Type),
                isText = Type.Is(sourceType, Text.Type),
                sourceType = Value.Type(source),
                other =
                    error
                        Error.Record(
                            "UnhandledTypeConversion",
                            "UnhandledType",
                            sourceType
                        )
            in
                if false then
                    null
                else if isRecord then
                    Record.ToTable(source) as table
                else if isText then
                    #table(1, {source}) as table
                else if isTable then
                    source as table
                else
                    try other catch (e) => e[Message]
in
    CoerceToTable