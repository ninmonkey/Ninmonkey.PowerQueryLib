using namespace System.Collections.Generic
#Requires -Version 7

Import-Module Pansies

$script:Color = @{
    Fg    = '#47c589'
    Green = '#47c589'
    H1    = '#fea9aa'
    Red   = '#fea9aa'
}


function Find-PqLibSources {
    <#
    .SYNOPSIS
        find files, summarize the counts. You can filter by regex
    .example

    #>
    [Alias('Find-PqSources')]
    [OutputType( [System.IO.FileInfo[]] )]
    param(
        # Root directory to search
        [Parameter(Mandatory)]
        [string]$RootDir,

        # regex to match against
        [Alias('Patterns')]
        [string[]]$Regex,

        # Like -Regex but this matches the end of the base file name (ignoring extension )
        [Alias('RegexStart')]
        [string[]]$StartsWith,

        # Like -Regex but this matches the start of the base file name)
        [Alias('RegexEnd')]
        [string[]]$EndsWith,

        # Filetype
        [ArgumentCompletions( "'*.pq'", "'*.m'", "'*.powerquery'" )]
        [string]$GciFilter = '*.pq'
    )
    $ResolvedRoot  = Get-Item -ea 'stop' $RootDir
    $query = Get-ChildItem -path $ResolvedRoot $GciFilter -Recurse

    'Found {0} .pq files under the root path: "{1}"' -f @(
        $query.count
        $ResolvedRoot
    ) | Write-host -fg $Color.Fg

    $WasPassedAnyRegexParam = $Regex.count -gt 0 -or $StartsWith.Count -gt 0 -or $EndsWith.count -gt 0
    $orig = $query

    if( $WasPassedAnyRegexParam ) {

        write-warning 'partial match not quite working'
        [pscustomobject]@{
            ReCount    = $Regex.Count -gt 0
            StartCount = $StartsWith.count -gt 0
            EndCount   = $EndsWith.count -gt 0
        } | ft -auto | out-string | Join-string -sep "`n"  | write-host

        $query =
            $query | Where-Object {
                $curFile = $_
                # Conditionally compare against a list of regexes
                # only include files that match 1 or more of the patterns
                # finally emits 0 or 1 boolean
                $tests = @(
                    if($Regex.Count -gt 0) {
                        @( $Regex ).Where(
                            { $curFile.Name -match $_  }, 'first', 1 )
                    }

                    if($StartsWith.count -gt 0) {
                        @( $StartsWith ).Where(
                            { $curFile.BaseName -match '^' + $_  }, 'first', 1)
                    }
                    if($EndsWith.count -gt 0) {
                        @( $EndsWith ).Where(
                            { $curFile.BaseName -match $_ + '$'  }, 'first', 1)
                    }
                )
                $tests.where({ $_ }, 'first', 1)
            }
        'Filtered down to {0} files, using the regex: {1}, RegexStart: {2}, RegexEnd: {3}' -f @(
                $query.count
                $Regex      ?? '' | Join-String -sep ', ' -SingleQuote
                $StartsWith ?? '' | Join-String -sep ', ' -SingleQuote
                $EndsWith   ?? '' | Join-String -sep ', ' -SingleQuote

            ) | Write-host -fg $Color.Fg
    }

    if($query.count -eq 0 ) { write-error 'Zero matches found after applying filters' }

    $query
}

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

function GetNativeCommand {
    <#
    .SYNOPSIS
      slow lookup using Get-Command. See also: FastGetNativeCommand
    #>
    [OutputType('String')]
    param(
        [string]$CommandName,
        [Alias('TestExists')]
        [switch]$TestIfExists)

    # was:
    if( -not ( FastGetNativeCommand -Name $CommandName -TestIfExists)) {

        Join-String -in $CommandName -f 'FastGetNativeCommand did not find command: {0}'
            | write-error
    }

    $query = $ExecutionContext.InvokeCommand.
        GetCommandName( $CommandName, $false, $true ).Where({$_},'first')

    if($TestIfExists) { return $query.count -gt 0 }
    $query
}
function FastGetNativeCommand {
    <#
    .SYNOPSIS
        Returns the first path, or, null if no commands are found. ( false is super fast compared to Get-Command -Commandtype Application ) . see also: GetNativeCommand
    #>
    [OutputType('String')]
    param(
        # full paths are allowed
        [ArgumentCompletions(
            "'git'", "'pwsh'",
            "''C:\Program Files\Git\cmd\git.exe'" )]
        [Alias('FullName')]
        [string]$CommandName,

        [Alias('TestExists', 'AsBool', 'TestOnly')]
        [switch]$TestIfExists, # this param setname has output type [bool]

        # normally allow silent failures that emit nothing. this forces a throw.
        [Alias('AssertExists')]
        [switch]$ThrowIfMissing
    )

    $Query = $ExecutionContext.InvokeCommand.
        GetCommandName( $CommandName, $false, $true ).Where({$_},'first')

    [bool] $HasNoResults = $query.count -eq 0

    if( $ThrowIfMissing -and $HasNoResults ) {
        throw (
            Join-String -in $CommandName -f 'FastGetNativeCommand did not find command: {0}' )
    }
    if( $TestIfExists ) { return -not $HasNoresults }
    $query
}
function _Test-UserHasGit {
    $userHasGit = FastGetNativeCommand -Name 'git' -TestIfExists
    if($UserHasGit)
}
function Get-PqLibManifestInfo {
    param(

        # Skip/Ignore metadata that uses git commands on the repository
        [Alias('SkipGit')]
        [switch]$NoGit
    )
    (gcm git)
}
