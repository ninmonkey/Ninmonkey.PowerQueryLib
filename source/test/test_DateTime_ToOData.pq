let
    /*
    Description
        Convert PowerQuery `datetime` and `datetimezone` to a OData format

        OData primatives: https://www.odata.org/documentation/odata-version-2-0/json-format/

    Example:
        9/8/2020 2:01:50 PM         DateTime Local
        9/8/2020 2:01:50 PM -05:00  DateTimeZone Local
        9/8/2020 7:23:18 PM +00:00  DateTimeZone Utc

    Output:
        datetime'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T19:23:17'
    */
    Source = #table(
        type table[Label = text, Format = text, Example = text, Input = any],
        {
            // "there is no 'date' primative type?",
            {
                "DT Fixed local",
                "datetime'yyyy-mm-ddThh:mm[:ss[.fffffff]]",
                "datetime'2000-12-12T12:00'",
                DateTime.FixedLocalNow()
            },
            {
                "DTZ Fixed Local",
                "..",
                "datetimeoffset'2002-10-10T17:00:00Z'",
                DateTimeZone.FixedLocalNow()
            },
            {
                "DTZ Fixed UTC",
                "..",
                "datetimeoffset'2002-10-10T17:00:00Z'",
                DateTimeZone.FixedUtcNow()
            }
        }),

    colUsingFunction = Table.AddColumn(
        Source,
        "Results",
        each DateTime_ToOData( [Input] ),
        type text ),

    Final = colUsingFunction

in
    Final
