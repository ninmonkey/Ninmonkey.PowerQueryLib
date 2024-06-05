#Requires -Version 7
'Running: {0}' -f $PSCommandPath | Write-host -fore 'gray50'
Import-Module Pansies -ea 'stop'

$Config = @{
    AppRoot        = gi $PSScriptRoot
    ExportMd       = Join-Path $PSScriptRoot 'readme.md'
}
$Config | Ft -auto

goto $Config.AppRoot

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
filter MdFormat-EscapePath {
    $_ -replace ' ', '%20' -replace '\\', '/'
}
# drop files not commited
$group_byParent         = $find_pq | Group DirectoryBaseName
$group_byRelPath        = $find_pq | Group RelativePath
$group_byDirectory      = $find_pq | Group Directory


function RenderByGroup {
    param(
        [Microsoft.PowerShell.Commands.GroupInfo] $GroupedBy,
        [string] $PathOutput

    )

    # if( $GroupedBy[0] -isnot [Microsoft.PowerShell.Commands.GroupInfo] ) {
    #     throw "UnexpectedError, "
    # }

    # }

    [string]$finalDocRender = ''

        $GroupedBy | %{
            [string]$rendStr = ''
            $curGroup = $_

            $groupName = $curGroup.Name
            $rendStr += @(
                "`n`n"
                "### ${GroupName}"
                "`n"
            ) -join ''

            $curGroup.Group | %{
                $curItem     = $_
                $itemName    = $CurItem.Name
                $itemRelPath = $CurItem.RelativePath | MdFormat-EscapePath
                $rendMdLink  = @(
                    '[',
                    $itemName,
                    ']', '(',
                    $itemRelPath
                    ')'
                ) -join ''

                $rendStr += "`n${RendMdLink}"
            } # | Join-String -f "`n{0}`n"

            $finalDocRender += $rendStr
        } | Join-String -f "`n{0}`n"

    $FinalDocRender.length

    $FinalDocRender | Set-Content -Path $Config.ExportMd
    'wrote: {0}' -f $Config.ExportMd | write-host -fg 'orange'
}


$find_pq | Select -First 7 # | FormatPqSourceItem
    | ft -auto
$find_pq | Select -First 2 # | FormatPqSourceItem
    | fl
write-warning 'todo: make filter test if files are untracked or not'
