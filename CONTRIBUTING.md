# Contributing to msp-tier3-toolkit

## Development

msp-tier3-toolkit is a PowerShell toolkit for MSP work. The tools are Windows-only.

- The canonical launcher is `Launch-MSPToolkit.ps1` (see README).
- Run Pester tests where applicable before opening a PR.
- Run PSScriptAnalyzer where applicable.

## Pull requests

- Keep changes small and focused.
- Update the README and QUICKSTART where behaviour changes.
- Do not include secrets or real credentials in tests or examples.
- Note that CI runs parse/import checks on Linux `pwsh` only — the tools themselves are Windows-only and are not executed by CI.
