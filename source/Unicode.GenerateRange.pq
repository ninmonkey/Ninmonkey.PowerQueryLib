let
/* wip: 
        [1] docstring
        [2] convertTo-BitString (where 1 byte per braile characte )
        [3] add help metadata
        

    future:
        - calculate number of bytes to represent that encoding 

    more:
        https://en.wikipedia.org/wiki/Braille_Patterns

    */
    Schema = [
        EncodingInfoTable = type table [
            Codepoint = Int64.Type,
            Hex = text,
            Rune = text, 
            BytesUtf8_B64 = text, 
            BytesUtf8_HexStr = text, 
            BytesUtf16le_HexStr = text,
            BytesUtf16be_HexStr = text,
            BytesWindows_HexStr = text,
            bytes_utf8 = binary
        ]
    ],

    Uni.EncodingInfo = ( codepoint as number ) as record =>
        [
            r = [
                Codepoint = codepoint,
                Hex = Number.ToText( codepoint, "x", "en-us" ),
                Rune    =
                    try Character.FromNumber( Codepoint )
                    catch (e) => null meta [
                        // M = e[Message],
                        ErrorRecord  = e,
                        Reason = 
                            if codepoint >= 0x00d800 and codepoint <= 0xdfff
                            then "Is a surrogate pair"
                            else error e
                    ],
                    
                BytesUtf8_B64    = Binary.ToText( bytes_utf8, BinaryEncoding.Base64 ),
                
                BytesUtf8_HexStr = Binary.ToText(
                    bytes_utf8, BinaryEncoding.Hex),
                
                BytesUtf16le_HexStr = Binary.ToText( 
                    Text.ToBinary( Rune, TextEncoding.Utf16 ),
                    BinaryEncoding.Hex ),

                BytesUtf16be_HexStr = Binary.ToText( 
                    Text.ToBinary( Rune, TextEncoding.BigEndianUnicode ),
                    BinaryEncoding.Hex ),

                BytesWindows_HexStr = Binary.ToText( 
                    Text.ToBinary( Rune, TextEncoding.Windows ),
                    BinaryEncoding.Hex ),

                bytes_utf8 = Text.ToBinary( Rune, TextEncoding.Utf8 )
            ]          
        ][r],
    
    /*
    generate the first N codepoints, with lots of info and stats
    */
    Unicode.GenerateRange = (start as number, end as number) as table =>
       [
            uni_records = List.TransformMany(
            {start..end},

            (codepoint) =>
                { Uni.EncodingInfo(codepoint) },

            (codepoint, info ) =>
                [ Codepoint = codepoint ] & info        
            ),

            FinalTable = Table.FromRecords( uni_records, Schema[EncodingInfoTable], MissingField.Error)            
        ][FinalTable] ,

    // jump to test surrogates Custom1 = Table.Skip(Final3, 55294)  
    Final = Unicode.GenerateRange( 0, #"Global Max Codepoint Range" )
in
    Final
