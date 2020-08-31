// RandomCurrency
let
    /* randomly generate currency within a range
    optional culture */
    RandomCurrency = (
            min as number,
            max as number,
            optional culture as nullable text,
            optional roundingMode as nullable number
        ) as number =>
            Currency.From(
                    Number.RandomBetween( min, max ),
                    culture,
                    RoundingMode.Down
                )
in
    RandomCurrency
