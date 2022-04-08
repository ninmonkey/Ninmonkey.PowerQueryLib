
clean up queries, like running web.contents ?














 Example snippets

## `Let` expression

```ts
    (_) as any =>
        x = Table.SelectRows(source, each [x] )
// to
    (_) as any =>
        let
            selection = 10
        in
            selection

```

## convert to `function` expression

```ts

        cat = 30,
        zed = ...
// to
    cat = (_) => {selection},

    or
    cat = ($1 as ax) =>
        let
            $2 = 30
        in
            $2,


    or
```
