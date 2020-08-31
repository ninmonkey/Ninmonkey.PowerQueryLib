
/*


Todo
    Type.AsText() will invoke this for non-primative type checking

    Should Type.AsText()
    See: Type.AsText() to get primative ty

Better naming?
    Serialize.ExtendedTypeName()
    Serialize.ExtendedType()
    ExtendedTypeName.AsText()


*/
let

    /* Optional parameter: Is this being used as part of a function signature? */
    ExtendedTypeName.AsText =  (x, optional funtype as logical) =>
        let
            isFunctionType = (x as type) => try if Type.FunctionReturn(x) is type then true else false otherwise false,
            isTableType = (x as type) =>  try if Type.TableSchema(x) is table then true else false otherwise false,
            isRecordType = (x as type) => try if Type.ClosedRecord(x) is type then true else false otherwise false,
            isListType = (x as type) => try if Type.ListItem(x) is type then true else false otherwise false
        in
            if funtype = null and isTableType(x) then "Table"
            else if funtype = null and isListType(x) then "list"
            else if funtype = null and isFunctionType(x) then "Function"
            else if funtype = null and isRecordType(x) then "Record"
            else if x = type any then "any"
            else let base = Type.NonNullable(x) in
                (if Type.IsNullable(x) then "nullable " else "") &
                (if base = type anynonnull then "anynonnull" else
                if base = type binary then "binary" else
                if base = type date   then "date"   else
                if base = type datetime then "datetime" else
                if base = type datetimezone then "datetimezone" else
                if base = type duration then "duration" else
                if base = type logical then "logical" else
                if base = type none then "none" else
                if base = type null then "null" else
                if base = type number then "number" else
                if base = type text then "text" else
                if base = type time then "time" else
                if base = type type then "type" else

                /* Abstract types: */
                if base = type function then "function" else
                if base = type table then "table" else
                if base = type record then "record" else
                if base = type list then "list"
                else "any /*Actually unknown type*/")
in
    ExtendedTypeName.AsText
