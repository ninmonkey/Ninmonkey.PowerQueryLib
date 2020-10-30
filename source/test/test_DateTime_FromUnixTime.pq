let
    /*
    if textUnitPrice[HasError] then textUnitPrice[Error][Message]
        //Continue expression flow
            else textUnitPrice[Value]
    */



    sampSec = 1604073449,
    sampMs = sampSec * 1000,
    sampNs = sampMs * 1000,
    UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),
    // const = [
    //     UnixEpoch = UnixEpoch,
    // ]

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
        [Name = "15 digits", Value = 160407195212344 ],
        [Name = "17 digits", Value = 16040719521234433 ],
        [Name = "floating", Value = 1095379201.25 ],
        [Name = "floating converted int", Value = Int32.From( 1095379201.25) ],
        [Name = "20 digits", Value = 12345123451234512345 ],
        [Name = "max unsigned int32", Value = max[uint32] ],
        [Name = "max int32", Value = max[int32] ]

    },
    t = Table.FromRecords(
        sampleTest,
        // Value.Type(sampleTest),
        type table[Name = text, Value = number],
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
    mini = DateTime_FromUnixTime( sampSec )    ,
    mDuration = #duration(0, 0, 0, (sampNs / 1000) ),
    mRes = UnixEpoch + mDuration,
    rOneStep = UnixEpoch + #duration(0, 0, 0, (sampNs / 1000) ),
    max_uInt32 = 4294967295 - Number.Power(2, 32),
    max_Int32 = 2147483647 = Number.Power(2,31) - 1 and 2147483647 = max[int32] + 1,



    Custom1 = DateTime_FromUnixTime( sampNs ),
    c2 = DateTime_FromUnixTime( 160407195212344 ),
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

    t2 = Table.AddColumn(
        t1,
        "Default",
        each DateTime_FromUnixTime( _[Value]  ),
        type datetime

    ),
    unitTest_t4 = unitTest_t3,
    unitTest_t5 = Table.AddColumn(unitTest_t4, "try timezone", each DateTime.AddZone( [Expected], 0, null), type datetimezone),
    unitTest_t6 = Table.AddColumn(unitTest_t5, "Local Time", each DateTimeZone.ToLocal([try timezone]), type datetimezone),
    #"Table of Contents of Results" = [ #"Main Results" = t2, #"Manual Tests" = unitTest_t3 ],
    #"MainFinal test" = #"Table of Contents of Results"[Main Results]
in
    #"MainFinal test"