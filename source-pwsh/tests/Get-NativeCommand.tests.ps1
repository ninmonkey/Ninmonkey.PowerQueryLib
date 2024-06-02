Import-Module Pester -ea 'stop' -MinimumVersion '5.0' -PassThru
Import-Module (Join-Path $PSScriptRoot '../Nin.PqLib.psd1' ) -Force -ea 'continue'

Describe 'Nin.PqLib NativeCommands' {
    BeforeAll {
        if((gcm -ea 'ignore' 'git' -CommandType Application).count -eq 0) {
            write-warning '"git" may not be in the path. Expect tests to fail'
        }
    }

    Context 'GetNativeCommand' {
        it 'IsA ApplicationInfo' {
            Get-PqLibNativeCommand -CommandName 'git'
                | Should -BeOfType ([System.Management.Automation.ApplicationInfo])
        }
        it 'Throws If Missing' {
            { Get-PqLibNativeCommand -CommandName 'DoesNotExist' }
                | Should -Throw -Because 'Cmd Path is not real'
        }
    }
    Context 'GetNativeCommandFast' {
        it 'IsA String' {
            Get-PqLibNativeCommandFast -CommandName 'git'
                | Should -BeOfType ([string])
        }
        it 'Finds git' {
            (Get-PqLibNativeCommandFast -CommandName 'git').count -gt 0
                | Should -Be $true -Because 'Expect at least one result'

        }
    }
}
