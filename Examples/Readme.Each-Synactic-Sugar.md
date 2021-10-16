
## Walkthrough, Example converting `each` functions
Short version:
```ts
List.Generate(() => 0, each _ > 5, each _ + 1)
```
```ts
//formatted
numbers = List.Generate(
    () => 0,
    each _ < 5,
    each _ + 1,
    each _
)
```
Same results, without the each-sugar
```ts
numbers = List.Generate(
    ()  => 0,       // initialize
    (x) => x < 5,   // test condition
    (x) => x + 1,   // increment/update
    (x) => x        // optional transform
)
```
```ts
squares = List.Generate(
    ()  => 0,       // initialize
    (x) => x < 5,   // test condition
    (x) => x + 1    // increment/update
    (x) => x * x    // transform
)
```
### Explicit `Each` functions

`each` is synactic sugar. To be explicit:

```ts
each
    _ < 5
```
is equivalent to
```ts
(x as any) as any =>
    x < 5
```