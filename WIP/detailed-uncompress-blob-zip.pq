

https://community.powerbi.com/t5/Community-Blog/Working-With-Zip-Files-in-Power-Query/ba-p/1190186
// https://en.wikipedia.org/wiki/Zip_(file_format)#Structure

and
    https://blog.crossjoin.co.uk/2015/12/08/working-with-compression-in-power-query-and-power-bi-desktop/


(ZIPFile) =>
let
    //read the entire ZIP file into memory - we'll use it often so this is worth it
    Source = Binary.Buffer(File.Contents(ZIPFile)),
    // get the full size of the ZIP file
    Size = Binary.Length(Source),
    //Find the start of the central directory at the sixth to last byte
    Directory = BinaryFormat.Record([
                    MiscHeader=BinaryFormat.Binary(Size-6),
                    Start=BinaryFormat.ByteOrder(BinaryFormat.UnsignedInteger32, ByteOrder.LittleEndian)
            ]) ,
    Start = Directory(Source)[Start],
    //find the first entry in the directory and get the compressed file size
    FirstDirectoryEntry = BinaryFormat.Record([
                    MiscHeader=BinaryFormat.Binary(Start+20),

    ...

    see url