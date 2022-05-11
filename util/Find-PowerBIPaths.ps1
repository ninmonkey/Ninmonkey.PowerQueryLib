class PathInfo {
    <#
    future:
        Format-Wide should return property Path
    #>
    [ValidateNotNullOrEmpty()] # or maybe not, actually depending on goal
    [IO.DirectoryInfo]$Path
    [string]$Description = ''
    [string[]]$Tags = @()

    [string]relativePath() {
        return (ConvertTo-EnvVarPath $_.Path )
    }

    [string]ToString() {
        return $this.Path.FullName
    }
}

@'
## See more:

- https://docs.microsoft.com/en-us/power-query/samples/trippin/8-diagnostics/readme
- https://docs.microsoft.com/en-us/power-query/samplesdirectory#odbc
- https://docs.microsoft.com/en-us/power-query/handlingauthentication

## Best Practice Analyzer

- https://github.com/microsoft/Analysis-Services/tree/master/BestPracticeRules#setup-automated
- https://www.elegantbi.com/post/vertipaqintabulareditor
- https://powerbi.microsoft.com/en-us/blog/best-practice-rules-to-improve-your-models-performance/

## Some query tracing related:

- https://blog.crossjoin.co.uk/2016/06/09/power-bi-diagnostics-trace-logs-and-query-execution-times-again/
- https://blog.crossjoin.co.uk/2015/04/30/using-function-invokeafter-in-power-query/
- https://blog.crossjoin.co.uk/2014/12/11/reading-the-power-query-trace-filewith-power-query/
- https://blog.crossjoin.co.uk/2014/11/14/waiting-between-web-service-requests-in-power-query/

## library / repo

- https://github.com/m-kovalsky/Tabular
    - from: https://www.elegantbi.com/post/vertipaqintabulareditor

## Best practice analyzer <https://docs.tabulareditor.com/te2/Best-Practice-Analyzer.html>

    Note that the rule ID's must always be unique. In case a rule within the model metadata has the same ID as a rule in the %AppData% or %ProgramData% folder, the order of precedence is:

        Rules stored locally in the model
        Rules stored in the %AppData%\Local folder
        Rules stored in the %ProgramData% folder

'@ | Write-Debug


$__fileList = @(
    [PathInfo]@{
        Path        = "$Env:UserProfile\Microsoft\Power BI Desktop Store App\Traces\Performance"
        Tags        = @(
            'PowerBI-Desktop', 'AppStore_Install',
            'Tracing'
        )
        Description = @'
Performance traces logs, like:
    'Microsoft.Mashup.Container.NetFX45.40240.2022-05-04T18-57-50-316600',
    'msmdsrv.14640.2022-05-06T16-33-08-323610.log',
    'PBIDesktop.1132.2022-05-05T18-10-58-525755.log'
'@
    }

    [PathInfo]@{
        Path        = "$Env:UserProfile\Microsoft\Power BI Desktop Store App\Traces"
        Tags        = @(
            'PowerBI-Desktop', 'ToVerify',
            'AppStore_Install', 'Tracing'
        )
        Description = @'
Non-perf traces compared to the subdir? I am not sure.

logs, like:
    'Microsoft.Mashup.Container.NetFX45.11092.2022-04-06T16-03-31-038263',
    'msmdsrv.20864.2022-04-06T16-03-40-896581'
    'PBIDesktop.21368.2022-04-06T16-03-30-979587.log',
'@
    }
    [PathInfo]@{
        Path        = "$Env:UserProfile\Microsoft\Power BI Desktop Store App\Traces\Diagnostics"
        Tags        = @(
            'PowerBI-Desktop', 'ToVerify',
            'AppStore_Install', 'Tracing'
        )
        Description = @'
Currently empty, to confirm whether it's just a cleared folder or what.

logs, like:

'@
    }
    [PathInfo]@{
        Path        = "$Env:localAPPDATA\TabularEditor\BPARules.json"
        Tags        = @('BestPracticeAnalyzer')
        Description = @'
Global Rules
'@
    }
    [PathInfo]@{
        Path        = "$Env:programdata\TabularEditor\BPARules.json"
        Tags        = @('BestPracticeAnalyzer')
        Description = @'
Also Global rules
'@
    }
    [PathInfo]@{
        Path        = "$Env:LocalAppData\DaxStudio\Log"
        Tags        = @('DaxStudio', 'Log')
        Description = @'
Dax Studio Logs
'@
    }
    [PathInfo]@{
        Path        = "$Env:LocalAppData\DaxStudio\Log"
        Tags        = @('DaxStudio', 'Log')
        Description = @'
Dax Studio Logs
'@
    }
)

function Find-PowerBIPaths {
    <#
    .SYNOPSIS
        scripted cheat sheet for PowerBI/Tabular/AS related paths in one spot
    #>
    [CmdletBinding()]
    param()
    return $__fileList
}

Find-PowerBIPaths
| Format-List
