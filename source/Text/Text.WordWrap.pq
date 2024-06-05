
let
    /*
    Example:

        wrapped    = Text.WordWrap(LoremIpsum, 80)
        LoremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eu laoreet turpis. Curabitur lacinia, risus ut rhoncus mattis, turpis lorem iaculis justo, nec ultrices arcu erat vitae felis. Pellentesque vulputate efficitur scelerisque. Etiam bibendum dignissim mauris",
    */

    // calculate length of string *after* the rightmost newline
    strNewline = "#(lf)",
    Text_LengthAfterNewline = (string as text) as number =>
        let
            posLastNewline = Text.PositionOf(string, strNewline, Occurrence.Last),
            posOffset = if posLastNewline <> -1 then posLastNewline else 0,
            deltaLen = Text.Length(string) - posOffset
        in
            deltaLen,

    // word wraps text
    Text.WordWrap = (string as text, max_width as number) as text =>
        let
            words = Text.Split(string, " "),
            accum_result = List.Accumulate(
                words, "",
                (state as text, current as text) as text =>
                    let
                        len = Text_LengthAfterNewline(state) + Text.Length(current) + 1,
                        maybeNewline =
                            if len > max_width then strNewline else "",

                        accum_string = Text.Combine({state & maybeNewline, current}, " ")
                    in
                        accum_string
            )
        in
            accum_result
in
    Text.WordWrap