let
/* from: https://docs.microsoft.com/en-us/power-query/waitretry#putting-it-all-together */
    waitForResult = Value.WaitFor(
        (iteration) =>
            let
                result = Web.Contents(url, [ManualStatusHandling = {500}]),
                buffered = Binary.Buffer(result),
                status = Value.Metadata(result)[Response.Status],
                actualResult = if status = 500 then null else buffered
            in
                actualResult,
        (iteration) => #duration(0, 0, 0, Number.Power(2, iteration)),
        5)
in
    waitForResult