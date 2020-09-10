# Common 'allowed values'

These are common types to reuse in `Documentation.AllowedValues` blocks

## RoundingMode

```pq
{ RoundingMode.AwayFromZero, RoundingMode.Down, RoundingMode.ToEven, RoundingMode.TowardZero, RoundingMode.Up }
```

## Text Encoding

```pq
{ TextEncoding.Ascii, TextEncoding.BigEndianUnicode, TextEncoding.Unicode, TextEncoding.Utf16, TextEncoding.Utf8, TextEncoding.Windows }
```

## Numbers and Precision

```pq
{ Precision.Double, Precision.Decimal }
```

## Byte Order (BOM)

```pq
{ ByteOrder.BigEndian, ByteOrder.LittleEndian }
```

## Occurrence

```pq
{ Occurrence.Optional, Occurrence.Repeating, Occurrence.Required }
```

## BinaryOccurence

```pq
{ BinaryOccurrence.Optional, BinaryOccurrence.Repeating, BinaryOccurrence.Required }
```

## BinaryEncoding

```p1
{ BinaryEncoding.Base64, BinaryEncoding.Hex }
```

## Compression

```pq
{ Compression.Brotli, Compression.Deflate, Compression.GZip, Compression.LZ4, Compression.None, Compression.Snappy, Compression.Zstandard }
```

## Web Method

```pq
{ WebMethod.Delete, WebMethod.Get, WebMethod.Head, WebMethod.Patch, WebMethod.Post, WebMethod.Put }
```

## Csv Style

```pq
CsvStyle.QuoteAfterDelimiter, CsvStyle.QuoteAlways
```

## Days

```pq
{ Day.Friday, Day.Monday, Day.Saturday, Day.Sunday, Day.Thursday, Day.Tuesday, Day.Wednesday }
```

## Extra Values

```pq
{ ExtraValues.Error, ExtraValues.Ignore, ExtraValues.List }
```
