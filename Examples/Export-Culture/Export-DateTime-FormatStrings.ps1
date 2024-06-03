$ModulePath = Join-Path $PSScriptRoot '../../source-pwsh/Nin.PqLib.psd1' | Get-Item -ea 'stop'
Import-Module $ModulePath -PassThru -Force

# Get-PqLibNamedDateFormatStrings -CultureName (Get-Culture -ListAvailable)
