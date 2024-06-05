let    Format.ShowBlank = (source as list) as list => [
        ret = List.ReplaceMatchingItems( source,
            {   { "", "<EmptyStr>" },
                { null, Uni[Null]  } }
        )
    ][ret]
in Format.ShowBlank