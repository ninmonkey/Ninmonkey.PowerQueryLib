let
    Text.RemoveDiacritics = (Text as text) as text =>
        let
            TextEncoding.Cyrillic = 28595,
            bytes                 = Text.ToBinary( Text, TextEncoding.Cyrillic ),
            cleanText             = Text.FromBinary( bytes )
        in cleanText

in
    Text.RemoveDiacritics
