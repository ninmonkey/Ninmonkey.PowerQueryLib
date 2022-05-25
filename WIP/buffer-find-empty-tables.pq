let
    Source = Json.Document(File.Contents("C:\Users\cppmo_000\Microsoft\Power BI Desktop Store App\Traces\Diagnostics\Diagnostics_Detailed_20220522T105451.876-f9e2ebd8-fd74-4f33-b9fa-b8cb656da987.json")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1",
        {"Id", "Query", "Step", "Category", "DataSourceKind", "Operation", "StartTime", "EndTime", "ExclusiveDurationPct", "ExclusiveDuration", "Resource", "DataSourceQuery", "AdditionalInfo", "RowCount", "ContentLength", "IsUserQuery", "Path", "GroupId", "PartitionKey", "Process", "ActivityId", "DataSourceOperationIds"},
        {"Id", "Query", "Step", "Category", "Data Source Kind", "Operation", "Start Time", "End Time", "Exclusive Duration (%)", "Exclusive Duration", "Resource", "Data Source Query", "Additional Info", "Row Count", "Content Length", "Is User Query", "Path", "Group Id", "Partition Key", "Process", "Activity Id", "Data Source Operation Identifiers"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",
        {{"Id", type text}, {"Query", type text}, {"Step", type text}, {"Category", type text}, {"Data Source Kind", type text}, {"Operation", type text}, {"Start Time", type datetime}, {"End Time", type datetime}, {"Exclusive Duration (%)", Percentage.Type}, {"Exclusive Duration", type duration}, {"Resource", type text}, {"Data Source Query", type text}, {"Additional Info", type any}, {"Row Count", Int64.Type}, {"Content Length", Int64.Type}, {"Is User Query", type logical}, {"Path", type text}, {"Group Id", type number}, {"Partition Key", type text}, {"Process", type text}, {"Activity Id", type text}, {"Data Source Operation Identifiers", type any}}),


    fn_FormatDiagQuery_Detailed = (source as table, optional CurrentActivityId as nullable any,
            optional options as nullable record
        ) as table =>
        let
            options = Record.Combine({ defaults, (options ?? []) }),
            defaults = [
                FilterByUserQuery = true,
                CurrentActivityId = CurrentActivityId ?? null
            ],

            select_activityId =
                if options[CurrentActivityId] = null then source
                else Table.SelectRows( source, each ([Activity Id] = options[CurrentActivityId] )),

            select_isUserQuery =
                if not options[FilterByUserQuery] then select_activityId
                else Table.SelectRows( select_activityId, each [Is User Query] = true )
        in
            select_isUserQuery,

    Table.ContainsNonBlank = (source as table, columnName as text) as logical =>
        // Test.ColumnIsBlank
        // future: source could optionally be a list, then drop the colukmn name args
        let
            col = Table.Column(source, columnName),
            containsNonBlank = List.MatchesAny( col, each _ <> null)
        in
            containsNonBlank,

    Table.FindBlankColumns = (source as table) as table =>
        let
            columnNames = Table.ColumnNames(source),
            t = Table.FromList(
                    columnNames, null,
                    type table[ColumnName = text]),

            col_containsTest = Table.AddColumn(
                    t,  "ContainsNonBlank",
                    (row) =>
                        Table.ContainsNonBlank( source, row[ColumnName] ),
                    type text
                )

        in
            col_containsTest,



    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([Activity Id] = CurrentActivityId )),
    final2 = fn_FormatDiagQuery_Detailed( #"Changed Type", CurrentActivityId ),
    Custom1 = List.MatchesAny( #"Filtered Rows1" [Data Source Kind], each _ <> null),
    #"Filtered Rows1" = #"Filtered Rows",
    tryI = [
        datasource = Table.ContainsNonBlank( #"Filtered Rows1", "Data Source Kind" ),
        bar = 23
    ],
    fin = Table.SelectRows(#"Filtered Rows1", each true),
    Custom2 = Table.ColumnNames( #"Filtered Rows1" ),
    Custom3 = Table.FromList( Custom2, null, type table[Column = text]),
    try_func = Table.FindBlankColumns( fin ),
    Custom4 = Table.AddColumn( try_func, "ContainsNonBlank" , (row) => Table.ContainsNonBlank( fin, row[Column] ), type logical ),
    cols_to_keep = Table.SelectRows( try_func, each [ContainsNonBlank] = true )[ColumnName],
    Custom5 = final2,

    Table.RemoveBlankColumns = (source as table, optional options as nullable record) as any =>//as table =>
        let
            blankColumns = Table.FindBlankColumns( source ),
            cols_to_keep = Table.SelectRows( blankColumns, each [ContainsNonBlank] = true )[ColumnName],
            drop_emptyCols = Table.SelectColumns( source, cols_to_keep ),
            // cols_to_keep = Table.SelectRows( try_func, each [ContainsNonBlank] = true )[ColumnName]
            zed = drop_emptyCols
        in
            zed,

    tryZed = Table.RemoveBlankColumns(final2),


    #"Removed Other Columns" = Table.SelectColumns(final2 , cols_to_keep)
in
    #"Removed Other Columns"
    let
    Source = Json.Document(File.Contents("C:\Users\cppmo_000\Microsoft\Power BI Desktop Store App\Traces\Diagnostics\Diagnostics_Detailed_20220522T105451.876-f9e2ebd8-fd74-4f33-b9fa-b8cb656da987.json")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1",
        {"Id", "Query", "Step", "Category", "DataSourceKind", "Operation", "StartTime", "EndTime", "ExclusiveDurationPct", "ExclusiveDuration", "Resource", "DataSourceQuery", "AdditionalInfo", "RowCount", "ContentLength", "IsUserQuery", "Path", "GroupId", "PartitionKey", "Process", "ActivityId", "DataSourceOperationIds"},
        {"Id", "Query", "Step", "Category", "Data Source Kind", "Operation", "Start Time", "End Time", "Exclusive Duration (%)", "Exclusive Duration", "Resource", "Data Source Query", "Additional Info", "Row Count", "Content Length", "Is User Query", "Path", "Group Id", "Partition Key", "Process", "Activity Id", "Data Source Operation Identifiers"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",
        {{"Id", type text}, {"Query", type text}, {"Step", type text}, {"Category", type text}, {"Data Source Kind", type text}, {"Operation", type text}, {"Start Time", type datetime}, {"End Time", type datetime}, {"Exclusive Duration (%)", Percentage.Type}, {"Exclusive Duration", type duration}, {"Resource", type text}, {"Data Source Query", type text}, {"Additional Info", type any}, {"Row Count", Int64.Type}, {"Content Length", Int64.Type}, {"Is User Query", type logical}, {"Path", type text}, {"Group Id", type number}, {"Partition Key", type text}, {"Process", type text}, {"Activity Id", type text}, {"Data Source Operation Identifiers", type any}}),


    fn_FormatDiagQuery_Detailed = (source as table, optional CurrentActivityId as nullable any,
            optional options as nullable record
        ) as table =>
        let
            options = Record.Combine({ defaults, (options ?? []) }),
            defaults = [
                FilterByUserQuery = true,
                CurrentActivityId = CurrentActivityId ?? null
            ],

            select_activityId =
                if options[CurrentActivityId] = null then source
                else Table.SelectRows( source, each ([Activity Id] = options[CurrentActivityId] )),

            select_isUserQuery =
                if not options[FilterByUserQuery] then select_activityId
                else Table.SelectRows( select_activityId, each [Is User Query] = true )
        in
            select_isUserQuery,

    Table.ContainsNonBlank = (source as table, columnName as text) as logical =>
        // Test.ColumnIsBlank
        // future: source could optionally be a list, then drop the colukmn name args
        let
            col = Table.Column(source, columnName),
            containsNonBlank = List.MatchesAny( col, each _ <> null)
        in
            containsNonBlank,

    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([Activity Id] = CurrentActivityId )),
    final2 = fn_FormatDiagQuery_Detailed( #"Changed Type", CurrentActivityId ),
    Custom1 = List.MatchesAny( #"Filtered Rows1" [Data Source Kind], each _ <> null),
    tryI = [
        datasource = Table.ContainsNonBlank( #"Filtered Rows1", "Data Source Kind" ),
        bar = 23
    ],
    fin = Table.SelectRows(#"Filtered Rows", each true)
in
    Fin

    let
    Source = Json.Document(File.Contents("C:\Users\cppmo_000\Microsoft\Power BI Desktop Store App\Traces\Diagnostics\Diagnostics_Detailed_20220522T105451.876-f9e2ebd8-fd74-4f33-b9fa-b8cb656da987.json")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1",
        {"Id", "Query", "Step", "Category", "DataSourceKind", "Operation", "StartTime", "EndTime", "ExclusiveDurationPct", "ExclusiveDuration", "Resource", "DataSourceQuery", "AdditionalInfo", "RowCount", "ContentLength", "IsUserQuery", "Path", "GroupId", "PartitionKey", "Process", "ActivityId", "DataSourceOperationIds"},
        {"Id", "Query", "Step", "Category", "Data Source Kind", "Operation", "Start Time", "End Time", "Exclusive Duration (%)", "Exclusive Duration", "Resource", "Data Source Query", "Additional Info", "Row Count", "Content Length", "Is User Query", "Path", "Group Id", "Partition Key", "Process", "Activity Id", "Data Source Operation Identifiers"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",
        {{"Id", type text}, {"Query", type text}, {"Step", type text}, {"Category", type text}, {"Data Source Kind", type text}, {"Operation", type text}, {"Start Time", type datetime}, {"End Time", type datetime}, {"Exclusive Duration (%)", Percentage.Type}, {"Exclusive Duration", type duration}, {"Resource", type text}, {"Data Source Query", type text}, {"Additional Info", type any}, {"Row Count", Int64.Type}, {"Content Length", Int64.Type}, {"Is User Query", type logical}, {"Path", type text}, {"Group Id", type number}, {"Partition Key", type text}, {"Process", type text}, {"Activity Id", type text}, {"Data Source Operation Identifiers", type any}}),


    fn_FormatDiagQuery_Detailed = (source as table, optional CurrentActivityId as nullable any,
            optional options as nullable record
        ) as table =>
        let
            options = Record.Combine({ defaults, (options ?? []) }),
            defaults = [
                FilterByUserQuery = true,
                CurrentActivityId = CurrentActivityId ?? null
            ],

            select_activityId =
                if options[CurrentActivityId] = null then source
                else Table.SelectRows( source, each ([Activity Id] = options[CurrentActivityId] )),

            select_isUserQuery =
                if not options[FilterByUserQuery] then select_activityId
                else Table.SelectRows( select_activityId, each [Is User Query] = true )
        in
            select_isUserQuery,

    Table.ContainsNonBlank = (source as table, columnName as text) as logical =>
        // Test.ColumnIsBlank
        // future: source could optionally be a list, then drop the colukmn name args
        let
            col = Table.Column(source, columnName),
            containsNonBlank = List.MatchesAny( col, each _ <> null)
        in
            containsNonBlank,

    Table.FindBlankColumns = (source as table) =>
        let
            columnNames = Table.ColumnNames(source)
        in
            columnNames,



    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([Activity Id] = CurrentActivityId )),
    final2 = fn_FormatDiagQuery_Detailed( #"Changed Type", CurrentActivityId ),
    Custom1 = List.MatchesAny( #"Filtered Rows1" [Data Source Kind], each _ <> null),
    #"Filtered Rows1" = #"Filtered Rows",
    tryI = [
        datasource = Table.ContainsNonBlank( #"Filtered Rows1", "Data Source Kind" ),
        bar = 23
    ],
    fin = Table.SelectRows(#"Filtered Rows1", each true),
    Custom2 = Table.ColumnNames( #"Filtered Rows1" ),
    Custom3 = Table.FromList( Custom2, null, type table[Column = text]),
    Custom4 = Table.AddColumn( Custom3, "ContainsNonBlank" , (row) => Table.ContainsNonBlank( fin, row[Column] ), type logical )
in
    Custom4


let
    Source = Json.Document(File.Contents("C:\Users\cppmo_000\Microsoft\Power BI Desktop Store App\Traces\Diagnostics\Diagnostics_Detailed_20220522T105451.876-f9e2ebd8-fd74-4f33-b9fa-b8cb656da987.json")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1",
        {"Id", "Query", "Step", "Category", "DataSourceKind", "Operation", "StartTime", "EndTime", "ExclusiveDurationPct", "ExclusiveDuration", "Resource", "DataSourceQuery", "AdditionalInfo", "RowCount", "ContentLength", "IsUserQuery", "Path", "GroupId", "PartitionKey", "Process", "ActivityId", "DataSourceOperationIds"},
        {"Id", "Query", "Step", "Category", "Data Source Kind", "Operation", "Start Time", "End Time", "Exclusive Duration (%)", "Exclusive Duration", "Resource", "Data Source Query", "Additional Info", "Row Count", "Content Length", "Is User Query", "Path", "Group Id", "Partition Key", "Process", "Activity Id", "Data Source Operation Identifiers"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",
        {{"Id", type text}, {"Query", type text}, {"Step", type text}, {"Category", type text}, {"Data Source Kind", type text}, {"Operation", type text}, {"Start Time", type datetime}, {"End Time", type datetime}, {"Exclusive Duration (%)", Percentage.Type}, {"Exclusive Duration", type duration}, {"Resource", type text}, {"Data Source Query", type text}, {"Additional Info", type any}, {"Row Count", Int64.Type}, {"Content Length", Int64.Type}, {"Is User Query", type logical}, {"Path", type text}, {"Group Id", type number}, {"Partition Key", type text}, {"Process", type text}, {"Activity Id", type text}, {"Data Source Operation Identifiers", type any}}),


    fn_FormatDiagQuery_Detailed = (source as table, optional CurrentActivityId as nullable any,
            optional options as nullable record
        ) as table =>
        let
            options = Record.Combine({ defaults, (options ?? []) }),
            defaults = [
                FilterByUserQuery = true,
                CurrentActivityId = CurrentActivityId ?? null
            ],

            select_activityId =
                if options[CurrentActivityId] = null then source
                else Table.SelectRows( source, each ([Activity Id] = options[CurrentActivityId] )),

            select_isUserQuery =
                if not options[FilterByUserQuery] then select_activityId
                else Table.SelectRows( select_activityId, each [Is User Query] = true )
        in
            select_isUserQuery,

    Table.ContainsNonBlank = (source as table, columnName as text) as logical =>
        // Test.ColumnIsBlank
        // future: source could optionally be a list, then drop the colukmn name args
        let
            col = Table.Column(source, columnName),
            containsNonBlank = List.MatchesAny( col, each _ <> null)
        in
            containsNonBlank,

    Table.FindBlankColumns = (source as table) as table =>
        let
            columnNames = Table.ColumnNames(source),
            t = Table.FromList(
                    columnNames, null,
                    type table[ColumnName = text]),

            col_containsTest = Table.AddColumn(
                    t,  "ContainsNonBlank",
                    (row) =>
                        Table.ContainsNonBlank( source, row[ColumnName] ),
                    type text
                )

        in
            col_containsTest,



    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([Activity Id] = CurrentActivityId )),
    final2 = fn_FormatDiagQuery_Detailed( #"Changed Type", CurrentActivityId ),
    Custom1 = List.MatchesAny( #"Filtered Rows1" [Data Source Kind], each _ <> null),
    #"Filtered Rows1" = #"Filtered Rows",
    tryI = [
        datasource = Table.ContainsNonBlank( #"Filtered Rows1", "Data Source Kind" ),
        bar = 23
    ],
    fin = Table.SelectRows(#"Filtered Rows1", each true),
    Custom2 = Table.ColumnNames( #"Filtered Rows1" ),
    Custom3 = Table.FromList( Custom2, null, type table[Column = text]),
    try_func = Table.FindBlankColumns( fin ),
    Custom4 = Table.AddColumn( try_func, "ContainsNonBlank" , (row) => Table.ContainsNonBlank( fin, row[Column] ), type logical )
in
    Custom4

    ---

    let
    Source = Json.Document(File.Contents("C:\Users\cppmo_000\Microsoft\Power BI Desktop Store App\Traces\Diagnostics\Diagnostics_Detailed_20220522T105451.876-f9e2ebd8-fd74-4f33-b9fa-b8cb656da987.json")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1",
        {"Id", "Query", "Step", "Category", "DataSourceKind", "Operation", "StartTime", "EndTime", "ExclusiveDurationPct", "ExclusiveDuration", "Resource", "DataSourceQuery", "AdditionalInfo", "RowCount", "ContentLength", "IsUserQuery", "Path", "GroupId", "PartitionKey", "Process", "ActivityId", "DataSourceOperationIds"},
        {"Id", "Query", "Step", "Category", "Data Source Kind", "Operation", "Start Time", "End Time", "Exclusive Duration (%)", "Exclusive Duration", "Resource", "Data Source Query", "Additional Info", "Row Count", "Content Length", "Is User Query", "Path", "Group Id", "Partition Key", "Process", "Activity Id", "Data Source Operation Identifiers"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",
        {{"Id", type text}, {"Query", type text}, {"Step", type text}, {"Category", type text}, {"Data Source Kind", type text}, {"Operation", type text}, {"Start Time", type datetime}, {"End Time", type datetime}, {"Exclusive Duration (%)", Percentage.Type}, {"Exclusive Duration", type duration}, {"Resource", type text}, {"Data Source Query", type text}, {"Additional Info", type any}, {"Row Count", Int64.Type}, {"Content Length", Int64.Type}, {"Is User Query", type logical}, {"Path", type text}, {"Group Id", type number}, {"Partition Key", type text}, {"Process", type text}, {"Activity Id", type text}, {"Data Source Operation Identifiers", type any}}),


    fn_FormatDiagQuery_Detailed = (source as table, optional CurrentActivityId as nullable any,
            optional options as nullable record
        ) as table =>
        let
            options = Record.Combine({ defaults, (options ?? []) }),
            defaults = [
                FilterByUserQuery = true,
                CurrentActivityId = CurrentActivityId ?? null
            ],

            select_activityId =
                if options[CurrentActivityId] = null then source
                else Table.SelectRows( source, each ([Activity Id] = options[CurrentActivityId] )),

            select_isUserQuery =
                if not options[FilterByUserQuery] then select_activityId
                else Table.SelectRows( select_activityId, each [Is User Query] = true )
        in
            select_isUserQuery,

    Table.ContainsNonBlank = (source as table, columnName as text) as logical =>
        // Test.ColumnIsBlank
        // future: source could optionally be a list, then drop the colukmn name args
        let
            col = Table.Column(source, columnName),
            containsNonBlank = List.MatchesAny( col, each _ <> null)
        in
            containsNonBlank,

    Table.FindBlankColumns = (source as table) as table =>
        let
            columnNames = Table.ColumnNames(source),
            t = Table.FromList(
                    columnNames, null,
                    type table[ColumnName = text]),

            col_containsTest = Table.AddColumn(
                    t,  "ContainsNonBlank",
                    (row) =>
                        Table.ContainsNonBlank( source, row[ColumnName] ),
                    type text
                )

        in
            col_containsTest,



    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([Activity Id] = CurrentActivityId )),
    final2 = fn_FormatDiagQuery_Detailed( #"Changed Type", CurrentActivityId ),
    Custom1 = List.MatchesAny( #"Filtered Rows1" [Data Source Kind], each _ <> null),
    #"Filtered Rows1" = #"Filtered Rows",
    tryI = [
        datasource = Table.ContainsNonBlank( #"Filtered Rows1", "Data Source Kind" ),
        bar = 23
    ],
    fin = Table.SelectRows(#"Filtered Rows1", each true),
    Custom2 = Table.ColumnNames( #"Filtered Rows1" ),
    Custom3 = Table.FromList( Custom2, null, type table[Column = text]),
    try_func = Table.FindBlankColumns( fin ),
    Custom4 = Table.AddColumn( try_func, "ContainsNonBlank" , (row) => Table.ContainsNonBlank( fin, row[Column] ), type logical ),
    cols_to_keep = Table.SelectRows( try_func, each [ContainsNonBlank] = true )[ColumnName],
    Custom5 = final2,

    Table.RemoveBlankColumns = (source as table, optional options as nullable record) as any =>//as table =>
        let
            blankColumns = Table.FindBlankColumns( source ),
            cols_to_keep = Table.SelectRows( blankColumns, each [ContainsNonBlank] = true )[ColumnName],
            drop_emptyCols = Table.SelectColumns( source, cols_to_keep ),
            // cols_to_keep = Table.SelectRows( try_func, each [ContainsNonBlank] = true )[ColumnName]
            zed = drop_emptyCols
        in
            zed,

    tryZed = Table.RemoveBlankColumns(final2),


    #"Removed Other Columns" = Table.SelectColumns(final2 , cols_to_keep)
in
    #"Removed Other Columns"