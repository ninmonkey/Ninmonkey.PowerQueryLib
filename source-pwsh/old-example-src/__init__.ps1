using namespace System.Text.StringBuilder
#Requires -Version 7.0
#Requires -Module Ninmonkey.Console
# Requires -Module Dev.Nin

Import-Module Ninmonkey.Console, Dev.nin -wa ignore

$ModuleConfig = @{

}
$eaStop = @{ ErrorAction = 'stop' }

$script:__Paths = @{
    RepoRoot = Get-Item @eaStop "$Env:UserProfile/SkyDrive/Documents/2021/Power BI/My_Github/Ninmonkey.PowerQueryLib"
}
$__paths = @{
    OutputRoot           = Get-Item @eaStop Join-path $__paths.RepoRoot '.output'
    ExportRoot           = Get-Item @eaStop Join-path $__paths.RepoRoot '.export'
    PowerQuerySourceRoot = Get-Item @eaStop Join-path $__paths.RepoRoot 'source'
}
function foo {
    <#
    .synpopsis
        what
    #>
    [CmdletBinding()]
    param()


}
function Set-PqLibOption {
    <#
    .synopsis
        set options
    #>
    param(
        [Parameter(Mandatory)]
        [hashtable]$Options
    )

}
function Get-PqLibOption {
    <#
    .synopsis
        get options
    #>
    [CmdletBinding()]
    param()
    $opt = @{
        PsTypeName = 'Nin.PqLib.Options'
        Paths      = $script:__Paths
    }
    return [pscustomobject]$Opt
}


$Config = @{
    AutoOpenEditor = $false
    AutoRoot       = Get-Item -ea stop (Join-Path $PSScriptRoot '..')
}
$Config += @{
    AutoExportRoot = Join-Path $Config.AutoRoot '.output'
}

