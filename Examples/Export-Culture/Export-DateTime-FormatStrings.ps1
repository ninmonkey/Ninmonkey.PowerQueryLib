$ModulePath = Join-Path $PSScriptRoot '../../source-pwsh/Nin.PqLib.psd1' | Get-Item -ea 'stop'
Import-Module $ModulePath -PassThru # -Force
$ExportConfig = @{
    ExportExcel = $false
    ExportCsv   = $true
    ExportJson = $false
}

$query ??= Get-PqLibNamedDateFormatStrings -CultureName (Get-Culture -ListAvailable)

    # | Export-Csv -Path
# |select -first 20 | Ft -AutoSize
# $cachedAllCultsList| some 32

mkdir -ea ignore (Join-path $PSScriptRoot 'csv')
mkdir -ea ignore (Join-path $PSScriptRoot 'excel')
mkdir -ea ignore (Join-path $PSScriptRoot 'json')

$PathCsv   = Join-Path $PSScriptRoot '/csv/NamedDateFormatStrings.csv'
$PathExcel = Join-Path $PSScriptRoot '/excel/NamedDateFormatStrings.xlsx'
$PathJson  = Join-Path $PSScriptRoot '/json/NamedDateFormatStrings.json'

if( $ExportConfig.ExportCsv ) {
    $query
        | Select-Object CultureName, Name, FormatString
        | Export-Csv -Path $PathCsv -Encoding utf8BOM # excel requires UTF8BOM if unicode

    $PathCsv | Get-Item | Join-String -f 'Wrote: <file:///{0}>' | write-verbose -verbose
}
