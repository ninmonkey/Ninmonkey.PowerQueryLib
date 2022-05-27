let
    // maybe this should be one function, that returns the correct variant
    // essentially an enum -> switch
    Summary = [
        SplitOnCaseChange_UpperToLower =
            Splitter.SplitTextByCharacterTransition(
                {{"A".."Z"}, {"a".."z"}}),

        SplitOnCaseChange_LowerToUpper =
            Splitter.SplitTextByCharacterTransition(
                {{"a".."z"}, {"A".."Z"}}),

        SplitOnCaseChange_Any =
            Splitter.SplitTextByCharacterTransition(
                {"A".."Z", "a".."z"}, {"a".."z", "A".."Z"})
        ]
in
    Summary