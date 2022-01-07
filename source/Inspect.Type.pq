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