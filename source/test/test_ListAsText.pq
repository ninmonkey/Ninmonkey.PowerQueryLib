let
    items = {7, 10, 40, 3},
    Summary = [
        asText = ListAsText(items),
        a2 = ListAsText(items, "."),
        a3 = ListAsText(items, ".", "<-"),
        a4 = ListAsText(items, ".", "<-", "->"),
        a5List = ListAsText(items, "#(cr)• ", "• ", ""),
        a6 = ListAsText(items, ".", "IP addr = ", "")
    ]
in
    Summary
