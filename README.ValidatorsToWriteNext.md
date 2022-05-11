# Validate Parameters in functions

- [ ] Inspect existing connector's code for patterns

# Wanted

- [ ] Assert `t` is one of union `Union([int, text, Currency.Type])`

## Numerical

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