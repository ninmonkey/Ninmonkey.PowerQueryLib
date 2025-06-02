## Conditional format using a gradient
```ts
[ HSL Hue from Sales ] = 
    // simpler version, which scales hue from 0 degrees to maxHue
    // outputs a gradient like: 
        // hsl(   0, 80%, 78%) 
        // hsl(  40, 80%, 78%) 
        // hsl( 160, 80%, 78%)
    var maxHue = 160

    // Can this ALL() be rewritten to run faster? 
    VAR CurrentValue = SELECTEDVALUE( Sale[Value], 0 )
    VAR MinValue     = CALCULATE( MIN(Sale[Value]), All( Sale[Value] ) )  
    VAR MaxValue     = CALCULATE( MAX(Sale[Value]), All( Sale[Value] ) )
    
    var relativeValue = 
        DIVIDE(
            CurrentValue - MinValue,
            MaxValue - MinValue, 
            0 
        )

    // outputs the color string: "hsl( 60, 80%, 78% )"
    var renderInt  = format( (relativeValue * maxHue), "#,0", "en-us" )
    var finalColor = "hsl( " & renderInt & ", 80%, 80%)"
    return finalColor
```

## Static Measure to Test Syntax

To use one, choose conditional formatting:

- format style: field alpha
- applies to: values only
- which field: your measure

Here's a bunch of options. Type `ctrl+/` to quickly comment the lines on and off to compare them.

```ts
[ Color Test ] =   
    // note: alpha uses the range [ 0.0, 1.0 ]  to mean 0% to 100% visible
    return
        "#ff00ff1f" // magenta, 50%
        // "#ff00ff"   // magenta
        // "rgba( 255, 0, 255, 0.4 )"
        // "rgb(255, 0, 255 )"
        // "salmon"
        // "hsla( 219, 68%, 20%, 0.5 )"
        // "hsl( 219, 68%, 20% )"
```

```ts
[ Conditional Alpha ] =
    // alpha is in the range [0.0, 1.0]
    var curDecimal = SELECTEDVALUE( Nums[Frac], 0 )
    return 
        "hsla(219, 68%, 20%," & curDecimal & ")"
```
```ts
[ Conditional Rgb ] = 
    // values are in the range [0, 255]
    var curR = SELECTEDVALUE( Nums[Decimal], 255 ) 
    var curG = SELECTEDVALUE( Nums[Decimal], 255 )
    var curB = SELECTEDVALUE( Nums[Decimal], 255 )
    return "rgb(" & curR
            & ", " & curG
            & ", " & curB
            & ")"
```

## Docs describing the syntax

- [using `HSL`](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/hsl)
- [using `RGB`](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/rgb)
- [using `LCH`](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/lch) ( Not currently enabled, maybe in the future? )
