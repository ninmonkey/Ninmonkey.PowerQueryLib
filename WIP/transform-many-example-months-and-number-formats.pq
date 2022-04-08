// let
//         b = List.TransformMany(
//             {1..12},
//             (x) => {
//                 #date(2016, x, 1)
//             },
//             (x, y) =>
//                 [ x =  x, y = y, z = Date.MonthName( y ) ]
//         ),
//         b2 = List.TransformMany(
//             {1..12},
//             (x) => {
//                 #date(2016, x, 1)
//             },
//             (x, y) =>
//                 Table.FromRecords(
//                     {
//                         [ x =  x, y = y, z = Date.MonthName( y ) ]
//                     }
//                 )
//         ),
//         b_t = Table.FromRecords( b ),
//     Summary = [
//         b = b2,
//         a = b_t
//     ]
// in
//     Summary
// also many unit test?

let
    a = List.TransformMany(
            {1..12},
            (x) => {
                #date(2016, x, 1)
            },
            (x, y) =>
                Text.Combine(
                    {
                        Number.ToText(x), " - ",
                        Text.Lower(Date.MonthName( y ))
                    }, ""
                )
        ),
        b = List.TransformMany(
            {1..12},
            (x) => {
                #date(2016, x, 1)
            },
            (x, y) =>
                [ x =  x, y = y, z = Date.MonthName( y ) ]
        ),
        b_t = Table.FromRecords( b )
in
    b_t