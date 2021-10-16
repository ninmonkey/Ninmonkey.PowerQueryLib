let
    // Combine all numbers by bitwise-OR-ing them togetherj
    List.Combine_BitFlags = (source as list) as number =>
        let
            joined_flags = List.Accumulate(
                source, 0,
                (state, current) => Number.BitwiseOr( state, current )
            )
        in
            joined_flags
in
    List.Combine_BitFlags