# Spiegelt AGENTS.md nach .github/copilot-instructions.md (kanonische Agent-Quelle).
# Aufruf aus Repo-Root:  pwsh tools/scripts/sync_instructions.ps1
$ErrorActionPreference = 'Stop'

$src = 'AGENTS.md'
$dst = '.github/copilot-instructions.md'

if (-not (Test-Path -LiteralPath $src)) {
    throw "Fehler: $src fehlt. Aus Repo-Root aufrufen."
}

$null = New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst)

$header = @'
<!-- AUTOGENERIERT via tools/scripts/sync_instructions.ps1 - NICHT direkt editieren. Quelle: AGENTS.md -->

'@

$body = Get-Content -LiteralPath $src -Raw -Encoding UTF8
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText((Resolve-Path -LiteralPath (Split-Path -Parent $dst) | Join-Path -ChildPath (Split-Path -Leaf $dst)), $header + $body, $utf8NoBom)

Write-Host "Mirror aktualisiert: $dst"
