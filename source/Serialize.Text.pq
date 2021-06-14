let
    /*
    from: https://github.com/microsoft/DataConnectors/blob/master/samples/UnitTesting/UnitTesting.query.pq
    */
   Serialize.Text =  (x) => let
            escapeText = (n as number) as text => "#(#)(" & Text.PadStart(Number.ToText(n, "X", "en-US"), 4, "0") & ")"
        in
        List.Accumulate(
            List.Transform(
                Text.ToList(x),
                (c) => let n = Character.ToNumber(c) in
                        if n = 9   then "#(#)(tab)" else
                        if n = 10  then "#(#)(lf)"  else
                        if n = 13  then "#(#)(cr)"  else
                        if n = 34  then """"""      else
                        if n = 35  then "#(#)(#)"   else
                        if n < 32  then escapeText(n) else
                        if n < 127 then Character.FromNumber(n) else
                        escapeText(n)
            ),
            "",
            (s, i) => s & i
        )
in
    Serialize.Text
