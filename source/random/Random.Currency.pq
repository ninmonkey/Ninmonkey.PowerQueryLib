let
    /*
    About: randomly generate currency within a range [2021-04-23]
    optional culture
    Return Type: [Currency]
     */
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