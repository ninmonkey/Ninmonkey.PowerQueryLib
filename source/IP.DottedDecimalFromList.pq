
/*

Input:
    ListAsIp( {192, 168, 5, 85} )
Output:
    192.168.5.85
*/
let
    IP.DottedDecimalFromList = (num as list) as text => let
        isValid = try if List.Count(num) = 4 then
            true
        else
            Error.Record(
                "Bad value", "Expected list length of 4", ListAsText(num)
            ),
        string = ListAsText(num, ".", "", "")
    in
        if isValid[HasError] then
            isValid[Error]
        else
            string

in
    fnListAsIp
