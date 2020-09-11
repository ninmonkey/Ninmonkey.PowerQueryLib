# How to document Power Query functions

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Template: Power Query function with Documentation](#template-power-query-function-with-documentation)
- [Cheatsheets: Metadata for Documentation](#cheatsheets-metadata-for-documentation)
  - [Functions](#functions)
  - [Examples](#examples)
  - [Parameters](#parameters)
- [References](#references)

<!-- /code_chunk_output -->

## Template: Power Query function with Documentation

A template to document custom functions: [Power Query function with Documentation.pq](./../template/Power Query function with Documentation.pq)

docs:

- [Handling Documentation](https://docs.microsoft.com/en-us/power-query/handlingdocumentation)
- [Value Functions and Metadata](https://docs.microsoft.com/en-us/powerquery-m/value-functions#__toc360789751)
- [Function-Value Functions](https://docs.microsoft.com/en-us/powerquery-m/function-values)

## Cheatsheets: Metadata for Documentation

### Functions

| Field                         | Type | Description                          |
| ----------------------------- | ---- | ------------------------------------ |
| Documentation.LongDescription | `text` | shown inside function help   |
| Documentation.Name            | `text` | Short name / description |
| Documentation.Examples        | `list` | `list` of `record`s of Examples      |

### Examples

| Field                         | Type | Description                          |
| ----------------------------- | ---- | ------------------------------------ |
| Description        | `text` | Name of this example |
| Code        | `text` | Power Query example code |
| Result        | `text` | Result of examplePower Query example code |

### Parameters

Choose either `AllowedValues` or `SampleValues`. Neither type is enforced.
The choice is purely how the visual is. Either a text box with grayed out text, otherwise a drop down box.

| Field                          | Type    | Details                                                                                                                                               |
| ------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Documentation.AllowedValues    | `list`    | Sample values that **populate a dropdown box**. Values are not actually enforced. |
| Documentation.FieldCaption     | `text`    | Friendly display name to use for the parameter.                                                                                                       |
| Documentation.FieldDescription | `text`    | Description to show next to the display name.                                                                                                         |
| Documentation.SampleValues     | `list`    | List of sample values to be displayed (as faded text) inside of the text box.                                                                         |
| Formatting.IsMultiLine         | `logical` | Input box should be multi-line     |
| Formatting.IsCode              | `logical` | Marks field as 'code'. Uses monospace font. |

## References

docs:

- [Handling Documentation](https://docs.microsoft.com/en-us/power-query/handlingdocumentation)
- [Value Functions and Metadata](https://docs.microsoft.com/en-us/powerquery-m/value-functions#__toc360789751)
- [Function-Value Functions](https://docs.microsoft.com/en-us/powerquery-m/function-values)
