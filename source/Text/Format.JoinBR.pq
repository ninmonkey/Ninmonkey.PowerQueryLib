let

    // See Write.Html.pq module for a better, nested approach to this function
    Format.JoinBR = (source as list) as text => [
        ret = Text.Combine( As.TextList( source ), "#(cr,lf)<br>" )
    ][ret]
in
    Format.JoinBR