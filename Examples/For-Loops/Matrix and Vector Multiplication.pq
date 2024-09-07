
// query: Source
section Section1;

Source =
// query: Source. Shared input data
    [
        Matrix = #table(
            {"ColA", "ColB", "ColC", "ColD"}, {
                {3, 1, 4 ,3},
                {4, 3, 2 ,2},
                {5, 4, 4 ,1},
                {6, 5, 4 ,3},
                {7, 6, 2 ,1}
            }),
        Vector =
            #table({"ColA", "ColB", "ColC", "ColD"}, {
                {2, 3, 3, 2}
            })
    ];

HardCoded =
// query: Hardcoded Version
    let
        TableA = Source[Matrix],
        TableB = Source[Vector],

        applyRow = (row as record, vector as any) => [
            vector =
                if vector is record then vector
                else Table.First( vector ),

            return = [
                ColA = row[ColA] * vector[ColA],
                ColB = row[ColB] * vector[ColB],
                ColC = row[ColC] * vector[ColC],
                ColD = row[ColD] * vector[ColD],
                Sum = ColA  + ColB + ColC + ColD
            ][Sum]
        ][return],

        Result = Table.TransformRows(
            TableA,
            (row) => applyRow( row, TableB )
        ),

        Summary = [
            Matrix = Source[Matrix],
            Vector = Source[Vector],
            Result = Result,
            Sum = List.Sum( Result )
        ]
    in
        Summary;

Dynamic =
// query: Dynamic number of columns version
let
    TableA = Source[Matrix],
    TableB = Source[Vector],
    // TableB = Table.SelectColumns( Source[Vector], {"ColA", "ColB"} ), // uncomment to trigger error on purpose


    // multiply a table matrix with by vector
    // vector can be a table or record
    MatrixVectorDot = (matrix as table, vector as any) => [
        vector = // ensure it's a record
            if vector is record then vector
            else Table.First( vector ),

        vectorList = List.Buffer( Record.ToList( vector ) ),
        vectorLen   = List.Count( vectorList ),

        applyRows = Table.TransformRows(
            matrix,
            (row) => calcRow( row )
        ),

        calcRow = (row as record) as number => [
            rowList  = Record.ToList( row ),
            rowLen   = List.Count( rowList ),
            products = List.Transform(
                { 0 .. ( vectorLen - 1 ) },
                (pos) =>
                    rowList{pos} * vectorList{pos}
            ),

            return =
                if rowLen <> vectorLen then error [
                    // allow them to drill down and inspect exact values that caused the error
                    Message.Format     = "Matrix row and Vector Len are not equal! row #{0} and Vector #{1}",
                    Message.Parameters = { rowList, vectorList }
                ] else
                    List.Sum( products )
        ][return],
        return = applyRows
    ][return],
    // ], // toggle to debug/inspect every row's value

    Summary = [
        TableA = TableA,
        TableB = TableB,
        Result = MatrixVectorDot( TableA, TableB ),
        FinalValue = List.Sum( Result )
    ]
in
    Summary;