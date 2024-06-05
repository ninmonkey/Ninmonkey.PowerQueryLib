let
 /*
     sugar to make it easier to embed powerquery as a string literal

        It replaces '␞' with double quotes '"'

        input : List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)
        output: List.SelectBySuffix( { {"2", "d"}, {"3", "h"} }, "h")
    */
        Format.DocExpand.Type = type function ( source as text )
            as text meta [
                Documentation.Name = "Format.DocExpand",
                Documentation.LongDescription = Text.Combine({
                    "A helper function to generate help strings without crazy escaping.",
                    "",
                    "Input:",
                    "",
                    "<code> = DocExpand( ""List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)"" )</code>",
                    "",
                    "Output:",
                    "",
                    "<code> = 'List.SelectBySuffix( { {""2"", ""d""}, {""3"", ""h""} }, ""h"")""'</code>",
                    "",
                    "returns type <code>text</code>"
                    }, "#(cr,lf)<br>")
            ],

        Format.DocExpand.Func = (source as text) as text =>
            Text.Replace( source, "␞", "#(0022)" )
in
    Value.ReplaceType( Format.DocExpand.Func, Format.DocExpand.Type )