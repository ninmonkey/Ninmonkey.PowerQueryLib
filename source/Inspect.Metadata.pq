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