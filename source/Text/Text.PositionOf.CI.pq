let
    // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
    Text.PositionOf.CI = (
        source           as text,
        substring        as text,
        optional options as nullable record
    ) as any => [

            occurrence = options[Occurrence]? ?? Occurrence.First,
            comparer   = options[Comparer]?   ?? Comparer.OrdinalIgnoreCase,
            return     = Text.PositionOf( source, substring, occurrence, comparer )

        ][ return ]

in
    Text.PositionOf.CI