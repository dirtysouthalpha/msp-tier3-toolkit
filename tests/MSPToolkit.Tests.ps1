#Requires -Modules Pester

BeforeDiscovery {
    $script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

    $script:ScriptFiles = Get-ChildItem -Path $script:RepoRoot -Recurse -Include '*.ps1', '*.psm1' -File |
        Where-Object { $_.FullName -notmatch '[\\/]tests[\\/]' } |
        ForEach-Object { @{ Path = $_.FullName; Name = $_.FullName.Substring($script:RepoRoot.Length + 1) } }

    $script:JsonFiles = @(Get-Item (Join-Path $script:RepoRoot 'config.json')) +
        @(Get-ChildItem -Path (Join-Path $script:RepoRoot 'Templates') -Filter '*.json' -File) |
        ForEach-Object { @{ Path = $_.FullName; Name = $_.FullName.Substring($script:RepoRoot.Length + 1) } }

    # Exported function names as documented in README.md ("Modules" section).
    $script:Modules = @(
        @{ Name = 'Core/MSPToolkit.Config.psm1';     Exports = @('Get-MSPConfig', 'Set-MSPConfigValue', 'Initialize-MSPDirectories', 'Test-MSPAdminRights', 'Get-MSPSystemInfo') }
        @{ Name = 'Core/MSPToolkit.Logging.psm1';    Exports = @('Initialize-MSPLogging', 'Write-MSPLog', 'Write-MSPProgress', 'Show-MSPBanner', 'Show-MSPSuccess', 'Show-MSPError', 'Show-MSPBox', 'Write-MSPTable') }
        @{ Name = 'Core/MSPToolkit.Remote.psm1';     Exports = @('Invoke-MSPRemoteScript', 'Invoke-MSPRemoteScriptFile', 'Get-MSPRemoteComputerStatus', 'Import-MSPComputerList', 'New-MSPCredential', 'Get-MSPCredential') }
        @{ Name = 'Integrations/MSPToolkit.RMM.psm1'; Exports = @('Send-RMMAlert', 'New-RMMTicket', 'Update-RMMTicket') }
    )
}

BeforeAll {
    # BeforeDiscovery variables are not visible during the Run phase; recompute here.
    $script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

Describe 'PowerShell syntax' {
    It 'parses without errors: <Name>' -ForEach $script:ScriptFiles {
        $tokens = $null
        $errors = $null
        [void][System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
        $errors | Should -BeNullOrEmpty -Because (($errors | ForEach-Object { $_.Message }) -join '; ')
    }
}

Describe 'JSON files' {
    It 'is valid JSON: <Name>' -ForEach $script:JsonFiles {
        { Get-Content -Path $Path -Raw | ConvertFrom-Json -ErrorAction Stop } | Should -Not -Throw
    }

    It 'config.json has the documented top-level sections' {
        $cfg = Get-Content -Path (Join-Path $script:RepoRoot 'config.json') -Raw | ConvertFrom-Json
        $cfg.PSObject.Properties.Name | Should -Contain 'company'
        $cfg.PSObject.Properties.Name | Should -Contain 'logging'
    }
}

Describe 'Modules' {
    It 'exports exactly the documented functions: <Name>' -ForEach $script:Modules {
        $modulePath = Join-Path $script:RepoRoot $Name
        $job = Start-Job -ScriptBlock {
            param($p)
            $m = Import-Module $p -PassThru -Force -ErrorAction Stop
            $m.ExportedFunctions.Keys
        } -ArgumentList $modulePath
        $actual = @($job | Wait-Job | Receive-Job -ErrorAction Stop)
        Remove-Job $job -Force
        ($actual | Sort-Object) | Should -Be ($Exports | Sort-Object)
    }
}

Describe 'PSScriptAnalyzer' {
    BeforeAll {
        $script:AnalyzerResults = Invoke-ScriptAnalyzer -Path $script:RepoRoot -Recurse `
            -Settings (Join-Path $script:RepoRoot 'PSScriptAnalyzerSettings.psd1')
    }

    It 'reports no Error-severity findings' {
        $msg = ($script:AnalyzerResults | ForEach-Object { "$($_.ScriptName):$($_.Line) $($_.RuleName) $($_.Message)" }) -join "`n"
        $script:AnalyzerResults | Should -BeNullOrEmpty -Because $msg
    }
}
