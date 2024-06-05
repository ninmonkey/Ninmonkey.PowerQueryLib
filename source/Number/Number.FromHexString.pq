let
    /*
    Converts from hex encoded, plain-text values into numbers

        in: "2432"  out: 9266 (which is 0x2432)

    note: It uses Eval. I think

    see also: Number.ToHexString, Number.FromHexString
    future improvement, I think I can make it stricter by wrapping it as a constant first
    psuedo code:

        Expression.Evaluate( Expression.Constant('0x' + "2400") ),

    */
    Number.FromHexString = (source as text) as number => [
        hasPrefix  = Text.StartsWith( source, "0x", Comparer.OrdinalIgnoreCase ),
        withPrefix =
            if hasPrefix
            then source else "0x" & source,

        // asConstant = Expression.Constant( withPrefix ),
        ret        = Expression.Evaluate( withPrefix, [] )
    ][ret]

in Number.FromHexString