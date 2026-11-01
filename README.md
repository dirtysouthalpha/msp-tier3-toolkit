# MSP Tier 3 Toolkit

**Battle-tested PowerShell for the service desk: diagnostics, AD/M365, cleanup, printing, Windows Update and remote execution, behind one zero-dependency menu.**

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-22D3EE?style=flat-square&labelColor=0A0A0F" alt="MIT license"></a>
  <a href="https://github.com/dirtysouthalpha/msp-tier3-toolkit/actions/workflows/ci.yml"><img src="https://github.com/dirtysouthalpha/msp-tier3-toolkit/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <img src="https://img.shields.io/badge/PowerShell-5.1%2B-22D3EE?style=flat-square&labelColor=0A0A0F" alt="PowerShell 5.1+">
  <img src="https://img.shields.io/badge/platform-Windows-22D3EE?style=flat-square&labelColor=0A0A0F" alt="Windows">
  <img src="https://img.shields.io/badge/built%20for-service%20desk-8B5CF6?style=flat-square&labelColor=0A0A0F" alt="service desk">
</p>

<p align="center">
  <img src="assets/banner.svg" alt="MSP Tier 3 Toolkit — battle-tested PowerShell for the service desk">
</p>

Welcome to the **MSP Tier 3 Toolkit** — a collection of high-impact PowerShell scripts designed to help Service Desk Technicians, System Admins, and MSP engineers troubleshoot faster, automate routine tasks, and deliver enterprise-level support with confidence.

## Quickstart

No installation and no extra modules: Windows 10/11 with the built-in PowerShell 5.1 is enough.

```powershell
git clone https://github.com/dirtysouthalpha/msp-tier3-toolkit.git
cd msp-tier3-toolkit

# Interactive menu (canonical launcher) — or just double-click "Launch MSP Toolkit.bat"
.\Launch-MSPToolkit.ps1

# If you hit an execution-policy error:
powershell -ExecutionPolicy Bypass -File .\Launch-MSPToolkit.ps1
```

In the menu, enter a number (1-12) to run a script, **H** for help, **Q** to quit. Scripts that need admin rights are marked **[ADMIN]**; start PowerShell with "Run as Administrator" for those.

Other entry points:

| Launcher | What it is |
|----------|------------|
| `Launch MSP Toolkit.bat` / `Launch-MSPToolkit.ps1` | **Canonical.** Standalone interactive menu, no dependencies. |
| `Launch Web UI.bat` / `Launch-WebUI.ps1` | Local web interface on http://localhost:8080 (`-Port`, `-OpenBrowser`). See [WEB_UI_INSTRUCTIONS.md](./WEB_UI_INSTRUCTIONS.md). |
| `Start-MSPToolkit.ps1` | Full-featured launcher using the `Core/` modules: search, favorites, remote execution (`-DirectMode -Script <name>`). |
| `Install-MSPToolkit.ps1` | Optional installer (run as Administrator): modules, scheduled tasks, shortcuts; `-Uninstall` to remove. |

Any script in `MSP_Tier3_Toolkit/` can also be run directly, e.g. `.\MSP_Tier3_Toolkit\SystemHealthReport.ps1`.

**Legacy / scratch files** kept for people following older instructions, not needed for new installs: `WORKING_LAUNCHER_USE_THIS.ps1` (an ASCII-only copy of `Launch-MSPToolkit.ps1` from the emoji-encoding fix; the canonical launcher now carries the fix), `README_WORKING_LAUNCHER.txt`, `URGENT_UPDATE_INSTRUCTIONS.txt`, `SYNTAX_VALIDATION_REPORT.md`, `CODE_QUALITY_IMPROVEMENTS.md`.

## Hardware tested

Built from what the repo documents (`QUICKSTART.md`, `CODE_QUALITY_IMPROVEMENTS.md`, launcher headers); no benchmark numbers exist for this tooling repo.

| OS | PowerShell | Status |
|----|------------|--------|
| Windows 10 (21H2+) | 5.1 (built-in) and 7.x | Documented as tested |
| Windows 11 | 5.1 (built-in) and 7.x | Documented as tested |
| Windows Server 2016+ | 5.1 | Documented as tested |
| Linux (Ubuntu 24.04, pwsh 7) | 7.x | CI only: parse, JSON, module import and PSScriptAnalyzer. The tools themselves target Windows. |

Add your machine via PR if you have run it elsewhere.

## Modules

`Core/` and `Integrations/` are importable modules used by `Start-MSPToolkit.ps1` and the web UI. The test suite asserts that each module exports exactly these functions.

| Module | Exported functions |
|--------|--------------------|
| `Core/MSPToolkit.Config.psm1` | `Get-MSPConfig`, `Set-MSPConfigValue`, `Initialize-MSPDirectories`, `Test-MSPAdminRights`, `Get-MSPSystemInfo` |
| `Core/MSPToolkit.Logging.psm1` | `Initialize-MSPLogging`, `Write-MSPLog`, `Write-MSPProgress`, `Show-MSPBanner`, `Show-MSPSuccess`, `Show-MSPError`, `Show-MSPBox`, `Write-MSPTable` |
| `Core/MSPToolkit.Remote.psm1` | `Invoke-MSPRemoteScript`, `Invoke-MSPRemoteScriptFile`, `Get-MSPRemoteComputerStatus`, `Import-MSPComputerList`, `New-MSPCredential`, `Get-MSPCredential` |
| `Integrations/MSPToolkit.RMM.psm1` | `Send-RMMAlert`, `New-RMMTicket`, `Update-RMMTicket` (ConnectWise, Autotask, Datto and others; see [README_v2.md](./README_v2.md#-rmm-integration)) |

Configuration lives in `config.json` (company, paths, logging, ...); task templates in `Templates/*.json`; extra tools (dashboard, knowledge base, self-healing, updater) in `Tools/`.

## Tests

```powershell
Install-Module Pester, PSScriptAnalyzer -Scope CurrentUser -Force -SkipPublisherCheck
Invoke-Pester -CI
Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error -Settings .\PSScriptAnalyzerSettings.psd1
```

The suite parses every `.ps1`/`.psm1`, validates every `.json`, imports each module in a fresh session and checks its exports, and runs PSScriptAnalyzer at Error severity. CI (`.github/workflows/ci.yml`) runs the same on Ubuntu 24.04.

## Requirements

- **PowerShell 5.1+** (Built into Windows 10/11)
- **Administrator privileges** (for some scripts)
- **Windows OS** (tested on Windows 10/11 and Windows Server 2016+)
- Some scripts need extra modules: `ActiveDirectory` (RSAT) for `CheckADUserStatus.ps1`, `MSOnline` for `M365UserProvisioning.ps1`.

## 🔧 Available Tools

| Category | Script Name | Description |
|----------|-------------|-------------|
| **Diagnostics** | `SystemHealthReport.ps1` | Comprehensive system health check |
| | `BootTimeAnalyzer.ps1` | Analyze boot and shutdown times |
| | `ClientSystemSummary.ps1` | Generate HTML report for clients |
| **Active Directory** | `CheckADUserStatus.ps1` | Check user lockout and password status |
| **Microsoft 365** | `M365UserProvisioning.ps1` | Provision Office 365 licenses |
| **Maintenance** | `CleanupOldProfiles.ps1` | Remove old user profiles |
| | `Cleanup-Auto.ps1` | Comprehensive system cleanup |
| **Print Management** | `PrinterSpoolerFix.ps1` | Fix stuck print jobs |
| | `CheckAndStart-Spooler.ps1` | Auto-monitor print spooler |
| **Network** | `FixMappedDrives.ps1` | Test and repair mapped drives |
| **Software** | `RemoteUninstall.ps1` | Silently uninstall software |
| **Windows Update** | `WindowsUpdateFix.ps1` | Reset Windows Update components |

## ✨ Key Features

- ✅ **No Installation Required** - Just download and run
- 🌐 **Web Interface** - Access from any browser
- 📱 **Remote Execution** - Run scripts on remote computers
- 📊 **Beautiful Reports** - HTML output for clients
- 🔄 **Auto-Updates** - Keep your toolkit current
- 📝 **Comprehensive Logging** - Track all operations
- 🎨 **Color-Coded Output** - Easy to read results

## 🚧 Planned Additions

See [ROADMAP.md](./ROADMAP.md) for upcoming scripts and contributions.

## 📚 Documentation

- [Web UI Instructions](./WEB_UI_INSTRUCTIONS.md) - How to use the web interface
- [Quick Start Guide](./QUICKSTART.md) - Get started in 5 minutes
- [Full reference (README_v2.md)](./README_v2.md) - Long-form documentation: every script, module, template and integration
- [Code Quality Improvements](./CODE_QUALITY_IMPROVEMENTS.md) - Recent enhancements
- [Syntax Validation Report](./SYNTAX_VALIDATION_REPORT.md) - Historical validation notes

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

> 💡 Most scripts are safe to run unattended — but always test in a non-production environment first.

**Version:** 2.0.0 | **Dazzle. Automate. Dominate.** 🚀

---

## Support this project

Built and maintained by one person, in the open. If it saves you time or
money, you can throw something in the hat — entirely optional, and it changes
nothing about the license or what ships.

<a href="https://cash.app/$vladien"><img src="docs/assets/donate-cashapp.png" alt="Cash App donation QR code for $vladien" width="170" align="left" hspace="18" vspace="6"></a>

**Cash App — [$vladien](https://cash.app/$vladien)**

Scan the code, or follow the link.

No tiers, no paywalled features, no "pro" build.

<br clear="left">

---
### More from Dirty South Alpha
*Self-hosted AI. Security-first. Always innovating.*

- 🚀 [intel-arc-llm-stack](https://github.com/dirtysouthalpha/intel-arc-llm-stack) — run any LLM locally on Intel Arc
- 🎛️ [muse-maestro](https://github.com/dirtysouthalpha/muse-maestro) — guardrails, memory & cost telemetry for Meta Muse Code
- 🤖 [sentinel-code](https://github.com/dirtysouthalpha/sentinel-code) — multi-provider AI coding agent with smart model routing
- 📊 [intel-arc-llm-benchmarks](https://github.com/dirtysouthalpha/intel-arc-llm-benchmarks) — real Arc B60 inference numbers
- 👤 [@dirtysouthalpha](https://github.com/dirtysouthalpha) — the full fleet

⭐ If this saved you time, star it and follow for more.

---
<p align="center"><sub><b>Dirty South Alpha™</b> · © 2026 · <a href="https://dirtysouthalpha.com">dirtysouthalpha.com</a> · self-hosted AI · security-first</sub></p>
