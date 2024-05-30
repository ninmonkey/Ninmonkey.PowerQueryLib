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
    Green = '#47c589'
    Fg    = '#47c589'
}

function FindPowerQuerySources {
    param( [string]$RootDir )
    Get-ChildItem -path *.pq -Recurse
}
$all_pq_files = FindPowerQuerySources -RootDir $Config.ImportRoot

$Config | Ft -auto
'Found {0} .pq files under the root path: "{1}"' -f @(
    $all_pq_files.count
    $Config.ImportRoot | Get-Item
) | Write-host -fg $Color.Fg
