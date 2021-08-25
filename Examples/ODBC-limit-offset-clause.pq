
source: <https://docs.microsoft.com/en-us/power-query/odbc#parameters-for-odbcdatasource>

// when LIMIT but not OFFSET is supported:
LimitClause1 = (skip, take) =>
    if (skip > 0) then error "Skip/Offset not supported"
    else
    [
        Text = Text.Format("LIMIT #{0}", {take}),
        Location = "AfterQuerySpecification"
    ];

// LIMIT and OFFSET
LimitClause2 = (skip, take) =>
    let
        offset = if (skip > 0) then Text.Format("OFFSET #{0} ROWS", {skip}) else "",
        limit = if (take <> null) then Text.Format("LIMIT #{0}", {take}) else ""
    in
        [
            Text = Text.Format("#{0} #{1}", {offset, limit}),
            Location = "AfterQuerySpecification"
        ];