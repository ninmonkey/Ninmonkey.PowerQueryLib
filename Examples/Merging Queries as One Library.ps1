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

$Config | Ft -auto
$RegexMustMatch = @(
    'Html'
)
$select_pq = Find-PqLibSources -RootDir $Config.ImportRoot -Regex $RegexMustMatch

'Final Files' | write-host -fg $Color.H1
$select_pq -join "`n"


return

$all_pq_files = FindPowerQuerySources -RootDir $Config.ImportRoot
$Patterns = @(
    'Html.Write'
)

$select_pq = $all_pq_files | ?{
    $Patterns.Where({ $_.Name -match $_  }, 'first', 1)
    $_.name -match $Patterns
}
$select_pq -join "`n"
