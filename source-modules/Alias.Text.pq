[
    FmtList              = Text.FormatList meta [ AliasTo = "Text.FormatList", NinLibType = "Alias" ],
    Csv                  = Text.FormatCsv,
    Format.Csv           = Csv,
    Fmt.Csv              = Csv,
    TransformTo.TextList = List.TransformTo.ListOfText

    /*
    old aliases I experimentede with:

        AsList.Text = AsTextList,
        AsList.OfText = TextList = AsTextList,
        To.TextList = Transform.TextList,
        AsTextList = As.TextList,
        To.TextList = As.TextList,


        in:  { "a", "b" }
        out: "a#(cr,lf)b"

    Format.JoinDocNewline = Format.JoinBR,

    Join.NewLine = Format.JoinNewLine,
    Join.NL      = Join.NewLine,
    FmtNL        = Join.NewLine,


    // # attributes could auto-strip these out based on a config value, that reads metadata
        ListOf.Text = TransformTo.TextList,
        As.TextList = ListOf.Text,
        // AsTextList         = ListOf.Text,
        // To.TextList        = ListOf.Text,
        // ToList.OfText      = ListOf.Text,
        AsList.OfText      = ListOf.Text,
        TextList           = ListOf.Text,
        Transform.TextList = ListOf.Text,
        // AsList.Text        = ListOf.Text,
    */
]