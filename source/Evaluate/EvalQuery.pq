let
    /*
    ## About

    executes an external power query text file

    [1] You can edit 'c:\myquery.pq' in an external editor like VS Code
    [2] Save, then hit "Refresh" or "Apply" in Power BI

    This is nice for local development. ,   lets you dynically load powerquery files for local developement


    ## Valid Keys for 'options' Record  : [
        Environment: defaults to #shared
        Encoding   : defaults to Utf8
    ]

    */
    EvalQuery.Type = type function (
        filePath as text,
        optional options as nullable record
    ) as any meta [
            Documentation.Name = "EvalQuery",
            Documentation.LongDescription = Text.Combine({
                "Execute a local .pq file", "", "useful for importing modules as one query",""
            }, "<br>")
        ],

    EvalQuery.Impl = (
        filePath as text,
        optional options as nullable record

    ) as any => [

        encoding    = options[Encoding]?    ?? TextEncoding.Utf8,
        environment = options[Environment]? ?? #shared,
        bytes       = File.Contents( filePath ),
        lines       = Text.FromBinary( bytes, encoding ),
        return      = Expression.Evaluate( lines, environment )
    ][return]
in
    Value.ReplaceType( EvalQuery.Impl, EvalQuery.Type )
