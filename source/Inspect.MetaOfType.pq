let
    // Inspect type
    FuncDef = (x as any) as record =>
        let
            t = Value.Type(x),
            md = Value.Metadata(x),
            mdt = Value.Metadata( Value.Type(x) )
        in
            [
                TypeName = Type.ToText( t ),
                Type = t, Metadata = md, TypeMetadata = mdt
            ],

    // Inspect type
    FuncType = type function (input as any) as record
        meta [
            Documentation.Name = "Metadata of Type",
            Documentation.LongDescription = "Sugar for the Metadata of an object's type",
            Documentation.Examples = {
                [
                    Description = "Type of a function",
                    Code = "Record.FieldNames( Inspect.MetaOfType( BinaryEncoding.Base64 ) )",
                    Result = "{ ""Documentation.Name"", ""Documentation.Description"", ""Documentation.LongDescription"", ""Documentation.Category"", ""Documentation.Examples"" }"
                ]
            }
        ],
    // enableTesting = false,
    // testResults = Record.FieldNames(Inspect.MetaOfType(BinaryEncoding.Base64)),
    Inspect.MetaOfType = Value.ReplaceType(FuncDef, FuncType)
in
    Inspect.MetaOfType