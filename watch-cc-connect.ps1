$ErrorActionPreference = 'Stop'
$Base = 'F:\cc-agent'
$Exe = 'F:\cc-global\node_modules\cc-connect\bin\cc-connect.exe'
$Cfg = 'F:\cc-agent\cc-config\config.toml'
$Log = 'F:\cc-agent\cc-connect.console.log'
$ErrLog = 'F:\cc-agent\cc-connect.error.log'
$PidFile = 'F:\cc-agent\cc-connect.pid'

New-Item -ItemType Directory -Force -Path $Base | Out-Null

function Set-CcConnectEnv {
  $env:HTTP_PROXY = ''
  $env:HTTPS_PROXY = ''
  $env:ALL_PROXY = ''
  $env:http_proxy = ''
  $env:https_proxy = ''
  $env:all_proxy = ''
  $env:NO_PROXY = '127.0.0.1,localhost,open.feishu.cn'
  $env:no_proxy = '127.0.0.1,localhost,open.feishu.cn'
  $env:CC_DATA_DIR = 'F:\cc-agent\cc-connect-data'
  $env:Path = 'F:\claude-global;F:\cc-global;D:\nodejs\npm_global;' + $env:Path
}

function Stop-ExtraCcConnect {
  $procs = @(Get-Process cc-connect -ErrorAction SilentlyContinue | Sort-Object StartTime)
  if ($procs.Count -le 1) { return }
  $procs | Select-Object -Skip 1 | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Test-CcConnectOnline {
  $procs = @(Get-Process cc-connect -ErrorAction SilentlyContinue)
  return ($procs.Count -ge 1)
}

Set-CcConnectEnv
Stop-ExtraCcConnect

if (-not (Test-CcConnectOnline)) {
  Add-Content -LiteralPath $Log -Encoding UTF8 -Value "`n===== start $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="
  $p = Start-Process -FilePath $Exe -ArgumentList @('--force','--config',$Cfg) -WorkingDirectory $Base -WindowStyle Hidden -RedirectStandardOutput $Log -RedirectStandardError $ErrLog -PassThru
  Set-Content -LiteralPath $PidFile -Encoding ASCII -Value $p.Id
}

for ($i = 0; $i -lt 6; $i++) {
  Start-Sleep -Seconds 5
  Stop-ExtraCcConnect
  if (-not (Test-CcConnectOnline)) {
    Add-Content -LiteralPath $Log -Encoding UTF8 -Value "`n===== restart $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="
    $p = Start-Process -FilePath $Exe -ArgumentList @('--force','--config',$Cfg) -WorkingDirectory $Base -WindowStyle Hidden -RedirectStandardOutput $Log -RedirectStandardError $ErrLog -PassThru
    Set-Content -LiteralPath $PidFile -Encoding ASCII -Value $p.Id
  }
}
