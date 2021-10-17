let
    List.Schema = ( items as list ) as table =>
        let
            recordList = List.Transform(
                items,
                (item as any) as record => [
                    Type = Type.ToText( Value.Type(item) ),
                    Value = item
                ]
            ),
            schemaTable = Table.FromRecords(
                recordList,
                type table[Type = text, Value = any]
            )

        in schemaTable
in
    List.Schema
