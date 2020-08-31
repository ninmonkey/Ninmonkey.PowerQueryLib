/*

Description:


see:
    ListAsText()

original code based on: <https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244>

*/
let

    /* Optional parameter: Is this being used as part of a function signature? */
    Serialize.List =  (x as list) as list => "{" &
        List.Accumulate(x, "",
            (seed,item) =>
                if seed="" then Text.From(item)
                else seed & ", " & Text.From(item)) &
            "} "
in
    Serialize.List
