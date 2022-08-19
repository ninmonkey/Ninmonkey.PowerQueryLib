let
    /*
    Input:
        Table with at least a [Date] column
    output:
        Adds columns for: [Year], [Month], [Day], [Week of Year], [Date Id] key

    future:
        optionally add time when datetime is the source

    */
    DateTable.FromDates_Impl = () =>
        error Error.Record("NYI", "First write ListAll.Dates.pq"),
    old_version_Date.TableFromDates = (source as table) as table =>
        let
            // isDatetime =  ..., // if datetime, or datetimezone,
            source =
                if Table.HasColumns( source, {"Date"} )
                then source
                    else error Error.Record(
                        "InvalidArgument", "Expects a table with a column named 'Date'", source
                    ),

            base =List.ContinuousDates( source[Date] ),
            col_Year = Table.AddColumn(base, "Year", (_) as number => Date.Year([Date]), Int64.Type),
            col_Month = Table.AddColumn(col_Year, "Month", (_) as number => Date.Month([Date]), Int64.Type),
            col_Day = Table.AddColumn(col_Month, "Day", (_) as number => Date.Day([Date]), Int64.Type),
            col_WeekOfYear = Table.AddColumn(col_Day, "Week of Year", (_) as number => Date.WeekOfYear([Date]), Int64.Type),
            col_Index = Table.AddIndexColumn(col_WeekOfYear, "Date Id", 0, 1, Int64.Type),
            verifyDistict = Table.IsDistinct(col_Index, {"Date"}),
            Final =
                if verifyDistict then col_Index
                else error Error.Record(
                    "TableNotDistinct", "Using column 'date'", col_Index )
        in
            Final

in
    Value.ReplaceType( DateTable.FromDates_Impl, DateTable.FromDates_Type1 )

