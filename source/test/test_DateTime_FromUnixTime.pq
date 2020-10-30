// test_DateTime_FromUnixTime
let

    sampSec = 1604073449,
    sampMs = sampSec * 1000,
    sampNs = sampMs,
    UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),
    // maximum values for numbers
    max = [
        uint32 = Number.Power(2, 32) - 1,
        int32 = Number.Power(2, 31) - 1
    ],

    sampleTest = {
        [Name = "seconds", Value = sampSec],
        [Name = "milliseconds", Value = sampMs],
        [Name = "nanoseconds", Value = sampNs],
        [Name = "guess", Value = 1604071952 ],
        [Name = "10 digits", Value = 1111111111 ],
        [Name = "13 digits", Value =  1111111111111 ],
        [Name = "15 digits", Value = 160407195212344 ],
        [Name = "17 digits", Value = 16040719521234433 ],
        [Name = "floating", Value = 1095379201.25 ],
        [Name = "floating converted int", Value = Int32.From( 1095379201.25) ],
        [Name = "20 digits", Value = 12345123451234512345 ],
        [Name = "max unsigned int32", Value = max[uint32] ],
        [Name = "Manual now", Value = 1604085099 ],
        [Name = "max int32", Value = max[int32] ]

    },
    t = Table.FromRecords(
        sampleTest,
        type table[Name = text, Value = number],
        MissingField.Error
    ) ,

    t1 = Table.AddColumn(
        t,
        "Length",
        each   Text.Length( Text.From( _[Value] ) ),
        Int8.Type
    ),
    // mini = DateTime_FromUnixTime( sampSec )    ,
    // mDuration = #duration(0, 0, 0, (sampNs / 1000) ),
    // mRes = UnixEpoch + mDuration,
    // rOneStep = UnixEpoch + #duration(0, 0, 0, (sampNs / 1000) ),
    // max_uInt32 = 4294967295 - Number.Power(2, 32),
    // max_Int32 = 2147483647 = Number.Power(2,31) - 1 and 2147483647 = max[int32] + 1,



    // Custom1 = DateTime_FromUnixTime( sampNs ),
    // c2 = DateTime_FromUnixTime( 160407195212344 ),
        //    [Name = "15 digits", Value = 160407195212344 ],
        // [Name = "17 digits", Value = 16040719521234433 ],
        // [Name = "20 digits", Value = 12345123451234512345 ]

    unitTest_sample = {
        [
                Name = "UTC",
                Expected = DateTime.FromText( "2004-09-17T00:00:01.25" ),
                Value = 1095379201.25
        ]
    },
    unitTest_t1 = Table.FromRecords(
        unitTest_sample,
        // Value.Type(sampleTest),
        type table[Name = text, Expected = datetime, Value = number],
        MissingField.Error
    ) ,

    unitTest_t2 = Table.AddColumn(
        unitTest_t1,
        "Result_Default",
        each DateTime_FromUnixTime( _[Value]  ),
        type datetime
    ),

    unitTest_t3 = Table.AddColumn(
        unitTest_t2,
        "2",
        each DateTimeZone.From( _[Result_Default] ),
        type datetimezone
    ),
    // 2004-09-17T00:00:33.25 	2004-09-17T00:00:01.25 	1095379201.25



    // 1000000
    // 16040719521234433

    main_t1 = Table.AddColumn(
        t1,
        "Default",
        each DateTime_FromUnixTime( _[Value]  ),
        type datetime
    ),
    main_t2 = Table.AddColumn(
        main_t1,
        "mode = 'seconds'",
        each DateTime_FromUnixTime( _[Value], "s" ),
        type datetime
    ),
    main_t3 = Table.AddColumn(
        main_t2,
        "mode = 'ms'",
        each DateTime_FromUnixTime( _[Value], "ms" ),
        type datetime
    ),
    main_t4 = Table.AddColumn(
        main_t3,
        "mode = 'ns'",
        each DateTime_FromUnixTime( _[Value], "ns" ),
        type datetime
    ),

    main_final = main_t4,

    unitTest_t4 = unitTest_t3,
    unitTest_t5 = Table.AddColumn(unitTest_t4, "try timezone", each DateTime.AddZone( [Expected], 0, null), type datetimezone),
    unitTest_t6 = Table.AddColumn(unitTest_t5, "Local Time", each DateTimeZone.ToLocal([try timezone]), type datetime),
    #"Table of Contents of Results" = [
        #"Main Results" = main_final,
        #"Manual Tests" = unitTest_t3
    ],
    #"MainFinal test" = #"Table of Contents of Results"[Main Results]
in
    #"MainFinal test"

// DateTime_FromUnixTime
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