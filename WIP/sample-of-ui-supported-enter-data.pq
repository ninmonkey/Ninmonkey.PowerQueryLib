let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCsnPyc5MzVPSUTI0sjQBUkbGBgYGSrE60UoupXmpQAFTUyOQuImxpZFSbCwA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#" Book Name" = _t, Year = _t, Sales = _t])
in
    Source