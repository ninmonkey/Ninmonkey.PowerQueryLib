let
    DateTime_FromUnixTime = (unixTime as number, optional mode as text) as any =>
        /*

        modes
            "s" is seconds
            "ms" is milliseconds
            "ns" is nanoseconds

        DateTime.FromFileTime
        DateTimeZone.FromFileTime

        To use the epoch "12:00 midnight, January 1, 1601", use the functions
            DateTime.FromFileTime, and DateTimeZone.FromFileTime

        see also:
            https://en.wikipedia.org/wiki/Unix_time#UTC_basis


        */
        let
            UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),
            NumberOfDigits = Text.Length( Text.From( unixTime ) ),
            // guessModifier
            //     = if NumberOfDigits <= 10 then 1
            //     else if NumberOfDigits <= 13 then 1000
            //     else if NumberOfDigits <= 16 then 1000000
            //     else Error.Record(
            //         "OutOfBounds",
            //         "Attempted to detect UnixTime, it is out of range",
            //         "Count = " & Number.ToText( NumberOfDigits )
            //     ),
            modifier
                = if mode = "s" then 1
                else if mode = "ms" then 1000
                else if mode = "ns" then 1000000
                else null,

            offsetDuration = try
                    #duration(0, 0, 0, (unixTime / modifier) )
                otherwise
                    Error.Record("bad", unixTime, modifier)
                ,
            tryDatetime = try UnixEpoch + offsetDuration,
            // Maybe return datetime
            asUtc = DateTime.AddZone( tryDatetime , 0, 0),
            l = DateTimeZone.ToLocal(asUtc),

            result = l
        in
            if result[HasError] then result[Error] else result[Value]

in
    DateTime_FromUnixTime