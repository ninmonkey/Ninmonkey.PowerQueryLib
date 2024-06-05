let
  /*
    converts string to a bunch of formats
        - components as [int]
        - components as RGBFloat [ 0..1.0 ]
        - components as Hex [ 0x00..0xFF ]
        - full hex string
        - int64, int32
    */
    Rgb.FromHexString = (source as text, optional options as nullable record) as record => [
        /*
        future: add support for
            - [ ] 2, 4, 6, 8 digits
            - [ ] strip prefixes like 0x or #
            - [ ] alpha
            - [ ] int32
            - [ ] int64
            - [ ] as range
        */
        Len = Text.Length( source ),
        pairs = List.Split( Text.ToList( source ), 2 ),
        pairStrings = List.Transform( pairs, each Text.Combine(_, "") ),

        // Assert.ValidLength = List.Contains({2, 4, 6}, Len),
        // List.Transform( List.Split( source, 2 ), each Number.FromHexString(_) )
        components = [
            RgbHexStr = Text.Combine( {"#", RHex, GHex, BHex}, ""),
            RHex = pairStrings{0}?,
            GHex = pairStrings{1}?,
            BHex = pairStrings{2}?,
            // AHex = null,
            // A = null,
            R = Number.FromHexString( RHex ),
            G = Number.FromHexString( GHex ),
            B = Number.FromHexString( BHex ),

            RFloat = R / 255,
            GFloat = G / 255,
            BFloat = B / 255

        ],
        Assert.ValidLength = List.Contains({6}, Len),
        ret =
            if Assert.ValidLength then components
            else error [
                Message.Format = "Message #{0}",
                Message.Parameters = { source  }
            ]
            // List.Transform( List.Split( source, 2 ), each Number.FromHexString(_) )
        // List.Transform( List.Split( Text.ToList("feaa99"), 2  ), each Text.Combine(_, ""))

    ][ret]
in
    Rgb.FromHexString