let
    EnableTests = true,
     // table
    ins = InspectObject,
    InspectObject = (source as any, optional options as nullable record) as any =>
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


    test = InspectObject( {"a".."4"}),
    test2 = InspectObject( Rations ),
    test3 = InspectObject( GenerateDocs_OnAlgoType ),

    target = JoinAlgorithm.Type,
    target2 = DirectQueryCapabilities.From,

    // q = Value.Compare()

    Value.Compare // type: comparisonCriteria
    equationCriteria // type: equationCriteria

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

    final = if EnableTests then test_results else InspectObject
in
    final