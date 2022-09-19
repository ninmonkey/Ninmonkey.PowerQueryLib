class RuneToPqLiteral {
    [string]$Source
    [int]$Codepoint
    [string]$Hex

    hidden [string]$displayStringCodepoint

    RuneToPqLiteral ( [string]$Rune ) {
        $first, $rest = $Rune.EnumerateRunes()
        if ($rest.count -gt 0) { throw 'nyi IEnumerable list of runes' }

        $This.Source = $Rune
        $This.First = $first
        $This.Codepoint = $first.Value
        $This.Hex = '{0:x}' -f @($This.Codepoint)
        $This.DisplayCodeoint = '0x' + $this.Hex
        # just do 1 for now
        # foreach($Rune in $InputText.EnumerateRunes()) {

        # }
        $null -eq 2
    }

    [string] ToString() {
        return ''
    }

    [int] Length () {
        return $this.Source.EnumerateRunes().Value.Count
    }


}

function StringToPqLiteral {
    param(
        [Parameter(ValueFromPipeline)]
        $InputText
    )

    process {
        $ErrorActionPreference = 'break'
        $InputText.EnumerateRunes() | ForEach-Object {
            [RuneToPqLiteral]::new($_)
        }
        $ErrorActionPreference = 'continue'
    }
}


$sample = '    🙊🐛🐈'

StringToPqLiteral $sample