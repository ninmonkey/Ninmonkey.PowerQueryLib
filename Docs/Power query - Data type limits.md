# Power Query: Data types

Notes on data types in powerquery. It includes `primative types` and custom types.


## `number`

Docs: 
> docs: A `number` is represented with **at least the precision** of a `Double` (but may retain more precision). The `Double` representation is congruent with the `IEEE 64-bit double` precision standard for binary floating point arithmetic
>  `Double` representation have an approximate dynamic range from `5.0 × 10−324` to `1.7 × 10308` with a **precision of 15-16 digits**



## `Decimal.Type`

Docs:
> representation have an **approximate dynamic range** from `5.0 × 10−324` to `1.7 × 10308` with a
**precision of 15-16 digits**


## `duration`

full value is signed `int64` ? 

Docs:
> A `duration` value stores an opaque representation of the distance between two points on a timeline **measured 100-nanosecond ticks**. The magnitude of a duration can be either positive or negative, with positive values denoting progress forwards in time and negative values denoting progress backwards in time.
> The **minimum value** that can be stored in a duration is `-9,223,372,036,854,775,808 ticks`, or `10,675,199 days 2 hours 48 minutes 05.4775808 seconds` backwards in time
> The **maximum value** that can be stored in a duration is `9,223,372,036,854,775,807 ticks`, or `10,675,199 days 2 hours 48 minutes 05.4775807 seconds` forwards in time.


### .net test

```powershell
🐒> [timespan]::MaxValue.tostring()
10675199.02:48:05.4775807

🐒> [timespan]::MaxValue

Days              : 10675199
Hours             : 2
Minutes           : 48
Seconds           : 5
Milliseconds      : 477
Ticks             : 9223372036854775807
TotalDays         : 10675199.1167301
TotalHours        : 256204778.801522
TotalMinutes      : 15372286728.0913
TotalSeconds      : 922337203685.478
TotalMilliseconds : 922337203685477

# h1 "FromUnixTimeSeconds( $unixTime )"
$unixTime = 1604073449
[DateTimeOffset]::FromUnixTimeSeconds( $unixTime )

# h1 "FromUnixTimeMilliseconds( $unixTime )"
[DateTimeOffset]::FromUnixTimeMilliseconds( $unixTime )
```