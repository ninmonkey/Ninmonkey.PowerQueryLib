List.ContinuousDates =  [
    /*
    Generate all dates for a date table
        Source: <https://github.com/ninmonkey/Ninmonkey.PowerQueryLib/blob/master/source/List.ContinuousDates.pq>
    input:
        a list of dates        
    */
    List.ContinuousDates.Type = type function (source as list) as list meta [
        Documentation.Name = "List.ContinuousDates",
        Documentation.LongDescription = "Generate a continuous list of dates from a list of dates, useful for date tables",
        Documentation.Examples = {[
            Description = "Generate a continuous list of dates",
            Code = "List.ContinuousDates( { #date(2021, 1, 1), #date(2021, 1, 3)} )",
            Result = "Table.FromRecords({ [ Date = #date(2021, 1, 1)], [ Date = #date(2021, 1, 2)], [ Date = #date(2021, 1, 3)])"
        ]}
    ],
    List.ContinuousDates.Impl = (source as list) as list => let
        first = List.Min(source),
        last =  List.Max(source),
        days =  { Number.From(first)..Number.From(last) },

        baseDates = List.Transform(
            days, each Date.From(_) )
    in
        baseDates,
    return = Value.ReplaceType( List.ContinuousDates.Impl, List.ContinuousDates.Type )
][return],
