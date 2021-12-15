
/*
This should have a condition, that evaluates

input:
    "fooBarCat" => {"foo", "Bar", "Cat" }

maybe also split on non-word non-alpha
    "CatJenn34Fred$134" => {"Cat", "Jenn", "34", "Fred", "$124" }

*/
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Character Transition",{{"Column1.2", Int64.Type}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Changed Type",{{"Column1.1", Text.Proper, type text}}),


// let
//     uuid = Excel.CurrentWorkbook(){[Name="uuid"]}[Content]{0}[Column1],
//     profile = Excel.CurrentWorkbook(){[Name="profile"]}[Content]{0}[Column1],
//     apikey = Excel.CurrentWorkbook(){[Name="apikey"]}[Content]{0}[Column1],
//     Source = Json.Document(Web.Contents("https://api.hypixel.net/skyblock/profiles?key="&apikey&"&uuid="&uuid)),
//     profiles = Source[profiles],
//     profiles1 = profiles{profile},
//     members = profiles1[members],
//     #"Converted to Table" = Record.ToTable(members),
//     #"Expanded Value" = Table.ExpandRecordColumn(#"Converted to Table", "Value", {"crafted_generators"}, {"Value.crafted_generators"}),
//     #"Added Index" = Table.AddIndexColumn(#"Expanded Value", "Index", 0, 1, Int64.Type),
//     #"Expanded Value.crafted_generators" = Table.ExpandListColumn(#"Added Index", "Value.crafted_generators"),
//     #"Renamed Columns1" = Table.RenameColumns(#"Expanded Value.crafted_generators",{{"Value.crafted_generators", "Column1"}}),
//     #"Split Column by Character Transition" = Table.SplitColumn(#"Renamed Columns1", "Column1", Splitter.SplitTextByCharacterTransition((c) => not List.Contains({"0".."9"}, c), {"0".."9"}), {"Column1.1", "Column1.2"}),
//     #"Sorted Rows" = Table.Sort(#"Capitalized Each Word",{{"Column1.1", Order.Ascending}, {"Column1.2", Order.Ascending}}),
//     #"Replaced Value" = Table.ReplaceValue(#"Sorted Rows","_","",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Cavespider","Cave Spider",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","Cocoa","Cocoa Beans",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","DarkOak","Dark Oak",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","EnderStone","End Stone",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","HardStone","Hard Stone",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value6" = Table.ReplaceValue(#"Replaced Value5","MagmaCube","Magma Cube",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value7" = Table.ReplaceValue(#"Replaced Value6","NetherWarts","Nether Warts",Replacer.ReplaceText,{"Column1.1"}),
//     #"Replaced Value8" = Table.ReplaceValue(#"Replaced Value7","SugarCane","Sugar Cane",Replacer.ReplaceText,{"Column1.1"}),
//     #"Renamed Columns" = Table.RenameColumns(#"Replaced Value8",{{"Column1.1", "Minion"}, {"Column1.2", "Tier"}})
// in
//     #"Renamed Columns"