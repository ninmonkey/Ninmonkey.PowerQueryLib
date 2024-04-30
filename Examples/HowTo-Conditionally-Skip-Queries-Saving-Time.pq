let
    /*
    See more: 
    
    - [Dynamic, Lazy Records](https://bengribaudo.com/blog/2021/08/09/5941/dynamic-lazy-records)

    */
    // example showing that Api1() isn't always called
    // if they are called, it will delay for 3 seconds to simulate a query or web request
    // skip load ends up skipping the query, and the 3 second delay
    delay   = #duration(0,0,0, 3),

    SkipLoad = true,

    
    // sleep for delay Seconds and return a string
    Api1 = () => Function.InvokeAfter( 
        () => "Api1 finished", delay ),

    // for fun, this version uses a string template to create the error rmessage 
    Api2 =() => Function.InvokeAfter( 
        () => 
            Text.Format(
                "Api2 finished, at #[dt]", 
                [ dt = DateTime.LocalNow() ]
            ), 
            delay ),

    
    // the important part of the query:
    ApiList = { Api1(), Api2() },
    Query2 = { "some", "Fallback" },
    Final = if SkipLoad = true then Query2 else ApiList
in
    Final
