// Summarize_Record
let
    /*
    converts records into a string

        let
            source =
        in
            Summarize_Record(source)

    Example: Basic
        input:

            [ Name = "Dog", Age = 3, DogYears = 3*3 ],

        output: as text:
            '[ Age = 3, DogYears = 9, Name = "Dog" ]'

    Example: Values are converted using 'culture':
        input:
            [ now = DateTime.LocalNow(), utc = DateTimeZone.UtcNow(), culture = Culture.Current ]


        output as text:
            [ now = 1/7/2021 10:52:12 AM, utc = 1/7/2021 4:52:12 PM +00:00, culture = en-US ]

    Example3:
        options = [ separator = "#(lf,tab)", prefix = "[#(lf,tab)", suffix = "#(lf)]" ],

        output:

            [
                culture = en-US
                now = 1/7/2021 11:14:59 AM
                utc = 1/7/2021 5:14:59 PM +00:00
            ]

    when options[sort] = true
        in:
            [ Name = cat, Lives = 9 ]
        out:
            [ Lives = 9, Name = cat ]

    Example 4:
        in:
            [ Num = 123.45 ]

        with default
            [ Num = 123.45 ]

        with [ culture = "de-DE" ]
            [ Num = 123,45 ]


    */

    fn_Summarize_Record = (
        source as record,
        optional options as nullable record
    ) as text =>
        let
            // supports nested records
            // next: simplify parameter handling w/ Validate_OptionalArgRecord
            // future: support nested recursively?
            // future:  allow Text.From error to just place a default value



            outputPrefix = Text.From(options[prefix]? ?? "[ "),
            outputSuffix = Text.From(options[suffix]? ?? " ]"),
            outputSeparator = Text.From(options[separator]? ?? ", "),
            culture = options[culture]? ?? null,

            // outputSuffix = options[suffix]? ??  " ]",
            optionSort = options[sort]?  ?? true,

            _n = Record.FieldNames( source ),
            names = if optionSort then List.Sort(_n) else _n,


            pairs = List.Transform(
                names,
                (key as text) =>
                    let
                        value = Record.Field( source, key ),

                        valueIsRecord = Type.Is( Value.Type(value), type record),
                        flatValue =
                            if valueIsRecord then @fn_Summarize_Record( value, options )
                            else value,
                        pair = [
                            Key = key,
                            Value = flatValue
                        ]
                    in
                        pair
            ),
            flat_pairsAsText = List.Transform(
                pairs,
                (field as record) =>
                    field[Key] & " = "  & Text.From( field[Value], culture )
            ),

            transformPair = (field as record) as text =>
                let
                    result  = field[Key] & " = "  & Text.From( field[Value], culture )
                in
                    result,

                    // isRecord =
                    //     Value.Is(
                    //         type record,
                    //         Value.Type( field[Value] )
                    //     )
                // in
                //     if isRecord then
                //         //"[nested]"
                //         "<<" &
                //         @fn_Summarize_Record( field[Value] )
                //         & ">>"
                //     else


            pairsAsText = List.Transform(
                pairs,
                (field as record) => transformPair(field)
            ),
            x3 = outputPrefix & Text.Combine( pairsAsText, outputSeparator ) & outputSuffix
        in
            x3
in
    fn_Summarize_Record