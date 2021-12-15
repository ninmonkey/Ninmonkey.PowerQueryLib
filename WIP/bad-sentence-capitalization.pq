// Sample (2)
let
    Raw = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("bVXZjhtHDPwVYp8H8wN+MtYOYMBJHCRIHhZ+oHooiUYfs30IWH+9i90zIy0QYIXVwaNYVeS8vDz9c9VCXwp9y2mVTM9cZKYv8fHzRJ9vkt/ov5QXC33mVSt7/SnL/DSNCvgrEqtEJ+R6jT+jf6N6FTprLpW81Ip66UzC7noPRqJ7rPd9enn6mrIE0rW0QEvyKVPRShykTuRSLOKq1IZqvOiqxWm8kHitM32UKBwRFEJaEnm9NM8kF6mj0BERuBSe6RkdSnIKFJFrem1Cq+CdnlohJAW+RPy24LVyri0rcFNIAF8mpBQHIJmyLuqaR05oZaZPKYqj18aBzsCFyOZrVqeCNuIm9PDeCCjWUBq+yFIVWF6bRRcJM/3RPKD3cVGpDsQ9gCRq2Lussgj9aKWmic4ZTKil3cRPBEpRv46Wt+bXVrlKZwM/Zte60FZsL5CvKTpM0RCgAfovinxGNlgzWgrdIBUc0RM2kBBJXW3bsJhngArJ28dtNOtV0TpT1eh0aRFyPWcGuZD/ZLT9qzcOxruXAHZMGjEQBAn0UO5hEC96lrhQBZ1WYIvwsisPYlOuVSssZDTf2dzGOEowKBq0fjTWMJPvJmSAnnaIpBFUKJYh8ybVWdpFuXO0o/h2hf/t7REau5QNGsIt+Jqz4p9ndBCw8BcqmRFyq9mI2sY4BJjpc1UgejARCDGNidulidk480nNiV0Pl7LR9j4eYqHGWIWmtrh910bpTfiZfmdxULpgmrC2sk818kDfops0W0Y367D6JpbXk2R4aV/ZxyW12Cg2a5FlLPiA1QvEFqHCyTO61GFh35wxtjZ/08h5oivEypLxuy7T0OgBtC1EWjTZ6ppyd69t8+xb0+WnAlklmjAD9IPNz9zccOVm8b54VnNX45gvZaeDH5S4Zz76/JMlw5Yz/Y2572saGBel3EtFPV13iCUt7KFd4YtWg2S3iEeFw8dTN3tvfsIIcen3rCdOwxzGI8q7lgswDYr7LJfMN114lKWgxBsLM/3WcNf+b9EGYdhUKXYiPbqtLaOu6QfJHSLzMLOdkO0CQGvcyhRbCG9dtr4GB7PsXAvF9nac/dj9OW7D3cIAiMMCi8NLDy44uHwHqms/nh9r1mDPp3gXpgu2OQvEjR5osaaChwqeX+2kXrlvlXywG8nOMA3eAOTdM8gzrK08Fur7Lw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Sample = _t, Expected = _t]),
    
    Source = Table.TransformColumns(Raw,{{"Sample", Text.Upper, type text}}),

    zText_ProperSentence = (source as text) as any =>
        let 
            s1 = Text.Lower(source),
            s2 = Text.Split(s1, "."),
            s3 = List.Transform(
                s2,
                (item) => Text.Upper( Text.Start(item, 1)   ) & Text.RemoveRange(item, 0, 1)
            ),
            fin = Text.Combine(s3, ".")
        in 
            [
                s1 =  s1,
                sa = Value.Type(s1),
                s2 =  s2,
                sab = Value.Type(s2),
                s3 =  s3,
                sac = Value.Type(s3),
                fin = fin
            ],
    test = Text_ProperSentence( "This Is Proper Case. In Proper Case, Every Word Is Capitalized. "),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Sample", type text}, {"Expected", type text}}),
    #"Lowercased Text" = Table.TransformColumns(#"Changed Type",{{"Sample", Text.Lower, type text}}),
    Custom1 = test,

    source2 = Text.Lower( Source[Sample]{0} ),
    firstSentence = Text.Split( source2, "." ){0},

    firstLetter = Text.Upper( Text.Start( firstSentence, 1 ) ),
    rest  = Text.RemoveRange( firstSentence, 0, 1 ),
    oneFinal = firstLetter & rest,



    Text_CapitalizeLine = (source as text) as any => //text =>
        let
            firstLetter =  Text.Upper( Text.Start( source, 1 ) ),
            rest = Text.RemoveRange (source, 0, 1 )
        in 
            firstLetter & rest,


    tProp = Text_CapitalizeLine("dsfiewafd ajf fjaoifeifj"),
    tsen = Text_ProperSentence("This Is Proper Case. In Proper Case, Every Word Is Capitalized."),

    Text_ProperSentence = (source as text) as any => // as text =>
        let
            sentences = Text.Split(source, "."),
            proper = List.Transform(
                (item) => Text_CapitalizeLine(item)
            ),
            finalResult = Text.Combine(proper, "."),
            f = [
                sentences = sentences,
                proper = proper,
                finalResult = finalResult
            ]
        in 
            f,
            // finalResult,


    
    

    strSample = Text.Split(
        source2, "."
    ),

     
    // list.Transform(
                // s2,
                // (item) => Text.Upper( Text.Start(item, 1)   ) & Text.RemoveRange(item, 1)
            // ),

    final = [
        tProp = tProp,
        tsen = tsen,
        firstLetter = firstLetter,
        rest = rest,
        strSample = strSample,
        fs = firstSentence,
        source2 = source2
    ],
    Custom2 = final,
    Custom3 = Source,
    #"Uppercased Text" = Table.TransformColumns(Custom3,{{"Sample", Text.Upper, type text}}),
    #"Uppercased Text1" = Table.TransformColumns(#"Uppercased Text",{{"Sample", Text_ProperSentence, type text}}),
    Custom4 = #"Uppercased Text1",
    Custom5 = tsen,
    Error = Custom5[Error]
in
    Error