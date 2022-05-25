let
    // Splitter.SplitByTraceLog = () =>
    // this part is a wip, to work on any of the log files without the json specific
    Table.FromTraceLog = (source as binary, optional options as nullable record) as any => // as table
        let
            read_lines = Lines.FromBinary(source, null, null, TextEncoding.Utf8),
            t0 = Table.FromColumns( read_lines  ), //{"Line"} ),
             split_by_json = Table.SplitColumn(
                    read_lines, "Column1",
                    Splitter.SplitTextByCharacterTransition({" "}, {"{"}),
                    {"Header", "Json"}
                ),
                parse_json = Table.TransformColumns(split_by_json,{{"Json", Json.Document}})
        in
            parse_json,


    /*
    loads trace log from mashup
        example name: traces/Microsoft.Mashup.Container.NetFX45.22620.2022-05-20T21-17-01-611886.log

    see also:
        Diagnostic.FormatDetailedLog
    */
    Table.FromMashupLog = (source as binary, optional options as nullable record) as table =>
        // use QuoteStyle.None or else it removes quotes, making JSON invalid
            let
                read_lines = Table.FromColumns({
                    Lines.FromBinary(source, null, null, 65001)}),

                split_by_json = Table.SplitColumn(
                    read_lines, "Column1",
                    Splitter.SplitTextByCharacterTransition({" "}, {"{"}),
                    {"Header", "Json"}
                ),
                parse_json = Table.TransformColumns(split_by_json,{{"Json", Json.Document}}),

                #"Expanded Json" = Table.ExpandRecordColumn(parse_json, "Json", {"Start", "Action", "HostProcessId", "PartitionKey", "Expression", "ProductVersion", "ActivityId", "Process", "Pid", "Tid", "Duration"}, {"Start", "Action", "HostProcessId", "PartitionKey", "Expression", "ProductVersion", "ActivityId", "Process", "Pid", "Tid", "Duration"}),

                col_types = Table.TransformColumnTypes(#"Expanded Json",{{"Action", type text}, {"Header", type text}, {"Start", type datetime}, {"HostProcessId", Int64.Type}, {"PartitionKey", type text}, {"Expression", type text}, {"ProductVersion", type text}, {"ActivityId", type text}, {"Process", type text}, {"Pid", Int64.Type}, {"Tid", Int64.Type}, {"Duration", type duration}}),

                add_seconds = Table.AddColumn(col_types, "Seconds", each Duration.Seconds([Duration]), type number),
                add_milliseconds = Table.AddColumn(add_seconds, "Ms", each Duration.TotalSeconds([Duration] * 1000) , type number),
                #"Removed Columns" = Table.RemoveColumns(add_milliseconds,{"Header"}),

                #"Reordered Columns" = Table.ReorderColumns(
                    #"Removed Columns",
                    {"Action", "Ms", "ActivityId", "Pid", "Tid", "Start", "Seconds", "HostProcessId",
                    "PartitionKey", "Expression", "ProductVersion", "Process", "Duration"}
                )
            in
                #"Reordered Columns"

in
    Table.FromMashupLog