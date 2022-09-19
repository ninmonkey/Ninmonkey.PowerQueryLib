let
/*
doc tips:

documentation on the types uses for documentation
    https://docs.microsoft.com/en-us/power-query/handlingdocumentation

from:
    https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata
> A note about Documentation.Name: This value should probably match the name of the identifier you assign your function when you define it. For example, if you call your function SomeFunction, then when you set Documentation.Name, you should probably set its value to “SomeFunction”, as well.

*/


    Text.ReplaceMany
        = ( source as text, mapping as list ) as text =>
            let
                result = List.Accumulate(
                    mapping, source,
                    ( state, cur ) => Text.Replace(state, cur{0}, cur{1} ))
            in
                result,
    Text.ReplaceMany.Type = type function(
        source as (
            type text meta [
                Documentation.FieldCaption = "source",
                Documentation.FieldDescription = "List to search and replace multiple values"
        ]),
        mapping as (type list meta[
            Documentation.FieldCaption = "List of {oldText, newText} replacement Pairs",
            Documentation.FieldDescription = "A list of {oldText, newText} pairs, to search and then replace values"
        ]))
        as (type text meta [
            Documentation.Name = "Text.ReplaceMany",
            Documentation.LongDescription = "A list of {oldText, newText} pairs,<br></br><br>#(cr,lf)#(cr,lf) to search and then replace values",
            Documentation.Examples = {[
                Description = "cat to emoji",
                Code = "{0..4}",
                Result = "none"
            ]}
        ])
in
    Value.ReplaceType( Text.ReplaceMany, Text.ReplaceMany.Type )