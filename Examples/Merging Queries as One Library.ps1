$impo_Splat = @{ ErrorAction = 'stop' ; PassThru = $true }
$ModulePath = Get-Item 'H:\data\2024\tabular\Ninmonkey.PowerQueryLib\source-pwsh\Nin.PqLib.psd1'
@(
    Import-module @impo_splat Pansies
    Import-module @impo_splat -Force $ModulePath
) | Join-String -p { $_.Name, $_.Version } -sep ', '

$Config = @{
    AppRoot = ($AppRoot = Get-Item $PSScriptRoot)
    ImportRoot = Join-Path $AppRoot '../source'
}
$Color = @{
    Fg    = '#47c589'
    Green = '#47c589'
    H1    = '#fea9aa'
    Red   = '#fea9aa'
}

function FindPowerQuerySources {
    <#
    .SYNOPSIS
        Tiny sugar to find files and summarize the counts. move to module or is a 1-off?
    #>
    [OutputType( [System.IO.FileInfo[]] )]
    param( [string]$RootDir )
    $Root  = Get-Item -ea 'stop' $RootDir
    $query = Get-ChildItem -path $Root *.pq -Recurse

    'Found {0} .pq files under the root path: "{1}"' -f @(
        $query.count
        $RootDir | Get-Item
    ) | Write-host -fg $Color.Fg
    $query
}
$all_pq_files = FindPowerQuerySources -RootDir $Config.ImportRoot
$Patterns = @(
    'Write.Html'
)

$select_pq = $all_pq_files | ?{
    $Patterns.Where({ $_.Name -match $_  }, 'first', 1)
    $_.name -match $Patterns
}
$Config | Ft -auto

'Filtered Files' | write-host -fg $Color.H1

$select_pq -join "`n"
