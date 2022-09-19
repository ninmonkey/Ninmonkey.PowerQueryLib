# How to document Power Query functions

first:

- <https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata>
- <https://docs.microsoft.com/en-us/power-query/handlingdocumentation>


<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [How to document Power Query functions](#how-to-document-power-query-functions)
  - [Template: Power Query function with Documentation](#template-power-query-function-with-documentation)
  - [Cheatsheets: Metadata for Documentation](#cheatsheets-metadata-for-documentation)
    - [Functions](#functions)
    - [Examples](#examples)
    - [Parameters](#parameters)
  - [References](#references)

<!-- /code_chunk_output -->

## Template: Power Query function with Documentation

A template to document custom functions:

- [Power Query function with Documentation.pq](./../template/Power Query function with Documentation.pq)

docs:

- [bengribaudo.com/Handling Metadata as Documentation](https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata#function-parameter-documentation)
- [Handling Documentation](https://docs.microsoft.com/en-us/power-query/handlingdocumentation)
- [Value Functions and Metadata](https://docs.microsoft.com/en-us/powerquery-m/value-functions#__toc360789751)
- [Function-Value Functions](https://docs.microsoft.com/en-us/powerquery-m/function-values)

## Cheatsheets: Metadata for Documentation

### Functions

| Field                         | Type   | Description                     |
| ----------------------------- | ------ | ------------------------------- |
| Documentation.LongDescription | `text` | shown inside function help      |
| Documentation.Name            | `text` | Short name / description        |
| Documentation.Examples        | `list` | `list` of `record`s of Examples |

### Examples

| Field       | Type   | Description                               |
| ----------- | ------ | ----------------------------------------- |
| Description | `text` | Name of this example                      |
| Code        | `text` | Power Query example code                  |
| Result      | `text` | Result of examplePower Query example code |

### Parameters

Choose either `AllowedValues` or `SampleValues`. Neither type is enforced.
The choice is purely how the visual is. Either a text box with grayed out text, otherwise a drop down box.

| Field                          | Type      | Details                                                                           |
| ------------------------------ | --------- | --------------------------------------------------------------------------------- |
| Documentation.AllowedValues    | `list`    | Sample values that **populate a dropdown box**. Values are not actually enforced. |
| Documentation.FieldCaption     | `text`    | Friendly display name to use for the parameter.                                   |
| Documentation.FieldDescription | `text`    | Description to show next to the display name.                                     |
| Documentation.SampleValues     | `list`    | List of sample values to be displayed (as faded text) inside of the text box.     |
| Formatting.IsMultiLine         | `logical` | Input box should be multi-line                                                    |
| Formatting.IsCode              | `logical` | Marks field as 'code'. Uses monospace font.                                       |

## References

docs:

- [Handling Documentation](https://docs.microsoft.com/en-us/power-query/handlingdocumentation)
- [Value Functions and Metadata](https://docs.microsoft.com/en-us/powerquery-m/value-functions#__toc360789751)
- [Function-Value Functions](https://docs.microsoft.com/en-us/powerquery-m/function-values)


```
doc tips:

documentation on the types uses for documentation
    https://docs.microsoft.com/en-us/power-query/handlingdocumentation

from:
    https://bengribaudo.com/blog/2021/03/17/5523/power-query-m-primer-part20-metadata
> A note about Documentation.Name: This value should probably match the name of the identifier you assign your function when you define it. For example, if you call your function SomeFunction, then when you set Documentation.Name, you should probably set its value to “SomeFunction”, as well.

```