[
    /*
    About: Stand alone StringBuilder inspired functions

    See Also:
        Write.Html.module.pq

    */
    // optional aggressive Aliases
    Sb.JoinDelim      = StringBuilder.JoinDelimiter,
    Sb.Format         = StringBuilder.Format,
    Sb.JoinFormat     = StringBuilder.JoinFormat,
    Sb.JoinLineEnding = StringBuilder.JoinLineEnding,
    Sb.JoinNL         = StringBuilder.JoinLineEnding,

    Sb.Str = [
        LineEnding = "#(cr,lf)",
        NullStr    = "#(2400)",
        SpaceStr   = "#(2420)",
        Tab        = "#(tab)"
    ],

    StringBuilder.JoinLineEnding = (
        items as list
    ) as text => [
        return = Text.Combine( items, Sb.Str[LineEnding] )
    ][return],

    StringBuilder.JoinDelimiter = (
        items            as list,
        separator        as text
    ) as text => [
        return = Text.Combine( items, separator )

    ][return],
    /*
        like StringBuilder.JoinFormat,
        but this accepts a single value verses a list
    */
    StringBuilder.Format = (
        content          as text,
        optional options as nullable record
    ) as text => [
        return = StringBuilder.JoinFormat( {content}, options )
    ][return],

    /*
        Valid options are any combination of these:
        - Prefix,
        - Suffix
        - Separator
    */
    StringBuilder.JoinFormat = (
        items            as list,
        optional options as nullable record

    ) as text => [
        formatStr = "#[prefix]#[content]#[suffix]",

        renderLines = List.Transform(
             items,
            (line) => Text.Format(
                formatStr, [
                    prefix  = options[Prefix]? ?? "",
                    content = line,
                    suffix  = options[Suffix]? ?? ""
                ]
            )
        ),

        return = Text.Combine(
            renderLines,
            options[Separator]? ?? Sb.Str[LineEnding]
        )

    ][return],

]