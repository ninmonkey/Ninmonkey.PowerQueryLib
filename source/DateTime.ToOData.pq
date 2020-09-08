let
    /*

    See also:
        .\source\test\test_DateTime_ToOData.pq

    Description:

        Converts Power Query `date` and `datetimes` to OData `datetime` and `datetimeoffset`

    Examples:
        9/8/2020 2:01:50 PM         DateTime Local
        9/8/2020 2:01:50 PM -05:00  DateTimeZone Local
        9/8/2020 7:23:18 PM +00:00  DateTimeZone Utc

    Output:
        datetime'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T14:01:49'
        datetimeoffset'2020-09-08T19:23:17'
    */

    DateTime_ToOData = (dates as any) as text =>
        // verify that culture doesn't change when using format "s"
        let
            formattedType = if dates is datetime then
                "datetime'" &  DateTime.ToText( dates, "s", null )
            else if dates is datetimezone then
                "datetimeoffset'" & DateTimeZone.ToText( dates, "s", null )
            else
                error Error.Record(
                    "InvalidType", "Expected, datetime, or datetimezone",
                    Value.Type( dates )
                ),
            formatted = formattedType & "'"
        in
            formatted
in
    DateTime_ToOData
