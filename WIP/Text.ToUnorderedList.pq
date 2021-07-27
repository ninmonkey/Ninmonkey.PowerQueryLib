let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WKkmtKFGK1YlWysnMS1UwAjNz84tSFYpLStPSwFyv1OJipdhYAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Line = _t]),

    Str = [
        Bullet = "•",
        Newline = "#(cr,lf)"
    ],
    Text.ToUnorderedList = (source as list) as text =>
        let
            prefix = Str[Bullet] & " ",
            items = List.Transform(
                source,
                each Prefix & Text.From(_)
            )
            x = z
        in
            "final",
    #"transform text" = Table.TransformColumns(Source,{{
        "Line",
        each Str[Bullet] & " " &  _,
        type text}}
    ),

    MergedText = Text.Combine( #"transform text"[Line], Str[Newline] ),
    final = #"transform text"
    // #"transform text" = Table.TransformColumns(Source,{{"Line", Text.Trim, type text}})
in
    final