using namespace System.Text.StringBuilder;
#Requires -Version 7.0.0
#Requires -Module Dev.Nin, Ninmonkey.console

Import-Module Ninmonkey.Console, Dev.nin -wa ignore
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

        $Options['IncludeFile']
            is a list of $file.Name that are always imported
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
        # Base / Root Directories to search
        [Alias('Path')]
        [Parameter(Position = 0)]
        [string]$BaseDirectory,

        # ExportPath
        # [Alias('Path')]
        [Parameter()]
        [string]$ExportPath,

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
        [switch]$List,

        # extra options
        [Alias('Config')]
        [parameter()]
        [hashtable]$Options


    )
    begin {}
    process {
        try {
            $buildMeta = [ordered]@{
                StartTime = Get-Date
                Version   = $Config.AppVersion
            }
            '[Invoke-Build]: building...' | write-color darkgreen | Write-Information
            if ([string]::IsNullOrWhiteSpace($BaseDirectory)) {
                $BaseDirectory = Join-Path $PSScriptRoot '../source'
            }
            $Path = Get-Item -ea stop $BaseDirectory
            if(! $ExportPath ) {
                $ExportPath = Join-Path $PSScriptRoot '../.output/PowerQueryLib.pq' # | Get-Item -ea stop
            }

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
                if ( ($Options)?['IncludeFile'] -contains $_.Name ) {
                    $true; return
                }
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
                if ( ($Options)?['IncludeFile'] -contains $_.Name ) {
                    $true; return
                }

                foreach ($Regex in $ExcludeRegex) {
                    if ($_.Name -match $Regex) {
                        $false; return
                    }
                }
                $true; return
            }



            $BuildMeta += @{
                FilesSelected      = $filesSelected
                FilesSelectedCount = $filesSelected.Count
                FilesFiltered      = $FilesFiltered
                FilesFilteredCount = $FilesFiltered.Count
                FilesName          = $FilesFiltered | Join-String -sep ', ' -prop 'BaseName' -SingleQuote
                Options            = $Options
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
        Commit = "{2}",
        BuildArgIncludes = "{3}",
        BuildArgExcludes = "{4}"
    ],

'@
            $queryInfo = @(
                $Config.AppVersion
                $Now.ToString('o')
            (Get-GitCommitHash ) -replace '\r?\n', ''
                $IncludeRegex | Join-String -sep ', ' -SingleQuote
                $ExcludeRegex | Join-String -sep ', ' -SingleQuote
            )
            [void]$querysb.AppendFormat( $Template.Header, $queryInfo)

            $Template.RootBody = @'
    FinalRecord = [
        Lib = Metadata,
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
                $curSrc = Get-Content -Path $curFile -Raw

                '{0} = {1}' -f @(
                    $curFileBase
                    $curSrc -join "`n"
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
            $QuerySb | Set-Content -Path $ExportPath -Encoding 'utf8'
            $buildMeta
        }
        catch {
            Write-Error -ErrorRecord $_ 'Build {} failed'
        }
    }
    end {

        @(
            hr
            $clist = @{
                H1             = @{
                    Fg = 'orange'
                }
                BacktickCode   = @{
                    Bg = 'gray20'
                    Fg = 'gray75'
                }
                SubtleEmphasis = @{
                    Bg = 'gray20'
                    Fg = 'gray75'
                }
                SubtleDim      = @{ # de-emphasis

                    Fg = 'gray40'
                }
            }
            write-color $clist.H1.Fg -t 'Files filtered out: '
            $buildMeta.Files
            | Where-Object { $_ -notin $buildMeta.FilesFiltered }
            | Join-String -sep ', ' -SingleQuote:$false {
                $_.BaseName
                | write-color gray75 -bg gray20
            }
            # | Write-Information

            hr
            # | Write-Information
            $BuildMeta | Format-Dict
            # | Write-Information
            # | Write-Information
            hr

            # $ColorNames = @{
            #     SubtleEmphasis = @{ fg = gray75; bg = gray20; }
            # }


            $Options.Detailed = $false
            if (! $Options.Detailed) {
                write-color $clist.H1.Fg -t 'Files Exported: '
                $splat_backtick = $clist.SubtleEmphasis
                @(
                    $results.FilesFiltered
                    | Join-String -sep ', ' -SingleQuote:$false {
                        $_.BaseName
                        | write-color @splat_backtick
                    }
                )
                | Join-String
            }
            else {
                write-color $clist.H1.Fg -t 'Files Exported: '
                $splat_backtick = $clist.SubtleEmphasis
                @(
                    $results.FilesFiltered
                    | Join-String -sep ', ' -SingleQuote:$false {
                        @(
                            $_.BaseName | write-color @splat_backtick
                            ' {0:n2}' -f @(
                                Format-FileSize $_.Length
                            )
                        )
                    }
                )
                | Join-String
            }
            $ExportPath | write-color green | join-string -op (write-color yellow -t 'Wrote: ')

            '[Invoke-Build]: done' | write-color darkgreen
        ) | Write-Information

    }

}
