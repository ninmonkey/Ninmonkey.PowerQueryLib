[Go Back](../Readme.md)

- [Exporting Cultures Examples](#exporting-cultures-examples)

## Exporting Cultures Examples

[Named DateTime FormatStrings by Culture.csv](./csv/NamedDateFormatStrings.csv) was built with this command:

```powershell
Import-Module Nin.PqLib

Get-PqLibNamedDateFormatStrings -CultureName (Get-Culture -ListAvailable)
    | Select-Object CultureName, Name, FormatString
    | Export-Csv -Path 'export.csv' -Encoding utf8BOM # excel requires UTF8BOM if unicode
```