// Regex_Replace
let
    Source =
        (string as nullable text, pattern as text, optional replacement as text, optional modifiers as text) =>
            let
                Source =
                    "<html><body><script>
        var x = '"
                    & Text.Replace(
                        Text.Replace(
                            Text.Replace(string, "'", "\'"),
                            "#(lf)",
                            "\n"
                        ),
                        "#(cr)",
                        "\r"
                    )
                    & "';
        var z = '"
                    & (
                        if modifiers <> null then
                            modifiers
                        else
                            ""
                    )
                    & "';
        var y = new RegExp('"
                    & Text.Replace(pattern, "\", "\\")
                    & "',z);
        var a = '"
                    & (
                        if replacement <> null then
                            replacement
                        else
                            ""
                    )
                    & "'
        var result = x.replace(y,a);
        document.write('<pre>' + result + '</pre>')
    </script></body><html>",
                WebPage = Web.Page(Source),
                Data = WebPage{0}[Data],
                Children = Data{0}[Children],
                Children1 = Children{[Name = "BODY"]}[Children],
                Children2 = Children1{[Name = "PRE"]}[Children],
                Text = Children2{0}[Text]
            in
                Text,
    documentation = [
        Documentation.Name = "RegexReplace",
        Documentation.Category = "",
        Documentation.Author = "reddit.com/u/tirlibibi17",
        Documentation.Description = "A generic regular expression replacement function based on the Javascript replace() method. Adapted from https://www.thebiccountant.com/2018/04/25/regex-in-power-bi-and-power-query-in-excel-with-java-script/. #(lf)See https://www.w3schools.com/jsref/jsref_obj_regexp.asp for Javascript regular expression reference and https://www.regular-expressions.info/ for general regular expression information.",
        Documentation.Examples = {
            [
                Description = "Pattern without capturing groups",
                Code = "RegexReplace(""The quick brown fox jumps over the lazy dog"", ""the quick brown fox"",""Da fox"",""i"")",
                Result = "Da fox jumps over the lazy dog"""
            ],
            [
                Description = "Pattern that does not match",
                Code = "RegexReplace(""The quick brown fox jumps over the lazy dog"", ""the quick brown fox"",""Da fox"")",
                Result = "The quick brown fox jumps over the lazy dog"
            ],
            [
                Description = "Pattern with capturing groups",
                Code = "RegexReplace(""The quick brown fox jumps over the lazy dog"", ""the quick brown (.*?) jumps over the ([^ ]*) ([^ ]*)"", ""THE QUICK BROWN $1 JUMPS OVER THE $2 $3"", ""i"")",
                Result = "THE QUICK BROWN fox JUMPS OVER THE lazy dog"
            ]
        }
    ]
in
    Value.ReplaceType(
        Source,
        Value.ReplaceMetadata(
            Value.Type(Source),
            documentation
        )
    )