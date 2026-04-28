#Requires -Version 5.1
<#
.SYNOPSIS
  Read-only branch inventory for the emma repo (local + origin), plus optional
  deletion of *merge commits* fully integrated into main.

.DESCRIPTION
  GitHub uses **squash merge** by default. After a squash, `git branch --merged`
  is often FALSE for the feature branch — the old tip is not an ancestor of main.
  Therefore "not merged" lists are expected to stay long; use GitHub closed PRs
  to confirm whether work landed in main.

.PARAMETER Prune
  Run `git fetch --prune origin` first (updates remote-tracking refs).

.PARAMETER DeleteMergedLocal
  Delete **local** branches that `git branch --merged main` reports as merged
  (true merge only). Protected name patterns are never deleted.

.PARAMETER DryRun
  With -DeleteMergedLocal: print which branches would be removed, do not delete.

.EXAMPLE
  pwsh -File tools/scripts/branch_hygiene.ps1

.EXAMPLE
  pwsh -File tools/scripts/branch_hygiene.ps1 -Prune -DeleteMergedLocal -DryRun
#>
[CmdletBinding()]
param(
    [switch] $Prune,
    [switch] $DeleteMergedLocal,
    [switch] $DryRun
)

$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $root

function Test-ProtectedLocalBranch {
    param([string] $Name)
    if ($Name -eq 'main') { return $true }
    foreach ($p in @(
            'recovery-*', 'safety-*', 'mess-up-*', 'claude/*', 'review/*',
            'feature/EMM-XXX-*'
        )) {
        if ($Name -like $p) { return $true }
    }
    return $false
}

if ($Prune) {
    Write-Host '>> git fetch --prune origin' -ForegroundColor Cyan
    git fetch --prune origin
}

$mainRef = 'main'
if (-not (git rev-parse --verify $mainRef 2>$null)) {
    throw "Branch '$mainRef' not found. Run from repo root."
}

Write-Host "`n=== Base: $((git rev-parse --short $mainRef)) ($mainRef) ===" -ForegroundColor Green

Write-Host "`n--- Local branches (merge-merged into $mainRef) ---" -ForegroundColor Yellow
git branch --merged $mainRef --format='%(refname:short)'

Write-Host "`n--- Local branches (NOT merge-merged into $mainRef) ---" -ForegroundColor Yellow
git branch --no-merged $mainRef --format='%(refname:short)'

Write-Host "`n--- Remote branches (merge-merged into origin/$mainRef) ---" -ForegroundColor Yellow
git branch -r --merged "origin/$mainRef" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch 'HEAD' }

Write-Host "`n--- Note (squash merge) ---" -ForegroundColor Magenta
Write-Host "If your team squashes PRs, most feature branches stay 'not merged' in Git's sense."
Write-Host "Delete or close them in GitHub after merge; do not rely only on --merged."

if ($DeleteMergedLocal) {
    $candidates = git branch --merged $mainRef --format='%(refname:short)' | Where-Object {
        $_ -and $_ -ne $mainRef -and -not (Test-ProtectedLocalBranch $_)
    }
    if (-not $candidates) {
        Write-Host "`nNo deletable merge-merged local branches (after protection filter)." -ForegroundColor Green
        exit 0
    }
    Write-Host "`n--- Delete merge-merged local branches (protected names skipped) ---" -ForegroundColor Yellow
    foreach ($b in $candidates) {
        if ($DryRun) {
            Write-Host "[dry-run] git branch -d $b"
        }
        else {
            Write-Host "git branch -d $b" -ForegroundColor Cyan
            git branch -d $b
        }
    }
}

Write-Host "`nDone." -ForegroundColor Green
