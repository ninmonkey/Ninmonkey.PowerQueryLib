let
    runTest = false,
    Logical_FromText_WR = (item as text) as logical =>
        // input: R => true
        // input: W => false
        if item = "R" then true else false,

    Logical_FromText_YN = (item as text) as logical =>
        // input: Y => true
        // input: any => false
        if item = "Y" then true else false,

    Logical_FromTextAny = (item as text) as logical =>
        let
            hasWR =
                List.AnyTrue(
                    {
                        Text.Contains(item, "R", Comparer.OrdinalIgnoreCase),
                        Text.Contains(item, "W", Comparer.OrdinalIgnoreCase)
                    }
                ),

            result =
                if hasWR then Logical_FromText_WR(item)
                else Logical_FromText_YN(item)
        in
            result,
    tests = [
        #"R should be True"      = Logical_FromText_WR("R"),
        #"W should be False"     = Logical_FromText_WR("W"),
        #"Y should be True"      = Logical_FromText_YN("Y"),
        #"other should be False" = Logical_FromText_YN(""),
        #"Auto R"                = Logical_FromTextAny("R"),
        #"Auto W"                = Logical_FromTextAny("W"),
        #"Auto Y"                = Logical_FromTextAny("Y"),
        #"Auto other"            = Logical_FromTextAny("")
    ],
    final =
        if runTest then tests
        else  Logical_FromTextAny
in
    final