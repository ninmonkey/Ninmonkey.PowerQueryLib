#Requires -Version 7
'Running: {0}' -f $PSCommandPath | Write-host -fore 'gray50'
Import-Module Pansies -ea 'stop'

$Config = @{
    AppRoot        = gi $PSScriptRoot
    # ExportMd       = Join-Path $PSScriptRoot 'readme.md'
}
$Config | Ft -auto

goto $Config.AppRoot

function FormatPqSourceItem {
    <#
    .SYNOPSIS
        build metadata on the objects, making source generation easier
    .NOTES
        if already is formatted, don't mutate it again, return as a no-op.

        now you can pipe directly from native command too

    .EXAMPLE
        fd inspect.type | gi | FormatPqSourceItem

        # auto converts to Item if it's a string
        fd inspect.type | FormatPqSourceItem

        # and duplicate calls are safe
        fd inspect.type | FormatPqSourceItem | FormatPqSourceItem # no-op return
    #>
    [CmdletBinding()]
    param(
        # Pass either file info, or paths as a string
        [Parameter(Mandatory, ValueFromPipeline)] $InObj
     )
    process {
        if( $InObj -is [string] ) {
            $InObj = Get-Item -ea 'stop' $InObj
        }

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


filter MdFormat-EscapePath {
    <#
    .SYNOPSIS
        make safe markdown style links. convert paths to work as urls and console clickable urls like: <file:///{0}>'
    .example
        > 'dir\some Item.md' | MdFormat-EscapePath

            dir/some%20Item.md
    #>
    $_ -replace ' ', '%20' -replace '\\', '/'
}
function MdFormat-Link {
    <#
    .SYNOPSIS
        format a single markdown url with a name and value
    .EXAMPLE
        Pwsh> MdFormat-Link -Name 'go to' -Url 'some Item.md'

            [go to](some Item.md)

        MdFormat-Link -Name 'go to' -Url 'dir\some Item.md' -AlwaysEscapeUrlPath

            [go to](dir/some%20Item.md)
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Url,

        [Alias('EscapePath')]
        [switch]$AlwaysEscapeUrlPath,

        [Alias('EscapeName')]
        [switch]$AlwaysEscapeKey
    )
    $maybeEscapedPath =
        if( -not $AlwaysEscapeUrlPath ) {
            $url
        } else {
            $url | MdFormat-EscapePath
        }
    $maybeEscapedName =
        if( -not $AlwaysEscapeKey ) {
            $Name
        } else {
            $Name -replace '\(', '\(' -replace '\)', '\)' -replace '\[', '\[' -replace '\]', '\]'
        }
    [string] $rendMdLink  = @(
        '[',
        $maybeEscapedName,
        ']', '(',
        $maybeEscapedPath
        ')'
    ) -join ''
    $rendMdLink
}
function RenderReadmeForGroup {
    <#
    .SYNOPSIS
        Assumes you using grouped items that came from: FormatPQSourceItem

    #>
    param(
        # [Microsoft.PowerShell.Commands.GroupInfo] $GroupedBy,
        $GroupedBy,
        [string] $PathOutput,

        [hashtable]$Options = @{
            TOC = $true
            SortBy = 'RelativePath'
        }
    )
    [string]$finalDocRender = ''

    # using this, because parameter binding likes to pass a pass a [Object[GroupInfo]]]

    if( $GroupedBy[0] -isnot [Microsoft.PowerShell.Commands.GroupInfo] ) {
        throw "UnhandledInputTypeException: Requires object to be a [GroupInfo]"
    }

    if($Options.TOC) {
        # $GroupedBy.Name

        # $finalDocRender += @(
        #     "`n`n"
        #     "## Table of Contents"
        #     "`n"
        # ) -join ''

        [string] $renderTOC =
            $GroupedBy.Name
                | Sort-Object
                | %{
                    MdFormat-Link -Name $_ -Url (Join-String -f '#{0}' -Inp $_)
                        |Join-String -f '  - {0}'
                } | Join-String -sep "`n"

        $finalDocRender += @(
            "`n"
            '<div><small>'
            'Updated: {0}' -f @(
                (Get-Date).ToShortDateString()
            )
            ', Groups: {0}' -f @(
                $GroupedBy.Count
            )
            ', Files: {0}' -f @(
                $GroupedBy.Group.Name.Count
            )
            '</small></div>'
            # "`n"
        ) -join ''
        $finalDocRender += @(
            "`n`n"
            "## Table of Contents"
            "`n"
            '- [Table of Contents](#table-of-contents)'
            "`n"
            $renderTOC
            # "`n"
        ) -join ''

    }

    $GroupedBy | %{
        [string]$rendStr = ''
        $curGroup = $_

        $groupName = $curGroup.Name
        if($GroupName -eq 'alias' ) {
            $null = 0
        }
        $rendStr += @(
            "`n`n"
            "### ${GroupName}"
            "`n"
            '[Top](#table-of-contents)'  # or: MdFormat-link -Name 'Top' -Url '#table-of-contents'
            "`n"
        ) -join ''

        $curGroup.Group
        | Sort-Object -p $Options.SortBy
        | %{
            $curItem     = $_
            $itemName    = $CurItem.Name
            $itemRelPath = $CurItem.RelativePath
            $mdFormatLinkSplat = @{
                Name                = $itemName
                Url                 = $itemRelPath
                AlwaysEscapeUrlPath = $true
            }

            $rendMdLink = MdFormat-Link @mdFormatLinkSplat
            <# was
                $itemName    = $CurItem.Name
                $itemRelPath = $CurItem.RelativePath | MdFormat-EscapePath

                $rendMdLink  = @(
                    '[',
                    $itemName,
                    ']', '(',
                    $itemRelPath
                    ')'
                ) -join ''
            #>
            $RendStr +=
                $RendMdLink | Join-String -f "`n - {0}"

            # $rendStr += @(
            #     "`n"
            #     $RendMdLink
            # ) -join ''
        } # | Join-String -f "`n{0}`n"

        $finalDocRender += $rendStr
    } #| Join-String -f "`n{0}`n"

    $FinalDocRender | Set-Content -Path $PathOutput
    'wrote: {0} of length {1}' -f @(
        $PathOutput
        $FinalDocRender.length
    )| write-host -fg 'orange'
}
function Build.FindForRoot {
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
    ) | write-host -fg 'orange'

    [pscustomobject]@{
        PSTypeName      = 'Build.FindForRoot.Result'
        pq         = $find_pq
        pq_Modules = $find_pq_modules
    }
}
function Build.GroupForRoot {
    param(
        $foundPqItem
    )
    # drop files not commited
    $group_byParent         = $foundPqItem | Group DirectoryBaseName
    # $group_byRelPath        = $foundPqItem | Group RelativePath
    $group_byDirectory      = $foundPqItem | Group Directory
    $group_byFilePrefix     = $foundPqItem | Group -p {
        # support several delims,
        $_.name -split '\.|-|_' | Select -First 1
    }

    'found: Group sizes {{ ByParent: {0}, ByDirectory: {1}, ByFilePrefix: {2} }}' -f @(
        $group_ByParent.count
        $group_ByDirectory.count
        $group_ByFilePrefix.count
    ) | write-host -fg 'orange'
    [pscustomobject]@{
        PSTypeName   = 'Build.GroupForRoot.Result'
        ByParent     = $group_ByParent
        ByDirectory  = $group_ByDirectory
        ByFilePrefix = $group_ByFilePrefix
    }
}

if($false) {
    $Prefix = $Config.AppRoot
    # was named: 'readme.byParent.md'
    RenderReadmeForGroup -GroupedBy $group_byParent -PathOutput (
        Join-path $Prefix 'readme.md')

    # was named: 'readme.byParent.md'
    RenderReadmeForGroup -GroupedBy $group_byParent -PathOutput (
        join-path $Prefix 'readme.md')

    RenderReadmeForGroup -GroupedBy $group_byFilePrefix -PathOutput (
        Join-Path $Prefix 'readme.ByPrefix.md'
    )
}


# RenderReadmeForGroup -GroupedBy $group_byRelpath -PathOutput 'readme.byRelpath.md'
# RenderReadmeForGroup -GroupedBy $group_byDirectory -PathOutput 'readme.byDirectory.md'

$find_pq | Select -First 7 # | FormatPqSourceItem
    | ft -auto
$find_pq | Select -First 2 # | FormatPqSourceItem
    | fl
write-warning '[ ] todo: make filter test if files are untracked or not'
write-warning '[ ] todo: make function run relative any directory'
