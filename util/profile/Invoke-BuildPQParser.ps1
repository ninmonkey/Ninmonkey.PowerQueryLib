
. (Join-Path $PSSCriptRoot '../Invoke-BuildPowerQueryLib.ps1' | Get-Item -ea stop)

$RegexIncludeList = @(
    # 'web', text, date, summarize, list, inspect
    'ToText'
    'Text'
)
$RegexExcludeList = @(
    # 'inspect', 'web'
    '$test_'
    'wordwrap'
    'IP\.Dot'
    'regex'
    'shared -'
    'WebRequest'
    '\.old\.pq$'
)



$Options = @{
    IncludeFile = @(
        # 'ConvertTo-Markdown.pq'
        'DateTable_FromDates.pq'
        'DateTime.FromUnixTime.pq'
        # 'Html.GenerateSelectorList.pq'
        # 'Html.GetScalar.pq'
        'Inspect_Function.pq'
        'Inspect.Type.pq'
        'Record.Summarize.pq'
        'Inspect.Metadata.pq'
        'Inspect.MetaOfType.pq'
        # 'List_RandomItem.pq'
        # 'List.Combine_BitFlags.pq'
        'List.ContinuousDates.pq'
        # 'List.Schema.pq'
        'List.Summarize.pq'
        # 'Summarize.Rec.pq'

        # 'Number.From_TextWithBase.pq'
        # 'Number.ToHexString.pq'
        'Query_Summary.pq'
        # 'Random.Currency.pq'
        # 'Random.Int.pq'
        'Record.Schema.pq'
        'Serialize.ExtendedType.pq'
        'Serialize.List.pq'
        'Serialize.Text.pq'
        # 'Summarize_Record.recursion.tests.pq'
        'Summarize.Record.pq'
        'Record.Summarize.pq'
        'List.Summarize.pq'

        # 'Table.FindNotDistinctRows.pq'
        # 'Table.ToJson.pq'
        # 'Text_JsonToPowerQuery.pq'
        # 'Text.AnyMatches.pq'
        # 'Text.IsNullOrWhitespace.pq'
        # 'Text.ToUnorderedList.pq'
        'Type.ToText.pq'
        'Table.SelectRemovedColumns.pq'

        # 'validate_record_for_function_calls.pq'
        # 'Value.ToPowerQuery.pq'
        # 'waitForResult.pq'
        # 'WebRequest_Simple.pq'
        # 'WebRequest.ToRecord.pq'
    ) | Sort-Object -Unique
}
# $Options['IncludeFile'] = Get-ChildItem ../.. -Recurse *.pq | ForEach-Object name


$LibRoot = Join-Path $PSScriptRoot 'source' | Get-Item #-ea ignore
$invokeBuildPowerQueryLibSplat = @{
    IncludeRegex  = $RegexIncludeList
    ExcludeRegex  = $RegexExcludeList
    Options       = $Options
    BaseDirectory = $LibRoot
    Infa          = 'Continue'
    ExportPath    = Get-Item -ea stop 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Power BI\My_Forks\powerquery-parser-report\ninlib.pq'
    # 'C:\Users\cppmo_000\SkyDrive\Documents\2021\My_Github\AdventOfCode\utils\ninlib_adventOfCode.pq'
}
# Copy-Item $invokeBuildPowerQueryLibSplat.ExportPath -Destination
$invokeBuildPowerQueryLibSplat | format-dict
$results = Invoke-BuildPowerQueryLib @invokeBuildPowerQueryLibSplat -ea break

# $Results | format-dict
