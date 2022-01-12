// t
let

    let
        // Inspect type
        FuncDef = (x as any) => Value.Type(x),
        // Inspect type
        FuncType = type function (input as any) as any
            meta [
                Documentation.Name = "Alias for Value.Type()",
                Documentation.LongDescription = "Alias for getting an object's type",
                Documentation.Examples = {
                    [
                        Description = "Type of a function",
                        Code = "Inspect.Type( Value.Type )",
                        Result = "function"
                    ]
                }
            ],
        enableTesting = false,
        testResults = Inspect.Type( Value.Type ),
        Inspect.Type = Value.ReplaceType(FuncDef, FuncType)
    in
        if not enableTesting then Inspect.Type else  testResults

    // md
    let
        // Inspect metadata
        FuncDef = (x as any) as any => Value.Metadata(x), // nullable record not guaranteed
        // Inspect metadata
        FuncType = type function (input as any) as any
            meta [
                Documentation.Name = "Alias for Value.Metadata(x)",
                Documentation.LongDescription = "Alias for getting an object's metadata"
                // Documentation.Examples = {
                //     [
                //         Description = "Metadata of object",
                //         Code = "Inspect.Type( Value.Type )",
                //         Result = "function"
                //     ]
                // }
            ],
        enableTesting = false,
        testResults = Inspect.Metadata( Value.Type ),
        Inspect.Metadata = Value.ReplaceType(FuncDef, FuncType)
    in
        if not enableTesting then Inspect.Metadata else  testResults

    // mdt
    let
        // Inspect type
        FuncDef = (x as any) as any =>
            Value.Metadata( Value.Type(x) ),
        // Inspect type
        FuncType = type function (input as any) as any
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
        enableTesting = false,
        testResults = Record.FieldNames(Inspect.MetaOfType(BinaryEncoding.Base64)),
        Inspect.MetaOfType = Value.ReplaceType(FuncDef, FuncType)
    in
        if not enableTesting then Inspect.MetaOfType else  testResults

    // ins
    let
        info = (o) as record => [ t = t(o) , md = md(o), mdt = mdt(o) ]
    in
        info
