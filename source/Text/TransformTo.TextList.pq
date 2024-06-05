let
    // in:  List type { any }
    // out: List type { text }
    TransformTo.TextList = (
        source           as list,
        optional culture as nullable text

    ) as list => [
        return =
            List.Transform(
                source,
                each Text.From(_, culture ?? null ) )

    ][return]

in
    TransformTo.TextList
