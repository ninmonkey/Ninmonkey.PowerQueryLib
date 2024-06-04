let
    // long name: Text.Contains.CaseInsensitiveMatch
    // mainly for interactive use when debugging
    Text.EndsWith.CI = (source as text, substring as text) as logical =>
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
        // Text.Contains( source, substring, Comparer.OrdinalIgnoreCase )
        // if Text.EndsWith( imageUrl, ".png", Comparer.OrdinalIgnoreCase ) then
        Text.EndsWith( source, substring, Comparer.OrdinalIgnoreCase )
in
    Text.EndsWith.CI