// PQ_Library_Path
"H:\data\2024\tabular\Ninmonkey.PowerQueryLib\build\2024-04.ninlib.pq" meta [IsParameterQuery=true, List={"H:\data\2024\tabular\Ninmonkey.PowerQueryLib\build\2024-04.ninlib.pq", "H:\data\2024\tabular\Ninmonkey.PowerQueryLib\build\2022-01.ninlib.pq", "c:\pq\your-lib.pq", "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\pq.lib\2024.pq-lib.pq"}, DefaultValue="H:\data\2024\tabular\Ninmonkey.PowerQueryLib\build\2024-04.ninlib.pq", Type="Text", IsParameterQueryRequired=true]

// lib
/* a fancier version of the import function for Import.PowerQueryLib.pq, or other scripts
let
    // evaluates a .pq text file that's editable outside of power bi, without pasting updates. just refresh.
    EvalQueryFunc = (filePath as text, optional options as nullable record) as any => [
        encoding = options[Encoding]? ?? TextEncoding.Utf8,
        environment = options[Environment]? ?? #shared,
        bytes = File.Contents(filePath),
        lines = Text.FromBinary( bytes, encoding ),
        return = Expression.Evaluate( lines, environment )
    ][return]
in
    EvalQueryFunc

    <file:///H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\pq.lib\2024.pq-lib.pq>

*/

// with extra
let
    // AsWebRequest = Web.Contents( "https://github.com", [RelativePath = "/ninmonkey/Ninmonkey.PowerQueryLib/blob/318cea1e52b2d1ab456a004dca79d235dec3f82e/build/2024-04.ninlib.pq" ]),

    /* this is the entry point */
    EvalQuery = (filePath as text, optional options as nullable record) as any => [
        encoding    = options[Encoding]? ?? TextEncoding.Utf8,
        environment = options[Environment]? ?? #shared,
        bytes       = File.Contents(filePath),
        lines       = Text.FromBinary( bytes, encoding ),
        return      = Expression.Evaluate( lines, environment )
    ][return],

    Convert.ScriptExtent.FromError = (err as any) => [
            Split.ScriptExtent = Splitter.SplitTextByEachDelimiter({"[", ",", "-", ",", "]"}, QuoteStyle.None),
            lineData = Split.ScriptExtent( err[Message] ),
            ret = [
                StartLineNumber   = Number.FromText( lineData{1}? ),
                StartColumnNumber = Number.FromText( lineData{2}? ),
                EndLineNumber     = Number.FromText( lineData{3}? ),
                EndColumnNumber   = Number.FromText( lineData{4}? ),
                RemainingMessage  = lineData{5}?,                      // shouldn't be more than 1 index?
                Reason            = err[Reason],
                Message           = err[Message],
                ErrorRecord       = err,
                ErrorDetailsJson  = [
                    target = ErrorRecord[Detail]?,
                    json   = Json.FromValue( target, TextEncoding.Utf8 ),
                    string = try Text.FromBinary( json, TextEncoding.Utf8 ) catch (e) => null
                ][string],
                RawText           = err[Message]
            ]
        ][ret],

        File.ShowError = ( path as text, extent as record, optional options as nullable record) => [
            LinesOfContext = options[LinesOfContext]? ?? 2,
            Extent = extent,
            Bytes          = File.Contents( path ),
            SourceMeta     = Value.Metadata( Bytes ),
            Contents       = Lines.FromBinary( Bytes, QuoteStyle.None, false, TextEncoding.Utf8 ),
            LinesCount     = extent[EndLineNumber] - extent[StartLineNumber],
            SelectedLines  = List.Range( Contents, extent[StartLineNumber] - LinesOfContext, LinesCount + LinesOfContext ),
            Prefix         = {
                "Reason: #[Reason]",
                "Path: #[LineNumber], #[FullPath]",
                "Message: #[Message]",
                "...",
                "RemainingMessage: #[RemainingMessage]",
                "DetailsJson: #[ErrorDetailsJson]",
                "...",
                "Context: "
            },
            MergedTemplate = Text.Combine( Prefix & SelectedLines, "#(cr,lf)" ),
            ret = Text.Format( MergedTemplate, [
                Reason           = extent[Reason],
                Message          = extent[Message],
                LineNumber       = extent[StartLineNumber]?,
                RemainingMessage = extent[RemainingMessage]?,
                ErrorDetailsJson = extent[ErrorDetailsJson]?,
                FullPath         = path
            ] )
        ][ret],
        // ],

    FinalEval =
        try EvalQuery( PQ_Library_Path )
        catch (e) =>
            File.ShowError( PQ_Library_Path, Convert.ScriptExtent.FromError( e ), [
                LinesOfContext = 5
            ] )
in
    FinalEval

// lib_meta
let
    // summarize the module
    Source = lib,
    top_items = Table.Buffer(
        Table.FromValue( lib ), [ BufferMode = BufferMode.Delayed ] ),

    // Custom1 = top_items,
    procRow = ( source as any) as nullable record => [
        target  = Value.Metadata( Value.Type( source ) ),
        hasKeys = Record.FieldCount( target ) > 0,
        ret     = if hasKeys then source else null
    ][target],
    // #"Added Custom" = Table.AddColumn(Custom1, "Custom", (row) => procRow(row), Record.Type )
    #"Added Custom" = Table.AddColumn(top_items, "Custom", (row) => procRow( row[Value] ), type any)
in
    #"Added Custom"