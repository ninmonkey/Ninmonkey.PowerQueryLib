## Important 

- https://docs.microsoft.com/en-us/power-query/handlingdocumentation
- Intro to docs metadata: https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata

## Related:
- https://bengribaudo.com/blog/2020/06/02/5259/power-query-m-primer-part18-type-system-iii-custom-types
- https://bengribaudo.com/blog/2020/09/03/5408/power-query-m-primer-part19-type-system-iv-ascription-conformance-and-equalitys-strange-behaviors


## Partial lexical grammar of PQ documentation

- Todo: Script that mines the names of all metadata on built-in connectors
- this is to detect any missing `Documentation.` keys for function metadata
Abbreviation 
`Documentation.Examples` as `D.Examples`

### Basic pseudo lexical grammar

```yml
type Function:
    | D.Examples
    | D.LongDescription
    | D.Name

type Parameter:
    | D.AllowedValues
    | D.FieldCaption
    | D.FieldDescription
    | D.SampleValues
    | Formatting.IsCode
    | Formatting.IsMultiLine
```

### expanded with types

```yml
type Function:
    | D.Examples
        ListOf:
            type [ Description, Code, Result ]
    | D.LongDescription
        text
    | D.Name
        text

type Parameter:
    | D.AllowedValues
        ListOf:
            type any
        
    | D.FieldCaption
        text
    | D.FieldDescription
        text
    | D.SampleValues
        ListOf:
            type any
    | Formatting.IsCode
        logical
    | Formatting.IsMultiLine
        logical
```