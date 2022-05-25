// from PBI traces, the one named 'detailed'
    Diagnostic.FormatDetailedLog = (source as table, optional CurrentActivityId as nullable any,
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
            select_isUserQuery