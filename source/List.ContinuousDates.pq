let
    List.ContinuousDates = (source as list) as table =>
        /*
        Generate all dates for a date table
            Source: <https://github.com/ninmonkey/Ninmonkey.PowerQueryLib/blob/master/source/List.ContinuousDates.pq>
        input:
            a list or table table column of dates
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
            result = List.ContinuousDates(sample)
        in
            result,

    FinalResult =
        if show_example then example else List.ContinuousDates

in
    FinalResult