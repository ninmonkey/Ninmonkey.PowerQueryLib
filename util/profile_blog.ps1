. (Join-Path $PSSCriptRoot 'Invoke-BuildPowerQueryLib.ps1')

$RegexIncludeList = @(
    # 'web'
    # 'text'
    # 'date'
    # 'summarize'
    'ToText'
    'Text'
    'list'
    # 'inspect'
)
$RegexExcludeList = @(
    # '.*'
    '$test_'
    'wordwrap'
    'IP\.Dot'
    'regex'
    'shared -'
    'inspect'
    'WebRequest'
    '\.old\.pq$'
)



$Options = @{
    IncludeFile = @(
        # 'ConvertTo-Markdown.pq'
        # 'DateTable_FromDates.pq'
        # 'DateTime.FromUnixTime.pq'
        # 'Html.GenerateSelectorList.pq'
        # 'Html.GetScalar.pq'
        # 'Inspect_Function.pq'
        # 'List_RandomItem.pq'
        # 'List.Combine_BitFlags.pq'
        # 'List.ContiguousDates.pq'
        # 'List.Schema.pq'
        'List.Summarize.pq'
        # 'Number.From_TextWithBase.pq'
        # 'Number.ToHexString.pq'
        # 'Query_Summary.pq'
        # 'Random.Currency.pq'
        # 'Random.Int.pq'
        # 'Record.Schema.pq'
        # 'Serialize.ExtendedType.pq'
        # 'Serialize.List.pq'
        # 'Serialize.Text.pq'
        # 'Summarize_Record.recursion.tests.pq'
        # 'Summarize.Record.pq'
        # 'Table.FindNotDistinctRows.pq'
        # 'Table.ToJson.pq'
        # 'Text_JsonToPowerQuery.pq'
        # 'Text.AnyMatches.pq'
        # 'Text.IsNullOrWhitespace.pq'
        # 'Text.ToUnorderedList.pq'
        'Type.ToText.pq'
        # 'validate_record_for_function_calls.pq'
        # 'Value.ToPowerQuery.pq'
        # 'waitForResult.pq'
        # 'WebRequest_Simple.pq'
        # 'WebRequest.ToRecord.pq'
    )
}
# $Options['IncludeFile'] = Get-ChildItem ../.. -Recurse *.pq | ForEach-Object name


$LibRoot = Join-Path $PSScriptRoot 'source' | Get-Item -ea ignore
$invokeBuildPowerQueryLibSplat = @{
    IncludeRegex  = $RegexIncludeList
    ExcludeRegex  = $RegexExcludeList
    Options       = $Options
    BaseDirectory = $LibRoot
    Infa          = 'Continue'
    ExportPath    = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Power BI\Buffer\2021-10\sketch for blog - 2021-10\import\blog_sketch.pqlib.pq'
}
$invokeBuildPowerQueryLibSplat | format-dict
$results = Invoke-BuildPowerQueryLib @invokeBuildPowerQueryLibSplat

# $Results | format-dict
