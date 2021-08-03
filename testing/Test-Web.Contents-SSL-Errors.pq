// clean
let
    /*

    see more:
        - https://docs.microsoft.com/en-us/power-query/handlingstatuscodes
        - https://docs.microsoft.com/en-us/power-query/waitretry
        - https://docs.microsoft.com/en-us/power-query/handlingstatuscodes#authentication-exceptions
            401, 403 are special


    */
    UseMinimal = false,
    RequestOptions =  [
        // Timeout = // as duration: default is 100ms
        // IsRetry = true, // true: means ignore cached response
        // ManualStatusHandling = {400,401,403,404,429,500,503}
        ManualStatusHandling = {200..299} & {400..599} // didn't seem to ever throw an exception

    ],
    sslList = {
        "https://httpbin.org/",
        "https://wrong.host.badssl.com/",
        "https://expired.badssl.com/",
        "http://www.somefakenamedoesnotexist.com"
    },

    // statusCodes = List.Transform(
    //     { {400, 401, 402} & {200..230} & {300..350} }, each _
    //     // each (i) as text =>
    //     //     "https://httpbin.org/status/" & i
    // ),
    statusCodes = {202, 404, 400, 500, 503, 501},
    statusUrlList = List.Transform( statusCodes,
        each "https://httpbin.org/status/" & Text.From(_)
    ),


    urlList = sslList & statusUrlList,

    responseList = List.Transform(
        urlList,
        (url as text) as any =>
            // Binary.Buffer(
                Web.Contents( url, RequestOptions )
            // )
    ),

    // Get metadata for a Web.Contents call
    WebRequest_ToRecord = (response as binary) as record  =>
        let
            metaData = Value.Metadata( response ),
            maybeErr = try metaData[Content.Type],
            // metaData2 = try Value.Metadata( response ),

            r2 = Record.AddField(metaData, "Binary", response, null ),
            r3 = Record.AddField(r2, "Response.Error",
                if maybeErr[HasError] then maybeErr[Error] else null,
                null
            ),
            r4 = Record.AddField(r3, "Url", metaData[Content.Uri]() )
        in
            r4,

    WebRequest_Table.Type = type table[
        Content.Type = text,
        Content.Uri = Function.Type,
        Content.Name = text,
        Headers = record,
        Request.Options = record,
        Response.Status = number, // always?
        Response.Error = record,
        Binary = binary,
        Url = text
    ],

    metaDataList = List.Transform(
        responseList,
        each WebRequest_ToRecord(_)
    ),

    t1 = Table.FromRecords(
        metaDataList,
        WebRequest_Table.Type,
        MissingField.Error
    ),
    #"Expanded Response.Error" = Table.ExpandRecordColumn(
        t1,
        "Response.Error",
        {"Reason", "Message", "Detail"},
        {"Error.Reason", "Error.Message", "Error.Detail"}
    ),
    FinalMinimal = Table.SelectColumns(
        #"Expanded Response.Error",
        {"Url", "Response.Status", "Error.Reason", "Error.Message", "Error.Detail"}
    ),
    FinalTable =
        if UseMinimal then FinalMinimal
        else #"Expanded Response.Error"
in
    FinalTable