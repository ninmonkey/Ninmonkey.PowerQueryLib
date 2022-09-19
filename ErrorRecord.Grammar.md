- [Inline throw](#inline-throw)
- [Function: `Error.Record()` signature](#function-errorrecord-signature)
- [See Also](#see-also)
- [Examples from the Docs](#examples-from-the-docs)
- [Extra Requirements Specific to Try Catch](#extra-requirements-specific-to-try-catch)
- [Try Expression Types](#try-expression-types)
  - [Try <Expression> catch (e) => <Expression>](#try-expression-catch-e--expression)
  - [Try <Expression> catch () => <Expression>](#try-expression-catch---expression)
  - [Try <Expression> otherwise <Expression>](#try-expression-otherwise-expression)
  - [Try <Expression>](#try-expression)
- [yaml summary](#yaml-summary)

## Inline throw

`error` is the name of a **language keyword** that throws an exception. There's a built in function named `Error.Record` to construct  the argument `record` for you
```js
error [
  Reason = "Business Rule Violated", 
  Message = "Item codes must start with a letter", 
  Detail = "Non-conforming Item Code: 456"
]
```

To get a GUID to easily filter query tracing, you can `Table.AddColumn()` a guid for traces using trace specific rows to specific [Diagnostics.ActivityId\(\) as text](https://docs.microsoft.com/en-us/powerquery-m/diagnostics-activityid)
```js
= Diagnostics.ActivityId()
```


## Function: `Error.Record()` signature

Creates the record to `throw`

```js
Error.Record(
    reason as text,
    optional message as nullable text,
    optional detail as any,
    optional parameters as nullable list) as record
```
## See Also 

  - what's new: [New Power Query M Language Keyword: catch](https://powerquery.microsoft.com/en-us/blog/new-power-query-m-language-keyword-catch/)
  - pq docs [Error.Record\(\)](https://docs.microsoft.com/en-us/powerquery-m/error-record)
  - [Diagnostics.Trace\(\)](https://docs.microsoft.com/en-us/powerquery-m/diagnostics-trace)
  - [Diagnostics.ActivityId\(\) as text](https://docs.microsoft.com/en-us/powerquery-m/diagnostics-activityid)
  - what's new: [bengribaudo.com: Structured Error Messages](https://bengribaudo.com/blog/2022/05/24/6753/new-m-feature-structured-error-messages)
  - [bengribaudo.com: power-query-m-primer-part-15-error-handling](https://bengribaudo.com/blog/2020/01/15/4883/power-query-m-primer-part-15-error-handling)
  - Power Query Formal Language Specs.pdf


## Examples from the Docs

The `Ellipsis` expression is **sugar** for throwing this expression
```js
x =...
```
is equivalent to 
```js
x = error Error.Record("Expression.Error", "Not Implemented")
```
This expression
```js
x = error Error.Record(
    "FileNotFound", "File my.txt not found", "my.txt")
```
is equivalent to
```js
x = error [
    Reason = "FileNotFound",
    Message = "File my.txt not found",
    Detail  = "my.txt"
]
```
more examples

## Extra Requirements Specific to Try Catch

- The catch **function must be defined inline**, so a reference to a function cannot be used.
- `each` cannot be used to define the `catch-function`
- the function defintion **cannot include any type constraints**

## Try Expression Types

### Try <Expression> catch (e) => <Expression>

```js
= Table.AddColumn(
Source, 
    "Clean Standard Rate",
    each 
        try [Standard Rate]
        catch (e) =>
            if e[Message] = "Invalid cell value '#REF!'." then [Special Rate] * 2
            else if e[Message] = "Invalid cell value '#DIV/0!'." then [Special Rate] / 3
            else 0
)
```


### Try <Expression> catch () => <Expression>

Functionally equivalent to `try <e> otherwise <e>`

```js
let
    x = try 1 / 0
        catch () => "null"
in 
    x
```

### Try <Expression> otherwise <Expression>
```js
let
    x = try 1 / 0 
        otherwise "null"
in 
    x
```
### Try <Expression>

```js
let
    x = try "A"
in
    if x[HasError] then x[Error] else x[Value]
```

## yaml summary
```yml
returns:
    type: record
reason: 
    type: text
    default: "Expression.Error"
    notes: . | 
        the default value isn't mandatory, may be implementation details and change
message:
    type: optional nullable text

detail:
    type: optional detail as any

parameters:
    type: optional nullable list
```


