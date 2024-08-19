
// Someone asked for a way to auto expand xml columns
// hard coded example filter
Table.AutoExpandTableColumn = (source as table, columnName as text ) => 
    let 
        allNames = Table.ColumnNames( source ),        
        filteredNames = List.Select( allNames, (item) => 
            not Text.StartsWith( item, "http://", Comparer.OrdinalIgnoreCase ) ),

        prefixedNames = List.Transform( filteredNames, each expandColumnName & "." & _ ),            
        return = Table.ExpandTableColumn( source, columnName, allNames, filteredNames )
    in 
        return
