let
    TextFromRecurse = (object as any) as text =>
        let
            scalar = if object is list
                then "{ " & Text.Combine(
                        List.Transform(
                            object,
                            // each "Item,"
                            each @TextFromRecurse(_)
                        ),
                        ", "
                    ) & "} "
                else object,

            output = Text.From(scalar)
        in
            output,

    CombineVararg =
        Function.From(
            type function() as list,
            each TextFromRecurse(_)
        ),

    results = [
        basic = CombineVararg("a", "b", 3, TextEncoding.Utf16),
        nested = CombineVararg("a", "b", 3, {3..6}),
        nested2 = CombineVararg(
            "a", "b",
            DateTime.LocalNow(),
            3, {3..6}
        )

    ]
in
    results