[
    Convert.ScriptExtent.FromError = (err as any) => [
            Split.ScriptExtent = Splitter.SplitTextByEachDelimiter({"[", ",", "-", ",", "]"}, QuoteStyle.None),
            lineData = Split.ScriptExtent( err[Message] ),
            return = [
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
        ][return]
]