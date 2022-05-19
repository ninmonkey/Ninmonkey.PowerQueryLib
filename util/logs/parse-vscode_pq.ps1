$AppConf = @{
    AppRoot = Get-Item $PSScriptRoot
    LogRoot = Get-Item "$Env:UserProfile/SkyDrive/2022-fam-share/logs/vscode-pq-parser"
}

$AppConf += @{
    ExportRoot  = Join-Path $AppConf.LogRoot '.output'
    Target_Name = '2022-05-23.crashed-pqparser-version_1.32.log'
    # FirstLog = Get-Item "$Env:UserProfile/SkyDrive/2022-fam-share/logs/vscode-pq-parser/2022-05-23-item1-crashed.version_1.32.log"
    # ImportPath = "$Env:UserProfile\SkyDrive\Documents\2021\Powershell\My_Github\Marking\newest-refs\pq-to-json\power-query-to-json.log"
}
New-Item -ea ignore -ItemType Directory -Path $AppConf.ExportRoot
$AppConf.ExportRoot = Get-Item -ea stop $AppConf.ExportRoot
# $AppConf += @{

# }
$AppConf | Format-Table -AutoSize -Wrap

$target = Get-Item -ea stop 'C:\Users\cppmo_000\SkyDrive\2022-fam-share\logs\vscode-pq-parser\2022-05-23.crashed-version_1.32.pq.log'
$Content = Get-Content -Path $target -Raw


class PQRecord {
    [string]$Header
    [object]$Json
    [string]$RawJson
    [boolean]$FailedParsing = $false
}




$Regex = @{}
$Regex['SplitLogPhase1_iter0'] = @'
(?xm)
    \n
    <---\s*
    (?<Label>.*)
    \s*--->
    \n
'@
$Regex['SplitLogPhase1'] = @'
(?xm)
    <---
    \s*
    (?<Label>.*)
    \s*--->
'@

$Regex['PQRecord'] = @'
(?xm)
    (?<Header>
        ^\[Trace.*$
        \nParams:
    )
    (?<Json>
        (.|\n)*?
    )

    (?=
        \Z|^\[Trace
    )
'@

function _exportPhase1 {
    <#
    .synopsis
        split main .pq log by the <-- --> named sections
    .OUTPUTS
        returns paths of new files
    #>
    [CmdletBinding()]
    param(
        $TargetPath
    )
    if (!(Test-Path $TargetPath)) {
        Throw "MissingFileException: '$TargetPath'"
    }
    $Target = Get-Item $TargetPath
    $id = 0
    $phase1 = ((Get-Content $target -Raw) -split ($Regex.SplitLogPhase1) )
    if ($phase1.count -le 1) {
        Write-Warning "Unexpected length after splitting '$Target'"
    }
    $files = [list[[object]]]::new()
    $Phase1 | ForEach-Object {
        $curContent = $_
        $Dest = $Target.FullName + "_part${id}"
        $id++
        Set-Content -Value $curContent -Path $Dest -Encoding utf8
        $Dest = Get-Item $Dest

        Write-Debug "write: '$Dest'"

        $files.add($dest)


    }
    return $files
}

function _parseRecord {
    <#
    .synopsis
        convert a single, multi-line record
    #>
    [OutputType('PSCustomObject')]
    param(
        # [object]$InputObject
        [Text.RegularExpressions.Match]$InputObject
    )
    process {
        # ignore unnamed
        $hash = @{}
        $InputObject.Groups | Where-Object { $_.Name -notmatch '\A\d+\Z' }
        | ForEach-Object { $hash[ $_.Name, $_.Value ] }

        $Hash['RawJson'] = $Hash.Json
        try {
            $Hash['Json'] = $Hash['Json'] | ConvertFrom-Json
        } catch {
            Write-Warning "Failed Parsing Json: '$($Hash.RawJson)'"
            $Hash['Json'] = $Null
            $Hash['FailedParsing'] = $true
        }
        return [PQRecord]@{
            Header        = $Hash.Header
            Json          = $hash['Json']
            RawJson       = $Hash['RawJson']
            FailedParsing = $Hash['FailedParsing']
        }

    }
}


$Target_segments = _exportPhase1 -TargetPath $target -Verbose
$Target_segments
$phase1.count | Label 'split on <-->'

$phase2_target = Get-Item $Target_segments[0]
$curContent = Get-Content -Raw $phase2_target
$listMatches = [regex]::Matches($curContent, $Regex.PQRecord)
$listMatches[0..2] | Format-Table



$listPQRecords = $listMatches | _parseRecord

$processed = $listMatches[0].Groups | s name, value
# drop un-named
| Where-Object Name -NotMatch '\A\d+\Z'
# as object
| ForEach-Object -Begin { $hash = @{} } {
    $hash.Add( $_.Name, $_.Value )
} -End {
    # $Hash['Json_Original'] = $Hash['Json']
    [pscustomobject]$hash
}

function a {

}
# drop-unnamed
<#
new-doir $AppConf.ExportRooot

    Target_FullName = Join-Path $AppConf.LogRoot gi '2022-05-23.crashed-pqparser-version_1.32.log'


 FirstLog = Get-Item "$Env:UserProfile/SkyDrive/2022-fam-share/logs/vscode-pq-parser/2022-05-23-item1-crashed.version_1.32.log"
$Content = Get-Content $AppConf.FirstLog

C:\Users\cppmo_000\SkyDrive\2022-fam-share\logs\vscode-pq-parser\2022-05-23.crashed-pqparser-version_1.32.log

function split-pqpLog
#>
