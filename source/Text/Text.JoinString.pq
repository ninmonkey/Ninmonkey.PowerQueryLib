let
    /*
    About: Join a string with a delimiter, prefix, and suffix
    It was written as an example for using optional record parameters


    For more advanced joins, checkout these collections of functions:
        - Write.Html.module.pq
        - String.Builder.module.pq

    */
    Text.JoinString = (strings as list, optional options as record) as text => let
            Prefix    = options[Prefix]?    ?? "",
            Suffix    = options[Suffix]?    ?? "",
            Delimiter = options[Delimiter]? ?? ","
        in
            Prefix & Text.Combine( strings, Delimiter ) & Suffix
in
    Text.JoinString

//     Examples = [

//         names = {"Jen", "Hubert", "Nobody", "Somebody" },

//         Default       = Text.JoinString( names ) ,

//         AsCsv         = Text.JoinString( names, [ Delimiter = ", "] ),

//         AsTablePipes  = Text.JoinString( names, [
//             Prefix = "| ", Delimiter = " | ", Suffix = " |" ] ),

//         AsBullets     = Text.JoinString( names, [
//             Prefix    = " #(2022) ",
//             Delimiter = " #(cr,lf) #(2022) "
//         ])
//     ]
// in
//     Examples
