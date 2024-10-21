let
    // I updated the code from 5:57 at <https://www.youtube.com/watch?v=L3xfWiMSMiA&t=357s>
    
    base_url           = "http://localhost:11434",
    prompt             = "do llama magic",
    DoubleQuote        = """",  // or: "#(0022)"
    EscapedDoubleQuote = "\""", // or: "\#(0022)"

    // 
    Text.EscapeQuote = (string as text) => 
        Text.Replace( string, DoubleQuote, EscapedDoubleQuote ),

    // sugar to call the API
    // I updated the original requestBody to use standard power query
    // that saves you having to manually write json and adding quoted strings
    Llama.Request = ( prompt as text ) => 
        let 
            json = [
                model = "llama3.2:latest",
                // escaping might be redundant because of Json.FromValue
                // I left it in so you could test it 
                prompt = Text.EscapeQuote( prompt ),
                stream = false
            ],
            return = Web.Contents( 
                base_url,
                [ 
                    // this encodes to bytes using Text.Encoding.Utf8 by default
                    Content      = Json.FromValue( json ),
                    RelativePath = "api/generate",
                    Headers      = [
                        #"Content-Type" = "application/json"
                    ],
                    ManualStatusHandling = {200..299}
                ]
            )
        in
            return,

    // inspect the Status code, headers, requestUrl, etc....
    Web.InspectResponse = (response as binary) as record => [
        Bytes       = response,
        HadError    = StatusCode <> 200,
        StatusCode  = Meta[Response.Status],
        ContentType = Meta[Content.Type],
        RequestUrl  = Meta[Content.Uri](),
        Meta        = Value.Metadata( Bytes ),
        AsJson      = 
            try Json.Document( Bytes, TextEncoding.Utf8 )
            catch (e) => null,
        
        RawText     = Text.FromBinary( Bytes, TextEncoding.Utf8 )
    ],
    
    Test =  [ 
        response = Llama.Request( prompt ),    
        Info     = Web.InspectResponse( response ),

        // for a comparison, here's a public JSON response, no auth needed
        Info2    = Web.InspectResponse( Web.Contents( "https://httpbin.org/json" ) ),

        RawInfo  = Value.Metadata( response ) // here's the base data that Web.InspectResponse uses
    ]
in
    Test
