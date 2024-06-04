let
    Text.MatchesAnyOf.CI = (sourceList as text, patternList as list) as logical => [
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
        // todo: validate, add tests
        return = List.Select(
            sourceList,
            (source) => List.AnyTrue(
                List.Transform( patternList, (pattern) => Text.Contains.CI( source, pattern ) )
            )
        )
            // List.Contains( patternList, item, Comparer.OrdinalIgnoreCase ))


        // return = List.Select( sourceList, (item) =>
            // List.Select(
            //     sourceList, (item) =>
            //         List.AnyTrue(
            //             List.Transform(
            //                 patternList,
            //                 (pattern) => Text.Contains( item, pattern, Comparer.OrdinalIgnoreCase ) ) ) ).AnyTrue( List.Transform( patternList, )

    ][return]
in
    Text.MatchesAnyOf.CI