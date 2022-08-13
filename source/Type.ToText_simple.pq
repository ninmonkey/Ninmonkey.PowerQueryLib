let
    // converts object to plain text
    // converts object to plain text
Type.ToText.Type = type function(
        typeInfo as (type any meta [
            Documentation.FieldCaption = "Object to test",
            Documentation.FieldDescription = "Value to compare type names against",
            Documentation.SampleValues = {
                23.45, "string", DateTime.LocalNow()
                //, #table(type table[Text = text],{{"hi world"}})
            }
        ]),
        optional options as (type record meta [
            Documentation.FieldCaption = "for future formatting",
            Documentation.FieldDescription = "for future formatting",
            Documentation.SampleValues = {
            }
        ])) as table meta [
            Documentation.Name = "Get Type Name",
            Documentation.LongDescription = "Returns type names as text, for the current value",
            Documentation.Examples = {[
                Description = "Getting Type Names:",
                Code = "{ Type.ToText(3), Type.ToText( {0..4} ), Type.ToText(null)  }",
                Result = "{ ""Number"",  ""List"", ""None""}"
            ]}
        ],
    Type.ToText_impl = (typeInfo as any, optional options as nullable record) as text =>
        let
            options = Record.Combine([], options),
            name =
                if typeInfo is null then "Null"
                else if typeInfo is type then "Type"
                else if typeInfo is binary then "Binary"
                else if typeInfo is number then "Number"
                else if typeInfo is function then "Function"
                else if typeInfo is list then "List"
                else if typeInfo is table then "Table"
                else if typeInfo is record then "Record"
                else "Other" meta [ ValueType = typeInfo ]
        in
            name,
    Type.ToText = Value.ReplaceType( Type.ToText_impl, Type.ToText.Type ),
    tests = {
    },
    summary = [
        tests = tests,
        a = Type.ToText(3.4),
        b = Type.ToText( {0..4} ),
        c = Type.ToText(null),
        FuncFinal = Type.ToText
    ],
    FuncFinal = summary[FuncFinal],
    #"Invoked FunctionFuncFinal" = FuncFinal(34, [])
in
    #"Invoked FunctionFuncFinal"
// in
//     Type.ToText