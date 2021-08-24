let
    Docs = ItemExpression.From,
    Ast1 = ItemExpression.From(each _ <> null),
    Ast2 = ItemExpression.From( (x as number) as number => Int64.From(x, RoundingMode.ToEven )
    Left = Ast1[Left],

    inspectAstPair = (source as any) as any =>
        let
            x = Record.FromList(source)
        in
            x,

    // Record.FromList({1, "Bob", "123-4567"}, {"CustomerID", "Name", "Phone"})
    // Record.FromList({1, "Bob", "123-4567"}, type [CustomerID = number, Name = text, Phone = number])
    // Custom1 = Record.ToTable(Left),
    doc = Record.FromList,
    z = Type.Facets()
    doc2 = Record.FromTable,
    Custom1 = Record.FromList( Left, {}),
    a = DirectQueryCapabilities.From,
    // Value.ResourceExpression()
    x = Facts.Summarize(),
    y = Type.ReplaceFacets,
    // a3 = Roundingmod,
    a1 = Type.FunctionParameters,
    a32 = Type.FunctionRequiredParameters,
    // a3 = Type. * generate this , qer = Typee
    e = Type.Facets,


    z = FactCheck,
    insp = inspectAstPair( Left ),
    Custom2 = TableToJson( Left )

    // insp = Inspect
in
    Custom2


