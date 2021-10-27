let
/*
    This query's final output is either: (in order)

    - library record if parsing works
    - directory listing, if file did not exist
    - library error location, if failed parsing
*/
    fullPath = #"PQLib Path" & "\" & #"PQLib Version",

    // list scripts, I did not hard code filtering for ".pq"
    table_listSourceFilesInDirectory
        = let
            listFiles = Folder.Contents( #"PQLib Path" ),
            sortedFiles = Table.Sort(listFiles,{{"Date modified", Order.Descending}})
        in
            sortedFiles,

    bytes = File.Contents( fullPath ),
    raw_text = Text.FromBinary( bytes, TextEncoding.Utf8 ),
    final_evaluation = try Expression.Evaluate( raw_text , #shared ),

    FormatError = (source as any) as any =>
        error "NYI: refactor the formatting logic",

        error_ast = final_evaluation[Error],
        error_json = Text.FromBinary( Json.FromValue( final_evaluation[Error] ), TextEncoding.Utf8 ),
        summary_message = Text.Replace( error_ast[Message], "] ", "]#(cr,lf)"),

        // converts strings "[171-18-171-28]" to structured location data
        error_location
            =  let
                rawText = Text.AfterDelimiter( Text.BeforeDelimiter( error_ast[Message], "]"), "["),
                pairs = Text.Split( rawText, "-"),
                return = [
                        StartLine = Number.From( Text.BeforeDelimiter( pairs{0}, "," )),
                        StartColumn = Number.From( Text.AfterDelimiter( pairs{0}, "," )),
                        EndLine = Number.From( Text.BeforeDelimiter( pairs{1}, "," )),
                        EndColumn = Number.From( Text.AfterDelimiter( pairs{1}, "," ))
                ]
            in
                return,

        actual_lines = Lines.FromText(raw_text),
        code_at_location = Lines.ToText( List.Range( actual_lines,
            error_location[StartLine] - 1, error_location[EndLine] + 1) ),

        formatted_errors = Table.FromRecords(
            {[
                Message = summary_message,
                Location = error_location,
                Code = code_at_location,
                json =  error_json
            ]},
            type table [
                Message = text,
                Code = text,
                json = text,
                Location = Record.Type
            ],
            MissingField.Error
        ),

        return
            =
            /* note: read error of 'try bytes' still returns HasError = False, when file does not exist, so I test for 'DataSource.Error'

            */
            if #"PQLib Version" = "" then table_listSourceFilesInDirectory
            else if (final_evaluation[HasError] and final_evaluation[Error][Reason] = "DataSource.Error")
                then table_listSourceFilesInDirectory
            else if not final_evaluation[HasError]
            then final_evaluation[Value]
            else formatted_errors
in
    return