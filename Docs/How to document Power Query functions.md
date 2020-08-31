# How to document Power Query functions

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cheatsheets: Metadata for Documentation](#cheatsheets-metadata-for-documentation)
  - [Functions](#functions)
  - [Parameter](#parameter)
- [References](#references)


<!-- /code_chunk_output -->

docs:

- [Handling Documentation](https://docs.microsoft.com/en-us/power-query/handlingdocumentation)
- [Value Functions and Metadata](https://docs.microsoft.com/en-us/powerquery-m/value-functions#__toc360789751)
- [Function-Value Functions](https://docs.microsoft.com/en-us/powerquery-m/function-values)

## Cheatsheets: Metadata for Documentation

### Functions

| Field                         | Type | Description                          |
| ----------------------------- | ---- | ------------------------------------ |
| Documentation.Examples        | list | `list` of `record`s of examples      |
| D | text | Full description                     |
| Documentation.Name            | text | "displayd on function invoke dialog" |

**test**: is this the UI, or intellisense?

### Parameter

| Field                          | Type    | Details                                                                                                                                               |
| ------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Documentation.AllowedValues    | list    | List of valid `value`s for this parameter. <br/>Shows a **UI dropdown** Providing this field will change the input from a textbox to a drop down list |
| Documentation.FieldCaption     | text    | Friendly display name to use for the parameter.                                                                                                       |
| Documentation.FieldDescription | text    | Description to show next to the display name.                                                                                                         |
| Documentation.SampleValues     | list    | List of sample values to be displayed (as faded text) inside of the text box.                                                                         |
| Formatting.IsMultiLine         | boolean | Allows you to create a multi-line input, for example for pasting in native queries.                                                                   |
| Formatting.IsCode              | boolean | Formats the input field for code, commonly with multi-line inputs. Uses a code-like font rather than the standard font.                               |

## References

docs:

- [Handling Documentation](https://docs.microsoft.com/en-us/power-query/handlingdocumentation)
- [Value Functions and Metadata](https://docs.microsoft.com/en-us/powerquery-m/value-functions#__toc360789751)
- [Function-Value Functions](https://docs.microsoft.com/en-us/powerquery-m/function-values)
