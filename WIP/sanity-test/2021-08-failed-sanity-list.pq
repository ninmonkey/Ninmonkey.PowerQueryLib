// Unicode Range Map
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("fVLbbsIgGH4V0uu5gLpNL9XanTRpsmw3xgu0P0pEaJDO7u33Q3HVbbEJhfQ7QlkskonRzhpFJqaA5CahftRM4JQsb1o4l2tXWTgEuNunNC56njlWZr0L9DmvyQdXVbCqoxkV+JwMU1DgPMy6Dz/vJurlFVvsS+7kSirpvshzAWZjebltYsUwxgre+o2sNcemDBvGVkxctnKGrCzwHX7sdPu3/d6dV0eDJ7nZkrcKbTbcAcm5tMFlEMOKVRs2M8e/1HQSmGmWZSdebuWnZ7wfgIwwmeSKayDM52aUBj7SsxTnAF1V3ftzolHGaNQFyXie43LaQGIQmraGv/7t2aZneMi6w3AzZalgD9pd4ikIXin3j4hMawe6gKIzuoqOL9FH0GA53qNK40VCqtFnhOU3", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Label = _t, #"First Codepoint" = _t, #"Last Codepoint" = _t, #"Range Type" = _t]),

    // load and transform is about it
    try_transform = Table.TransformColumns(
        Source,
        {
            {"First Codepoint", (_) as number => Number_FromHexText( _ ), Int64.Type },
            {"Last Codepoint", (_) as number => Number_FromHexText( _ ), Int64.Type }
        }
    ),
    #"Removed Errors" = Table.RemoveRowsWithErrors(try_transform, {"First Codepoint"})
in
    #"Removed Errors"

// Number_FromHexText
let
    enableTest = false,
    Number.FromHexText = (source as any)
    // as number =>
    as any => // only set to 'any' for debugging
        /*
        input:      0x1f, ff
        Output:     31, 255

        returns: Int64
        converts text to numbers, as Hex / base-16 format
        */
        let
            hasPrefix = Text.StartsWith(source, prefix, Comparer.OrdinalIgnoreCase),
            prefix = "0x",
            expression_string = if hasPrefix then source else prefix & source,
            maybeInt = Expression.Evaluate( expression_string ),
            typed_num = Int64.From( maybeInt ),
            result = try Expression.Evaluate(expression_string)
        in
            if result[HasError] then result[Error] else result[Value],

    testCase = {
        [ Input = "-24.435", Expect = "throw" ],
        [ Input = "-24", Expect = -0x24 ],
        [ Input = "24", Expect = 0x24 ],
        [ Input = "0x10ffff", Expect = 0x10ffff ]
    },
    testTable = Table.FromRecords( testCase, type table[ Input = any, Expect = any], MissingField.Error ),
    testTable2 = Table.AddColumn(
        testTable,
        "Result",
        each Number.FromHexText( _ ),
        type any
    ),
    testTable3 = Table.AddColumn(
        table2,
        "Exactly Equal",
        (_) as logical =>
            _[Input] = _[Expect],
       Logical.Type
    ),
    Final = if enableTest then testTable3 else Number.FromHexText
in
    Final

// Sanity test - not working (2)
let
    Source = #"Unicode Range Map",
    old_ValidateDistinct = (targets as list) as any =>
        let
            testItems = List.Transform(
                targets,
                (target as record)  =>
                    [
                        Okay = true,
                        IsDistinct = try Table.IsDistinct(target[Table], target[Columns])
                    ]
            ),
            Final = try testItems
            //                 (target as record) as list =>
            //         [
            //             Columns = target[Columns],
            //             source = target[Note],
            //             IsDistinct = Table.IsDistinct( target[Table], target[Columns] )
            //         ]
            // ),
            // target
            // isDistinct_Labels = Table.IsDistinct( Source, {"Label"} ),
        in
            Final,
    ValidateDistinct = (targets as list) as any =>
        let
            testItems = List.Transform(
                targets,
                (target as record)  =>
                    [
                        Time = DateTime.LocalNow(),
                        IsDistinct = Table.IsDistinct(
                            target[Table],
                            target[Columns]
                        )
                    ]
            ),
            Final = testItems
            //                 (target as record) as list =>
            //         [
            //             Columns = target[Columns],
            //             source = target[Note],
            //             IsDistinct = Table.IsDistinct( target[Table], target[Columns] )
            //         ]
            // ),
            // target
            // isDistinct_Labels = Table.IsDistinct( Source, {"Label"} ),
        in
            Final,
    targets = {
        [
            Table = #"Config My Colors",
            Columns = {"Color Name"}
        ],
        [
            Table = ColorMapping,
            Columns = {"Color Name"}
        ],
        [
            Table = Source,
            Columns = {"Label"}

        ]
    },
    testRunnerResult = ValidateDistinct(
        {
            [
                Source =  Source,
                Columns = {"Label"}
            ]
        }),
    testRunnerResult1 = testRunnerResult{0},
    IsDistinct = (try testRunnerResult1[IsDistinct]),
    Error = IsDistinct[Error],
    Detail = Error[Detail],
    Source1 = Detail[Source]
in
    Source1

// Config My Colors
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("bYyxCsJAEAV/5dg6KfIJJkqaFILlkeLwniJsdsOxS/TvPWNhYzszTIw0qFhRDoNmUEMvMOtGcxNpSvaQtgsXX1fGArHqe3bs9ohbcv6gXxxOT4Nk5PZQeUH+p/qqtCS5fz8jBCVxOLtczWuqsj/nNw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Color Name" = _t, #"Color Value" = _t]),
    #"My Colors" = Source,

    #"Added Index" = Table.AddIndexColumn(#"My Colors", "Color Index", 0, 1, Int64.Type),
    #"Renamed Columns" = Table.RenameColumns(#"Added Index",{{"Color Index", "MyColor Index"}})
in
    #"Renamed Columns"

// ColorMapping
let
    usingInnerJoin = false,
    Source = #"Config My Colors",
    OtherMap = #"Unicode Range Map",
    // actual Table.Join

    innerJoin = Table.Join( #"Config My Colors", "Color Name", OtherMap, "Label", JoinKind.Inner, null ),
    fullOuterJoin = Table.Join( #"Config My Colors", "Color Name", OtherMap, "Label", JoinKind.FullOuter, null ),
    Selected = if usingInnerJoin then innerJoin else fullOuterJoin,
    c_Index = Table.AddIndexColumn( Selected , "ColorMap Index", 0, 1, Int64.Type)
in
    c_Index