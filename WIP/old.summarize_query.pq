// References
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("TcxNC4IwGADgvzJ2KlD3YR0UIvBUlwyiLuJhm680EjfcO7R/X+Gl63N4moZe3QwTqc7k7juFQFJSG3T6a5JLQRP6RPShZOztIsZMA9vFx+VVLCd540c85HtB26ShlcXZBiC1h0mhdWMgGw29m4D0cTSrwGIDQrf9azu1ZGh9YJKLggnOeP6zVK9fatRg4rCOjLbtBw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Description = _t, Url = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Description", type text}, {"Url", type text}})
in
    #"Changed Type"

// Query Summary
let

    Source = #sections,
    Config = [
        IgnoreQueries = {"Query Summary_InOneGo", "Query Summary"},
        KeepColumns = { "Query", "Type", "Table Meta" },
        HideNonTables = false
    ],
    /*
        Summarize (all?) queries
        future:
            - [ ] apply schema, to have a better expansion
            - [ ] maybe one addcolumn, or nested join, which leads to expanding to coloumns
    */
    Query_Summary = (
        optional ignoredKeys as nullable list
    ) as any => //table =>
        let
            source = Record.RemoveFields(
                #sections[Section1],
                (ignoredKeys ?? {"Query Summary"})
            ),
            baseTable = Record.ToTable( source ),
            t1 = Table.AddColumn(
                baseTable, "Type",
                each
                    Value.Type( _[Value] )
                , Type.Type
            ),
            t2 = Table.AddColumn(
                t1, "TypeName",
                each
                    Type_ToText( Value.Type( _[Value] ))
                ,type text
            ),
            t3 = Table.AddColumn(
                t2, "Table Schema",
                (row) =>
                    if row[TypeName] = "Table"
                    then Table.Schema( row[Value] )
                    else null,
                Table.Type
            ),
            finalMeta = t3
        in
            finalMeta,
    Invoke = Query_Summary( Config[IgnoreQueries] ),
    #"Filtered Rows"
        =
            if Config[HideNonTables]
            then Table.SelectRows(Invoke,
                each
                    "Table" = Type_ToText( Value.Type( [Value] ))
            )
            else Invoke,
    finalTable = #"Filtered Rows"
in
    finalTable

// Type_ToText
// TypeAsText
/*


Todo:
    - [ ] Better name: Type.ToText
    - [ ] Clean up, add unit testing for all types.

Originally based on: <https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244>

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

// Query Summary_InOneGo
let

    Source = #sections,
    Config = [
        IgnoreQueries = {"Query Summary_InOneGo", "Query Summary"},
        KeepColumns = { "Query", "Type", "Table Meta" },
        HideNonTables = true
    ],
    /*
        Summarize (all?) queries
        future:
            - [ ] apply schema, to have a better expansion
    */
    Query_Summary = (
        optional ignoredKeys as nullable list
    ) as any => //table =>
        let
            source = Record.RemoveFields(
                #sections[Section1],
                (ignoredKeys ?? {"Query Summary"})
            ),
            baseTable
                = Record.ToTable( source )
                    // otherwise "fail"
                ,
            col_info = Table.AddColumn(
                baseTable,
                "Info",
                (row) as record =>
                    let
                        querySource = row[Value],
                        queryType = Value.Type( querySource ),
                        typeName = Type_ToText( queryType ),
                        // typeName = Type_ToText( Value.Type( querySource )),
                        schema = null,
                        // schema
                        //     = if typeName <> "Table"
                        //         then null
                        //         else Table.Schema( querySource ),
                        summary = [
                            TypeName = typeName,
                            Type = queryType,
                            Schema = schema
                            // TableSummary
                            //     = if not (typeName = "Table")
                            //         then null
                            //         else "yes"
                        ]
                    in
                        summary,
                infoType
                // ,type foo Better Typing here
            ),

            infoType = type table [
                TypeName = Text.Type,
                Type = Type.Type,
                Schema = nullable Table.Type
                // Schema = nullable Table.Type
                // ,
                // TableInfo = nullable Table.Type
            ],



            // t1 = Table.AddColumn(
            //     t0, "Type",
            //     each
            //         Value.Type( _[Value] )
            //     , Type.Type
            // ),
            // t2 = Table.AddColumn(
            //     t1, "TypeName",
            //     each
            //         Type_ToText( Value.Type( _[Value] ))
            //     ,type text
            // ),
            // t3 = Table.AddColumn(
            //     t2, "Table Schema",
            //     (row) =>
            //         if row[TypeName] <> "Table" then null
            //         else Table.Schema( row[Value] )
            //     // ,type text
            // ),
                    // Type_AsText(Value.Type( _[Value] )
                // type text
            //     ),
            // ),

            // data = [
            //     // Schema = Table.Schema( t0 ),
            //     Main = t1
            // ],
            // finalMeta =
            finalMeta = col_info

            // t1 =

            // schema = Table.Schema( source ),
            // queryType = Table.AddColumn(
            //     source, "Query Type",

            // )
            // finalMeta = Table.Schema(source)
            // tMeta = (try l),
            // finalMeta = if source is table then tMeta[Value]? else null
            // finalMeta = if source is table then "yes" else "no"
        in
            finalMeta,
    col_TableType = Table.AddColumn(
        #"Added Custom",
        "Table Meta",
        // (row) => row[Query],
        (row) => try fn_tableSummary( row[Value] ),
        type any

    ),

    #"Removed Other Columns" = Table.SelectColumns(col_TableType, Config[KeepColumns] ),


    #"Expanded Table Meta" = Table.ExpandRecordColumn(#"Removed Other Columns", "Table Meta", {"HasError", "Value", "Error"}, {"Table Meta.HasError", "Table Meta.Value", "Table Meta.Error"}),
    Invoke = Query_Summary( Config[IgnoreQueries] ),
    #"Filtered Rows"
        =
            if Config[HideNonTables]
            then Table.SelectRows(Invoke, each "Table" = Type_ToText( Value.Type([Value])) )
            else Invoke,
    finalTable = #"Filtered Rows"
in
    finalTable

// IPDottedDecimal_ToInt
// IPDottedToDecimal
let
    /*
    takes a list of number, converts to decimal [uint32]

    input: DottedDecimal
        "192.168.1.0"
    output: Decimal [ 32-bit ]
        3232235776
    */

    // fn_IPDottedToDecimal = (IPDecimal as any) as any => let

        // TextList = Text.Split(IPDottedToDecimal, "."),
        IPDottedToDecimal = (dottedDecimal as text) as number =>
            let
                Source = "192.168.1.0",
                TextList = Text.Split(Source, "."),
                DecimalList = List.Transform(
                    TextList,
                    each Number.FromText(_, null)
                ),
                ByteString = Binary.FromList( DecimalList ),
                Decimal = BinaryFormat.UnsignedInteger32( ByteString )
            in
                Decimal
    in
        IPDottedToDecimal

// UnitTest
let
    result0 =
        let
            item = [
                Args = "192.168.1.0",
                Function = IPDottedDecimal_ToInt,
                Expected = 3232235776
            ],
            // result = IPDottedToDecimal( item[Args] )
            result = item[Function]( item[Args] ),
            isGood = result = item[Expected],

            SingleRecord = [
                Function = item[Function],
                Args = item[Args],
                Result = try result,
                IsGood = isGood
            ]
        in
            SingleRecord,
    result1 =
        let
            item = [
                Args = {192, 168, 1, 0},
                Function = IPDottedDecimal_FromList,
                Expected = "192.168.1.0"
            ],
            // result = IPDottedToDecimal( item[Args] )
            result = item[Function]( {192,  168, 1, 0} ),
            isGood = result = item[Expected],

            SingleRecord = [
                Function = item[Function],
                Args = item[Args],
                Result = try result,
                IsGood = isGood
            ]
        in
            SingleRecord,
    result2 =
        let
            item = [
                Args = {
                    {0..4},
                    "-",
                    null
                },
                Function = List_ToText,
                Expected = "0-1-2-3-4"
            ],
            // result = IPDottedToDecimal( item[Args] )
            result = item[Function]( item[Args]{0}, item[Args]{0} ),
            isGood = result = item[Expected],

            SingleRecord = [
                Function = item[Function],
                Args = item[Args],
                Result = try result,
                IsGood = isGood
            ]
        in
            SingleRecord,
    result3 =
        let
            args = {
                {0..4},
                "-"
            },
            SingleRecord = Text.Combine(
                List.Transform( args{0}, each Text.From(_) )
            )
        in
            SingleRecord,

    resultsList = {
        result0, result1,
        result2
    },
    // t0 = Table.FromRecords( { SingleRecord }, null, MissingField.Error ),
    temp0 = IPDottedDecimal_FromList( {192, 168, 1, 0} ),
    t0 = Table.FromRecords( resultsList, null, MissingField.Error ),
    #"Changed Type" = Table.TransformColumnTypes(t0,{{"IsGood", type logical}})
in
    #"Changed Type"

// List_ToText
// ListAsText
/*

options:
    Suffix type: text    default: "{"
    Prefix type: text    default: "{"
    Separator   type: text    default: {

Note:
    The original serializes **everything**
    This only shows type names as text

    this is not a round-trip serialization

*/
let
    Serialize.List =  (
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
    Serialize.List

// IPDottedDecimal_FromList
/*

Input:
    ListAsIp( {192, 168, 5, 85} )
Output:
    192.168.5.85
*/
let
    IP.IPDottedDecimal_FromList = (num as list) as text =>
        let
            e = error Error.Record("NYI", "brokenRewrite", null),

            isValid = try if List.Count(num) = 4
                then true
                else error Error.Record(
                    // "InvalidArgs", "List Length != 4", num
                    "Bad value", "Expected list length of 4", List_ToText(num, ".", "", "")
                ),

            final = List_ToText(num, ".", "", "")
        in
            // if isValid[HasError] then
            //     isValid[Error]
            // else
            //     final,
            //     // isValid[Value],
            //     // final,
            e

    // IP.DottedDecimalFromList( {192, 168, 1, 0})
in
    IP.IPDottedDecimal_FromList
    // IPDottedDecimal_FromList

// Enum_FileAttribute
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("LY/BbsIwEET/xWcOcRJMOFaEqlygIr1FHFx7aS3FdrRZUPP3tdccZzTvrXYcxRW0vYRpFRshxW0zig9nLYQUa47DuhD4FFuOvUMwFJH3iqs3NL/uCaloCtLD05mcVWHOEb2eMlB3XHyBnyNqltTbYhlmjQu8uymDW1lMV+D2M7pAma/qYjxEPyMsC9hsqNqivdzvkwuZb6u9ep2mQwwEgU7Bwh/vO7kv9mMwuM7EpVRNV9ynNP9BR+tACNrzWzvVvXSDwcd3r0lnppHVLqlu/w==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Name = _t, Value = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Name", type text}, {"Value", Int64.Type}}),


    z = Number_ToHexString(255),



    Custom1 = Table.AddColumn( #"Changed Type", "Hex",
        (row) as text =>

//  Number_ToHexString( row[Value] ),
                    "0x" & Text.PadStart( Number.ToText( row[Value], "x" ), 8, "0"),
        type text
        ),
    Custom2 = Number.ToText
in
    Custom2

// Number_ToHexString
let
    Number_ToHexString = (
        num as number,
        optional options as nullable record
    ) as text =>
        let
            defaults
                = [
                    PadStart = true,
                    Prefix = true,
                    Columns = 8
                ],
            options
                = Record.Combine({defaults, options ?? []}),
            prefix
                = if options[Prefix]? then "0x" else "",

            numString
                = Number.ToText(num, "x"),

            paddedString
                =  if options[PadStart]?
                    then Text.PadStart(
                        numString, "0",
                        options[Columns]? ?? 8
                    )
                    else numString,
            finalText
                = prefix & numString
        in
            finalText
in
    Number_ToHexString

// Sum_BitFlags
let
    // Combine all numbers by bitwise-OR-ing them togetherj
    Sum_BitFlags = (source as list) as number =>
        let
            joined_flags = List.Accumulate(
                source, 0,
                (state, current) => Number.BitwiseOr( state, current )
            )
        in
            joined_flags
in
    Sum_BitFlags

// FilterDistinct
true meta [IsParameterQuery=true, List={true, false}, DefaultValue=true, Type="Logical", IsParameterQueryRequired=true]

// MaxDepth
2 meta [IsParameterQuery=true, List={0, 4, 10, 1, 2}, DefaultValue=4, Type="Any", IsParameterQueryRequired=true]

// Files-Filter NotBuffer
let
    Config = [
        IgnoreRecycle = true,
        FilterPrefix = {
            "c:\AI_RecycleBin", "c:\$Recycle.Bin"
        },
        FilterDistinct = FilterDistinct, //true,
        MaxDepth = MaxDepth,
        FinalSelectCols = {"Name", "Extension", "Attributes BitFlag", "Date modified", "Folder Path", "Depth"}
    ],
       /*
    For a list of values, test any combination of: Text.StartsWith, Text.Contains, Text.EndsWith
    one or more matches returns true

    future:
        List.Generate/Accumulate to stop calls when one is already true
    */
    Text.AnyMatches = (
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
            boolShouldFilter,

    // builds a single row for this query
    Calculate_AttributesQuery =
        (row as record) as any =>
            let
                // single_file = Source{[Name = "special_hidden"]},
                single_file = row,
                attrs = single_file[Attributes],
                single_table = Record.ToTable(attrs),

                filter_enabled =
                    Table.SelectRows( single_table,
                        each ([Value] = true) ),

                enabled_typed =
                    Table.TransformColumnTypes(
                        filter_enabled, { { "Value", type logical } } ),

                enabled_values =
                    Table.NestedJoin( enabled_typed,
                    {"Name"}, Enum_FileAttribute,
                    {"Name"}, "Enum_FileAttribute", JoinKind.LeftOuter ),

                #"Expanded Enum_FileAttribute" =
                    Table.ExpandTableColumn(
                        enabled_values, "Enum_FileAttribute",
                        {"Value"}, {"Value.1"} ),

                #"Renamed Columns" =
                    Table.RenameColumns(
                        #"Expanded Enum_FileAttribute",
                        { { "Value.1", "IntValue" } }
                    ),
                combinedBitFlag = Sum_BitFlags(#"Renamed Columns"[IntValue])
                /*
                FinalBitflag =
                    List.Accumulate(
                        #"Renamed Columns"[IntValue],
                        0,
                        (state, current) => Number.BitwiseOr(state, current)
                    ),
                // withType = Value.ReplaceType(FinalBitflag, Int64.Type)
                withType = Int64.From( FinalBitflag ) // actually need to ascribe function?
                */
            in
                combinedBitFlag,

    SourceList = Text.Split(RootDirectoryList, ";"),
    queryDirs = List.Transform( SourceList, each Folder.Contents( _ )),
    root = Table.Combine( queryDirs ),


                // Folder.Files(RootDirectory),
        // Folder.Files("c:\")



    // works when set
    /*
    col_depth = if Config[MaxDepth] = 0
        then root
        else  Table.AddColumn(
            root, "Depth",
            (row) => List.Count( Text.PositionOf( row[Folder Path], "\", Occurrence.All, Comparer.OrdinalIgnoreCase) ),
            Int64.Type
        ),
    */
    col_depth = Table.AddColumn(
        root, "Depth",
        (row) => List.Count(
            Text.PositionOf(
                row[Folder Path], "\",
                Occurrence.All, Comparer.OrdinalIgnoreCase)
        ),
        Int64.Type
    ),
    filter_depth
        = if MaxDepth = 0
        then col_depth
        else Table.SelectRows(
            col_depth, (row) => row[Depth] <= MaxDepth ),


    filter_recycle = Table.SelectRows(
        Table.Buffer( filter_depth ),
        each Text.AnyMatches( [Folder Path], Config[FilterPrefix] )
        // each not Text.Contains( [Folder Path], "Recycle.Bin", Comparer.OrdinalIgnoreCase )
    ),

    #"Added CustomHardCoded" = Table.AddColumn(filter_recycle, "Attributes BitFlag", each Calculate_AttributesQuery( _ ), Int64.Type),
    // works when set

    #"Added Custom" = Table.AddColumn(root, "Attributes BitFlag", each Calculate_AttributesQuery( _ )),
    final_typed = #"Added CustomHardCoded",
    #"Removed Other Columns" = Table.SelectColumns(
        final_typed, Config[FinalSelectCols] ),

    only_errors = Table.SelectRowsWithErrors( #"Removed Other Columns" ),
    // only_errors2 = Table.SelectRowsWithErrors( #"Removed Other Columns" )[Attributes BitFlag],
    selectFinalCols = Table.RemoveRowsWithErrors( #"Removed Other Columns" ),
    maybe_distinct = if Config[FilterDistinct] then Table.Distinct( selectFinalCols, {"Attributes BitFlag"}) else selectFinalCols,
    Custom1 = if LimitTopN = 0 then Table.FirstN( maybe_distinct , LimitTopN ) else maybe_distinct
in
    Custom1

// RootDirectoryList
"c:\nin_temp;G:\2021-github-downloads;c:\;c:\windows;c:\nin_temp" meta [IsParameterQuery=true, List={"c:\", "j:\", "c:\nin_temp", "c:\;c:\nin_temp", "G:\2021-github-downloads", "c:\nin_temp;G:\2021-github-downloads", "c:\nin_temp;G:\2021-github-downloads;c:\;c:\windows;c:\nin_temp"}, DefaultValue="G:\2021-github-downloads", Type="Text", IsParameterQueryRequired=true]

// LimitTopN
"2000" meta [IsParameterQuery=true, List={0, 2000, 6000, 10000}, DefaultValue="2000", Type="Text", IsParameterQueryRequired=true]

// Test_BitFlag
let
// / minimal wrapper, shows how to test one flag
    Test_BitFlag = (source as number, flag as number) =>
        Number.BitwiseOr( source, flag )
in
    Test_BitFlag

// __Text_AnyMatches
let
   /*
    For a list of values, test any combination of: Text.StartsWith, Text.Contains, Text.EndsWith
    one or more matches returns true

    future:
        List.Generate/Accumulate to stop calls when one is already true
    */
    __Text_AnyMatches = (
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
    __Text_AnyMatches

// Files_without_buffer
let
    Config = [
        IgnoreRecycle = true,
        FilterPrefix = {
            "c:\AI_RecycleBin", "c:\$Recycle.Bin"
        },
        FilterDistinct = FilterDistinct, //true,
        MaxDepth = MaxDepth,
        FinalSelectCols = {"Name", "Extension", "Attributes BitFlag", "Date modified", "Folder Path", "Depth"}
    ],
       /*
    For a list of values, test any combination of: Text.StartsWith, Text.Contains, Text.EndsWith
    one or more matches returns true

    future:
        List.Generate/Accumulate to stop calls when one is already true
    */
    Text.AnyMatches = (
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
            boolShouldFilter,

    // builds a single row for this query
    Calculate_AttributesQuery =
        (row as record) as any =>
            let
                // single_file = Source{[Name = "special_hidden"]},
                single_file = row,
                attrs = single_file[Attributes],
                single_table = Record.ToTable(attrs),

                filter_enabled =
                    Table.SelectRows( single_table,
                        each ([Value] = true) ),

                enabled_typed =
                    Table.TransformColumnTypes(
                        filter_enabled, { { "Value", type logical } } ),

                enabled_values =
                    Table.NestedJoin( enabled_typed,
                    {"Name"}, Enum_FileAttribute,
                    {"Name"}, "Enum_FileAttribute", JoinKind.LeftOuter ),

                #"Expanded Enum_FileAttribute" =
                    Table.ExpandTableColumn(
                        enabled_values, "Enum_FileAttribute",
                        {"Value"}, {"Value.1"} ),

                #"Renamed Columns" =
                    Table.RenameColumns(
                        #"Expanded Enum_FileAttribute",
                        { { "Value.1", "IntValue" } }
                    ),
                combinedBitFlag = Sum_BitFlags(#"Renamed Columns"[IntValue])
                /*
                FinalBitflag =
                    List.Accumulate(
                        #"Renamed Columns"[IntValue],
                        0,
                        (state, current) => Number.BitwiseOr(state, current)
                    ),
                // withType = Value.ReplaceType(FinalBitflag, Int64.Type)
                withType = Int64.From( FinalBitflag ) // actually need to ascribe function?
                */
            in
                combinedBitFlag,

    SourceList = Text.Split(RootDirectoryList, ";"),
    queryDirs = List.Transform( SourceList, each Folder.Files( _ )),
    root = Table.Combine( queryDirs ),


                // Folder.Files(RootDirectory),
        // Folder.Files("c:\")



    // works when set
    /*
    col_depth = if Config[MaxDepth] = 0
        then root
        else  Table.AddColumn(
            root, "Depth",
            (row) => List.Count( Text.PositionOf( row[Folder Path], "\", Occurrence.All, Comparer.OrdinalIgnoreCase) ),
            Int64.Type
        ),
    */
    col_depth = Table.AddColumn(
        root, "Depth",
        (row) => List.Count(
            Text.PositionOf(
                row[Folder Path], "\",
                Occurrence.All, Comparer.OrdinalIgnoreCase)
        ),
        Int64.Type
    ),
    filter_depth
        = if MaxDepth = 0
        then col_depth
        else Table.SelectRows(
            col_depth, each [Depth] <= [Depth]),


    filter_recycle = try Table.SelectRows(
        filter_depth,
        each Text.AnyMatches( [Folder Path], Config[FilterPrefix] )
        // each not Text.Contains( [Folder Path], "Recycle.Bin", Comparer.OrdinalIgnoreCase )
    ),

    #"Added CustomHardCoded" = Table.AddColumn(filter_recycle, "Attributes BitFlag", each Calculate_AttributesQuery( _ ), Int64.Type),
    // works when set

    #"Added Custom" = Table.AddColumn(root, "Attributes BitFlag", each Calculate_AttributesQuery( _ )),
    final_typed = #"Added CustomHardCoded",
    #"Removed Other Columns" = Table.SelectColumns(
        final_typed, Config[FinalSelectCols] ),

    only_errors = Table.SelectRowsWithErrors( #"Removed Other Columns" ),
    // only_errors2 = Table.SelectRowsWithErrors( #"Removed Other Columns" )[Attributes BitFlag],
    selectFinalCols = Table.RemoveRowsWithErrors( #"Removed Other Columns" ),
    maybe_distinct = if Config[FilterDistinct] then Table.Distinct( selectFinalCols, {"Attributes BitFlag"}) else selectFinalCols,
    Custom1 = if LimitTopN = 0 then Table.FirstN( maybe_distinct , LimitTopN ) else maybe_distinct
in
    Custom1

// Files
let
    Config = [
        IgnoreRecycle = true,
        FilterPrefix = {
            "c:\AI_RecycleBin", "c:\$Recycle.Bin"
        },
        FilterDistinct = FilterDistinct, //true,
        MaxDepth = MaxDepth,
        FinalSelectCols = {"Name", "Extension", "Attributes BitFlag", "Date modified", "Folder Path", "Depth"}
    ],
       /*
    For a list of values, test any combination of: Text.StartsWith, Text.Contains, Text.EndsWith
    one or more matches returns true

    future:
        List.Generate/Accumulate to stop calls when one is already true
    */
    Text.AnyMatches = (
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
            boolShouldFilter,

    // builds a single row for this query
    Calculate_AttributesQuery =
        (row as record) as any =>
            let
                // single_file = Source{[Name = "special_hidden"]},
                single_file = row,
                attrs = single_file[Attributes],
                single_table = Record.ToTable(attrs),

                filter_enabled =
                    Table.SelectRows( single_table,
                        each ([Value] = true) ),

                enabled_typed =
                    Table.TransformColumnTypes(
                        filter_enabled, { { "Value", type logical } } ),

                enabled_values =
                    Table.NestedJoin( enabled_typed,
                    {"Name"}, Enum_FileAttribute,
                    {"Name"}, "Enum_FileAttribute", JoinKind.LeftOuter ),

                #"Expanded Enum_FileAttribute" =
                    Table.ExpandTableColumn(
                        enabled_values, "Enum_FileAttribute",
                        {"Value"}, {"Value.1"} ),

                #"Renamed Columns" =
                    Table.RenameColumns(
                        #"Expanded Enum_FileAttribute",
                        { { "Value.1", "IntValue" } }
                    ),

                FinalBitflag =
                    List.Accumulate(
                        #"Renamed Columns"[IntValue],
                        0,
                        (state, current) => Number.BitwiseOr(state, current)
                    ),
                // withType = Value.ReplaceType(FinalBitflag, Int64.Type)
                withType = Int64.From( FinalBitflag ), // actually need to ascribe function?


                combinedBitFlag = Sum_BitFlags(#"Renamed Columns"[IntValue])
            in
                FinalBitflag,

    SourceList = Text.Split(RootDirectoryList, ";"),
    queryDirs = List.Transform( SourceList, each Folder.Contents( _ )),
    root = Table.Combine( queryDirs ),

     col_depth = Table.AddColumn(
        root, "Depth",
        (row) => List.Count(
            Text.PositionOf(
                row[Folder Path], "\",
                Occurrence.All, Comparer.OrdinalIgnoreCase)
        ),
        Int64.Type
    ),
    filter_depth
        = if MaxDepth = 0
        then col_depth
        else Table.SelectRows(
            col_depth, each [Depth] <= MaxDepth),


    #"Added CustomHardCoded" = Table.AddColumn(
        filter_depth, "Attributes BitFlag",
        // each Calculate_AttributesQuery( _ ), Int64.Type)
        (_) as number => Calculate_AttributesQuery( _ )),

    // works when set
    final_typed = #"Added CustomHardCoded",
    top2000 = Table.FirstN( final_typed, 2000  ),
    #"Reordered Columns" = Table.ReorderColumns(top2000,{"Date modified", "Folder Path", "Attributes BitFlag", "Content", "Name", "Extension", "Date accessed", "Date created", "Attributes"})
in
    #"Reordered Columns"

// bytes_to_numbers
let
    /* go from int -> binarystr, and back */

    listIpDec = {192, 168, 5, 85},
    nums = [
        a = Byte.From( listIpDec{0} ),
        b = Byte.From( listIpDec{1} ),
        c = Byte.From( listIpDec{2} ),
        d = Byte.From( listIpDec{3} )
    ],


    // both work
    byteStringIp = #binary(listIpDec),
    byteStringIpFromList = Binary.FromList(listIpDec),

    // bytes to 32bit int
    UInt32 = BinaryFormat.UnsignedInteger32( byteStringIp ),

    // FailByteRead = Int32.From(byteStringIp, null, RoundingMode.Down),
    // fromfromint = Byte.From(binUint32) //Binary.From(binUint32)
    // ,
    // t = byteStringIpFromList( fromfromint ),

    // binary to list of integers
    ListFormatByteString = BinaryFormat.List(BinaryFormat.Byte),
    listIntFromByteString = ListFormatByteString( byteStringIp ),

    Summary = [
        listIpDec = List_ToText( listIpDec ),
        //  z = #binary(binUint32),
        byteStringIp = byteStringIp,
        ListFormatByteString = ListFormatByteString,
        listIntFromByteString = List_ToText( listIntFromByteString ),
        UInt32 = UInt32
        // nums = nums
        // same = listIntFromByteString = nums
    ]
in
    Summary

// Test type ascribe on List number
let
    listNum = {1, 2, 3},
    listMixed= {1, "foo", 3.4},
    typeNumberList = type { number },
    typeAnyList = type { any },
    typeRecordList = type { record },

    // isSameObj = Value.Is(listObj, listType),
    Results = [
        listNum = listNum,
        value_listNum = ListAsText( listNum ),
        typeNumberList = typeNumberList,
        numIsNumberList = Value.Is( listNum, typeNumberList  ),

        listMixed = listMixed,
        value_listMixed = ListAsText( listMixed ),
        typeAnyList = typeAnyList,
        mixedIsTest = [
            IsAnyList = Value.Is( listMixed, typeAnyList ),

            IsNumberList = Value.Is( listMixed, typeNumberList ),  // does this mean type {number} is ascribed, not tested like primatives?
            IsRecordList = Value.Is( listMixed, typeRecordList )
        ]


    ]
in
    Results

// ListAsText
/*
from: https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244

Note:
    The original serializes **everything**
    This only shows type names as text

*/
let

    /* Optional parameter: Is this being used as part of a function signature? */
    Serialize.List =  (x) => "{" &
        List.Accumulate(x, "",
            (seed,item) =>
                if seed="" then Text.From(item)
                else seed & ", " & Text.From(item)) &
            "} "
in
    Serialize.List