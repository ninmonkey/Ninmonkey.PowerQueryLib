/* PowerQueryLib : v 0.0.2
    Generated on: 1/11/2022 10:05 PM
    Source:
        https://github.com/ninmonkey/Ninmonkey.PowerQueryLib
        Jake Bolton ninmonkeys@gmail.com
*/let
    Metadata = [
        LastExecution = DateTime.FixedLocalNow(),
        PQLib = "0.0.2",
        GeneratedOn = "2022-01-11T22:05:14.6587060-06:00",
        Commit = "f9ec9b0fa120affe5b68ad72d8a31403530be150",
        BuildArgIncludes = "'ToText', 'Text'",
        BuildArgExcludes = "'$test_', 'wordwrap', 'IP\.Dot', 'regex', 'shared -', 'WebRequest', '\.old\.pq$'",
        BuildArgFileList = "'DateTable_FromDates.pq', 'DateTime.FromUnixTime.pq', 'Inspect_Function.pq', 'Inspect.Metadata.pq', 'Inspect.MetaOfType.pq', 'Inspect.Type.pq', 'List.ContinuousDates.pq', 'List.Summarize.pq', 'ParameterQuery.Summary.pq', 'Query_Summary.pq', 'Record.Schema.pq', 'Record.Summarize.pq', 'Serialize.ExtendedType.pq', 'Serialize.List.pq', 'Serialize.Text.pq', 'Summarize.Record.pq', 'Table.SelectRemovedColumns.pq', 'Type.ToText.pq'"
    ],
    FinalRecord = [
        Lib = Metadata,
#"DateTable_FromDates" = let
    /*
    Input:
        Table with at least a [Date] column
    output:
        Adds columns for: [Year], [Month], [Day], [Week of Year], [Date Id] key

    future:
        optionally add time when datetime is the source

    */
    Date.TableFromDates = (source as table) as table =>
        let
            // isDatetime =  ..., // if datetime, or datetimezone,
            source =
                if Table.HasColumns( source, {"Date"} )
                then source
                    else error Error.Record(
                        "InvalidArgument", "Expects a table with a column named 'Date'", source
                    ),

            base =List.ContinuousDates( source[Date] ),
            col_Year = Table.AddColumn(base, "Year", (_) as number => Date.Year([Date]), Int64.Type),
            col_Month = Table.AddColumn(col_Year, "Month", (_) as number => Date.Month([Date]), Int64.Type),
            col_Day = Table.AddColumn(col_Month, "Day", (_) as number => Date.Day([Date]), Int64.Type),
            col_WeekOfYear = Table.AddColumn(col_Day, "Week of Year", (_) as number => Date.WeekOfYear([Date]), Int64.Type),
            col_Index = Table.AddIndexColumn(col_WeekOfYear, "Date Id", 0, 1, Int64.Type),
            verifyDistict = Table.IsDistinct(col_Index, {"Date"}),
            Final =
                if verifyDistict then col_Index
                else error Error.Record(
                    "TableNotDistinct", "Using column 'date'", col_Index )
        in
            Final

in
    Date.TableFromDates
,
#"DateTime.FromUnixTime" = let
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
    DateTime_FromUnixTime,
#"Inspect.Metadata" = // md
    let
        // Inspect metadata
        FuncDef = (x as any) as any => Value.Metadata(x), // nullable record not guaranteed
        // Inspect metadata
        FuncType = type function (input as any) as any
            meta [
                Documentation.Name = "Alias for Value.Metadata(x)",
                Documentation.LongDescription = "Alias for getting an object's metadata"
                // Documentation.Examples = {
                //     [
                //         Description = "Metadata of object",
                //         Code = "Inspect.Type( Value.Type )",
                //         Result = "function"
                //     ]
                // }
            ],
        enableTesting = false,
        testResults = Inspect.Metadata( Value.Type ),
        Inspect.Metadata = Value.ReplaceType(FuncDef, FuncType)
    in
        if not enableTesting then Inspect.Metadata else  testResults,
#"Inspect.MetaOfType" = let
    // Inspect type
    FuncDef = (x as any) as record =>
        let
            t = Value.Type(x),
            md = Value.Metadata(x),
            mdt = Value.Metadata( Value.Type(x) )
        in
            [
                TypeName = Type.ToText( t ),
                Type = t, Metadata = md, TypeMetadata = mdt
            ],

    // Inspect type
    FuncType = type function (input as any) as record
        meta [
            Documentation.Name = "Metadata of Type",
            Documentation.LongDescription = "Sugar for the Metadata of an object's type",
            Documentation.Examples = {
                [
                    Description = "Type of a function",
                    Code = "Record.FieldNames( Inspect.MetaOfType( BinaryEncoding.Base64 ) )",
                    Result = "{ ""Documentation.Name"", ""Documentation.Description"", ""Documentation.LongDescription"", ""Documentation.Category"", ""Documentation.Examples"" }"
                ]
            }
        ],
    // enableTesting = false,
    // testResults = Record.FieldNames(Inspect.MetaOfType(BinaryEncoding.Base64)),
    Inspect.MetaOfType = Value.ReplaceType(FuncDef, FuncType)
in
    Inspect.MetaOfType,
#"Inspect.Type" =  let
        // Inspect type
        FuncDef = (x as any) => Value.Type(x),
        // Inspect type
        FuncType = type function (input as any) as any
            meta [
                Documentation.Name = "Alias for Value.Type()",
                Documentation.LongDescription = "Alias for getting an object's type",
                Documentation.Examples = {
                    [
                        Description = "Type of a function",
                        Code = "Inspect.Type( Value.Type )",
                        Result = "function"
                    ]
                }
            ],
        enableTesting = false,
        testResults = Inspect.Type( Value.Type ),
        Inspect.Type = Value.ReplaceType(FuncDef, FuncType)
    in
        if not enableTesting then Inspect.Type else  testResults,
#"List.ContinuousDates" = let
    List.ContinuousDates = (source as list) as table =>
        /*
        Generate all dates for a date table
            Source: <https://github.com/ninmonkey/Ninmonkey.PowerQueryLib/blob/master/source/List.ContinuousDates.pq>
        input:
            a list or table table column of dates
        output:
            table of continuous [Date]s., for a Date table
        future:
            auto detect if arg is a table or a list
        */
        let
            first = List.Min(source),
            last =  List.Max(source),
            days =  { Number.From(first)..Number.From(last) },

            baseDates = List.Transform(
                days, each Date.From(_) ),

            FinalTable = Table.FromList(
                baseDates, Splitter.SplitByNothing(),
                type table[Date = date], null, ExtraValues.Error
            )
        in
            FinalTable,

    show_example = false,
    example =
        let
            sample = { #date(2010,1,9), #date(2010,1,3), #date(2010,1,5) },
            result = List.ContinuousDates(sample)
        in
            result,

    FinalResult =
        if show_example then example else List.ContinuousDates

in
    FinalResult,
#"List.Summarize" = /*

options:
    Suffix type: text    default: "{"
    Prefix type: text    default: "{"
    Separator   type: text    default: {

Note:

*/
let
    List.Summarize = (
        values as list,
        optional options as nullable record
    ) as text => let
        Separator = options[Separator]? ?? ", ",
        Prefix    = options[Prefix]? ?? "{",
        Suffix    = options[Suffix]? ?? "}",
        joined    = List.Accumulate(
            values, "",
            (seed, item) =>
                if seed = "" then Text.From(item)
                else seed & Separator & Text.From(item)),

        output = Prefix & joined & Suffix
    in
        output
in
    List.Summarize,
#"Number.From_TextWithBase" = let
    enableTest = false,
    /*
    better naming idea?

        Number.FromTextWithBaseWithBase
        TextTo_NumberWithBase
        Number.FromTextWithBase
        Number.FromTextWithBaseBase
        Text.To_NumberWithBase

     */

    Number.FromTextWithBase = (Input as text, optional Base as number) as number =>
        // original from: <https://xxlbi.com/blog/converting-hexadecimal-to-decimal-numbers-in-power-query/>
        let
            Symbols = {"0".."9"} & {"A".."F"},
            AsReverseList = List.Reverse(Text.ToList(Text.Upper(Input))),
            AsNumbers = List.Transform(
                AsReverseList,
                each List.PositionOf(Symbols, _)
            ),
            DigitConversion = List.Generate(
                () => 0,
                each _ < List.Count(AsNumbers),
                each _ + 1,
                each AsNumbers{_} * Number.Power(Base ?? 16, _)
            ),
            // Result = try List.Sum(DigitConversion) otherwise null
            Result = try List.Sum(DigitConversion) otherwise error Error.Record(
                "TypeConversionFailed", "Unable to convert",
                [
                    Input = Input,
                    Base = Base,
                    DigitConversion = DigitConversion
                ]
            )
        in
                Result,

    tests = {
        Number.FromTextWithBase("0101", 2) = 5,
        Number.FromTextWithBase("ff", 16) = 255
    },
    Final =
        if enableTest then tests else Number.FromTextWithBase
in
    Final,
#"ParameterQuery.Summary" = let
    // Type.ToText = lib[Type.ToText],

    ParameterQuery.Summary = (environment as nullable record, ignoreQueries as list) as any =>
        let
            ignoreQueries = ignoreQueries ?? {"lib", "Readme", "SummarizeReportParams" },
            source = environment ?? #sections[Section1],
            removeCyclicalRef = Record.RemoveFields(  source , ignoreQueries ),

            baseTable = Record.ToTable( removeCyclicalRef ),
            #"Added Custom" = Table.AddColumn(baseTable,
                "Typename",
                (_) as text =>
                    Type.ToText( Value.Type( [Value] ) ),
                 type text
            ),

            getMetadata = Table.AddColumn(
                #"Added Custom", "Meta",
                each Value.Metadata( [Value] )
            ),

        // met = Value.Metadata( [Value] ),
        #"Filtered Rows" = getMetadata
        // ]),
        //     #"Expanded Meta" = Table.ExpandRecordColumn(#"Added Custom1", "Meta", {"mtype", "met"}, {"mtype", "met"}),
        //     #"Expanded met" = Table.ExpandRecordColumn(#"Expanded Meta", "met", {"IsParameterQuery", "List", "DefaultValue", "Type", "IsParameterQueryRequired", "ExpressionIdentifier"}, {"met.IsParameterQuery", "met.List", "met.DefaultValue", "met.Type", "met.IsParameterQueryRequired", "met.ExpressionIdentifier"}),
        //     #"Filtered Rows" = Table.SelectRows(#"Expanded met", each ([met.IsParameterQuery] = true))

        // in [ t1 = Custom5, fin = #"Filtered Rows" ]
        in
            #"Filtered Rows"
    in
        ParameterQuery.Summary
,
#"Record.Summarize" = // Record.Summarize
let
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

    Record.Summarize = (
        source as record,
        optional options as nullable record
    ) as text =>
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

                        // do not throw by default
                        maybeFlatValue =
                            try
                                if valueIsRecord then @Record.Summarize( value, options )
                                else value,

                        flatValue =
                            if maybeFlatValue[HasError]
                            then "< " & Type.ToText(Value.Type(value)) & " >"
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
                //         @Record.Summarize( field[Value] )
                //         & ">>"
                //     else


            pairsAsText = List.Transform(
                pairs,
                (field as record) => transformPair(field)
            ),
            x3 = (outputPrefix
                & Text.Combine( pairsAsText, outputSeparator )
                & outputSuffix
            )
        in
            x3
in
    Record.Summarize,
#"Serialize.ExtendedType" = 
/*

Todo
    Type.AsText() will invoke this for non-primative type checking

    Should Type.AsText()
    See: Type.AsText() to get primative ty

Better naming?
    Serialize.ExtendedTypeName()
    Serialize.ExtendedType()
    ExtendedTypeName.AsText()


*/
let

    /* Optional parameter: Is this being used as part of a function signature? */
    ExtendedTypeName.AsText =  (x, optional funtype as logical) =>
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
    ExtendedTypeName.AsText
,
#"Serialize.List" = /*

Description:


see:
    ListAsText()

original code based on: <https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244>

*/
let

    Documentation = type function (
        anyList as (type number meta [
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
        ])
    )
    as table meta [
        Documentation.Name = "[Name] SumNumbers",
        Documentation.LongDescription = "[LongDesc] Adds two numbers",
        Documentation.Examples = {[
            Description = "Sum two numbers",
            Code = "let sum = Func(1, 3) in sum",
            Result = "4"
        ]}
    ],


    /* Optional parameter: Is this being used as part of a function signature? */
    Serialize.List =  (anyList as list) as text => "{" &
        List.Accumulate(anyList, "",
            (seed,item) =>
                if seed="" then Text.From(item)
                else seed & ", " & Text.From(item)) &
            "} "
in
    Serialize.List
,
#"Serialize.Text" = let
    /*
    from: https://github.com/microsoft/DataConnectors/blob/master/samples/UnitTesting/UnitTesting.query.pq
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
,
#"Table.SelectRemovedColumns" = let
    // For when you're using Table.SelectColumns(), easily view only the removed columns
    Table.SelectRemovedColumns = (source as table, previousTable as table) as any =>
        let
            sourceCols = Table.ColumnNames(source),
            prevCols = Table.ColumnNames(previousTable),
            deltaCols = List.RemoveMatchingItems(sourceCols, prevCols),
            selectMissing = Table.SelectColumns( source, deltaCols ),
            return = [
                deltaCols = deltaCols,
                selectMissing = selectMissing
            ]
        in
            selectMissing
in
    Table.SelectRemovedColumns,
#"Text.AnyMatches" = let
/*
    For a list of values, test any combination of: Text.StartsWith, Text.Contains, Text.EndsWith
    one or more matches returns true

    future:
        List.Generate/Accumulate to stop calls when one is already true
    */
    #"Text.AnyMatch" = (
        source as text,
        optional filtersStartsWith as nullable list,
        optional filterContainsWith as nullable list,
        optional filterEndsWith as nullable list,
        optional comparer as nullable function
    ) as logical =>
        let
            comparer = comparer ?? Comparer.OrdinalIgnoreCase,
            filtersStartsWith = filtersStartsWith ?? {},
            filterContainsWith = filterContainsWith ?? {},
            filterEndsWith = filterEndsWith ?? {},
            // x = FilterPrefix Text.Contains(source, Config),
            anyStart = List.Transform(
                filtersStartsWith, (i) => Text.StartsWith( source, i, comparer)
            ),
            anyContain = List.Transform(
                filterContainsWith, (i) => Text.Contains( source, i, comparer)
            ),
            anyEnd = List.Transform(
                filterEndsWith, (i) => Text.EndsWith( source, i, comparer)
            ),
            boolShouldFilter = List.AnyTrue( anyStart )
                or List.AnyTrue( anyContain )
                or List.AnyTrue( anyEnd )
        in
            boolShouldFilter
in
   #"Text.AnyMatch"
,
#"Text.IsNullOrWhitespace" = // Text_IsNullOrWhitespace
let
    run_example = false,
    Text_IsNullOrWhitespace = (source as nullable text) as logical =>
        /* True when source only contains: null or whitespace or control chars

            [string]::IsNullOrWhitespace()
        */
        let
            trimClean = Text.Trim( Text.Clean( source ) ),
            len = Text.Length(trimClean)
        in
            source is null or len = 0,
    tests = {
        Text_IsNullOrWhitespace("#(tab)#(cr,lf)"),
        Text_IsNullOrWhitespace("     "),
        Text_IsNullOrWhitespace(""),
        Text_IsNullOrWhitespace(null)
    }
in
    if run_example then tests else Text_IsNullOrWhitespace,
#"Text.JsonToPowerQuery" = let
    /* converts JSON string to a pastable PowerQuery Literal
    Otherwise you have to escape values

    Usage:
        Text_JsonToPowerQuery(
            Table_ToJson( TableName )
        )

    */
    Text.JsonToPowerQuery = (json as text) as text =>
        let
            doubleQuote = """",
            escapeQuotes = Text.Replace(
                json, doubleQuote,
                ( doubleQuote & doubleQuote)
            )
        in
            escapeQuotes
in
    Text.JsonToPowerQuery,
#"Type.ToText" = /*


Todo:
    - [ ] Better name: Type.ToText
    - [ ] Clean up, add unit testing for all types.

Originally based on: <https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244>

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

    ]
in
    FinalRecord
