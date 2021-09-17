// Text_IsNullOrWhitespace
let
    run_example = false,
    Text_IsNullOrWhitespace = (source as nullable text) as logical =>
        /* True when source only contains: null or whitespace or control chars

            [string]::IsNullOrWhitespace()
        */
        let
            trimClean = Text.Trim( Text.Clean( source ) ),
            len = Text.Length(trimClean)
        in
            source is null or len = 0,
    tests = {
        Text_IsNullOrWhitespace("#(tab)#(cr,lf)"),
        Text_IsNullOrWhitespace("     "),
        Text_IsNullOrWhitespace(""),
        Text_IsNullOrWhitespace(null)
    }
in
    if run_example then tests else Text_IsNullOrWhitespace