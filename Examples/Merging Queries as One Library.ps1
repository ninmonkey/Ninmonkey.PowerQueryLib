'Running: {0}' -f $PSCommandPath | Write-verbose -verbose
$impo_Splat = @{ ErrorAction = 'stop' ; PassThru = $true }
$ModulePath = Get-Item 'H:\data\2024\tabular\Ninmonkey.PowerQueryLib\source-pwsh\Nin.PqLib.psd1'
$AppRoot    = Get-Item -ea 'stop' $PSScriptRoot
@(
    Import-module @impo_splat Pansies
    Import-module @impo_splat -Force $ModulePath
) | Join-String -p { $_.Name, $_.Version } -sep ', '

$Config = @{
    AppRoot = $AppRoot
    ImportRoot = Join-Path $AppRoot '../source' | Get-Item -ea 'stop'
    AutoExportRoot = Join-path $AppRoot '../build/auto-export' | Get-Item -ea 'stop'
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

$dynamicName = Join-String -f '{0}.ninlib.pq' -In (get-date).tostring('yyyy-MM-dd')
$newExport   = Join-path $Config.AutoExportRoot $DynamicName
hr
gc ($select_pq | select -First 1) | sc -Path $newExport
$newExport = $newExport | Get-Item
'wrote: {0}' -f $NewExport | write-host -fg $Color.Red

Get-PqLibManifestInfo|ft -AutoSize

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
