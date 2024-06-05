let    // gets a random index within the bounds of a list
    List.RandomIndex = (source as list) as number => [
        maxIndex = List.Count(source) - 1,
        return   = Random.Int64(0, maxIndex)
    ][return]
in
    List.RandomIndex