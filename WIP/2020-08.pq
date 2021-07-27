// IPDottedToDecimal
// IPDottedToDecimal
let
    /*

    input: DottedDecimal
        "192.168.1.0"
    output: Decimal [ 32-bit ]
        3232235776
    */
    fn_IPDottedToDecimal = (IPString as text) as number => let
        /*
        todo: error check
        - list length exactly 4
        - all are number convertable
        - all within 1 byte
        */
        TextList = Text.Split(IPString, "."),
        DecimalList = List.Transform(
            TextList,
            each Number.FromText(_, null)
        ),
        ByteString = Binary.FromList( DecimalList ),
        Decimal = BinaryFormat.UnsignedInteger32( ByteString )
    in
        Decimal

in fn_IPDottedToDecimal

// ConvertNumberToBytes
let
    ConvertNumberToBytes = (num as number, numBytes as number) as list => let
    /*
    input: 3232240641
    output: { 192, 168, 20, 1 }
    */


        byteString = List.Generate(
            () => 8 * (numBytes - 1),
            each _ >= 0,
            each _ - 8,
            (bits as number) =>
                Number.BitwiseAnd(
                    255,
                    Number.BitwiseShiftRight( num, bits )
                )
        )
    in
        byteString
in ConvertNumberToBytes

// IPDecimalToDotted
let
    IPDecimalToDotted = (DecimalIP as number) as text => let
    /*
    input:
        3232240641
    output:
        192.168.20.1
    */

    // ListOfDecimal = ConvertNumberToBytes(DecimalIP, 4),

    /* hard coded method */
        ListDecimal = {
            Number.BitwiseAnd(
                255,
                Number.BitwiseShiftRight( DecimalIP, 24 )),

            Number.BitwiseAnd(
                255,
                Number.BitwiseShiftRight( DecimalIP, 16 )),
            Number.BitwiseAnd(
                255,
                Number.BitwiseShiftRight( DecimalIP, 8 )),

            Number.BitwiseAnd(
                255,
                DecimalIP)
        }
    in
        ListAsIp( ListDecimal )

in IPDecimalToDotted
