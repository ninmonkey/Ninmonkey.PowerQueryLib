let
    /*
    About:
        I wanted a quick way to visualize JSON
        Expanding JSON with newlines still has a lot of noice
        I am experimenting with something shorter like yaml, but not using yaml constraints
    this is overkill.
    */
    Format.SimplfyJson = (
        source           as text,
        optional options as nullable record

    ) as text => [

        // make defaults param
        options = options ?? [
            PadKeyValue              = true,
            KeyValueDelim            = " ▸ ",
            PadBraceEnding           = true,
            TrimDoubleQuotes         = true,
            ReplaceDoubleQuoteString = " ",
            TrimPrefixSuffixBrace    = false
        ],
        // Str = [ DoubleQuote = "#(0022)" ],
        keyValueDelim_1 = " ▸ ",
        keyValueDelim   = ": ",
        acc0            = source,
        // acc1 = Text.Replace( acc0, "#(0022):{#(0022)", " => " ),
        acc1 =
            if not options[PadKeyValue]
            then acc0
            else
                Text.Replace( acc0, "#(0022):", options[KeyValueDelim] ),
        acc2 =
            if not options[TrimDoubleQuotes]
            then acc1
            else
                Text.Replace( acc1, "#(0022)", options[ReplaceDoubleQuoteString] ),
        acc3 =
            if not options[PadBraceEnding] then acc2
            else
                Text.Replace( acc2, "}", " }" ),
        acc4 = // this only strips the final instance because of acc3 running first
                // should instead be a replace first and last occurence instead
            if not options[TrimPrefixSuffixBrace] then acc3
            else
                [
                    trimSpace = Text.Trim( acc3 ),
                    trimStart = Text.TrimStart( trimSpace, "{" ),
                    trimEnd   = Text.TrimEnd( trimStart, "}" ),
                    return    = trimEnd

                ][return],

        return = acc3

    ][return]
    in
        Format.SimplfyJson