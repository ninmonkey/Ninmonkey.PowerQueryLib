let
    mapping = [
        Join-String = Text.Combine,
        t = Value.Type,
        mdt = Inspect.Meta,
        // value.me = Value,


        // random = {
        //     ..,... /// list of all funcs related to random
        // },
        // findFunc = ...,  // filter functions in current session with pattern

        // fmt_Hex = Number_ToHexString


    ] meta [
        pqLibAlias = "Inspect.MetaOfType",
        IsAlias = true
    ]
in
    mapping
