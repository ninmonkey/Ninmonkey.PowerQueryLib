# Regular Expressions


## Convert copy->pasting columns from PBIX

`csv` files are generated using

```ps1
# for two columns
$in = '(.*)\s+(.*)'
$replace = '"$1","$2"'
```
