let
    /*
        in:  { "a", 2, #date(2023,1,4) },
        out: "{ a, 2, 2023-01-04 }"
    */
    Text.FormatList = (source as list) as text => [
        Config = [
            BracePrefix = "{ ",
            BraceSuffix = " }",
            Separator = ", ",
            OuterSeparator = ""
        ],
        str_list = List.Transform( source, each Text.From(_) ),
        ret = Text.Combine( {
            Config[BracePrefix],
            Text.Combine( str_list, Config[Separator] ),
            Config[BraceSuffix]
        },  Config[OuterSeparator] )
    ][ret]

in
    Text.FormatList