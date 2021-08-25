# CompareCriteria, EquationCriteria

## `Comparison` criteria

See [Value.Compare](https://docs.microsoft.com/en-us/powerquery-m/value-compare)

```ts
Value.Compare(
    value1 as any,
    value2 as any,
    optional precision as nullable number
) as number 
```

`Comparison` criterion` can be provided as either of the following values:

- A number value to specify a sort order. See sort order in the parameter values section above.
- To **compute a key** to be used for sorting, a **`function` of 1 argument** can be used.
- To **both select a key and control order**, `comparison criterion` can be a list containing the key and order.
- To completely control the `comparison`, a `function` of 2 arguments can be used that returns `-1, 0, or 1` given the **relationship between the left and right inputs**. Value.Compare is a method that can be used to delegate this logic.

For examples, see description of Table.Sort.

## `Count` or `Condition` critieria

This **criteria** is generally used in ordering or row operations. It determines the number of rows returned in the table and can take two forms, a number or a `condition`:

1. A number indicates how many values to return inline with the appropriate `function`
1. If a `condition` is specified, the rows containing values that initially meet the `condition` is returned.
   1. Once a value fails the `condition`, no further values are considered.

## `Equation` criteria

See [Value.Equals](https://docs.microsoft.com/en-us/powerquery-m/value-equals)

```ts
Value.Equals(
    value1 as any,
    value2 as any,
    optional precision as nullable number
) as logical
```

Equation **criteria** for tables can be specified as either a

1. A `function` value that is either
    A key selector that determines the column in the table to apply the `equality criteria`, or
    A `comparer function` that is used to specify the kind of `comparison` to apply. Built in `comparer functions` can be specified, see section for `Comparer functions`.

2. A list of the columns in the table to apply the `equality criteria`

