// Text_IsNullOrWhitespace
// Text_IsNullOrWhitespace
let
    runTests = false,
    Text_IsNullOrWhitespace = (source as nullable text) as logical =>
        /* True when source only contains: null or whitespace or control chars

            [string]::IsNullOrWhitespace()
        */
        let
            trimClean = Text.Trim( Text.Clean( source ) ),
            len = Text.Length(trimClean)
        in
            source is null or len = 0,
    tests = {
        Text_IsNullOrWhitespace("#(tab)#(cr,lf)"),
        Text_IsNullOrWhitespace("     "),
        Text_IsNullOrWhitespace(""),
        Text_IsNullOrWhitespace(null)
    }
in
    if runTests then tests else Text_IsNullOrWhitespace

// Text_WhitespaceToNull
let
    runTests = false,

    Text_WhitespaceToNull = (source as nullable text) as nullable text =>
        /* convert text columns to equal null if they are whitespace only
        */
        let
            // isEmpty = Text.Length( Text.Trim(source) ) = 0
            isEmpty = Text_IsNullOrWhitespace(source)
        in
            if isEmpty then null else source,

    tests = {
        Text_WhitespaceToNull("  "),
        Text_WhitespaceToNull("")
    }
in
    if runTests then tests else Text_WhitespaceToNull

// Table_TransformColumns_WhitespaceToNull
let
    runTests = false,
    Table.TransformColumns_WhitespaceToNull = (source as table, columnNames as list) as table =>
        /* convert text columns to equal null if they are whitespace only
        */
        let
            transformsList = List.Transform(
                columnNames,
                (colName as text) as list => {
                    colName, Text_WhitespaceToNull, type nullable text
                }
            ),
            finalTable = Table.TransformColumns(
                source, transformsList, each _, MissingField.Error
            )
        in
            finalTable,
            // if isEmpty then null else source,








    tests = {
        // transform_WhitespaceToNull("  "),
        // transform_WhitespaceToNull("")
    }
in
    if runTests then tests else Table.TransformColumns_WhitespaceToNull