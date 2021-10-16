using namespace System.Text.StringBuilder;
#Requires -Version 7.0.0
#Requires -Module Dev.Nin, Ninmonkey.console

Import-Module Ninmonkey.Console, Dev.nin
$Config = @{
    AutoOpenEditor = $false
    AppVersion     = 0.1
}

function Invoke-BuildPowerQueryLib {
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
        PositionalBinding = $false
    )]
    param (
        # Basee / Root Directories to search
        [Alias('Path')]
        [Parameter(Position = 0)]
        [string]$BaseDirectory,

        # List of regex's that include files
        [Alias('Regex')]
        [Parameter(Position = 1)]
        [string[]]$IncludeRegex = '.*',

        # to ignore
        [Alias('RegexExclude')]
        [Parameter(Position = 1)]
        [string[]]$ExcludeRegex = '\.old\.pq',

        # show matching files, do not run
        [parameter()]
        [switch]$List


    )
    begin {}
    process {
        $buildMeta = [ordered]@{
            StartTime = Get-Date
            Version   = $Config.AppVersion
        }
        'building...' | write-color darkgreen | Write-Information
        if ([string]::IsNullOrWhiteSpace($BaseDirectory)) {
            $BaseDirectory = Join-Path $PSScriptRoot '../source'
        }
        $Path = Get-Item -ea stop $BaseDirectory
        $ExportPath = Join-Path $PSScriptRoot '../.output/PowerQueryLib.pq' # | Get-Item -ea stop

        $Files = Get-ChildItem -Path $Path -Filter '*.pq' -Recurse
        $Now = Get-Date

        $BuildMeta += @{
            BaseDirectory = $BaseDirectory
            Path          = $Path
            ExportPath    = $ExportPath
            Files         = $Files
            Now           = $Now
            Regex         = $IncludeRegex
            ExcludeRegex  = $ExcludeRegex
        }


        $filesSelected = $Files | Where-Object {
            foreach ($Regex in $IncludeRegex) {
                if ($_.Name -match $Regex) {
                    $True
                    return
                }
            }
            $false
            return
        }

        $FilesFiltered = $filesSelected | Where-Object {
            foreach ($Regex in $ExcludeRegex) {
                if ($_.Name -match $Regex) {
                    $false
                    return
                }
            }
            $true
            return
        }



        $BuildMeta += @{
            FilesSelected      = $filesSelected
            FilesSelectedCount = $filesSelected.Count
            FilesFiltered      = $FilesFiltered
            FilesFilteredCount = $FilesFiltered.Count
            FilesNames         = $FilesFiltered | Join-String -sep ', ' -prop 'BaseName' -SingleQuote
        }


        if ($List) {
            $FilesFiltered
            return
        }



        $TemplateHeader = @"
/* PowerQueryLib : v $($Config.AppVersion)
    Generated on: $($Now.ToShortDateString()) $($Now.ToShortTimeString())
    Source:
        https://github.com/ninmonkey/Ninmonkey.PowerQueryLib
        Jake Bolton ninmonkeys@gmail.com
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

    SB ref:
        Append | Adds text,
        AppendLine | Same plus newline
        AppendFormat | includes format string



    #>
        $ExportPath = Get-Item -ea 'Stop' $ExportPath

        $querySb = [System.Text.StringBuilder]::new()
        [void]$querySb.Append( $TemplateHeader )
        $Template = @{}

        $Template.Header = @'
let
    Metadata = [
        LastExecution = DateTime.FixedLocalNow(),
        PQLib = "{0}",
        GeneratedOn = "{1}",
        Commit = "{2}"
    ],

'@
        $queryInfo = @(
            $Config.AppVersion
            $Now.ToString('o')
            (Get-GitCommitHash ) -replace '\r?\n', ''
        )
        [void]$querysb.AppendFormat( $Template.Header, $queryInfo)

        $Template.RootBody = @'
    FinalRecord = [
{0}
    ]
in
    FinalRecord
'@

        # $querySB.AppendFormat(
        #     $Template.RootBody,
        # )
        #     'dfs'

        # 0 equals list
        # $curSrc = 'let Nin = 10 in Nin'
        # $curFileBase = 'Nin'
        # '{0} = {1}' -f @(
        #     $curFileBase
        #     $curSrc
        # )

        $joinedQueries = $FilesFiltered | ForEach-Object {
            $curFile = $_
            $curFileBase = '#"{0}"' -f @(
                $curFile.BaseName
            )
            $curSrc = Get-Content -Path $curFile

            '{0} = {1}' -f @(
                $curFileBase
                $curSrc
            )
        }
        | Join-String -sep ",`n"
        # | Format-IndentText -Depth 3

        $buildMeta.FinalText = $joinedQueries

        # $curSrc = 'let Nin = 90 in Nin'
        # $curFileBase = 'Bar'
        # '{0} = {1}' -f @(
        #     $curFileBase
        #     $curSrc
        # )

        [void]$querysb.AppendFormat( $Template.RootBody, $joinedQueries )
        # $querysb.AppendFormat( $Template.RootBody, $kwargs )



        "Saved: $($ExportPath)" | write-color green | Write-Information
        $QuerySb | Set-Content -Path $ExportPath -Encoding 'utf8'
        'Done.' | write-color darkgreen | Write-Information
        # $QuerySb | Set-Content -Path temp:\dump.pq # debug
        $buildMeta
    }
    end {

    }

}

$RegexIncludeList = @(
    'web'
)
$RegexExcludeList = @(
    '\.old\.pq$'
)

$splat_build = @{
    BaseDirectory = $LibRoot
    Infa          = 'Continue'
}

'start'
$LibRoot = Join-Path $PSScriptRoot 'source' | Get-Item -ea ignore
$results = Invoke-BuildPowerQueryLib @splat_build -IncludeRegex $RegexIncludeList -ExcludeRegex $RegexExcludeList
$Results | format-dict
'done'
# $ColorNames = @{
#     SubtleEmphasis = @{ fg = gray75; bg = gray20; }
# }
$fileNameColor = @(
    $results.FilesFiltered | Join-String -sep ', ' -SingleQuote:$false {
        $_.BaseName | write-color gray75 -bg gray20 }
)

$fileNameColor | Join-String -op 'Wrote: '