// fn_ValidateSchemaTest
let
    runTest = true,
    Sources = TestMismatchingDatattype, //#"📌auto-detected-type",
    Source_Wrong = Sources[SampleWrongColumnType],
    Source_Right = Sources[SampleWrongColumnType],
    validateSchema = (source as table) as table =>
        let
            selectColumns = {"Name", "Position", "TypeName", "Kind", "IsNullable"},
            firstValues = Table.First( source ),
            t0 = Table.Schema(source),
            t1 = Table.SelectColumns(t0, selectColumns),
            t2 = Table.AddColumn( t1, "Actual Type",
                (row) => Value.Type(  Table.Column( source, row[Name]){0}  ),
                Type.Type
            ),
            t3 = Table.AddColumn( t2, "Sample Value",
                (row) =>  Table.Column( source, row[Name] ){0}
            ),
            final = t3
        in
            final,


    test_case = validateSchema( Source_Wrong ),
    final = if runTest then test_case else validateSchema
in
    final