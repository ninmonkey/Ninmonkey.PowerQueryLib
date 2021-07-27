let
/*

output:

    As Column [Value]
    [ a = 10, c = 4 ]
    [ a = 93.45, b = 1/1/2031 ]
    [ a = [ a = 10, c = 4 ], b = [ b = 3 ] ]

    As Row itself
    [ As Column [Value] = [ a = 10, c = 4 ], Name = flat, Value = [ a = 10, c = 4 ] ]
    [ As Column [Value] = [ a = 93.45, b = 1/1/2031 ], Name = withdate, Value = [ a = 93.45, b = 1/1/2031 ] ]
    [ As Column [Value] = [ a = [ a = 10, c = 4 ], b = [ b = 3 ] ], Name = nested, Value = [ a = [ a = 10, c = 4 ], b = [ b = 3 ] ] ]`

*/
    r1 = [ a = 10, c = 4 ],
    r2 = [ b = 3 ],
    r3 = [ z = 9, a = 30 ],
    r4 = [ a = 93.45 , b = #date(2031, 1,1) ],
    r5 = [ a = r1, b = r2 ],
    tests_list = {
        [ arg1 = r1, arg2 = r2 ],
        [ arg1 = r1, arg2 = r3 ],
        [ arg1 = r2, arg2 = r3 ],
        [ arg1 = r1, arg2 = r3 ]
    },

    summarizeArgs = [
        flat = r1,
        withdate = r4,
        nested = r5
],
    t_summary = Record.ToTable(summarizeArgs),
    as_row = Table.AddColumn(
        t_summary, "As Column [Value]",
        (row) as text => Summarize_Record(row[Value]), type text ),

    as_self = Table.AddColumn(
        as_row, "As Row itself",
        (row) as text => Summarize_Record(row), type text ),
    final = as_self
in
    final

