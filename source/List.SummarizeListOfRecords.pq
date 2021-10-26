let
    Summarize.ListOfRecord = (source as any) as any  =>  // text
        let
            // x = source{0},
            // result = Record.Summarize(x),
            listOfRecords = source,
            listOfText = List.Transform(source, each Record.Summarize(_)),
            finalSummary = List.Summarize(listOfText)
        in
            finalSummary,


    fin = Summarize.ListOfRecord
in
    fin