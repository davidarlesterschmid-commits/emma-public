#Requires -Version 5.1
<#
.SYNOPSIS
  Non-destructive helper for emma agent workflow handoffs.

.DESCRIPTION
  Generates and validates local START, REVIEW REQUEST and GATE CHECK blocks for
  the multi-agent workflow. The script does not commit, push, merge, change
  Linear, change GitHub settings, or touch external services.

.PARAMETER Command
  One of: help, start, review-request, gate.

.PARAMETER Issue
  Linear issue identifier, for example EMM-188.

.PARAMETER Risk
  Declared risk class R0-R5.

.PARAMETER Agent
  Agent role for the generated block.

.PARAMETER Branch
  Branch name to report. Defaults to the current git branch.

.PARAMETER PrLink
  Pull request link or placeholder for review/gate blocks.

.PARAMETER Scope
  Markdown scope block. Keep short; detailed scope belongs in Linear/PR.

.PARAMETER NonScope
  Markdown non-scope block.

.PARAMETER Tests
  Markdown tests/checks block.

.PARAMETER Strict
  Return a non-zero exit code on snapshot drift or branch/issue mismatch.

.EXAMPLE
  pwsh -File tools/scripts/agent_workflow.ps1 start EMM-188 -Risk R1 -Agent Codex

.EXAMPLE
  pwsh -File tools/scripts/agent_workflow.ps1 review-request EMM-188 -Risk R1 -PrLink https://github.com/org/repo/pull/123

.EXAMPLE
  pwsh -File tools/scripts/agent_workflow.ps1 gate EMM-188 -Risk R1 -PrLink https://github.com/org/repo/pull/123
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('help', 'start', 'review-request', 'gate')]
    [string] $Command = 'help',

    [Parameter(Position = 1)]
    [string] $Issue,

    [ValidateSet('R0', 'R1', 'R2', 'R3', 'R4', 'R5')]
    [string] $Risk = 'R1',

    [ValidateSet('ChatGPT', 'Codex', 'Cursor', 'Claude', 'Copilot')]
    [string] $Agent = 'Codex',

    [string] $Branch,
    [string] $PrLink = '<PR-Link>',
    [string] $Scope = '- <Scope>',
    [string] $NonScope = '- <Nicht-Scope>',
    [string] $Tests = '- <Tests oder begruendete Auslassung>',
    [switch] $Strict
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $RepoRoot

function Write-Usage {
    @'
emma agent workflow helper

Usage:
  pwsh -File tools/scripts/agent_workflow.ps1 start EMM-188 -Risk R1 -Agent Codex
  pwsh -File tools/scripts/agent_workflow.ps1 review-request EMM-188 -Risk R1 -PrLink <url>
  pwsh -File tools/scripts/agent_workflow.ps1 gate EMM-188 -Risk R1 -PrLink <url>

Commands:
  start           Print a Linear START block and snapshot/branch validation.
  review-request  Print a REVIEW REQUEST block for PR/Claude handoff.
  gate            Print a local gate checklist for R0-R2/R3+ handling.
  help            Print this help.

Non-destructive:
  This script does not commit, push, merge, edit Linear, edit GitHub settings, or
  call external APIs. It only reads local files and git refs, then prints output.
'@
}

function Get-GitValue {
    param([string[]] $GitArgs)
    $value = & git @GitArgs 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $value) {
        return $null
    }
    return (($value | Select-Object -First 1) -as [string]).Trim()
}

function Test-GitAncestor {
    param(
        [string] $Ancestor,
        [string] $Descendant
    )
    if (-not $Ancestor -or -not $Descendant -or $Ancestor -like '<*' -or $Descendant -like '<*') {
        return $false
    }

    & git merge-base --is-ancestor $Ancestor $Descendant 2>$null
    return ($LASTEXITCODE -eq 0)
}

function Assert-Issue {
    param([string] $Value)
    if (-not $Value -or $Value -notmatch '^EMM-\d+$') {
        throw "Issue must use format EMM-<number>, for example EMM-188."
    }
}

function Get-SnapshotInfo {
    $path = Join-Path $RepoRoot 'docs\operations\CONTEXT_SNAPSHOT.md'
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Snapshot file missing: $path"
    }

    $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $versionMatch = [regex]::Match($raw, '\*\*Snapshot-Version:\*\*\s+`([^`]+)`')
    $shaMatch = [regex]::Match($raw, '\*\*main-SHA \(Snapshot\):\*\*\s+`([0-9a-f]{7,40})`')

    $version = '<missing>'
    $sha = '<missing>'
    if ($versionMatch.Success) { $version = $versionMatch.Groups[1].Value }
    if ($shaMatch.Success) { $sha = $shaMatch.Groups[1].Value }

    [pscustomobject]@{
        Version = $version
        MainSha = $sha
        Path = 'docs/operations/CONTEXT_SNAPSHOT.md'
    }
}

function Get-WorkflowContext {
    Assert-Issue $Issue

    $snapshot = Get-SnapshotInfo
    $currentBranch = Get-GitValue @('branch', '--show-current')
    if (-not $Branch) { $Branch = $currentBranch }
    if (-not $Branch) { $Branch = '<detached-or-unknown>' }

    $originMain = Get-GitValue @('rev-parse', 'origin/main')
    if (-not $originMain) { $originMain = '<missing-origin-main>' }

    $head = Get-GitValue @('rev-parse', 'HEAD')
    if (-not $head) { $head = '<missing-head>' }

    $snapshotCompatible = (
        (Test-GitAncestor $snapshot.MainSha $originMain) -and
        (Test-GitAncestor $snapshot.MainSha $head)
    )
    $branchHasIssue = ($Branch -like "*$Issue*")

    [pscustomobject]@{
        Issue = $Issue
        Risk = $Risk
        Agent = $Agent
        Branch = $Branch
        Head = $head
        OriginMain = $originMain
        Snapshot = $snapshot
        SnapshotCompatible = $snapshotCompatible
        BranchHasIssue = $branchHasIssue
    }
}

function Write-Validation {
    param($Context)

    $hasError = $false
    if (-not $Context.BranchHasIssue) {
        Write-Warning "Branch '$($Context.Branch)' does not contain $($Context.Issue)."
        $hasError = $true
    }
    if (-not $Context.SnapshotCompatible) {
        Write-Warning "Snapshot main-SHA '$($Context.Snapshot.MainSha)' is not a compatible ancestor of origin/main '$($Context.OriginMain)' and HEAD '$($Context.Head)'."
        $hasError = $true
    }
    if ($Strict -and $hasError) {
        exit 2
    }
}

function Format-Bool {
    param([bool] $Value)
    if ($Value) { return 'PASS' }
    return 'CHECK_REQUIRED'
}

function Write-StartBlock {
    $context = Get-WorkflowContext
    Write-Validation $context

    @"
## START

- Agent: $($context.Agent)
- Linear-Issue: $($context.Issue)
- Branch: ``$($context.Branch)``
- Risiko: $($context.Risk)
- Snapshot-Version: ``$($context.Snapshot.Version)``
- Main-SHA (Snapshot): ``$($context.Snapshot.MainSha)``
- origin/main: ``$($context.OriginMain)``
- HEAD: ``$($context.Head)``
- Snapshot-Abgleich: $(Format-Bool $context.SnapshotCompatible)
- Branch-ID-Abgleich: $(Format-Bool $context.BranchHasIssue)
- Scope:
$Scope
- Nicht-Scope:
$NonScope
"@
}

function Write-ReviewRequestBlock {
    $context = Get-WorkflowContext
    Write-Validation $context

    @"
## REVIEW REQUEST

- Linear-Issue: $($context.Issue)
- PR-Link: $PrLink
- Snapshot-Version: ``$($context.Snapshot.Version)``
- Main-SHA (Snapshot): ``$($context.Snapshot.MainSha)``
- Risiko deklariert: $($context.Risk)
- Scope:
$Scope
- Nicht-Scope:
$NonScope
- Tests / Checks:
$Tests
- Review-Fokus:
  - Scope gegen Linear-Issue
  - Governance-Dokumente: AGENTS.md, review_merge_automation.md, CONTEXT_SNAPSHOT.md
  - Risiko, Tests, Regression und Traceability
- Auto-Merge nach PASS beabsichtigt: nur wenn Risiko/Gates/Checks nach Policy erfuellt sind.
"@
}

function Write-GateBlock {
    $context = Get-WorkflowContext
    Write-Validation $context

    $reviewGate = 'Self-Check zulaessig; Claude empfohlen, aber nicht zwingend.'
    $mergePath = 'Agentischer Squash-Merge nach PASS, Ready-Status, gruenen Checks und Linear GATE OUTCOME moeglich.'
    if ($context.Risk -eq 'R2') {
        $reviewGate = 'Claude PASS ist Pflicht.'
        $mergePath = 'Agentischer Squash-Merge erst nach Claude PASS, passenden Tests, gruenen Checks und Linear GATE OUTCOME.'
    }
    elseif ($context.Risk -in @('R3', 'R4', 'R5')) {
        $reviewGate = 'Maintainer-Gate ist Pflicht; kein agentischer Merge.'
        $mergePath = 'Nicht agentisch mergen. Auf R3+ Gate / Maintainer-Entscheidung hochstufen.'
    }

    @"
## GATE CHECK

- Linear-Issue: $($context.Issue)
- PR-Link: $PrLink
- Risiko: $($context.Risk)
- Snapshot-Version: ``$($context.Snapshot.Version)``
- Main-SHA (Snapshot): ``$($context.Snapshot.MainSha)``
- Snapshot gegen origin/main/HEAD: $(Format-Bool $context.SnapshotCompatible)
- Branch enthaelt Linear-ID: $(Format-Bool $context.BranchHasIssue)
- Review-Gate: $reviewGate
- Merge-Pfad: $mergePath

Pflichtpunkte vor Merge:
- [ ] PR ist Ready for review und nicht Draft.
- [ ] PR-Titel oder PR-Body enthaelt $($context.Issue).
- [ ] Scope/Nicht-Scope und Risiko sind im PR dokumentiert.
- [ ] Vorhandene GitHub-Checks sind gruen; rot/pending blockiert.
- [ ] Linear GATE OUTCOME ist PASS inklusive Snapshot-Abgleich.
- [ ] ABSCHLUSS wird nach Merge oder terminalem Blocker in Linear dokumentiert.
"@
}

switch ($Command) {
    'help' { Write-Usage }
    'start' { Write-StartBlock }
    'review-request' { Write-ReviewRequestBlock }
    'gate' { Write-GateBlock }
}
