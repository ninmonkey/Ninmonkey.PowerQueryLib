let
    // in:  List { any }
    // out: List { text }
    TransformTo.TextList = (
        source as list,
        optional culture as nullable text
    ) as list => [
        ret = List.Transform( source, each Text.From(_, culture ?? null ))
    ][ret]

in
    TransformTo.TextList
    