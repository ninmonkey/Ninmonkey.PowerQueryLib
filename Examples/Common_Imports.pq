let
    Version = lib[Lib],
    // local references to "import" functions into the current scope
    List.Summarize   = lib[List.Summarize],
    Record.Summarize = lib[Record.Summarize],
    Table.Summarize  = lib[Table.Summarize],
    // future: auto-expand docstrings for function table as a lib summary
    // libSummary_table = List.Summarize(Functions),
    summaryTable = Record.ToTable( lib )

in
    summaryTable