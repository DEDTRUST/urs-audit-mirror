<#
.SYNOPSIS
    Verifies the URS/DUX v1.2.0 audit-mirror bundle.

.DESCRIPTION
    Reads bundle/manifest.json, recomputes the SHA-256 of every listed file,
    reconstructs the deterministic bundle_root hash, and compares it to the
    value sealed in the manifest.  Exits 0 on PASS, 1 on FAIL.

    bundle_root algorithm
    ---------------------
    1. For each file listed in manifest.json, compute SHA-256(file bytes).
    2. Sort entries by relative path (case-sensitive, forward slashes).
    3. Concatenate lines of the form:  "<hash>  <rel_path>\n"
    4. bundle_root = SHA-256 of that concatenated string (UTF-8, no BOM).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File verify_bundle.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── locate repo root (script may be run from any working directory) ────────────
$repoRoot = $PSScriptRoot
if (-not $repoRoot) { $repoRoot = (Get-Location).Path }

$manifestPath = Join-Path $repoRoot 'bundle\manifest.json'
if (-not (Test-Path $manifestPath)) {
    Write-Host "[FAIL] manifest not found: $manifestPath" -ForegroundColor Red
    exit 1
}

# ── read manifest ──────────────────────────────────────────────────────────────
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$expectedRoot = $manifest.bundle_root

# ── helper: compute SHA-256 of a file ─────────────────────────────────────────
function Get-FileSha256 {
    param([string]$Path)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $stream = [System.IO.File]::OpenRead($Path)
        try   { $bytes = $sha.ComputeHash($stream) }
        finally { $stream.Dispose() }
    } finally { $sha.Dispose() }
    return ([System.BitConverter]::ToString($bytes) -replace '-','').ToLower()
}

# ── helper: compute SHA-256 of a UTF-8 string (no BOM) ────────────────────────
function Get-StringSha256 {
    param([string]$Text)
    $sha   = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    try   { $hash = $sha.ComputeHash($bytes) }
    finally { $sha.Dispose() }
    return ([System.BitConverter]::ToString($hash) -replace '-','').ToLower()
}

# ── verify each file and accumulate sorted lines ───────────────────────────────
$fail   = $false
$lines  = [System.Collections.Generic.List[string]]::new()

foreach ($entry in $manifest.files) {
    # normalise path separator for this OS
    $relPath  = $entry.path -replace '/', [System.IO.Path]::DirectorySeparatorChar
    $fullPath = Join-Path $repoRoot $relPath
    $relFwd   = $entry.path -replace '\\', '/'   # always forward-slash for hash

    if (-not (Test-Path $fullPath)) {
        Write-Host "[FAIL] missing file: $relFwd" -ForegroundColor Red
        $fail = $true
        continue
    }

    $actual   = Get-FileSha256 -Path $fullPath
    $expected = $entry.sha256

    if ($actual -ne $expected) {
        Write-Host "[FAIL] hash mismatch for $relFwd" -ForegroundColor Red
        Write-Host "       expected : $expected"
        Write-Host "       actual   : $actual"
        $fail = $true
    } else {
        Write-Host "[ok]  $relFwd"
    }

    $lines.Add("$actual  $relFwd")
}

if ($fail) {
    Write-Host "`n[FAIL] one or more files failed verification" -ForegroundColor Red
    exit 1
}

# ── reconstruct bundle_root ────────────────────────────────────────────────────
$sorted      = ($lines | Sort-Object) -join "`n"
$rootInput   = $sorted + "`n"
$computedRoot = Get-StringSha256 -Text $rootInput

if ($computedRoot -eq $expectedRoot) {
    Write-Host "`n[PASS] bundle_root reproduces: $($computedRoot.Substring(0,8))..." -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n[FAIL] bundle_root mismatch" -ForegroundColor Red
    Write-Host "       expected : $expectedRoot"
    Write-Host "       computed : $computedRoot"
    exit 1
}
