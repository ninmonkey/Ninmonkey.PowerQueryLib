let

    Source = #sections,
    Config = [
        IgnoreQueries = {"Query Summary"},
        KeepColumns = { "Query", "Type", "Table Meta" },
        HideNonTables = false
    ],
    /*
        Summarize (all?) queries
        future:
            - [ ] apply schema, to have a better expansion
    */
    Query.Summary = (
        optional ignoredKeys as nullable list
    ) as any => //table =>
        let
            source = Record.RemoveFields(
                #sections[Section1],
                (ignoredKeys ?? {"Query Summary"})
            ),
            baseTable = Record.ToTable( source ),
            t1 = Table.AddColumn(
                baseTable, "Type",
                each
                    Value.Type( _[Value] ),
                Type.Type
            ),
            t2 = Table.AddColumn(
                t1, "TypeName",
                each
                    Type.ToText( Value.Type( _[Value] )),
                type text
            ),
            t3 = Table.AddColumn(
                t2, "Table Schema",
                (row) =>
                    if row[TypeName] = "Table"
                    then Table.Schema( row[Value] )
                    else null,
                Table.Type
            ),
            finalMeta = t3
        in
            finalMeta,
    Invoke = Query.Summary( Config[IgnoreQueries] )
in
    Invoke