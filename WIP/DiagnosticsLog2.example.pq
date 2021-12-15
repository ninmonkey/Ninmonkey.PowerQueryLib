    Value.ToText = (value, optional depth) =>
        let
            nextDepth = if depth = null then 3 else depth - 1,
            result = if depth = 0 then "..."
                else if value is null then "<null>"
                else if value is function then "<function>"
                else if value is table then "#table({" & Text.Combine(Table.ColumnNames(value), ",") & "},{" & Text.Combine(
                    List.Transform(Table.ToRows(Table.FirstN(value, 2)), each @Value.ToText(_, nextDepth)), "},#(cr)#(lf){") & "})"
                    //& "Row Count (" & Number.ToText(Table.RowCount(value)) & ")"
                else if value is list then "{" & Text.Combine(List.Transform(List.FirstN(value, 10), each @Value.ToText(_, nextDepth)), ",") & "}"
                else if value is record then "[" & Text.Combine(List.Transform(Record.FieldNames(value), each _ & "=" & @Value.ToText(Record.Field(value, _), nextDepth)), ",") & "]"
                else if value is type then List.First(Table.Schema(#table({"type"}, {{value}}))[TypeName], "<type>")
                else Text.From(value)
        in
            try result otherwise "<error>",
    Diagnostics.LogValue = (prefix, value, result, optional delayed) => Diagnostics.Trace(TraceLevel.Information, prefix & ": " & Value.ToText(value), result, delayed),
    Diagnostics.LogValue2 = (prefix, value) => Diagnostics.Trace(TraceLevel.Information, prefix & ": " & Value.ToText(value), value),
    Diagnostics.LogFailure = (text, function) =>
        let
            result = try function()
        in
            if result[HasError] then Diagnostics.LogValue(text, result[Error], () => error result[Error], true) else result[Value],
    Diagnostics.WrapFunctionResult = (innerFunction as function, outerFunction as function) as function =>
        let
            parameterCount = Record.FieldCount(Type.FunctionParameters(Value.Type(innerFunction)))
        in
            if parameterCount = 0 then () => outerFunction(() => innerFunction())
            else if parameterCount = 1 then (p1) => outerFunction(() => innerFunction(p1))
            else if parameterCount = 2 then (p1, p2) => outerFunction(() => innerFunction(p1, p2))
            else if parameterCount = 3 then (p1, p2, p3) => outerFunction(() => innerFunction(p1, p2, p3))
            else if parameterCount = 4 then (p1, p2, p3, p4) => outerFunction(() => innerFunction(p1, p2, p3, p4))
            else if parameterCount = 5 then (p1, p2, p3, p4, p5) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5))
            else if parameterCount = 6 then (p1, p2, p3, p4, p5, p6) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6))
            else if parameterCount = 7 then (p1, p2, p3, p4, p5, p6, p7) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6, p7))
            else if parameterCount = 8 then (p1, p2, p3, p4, p5, p6, p7, p8) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6, p7, p8))
            else if parameterCount = 9 then (p1, p2, p3, p4, p5, p6, p7, p8, p9) => outerFunction(() => innerFunction(p1, p2, p3, p4, p5, p6, p7, p8, p9))
            else error "Too many arguments to wrap",
    Diagnostics.WrapHandlers = (handlers as record) as record =>
        Record.FromList(
            List.Transform(
                Record.FieldNames(handlers),
                (h) => Diagnostics.WrapFunctionResult(Record.Field(handlers, h), (fn) => Diagnostics.LogFailure(h, fn))),
            Record.FieldNames(handlers)),

    Value.IfNull = (a, b) => if a <> null then a else b,
