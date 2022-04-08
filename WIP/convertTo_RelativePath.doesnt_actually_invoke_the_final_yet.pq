convertTo_RelativePath = (source as text, optional options as nullable record) =>
        /*
        todo:
            - [ ] attempt to resolve using the longest replacements first
            - [ ] optional username
        */
        let 
            userName = options[Name]? ?? "c:\users\cppmo_000",
            replacements = {
                [
                    From = "C:\Users\cppmo_000\SkyDrive\Documents",
                    To = "$Env:UserProfile\SkyDrive\Documents"
                ],
                [
                    From = "C:\Users\cppmo_000",
                    To = "$Env:UserProfile"
                ],
                [
                    From = "C:\Users\cppmo_000\AppData\Roaming",
                    To = "$Env:AppData"
                ]
            },
            // silly inline example
            remapUser = List.Transform(
                replacements,
                (item) =>
                    let 
                        after = Text.Replace( item[From]?, "c:\users\cppmo_000", userName )
                    in 
                        Record.Combine({
                            item,
                            [From = after]
                        })
            ),


            final = ...
        in
            if false then final else [                
                replacements = replacements,
                remapUser = remapUser,
                final = final,
                source = source, 
                other = "fds"
            ],
    tests = [
        appdata_roam = convertTo_RelativePath( "C:\Users\cppmo_000\AppData\Roaming" ),
        docs = convertTo_RelativePath( "C:\Users\cppmo_000\SkyDrive\Documents" )
    ],