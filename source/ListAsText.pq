/*

Description:

alias: SummarizeList() or ListAsText()

see:
    Serialize.List()

*/
let
    ListAsText =  (values as list, optional separator as nullable text, optional prefix as nullable text, optional suffix as nullable text) as text => let
        separator = separator ?? ", ",
        prefix = prefix ?? "{",
        suffix = suffix ?? "}",
        joined = List.Accumulate(values, "",
            (seed, item) =>
                if seed="" then Text.From(item)
                else seed & separator & Text.From(item)),
        output = prefix & joined & suffix
    in
        output
in
    ListAsText
