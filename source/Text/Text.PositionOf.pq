let Text.PositionOf.CI = (source as text, substring as text, optional options as nullable record) as any => [
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
            occurrence = options[Occurrence]? ?? Occurrence.First,
            comparer = options[Comparer]? ?? Comparer.OrdinalIgnoreCase,
            ret = Text.PositionOf( source, substring, occurrence, comparer )
        ][ret]
in Text.PositionOf.CI