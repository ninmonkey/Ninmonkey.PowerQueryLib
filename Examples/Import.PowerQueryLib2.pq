/* a fancier version of the import function for Import.PowerQueryLib.pq, or other scripts */
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
    Path = "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\Day-01-Part2-FirstAndLastoccurrence-AsWords-OfNumber.pq",
    EvalQuery = (filePath as text, optional options as nullable record) as any => [
        encoding = options[Encoding]? ?? TextEncoding.Utf8,
        environment = options[Environment]? ?? #shared,
        bytes = File.Contents(filePath),
        lines = Text.FromBinary( bytes, encoding ),
        return = Expression.Evaluate( lines, environment )
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
                Reason      = err[Reason],
                Message     = err[Message],
                ErrorRecord = err,
                RawText     = err[Message]
        // retWithAssert =
        //     if finalAssert and Text.Contains( err[Message], "Expression.Error", Comparer.OrdinalIgnoreCase )
        //     then ret
        //     else error [Message.Format = "Unexpected error kind, was of type: #[Reason]: #[Message]", Message.Parameters = [
        //         Reason = err[Reason],
        //         Message = err[Message]
        //     // ]][retWithAssert]
        //     ]]
            ]
        ][ret],

        File.ShowError = ( path as text, extent as record) => [
            path = path ?? "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\pq.lib\2024.pq-lib.pq",
            contents = Lines.FromBinary( File.Contents( path ), QuoteStyle.None, false, TextEncoding.Utf8 ),
            linesCount =  extent[EndLineNumber] - extent[StartLineNumber],
            selectedLines = List.Range( contents, extent[StartLineNumber] - 2, linesCount + 2 ),
            prefix =  {
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

    asEval = EvalQuery( SharedUtils_Path ),
    FinalEval =
        try asEval
        catch (e) =>
            File.ShowError( SharedUtils_Path, Convert.ScriptExtent.FromError( e ) )
            // Convert.ScriptExtent.FromError( e ),
            // showFinal = File.ShowError( FinalEval[?])
in
    FinalEval
