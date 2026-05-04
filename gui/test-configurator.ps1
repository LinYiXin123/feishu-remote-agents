$ErrorActionPreference = 'Stop'
$errors = $null
$tokens = $null
$target = Join-Path $PSScriptRoot 'FeishuRemoteConfigurator.ps1'
[System.Management.Automation.Language.Parser]::ParseFile($target, [ref]$tokens, [ref]$errors) | Out-Null
if ($errors -and $errors.Count -gt 0) {
    $errors | ForEach-Object { $_.Message }
    exit 1
}
Write-Output 'OK'
