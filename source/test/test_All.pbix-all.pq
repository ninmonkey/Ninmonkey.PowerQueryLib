// test_DateTime_ToOData
let
    /*
    Description
        Convert PowerQuery `datetime` and `datetimezone` to a OData format

        OData primatives: https://www.odata.org/documentation/odata-version-2-0/json-format/

    Example:
        9/8/2020 2:01:50 PM
        9/8/2020 2:01:50 PM -05:00

    Output:
        datetime'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T14:01:49'
    */
    Source = #table(
        type table[Label = text, Format = text, Example = text, Input = any],
        {
            // "there is no 'date' primative type?",
            {
                "DT Fixed local",
                "datetime'yyyy-mm-ddThh:mm[:ss[.fffffff]]",
                "datetime'2000-12-12T12:00'",
                DateTime.FixedLocalNow()
            },
            {
                "DTZ Fixed Local",
                "..",
                "datetimeoffset'2002-10-10T17:00:00Z'",
                DateTimeZone.FixedLocalNow()
            },
            {
                "DTZ Fixed UTC",
                "..",
                "datetimeoffset'2002-10-10T17:00:00Z'",
                DateTimeZone.FixedUtcNow()
            },
            {
                "Invalid Data", "", "", 2020

            }
        }),

    colUsingFunction = Table.AddColumn(
        Source,
        "Results",
        each DateTime_ToOData( [Input] ),
        type text ),

    Final = colUsingFunction
in
    Final

// DateTime_ToOData
let
    /*
    Description:

        Converts Power Query `date` and `datetimes` to OData `datetime` and `datetimeoffset`

    Examples:
        9/8/2020 2:01:50 PM         DateTime Local
        9/8/2020 2:01:50 PM -05:00  DateTimeZone Local
        9/8/2020 7:23:18 PM +00:00  DateTimeZone Utc

    Output:
        datetime'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T19:23:17'

    See also:
        .\source\test\test_DateTime_ToOData.pq
    */

    DateTime_ToOData = (dates as any) as text =>
        // verify that culture doesn't change when using format "s"
        let
            formattedType = if dates is datetime then
                "datetime'" &  DateTime.ToText( dates, "s", null )
            else if dates is datetimezone then
                "datetimeoffset'" & DateTimeZone.ToText( dates, "s", null )
            else
                error Error.Record(
                    "InvalidType", "Expected, datetime, or datetimezone",
                    Value.Type( dates )
                ),
            formatted = formattedType & "'"
        in
            formatted
in
    DateTime_ToOData

// ListAsText
/*

Description:

alias: SummarizeList() or ListAsText()

see:
    Serialize.List()

*/
let
    List.AsText =  (values as list, optional separator as nullable text, optional prefix as nullable text, optional suffix as nullable text) as text => let
        separator = separator ?? ", ",
        prefix = prefix ?? "{",
        suffix = suffix ?? "}",
        joined = List.Accumulate(values, "",
            (seed, item) =>
                if seed="" then Text.From(item)
                else seed & separator & Text.From(item)),
        output = prefix & joined & suffix
    in
        output
in
    List.AsText

// RandomCurrency
// RandomCurrency
let
    /* randomly generate currency within a range
    optional culture */
    RandomCurrency = (
            min as number,
            max as number,
            optional culture as nullable text,
            optional roundingMode as nullable number
        ) as number =>
            Currency.From(
                    Number.RandomBetween( min, max ),
                    culture,
                    RoundingMode.Down
                )
in
    RandomCurrency

// RandomInt
let
    /*
    ref: https://docs.microsoft.com/en-us/power-query/handlingdocumentation
    for rounding see also: Number.Round* family of functions.
    */

    Documentation = type function (
        min as (type number meta [
            Documentation.FieldCaption = "Min",
            Documentation.FieldDescription = "Minimum number",
            Documentation.SampleValues = {10, 0.45}
        ]),
        b as (type number meta [
            Documentation.FieldCaption = "Max",
            Documentation.FieldDescription = "Maximum number",
            Documentation.SampleValues = {34, 100.45}
        ]),
        optional culture as (type nullable text meta [
            Documentation.FieldCaption = "Culture",
            Documentation.FieldDescription = "Culture used to convert number"
        ]),
        optional roundingMode as (type nullable number meta [
            Documentation.FieldCaption = "Rounding Mode",
            Documentation.FieldDescription = "rounding method",
            Documentation.AllowedValues = {
                RoundingMode.AwayFromZero, RoundingMode.Down, RoundingMode.ToEven, RoundingMode.TowardZero, RoundingMode.Up}
        ])
    ) as table meta [
            Documentation.Name = "RandomInt",
            Documentation.LongDescription = "Generate a random Integer between two values. Optionally set culture and rounding mode.",
            Documentation.Examples = {[
                Description = "Generate one value",
                Code = "RandomInt(10, 20)",
                Result = "11"
            ]}
        ],

    RandomInt = (
        min as number,
        max as number,
        optional culture as nullable text,
        optional roundingMode as nullable number
    ) as number =>
        Int64.From(
            Number.RandomBetween( min, max ),
            culture,
            roundingMode
        )
in
    Value.ReplaceType( RandomInt, Documentation)

// test_ListAsText
let
    items = {7, 10, 40, 3},
    Summary = [
        asText = ListAsText(items),
        a2 = ListAsText(items, "."),
        a3 = ListAsText(items, ".", "<-"),
        a4 = ListAsText(items, ".", "<-", "->"),
        a5List = ListAsText(items, "#(cr)• ", "• ", ""),
        a6 = ListAsText(items, ".", "IP addr = ", "")
    ]
in
    Summary

// SerializeList
/*

Description:


see:
    ListAsText()

original code based on: <https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244>

*/
let

    /* Optional parameter: Is this being used as part of a function signature? */
    Serialize.List =  (x as list) as text => "{" &
        List.Accumulate(x, "",
            (seed,item) =>
                if seed="" then Text.From(item)
                else seed & ", " & Text.From(item)) &
            "} "
in
    Serialize.List

// SerializeText
let
    /*
    original code based on: from: https://github.com/microsoft/DataConnectors/blob/master/samples/UnitTesting/UnitTesting.query.pq
    */
   Serialize.Text =  (x) => let
            escapeText = (n as number) as text => "#(#)(" & Text.PadStart(Number.ToText(n, "X", "en-US"), 4, "0") & ")"
        in
        List.Accumulate(
            List.Transform(
                Text.ToList(x),
                (c) => let n = Character.ToNumber(c) in
                        if n = 9   then "#(#)(tab)" else
                        if n = 10  then "#(#)(lf)"  else
                        if n = 13  then "#(#)(cr)"  else
                        if n = 34  then """"""      else
                        if n = 35  then "#(#)(#)"   else
                        if n < 32  then escapeText(n) else
                        if n < 127 then Character.FromNumber(n) else
                        escapeText(n)
            ),
            "",
            (s, i) => s & i
        )
in
    Serialize.Text

// SerializeType

/*


Todo:
    Clean up, add unit testing for all types.

alias?
Better naming ?
    - Serialize.TypeName()
    - Type.NameAsText()


from: https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244

Note:
    The original serializes **everything**
    This only shows type names as text

*/
let

    /* Optional parameter: Is this being used as part of a function signature? */
    Type.ToText =  (x, optional funtype as logical) =>
        let
            isFunctionType = (x as type) => try if Type.FunctionReturn(x) is type then true else false otherwise false,
            isTableType = (x as type) =>  try if Type.TableSchema(x) is table then true else false otherwise false,
            isRecordType = (x as type) => try if Type.ClosedRecord(x) is type then true else false otherwise false,
            isListType = (x as type) => try if Type.ListItem(x) is type then true else false otherwise false
        in
            if funtype = null and isTableType(x) then "Table"
            else if funtype = null and isListType(x) then "list"
            else if funtype = null and isFunctionType(x) then "Function"
            else if funtype = null and isRecordType(x) then "Record"
            else if x = type any then "any"
            else let base = Type.NonNullable(x) in
                (if Type.IsNullable(x) then "nullable " else "") &
                (if base = type anynonnull then "anynonnull" else
                if base = type binary then "binary" else
                if base = type date   then "date"   else
                if base = type datetime then "datetime" else
                if base = type datetimezone then "datetimezone" else
                if base = type duration then "duration" else
                if base = type logical then "logical" else
                if base = type none then "none" else
                if base = type null then "null" else
                if base = type number then "number" else
                if base = type text then "text" else
                if base = type time then "time" else
                if base = type type then "type" else

                /* Abstract types: */
                if base = type function then "function" else
                if base = type table then "table" else
                if base = type record then "record" else
                if base = type list then "list"
                else "any /*Actually unknown type*/")
in
    Type.ToText

// IPDottedDecimalFromList
/*

Input:
    ListAsIp( {192, 168, 5, 85} )
Output:
    192.168.5.85
*/
let
    IP.DottedDecimalFromList = (num as list) as text => let
        isValid = try if List.Count(num) = 4 then
            true
        else
            Error.Record(
                "Bad value", "Expected list length of 4", ListAsText(num)
            ),
        string = ListAsText(num, ".", "", "")
    in
        if isValid[HasError] then
            isValid[Error]
        else
            string

in
    IP.DottedDecimalFromList

// SampleDates
let
    args = [
        Culture = "fr-FR"
    ],

    JSON = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("NY3LCcAwDEN38TlgSSWQzBKy/xr1pwVfHnqSzzE8DrlA2jDBMRNWAJbHCVh2R4vMTCnSWTADKKc6KVG9iBSjUi3kPLbHBewWvxEhs9mvUYv/PO3eFw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Date A" = _t, #"Date B" = _t, #"Date C" = _t]),

    // parsing dates from a different locale than the system:
    Final = Table.TransformColumnTypes( JSON,
        {
            {"Date A", type date},
            {"Date B", type date},
            {"Date C", type date}
        },
        args[Culture]
    )
in
    Final

// test_TableToJson
let
    Source = #table(
        {"Animal", "Id"},
        {
            {"Cat", 1}, {"Turtle", 2}
        }
    ),

    json = TableToJson( Source )
in
    json

// TableToJson
let
    Documentation = type function (
        source as (type table meta [
            Documentation.FieldCaption = "Input Table",
            Documentation.FieldDescription = "Input Table"
        ]),
        optional encoding as (type nullable number meta [
            Documentation.FieldCaption = "Text Encoding",
            Documentation.FieldDescription = "Text Encoding",
            Documentation.AllowedValues = { TextEncoding.Ascii, TextEncoding.BigEndianUnicode, TextEncoding.Unicode, TextEncoding.Utf16, TextEncoding.Utf8, TextEncoding.Windows }
        ])
    ) as table meta [
            Documentation.Name = "TableToJson",
            Documentation.LongDescription = "Converts a table to JSON. (The reverse of using 'Enter Data'). Currently this does not save schema other than JSON types",
            Documentation.Examples = {[
                Description = "Generate one value",
                Code = "TableToJson( #table({""Animal"", ""Id""}, {{""Cat"", 1}, {""Turtle"", 2}}) )",
                Result = "[{""Animal"":""Cat"",""Id"":1},{""Animal"":""Turtle"",""Id"":2}]"
            ]}
        ],

    TableToJson = (source as table, optional encoding as nullable number) as text =>
        let
            encoding = if encoding <> null then encoding else TextEncoding.Utf8,
            bin = Json.FromValue(source, encoding),
            jsonAsText = Text.FromBinary(bin, encoding)
        in
            jsonAsText
in
    Value.ReplaceType( TableToJson, Documentation)

// JsonToLiteral
let
    /* converts JSON to a pastable PowerQuery Literal

    Usage:
        TableToJson( TableName )

    */
    JsonToLiteral = (json as text) as text =>
        let
            doubleQuote = """",
            escapeQuotes = Text.Replace(
                json, doubleQuote,
                ( doubleQuote & doubleQuote)
            )
        in
            escapeQuotes
in
    JsonToLiteral

// test_JsonToLiteral
let
    Source = JsonToLiteral( test_TableToJson )
in
    Source

// Invoked Function
let
    Source = ListAsText(test_DateTime_ToOData[Example], null, null, null),
    Custom1 = Value.Type( Source )
in
    Custom1

// test_SerializeText
let
    Source = """nyi"""
in
    Source

// test_SerializeList
let
    Source = """nyi"""
in
    Source

// test_SerializeType
let
    Source = """nyi"""
in
    Source

// Template: function with documentation
let
    #"Template: function with documentation" = let
    /*
    ref: https://docs.microsoft.com/en-us/power-query/handlingdocumentation

    AllowedValues may be dynamic:
        https://ssbi-blog.de/blog/technical-topics-english/writing-documentation-for-custom-m-functions-part3/
    */

    Documentation = type function (
        a as (type number meta [
            Documentation.FieldCaption = "First Number",
            Documentation.FieldDescription = "[Field A Desc] text (tooltip?)",
            // use a multi-line input box
            Formatting.IsMultiLine = false,
            // monospace font
            Formatting.IsCode = false,
            // shown as faded input in text box, else:
            Documentation.SampleValues = {1, 9},
            // as a dropdown, but not enforced
            Documentation.AllowedValues = {34, 99}

        ]),
        b as (type number meta [
            Documentation.FieldCaption = "Second Number",
            Documentation.FieldDescription = "[Field B Desc] text (tooltip?)",
            Formatting.IsMultiLine = true,
            Formatting.IsCode = false,
            Documentation.SampleValues = {4, 7}
        ])
    ) as table meta [
        Documentation.Name = "[Name] SumNumbers",
        Documentation.LongDescription = "[LongDesc] Adds two numbers",
        Documentation.Examples = {[
            Description = "Sum two numbers",
            Code = "let sum = Func(1, 3) in sum",
            Result = "4"
        ]}
    ],

    SumNum = (a as number, b as number) as number =>
        a + b
in
    Value.ReplaceType( SumNum, Documentation)
in
    #"Template: function with documentation"

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

// test_DateTimeFrom_UnixTime
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
        [Name = "Manual now", Value = 1604085099 ],
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

    #"MainResults table" = Table.AddColumn(
        t1,
        "Default",
        each DateTime_FromUnixTime( _[Value]  ),
        type any // datetime


    ),
    unitTest_t4 = unitTest_t3,
    unitTest_t5 = Table.AddColumn(unitTest_t4, "try timezone", each DateTime.AddZone( [Expected], 0, null), type datetimezone),
    unitTest_t6 = Table.AddColumn(unitTest_t5, "Local Time", each DateTimeZone.ToLocal([try timezone]), type datetimezone),
    #"Table of Contents of Results" = [ #"Main Results" = #"MainResults table", #"Manual Tests" = unitTest_t3 ],
    x = DateTime_FromUnixTime( 1604085099 ),
    #"MainFinal test" = #"Table of Contents of Results"[Main Results]
in
    #"MainFinal test"

// wip - test overflow on durations
let
    Source = 9223372036854775808,
    Custom1 = Duration.From(Source),
    maxTick = 9223372036854775807,
    #"div huge" = maxTick / 1000 / 1000 / 1000,
    back = Duration.TotalSeconds( #"div huge" ),
    dur63 = #duration(0,0,0,  Number.Power(2, 20)   ),
    Custom2 = #duration( 10675199, 0, 0, 0 ),
    c3 = #duration( 10675199 + 1, 0, 0, 0 ),
    dur64 = #duration(0,0,0,  Number.Power(2, 64)   ),
    Custom3 = #duration(0,0, 0, 9223372036 + 23),
    Custom4 = Duration.From("10675199.02:48:05.4775807"),
    #"maxLiteral will error" = #duration(10675199, 2, 48, 5),
    const_1Day = #duration(1, 0, 0, 0),
    const_30min = #duration(0, 0, 30, 0),


    Const = [
        1Day = const_1Day,
        1Week = 7 * const_1Day,
        HalfHour = const_30min,
        HalfHalfHour = const_30min / 2

    ],
    Custom5 = Duration.TotalDays( Custom4 )
in
    Custom5

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

// wip test mini - datefrom
let
    Sample = {
        [
                Name = "UTC",
                Expected = DateTime.FromText( "2004-09-17T00:00:01.25" ),
                Value = 1604073449
        ]
    },

    rec =  Sample{0},
    call = DateTime_FromUnixTime( rec[Value] ) ,

    results = [
        Todo = "Validate test, datetime as local/utc",
        Record = rec,
        Call = call
    ]

in
    results

// test exponents
let
    doIt = ( num as number, mode as text) as any =>
        let
            modifier
                = if mode = "s" or mode = "sec" then 1
                else if mode = "ms" then 1e3
                else if mode = "ns" then 1e9
                else 1
        in
            num / modifier,


    sample = 213241535434,
    Results = [
        #"doIt('s')" = doIt(sample, "s"),
        #"sample / 1" = sample / 1,
        #"doIt('ms')" = doIt(sample, "ms"),
        #"num / 1e3" = sample / 1e3,
        #"num / 1e6" = sample / 1e6,
        #"num / 1e9" = sample / 1e9,
        #"doIt('ns')" = doIt(sample, "ns"),
        #"google ns to s" = 213.241535434,
        #"google ms to s" = 213241535.434

    ]
in
    Results

// Value_ToPowerQuery
// Value_ToPowerQuery
/*
    serializes values as power query source code

    from: https://github.com/microsoft/DataConnectors/blob/master/samples/UnitTesting/UnitTesting.query.pq
*/
let Value.ToPowerQuery = (value, optional depth) =>
    let
        List.TransformAndCombine = (list, transform, separator) => Text.Combine(List.Transform(list, transform), separator),

        Serialize.Binary =      (x) => "#binary(" & Serialize(Binary.ToList(x)) & ") ",

        Serialize.Function =    (x) => _serialize_function_param_type(
                                          Type.FunctionParameters(Value.Type(x)),
                                          Type.FunctionRequiredParameters(Value.Type(x)) ) &
                                       " as " &
                                       _serialize_function_return_type(Value.Type(x)) &
                                       " => (...) ",

        Serialize.List =        (x) => "{" & List.TransformAndCombine(x, Serialize, ", ") & "} ",

        Serialize.Record =      (x) => "[ " &
                                       List.TransformAndCombine(
                                            Record.FieldNames(x),
                                            (item) => Serialize.Identifier(item) & " = " & Serialize(Record.Field(x, item)),
                                            ", ") &
                                       " ] ",

        Serialize.Table =       (x) => "#table( type " &
                                        _serialize_table_type(Value.Type(x)) &
                                        ", " &
                                        Serialize(Table.ToRows(x)) &
                                        ") ",

        Serialize.Identifier =  Expression.Identifier,

        Serialize.Type =        (x) => "type " & _serialize_typename(x),


        _serialize_typename =    (x, optional funtype as logical) =>                        /* Optional parameter: Is this being used as part of a function signature? */
                                    let
                                        isFunctionType = (x as type) => try if Type.FunctionReturn(x) is type then true else false otherwise false,
                                        isTableType = (x as type) =>  try if Type.TableSchema(x) is table then true else false otherwise false,
                                        isRecordType = (x as type) => try if Type.ClosedRecord(x) is type then true else false otherwise false,
                                        isListType = (x as type) => try if Type.ListItem(x) is type then true else false otherwise false
                                    in

                                        if funtype=null and isTableType(x) then _serialize_table_type(x) else
                                        if funtype=null and isListType(x) then "{ " & @_serialize_typename( Type.ListItem(x) ) & " }" else
                                        if funtype=null and isFunctionType(x) then "function " & _serialize_function_type(x) else
                                        if funtype=null and isRecordType(x) then _serialize_record_type(x) else

                                        if x = type any then "any" else
                                        let base = Type.NonNullable(x) in
                                          (if Type.IsNullable(x) then "nullable " else "") &
                                          (if base = type anynonnull then "anynonnull" else
                                          if base = type binary then "binary" else
                                          if base = type date   then "date"   else
                                          if base = type datetime then "datetime" else
                                          if base = type datetimezone then "datetimezone" else
                                          if base = type duration then "duration" else
                                          if base = type logical then "logical" else
                                          if base = type none then "none" else
                                          if base = type null then "null" else
                                          if base = type number then "number" else
                                          if base = type text then "text" else
                                          if base = type time then "time" else
                                          if base = type type then "type" else

                                          /* Abstract types: */
                                          if base = type function then "function" else
                                          if base = type table then "table" else
                                          if base = type record then "record" else
                                          if base = type list then "list" else

                                          "any /*Actually unknown type*/"),

        _serialize_table_type =     (x) =>
                                           let
                                             schema = Type.TableSchema(x)
                                           in
                                             "table " &
                                             (if Table.IsEmpty(schema) then "" else
                                                 "[" & List.TransformAndCombine(
                                                     Table.ToRecords(Table.Sort(schema,"Position")),
                                                     each Serialize.Identifier(_[Name]) & " = " & _[Kind],
                                                     ", ") &
                                                 "] "),

        _serialize_record_type =    (x) =>
                                            let flds = Type.RecordFields(x)
                                            in
                                                if Record.FieldCount(flds)=0 then "record" else
                                                    "[" & List.TransformAndCombine(
                                                        Record.FieldNames(flds),
                                                        (item) => Serialize.Identifier(item) & "=" & _serialize_typename(Record.Field(flds,item)[Type]),
                                                        ", ") &
                                                    (if Type.IsOpenRecord(x) then ", ..." else "") &
                                                    "]",

        _serialize_function_type =  (x) => _serialize_function_param_type(
                                              Type.FunctionParameters(x),
                                              Type.FunctionRequiredParameters(x) ) &
                                            " as " &
                                            _serialize_function_return_type(x),

        _serialize_function_param_type = (t,n) =>
                                let
                                    funsig = Table.ToRecords(
                                        Table.TransformColumns(
                                            Table.AddIndexColumn( Record.ToTable( t ), "isOptional", 1 ),
                                            { "isOptional", (x)=> x>n } ) )
                                in
                                    "(" &
                                    List.TransformAndCombine(
                                        funsig,
                                        (item)=>
                                            (if item[isOptional] then "optional " else "") &
                                            Serialize.Identifier(item[Name]) & " as " & _serialize_typename(item[Value], true),
                                        ", ") &
                                     ")",

        _serialize_function_return_type = (x) => _serialize_typename(Type.FunctionReturn(x), true),

        Serialize = (x) as text =>
                           if x is binary       then try Serialize.Binary(x) otherwise "null /*serialize failed*/"        else
                           if x is date         then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is datetime     then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is datetimezone then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is duration     then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is function     then try Serialize.Function(x) otherwise "null /*serialize failed*/"      else
                           if x is list         then try Serialize.List(x) otherwise "null /*serialize failed*/"          else
                           if x is logical      then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is null         then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is number       then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is record       then try Serialize.Record(x) otherwise "null /*serialize failed*/"        else
                           if x is table        then try Serialize.Table(x) otherwise "null /*serialize failed*/"         else
                           if x is text         then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is time         then try Expression.Constant(x) otherwise "null /*serialize failed*/"     else
                           if x is type         then try Serialize.Type(x) otherwise "null /*serialize failed*/"          else
                           "[#_unable_to_serialize_#]"
    in
        try Serialize(value) otherwise "<serialization failed>"
in
    Value.ToPowerQuery

// Inspect_Table
let
    Inspect.Table = "NYI"
in
    Inspect.Table

// Inspect_Column
let
    Inspect.Column = (source as table, column as text) as record =>
        // Get number of values, type, count
        let
            colValues = Table.Column(source, column),
            result = [
                // TableName = "todo",  // created in parent func TableStats
                ColumnName = column,

                Count = List.Count( colValues ),
                Count_Distinct = List.Count( List.Distinct( colValues ) ),

                Table_Type = Value_ToPowerQuery( Value.Type( source ) ),
                FirstRecord_Type =  Value_ToPowerQuery( Value.Type( colValues{0} ?? null ) ),

                Schema = Table.Schema( source ),

                PowerQuery = Value_ToPowerQuery( source ),
                All_Values = colValues,
                Distinct_Values = Table.Distinct( Table.SelectColumns( source, {column}, MissingField.Error ) )
            ]
        in
            result
in
    Inspect.Column

// Table_FindDuplicates
let
    Table.FindDuplicates = "nyi"
in
    Table.FindDuplicates

// SampleData_DuplicateValues
let
    // a mixture of almost-distinct, and non-distinct values
    Source = #table(
        type table[String = text, Description = text],
        {
            { "-91", "negative 91" },
            { "1", "one" },
            { "cat", "cat lowercase" },
            { "CAT", "cat uppercase" },
            { "1", "one" },
            { "1#(lf)", "1 newline" },
            { "0", "zero" },
            { "0", "zero" },
            { "0  ", "zero /w space" },
            { "0", "zero" }
        }
    ),
    convertNumber = Table.AddColumn(
        Source,
        "Number",
        each try Number.From( [String] ) otherwise null,
        type nullable number
    )
in
    convertNumber

// SummarizeRecord - sketch
// Record_Schema
let
    /*
    About:
        get the schema of a Record
    */


    fn_Record_Schema = (source as record) as table =>
        let
            names = Record.FieldNames( source ),
            schemaList = List.Transform(
                names,
                (name as any) =>
                    let
                        fieldValue = Record.Field(source, name)
                    in
                        [
                            Name = name,
                            Type = Type_ToText( Value.Type( fieldValue ) ),
                            Value = fieldValue

                        ]
            ),
            resultTable = Table.FromRecords(
                schemaList,
                type table[
                    Name = text,
                    Type = Type.Type,
                    Value = any],
                MissingField.Error)
        in
            resultTable,

// Record.Summarize
// let
    /*
    converts records into a string

        let
            source =
        in
            Record.Summarize(source)

    Example: Basic
        input:

            [ Name = "Dog", Age = 3, DogYears = 3*3 ],

        output: as text:
            '[ Age = 3, DogYears = 9, Name = "Dog" ]'

    Example: Values are converted using 'culture':
        input:
            [ now = DateTime.LocalNow(), utc = DateTimeZone.UtcNow(), culture = Culture.Current ]


        output as text:
            [ now = 1/7/2021 10:52:12 AM, utc = 1/7/2021 4:52:12 PM +00:00, culture = en-US ]

    Example3:
        options = [ separator = "#(lf,tab)", prefix = "[#(lf,tab)", suffix = "#(lf)]" ],

        output:

            [
                culture = en-US
                now = 1/7/2021 11:14:59 AM
                utc = 1/7/2021 5:14:59 PM +00:00
            ]

    when options[sort] = true
        in:
            [ Name = cat, Lives = 9 ]
        out:
            [ Lives = 9, Name = cat ]

    Example 4:
        in:
            [ Num = 123.45 ]

        with default
            [ Num = 123.45 ]

        with [ culture = "de-DE" ]
            [ Num = 123,45 ]


    */

    fn_Record.Summarize = (source as record, optional options as nullable record) as text =>
        let
            // supports nested records
            // next: simplify parameter handling w/ Validate_OptionalArgRecord
            // future: support nested recursively?
            // future:  allow Text.From error to just place a default value



            outputPrefix = Text.From(options[prefix]? ?? "[ "),
            outputSuffix = Text.From(options[suffix]? ?? " ]"),
            outputSeparator = Text.From(options[separator]? ?? ", "),
            culture = options[culture]? ?? null,

            // outputSuffix = options[suffix]? ??  " ]",
            optionSort = options[sort]?  ?? true,

            _n = Record.FieldNames( source ),
            names = if optionSort then List.Sort(_n) else _n,


            pairs = List.Transform(
                names,
                (key as text) =>
                    let
                        value = Record.Field( source, key ),

                        valueIsRecord = Type.Is( Value.Type(value), type record),
                        maybeFlatValue =
                            try if valueIsRecord then @fn_Record.Summarize( value, options )
                            else value,

                        // do not throw by default
                        flatValue =
                            if maybeFlatValue[HasError]
                            then "< " & Type_ToText(Value.Type(value)) & " >"
                            else maybeFlatValue[Value],
                        pair = [
                            Key = key,
                            Value = try flatValue otherwise "<obj>"
                        ]
                    in
                        pair
            ),
            flat_pairsAsText = List.Transform(
                pairs,
                (field as record) =>
                    field[Key] & " = "  & Text.From( field[Value], culture )
            ),

            transformPair = (field as record) as text =>
                let
                    result  = field[Key] & " = "  & Text.From( field[Value], culture )
                in
                    result,

                    // isRecord =
                    //     Value.Is(
                    //         type record,
                    //         Value.Type( field[Value] )
                    //     )
                // in
                //     if isRecord then
                //         //"[nested]"
                //         "<<" &
                //         @fn_Record.Summarize( field[Value] )
                //         & ">>"
                //     else


            pairsAsText = List.Transform(
                pairs,
                (field as record) => transformPair(field)
            ),
            x3 = outputPrefix & Text.Combine( pairsAsText, outputSeparator ) & outputSuffix
        in
            x3,

    fin = 1
in
    fin

// Web_Request
// webRequest
let
    /*
    Example using the url:
        https://www.metaweather.com/api/location/search?lattlong=36.96,-122.02

        webRequest(
            "https://www.metaweather.com",
            "api/location/search",
            [ lattlong = "36.96,-122.02" ]
        )

    */
    Documentation = type function (
        staticPath as (type text meta [
            Documentation.FieldCaption = "Base Url",
            Documentation.FieldDescription = "Minimum of a url, usually up to '.com'",
            Documentation.SampleValues = {"https://www.metaweather.com"}
        ]),
        relativePath as (type text meta [
            Documentation.FieldCaption = "relativePath",
            Documentation.FieldDescription = "Everything after '.com' up until a '?'#(lf)ie: API Endpoint",
            Documentation.SampleValues = {"api/location/search"}
        ]),
        optional query as (type nullable record meta [
            Documentation.FieldCaption = "r",
            Documentation.FieldDescription = "a",
            Documentation.AllowedValues = {
                "[ lattlong = ""36.96,-122.02"" ]"
                }
        ]),
        optional asRaw as (type nullable logical meta [
            Documentation.FieldCaption = "return raw? (True skips parsing JSON)",
            Documentation.FieldDescription = "Set to 'true' to get non-JSON data",
            Documentation.AllowedValues = { true, false, null}
        ]),
        optional headers as (type nullable record meta [
            Documentation.FieldCaption = "return raw? (True skips parsing JSON)",
            Documentation.FieldDescription = "Set to 'true' to get non-JSON data",
            Documentation.AllowedValues = {
                [ Accept ="application/json" ]
            }
        ])
    ) as table meta [
        Documentation.Name = "Web.Request",
        Documentation.LongDescription = "short, domain name",
        Documentation.Examples = {
                [
                    Description = "Generate one value",
                    Code = "RandomInt(10, 20)",
                    Result = "11"
                ],
                [
                    Description = "Generate one value",
                    Code = "RandomInt(10, 20)",
                    Result = "11"
                ]
            }
        ],


    function_Web.Request = (
        staticPath as text,                 // domain
        relativePath as text,               // basically use everything after ".com" to "?"
        optional query as nullable record,  // url query string
        optional asRaw as nullable logical, // use true if content is not Json
        optional headers as nullable record
    ) as any =>
        let
            query = query ?? [],
            asRaw = asRaw ?? false, // toggles calling Json.Document() or not
            headers = headers ?? [
                Accept="application/json"
            ],

            baseUrl = staticPath,
            options = [
                RelativePath = relativePath,
                Headers = headers,
                Query = query
                // ManualStatusHandling = {400, 404}
            ],
            // wrap 'Response' in 'Binary.Buffer' if you are using it multiple times
            response = Web.Contents(staticPath, options),
            metadata = Value.Metadata(response),
            buffered = Binary.Buffer(response),
            result = Json.Document(buffered)
        in
            [
                response = if asRaw then buffered else result,
                status_code = metadata[Response.Status],
                metadata = metadata
            ]
in
    Value.ReplaceType( function_Web.Request, Documentation)

// toggle table max limit - SampleData_DuplicateValues (2)
let
    // Config_MaxRows = null, // null means keep everything
    Config_MaxRows = 2000, // or set the number of rows
    Raw_Source = test_DateTime_FromUnixTime,

    Source
        = if Config_MaxRows <> null
            then Table.FirstN(Raw_Source, Config_MaxRows)
            else Raw_Source,


    NumRows = Table.RowCount(Source)

in
    NumRows

// Web_Request - Invoke Test
let
    Source = "x",
    fn = Web_Request
in
    fn