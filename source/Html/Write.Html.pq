[
    /* a colleciton of functions to write Html Elements, or use StringBuilders
    */

    // Write.Html.Bold = (source as text) as text => "<b>" & source & "</b>",
    Str = [
        LineEnding = "#(cr,lf)",
        NullStr    = "#(2400)",
        SpaceStr   = "#(2420)",
        Tab        = "#(tab)"
    ],

    Write.Html.Element = ( elementName as text, content as text) as text =>
        Text.Format( "<#[name]>#[content]</#[name]>", [ name = elementName, content = content ] ),

    Write.Html.Bold           = (content as text) as text => Write.Html.Element("b", content),
    Write.Html.Paragraph      = (content as text) as text => Write.Html.Element("p", content),
    Write.Html.ElementClosing = (elementName as text) as text => "<" & elementName & "/>",
    Write.Html.KeyValue       = (key as text, value as text) as text =>
        Text.Format (
            "#[key]: #[value]", [
                key = Write.Html.Bold( key ),
                value = value
            ]
        ),
    StringBuilder.Join          = (items as list, optional options as nullable record) as text => [
            return = Text.Combine( items, Str[LineEnding] )
        ][return],

    StringBuilder.JoinParagraph  = (items as list, optional options as nullable record) as text => [
            paraList = List.Transform( items, (para) => Write.Html.Paragraph( para ) ),
            return =   StringBuilder.Join( paraList )
        ][return],

    Write.Html.UnorderedList = (items as list) as text => [
        itemsList = List.Transform( items, (cur) => Write.Html.Element( "li", cur ) ),
        return    = Write.Html.Element( "ul", Text.Combine( itemsList, Str[LineEnding] ) )
    ][return],

    // optional aliases
    Write.Element = Write.Html.Element,
    Write.Key     = Write.Html.KeyValue,
    Tag           = Write.Html.Element,
    P             = Write.Html.Paragraph,
    B             = Write.Html.Bold,
    UL            = Write.Html.UnorderedList
]