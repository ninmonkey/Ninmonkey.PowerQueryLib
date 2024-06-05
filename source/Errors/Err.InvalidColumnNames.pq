let
    // creates a new ErrorRecord fo you to throw

    Err.InvalidColumnNames = (
        source as table,
        columnNames as list,
        optional options as nullable record
    ) as record => [

        // or table source could be name,
        // assert = if sourceOrName is table then
        //     Columns.ThatExist( sourceOrName, columnNames )
        // else
        //     true,
        // assertAllowedKeys = {"Reason", "Detail", "Message.Parameters", "Message.Format" },
        // tableName = if source is text then source else Expression.Identifier(source),
        FmtList        = TransformTo.TextList,
        FmtNL          = Format.JoinNewLine,
        MissingColumns = List.RemoveItems( columnNames, Table.ColumnNames( source) ),
        err = [
            Reason = options[Reason]? ?? options[ExceptionName]? ??
                "InvalidColumnsException",

            Detail = options[Detail]? ??
                "Exact column names did not match. Verify capitalization and whitespace",

            Message.Parameters = {
                source, // AsText?
                FmtList( columnNames ),
                FmtList( Table.ColumnNames(source) ),
                FmtList( MissingColumns )
            },
            Message.Format = options[Message.Format]? ??
                FmtNL({ "",
                        "RequiredParameterMissingValues ColumnNames: ",
                        "Table: #{0}",
                        "Wanted: ",
                        "    #{1}",
                        "Found: ",
                        "    #{2}",
                        "Missing: ",
                        "    #{3}"
                    })
            ]
        ][err]

in Err.InvalidColumnNames