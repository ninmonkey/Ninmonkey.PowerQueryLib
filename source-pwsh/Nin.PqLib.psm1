using namespace System.Collections.Generic
#Requires -Version 7



function Format-AsPQListLiteral {
    [cmdletBinding()]
    [outputtype('String')]
    param(
        # future: calculated property as a joiner
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$InputText,

        [alias('Name')]
        [string]$ListName
    )
    begin {
        $Items = [list[string]]::new()
    }
    process {
        $items.AddRange( $InputText )
    }

    end {
        $js_PQLiteralSep = @{
            Separator   = ', '
            DoubleQuote = $true
            Property    = { $_ }
        }

        $js_PQListBody = @{
            OutputPrefix = $ListName ? "`$${ListName} = { " : '{ '
            OutputSuffix = ' } '
            Property     = { $_ }
        }
        0..4 | Format-AsPQListLiteral

        $Items
        | Join-String @js_PQLiteralSep
        | Join-String @js_PQListBody
    }
}

Export-ModuleMember -Function Format-AsPQListLiteral
<# --- should be seeparate -- #>
# Get-Culture -ListAvailable
# | s -First 10
# | Join-String -Separator ', ' -DoubleQuote { $_.Name }
# | Join-String -op 'names = { ' -os ' } ' { $_ }