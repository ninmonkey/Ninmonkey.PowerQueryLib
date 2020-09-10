# Ninmonkey.PowerQueryLib

Custom functions for Power BI

Take a look at [test_All.pbix](source\test\test_All.pbix) for examples.

You can also use it to copy -> paste the functions you want in one go.

## CSV data files

- list of all `*.Type`: [List Types.csv](Docs\List Types.csv)
- list of `type text` constants [List Text.csv](Docs\List Text.csv)
- list of all `type number` constants [List Numbers.csv](Docs\List Numbers.csv)
- list of all `type function`s [List Functions - All.csv](Docs\List Functions - All.csv)

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
