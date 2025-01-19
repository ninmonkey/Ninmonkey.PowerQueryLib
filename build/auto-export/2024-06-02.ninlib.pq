    /*
    Name:
        List_Random

    Description:
        Randomly select items in a list [2021-04-24]

        If a list has 3 elements, this generates a random int
            in the range [0-2] (inclusive), then returns list{i}

    Alias:
        python uses the name: random.choice( <list> )

    Example:

        List_Random( {"Dog", "Cat", "Fish"} )
        // returns: "Cat"

    future:
        - [ ] validate empty list, or null, or null in list
        - [ ] nicer user-facing errors
    */

    (source as list) as any =>
        let
            maxIndex = List.Count(source) - 1,
            offset = List.Random(1){0} * maxIndex,
            r = Number.Round( offset,  null, null ),
            name = source{r}
        in
            name
