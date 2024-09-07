let
    // multiply a table matrix with by vector
    // vector can be a table or record
    // example: <https://github.com/ninmonkey/Ninmonkey.PowerQueryLib/tree/main/Examples/For-Loops/Matrix%20and%20Vector%20Multiplication.pq>
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
    ][return]
in
    MatrixVectorDot