let
    todo = "
    about: validate optional record args in Function

    1] All(options.keys in AllowedKeys)
    2] assert ( options.keys notin AllowedKeys ).count = 0
    3] error
        InvalidKeyException,
        keyname
        supported keys are ...,

    4] invalid value type
        InvalidTypeError,
        Key[Foo] type != required type
        expects value  = typename
    "
in
    todo
