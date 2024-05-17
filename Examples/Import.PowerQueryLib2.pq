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
*/

// with extra
let
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
                RawText           = err[Message]
            ]
        ][ret],

        File.ShowError = ( path as text, extent as record) => [
            LinesOfContext = 2,
            contents      = Lines.FromBinary( File.Contents( path ), QuoteStyle.None, false, TextEncoding.Utf8 ),
            linesCount    = extent[EndLineNumber] - extent[StartLineNumber],
            selectedLines = List.Range( contents, extent[StartLineNumber] - LinesOfContext, linesCount + LinesOfContext ),
            prefix        = {
                "Reason: #[Reason]#",
                "#Message: #[Message]#",
                "..."
            },
            merged = Text.Combine( prefix & selectedLines, "#(cr,lf)" ),
            ret = Text.Format( merged, [
                Reason = extent[Reason],
                Message = extent[Message]
            ] )
        ][ret],

    FinalEval =
        try EvalQuery( SharedUtils_Path )
        catch (e) =>
            File.ShowError( SharedUtils_Path, Convert.ScriptExtent.FromError( e ) )
in
    FinalEval
