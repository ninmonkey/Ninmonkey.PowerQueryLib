let
    // mainly for interactive use when debugging
    // long name: Text.Contains.CaseInsensitiveMatch
    Text.Contains.CI = (source as text, substring as text) as logical =>
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase )
in
    Text.Contains.CI