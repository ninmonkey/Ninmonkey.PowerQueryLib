let
    /*
    ref:
        - https://docs.microsoft.com/en-us/power-query/handlingdocumentation
        - https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata#function-parameter-documentation

    AllowedValues may be dynamic:
        https://ssbi-blog.de/blog/technical-topics-english/writing-documentation-for-custom-m-functions-part3/
    */

    Documentation = type function (
        a as (type number meta [
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

        ]),
        b as (type number meta [
            Documentation.FieldCaption = "Second Number",
            Documentation.FieldDescription = "[Field B Desc] text (tooltip?)",
            Formatting.IsMultiLine = true,
            Formatting.IsCode = false,
            Documentation.SampleValues = {4, 7}
        ])
    ) as table meta [
        Documentation.Name = "[Name] SumNumbers",
        Documentation.LongDescription = "[LongDesc] Adds two numbers",
        Documentation.Examples = {[
            Description = "Sum two numbers",
            Code = "let sum = Func(1, 3) in sum",
            Result = "4"
        ]}
    ],

    SumNum = (a as number, b as number) as number =>
        a + b
in
    Value.ReplaceType( SumNum, Documentation)
