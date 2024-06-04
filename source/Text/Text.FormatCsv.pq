[
    Text.FormatCsv = (source as list, optional options as nullable record ) as text => [
        culture  = options[Culture]?,
        segments = List.Transform( source, each Text.From( _, culture ) ),
        return   = Text.Combine( segments, ", " )

    ][return]
]