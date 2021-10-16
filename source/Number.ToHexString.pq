
let
    /*
        255 => 0xff
    */
    Number_ToHexString = (
        num as number,
        optional options as nullable record
    ) as text =>
        let
            defaults
                = [
                    PadStart = true,
                    Prefix = true,
                    Columns = 8
                ],
            options
                = Record.Combine({defaults, options ?? []}),
            prefix
                = if options[Prefix]? then "0x" else "",

            numString
                = Number.ToText(num, "x"),

            paddedString
                =  if options[PadStart]?
                    then Text.PadStart(
                        numString, "0",
                        options[Columns]? ?? 8
                    )
                    else numString,
            finalText
                = prefix & numString
        in
            finalText
in
    Number_ToHexString
