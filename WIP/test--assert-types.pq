FinalResult = 1,

    Assert.TypeIs = (source as any, expected as type) as any =>
        <#

            primitive type is compatible?
                Should.BeOfType( #date(2020, 10, 10), type date ) //# true
                Should.BeOfType( #date(2020, 10, 10), type datetime ) // #

            primitive type is exactly of type
        #>

    // todo:
        ...,

