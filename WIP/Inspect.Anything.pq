let
    EnableTests = false,
     // table
    ins = Inspect.Object,
    Inspect.Object = (source as any, optional options as nullable record) as any =>
        let
            simpleOutput = options[simpleOutput]? ?? false,
            // should I catch exception?
            results_basic = [
                Metadata = Value.Metadata( target ),
                Facets = Type.Facets( target )
            ],
            results_detailed = [
                ResourceExpression = Value.ResourceExpression( target ),
                DirectQueryCapabilities = DirectQueryCapabilities.From( target )
            ]
            // Record.Combine()
        in
            if simpleOutput then results_basic
            else Record.Combine(
                {results_basic, results_detailed}),


    // q = Value.Compare()
    targets = [
        JoinAlgorithm.Type = JoinAlgorithm.Type,
        DirectQueryCapabilities.From = DirectQueryCapabilities.From,
        Value.Compare = Value.Compare, // type: comparisonCriteria
        equate = "?" // type: equationCriteria
    ],

    test = Inspect.Object( {"a".."4"}),
    test2 = Inspect.Object( Rations ),
    test3 = Inspect.Object( GenerateDocs_OnAlgoType ),

    // target = targets{0},
    target = Rations,

    test_results = [
        Metadata = Value.Metadata( target ),
        ResourceExpression = Value.ResourceExpression( target ),
        DirectQueryCapabilities = DirectQueryCapabilities.From( target ),
        Facets = Type.Facets( target )
    ],

    samplesList = {
        RoundingMode.ToEven,
        RoundingMode.Type
    },
    samplesDict = [
        maybe1 = ins( JoinAlgorithm.Type, [simpleOutput = true]),
        maybe2 = ins( JoinAlgorithm.Type ),
        maybe3 = ins( test_results )
    ],



    tab2 = DirectQueryCapabilities.From( target ),

    final = if EnableTests then test_results else Inspect.Object
in
    final