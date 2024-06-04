let
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
