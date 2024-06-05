#Requires -Version 7
'Running: {0}' -f $PSCommandPath | Write-host -fore 'gray50'
Import-Module Pansies -ea 'stop'

$Config = @{
    AppRoot        = gi $PSScriptRoot
    ExportMd       = Join-Path $PSScriptRoot 'readme.md'
}
$Config | Ft -auto

function FormatPqSourceItem {
    <#
    .SYNOPSIS
        build metadata on the objects, making source generation easier
    .NOTES
        if already is formatted, don't mutate it again, return as a no-op.
    #>
    [CmdletBinding()]
    param( [Parameter(Mandatory, ValueFromPipeline)] $InObj )
    process {

        if( $InObj.pstypenames -contains 'PqLibSourceItem' ) {
            return $InObj
        }

        $renderRelativePath = $InObj.FullName -replace [Regex]::escape( $Config.AppRoot.FullName + '\' ), ''
        [pscustomobject]@{
            PSTypeName   = 'PqLibSourceItem'
            RelativePath = $renderRelativePath
            Name         = $InObj.Name
            IsModule     = ($InObj.fullName -match '\.module\.pq$'
                ) ? $true :
                    $false

            # future: $q.IsTag.GetEnumerator() | ?{ $_.Value -eq $true }
            # IsTag = [PSCustomObject]@{
            IsTag = @{
                Assert    = $InObj.Name -match '\bAssert\b'
                Text      = $InObj.Name -match '\bText\b'
                Replace   = $InObj.Name -match 'Replace'
                Coerce    = $InObj.Name -match '\bCoerce\b'
                Convert   = $InObj.Name -match '\bConvert(to)?\b'
                Table     = $InObj.Name -match '\bTable\b'
                Column    = $InObj.Name -match '\bColumn\b'
                Number    = $InObj.Name -match '\bNumber\b'
                Binary    = $InObj.Name -match '\bBinary\b'
                Web       = $InObj.Name -match '\bWeb\b'
                Transform = $InObj.Name -match '\bTransform\b'
                List      = $InObj.Name -match '\bList\b'
                Date      = $InObj.Name -match '\bDate\b'
                DateTime  = $InObj.Name -match '\bDateTime\b'
            }
            BaseName          = $InObj.BaseName
            Directory         = $InObj.Directory
            DirectoryBaseName = $InObj.Directory.Name
            FullName          = $InObj.FullName
            Object            = $InObj
        }
    }
}

$find_pq_modules = fd -e module.pq --base-directory (gi $Config.AppRoot )
    | Get-Item
    | FormatPQSourceItem

$find_pq = fd -e pq --base-directory (gi $Config.AppRoot )
    | Get-Item
    | FormatPQSourceItem



'found: {{ modules: {0}, functions: {1}, root: {2} }}' -f @(
    $find_pq_modules.count
    $find_pq.count
    $Config.AppRoot
)
# drop files not commited


$find_pq | Select -First 7 # | FormatPqSourceItem
    | ft -auto
$find_pq | Select -First 2 # | FormatPqSourceItem
    | fl
write-warning 'todo: make filter test if files are untracked or not'
