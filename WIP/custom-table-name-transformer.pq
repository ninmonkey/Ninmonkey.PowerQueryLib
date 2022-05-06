let
    z =
    (name as text) as text =>
    let //original: https://bengribaudo.com/blog/2018/05/18/4447/automating-column-name-renames
    #"Split into Parts" = Text.Split(name, "_"),
    #"Change Case" =
        (input as text) as text =>
        if Comparer.Equals(Comparer.OrdinalIgnoreCase, "id", input)
        then Text.Upper(input)
        else Text.Proper(input),
        #"Transformed Parts" = List.Transform(#"Split into Parts", #"Change Case"),
        Result = Text.Combine(#"Transformed Parts", " ")
    in
    Result
in
    z


// usage

let
  Source = ...,
  #"Transform Column Names" = Table.TransformColumnNames(Source, #"Column Name Transformer")
in
  #"Transform Column Names"
