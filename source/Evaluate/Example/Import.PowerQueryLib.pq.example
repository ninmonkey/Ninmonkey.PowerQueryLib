/*
about: This is a fancy version of EvalQuery using a report parameter
*/
let
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
        // ][ret],
        ],

    FinalEval =
        try EvalQuery( SharedUtils_Path )
        catch (e) =>
            File.ShowError( SharedUtils_Path, Convert.ScriptExtent.FromError( e ), [
                LinesOfContext = 10
            ] )
in
    FinalEval
