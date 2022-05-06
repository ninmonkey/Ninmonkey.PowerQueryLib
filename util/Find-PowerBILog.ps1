class PathInfo {
    [string]$Description = ''
    [string[]]$Tags = @()

    [ValidateNotNull()] # or maybe not, actually depending on goal
    [IO.DirectoryInfo]$Path

    [string]ToString() {
        return $this.Path.FullName
    }
}

$fileList = @(
    [PathInfo]@{
        Path        = 'C:\Users\cppmo_000\AppData\Local\Packages\Microsoft.MicrosoftPowerBIDesktop_8wekyb3d8bbwe\LocalCache\Local\Microsoft\CLR_v4.0\UsageLogs'
        Description = "Example Logs: 'CefSharp.BrowserSubprocess.exe.log', 'Microsoft.Mashup.CefHelper.exe.log', 'Microsoft.Mashup.Container.NetFX45.exe.log', 'pbidesktop.exe.log'"
    }
)
