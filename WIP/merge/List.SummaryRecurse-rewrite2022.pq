let

    // Text.FromBinary( Json.FromValue( item , TextEncoding.Utf8 ) , TextEncoding.Utf8 ),
    // Generates type name by expecting Text.From to throw,
    // Then using the serialized name in the exception
    // if that fails, final fallback string is "<␀>" null symbol
    // write warning: does not work on type table, ewtc. so maybe I have the wrong param
    Value.TypeNameAsText = (source as any) =>
            let
                typeInfo =
                    try
                        Text.From(Value.Type(source))
                    catch (e) =>
                        e[Message.Parameters]?{0}?
                        ?? "<#(00002400)>"
            in
                typeInfo,

    // recursively summarize a list as a string
    List.Summary = (source as list, optional options as nullable record) as text =>
        let
            options = Record.Combine({ defaults, options }),
            defaults = [Culture = "en-us", Encoding = TextEncoding.Utf8, Prefix = "{ ", Suffix = " }", Delimiter = ", " ],
            culture = options[Culture],

            items_asText = List.Transform(
                source,
                (item) => try Text.From(item, culture) catch (e) =>
                    if Type.Is(Value.Type(item), Record.Type) then // placeholder
                        Text.FromBinary( Json.FromValue( item , options[Encoding] ) , options[Encoding] )
                    else if Type.Is( Value.Type(item), List.Type ) then
                        let
                            render =
                                try @List.Summary( item , culture )
                                catch (e2) =>
                                    error Error.Record(
                                        "NestedInvokeException", "Depth X and X+1 threw:"
                                        [ Exception = e, InnerException = e2 ]
                                    )
                            in
                                options[Prefix] & render & options[Suffix]

                    else if Value.Type(item, Type.Type) then
                        Value.TypeNameAsText( item )
                    else
                        "<#(00002400)>" ),
            combinedText = Text.Combine( items_asText, options[Delimiter])
        in combinedText,


    tests = [
        t0 = List.Summary(  { 0, 3, { 9, 8 } }),  // output: 0, 3, 9, 8,
        t1 = List.Summary( {DateTime.LocalNow(), 0.345, {0..4}, [a = "b"]} ),
        t3 = List.Summary( {
            {DateTime.LocalNow(), 0.345, {0..4}, [a = "b"]},
            {DateTime.LocalNow(), 0.345, {99..80}, [F = "b"]}
        })
    ]
    /*
    outputs:

        t3 = { 6/11/2022 11:58:28 AM, 0.345, { 0, 1, 2, 3, 4 }, [...] }, { 6/11/2022 11:58:28 AM, 0.345, {  }, [...] }
    */
in
    tests