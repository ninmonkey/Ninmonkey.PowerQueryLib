let
    SampleInput = GenerateDocs_OnType, // as table,
    source = SampleInput,

    Table_ToMarkdown = (source as table) as any => // text ?
        let
            headerRow = Format_RowsToMarkdown( Table.ColumnNames(source) ),
            tableBody = generate_lines(source),
            finalText = Text.Combine(
                {headerRow, tableBody}, "#(cr,lf)")
        in
            finalText,


    /*

    Input: "foo", "bar"
    Output: | foo | bar |
    future:
        tie into the better text coercion funcs
    */
    Format_RowsToMarkdown = (row as record) as any => // text
            let
                values = Record.FieldValues(row),
                joinPipe = Text.Combine(values, " | "),
                finalString = Text.Combine({"|", joinPipe, "|"}, " ")
            in
                finalString,
    /*

    Input: "foo", "bar"
    Output: | foo | bar |
    future:
        tie into the better text coercion funcs
    */
    GenerateRows = (source as table) as list =>
        let
            generate_lines = Table.TransformRows(
                source, Format_RowsToMarkdown
            )
        in
            generate_lines,



    test = Table_ToMarkdown( SampleInput )
in
    test