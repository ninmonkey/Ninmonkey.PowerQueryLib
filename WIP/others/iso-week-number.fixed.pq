// originally: <https://datacornering.com/how-to-calculate-iso-week-number-in-power-query/>
let
    todo = "Cleanup" ,
    Source = List.Dates(DateTime.Date(DateTime.LocalNow()), 365, #duration(1, 0, 0, 0)),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Columns" = Table.RenameColumns(#"Converted to Table", {{"Column1", "Date"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns", {{"Date", type date}}),
    #"Weekday Number" = Table.AddColumn(#"Changed Type", "Weekday Number", each Date.DayOfWeek([Date], Day.Monday) + 1),
    #"ISO Week Number" = Table.AddColumn(
        #"Weekday Number",
        "ISO Week Number",
        each
            if Number.RoundDown((Date.DayOfYear([Date]) - (Date.DayOfWeek([Date], Day.Monday) + 1) + 10) / 7) = 0 then
                Number.RoundDown(
                    (
                        Date.DayOfYear(#date(Date.Year([Date]) - 1, 12, 31)) - (
                            Date.DayOfWeek(#date(Date.Year([Date]) - 1, 12, 31), Day.Monday) + 1
                        ) + 10
                    ) / 7
                )
            else if (
                Number.RoundDown((Date.DayOfYear([Date]) - (Date.DayOfWeek([Date], Day.Monday) + 1) + 10) / 7) = 53
                and (Date.DayOfWeek(#date(Date.Year([Date]), 12, 31), Day.Monday) + 1 < 4)
            ) then
                1
            else
                Number.RoundDown((Date.DayOfYear([Date]) - (Date.DayOfWeek([Date], Day.Monday) + 1) + 10) / 7)
    )
in
    todo
