let
    /*  Build a bunch of random numbers with different rounding modes to compare distribution statistics. */
    Rand.Int64 = (min as number, max as number, optional roundingMode as number ) =>
        Int64.From(
            Number.RandomBetween( min, max ),
                "en-us",
                roundingMode ?? RoundingMode.TowardZero
            ),

    /* a macro to convert to table */
    TestOne = (items as list, optional label as text) as table => [
        asTable   = Table.FromList(items, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        with_type = Table.TransformColumnTypes( asTable , { { "Column1", Int64.Type } }),
        ret       = Table.RenameColumns( with_type, { {"Column1", label ?? "Column1"} }, MissingField.Error )
    ][ret],

    Oracle = (obj as any) as text => Text.FromBinary( Json.FromValue(obj) ),

    names    = List.Buffer( {0..1000} ),
    maxIndex = List.Count( names ) - 1,

    // build tables
    many_up   = List.Transform( names, each Rand.Int64( 0, maxIndex, RoundingMode.Up )  ),
    many_down = List.Transform( names, each Rand.Int64( 0, maxIndex, RoundingMode.Down )  ),

    many_to0    = List.Transform( names, each Rand.Int64( 0, maxIndex, RoundingMode.TowardZero )  ),
    many_away0  = List.Transform( names, each Rand.Int64( 0, maxIndex, RoundingMode.AwayFromZero )  ),
    many_toeven = List.Transform( names, each Rand.Int64( 0, maxIndex, RoundingMode.ToEven )  ),

    // drill down into one, then check column metrics
    summary = [
        Up           = TestOne( many_up, "Up" ),
        Down         = TestOne( many_down, "Down" ),
        TowardZero   = TestOne( many_to0, "TowardZero" ),
        AwayFromZero = TestOne( many_away0, "AwayFromZero" ),
        ToEven       = TestOne( many_toeven, "ToEven" )
    ]
in
    summary
