let
    combine_web_request = let
    /* a wrapper of Web.Contents with default values
        returns: response, HTTP StatusCode, and requestMetadata
    */
    webRequest = (
        staticPath as text, relativePath as text,
        optional query as nullable record,
        optional asRaw as nullable logical,
        optional headers as nullable record
    ) as any =>
        let
            query = query ?? [],
            asRaw = asRaw ?? false, // toggles calling Json.Document() or not
            headers = headers ?? [
                Accept="application/json"
            ],

            baseUrl = staticPath,
            options = [
                RelativePath = relativePath,
                Headers = headers,
                Query = query
                // ManualStatusHandling = {400, 404}
            ],
            // wrap 'Response' in 'Binary.Buffer' if you are using it multiple times
            response = Web.Contents(staticPath, options),
            metadata = Value.Metadata(response),
            buffered = Binary.Buffer(response),
            result = Json.Document(buffered)
        in
            [
                response = if asRaw then buffered else result,
                status_code = metadata[Response.Status],
                metadata = metadata
            ],

    response_locations = webRequest(
        "https://www.metaweather.com",
        "api/location/search",
        [ lattlong = "36.96,-122.02" ]
    ),
    location_schema = type table[
        distance = number, title = text,
        location_type = text, woeid = number, latt_long = text
    ],

    cityListing = Table.FromRecords(response_locations[response], location_schema, MissingField.Error),
    requestColumn = Table.AddColumn(
        cityListing,
        "LocationWeather",
        (row as record) as any =>
            let
                woeid = Text.From(row[woeid]),
                response = webRequest(
                    "https://www.metaweather.com",
                    "api/location/" & woeid,
                    []
                )
            in
                response,
        type any
    ),
    #"Expanded LocationWeather" = Table.ExpandRecordColumn(requestColumn, "LocationWeather", {"response"}, {"response"}),
    #"Expanded response" = Table.ExpandRecordColumn(#"Expanded LocationWeather", "response", {"consolidated_weather", "time", "sun_rise", "sun_set", "timezone_name", "parent", "sources", "timezone"}, {"consolidated_weather", "time", "sun_rise", "sun_set", "timezone_name", "parent", "sources", "timezone"}),
    #"Expanded consolidated_weather" = Table.ExpandListColumn(#"Expanded response", "consolidated_weather"),
    #"Expanded consolidated_weather1" = Table.ExpandRecordColumn(#"Expanded consolidated_weather", "consolidated_weather", {"id", "weather_state_name", "weather_state_abbr", "wind_direction_compass", "created", "applicable_date", "min_temp", "max_temp", "the_temp", "wind_speed", "wind_direction", "air_pressure", "humidity", "visibility", "predictability"}, {"id", "weather_state_name", "weather_state_abbr", "wind_direction_compass", "created", "applicable_date", "min_temp", "max_temp", "the_temp", "wind_speed", "wind_direction", "air_pressure", "humidity", "visibility", "predictability"})
in
    requestColumn,
    #"Expanded LocationWeather" = Table.ExpandRecordColumn(combine_web_request, "LocationWeather", {"response"}, {"response"}),
    #"Expanded response" = Table.ExpandRecordColumn(#"Expanded LocationWeather", "response", {"consolidated_weather"}, {"consolidated_weather"}),
    #"Expanded consolidated_weather" = Table.ExpandListColumn(#"Expanded response", "consolidated_weather"),
    #"Expanded consolidated_weather1" = Table.ExpandRecordColumn(#"Expanded consolidated_weather", "consolidated_weather", {"id", "weather_state_name", "weather_state_abbr", "wind_direction_compass", "created", "applicable_date", "min_temp", "max_temp", "the_temp", "wind_speed", "wind_direction", "air_pressure", "humidity", "visibility", "predictability"}, {"id", "weather_state_name", "weather_state_abbr", "wind_direction_compass", "created", "applicable_date", "min_temp", "max_temp", "the_temp", "wind_speed", "wind_direction", "air_pressure", "humidity", "visibility", "predictability"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded consolidated_weather1",{{"applicable_date", type date}, {"created", type datetimezone}})
in
    #"Changed Type"