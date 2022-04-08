let
    enableTest = false,
    Percent_FromText_Wrapped = (source as text) as number =>
            // input: "(50.87%)"
            // output: Percentage.Type
        let
            trim_list = {"(", ")"},
            strip = Text.Trim(source, trim_list),
            perc = Percentage.From(strip)
        in
            perc,

    Percent_FromText_Division = (source as text) as number =>
            // input: "117/230"
            // output: Percentage.Type
        let
            crumbs = Text.Split(source, "/"),
            perc = Percentage.From(
                Number.From( crumbs{0} ) / Number.From( crumbs{1} )
            )
        in
            perc,
    Percentage_FromText = (source as text) as number =>
        /*
            input: "117/230"
            input: "(40.83%)"
        */
        let
            containsDivide = Text.Contains(source, "/"),
            result =
                if containsDivide then Percent_FromText_Division(source)
                else Percent_FromText_Wrapped(source)
        in
            result,

    tests = [
        fromParens = Percentage_FromText("(20.45%)"),
        fromDivide = Percentage_FromText("120/345")
    ],
    Final = if enableTest then tests else Percentage_FromText
in
    Final