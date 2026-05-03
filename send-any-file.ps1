param(
  [Parameter(Mandatory=$true, Position=0)] [string] $Path,
  [string] $Project = 'cc-codex',
  [string] $Session = $env:CC_SESSION_KEY,
  [string] $Message = '文件已发给你'
)
$ErrorActionPreference = 'Stop'
$item = Get-Item -LiteralPath $Path
if ($item.PSIsContainer) {
  New-Item -ItemType Directory -Force -Path 'F:\cc-agent\outbox' | Out-Null
  $zip = Join-Path 'F:\cc-agent\outbox' ($item.BaseName + '-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.zip')
  Compress-Archive -LiteralPath (Join-Path $item.FullName '*') -DestinationPath $zip -Force
  $item = Get-Item -LiteralPath $zip
}
$limit = 30MB
if ($item.Length -le 0) {
  throw "不能发送空文件：$($item.FullName)"
}
if ($item.Length -gt $limit) {
  $mb = [Math]::Round($item.Length / 1MB, 2)
  throw "飞书单文件上传限制为 30MB；当前文件 $mb MB：$($item.FullName)"
}
$sendArgs = @('send', '--project', $Project, '--file', $item.FullName, '--message', $Message)
if ($Session) {
  $sendArgs += @('--session', $Session)
}
& 'F:\cc-global\cc-connect.cmd' @sendArgs
exit $LASTEXITCODE
