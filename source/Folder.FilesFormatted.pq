// Folder_FilesFormatted
let
    /*
    About:
        calls Folder.Files(path) , then cleans up the resulting table
    
    - simplifies and sorts the default table
    - adds filename Full Path, and Binary Metadata (In addition to Attributes)
    - ignores temp files

    Example
        = Folder_FilesFormatted( Folder.Files("c:\foo\bar") ) 

    Example
        options = [ keepAllColumns = true, noCustomColumns = true ],
        Source = Folder_FilesFormatted(
            Folder.Files("c:\foo\bar"), options
        ) 

    note:
        at first it was going to take a filepath then return the results
            but to make it work easier with data source privacy I'm trying out passing the table

    I could use 'source as any' to use both behaviors.
    */
    fnFolder_FilesFormated =
        (source as table, optional options as nullable logical) as table =>
            let
                keepAllColumns = options[keepAllColumns]? ?? false,
                // don't remove default columns
                // noCustomColumns = options[noCustomColumns]? ?? false, // disables addind new columns: Table.AddColumns
                /*
                The current Api returns these columns:
                    Attributes, Content, Date accessed, Date created, Date modified,
                    Extension, Folder Path, Name
            */
                #"Remove Extra Columns" =
                    let
                        // experimenting with half on formatting and alignment
                        t = Table.SelectColumns(
                                source,
                                { "Date modified", "Attributes", "Folder Path", "Name", "Content" })
                    in
                        if keepAllColumns then source
                        else t,
                        
                #"Hide Temp Files" = Table.SelectRows(
                        #"Remove Extra Columns",
                        (row) =>
                            not Text.StartsWith(row[Name], "~$")
                    ),

                #"Add Binary Metadata" = Table.AddColumn(
                        #"Hide Temp Files",
                        "Binary Metadata",
                        (row) as record =>
                            Value.Metadata(row[Content]),
                        type record
                    ), #"Add Full Path" = Table.AddColumn(
                        #"Add Binary Metadata",
                        "Full Path",
                        (row) as text =>
                            row[Folder Path] & row[Name],
                        type text
                    ),

                #"Reorder Columns" = Table.ReorderColumns(
                        #"Add Full Path",
                        { "Name", "Full Path", "Date modified", "Attributes", "Binary Metadata", "Folder Path", "Content" } ),

                #"Sorted Rows" = Table.Sort(
                    #"Reorder Columns", {
                        { "Date modified", Order.Descending },
                        { "Name", Order.Ascending }
                    }
                ),
                FinalTable = #"Sorted Rows"
            in
                FinalTable
in
    fnFolder_FilesFormated