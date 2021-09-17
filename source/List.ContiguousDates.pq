let
    List_ContiguousDates = (source as list) as table =>
        /*
        Generate all dates for a date table

        input:
            a list or table table column that contains [type date]
        output:
            table of continuous [Date]s., for a Date table
        future:
            auto detect if arg is a table or a list
        */
        let
            first = List.Min(source),
            last =  List.Max(source),
            days =  { Number.From(first)..Number.From(last) },

            baseDates = List.Transform(
                days, each Date.From(_) ),

            FinalTable = Table.FromList(
                baseDates, Splitter.SplitByNothing(),
                type table[Date = date], null, ExtraValues.Error
            )
        in
            FinalTable,

    show_example = false,
    example =
        let
            sample = { #date(2010,1,9), #date(2010,1,3), #date(2010,1,5) },
            result = List_ContiguousDates(sample)
        in
            result,

    FinalResult =
        if show_example then example else List_ContiguousDates

in
    FinalResult