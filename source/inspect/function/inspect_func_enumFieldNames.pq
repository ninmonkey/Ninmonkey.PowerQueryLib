let
    /*

    usually returns
        "Documentation.Name", "Documentation.Description", "Documentation.LongDescription", "Documentation.Category", "Documentation.Examples"
    */
    enumerate_fn_fieldName =
        (source as function) as list =>
        let
            target = Inspect.TypeMetadata( source ),
            target_md = target[TypeMetadata] //?? null
        in
            Record.FieldNames( target_md )
        ,
    test = enumerate_fn_fieldName( Web.Contents )
in
    test

