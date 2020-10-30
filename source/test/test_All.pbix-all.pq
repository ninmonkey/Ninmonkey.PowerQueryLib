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
// TypeAsText
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
    Type.AsText =  (x, optional funtype as logical) =>
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
    Type.AsText

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

// built in comparison
let
    Source = Text.Combine
in
    Source

// test_DateTimeFrom_UnixTime
let
    DateTime_FromUnixTime = (unixTime as number) as any =>
        /*
        see also:
            https://en.wikipedia.org/wiki/Unix_time#UTC_basis

        DateTime.FromFileTime
        DateTimeZone.FromFileTime

        To use the epoch "12:00 midnight, January 1, 1601", use the functions
            DateTime.FromFileTime, and DateTimeZone.FromFileTime

        Overflows return errors
        */
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
    Custom3 = unitTest_t3,


            // 2004-09-17T00:00:33.25 	2004-09-17T00:00:01.25 	1095379201.25



    // 1000000
    // 16040719521234433

    t2 = Table.AddColumn(
        t1,
        "Default",
        each DateTime_FromUnixTime( _[Value]  ),
        type datetime

    ),
    Custom2 = Custom3,
    #"Added Custom" = Table.AddColumn(Custom2, "try timezone", each DateTime.AddZone( [Expected], 0, null), type datetimezone),
    #"Inserted Local Time" = Table.AddColumn(#"Added Custom", "Local Time", each DateTimeZone.ToLocal([try timezone]), type datetimezone)
in
    #"Inserted Local Time"