let
    DateTime_FromUnixTime = (unixTime as number) as datetime =>
        let
            UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),
            result = UnixEpoch + #duration(0, 0, 0, unixTime / 1000)
        in
            result,

    /*

    DateTime.FromFileTime
    DateTimeZone.FromFileTime

    To use the epoch "12:00 midnight, January 1, 1601", use the functions
        DateTime.FromFileTime, and DateTimeZone.FromFileTime
    */

    sampSec = 1604073449,
    sampMs = sampSec * 1000,
    sampNs = sampMs * 1000,


    sampleTest = {
        [Name = "seconds", Value = sampSec],
        [Name = "milliseconds", Value = sampMs],
        [Name = "nanoseconds", Value = sampNs],
        [Name = "guess", Value = 1604071952 ]
    },
    t = Table.FromRecords(
        sampleTest,
        // Value.Type(sampleTest),
        type table[Name = text, Value = any],
        MissingField.Error
    ) ,

    // results = [
    //     input = sec,
    //     sec = DateTime_FromUnixTime( sampSec )
    t1 = Table.AddColumn(
        t,
        "Length",
        each   Text.Length( Text.From( _[Value] ) ),
        Int8.Type
    ),
    t2 = Table.AddColumn(
        t1,
        "Default",
        each DateTime_FromUnixTime( _[Value]  ),
        type datetime

    ),

    // prevent overflow when duration is too large
    durationFromBig = (x as any) as any => // duration
        let
            tryParse = try #duration(0, 0, 0, x),
            res = tryParse
        in
            res,
    t3 = Table.AddColumn(
        t2,
        "Duration",
        each durationFromBig( _[Value] ),


        type any

    )
in
    t3