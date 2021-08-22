let
    List_ContiguousDates = (source as list) as table =>
        /*
        input:
            table with a [Date] column
        output:
            table of continuous [Date]s
        future:
            auto detect if arg is a table or a list
        */
        let
            first = List.Min(source), //Table.Min(source, {"Date"})[Date],
            last = List.Max(source),  //Table.Max(source, {"Date"})[Date],
            days = { Number.From(first)..Number.From(last) },
            baseDates = List.Transform( days, each Date.From(_) ),
            FinalTable = Table.FromList(
                baseDates, Splitter.SplitByNothing(), type table[Date = date], null, ExtraValues.Error
            )
        in
            FinalTable,

    testing = false,
    test = List_ContiguousDates( Rations[Date] ),
    test2 =
        let
            sample = {
                #date(2010,1,9), #date(2010,1,3), #date(2010,1,5)
            },
            result = List_ContiguousDates(sample)
        in
            result,

    FinalStep =
        if testing then test else List_ContiguousDates

in
    FinalStep