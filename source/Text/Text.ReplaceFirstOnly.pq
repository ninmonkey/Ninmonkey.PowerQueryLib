let
    // Like Text.Replace except that this replaces at most one single occurrence of oldValue
    Text.ReplaceFirstOnly = (
        source   as nullable text,
        oldValue as text,
        newValue as text
    ) as nullable text => [

        found = Text.PositionOf( source, oldValue,
            Occurrence.First, Comparer.OrdinalIgnoreCase ),

        replaced = Text.ReplaceRange(
            source, found,
            Text.Length( oldValue ),
            newValue
        ),

        return   =
            if source     = null then null
            else if found = -1   then source
                                 else replaced

    ][return]
in
    Text.ReplaceFirstOnly
