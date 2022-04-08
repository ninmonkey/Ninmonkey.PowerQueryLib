let
    /* go from int -> binarystr, and back */

    listIpDec = {192, 168, 5, 85},
    nums = [
        a = Byte.From( listIpDec{0} ),
        b = Byte.From( listIpDec{1} ),
        c = Byte.From( listIpDec{2} ),
        d = Byte.From( listIpDec{3} )
    ],

    // both work
    byteStringIp = #binary(listIpDec),
    byteStringIpFromList = Binary.FromList(listIpDec),

    // bytes to 32bit int
    UInt32 = BinaryFormat.UnsignedInteger32( byteStringIp ),

    // FailByteRead = Int32.From(byteStringIp, null, RoundingMode.Down),
    // fromfromint = Byte.From(binUint32) //Binary.From(binUint32)

    // t = byteStringIpFromList( fromfromint ),

    // binary to list of integers
    ListFormatByteString = BinaryFormat.List(BinaryFormat.Byte),
    listIntFromByteString = ListFormatByteString( byteStringIp ),

    Summary = [
        listIpDec = ListAsText( listIpDec ),
        //  z = #binary(binUint32),
        byteStringIp = byteStringIp,
        ListFormatByteString = ListFormatByteString,
        listIntFromByteString = ListAsText( listIntFromByteString ),
        UInt32 = UInt32,
        nums = nums
    ]
in
    Summary
