This parses `cell()` output to get the **absolute filepath of the current workbook**

This is one way you can have powerquery autodetect absolute filepaths
```
= Cell( "filename" )
```
The raw output
```
c:\data\excel\[Example Sales Table.xlsx]Sheet2
```
formula:
```sql
= LET(
  rawName, CELL("filename"),

  folder,
    TEXTBEFORE( rawName, "[", 1 ),

  file,
    TEXTBEFORE(
      TEXTAFTER( rawName, "[", 1 ),
      "]", 1
    ),

  fullName,
    CONCAT(folder, file),

fullName )
```
Our final output:
```
c:\data\excel\Example Sales Table.xlsx
```
