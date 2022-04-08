let
    Binary_ToBase64 = (bytes as binary) as text =>
        /*
        About:      2021-04-22
            encode any file to base64

        future: include metadata of file as meta? or return a record?
        */
        let
            encodedText = Binary.ToText( bytes, BinaryEncoding.Base64 )
        in
            encodedText

 in
    Binary_ToBase64