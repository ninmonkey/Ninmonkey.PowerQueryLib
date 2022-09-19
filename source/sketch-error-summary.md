- [base](#base)
- [cleaner?](#cleaner)
- [copy  ?](#copy--)
## base 

## cleaner?

```pq
let
    Source = OData.Feed("https://services.odata.org/v4/TripPinService/"),
    People = Source{[Name="People"]}[Data],
    SelectColumns = Table.SelectColumns(People, {"UserName", "FirstName", "LastName"}),

    TestUrls = {    
        "https://services.odata.org/v4/TripPinService/Me",
        "https://services.odata.org/v4/TripPinService/GetPersonWithMostFriends()",
        "https://services.odata.org/v4/TripPinService/People"
    },

    queries = List.Transform( TestUrls, 
        (query) => [
            Query = query, 
            Response = try OData.Feed(query) catch (e) => e
        ]
    ),
    queries_summary = Table.FromRecords( queries, type table[Query = text, Response = any] ),
    Str = [
        NullSymbol = "#(2400)",
        NL = "#(cr,lf)"
    ],

    Template = [
        BasicError = Text.Combine({
            "Reason:  #[Reason]",
            "Message: #[Message]"
            // "Format:  #[Formatted]"
            
        }, Str[NL]),

        FullError = Text.Combine({            
            // "Reason:  #[Reason]",
            // "Message: #[Message]",
            // "Msg.Fmt: #[detail]",
            // "Msg.Arg: #[detail]",
            ""
        }, Str[NL])
    ],
    FormatErrorBasic = (source as record) as text =>
        let 
            // reason = source[Reason]? ?? Str[NullSymbol],
            renderFormat = 
                try Text.Format( source[Message.Format], source[Message.Parameters] )                
                // catch (e) => e,
                catch (e) => e[Message],

            render = Text.Format(
                Template[BasicError], 
                [
                    /* future keys: 
                        Reason, Message, Detail, Message.Format,  Message.Parameters
                    */
                    Reason = source[Reason]? ?? Str[NullSymbol],
                    Message = source[Message]? ?? Str[NullSymbol],
                    Formatted = renderFormat ?? Str[NullSymbol]
                ]
            )
            // Custom2 = (source as record) as any => Text.Format( source[Message.Format], source[Message.Parameters] )
            in
                render,
    
    RenderSummary = [
        Basic_Args = ErrSource2,
        Basic = FormatErrorBasic(ErrSource2)
    ],
    Summary = [
        Source = Source,
        People = People, 
        SelectColumns = SelectColumns,
        TestUrls = TestUrls,
        queries = queries,
        queries_summary = queries_summary

    ],
    queries_summary1 = Summary[queries_summary],
    #"Added Custom" = Table.AddColumn(queries_summary1,
        "DataSourceErrorMessage",
        (row) =>
            let 
                IsError = row[Response][Reason]? = "DataSource.Error",
                render = FormatErrorBasic( row[Response] ),
                fin = if IsError then render else ""
            in 
                fin,

            type text
    )

in 
    #"Added Custom"
```

```pq
let
    Source = OData.Feed("https://services.odata.org/v4/TripPinService/"),
    People = Source{[Name="People"]}[Data],
    SelectColumns = Table.SelectColumns(People, {"UserName", "FirstName", "LastName"}),

    TestUrls = {    
        "https://services.odata.org/v4/TripPinService/Me",
        "https://services.odata.org/v4/TripPinService/GetPersonWithMostFriends()",
        "https://services.odata.org/v4/TripPinService/People"
    },

    queries = List.Transform( TestUrls, 
        (query) => [
            Query = query, 
            // Response = try OData.Feed(query) catch (e) => "Failed" & e
            Response = try OData.Feed(query) catch (e) => "Failed" & e
        ]
    ),
    queries_summary = Table.FromRecords( queries, type table[Query = text, Response = any] ),
    Summary = [
        Source = Source,
        People = People, 
        SelectColumns = SelectColumns,
        TestUrls = TestUrls,
        queries = queries,
        queries_summary = queries_summary

    ],
    queries_summary1 = Summary[queries_summary],
    #"Added Custom" = Table.AddColumn(queries_summary1, "Custom", each try [Response] catch (e)=>e),
    Custom1 = Table.AddColumn(queries_summary1, "Custom", each try [Response] catch (e)=> e ),
    Custom = Custom1{1}[Custom],
    Detail = Custom[Detail],
    ErrSource2 = Detail[Right],
    Custom2 = (source as record) as any => Text.Format( source[Message.Format], source[Message.Parameters] ),
    Str = [
        NullSymbol = "#(2400)",
        NL = "#(cr,lf)"
    ],

    Template = [
        MinError = Text.Combine({
            "Reason:  #[Reason]",
            "Message: #[Message]"            
        }, Str[NL]),
        Min2Error = Text.Combine({
            "Reason:  #[Reason]",
            "",
            "Message: #[Message]"            
        }, Str[NL]),
        BasicError = Text.Combine({
            "Reason:  #[Reason]",
            "Message: #[Message]",
            // "",
            "Format:  #[Formatted]"
            
        }, Str[NL]),

        FullError = Text.Combine({            
            // "Reason:  #[Reason]",
            // "Message: #[Message]",
            // "Msg.Fmt: #[detail]",
            // "Msg.Arg: #[detail]",
            ""
        }, Str[NL])
    ],
    FormatErrorBasic = (source as record, optional options as nullable record) as text =>
        let 
            // reason = source[Reason]? ?? Str[NullSymbol],
            /*
                renderFormat usually equals Message
                but is that always true?
            */
            template = 
                options[Template]? ?? Template[BasicError],
            renderFormat = 
                try Text.Format( source[Message.Format], source[Message.Parameters] )                
                // catch (e) => e,
                catch (e) => e[Message],

            render = Text.Format(
                template, 
                [
                    Reason = source[Reason]? ?? Str[NullSymbol],
                    Message = source[Message]? ?? Str[NullSymbol],
                    Formatted = renderFormat ?? Str[NullSymbol]
                ]
            )
            // Custom2 = (source as record) as any => Text.Format( source[Message.Format], source[Message.Parameters] )
            in
                render,
        

    RenderSummary = [
        Basic_Args = ErrSource2,
        Min = FormatErrorBasic(ErrSource2, [Template = Template[MinError]]),
        Min2 = FormatErrorBasic(ErrSource2, [Template = Template[Min2Error]]),
        Duplicates = FormatErrorBasic(ErrSource2)
    ]
in
    RenderSummary
```

## copy  ?

```pq
let
    Source = OData.Feed("https://services.odata.org/v4/TripPinService/"),
    People = Source{[Name="People"]}[Data],
    SelectColumns = Table.SelectColumns(People, {"UserName", "FirstName", "LastName"}),

    TestUrls = {    
        "https://services.odata.org/v4/TripPinService/Me",
        "https://services.odata.org/v4/TripPinService/GetPersonWithMostFriends()",
        "https://services.odata.org/v4/TripPinService/People"
    },

    queries = List.Transform( TestUrls, 
        (query) => [
            Query = query, 
            // Response = try OData.Feed(query) catch (e) => "Failed" & e
            Response = try OData.Feed(query) catch (e) => "Failed" & e
        ]
    ),
    queries_summary = Table.FromRecords( queries, type table[Query = text, Response = any] ),
    Summary = [
        Source = Source,
        People = People, 
        SelectColumns = SelectColumns,
        TestUrls = TestUrls,
        queries = queries,
        queries_summary = queries_summary

    ],
    queries_summary1 = Summary[queries_summary],
    #"Added Custom" = Table.AddColumn(queries_summary1, "Custom", each try [Response] catch (e)=>e),
    Custom1 = Table.AddColumn(queries_summary1, "Custom", each try [Response] catch (e)=> e ),
    Custom = Custom1{1}[Custom],
    Detail = Custom[Detail],
    ErrSource2 = Detail[Right],
    Custom2 = (source as record) as any => Text.Format( source[Message.Format], source[Message.Parameters] ),
    Str = [
        NullSymbol = "#(2400)",
        NL = "#(cr,lf)"
    ],

    Template = [
        MinError = Text.Combine({
            "Reason:  #[Reason]",
            "Message: #[Message]"            
        }, Str[NL]),
        Min2Error = Text.Combine({
            "Reason:  #[Reason]",
            "",
            "Message: #[Message]"            
        }, Str[NL]),
        BasicError = Text.Combine({
            "Reason:  #[Reason]",
            "Message: #[Message]",
            // "",
            "Format:  #[Formatted]"
            
        }, Str[NL]),

        FullError = Text.Combine({            
            // "Reason:  #[Reason]",
            // "Message: #[Message]",
            // "Msg.Fmt: #[detail]",
            // "Msg.Arg: #[detail]",
            ""
        }, Str[NL])
    ],
    FormatErrorBasic = (source as record, optional options as nullable record) as text =>
        let 
            // reason = source[Reason]? ?? Str[NullSymbol],
            /*
                renderFormat usually equals Message
                but is that always true?
            */
            template = 
                options[Template]? ?? Template[BasicError],
            renderFormat = 
                try Text.Format( source[Message.Format], source[Message.Parameters] )                
                // catch (e) => e,
                catch (e) => e[Message],

            render = Text.Format(
                template, 
                [
                    Reason = source[Reason]? ?? Str[NullSymbol],
                    Message = source[Message]? ?? Str[NullSymbol],
                    Formatted = renderFormat ?? Str[NullSymbol]
                ]
            )
            // Custom2 = (source as record) as any => Text.Format( source[Message.Format], source[Message.Parameters] )
            in
                render,
        

    RenderSummary = [
        Basic_Args = ErrSource2,
        Min = FormatErrorBasic(ErrSource2, [Template = Template[MinError]]),
        Min2 = FormatErrorBasic(ErrSource2, [Template = Template[Min2Error]]),
        Duplicates = FormatErrorBasic(ErrSource2)
    ]
in
    RenderSummary
```