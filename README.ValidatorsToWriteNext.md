# About: Wishlist / or Ideas of PowerQuery Validation Scripts

Potential future rules/parsers.

## Implementation 

Either:
- [ ] PQ on the CLI, and/or PQ Parser
- [ ] Tabular editor C# rules using Tabular2/3 ( or even by itself )

## Fatal/Mandatory

- [ ] ScriptIsSynacticallyValid / no parse errors

## Quality / Preference

- [ ] either `some_table` or `someTable` or `SomeTable` or `Some.Table` or `#"Some Table"
    - [ ] pick one, and be consistant

## Special warnings, not always fatal

- [ ] nested `each function`, warn may be missing
- [ ] like the linter message: You used `stuff` did you mean `Stuff`
- [ ] Identifier references are missing ( ie: 2nd query in the advanced editor )
- [ ] Invisible Datetime Intelligence Tables found

# Validate Parameters in functions

- [ ] Inspect existing connector's code for patterns

## Text

- [ ] WarnOnInvisibleCharacters: invisible control chars should give a warning

# Wanted

- [ ] Assert `t` is one of union `Union([int, text, Currency.Type])`

## Numerical

- [ ] DisallowDefaultValueAsAggregate : Undo any non-numerical 
- [ ] ValidateRange(min,max) numerical ranges
- [ ] Assert List has N count items
- [ ] Assert List is all of the same type

### coercion


Resolve.Text =
    if text return
    else Text.From(..)

### ex

fn_Example( source as list, ...)
    Assert.CompatibleWithUnion( source, Union(int | text | currency) )


### ex

fn_AverageSales( source as list ):
    entire list is of `{ Currency.Type }` 
    not just a `{ Int64 }`
