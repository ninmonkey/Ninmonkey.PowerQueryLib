let
    // This function is WIP
    Assert.ColumnsExist = (source as table, requiredNames as list) as any => [ // as logical => [
        // refactor and export this func to shared
        config = [
            // DetailedOutput = true,
            // CaseSensitiveCompare = true
            // CultureComparer = null
        ],
        // details = [// ],
        actualCols  = List.Buffer( Table.ColumnNames( source ) ),
        missingCols = List.RemoveItems( requiredNames, actualCols ),
        extraCols   = List.RemoveItems( actualCols, requiredNames ),

        conditionsUsingSchema = [
                Source          = Table.Schema( source ),
                SortedRows      = Table.Sort(Source,{ { "TypeName", Order.Ascending } } ),
                FindTypeAnyRows = Table.SelectRows(SortedRows, each ( [Kind] = "any" ))
            ],

        // todo future: make names case insensitive using config
        shouldThrow = List.Count( missingCols ) > 0,
        FinalAssertStatement =
            if not shouldThrow then true
            else error [
                Message.Format = Text.Combine({
                    "Assert: ColumnsExist failed! Target: #[Source], To find: #[ToFind]",
                    "ActualCols: #[ActualCols]",
                    "MissingCols: #[MissingCols]",
                    "ExtraCols: #[ExtraCols]"
                }, "#(cr,lf)" ),
                Message.Parameters = [
                    ToFind      = requiredNames,
                    Source      = source,
                    ActualCols  = actualCols,
                    MissingCols = missingCols,
                    ExtraCols   = extraCols
                ] ],
        // return = FinalAssertStatement,
            return = [
                WipNotes             = error "NYI",
                FinalAssertStatement = FinalAssertStatement,
                MissingCols          = missingCols,
                ExtraCols            = extraCols,
                ActualCols           = actualCols
            ]

            // if config[DetailedOutput] then details
            // else FinalAssertStatement
            // error "NYI, successfull stand alone bool"
        // Table.SelectColumns( Source, ExpectCols, MissingField.Error ),
        // finalCondCondition =
        //     try a catch (e) =>
        //     error e
        // ][return],
        ][return]

in Assert.ColumnsExist