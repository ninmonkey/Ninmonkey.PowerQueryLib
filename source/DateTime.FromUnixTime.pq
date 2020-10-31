let
    DateTime_FromUnixTime = (unixTime as number, optional mode as text) as datetime =>
        /*
        Convert Unix date times to a `datetime`
        modes
            "s" is seconds
            "ms" is milliseconds
            "ns" is nanoseconds

        To use the epoch "12:00 midnight, January 1, 1601", use the functions
            DateTime.FromFileTime
            DateTimeZone.FromFileTime

        see also:
            https://en.wikipedia.org/wiki/Unix_time#UTC_basis
            .net class for duration: https://docs.microsoft.com/en-us/dotnet/api/system.timespan?view=netcore-3.1

        when out of range, the user facing error is:
            > An error occurred in the ‘DateTime_FromUnixTime’ query. Expression.Error: The Duration operation failed because the resulting duration falls outside the range of allowed values.
        */

        let
            UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),
            modifier
                = if mode = "s" or mode = "sec" then 1
                else if mode = "ms" then 1e3
                else if mode = "ns" then 1e9
                else 1,

            offsetDuration = #duration(0, 0, 0, (unixTime / modifier) ),
            tryDatetime = try UnixEpoch + offsetDuration,
            result = tryDatetime
        in
            if result[HasError] then error result[Error] else result[Value]

in
    DateTime_FromUnixTime