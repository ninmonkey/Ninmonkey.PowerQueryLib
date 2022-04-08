/* PowerQueryLib : v 
    Generated on: 10/23/2021 9:54 PM
    Source:
        https://github.com/ninmonkey/Ninmonkey.PowerQueryLib
        Jake Bolton ninmonkeys@gmail.com
*/let
    Metadata = [
        LastExecution = DateTime.FixedLocalNow(),
        PQLib = "",
        GeneratedOn = "2021-10-23T21:54:20.1576690-05:00",
        Commit = "be5addf2d75cd2d57824b70dfa82165600d09db2",
        BuildArgIncludes = "'ToText', 'Text', 'Text', 'Text'",
        BuildArgExcludes = "'$test_', 'wordwrap', 'IP\.Dot', 'regex', 'shared -', 'inspect', 'WebRequest', '\.old\.pq$'",
        BuildArgFileList = "'List.Summarize.pq', 'Summarize.Record.pq', 'Record.Summarize.pq', 'List.Summarize.pq', 'Type.ToText.pq', 'Table.SelectRemovedColumns.pq'"
    ],
    FinalRecord = [
        Lib = Metadata,
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

    fn_Record.Summarize = (
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
                                if valueIsRecord then @fn_Record.Summarize( value, options )
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
                //         @fn_Record.Summarize( field[Value] )
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
    fn_Record.Summarize,
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
    def_Table.SelectRemovedColumns = (source as table, previousTable as table) as any =>
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
    def_Table.SelectRemovedColumns,
#"Text_JsonToPowerQuery" = let
    /* converts JSON string to a pastable PowerQuery Literal
    Otherwise you have to escape values

    Usage:
        Text_JsonToPowerQuery(
            Table_ToJson( TableName )
        )

    */
    Text_JsonToPowerQuery = (json as text) as text =>
        let
            doubleQuote = """",
            escapeQuotes = Text.Replace(
                json, doubleQuote,
                ( doubleQuote & doubleQuote)
            )
        in
            escapeQuotes
in
    Text_JsonToPowerQuery,
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
