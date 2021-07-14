let
    transformChar = (char as text) => [
        Codepoint = Character.ToNumber(char),
        Text = char
    ],

    transformString = (source as text) as list =>
        // list codepoints
        let
            charList = Text.ToList(source),
            codepoints = List.Transform(
                charList,
                (char as text) as record => transformChar(char)
            )
        in
            codepoints,

    inspectText = (source as text) as table =>
        let
            charRecords = transformString(source),
            t = Table.FromRecords(
                charRecords,
                type table[Codepoint = number, Text = text],
                MissingField.Error
            )
        in
            t,


    example = inspectText("  Foo, #(tab)bar#(cr,lf).")

in
    example