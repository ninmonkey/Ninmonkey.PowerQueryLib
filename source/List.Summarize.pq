// ListAsText
/*

options:
    Suffix type: text    default: "{"
    Prefix type: text    default: "{"
    Separator   type: text    default: {

Note:

*/
let
    List.Summarize = (
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
    List.Summarize