let
    ErrorRecord.Format = (source as record, optional options as nullable record) as text =>
        let
            maybeDetail = source[Detail]? ?? [],
            prefix = Text.Combine({
                (source[Reason]? ?? ""),
                (source[Message]? ?? "")
            }, "#(cr,lf) "),
            formatted = Text.Format(
                (source[Message.Format]? ?? ""),
                (source[Message.Parameters]? ?? null)
            ),
            combineAll = Text.Combine({
                maybeDetail, prefix, formatted
            }, "#(cr,lf)"),
            summary = [
                nyi = "func not finished",
                combineAll = combineAll ]
        in
            summary
            // combineAll meta [Exception = source]
in
    ErrorRecord.Format