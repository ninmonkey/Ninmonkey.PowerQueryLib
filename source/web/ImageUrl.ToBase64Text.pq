let
    /*
        given a web url to an image
        convert it to base64 text in a format expected by browsers
        and Power BI Columns

        todo future: add gif, svg, etc
    */
    Image.ToBase64Text = (imageUrl as text) as any => [
            bytes = Web.Contents( imageUrl ),
            bytesAsText = Binary.ToText( bytes, BinaryEncoding.Base64 ),

            mime_prefix =
                if Text.EndsWith( imageUrl, ".png", Comparer.OrdinalIgnoreCase )
                then
                    "data:image/png;base64, "
                else if (
                    Text.EndsWith( imageUrl, ".jpeg", Comparer.OrdinalIgnoreCase ) or
                    Text.EndsWith( imageUrl, ".jpg",  Comparer.OrdinalIgnoreCase )
                )
                then
                    "data:image/jpg;base64, "
                else
                    error [
                        Message.Format = "Unhandled Image type: {0}",
                        Message.Parameters = { imageUrl } ],

            return = mime_prefix & bytesAsText

        ][return]

in Image.ToBase64Text