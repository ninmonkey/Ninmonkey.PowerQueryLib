/*

    this code is terrible on purpose.
    it's meant to stress syntax highlighting

        Foo.bar( , )
            Table.List( Tbar.Casdf(...) )

    )
    */
let
    a = Table.List,
    b = Table(),
    now = #duration(0,0,0,1), t = #table( type table[ Id = Int64.Type, Nested = Table.Type], {} ),
    r = Table.Combine({null, #"Some.Stepame"( ... ) }),
    r2 = Table.Combine(
        {null, #"Some.Stepame"( ... ) }
    ),
    r3 = {null, #"Some.Stepame"( ... ) }, // #"Table.List"#".List",
    [ fd = List.Bar( List.Transform( {9..4}, each _ + 3 ), ), When = DateTime.FixedLocalNow() ],
    // c = List.Generate(...) ],
    zed = List.Transform( source, (item) => item * 3 ) + Bar.FromText( " Table.List(" & "..". ),
    /*
        Text.Type, TA.A.Wfd,
        Text.Type
        */
    l  = TA.A.Wfd(),
    l3 = T.Wfd(),
    l4 = T.WfA(),
    l2 = TA.AWfd(),
    T.L.P = List.Count,
    j = T.L(...), q = T.L.P( ),
    q1 = #"List."( each 0, each _ < 1, each _ ),
    z = table.list(df),
    #" Table.List(bar Table.List({3,45,5}))",
    q = foo.bar(sdf),
    z = Bcat( { 234 } ),
    z2 = Bcat(),
    g = Table.Bar(dsf)


in z2