using namespace System.Text.StringBuilder;
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
        [string]$BaseDirectory
    )
    begin {}
    process {
        $buildMeta = @{
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

        $Template.RootBody = @'
let
    Metadata = [
        LastExecution = DateTime.FixedLocalNow(),
        PQLib = 0.1
    ],

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

        [string[]]$qArgs = @(
            # 0 equals list
            'Nin = 10'
        )
        [void]$querysb.AppendFormat( $Template.RootBody, $qArgs )
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

'start'
$LibRoot = Join-Path $PSScriptRoot 'source' | Get-Item -ea ignore
$results = Invoke-BuildPowerQueryLib -BaseDirectory $LibRoot -Infa Continue
$Results | format-dict

'done'