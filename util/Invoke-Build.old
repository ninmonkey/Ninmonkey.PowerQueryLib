function _iter0_Invoke-BuildPowerQueryLib {
    <#
    .synopsis
        Exports library as a single query, for import
    .description
        merge library into a single query, for import.
    .example
        PS> Invoke-BuildPowerQueryLib -path 'c:\stuff\source'
    .notes
        future
        - [ ] Parameters to exclude queries.
        - [ ] Param $BaseDirectory[] for multiple imports
    #>
    [CmdletBinding(
        # DefaultParameterSetName='sdf',
        PositionalBinding = $false
    )]
    param (
        # Basee / Root Directories to search
        [Alias('Path')]
        [Parameter(Position = 0)]
        [string]$BaseDirectory
    )

    Write-Host 'building...' -ForegroundColor darkgreen
    if ([string]::IsNullOrWhiteSpace($BaseDirectory)) {
        $BaseDirectory = Join-Path $PSScriptRoot '../source'
    }
    $Path = Get-Item -ea stop $BaseDirectory
    $ExportPath = Join-Path $PSScriptRoot '../.output/PowerQueryLib.pq' # | Get-Item -ea stop

    $Files = Get-ChildItem -Path $Path -Filter '*.pq' -Recurse
    $Now = Get-Date

    "abc$bdsf"

    $TemplateHeader = @"
/* PowerQueryLib
    Generated on: $($Now.ToShortDateString()) $($Now.ToShortTimeString())
    Source:
        https://github.com/ninmonkey/Ninmonkey.PowerQueryLib
        J. Bolton ninmonkeys@gmail.com
*/
"@

    <#
    target:
    let

        // then use 'drill down as new query' if you want the name to
        // be accessible without record syntax
        // this lets you import the entire lib in one go
        Source = [
            DatesText = DatesText,
            Times10 = Times10,
            ListAsText =
                let
                    x = 10
                in x,

            Magic = magic
        ]
    in
        Source

    #>
    $slist = [System.Text.StringBuilder]::new()
    $TemplateQueryPrefix = "`n`n## start ->"
    $TemplateQuerySuffix = "`n`n## <-- end"
    $LinePrefix = "`n`t"
    $TemplateFooter = "`n`n`t`t`t<footer here>"

    $QueryContents = $TemplateHeader
    $QueryContents += $TemplateQueryPrefix
    $slist.Append( $QueryContents )

    $QueryContents += $Files | ForEach-Object {
        $curFile = $_
        $Contents = Get-Content -Path $curFile -Encoding Utf8
        $Name = $curFile
        # 'let {0} =' -f $curFile.BaseName
        $TemplateQueryPrefix
        $Contents | ForEach-Object {
            $curLine = $_
            "${LinePrefix}${curLine}"
        }
        $Contents
        $Contents | Set-Content -Path temp:\dump.pq # debug

        Get-Content temp:\dump.pq
        $TemplateQuerySuffix

        # "`nin`n`t{0}," -f $curFile.BaseName
        # "`n`t,"
    }
    $QueryContents += $TemplateQuerySuffix
    $QueryContents += $TemplateFooter


    # $Files
    $QueryContents | Set-Content -Path temp:\dump.pq # debug
    $QueryContents
    | Set-Content -Path $ExportPath -Encoding 'utf8'

    $ExportPath = Get-Item -ea 'Stop' $ExportPath
    Write-Host "Saved: $($ExportPath)" -ForegroundColor green

    if ($Config.AutoOpenEditor) {
        code $ExportPath
    }

    Write-Host 'Done.' -ForegroundColor darkgreen
}

$LibRoot = Join-Path $PSScriptRoot 'source' | Get-Item -ea ignore
Invoke-BuildPowerQueryLib -BaseDirectory $LibRoot
