[
    /*
    See Also:

    Links For Finding Unicode Characters

    - https://www.compart.com/en/unicode/block
    - https://emojipedia.org/zero-width-joiner
    - https://emojipedia.org/emoji-zwj-sequence

    Related Functions

    - Character.ToNumber()    : Converts string to codepoint
    - Character.FromNumber()  : Converts codepoint to string

    */

    // extra aliases
    CrLf              = LineEnding.CrLf,
    NL                = LineEnding.Lf,
    ZWJ               = Zero.Width.Joiner,

    // whitespace and control chars
    Indent            = "    ",
    LineEnding.Cr     = "#(cr)",             // is \r
    LineEnding.Lf     = "#(lf)",             // is \n
    LineEnding.CrLf   = "#(cr,lf)",          // is \r\n
    Tab               = "#(tab)",            // is \t
    Space             = " ",                 // is " "
    Zero.Width.Joiner = "#(200d)",           // is zwj
    Zero.Width.Space  = "#(200b)",           // is zws
    NullString        = "#(0000)",           // is \0

    // regular characters
    Triangle.Right.Small  = "#(25b8)",   // is ▸

    /*
    symbols: used to replace control characters and escape sequences with safe to print symbols
    */
    Symbol.Null            = "#(2400)",   // is ␀
    Symbol.Tab             = "#(2409)",   // is ␉
    Symbol.Space           = "#(2420)",   // is ␠
    Symbol.Escape          = "#(241b)",   // is ␛
    Symbol.NewLine         = "#(2424)",   // is ␤
    Symbol.CarriageReturn  = "#(240d)",   // is ␍
    Symbol.Backspace       = "#(2408)",   // is ␈
    Symbol.FormFeed        = "#(240c)",   // is ␌
    Symbol.VerticalTab     = "#(240b)",   // is ␋
    Symbol.GroupSeparator  = "#(241d)",   // is ␝
    Symbol.RecordSeparator = "#(241e)",   // is ␞
    Symbol.UnitSeparator   = "#(241f)",   // is ␟

    Bullet                 = "#(2022)",   // is •

    Emoji.ThumbsUp         = "#(0001f44d)", // is 👍
    Emoji.ThumbsDown       = "#(0001f44e)", // is 👎

    Emoji.Monkey         = "#(0001f412)" // is 🐒

    /* Powershell

    I use this trick all the time in Powershell. It lets you pipe binary data in interactive sessions


    In powershell I use this to savely pipe binary data in interactive sessions without fear of breaking the terminal.

    Pwsh>
    0..32 -as [Text.Rune[]] | Join-String -sep ''
        | Format-ControlChar

        ␀␁␂␃␄␅␆␇␈␉␊␋␌␍␎␏␐␑␒␓␔␕␖␗␘␙␚␛␜␝␞␟␠

    - From: [Format-ControlChar](https://github.com/ninmonkey/Ninmonkey.Console/blob/251a0a8431ae953bbce989bd9361aa9b5e36c7d8/public/Format-ControlChar.ps1#L51-L180)

    */


]

// ] //future: add documentation that has links:  Value.ReplaceType( UnicodeString, Record.Type )

