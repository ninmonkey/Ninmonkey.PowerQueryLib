# Ninmonkey.PowerQueryLib

Custom functions for Power BI

Take a look at [test_All.pbix](source\test\test_All.pbix) for examples.

You can also use it to copy -> paste the functions you want in one go.

## Language data as `CSV`

- [All PowerQuery Functions](./Docs/List_Functions-All.csv)
- [All PowerQuery Constants](./Docs/List_Constants-All.csv)
- [All *.Types](./Docs/List_Types.csv) . This is all built-in types like `Int64.Type`, `Currency.Type`, etc.

## Examples in: Ninmonkey.PowerQueryLib-ExampleReports

**TextAsList.pbix**

- SerializeList, TypeAsText, ListAsText

**IP Addresses.pbix**

- convert from DecimalIP, DottetDecimalIP, and BinaryIP addresses
- includes bitwise math

**Random Sales**

- Random.Currency(), Random.Int()
- Integer rounding modes

**Enter Data**

- Uses compressed JSON tables

**Importing Raw Text Files.pbix**

- see `ConvertTableFromText = (filepath as text, splitCharacter as text, linesPerRecord as number, optional encoding as nullable number) as table =>`

**All HTTP Request types.pbix**

- uses `HTTP` `GET`, `POST`, `PUT`, `PATCH`, etc...
