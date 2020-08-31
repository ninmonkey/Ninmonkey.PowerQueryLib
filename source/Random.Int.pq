// RandomInt
let
    /* randomly generate currency within a range
    optional culture */
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
    RandomInt
