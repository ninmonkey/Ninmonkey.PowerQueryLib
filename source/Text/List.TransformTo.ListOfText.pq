let
    // in:  List { any }
    // out: List { text }
    List.TransformTo.ListOfText = (
        source as list,
        optional culture as nullable text
    ) as list => [
        ret = List.Transform( source, each Text.From(_, culture ?? null ))
    ][ret]

in
    List.TransformTo.ListOfText