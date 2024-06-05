let
     /*
        in: 0x2400  out: 2400
        in: 203     out: cb
        in: 203, [Prefix = true]
            out: 0xcb

        see also: Number.ToHexString, Number.FromHexString
    */
    Number.ToHexString = (
        source as number,
        optional options as nullable record

    ) as text => [

        config = Record.Combine({ [
                Prefix = false
            ],
            (options ?? [])
        }),
        hex    = Number.ToText( source, "x" ),
        return =
            if config[Prefix] then  // options[Prefix]? then
                "0x" & hex
            else
                hex
    ][return]

in
    Number.ToHexString