using namespace System.Collections.Generic
#Requires -Version 7

Import-Module Pansies

$script:Color = @{
    Fg    = '#47c589'
    Green = '#47c589'
    H1    = '#fea9aa'
    Red   = '#fea9aa'
}
$script:_cacheNativeCommand = [ordered]@{ # cache 'git.exe' lookups
    # used by Internal.Invoke-Git

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

function Get-PqLibNativeCommand {
    <#
    .SYNOPSIS
      slow lookup using Get-Command. defaults to Assertion. See also: FastGetNativeCommand
    .NOTES
        for examples see: /source-pwsh/tests/Get-NativeCommand.tests.ps1
    .LINK
        Get-PqLibNativeCommandFast
    .LINK
        Get-PqLibNativeCommand
    .LINK
        Internal.Invoke-Git
    #>
    [Alias( 'GetNativeCommand' )]
    [OutputType(
        [System.Management.Automation.ApplicationInfo],
        # [System.Management.Automation.CommandInfo],
        [bool]
    )]
    param(
        # full paths are allowed
        [ArgumentCompletions(
            "'git'", "'pwsh'",
            "'C:\Program Files\Git\cmd\git.exe'" )]
        [Alias('Name', 'FullName')]
        [string]$CommandName

        # # test without throwing or returning?
        # [Alias('TestExists', 'AsBool', 'TestOnly')]
        # [switch]$TestIfExists, # this param setname has output type [bool]
    )


    # # was:
    # if( -not ( FastGetNativeCommand -Name $CommandName -TestIfExists)) {
    #     Join-String -in $CommandName -f 'FastGetNativeCommand did not find command: {0}'
    #         | write-error
    # }
    # $query = $ExecutionContext.InvokeCommand.
    #     GetCommandName( $CommandName, $false, $true ).Where({$_},'first')

    # could optimize to use module-level cached value
    # shorthand to reuse throw assertions. ExecutionContext is fast, DRY doesn't matter
    $null = FastGetNativeCommand -CommandName $CommandName -TestIfExists -ThrowIfMissing
    $getCommandSplat = @{
        CommandType = 'Application'
        # ErrorAction = 'continue'
        Name        = $CommandName
        TotalCount  = 1
    }
    $binCmd = Get-Command @getCommandSplat
    return $binCmd
}
function Get-PqLibNativeCommandFast {
    <#
    .SYNOPSIS
        sort of redundant. Returns the first path, or, null if no commands are found. ( false is super fast compared to Get-Command -Commandtype Application ) . see also: GetNativeCommand
    .example
        Get-PqLibNativeCommandFast -TestIfExists -CommandName 'TestIfExists' ? 'yes' : 'no'
        Get-PqLibNativeCommandFast -TestIfExists -CommandName 'git'          ? 'yes' : 'no'
        # outputs: False, True
    .example
        Get-PqLibNativeCommandFast -CommandName 'git'     # out: "c:\Program Files\Git\cmd\git.exe"
        Get-PqLibNativeCommandFast -CommandName 'missing' # out: null
    .NOTES
        for examples see: /source-pwsh/tests/Get-NativeCommand.tests.ps1
    .LINK
        Get-PqLibNativeCommandFast
    .LINK
        Get-PqLibNativeCommand
    .LINK
        Internal.Invoke-Git
    #>
    [Alias(
        'FastGetNativeCommand')]
    [OutputType( [String], [bool] )]
    param(
        # full paths are allowed
        [ArgumentCompletions(
            "'git'", "'pwsh'",
            "'C:\Program Files\Git\cmd\git.exe'" )]
        [Alias('Name', 'FullName')]
        [string]$CommandName,

        [Alias('TestExists', 'AsBool', 'TestOnly')]
        [switch]$TestIfExists, # this param setname has output type [bool]

        # normally allow silent failures that emit nothing. this forces a throw.
        [Alias('AssertExists')]
        [switch]$ThrowIfMissing
    )

    $Query = $ExecutionContext.InvokeCommand.
        GetCommandName( $CommandName, $false, $true ).Where({$_},'first')

    [bool] $HasZeroResults = $query.count -eq 0

    if( $ThrowIfMissing -and $HasZeroResults ) {
        throw (
            Join-String -in $CommandName -f 'FastGetNativeCommand did not find command: {0}' )
    }
    if( $TestIfExists ) { return -not $HasZeroResults }
    $query
}
function Internal.Test-UserHasGit { #sugar
    [bool] (FastGetNativeCommand -CommandName 'git' -TestIfExists)
}
function Internal.Invoke-Git {
    <#
    .SYNOPSIS
        internal sugar for cached lookup, invoke, and log params.
    #>
    [OutputType( [string[]] )]
    [CmdletBinding()]
    param(
        # args directly passed to command
        [Alias('ArgList', 'Params', 'Args')]
        [Parameter(Mandatory)]
        [object[]]$ArgumentList,

        # To run with a path other than the current one
        [Alias('WorkingDirectory','FromPath')]
        [string]$FromWorkingDir
    )
    if( [string]::IsNullOrEmpty( $ArgumentList )) {
        throw 'Internal.Invoke-Git: Missing parameter: ArgumentList' }

    $state = $script:_cacheNativeCommand
    if( -not $State.Contains('git' )) {
        $BinGit = GetNativeCommand -CommandName 'git'
        $state['git'] = $BinGit
    }

    $binGit = $state['git']
    'Internal.Invoke-Git: invoking "{0}"{2} :> {1}' -f @(
        $BinGit
        $ArgumentList | Join-String -sep ' '
        ( $FromWorkingDir.length -eq 0 ) ? '' : (
            ' workingDir: "{0}"' -f $FromWorkingDir )
    ) | write-verbose # -verbose

    if( [string]::IsNullOrWhiteSpace( $FromWorkingDir ) ) {
        & $binGit @ArgumentList
        return
    }

    pushd -StackName 'Invoke.Git' -Path $FromWorkingDir
    & $binGit @ArgumentList
    popd -StackName 'Invoke.Git'
}
function Get-PqLibManifestInfo {
    <#
    .synopsis
        Create metadata about this specific build
    .DESCRIPTION
        Optionally includes info using git commands on the repo
    .EXAMPLE
    Pwsh> Get-PqLibManifestInfo -AsObject
    .EXAMPLE
    Pwsh> Get-PqLibManifestInfo -NoGit
        Name          Value
        ----          -----
        BuildDateTime 2024-06-02T14:36:56.7801630-05:00
    .EXAMPLE
    Pwsh> Get-PqLibManifestInfo
        Name          Value
        ----          -----
        BuildDateTime 2024-06-02T14:37:29.3628295-05:00
        GitCommitHash 54ef997de2d69bfee52854029d0668d35e49a2dc
    .example
    Pwsh> Get-PqLibManifestInfo -SuperVerbose -AsObject
            | ConvertTo-Json | jq '{ PwshLib: .PwshPqLib }'

        # outputs:
            {"PwshLib":{"ModuleVersion":"0.1.2"}}
    #>
    [OutputType( 'PSCustomObject', '' )]
    param(

        # Skip/Ignore metadata that uses git commands on the repository
        [Alias('SkipGit', 'WithoutGit')]
        [switch]$NoGit,

        # default returns hashtable
        [switch]$AsObject,

        # output record is extra verbose, includes extra details most uesrs don't care about
        [Alias('IncludeDebugInfo')]
        [switch]$SuperVerbose
    )
    $UserHasGit = Internal.Test-UserHasGit # [bool] (FastGetNativeCommand -CommandName 'git' -TestIfExists)
    [List[Object]]$BinArgs = @()

    $Info = [ordered]@{
        BuildDateTime = (Get-Date).ToString('o')
    }
    if( -not $NoGit -and $UserHasGit ) {
        $BinArgs = @('rev-parse', 'HEAD')
        $Info['GitCommitHash'] = Internal.Invoke-Git -Args $BinArgs -Verbose # -FromWorkingDir 'g:\temp'
    }
    if( $SuperVerbose ) {
        $Info['PwshPqLib'] = @{
            ModuleVersion = (get-module 'Nin.PqLib').Version?.ToString()
        }
    }

    if( $AsObject ) { return [pscustomobject]$Info }
    $Info
}

# function  # Internal.Write-PredentText {
function Format-PqLibPredentText {
    <#
    .synopsis
        minimalism predenting text, emits as array of strings. Sugar.
    .NOTES
        future version will use [StringBuilder]. This is fast enough currently.
    .EXAMPLE
        # indent code to paste
        Get-Clipboard | Fmt-Predent
    .EXAMPLE
        0..3 | %{  $_ ;'a'..'c' | Fmt-Predent 2 } | Fmt-Predent 2
        # same as
        0..3 | %{
            $_
            'a'..'b'
            | Fmt-Predent 2
        }   | Fmt-Predent 2
        # Out
            0
                a
                b
            1
                a
                b
            # ...
    #>
    [Alias(
        'Fmt-PqPredentText',
        'Fmt-Predent', 'Internal.Write-PredentText' # to be removed
    )]
    [CmdletBinding()]
    [OutputType( [System.String[]] )]
    param(
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]] $InputObject,

        # default depth
        [ArgumentCompletions(2, 3, 4)]
        [Parameter(Mandatory, Position=0)]
        [uint] $Depth = 2,

        [Parameter(Position = 1)]
        [ArgumentCompletions(1, 2, 3, 4, 6, 8)]
        [uint] $CharsPerDepth = 1,

        [Parameter()]
        [ArgumentCompletions("' '","'  '","'␠'",'"`t"','> ')]
        [string] $Text = ' ',

        # if the auto split on newlines could affect the execution
        # you can toggle that step off
        [switch]$NoSplitLineEndings,

        # output a single string. Default version allows you to output an array of strings.
        [Alias('AsString')]
        [switch]$OutputAsString
    )
    begin {
        [string] $prefix = $Text * ( $Depth * $CharsPerDepth ) -join ''
        [List[Object]]$Lines = @()
    }
    process {
        if( $NoSplitLineEndings ) {
            $lines.AddRange(@( $InputObject ))
            return
        }

        $lines.AddRange(@(
            $InputObject -split '\r?\n' ))
    }
    end {
        if( $OutputAsString ) {
            $lines | %{
                $_ | Join-String -f "${prefix}{0}"
            } | Join-String -sep "`n"
            return
        }
        # else allow many
        $lines | %{
            $_ | Join-String -f "${prefix}{0}"
        }
    }
}


function Write-PqLibWrapAsLetExpression {
    <#
    .SYNOPSIS
        write raw powerquery records
    .example

    .NOTES
        for examples see: /source-pwsh/tests/Get-NativeCommand.tests.ps1
    .LINK
    #>
    [Alias(
        'Write-PqWrapExpression')]
    [OutputType( [string] )]
    param(
        [Parameter(Mandatory)]
        [string]$KeyName,

        [Alias('Content', 'Text', 'Str')]
        [Parameter(Mandatory)]
        [string[]]$RawContent,

        [Alias('Template', 'Format')]
        [ValidateSet('Let', 'Record' )]
        [string]$OutputType = 'record',

        # nest using easier to read records instead
        [ValidateScript({throw 'nyi'})]
        [switch]$AsRecordExpression,

        # format style with or without semi
        [ValidateScript({throw 'nyi'})]
        [switch]$WithTrailingSemilcolon

        # [ValidateScript({throw 'nyi'})]
        # [switch]$WithTrailingCommaSemilcolon
    )

    $Merged = $RawContent -join "`n"
    $render_InnerRecord = $merged
    $render_KeyName_AsLiteral = Join-String -op '#"' -os '"' -Inp $KeyName # to export: writeIdentifier
        # future: don't wrap #"" if not required?

    # skipped using format strings, to prevent complications with operators
    switch($OutputType) {
        'Let' {
            # $Prefix = 'let '
            $render_Document = @(
                'let ' # $Prefix
                $render_KeyName_AsLiteral, ' '
                ' = '
                $render_InnerRecord
                ' in '
                $render_KeyName_AsLiteral, ' '
            ) -join ''
        }
        'Record' {
            $render_Document = '[ x = orig ]'
            throw 'nyi'
        }
        default { throw "ShouldNeverReachException: Unhandled OutputType: '${OutputType}'"}
    }

    return $render_Document
}
