let
    // does source contain any of these substrings? True when at least one does
    // see also: List.MatchesAny: https://docs.microsoft.com/en-us/powerquery-m/list-matchesany
    // example using List.Transform() instead, because it's used often
    // see more: adding date popups <https://bengribaudo.com/blog/2021/09/21/6179/describing-function-record-parameters>
    // https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata#function-parameter-documentation
    // does source contain any of these substrings? True when at least one does
    // see also: List.MatchesAny: https://docs.microsoft.com/en-us/powerquery-m/list-matchesany
    // example using List.Transform() instead, because it's used often
    Text.MatchesAnyType = type function (
        message as (
            type text meta [
                Documentation.FieldCaption = "source",
                Documentation.FieldDescription = "Text to Search",
                Documentation.SampleValues = {"Hello world", "Bat"}
            ]
        ),
        searchStrings as (
            type list meta [
                Documentation.FieldCaption = "Strings to Search",
                Documentation.FieldDescription = "Search source, does it match any substrings? Case-insensitive by default",
                Documentation.SampleValues = {{"Hello", "at"}, {"world"}}
            ]
        ),
        // optional
        options as (
            type nullable record meta [
                Documentation.FieldCaption = "Additional arguments",
                Documentation.FieldDescription = "Toggle Case-Sensitive Comparer",
                Documentation.SampleValues = {
                    [Comparer = Comparer.OrdinalIgnoreCase], [Comparer = Comparer.Ordinal]
                    // null
                }
            ]
        )
    ) as (
        type logical meta [
            Documentation.Name = "Hello - Name",
            Documentation.LongDescription = "Hello - Long Description",
            Documentation.Examples = {
                [
                    Description = "Returns a table with 'Hello world' repeated 2 times",
                    Code = "HelloWorldWithDocs.Contents(""Hello world"", 2)",
                    Result = "#table({""Column1""}, {{""Hello world""}, {""Hello world""}})"
                ],
                [
                    Description = "Another example, new message, new count!",
                    Code = "HelloWorldWithDocs.Contents(""Goodbye"", 1)",
                    Result = "#table({""Column1""}, {{""Goodbye""}})"
                ]
            }
        ]
    ),
    Text.MatchesAnyImpl = (source as text, searchStrings as list, optional options as nullable record) as logical =>
        let
            options = Record.Combine({defaults, options ?? []}),
            defaults = [Comparer = Comparer.OrdinalIgnoreCase, Culture = "en-us"],
            matchingList = List.Transform(searchStrings, (string) => Text.Contains(source, string, options[Comparer]))
        in
            List.AnyTrue(matchingList),
    Text.MatchesAny = Value.ReplaceType(Text.MatchesAnyImpl, Text.MatchesAnyType)
in
    Text.MatchesAny
