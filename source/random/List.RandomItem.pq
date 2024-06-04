let
    // returns a random item from a list
    List.Random.Item = (source as list) as any => [
        which  = List.Random.Index( source ),
        return = source{ which }
    ][return]
in
    List.Random.Item