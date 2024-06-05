let
    // values like "10s" or "3m"
    Splitter.SplitDigitWithSuffix = // Splitter.SplitTextByDigitWithSuffixTransition =
        Splitter.SplitTextByCharacterTransition(
        {"0".."9"}, (c) => not List.Contains({"0".."9"}, c) )


in Splitter.SplitDigitWithSuffix