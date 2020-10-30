let
    DateTime_FromUnixTime = (unixTime as number) as any =>
        let
            UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),
            NumberOfDigits = Text.Length( Text.From( unixTime ) ),
            modifier =
                if NumberOfDigits <= 10 then 1
                else if NumberOfDigits <= 13 then 1000
                else if NumberOfDigits <= 16 then 1000000
                else Error.Record(
                    "OutOfBounds",
                    "Attempted to detect UnixTime, it is out of range",
                    "Count = " & Number.ToText( NumberOfDigits )
                ),
            offsetDuration = try
                    #duration(0, 0, 0, (unixTime / modifier) )
                otherwise
                    Error.Record("bad", unixTime, Modifier)
                ,
            result = try UnixEpoch + offsetDuration
        in
            if result[HasError] then result[Error][Message] else result[Value],

    /*
    if textUnitPrice[HasError] then textUnitPrice[Error][Message]
        //Continue expression flow
            else textUnitPrice[Value]
    */


    /*

    DateTime.FromFileTime
    DateTimeZone.FromFileTime

    To use the epoch "12:00 midnight, January 1, 1601", use the functions
        DateTime.FromFileTime, and DateTimeZone.FromFileTime
    */

    sampSec = 1604073449,
    sampMs = sampSec * 1000,
    sampNs = sampMs * 1000,
    UnixEpoch = #datetime(1970, 1, 1, 0, 0, 0),


    sampleTest = {
        [Name = "seconds", Value = sampSec],
        [Name = "milliseconds", Value = sampMs],
        [Name = "nanoseconds", Value = sampNs],
        [Name = "guess", Value = 1604071952 ],
        [Name = "15 digits", Value = 160407195212344 ],
        [Name = "17 digits", Value = 16040719521234433 ],
        [Name = "floating", Value = 1095379201.25 ],
        [Name = "floating converted int", Value = Int32.From( 1095379201.25) ],
        [Name = "20 digits", Value = 12345123451234512345 ]
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
    Custom2 = unitTest_t3
in
    Custom2