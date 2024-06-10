let
    /*
    About: Compare different optional parameter types
    From this blog post: https://ninmonkeys.com/blog/2024/06/05/power-query-functions-part1-using-optional-parameters
    source: https://github.com/ninmonkey/Ninmonkey.PowerQueryLib/blob/bf4e1d63b8bb9ffe3b3e4df0d687435bb88be30d/Examples-Blog/Custom%20Functions/Part%201%20-%20Using%20Optional%20Parameters.pq


    lets call Text.Combine() to test declaring optional parameters:

    For this version:
        - you can pass a null value for a separator
        - always requires you pass 2 parameters
    */
    Join_Nullable = (texts as list, separator as nullable text) =>
        Text.Combine( texts, separator ),

    /*
    For this version:
        - you can pass a null value for a separator
        - you can skip the second parameter
        - 'optional' parameters are automatically 'nullable',
            so you can drop the 'nullable' part

    This is how library functions have multiple call signatures
    Power Query defines one function

    Other languages let you define multiple functions with shared name
    Based on the argument types, it'll call a different overloaded function
    */
    Join_Optional = (texts as list, optional separator as text) =>
        Text.Combine( texts, separator ),

    Summary = [
        chars = { "a".."h" }, // example array of strings

        // this version lets you pass an explicit null value
        Nullable_1 = Join_Nullable( chars, ", " ),
        Nullable_2 = Join_Nullable( chars, null ),

        // but it requires you to pass something. It doesn't let you omit a parameter
        Nullable_3 = Join_Nullable( chars ),

        // this version lets you pass an explicit null value
        // or drop the parameter completely
        Join_Optional_1 = Join_Optional( chars, ", " ),
        Join_Optional_2 = Join_Optional( chars, null ),
        Join_Optional_3 = Join_Optional( chars )
    ]
in Summary
