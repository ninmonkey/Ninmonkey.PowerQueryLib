let
    enableTest = false,
    /*
    better naming idea?

        Number.FromTextWithBaseWithBase
        TextTo_NumberWithBase
        Number.FromTextWithBase
        Number.FromTextWithBaseBase
        Text.To_NumberWithBase

     */

    Number.FromTextWithBase = (Input as text, optional Base as number) as number =>
        // original from: <https://xxlbi.com/blog/converting-hexadecimal-to-decimal-numbers-in-power-query/>
        let
            Symbols = {"0".."9"} & {"A".."F"},
            AsReverseList = List.Reverse(Text.ToList(Text.Upper(Input))),
            AsNumbers = List.Transform(
                AsReverseList,
                each List.PositionOf(Symbols, _)
            ),
            DigitConversion = List.Generate(
                () => 0,
                each _ < List.Count(AsNumbers),
                each _ + 1,
                each AsNumbers{_} * Number.Power(Base ?? 16, _)
            ),
            // Result = try List.Sum(DigitConversion) otherwise null
            Result = try List.Sum(DigitConversion) otherwise error Error.Record(
                "TypeConversionFailed", "Unable to convert",
                [
                    Input = Input,
                    Base = Base,
                    DigitConversion = DigitConversion
                ]
            )
        in
                Result,

    tests = {
        Number.FromTextWithBase("0101", 2) = 5,
        Number.FromTextWithBase("ff", 16) = 255
    },
    Final =
        if enableTest then tests else Number.FromTextWithBase
in
    Final