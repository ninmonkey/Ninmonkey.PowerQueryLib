let
    // sugar when experimenting
    CiMatch = ( source as text, pattern as text ) as logical =>
        Text.Contains( source , pattern, Comparer.OrdinalIgnoreCase )
in
    CiMatch
