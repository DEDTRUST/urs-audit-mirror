# Source-free integrity check (PowerShell native). Recomputes the bundle root with SHA-256.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$m = Get-Content store\MANIFEST.json -Raw | ConvertFrom-Json
$pinned = (Get-Content store\BUNDLE_ROOT -Raw).Trim()
$lines = New-Object System.Collections.Generic.List[string]
$ok = $true
foreach ($a in $m.artifacts) {
  $obj = Join-Path "store\objects" $a.sha256
  if (-not (Test-Path $obj)) { Write-Host "  [FAIL] missing $($a.path)"; $ok=$false; continue }
  $h = (Get-FileHash $obj -Algorithm SHA256).Hash.ToLower()
  if ($h -ne $a.sha256) { Write-Host "  [FAIL] corrupt $($a.path)"; $ok=$false; continue }
  $lines.Add("$($a.sha256)  $($a.path)")
}
$arr = $lines.ToArray(); [Array]::Sort($arr, [StringComparer]::Ordinal)
$data = ($arr -join "`n") + "`n"
$sha = [Security.Cryptography.SHA256]::Create()
$root = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($data))) -replace "-","").ToLower()
if ($ok -and $root -eq $pinned) { Write-Host "  [PASS] bundle_root reproduces: $root"; exit 0 }
else { Write-Host "  [FAIL] $root != $pinned"; exit 1 }
