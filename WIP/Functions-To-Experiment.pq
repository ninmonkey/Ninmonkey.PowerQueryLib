/*
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMjIwUggO9FOK1YlWMjWwgLPNkdhGBsZwtkWwi1JsLAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Unit = _t]),
    #"Added Index" = Table.AddIndexColumn(Source, "Unit Id", 0, 1, Int64.Type),
    #"Renamed Columns" = Table.RenameColumns(#"Added Index",{{"Unit", "UnitName"}}),
    Custom1 = ItemExpression.From( each Text.Combine({"a".."e"}, ", ") ),
    Custom2 = ItemExpression.From( each Table.Combine ),
    Value = Value.Metadata( Custom2 ),
    Custom3 = ItemExpression.From
in
    Custom3
*/
let
    ItemExpression.From  = ItemExpression.From,
    ItemExpression.Item  = ItemExpression.Item,
    // sep
    Table.View         = Table.View,
    Table.ViewFunction = Table.ViewFunction,
    // sep

    Table.ToRows              = Table.ToRows,
    Table.ToColumns           = Table.ToColumns,
    Table.ApproximateRowCount = Table.ApproximateRowCount,
    Tables.GetRelationships   = Tables.GetRelationships,
    // sep: split/repeat
    Table.FromPartitions  = Table.FromPartitions,
    Table.Partition       = Table.Partition,
    Table.PartitionValues = Table.PartitionValues,
    Table.Split           = Table.Split,
    Table.SplitColumn     = Table.SplitColumn,
    List.Repeat           = List.Repeat,
    Text.Repeat           = Text.Repeat,
    Table.Repeat          = Table.Repeat,
    // sep:  transform:
    BinaryFormat.Transform     = BinaryFormat.Transform,
    List.TransformMany         = List.TransformMany,
    Table.TransformColumnNames = Table.TransformColumnNames,
    Table.TransformColumns     = Table.TransformColumns,
    Table.TransformColumnTypes = Table.TransformColumnTypes,
    Table.TransformRows        = Table.TransformRows,

    // sep
    Table.Transpose   = Table.Transpose,
    Table.InsertRows  = Table.InsertRows,
    Table.ReverseRows = Table.ReverseRows,
    //sep
    Table.MatchesAllRows = Table.MatchesAllRows,
    Table.MatchesAnyRows = Table.MatchesAnyRows,
    //sep
    Table.ReplaceRelationshipIdentity = Table.ReplaceRelationshipIdentity,
    Table.ReplaceKeys                 = Table.ReplaceKeys,
    Table.ReplaceMatchingRows         = Table.ReplaceMatchingRows,
    // sep
    Expression.Constant   = Expression.Constant,
    Expression.Evaluate   = Expression.Evaluate,
    Expression.Identifier = Expression.Identifier,
    //
    RowExpression.Column = RowExpression.Column,
    RowExpression.Row    = RowExpression.Row,
    RowExpression.From   = RowExpression.From,
    //
    Table.ColumnsOfType = Table.ColumnsOfType,
    Table.ReorderColumns = Table.ReorderColumns,
    Table.PrefixColumns = Table.PrefixColumns,
    JoinSide.Left = JoinSide.Left,

    a = DirectQueryCapabilities.From,
    // Value.ResourceExpression()
    x = Facts.Summarize,
    y = Type.ReplaceFacets,
    z = FactCheck,

    // record
    Record.TransformFields = Record.TransformFields,

    JoinAlgorithm.Type = JoinAlgorithm.Type,

    // types

in
    final
