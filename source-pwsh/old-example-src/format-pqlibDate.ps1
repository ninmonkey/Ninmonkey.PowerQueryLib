'Original command'
$d = [datetime]'2024-03-13'
$cults = Get-culture -ListAvailable
$cults | %{
    $Cult = $_
    $d.ToString( $_.DateTimeFormat.ShortDatePattern, $cult )
    #  .DateTimeFormat.ShortDatePattern
    #   $d.ToShortDateString() } )
}

function Format-PqLibDate {

    param(
        [ValidateSet(
            'ShortDate', 'ShortTime'
        )]
        [Alias('Template', 'FStr')]
        [Parameter(Mandatory)]
        [string]$Format
    )

    $FormatStr = switch($Format) {
        'ShortDate' { 'yyyy-MM-dd' }
        'ShortTime' { 'HH:mm:ss' }
        default { throw "ShouldNeverReachException: Unhandled Format '$Format'" }
    }

    $d = [datetime]'2024-03-13'
$cults = Get-culture -ListAvailable
$cults | %{
    $d.ToString( $_.DateTimeFormat.ShortDatePattern,(get-culture 'de' ))
    #  .DateTimeFormat.ShortDatePattern
    #   $d.ToShortDateString() } )
}
}
