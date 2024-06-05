let
    // previous name: List.JoinNewLine, Format.JoinNewLine, Join.NewLine
    Format.JoinNewLine = (source as list) as text => [
        As.TextList = List.TransformTo.ListOfText,
        ret         = Text.Combine( As.TextList( source ), "#(cr,lf)"  ) //# Uni[CrLf] )
    ][ret]
in
    Format.JoinNewLine