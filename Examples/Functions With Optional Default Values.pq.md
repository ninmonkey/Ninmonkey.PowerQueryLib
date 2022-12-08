```sdfs
```


- 1] the syntax to declare a default, optional value named 'encoding'

- 2] if 'encoding' is missing or null, then set the value to Utf8.

- 3] you can "declare" local variables by using an inner let-expression
        
- 4] Local variables
        

```sql
let
    /* this demonstrates a few things:

        the variable 'declaring 'encoding' inside the inner let expression is like a local variable
            the variable is "shadowing" the variable of the outer scope.
            
    */
    TextToBytes = (source as text, optional encoding as nullable number) => 
        let 
            encoding = encoding ?? TextEncoding.Utf8,
            bytes = Text.ToBinary(source, encoding )
        in 
            bytes,

    // Custom3 = Value.Metadata( Text.ToBinary ),
    Example = [
        defaults = TextToBytes("hi #(0001F412) world!"), // 14 bytes
        ascii =    TextToBytes("hi #(0001F412) world!", TextEncoding.Ascii ), // 12 bytes

        // encoding a monkey U+1f412 as ascii, will destroy it. 
        #"round trip: ascii" = Text.FromBinary(ascii, TextEncoding.Ascii),

        // encoding as utf8 works
        #"round trip:  utf8" = Text.FromBinary(defaults, TextEncoding.Utf8)
    ]

in
    Example
```
