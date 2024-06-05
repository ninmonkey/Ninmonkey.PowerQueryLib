let
    /*
    About:
        accepts an error record merging its data and metadata as one record
    see also:
        Err.ExpandErrorRecord.pq - start here, this is a lot simpler to use
        Err.ExpandErrorRecord.Verbose.pq - when you want an excessive amount of details
    */
    // when you want extra details on an exception, mainly for interactive use.
    Err.ExpandErrorRecord = (
        exception        as any,
        optional options as nullable record
    ) => [
        Json = (source as any) as text => Text.FromBinary( Json.FromValue( source ) ),
        return = [
            // Er_Type         = Value.Type( exception ), // is alway a record?
            Err              = exception,
            Err.Meta        = Value.Metadata( Err ),
            ErTypeMeta      = Value.Metadata( Value.Type( Err ) ),
            ErMeta_KeyNames = Text.Combine( Record.FieldNames( Err.Meta ), ", " ),

            Reason             = Err[Reason]? ?? null,
            Message            = Err[Message]? ?? null,
            Detail             = Err[Detail]? ?? null,
            Message.Format     = Err[Message.Format]? ?? null,
            Message.Parameters = Err[Message.Parameters]? ?? null,

            Expression.Stack       = Err.Meta[Expression.Stack]? ?? null,
            Expression.Stack.Json       = Json( Expression.Stack ),
            Expression.Stack.JsonLines  =
                Text.Combine(
                    List.Transform(
                        Expression.Stack,
                        (item) => Json( item )
                    ),
                "#(cr,lf)" ),

            ActivityId      = Diagnostics.ActivityId(),
            ModuleVersion = Module.Versions()
        ]

    ][return]
in
    Err.ExpandErrorRecord