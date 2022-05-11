let
    // Type.ToText = lib[Type.ToText],

    // todo: next: Autodetect cyclical refs
    ParameterQuery.Summary = (environment as nullable record, ignoreQueries as list) as any =>
        let
            ignoreQueries = ignoreQueries ?? {"lib", "Readme", "SummarizeReportParams" },
            source = environment ?? #sections[Section1],
            removeCyclicalRef = Record.RemoveFields(  source , ignoreQueries ),

            baseTable = Record.ToTable( removeCyclicalRef ),
            #"Added Custom" = Table.AddColumn(baseTable,
                "Typename",
                (_) as text =>
                    Type.ToText( Value.Type( [Value] ) ),
                 type text
            ),

            getMetadata = Table.AddColumn(
                #"Added Custom", "Meta",
                each Value.Metadata( [Value] )
            ),

        // met = Value.Metadata( [Value] ),
        #"Filtered Rows" = getMetadata
        // ]),
        //     #"Expanded Meta" = Table.ExpandRecordColumn(#"Added Custom1", "Meta", {"mtype", "met"}, {"mtype", "met"}),
        //     #"Expanded met" = Table.ExpandRecordColumn(#"Expanded Meta", "met", {"IsParameterQuery", "List", "DefaultValue", "Type", "IsParameterQueryRequired", "ExpressionIdentifier"}, {"met.IsParameterQuery", "met.List", "met.DefaultValue", "met.Type", "met.IsParameterQueryRequired", "met.ExpressionIdentifier"}),
        //     #"Filtered Rows" = Table.SelectRows(#"Expanded met", each ([met.IsParameterQuery] = true))

        // in [ t1 = Custom5, fin = #"Filtered Rows" ]
        in
            #"Filtered Rows"
    in
        ParameterQuery.Summary
