let
    // If length was expected, return it, otherwise throw for unexpected values
    // todo future: Add a version that returns a logic instead. TryAssert.ListLength ?
    Assert.ListLength = (
        source as list,
        expectedLength as number
    ) as list => [
        actualLength = List.Count( source ),
        shouldThrow  = actualLength <> expectedLength,

        finalAssert =
            if not shouldThrow then source
            else error [
                Message.Format = "InvalidLengthException: Expected list length of {0}, but found {1} for list: {2}",
                Message.Parameters = { expectedLength, actualLength, source }
            ]

        return       = source

    ][return]

in
    Assert.ListLength