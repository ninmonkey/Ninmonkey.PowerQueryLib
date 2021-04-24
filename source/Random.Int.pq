let
    /*
        Source: https://github.com/ninmonkey/Ninmonkey.PowerQueryLib
        About: Randomized Int. [2021-04-22]
        See Also: Number.Round* family of functions, and <https://docs.microsoft.com/en-us/power-query/handlingdocumentation>
    */

    Documentation = type function (
        min as (type number meta [
            Documentation.FieldCaption = "Min",
            Documentation.FieldDescription = "Minimum number",
            Documentation.SampleValues = {10, 0.45}
        ]),
        b as (type number meta [
            Documentation.FieldCaption = "Max",
            Documentation.FieldDescription = "Maximum number",
            Documentation.SampleValues = {34, 100.45}
        ]),
        optional culture as (type nullable text meta [
            Documentation.FieldCaption = "Culture",
            Documentation.FieldDescription = "Culture used to convert number"
        ]),
        optional roundingMode as (type nullable number meta [
            Documentation.FieldCaption = "Rounding Mode",
            Documentation.FieldDescription = "rounding method",
            Documentation.AllowedValues = {
                RoundingMode.AwayFromZero, RoundingMode.Down, RoundingMode.ToEven, RoundingMode.TowardZero, RoundingMode.Up}
        ])
    ) as table meta [
            Documentation.Name = "RandomInt",
            Documentation.LongDescription = "Generate a random Integer between two values. Optionally set culture and rounding mode.",
            Documentation.Examples = {[
                Description = "Generate one value",
                Code = "RandomInt(10, 20)",
                Result = "11"
            ]}
        ],

    RandomInt = (
        min as number,
        max as number,
        optional culture as nullable text,
        optional roundingMode as nullable number
    ) as number =>
        Int64.From(
            Number.RandomBetween( min, max ),
            culture,
            roundingMode
        )
in
    Value.ReplaceType( RandomInt, Documentation)
