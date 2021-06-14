
// ListAsText
/*

options:
    Suffix      type: text
    Prefix      type: text
    Separator   type: text

Note:
    The original serializes **everything**
    This only shows type names as text

*/
let
    Serialize.List =  (
        values as list,
        optional options as nullable record
    ) as text => let
        Separator = options[Separator]? ?? ", ",
        Prefix    = options[Prefix]? ?? "{",
        Suffix    = options[Suffix]? ?? "}",
        joined    = List.Accumulate(
            values, "",
            (seed, item) =>
                if seed = "" then Text.From(item)
                else seed & Separator & Text.From(item)),

        output = Prefix & joined & Suffix
    in
        output
in
    Serialize.List
