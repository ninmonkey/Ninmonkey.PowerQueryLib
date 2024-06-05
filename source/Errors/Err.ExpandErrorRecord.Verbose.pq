let
    /*
    About:
        accepts an error record merging its data and metadata as one record
    see also:
        Err.ExpandErrorRecord.pq - start here, this is a lot simpler to use
        Err.ExpandErrorRecord.Verbose.pq - when you want an excessive amount of details
    */
    // when you want extra details on an exception, mainly for interactive use.
   Err.ExpandErrorRecord.Verbose = (exception as any, optional options as nullable record) => [
        // options = Record.Combine({
        //     defaults,
        //     (options ?? [])  // does this cause the unexpectStete of object
        // }),
        // defaults = [
        //     // include error info, or simplify to hide most properties?
        //     DropFieldNames = {
        //         // "Expression.Stack"
        //         // "Stack_JsonAbbr_List_Simple",
        //         // "Stack_Json_List_Str", // triggers error, I think because delayed evaluation of record values. further down Stack_JsonAbbr_ListSimple = [list] throws
        //         // "Stack_Json_OneLine",
        //         // "ModuleVersion"
        //     }
        // ],
        Json = (source as any) as text => Text.FromBinary( Json.FromValue( source ) ),
        return = [
            Err.Type         = Value.Type( exception ),
            Err              = exception,
            Err.Meta         = Value.Metadata( Err ),
            Err.TypeMeta     = Value.Metadata( Value.Type( Err ) ),
            Err.MetaKeyNames = Text.Combine( Record.FieldNames( Err.Meta ), ", " ),

            Reason             = Err[Reason]? ?? null,
            Message            = Err[Message]? ?? null,
            Detail             = Err[Detail]? ?? null,
            Message.Format     = Err[Message.Format]? ?? null,
            Message.Parameters = Err[Message.Parameters]? ?? null,

            Expression.Stack    = Err.Meta[Expression.Stack]? ?? null,
            Stack_Json          =
                Text.Combine(
                    List.Transform(
                        Expression.Stack,
                        (item) => Json( item )
                    ), "#(cr,lf)"
                ),
            ActivityId    = Diagnostics.ActivityId(),
            ModuleVersion = Module.Versions()
        ]

    ][return]
in
    Err.ExpandErrorRecord.Verbose