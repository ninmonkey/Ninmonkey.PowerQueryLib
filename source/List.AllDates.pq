let
    List.AllDates_Impl = (source as list) as table =>
        /*
        Generate all dates between 2 or more dates. (order does not matter)
            rewrite/rename: 'List.ContinuousDates.pq'
            Source: <https://github.com/ninmonkey/Ninmonkey.PowerQueryLib/blob/master/source/List.ContinuousDates.pq>
        input:
            a list or table table column of dates
        output:
            table of continuous [Date]s., for a Date table
        future:
            auto detect if arg is a table or a list
        */
        let
            // source = List.Buffer(source), // maybe?

            // future: assert compat with dates,
            validArgs = source is list and first is date and last is date,
            first = List.Min(source) as date,
            last =  List.Max(source) as date,
            days =  { Number.From(first)..Number.From(last) },
            extra = [ ValidArgs = validArgs, first = first, last  = last, days = days ],

            Datefrom = DateTime.Date()
        in
            extra,
            // a


    //     let
    //         first = List.Min(source),
    //         last =  List.Max(source),
    //         days =  { Number.From(first)..Number.From(last) },

    //         baseDates = List.Transform(
    //             days, each Date.From(_) ),

    //         FinalTable = Table.FromList(
    //             baseDates, Splitter.SplitByNothing(),
    //             type table[Date = date], null, ExtraValues.Error
    //         )
    //     in
    //         FinalTable,

    // show_example = false,
    // example =
    //     let
    //         sample = { #date(2010,1,9), #date(2010,1,3), #date(2010,1,5) },
    //         result = List.AllDates_Impl(sample)
    //     in
    //         result,

    // FinalResult =
    //     if show_example then example else List.AllDates_Impl

in
    FinalResult