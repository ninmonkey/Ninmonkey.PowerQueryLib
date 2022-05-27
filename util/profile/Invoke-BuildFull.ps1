
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
        'DateTable_FromDates.pq'
        'DateTime.FromUnixTime.pq'
        'Inspect_Function.pq'
        'Inspect.Metadata.pq'
        'Inspect.MetaOfType.pq'
        'Inspect.Type.pq'
        'List.ContinuousDates.pq'
        'List.Summarize.pq'
        'List.Summarize.pq'
        'ParameterQuery.Summary.pq'
        'Query_Summary.pq'
        'Record.Schema.pq'
        'Record.Summarize.pq'
        'Record.Summarize.pq'
        'Serialize.ExtendedType.pq'
        'Serialize.List.pq'
        'Serialize.Text.pq'
        'Summarize.Record.pq'
        'Table.SelectRemovedColumns.pq'
        'Type.ToText.pq'
        'WebRequest_Simple.pq'
        # 'ConvertTo-Markdown.pq'
        # 'Html.GenerateSelectorList.pq'
        # 'Html.GetScalar.pq'
        # 'List_RandomItem.pq'
        # 'List.Combine_BitFlags.pq'
        # 'List.Schema.pq'
        # 'Number.From_TextWithBase.pq'
        # 'Number.ToHexString.pq'
        # 'Random.Currency.pq'
        # 'Random.Int.pq'
        # 'Summarize_Record.recursion.tests.pq'
        # 'Summarize.Rec.pq'
        # 'Table.FindNotDistinctRows.pq'
        # 'Table.ToJson.pq'
        # 'Text_JsonToPowerQuery.pq'
        # 'Text.AnyMatches.pq'
        # 'Text.IsNullOrWhitespace.pq'
        # 'Text.ToUnorderedList.pq'
        # 'validate_record_for_function_calls.pq'
        # 'Value.ToPowerQuery.pq'
        # 'waitForResult.pq'
        # 'WebRequest.ToRecord.pq'
        # newest: 2022-01


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
    # ExportPath    = Join-Path "${Env:UserProfile}" 'SkyDrive\Documents\2021\Ninmonkeys.com\Experiments-Of-Week\2022-02-02\.ninlib'
    #                   'SkyDrive\Documents\2021\Ninmonkeys.com\Experiments-Of-Week\2022-02-02\.ninlib'
    # 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Power BI\My_Github\Ninmonkey.PowerQueryLib\.output\ninlib.pq'
    # 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Power BI\My_Github\Ninmonkey.PowerQueryLib\util\profile\Invoke-BuildFull.ps1'
    # ExportPath    = Join-Path "${Env:UserProfile}" 'SkyDrive\Documents\2021\Ninmonkeys.com\Experiments-Of-Week\2022-02-02\.ninlib'
    # ExportPath    = Get-Item -ea stop 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Power BI\My_Forks\powerquery-parser-report\ninlib.pq'
    # 'C:\Users\cppmo_000\SkyDrive\Documents\2021\My_Github\AdventOfCode\utils\ninlib_adventOfCode.pq'
}
if (Test-Path $invokeBuildPowerQueryLibSplat['ExportPath']) {
} else {
    mkdir $invokeBuildPowerQueryLibSplat['ExportPath'] -Confirm
    $invokeBuildPowerQueryLibSplat['ExportPath'] = Get-Item -ea stop $invokeBuildPowerQueryLibSplat['ExportPath']

}
# Copy-Item $invokeBuildPowerQueryLibSplat.ExportPath -Destination
$invokeBuildPowerQueryLibSplat | format-dict
$results = Invoke-BuildPowerQueryLib @invokeBuildPowerQueryLibSplat -ea break

# $Results | format-dict
