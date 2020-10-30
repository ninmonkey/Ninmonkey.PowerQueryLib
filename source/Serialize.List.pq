/*

Description:


see:
    ListAsText()

original code based on: <https://github.com/microsoft/DataConnectors/blob/460babf2f8c44ec82d7e08d1b65b156984c6ba75/samples/UnitTesting/UnitTesting.query.pq#L210-L244>

*/
let

    Documentation = type function (
        anyList as (type number meta [
            Documentation.FieldCaption = "First Number",
            Documentation.FieldDescription = "[Field A Desc] text (tooltip?)",
            // use a multi-line input box
            Formatting.IsMultiLine = false,
            // monospace font
            Formatting.IsCode = false,
            // shown as faded input in text box, else:
            Documentation.SampleValues = {1, 9},
            // as a dropdown, but not enforced
            Documentation.AllowedValues = {34, 99}
        ])
    )
    as table meta [
        Documentation.Name = "[Name] SumNumbers",
        Documentation.LongDescription = "[LongDesc] Adds two numbers",
        Documentation.Examples = {[
            Description = "Sum two numbers",
            Code = "let sum = Func(1, 3) in sum",
            Result = "4"
        ]}
    ],


    /* Optional parameter: Is this being used as part of a function signature? */
    Serialize.List =  (anyList as list) as text => "{" &
        List.Accumulate(anyList, "",
            (seed,item) =>
                if seed="" then Text.From(item)
                else seed & ", " & Text.From(item)) &
            "} "
in
    Serialize.List
