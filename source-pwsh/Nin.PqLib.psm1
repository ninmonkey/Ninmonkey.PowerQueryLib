using namespace System.Collections.Generic
#Requires -Version 7

function Convert-PqLibTableFromPaste {
    <#
    .SYNOPSIS
        In Power BI you can click a table and choose "copy". This the table from your clipboard
    .EXAMPLE
        Pwsh> Convert-PqTableFromClipboard -Contents $Text
        # outputs table
    .EXAMPLE
        # first copy your table in PBI, then
        Pwsh> Convert-PqTableFromClipboard
        # outputs table
    #>
    [Alias(
        'Convert-PqTableFromPaste',
        'Convert-PqTablePaste'
    )]
    [cmdletBinding()]
    [outputtype('[PSCustomObject[]]')]
    param(
        [string[]]$Contents
    )

    $convertFromCsvSplat = @{
        Delimiter = "`t"
    }
    $Data = $Contents -join "`n"
    if( -not $PSBoundParameters.ContainsKey('Contents') ) {
        $data = Get-Clipboard -Raw # | Join-String -sep "`n"
    }

    $table = $data | ConvertFrom-Csv @convertFromCsvSplat
    if($Table.count -eq 0) {
        'Tried importing table as a TSV. Convert failed, zero rows were returned' | Write-error
        return
    }
    $Table
}


function Format-PqLibPQListLiteral {
    [Alias('Format-PqListLiteral')]
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

function Update-PqLibBestPracticeAnalyzerRules {
    <#
    .SYNOPSIS
        fetch some best practice rules
    .link
        https://github.com/microsoft/Analysis-Services/tree/master/BestPracticeRules
    .LINK
        https://docs.tabulareditor.com/te3/views/bpa-view.html?tabs=TE3Rules
    #>
    [Alias(
        'Update-PqLatestBestPracticeRules'
    )]
    param(
        # Where to save the files, otherwise use local folder
        [ValidateScript({throw 'nyi'})]
        [ArgumentCompletions(
            'AppData',
            'LocalAppData',
            '$Env:LocalAppData'
        )]
        [Parameter()]
        [string]$DestinationPath
    )


@'
Sources:
  - https://raw.githubusercontent.com/microsoft/Analysis-Services/master/BestPracticeRules/BPARules.json
  - https://github.com/m-kovalsky/Tabular/blob/e43f62cedef06befaad80564c3062cafe8b7ba2d/BPA/BPAScanFolder.cs
'@
    | Write-host

    $invokeWebRequestSplat = @{
        Uri = 'https://raw.githubusercontent.com/microsoft/Analysis-Services/master/BestPracticeRules/BPARules.json'
    }

    Invoke-WebRequest @invokeWebRequestSplat

    throw 'wip: Use WhatIf to confirm writing to AppData'
}
