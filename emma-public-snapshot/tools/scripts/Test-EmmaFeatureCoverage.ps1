[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$RootPath,

    [string]$ReportDirectory = ".\emma-audit-report",

    [string]$CustomRulesPath,

    [string[]]$IncludeExtensions = @(
        ".ps1", ".psm1", ".cs", ".ts", ".tsx", ".js", ".jsx", ".dart", ".json", ".yaml", ".yml",
        ".java", ".kt", ".go", ".py", ".swift", ".xml", ".md"
    ),

    [string[]]$ExcludeDirectories = @(
        ".git", "node_modules", "bin", "obj", "build", "dist", "coverage", ".dart_tool", "Pods",
        ".gradle", ".idea", ".vscode", "__pycache__"
    ),

    [int]$MaxEvidencePerAlternative = 5,

    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-AlternativeGroup {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Alternatives
    )

    [PSCustomObject]@{
        alternatives = $Alternatives
    }
}

function Get-DefaultEmmaRules {
    $rules = @()

    $rules += [PSCustomObject]@{
        Area = 'Phase 1 – Demand Recognition'
        Capability = 'Mobilitätsbedarf erkennen'
        Description = 'Der Code bildet die Erkennung eines konkreten Mobilitätsanlasses aus Kalender, Routinen oder laufender Reise ab.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('intent_detected')),
            (New-AlternativeGroup -Alternatives @('confidence_score')),
            (New-AlternativeGroup -Alternatives @('trigger_reason')),
            (New-AlternativeGroup -Alternatives @('calendar_data', 'calendar')),
            (New-AlternativeGroup -Alternatives @('routines', 'routine')),
            (New-AlternativeGroup -Alternatives @('current_location', 'gps', 'location'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 1 – Demand Recognition'
        Capability = 'Konflikt-Check auf Standardroute'
        Description = 'Der Code prüft Echtzeitlage, Wetter und Budget-/Regelkonflikte vor einer Empfehlung.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('realtime_status', 'realtime')),
            (New-AlternativeGroup -Alternatives @('environmental_data', 'weather')),
            (New-AlternativeGroup -Alternatives @('budget_issue', 'budget_compliant', 'mobility_budget')),
            (New-AlternativeGroup -Alternatives @('optimization_found', 'optimization')),
            (New-AlternativeGroup -Alternatives @('action_type'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 1 – Demand Recognition'
        Capability = 'Trust Layer für proaktive Nutzeraktion'
        Description = 'Der Code stellt eine deterministische UI-Aktion mit trust_layer_action bereit.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('trust_layer_action')),
            (New-AlternativeGroup -Alternatives @('primary_cta')),
            (New-AlternativeGroup -Alternatives @('payload')),
            (New-AlternativeGroup -Alternatives @('one_tap_confirm', 'one_tap'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 2 – Option Orchestration'
        Capability = 'Auswahl der besten Mobilitätsoption'
        Description = 'Der Code bewertet candidate_options und wählt genau eine fachlich beste Option aus.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('candidate_options')),
            (New-AlternativeGroup -Alternatives @('recommendation_status')),
            (New-AlternativeGroup -Alternatives @('recommended_option_id')),
            (New-AlternativeGroup -Alternatives @('selection_reason')),
            (New-AlternativeGroup -Alternatives @('guarantee_level')),
            (New-AlternativeGroup -Alternatives @('provider_bundle'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 2 – Option Orchestration'
        Capability = 'Regelbasierte Bewertung nach Garantie, Budget und Bedienbarkeit'
        Description = 'Der Code priorisiert Garantiefähigkeit, Pünktlichkeit, Budget und geringe Komplexität.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('budget_compliant')),
            (New-AlternativeGroup -Alternatives @('transfer_count', 'transfercount')),
            (New-AlternativeGroup -Alternatives @('walking_min', 'walking')),
            (New-AlternativeGroup -Alternatives @('realtime_risk_score', 'capacity_risk_score', 'risk_score')),
            (New-AlternativeGroup -Alternatives @('bookable_with_one_tap', 'requires_user_input'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 3 – Booking Execution'
        Capability = 'Transaktionssichere Buchung vorbereiten'
        Description = 'Der Code führt Precheck, Commit-Scope und idempotente Transaktionsplanung für die ausgewählte Option.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('execution_status')),
            (New-AlternativeGroup -Alternatives @('transaction_plan')),
            (New-AlternativeGroup -Alternatives @('idempotency_key')),
            (New-AlternativeGroup -Alternatives @('commit_scope')),
            (New-AlternativeGroup -Alternatives @('precheck')),
            (New-AlternativeGroup -Alternatives @('commit_ready', 'commit'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 3 – Booking Execution'
        Capability = 'Rollback- und Kompensationslogik'
        Description = 'Der Code behandelt Teilfehler mit Rollback, Compensation und Provider-Prüfung.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('rollback_plan', 'rollback')),
            (New-AlternativeGroup -Alternatives @('compensation_plan', 'compensation')),
            (New-AlternativeGroup -Alternatives @('provider_execution_status', 'provider_states')),
            (New-AlternativeGroup -Alternatives @('inventory_status', 'inventory')),
            (New-AlternativeGroup -Alternatives @('reservation_status', 'reservation'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 4 – Fulfillment & Incident Control'
        Capability = 'Fulfillment, Monitoring und Incident Control'
        Description = 'Der Code überwacht eine gebuchte Reise, erkennt Incidents und hält Nachweise fest.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('control_status')),
            (New-AlternativeGroup -Alternatives @('fulfillment_state', 'fulfillment_summary')),
            (New-AlternativeGroup -Alternatives @('journey_status')),
            (New-AlternativeGroup -Alternatives @('incident_summary', 'incident_signals', 'incident')),
            (New-AlternativeGroup -Alternatives @('evidence_log')),
            (New-AlternativeGroup -Alternatives @('monitoring_window', 'monitoring'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 4 – Fulfillment & Incident Control'
        Capability = 'Reaccommodation und Mobilitätsgarantie'
        Description = 'Der Code kann bei Störungen Ersatzmaßnahmen oder Garantieaktionen auslösen.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('reaccommodation_options', 'reaccommodate')),
            (New-AlternativeGroup -Alternatives @('guarantee_action_required', 'trigger_guarantee', 'guarantee_policy')),
            (New-AlternativeGroup -Alternatives @('manual_ops_escalation', 'manual_ops', 'ops_escalation')),
            (New-AlternativeGroup -Alternatives @('selected_reaccommodation_option_id', 'target_option_id'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 5 – Settlement & Closure'
        Capability = 'Refund, Compensation und Fallabschluss'
        Description = 'Der Code bewertet finanzielle Nachläufe und schließt den Fall revisionssicher ab.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('settlement_status')),
            (New-AlternativeGroup -Alternatives @('case_closure_status')),
            (New-AlternativeGroup -Alternatives @('refund_decision', 'refund')),
            (New-AlternativeGroup -Alternatives @('compensation_decision', 'compensation')),
            (New-AlternativeGroup -Alternatives @('settlement_plan')),
            (New-AlternativeGroup -Alternatives @('financial_reconciliation_complete', 'reconciliation'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Phase 5 – Settlement & Closure'
        Capability = 'Verantwortung und Evidenz im Nachlauf'
        Description = 'Der Code führt Responsibility-Hinweise, Evidenzanforderungen und manuelle Prüfpfade.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('responsibility_summary', 'responsibility_hint')),
            (New-AlternativeGroup -Alternatives @('evidence_sufficient', 'evidence_log')),
            (New-AlternativeGroup -Alternatives @('case_review_required', 'manual_review')),
            (New-AlternativeGroup -Alternatives @('refund_basis', 'compensation_basis'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Master Orchestrator'
        Capability = 'Phasensteuerung und Zustandsfortschreibung'
        Description = 'Der Code steuert Übergänge zwischen Phase 1 bis 5 auf Basis eines gemeinsamen Falls.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('current_phase')),
            (New-AlternativeGroup -Alternatives @('current_state')),
            (New-AlternativeGroup -Alternatives @('next_phase')),
            (New-AlternativeGroup -Alternatives @('orchestration_action')),
            (New-AlternativeGroup -Alternatives @('phase_gate')),
            (New-AlternativeGroup -Alternatives @('advance_to_next_phase', 'execute_current_phase', 'trigger_manual_review'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Master Orchestrator'
        Capability = 'Gemeinsame Fallidentität, Audit und Fehlerklassen'
        Description = 'Der Code führt globale IDs, Audit Trace und standardisierte Fehlerklassen.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('global_case_id')),
            (New-AlternativeGroup -Alternatives @('trip_id')),
            (New-AlternativeGroup -Alternatives @('trace_id')),
            (New-AlternativeGroup -Alternatives @('audit_trace', 'audit_entry')),
            (New-AlternativeGroup -Alternatives @('error_class')),
            (New-AlternativeGroup -Alternatives @('state_transition_rules', 'transition'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Gemeinsame Contracts'
        Capability = 'Kanonisches Case-Model und gemeinsame Schemas'
        Description = 'Der Code enthält ein gemeinsames Vertragsmodell für Phasen, Ergebnisse und Handoffs.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('schema_version')),
            (New-AlternativeGroup -Alternatives @('case_header')),
            (New-AlternativeGroup -Alternatives @('phase_state')),
            (New-AlternativeGroup -Alternatives @('shared_entities')),
            (New-AlternativeGroup -Alternatives @('handoff_contract', 'handoff')),
            (New-AlternativeGroup -Alternatives @('contract_package_version', 'contract_package'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Gemeinsame Contracts'
        Capability = 'Trust Layer, JSON Contracts und deterministische UI'
        Description = 'Der Code stellt frontend-taugliche JSON-Verträge und deterministische Nutzeraktionen bereit.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('display_message')),
            (New-AlternativeGroup -Alternatives @('primary_cta')),
            (New-AlternativeGroup -Alternatives @('payload')),
            (New-AlternativeGroup -Alternatives @('type')),
            (New-AlternativeGroup -Alternatives @('technical_metadata'))
        )
    }

    $rules += [PSCustomObject]@{
        Area = 'Domänenlogik emma'
        Capability = 'Mobilitätsgarantie, Partnerlogik und Budgetkonformität'
        Description = 'Der Code bildet zentrale emma-Domänenlogiken wie Garantie, Partnerbundle und Budget ab.'
        Groups = @(
            (New-AlternativeGroup -Alternatives @('mobility_budget', 'budget_context', 'budget_policy')),
            (New-AlternativeGroup -Alternatives @('guarantee_policy', 'guarantee_level')),
            (New-AlternativeGroup -Alternatives @('provider_bundle')),
            (New-AlternativeGroup -Alternatives @('affected_providers')),
            (New-AlternativeGroup -Alternatives @('partner_allocation', 'partner_context', 'provider_execution_status'))
        )
    }

    return $rules
}

function Import-CustomRules {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "CustomRulesPath not found: $Path"
    }

    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $rules = $raw | ConvertFrom-Json -Depth 100
    if (-not $rules) {
        throw "Custom rules file is empty or invalid JSON."
    }
    return $rules
}

function Get-FileIndex {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Root,
        [Parameter(Mandatory = $true)]
        [string[]]$Extensions,
        [Parameter(Mandatory = $true)]
        [string[]]$ExcludedDirectories
    )

    $normalizedRoot = (Resolve-Path -LiteralPath $Root).Path
    $allFiles = Get-ChildItem -LiteralPath $normalizedRoot -Recurse -File -Force | Where-Object {
        $file = $_
        $extOk = $Extensions -contains $file.Extension.ToLowerInvariant()
        if (-not $extOk) { return $false }

        foreach ($excluded in $ExcludedDirectories) {
            $segment = [IO.Path]::DirectorySeparatorChar + $excluded + [IO.Path]::DirectorySeparatorChar
            if ($file.FullName -like "*$segment*") {
                return $false
            }
        }
        return $true
    }

    $index = foreach ($file in $allFiles) {
        $content = ''
        try {
            $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        }
        catch {
            try {
                $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
            }
            catch {
                $content = ''
            }
        }

        [PSCustomObject]@{
            Path = $file.FullName
            RelativePath = [IO.Path]::GetRelativePath($normalizedRoot, $file.FullName)
            Extension = $file.Extension.ToLowerInvariant()
            SearchText = ($content + "`n" + $file.FullName).ToLowerInvariant()
        }
    }

    return ,$index
}

function Find-AlternativeEvidence {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Alternative,
        [Parameter(Mandatory = $true)]
        [Object[]]$IndexedFiles,
        [Parameter(Mandatory = $true)]
        [int]$MaxEvidence
    )

    $needle = $Alternative.ToLowerInvariant()
    $hits = @()

    foreach ($file in $IndexedFiles) {
        if ($file.SearchText.Contains($needle)) {
            $hits += $file.RelativePath
            if ($hits.Count -ge $MaxEvidence) { break }
        }
    }

    return ,$hits
}

function Evaluate-Rule {
    param(
        [Parameter(Mandatory = $true)]
        [Object]$Rule,
        [Parameter(Mandatory = $true)]
        [Object[]]$IndexedFiles,
        [Parameter(Mandatory = $true)]
        [int]$MaxEvidence
    )

    $groupResults = @()
    $matchedGroupCount = 0

    foreach ($group in $Rule.Groups) {
        $alternativeResults = @()
        $groupMatched = $false
        $winningAlternative = $null
        $winningEvidence = @()

        foreach ($alternative in $group.alternatives) {
            $evidence = Find-AlternativeEvidence -Alternative $alternative -IndexedFiles $IndexedFiles -MaxEvidence $MaxEvidence
            $matched = $evidence.Count -gt 0
            $alternativeResults += [PSCustomObject]@{
                alternative = $alternative
                matched = $matched
                evidence_files = $evidence
            }

            if (-not $groupMatched -and $matched) {
                $groupMatched = $true
                $winningAlternative = $alternative
                $winningEvidence = $evidence
            }
        }

        if ($groupMatched) { $matchedGroupCount++ }

        $groupResults += [PSCustomObject]@{
            matched = $groupMatched
            matched_alternative = $winningAlternative
            evidence_files = $winningEvidence
            alternatives = $alternativeResults
        }
    }

    $totalGroups = [int]$Rule.Groups.Count
    $coverage = if ($totalGroups -eq 0) { 0 } else { [math]::Round(($matchedGroupCount / $totalGroups) * 100, 2) }

    $status = if ($matchedGroupCount -eq $totalGroups -and $totalGroups -gt 0) {
        'PASS'
    }
    elseif ($matchedGroupCount -gt 0) {
        'PARTIAL'
    }
    else {
        'FAIL'
    }

    $missingGroups = @()
    foreach ($groupResult in $groupResults) {
        if (-not $groupResult.matched) {
            $missingGroups += ($groupResult.alternatives | ForEach-Object { $_.alternative }) -join ' | '
        }
    }

    [PSCustomObject]@{
        area = $Rule.Area
        capability = $Rule.Capability
        description = $Rule.Description
        status = $status
        coverage_percent = $coverage
        matched_groups = $matchedGroupCount
        total_groups = $totalGroups
        missing_groups = $missingGroups
        group_results = $groupResults
    }
}

function Convert-ResultsToSummary {
    param(
        [Parameter(Mandatory = $true)]
        [Object[]]$Results
    )

    $areaSummary = $Results |
        Group-Object area |
        ForEach-Object {
            $group = $_.Group
            $pass = ($group | Where-Object status -eq 'PASS').Count
            $partial = ($group | Where-Object status -eq 'PARTIAL').Count
            $fail = ($group | Where-Object status -eq 'FAIL').Count
            $avg = if ($group.Count -eq 0) { 0 } else { [math]::Round((($group | Measure-Object coverage_percent -Average).Average), 2) }

            [PSCustomObject]@{
                area = $_.Name
                capabilities = $group.Count
                pass = $pass
                partial = $partial
                fail = $fail
                average_coverage_percent = $avg
            }
        }

    $overall = [PSCustomObject]@{
        capabilities_total = $Results.Count
        pass = ($Results | Where-Object status -eq 'PASS').Count
        partial = ($Results | Where-Object status -eq 'PARTIAL').Count
        fail = ($Results | Where-Object status -eq 'FAIL').Count
        average_coverage_percent = if ($Results.Count -eq 0) { 0 } else { [math]::Round((($Results | Measure-Object coverage_percent -Average).Average), 2) }
    }

    [PSCustomObject]@{
        overall = $overall
        by_area = $areaSummary
    }
}

function New-MarkdownReport {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,
        [Parameter(Mandatory = $true)]
        [Object]$Summary,
        [Parameter(Mandatory = $true)]
        [Object[]]$Results
    )

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# emma Code Coverage Audit")
    $lines.Add("")
    $lines.Add("Geprüfter Pfad: `" + $RootPath + "`")
    $lines.Add("Erstellt am: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')")
    $lines.Add("")
    $lines.Add("## Gesamtbild")
    $lines.Add("")
    $lines.Add("- Fähigkeiten gesamt: $($Summary.overall.capabilities_total)")
    $lines.Add("- PASS: $($Summary.overall.pass)")
    $lines.Add("- PARTIAL: $($Summary.overall.partial)")
    $lines.Add("- FAIL: $($Summary.overall.fail)")
    $lines.Add("- Durchschnittliche Abdeckung: $($Summary.overall.average_coverage_percent)%")
    $lines.Add("")
    $lines.Add("## Bereiche")
    $lines.Add("")
    foreach ($area in $Summary.by_area) {
        $lines.Add("### $($area.area)")
        $lines.Add("")
        $lines.Add("- Fähigkeiten: $($area.capabilities)")
        $lines.Add("- PASS: $($area.pass)")
        $lines.Add("- PARTIAL: $($area.partial)")
        $lines.Add("- FAIL: $($area.fail)")
        $lines.Add("- Durchschnittliche Abdeckung: $($area.average_coverage_percent)%")
        $lines.Add("")
    }

    $lines.Add("## Detailergebnisse")
    $lines.Add("")

    foreach ($result in $Results) {
        $lines.Add("### [$($result.status)] $($result.area) · $($result.capability)")
        $lines.Add("")
        $lines.Add($result.description)
        $lines.Add("")
        $lines.Add("- Abdeckung: $($result.coverage_percent)% ($($result.matched_groups)/$($result.total_groups) Gruppen)")
        if ($result.missing_groups.Count -gt 0) {
            $lines.Add("- Fehlende Gruppen: $([string]::Join('; ', $result.missing_groups))")
        }
        else {
            $lines.Add("- Fehlende Gruppen: keine")
        }
        $lines.Add("")

        foreach ($groupResult in $result.group_results) {
            $marker = if ($groupResult.matched) { '✓' } else { '✗' }
            $alternativesText = ($groupResult.alternatives | ForEach-Object { $_.alternative }) -join ' | '
            $lines.Add("- $marker $alternativesText")
            if ($groupResult.evidence_files.Count -gt 0) {
                foreach ($file in $groupResult.evidence_files) {
                    $lines.Add("  - Evidenz: `" + $file + "`")
                }
            }
        }
        $lines.Add("")
    }

    return ($lines -join [Environment]::NewLine)
}

if (-not (Test-Path -LiteralPath $RootPath)) {
    throw "RootPath not found: $RootPath"
}

$resolvedRoot = (Resolve-Path -LiteralPath $RootPath).Path
$resolvedReportDirectory = if ([IO.Path]::IsPathRooted($ReportDirectory)) {
    $ReportDirectory
}
else {
    Join-Path -Path (Get-Location) -ChildPath $ReportDirectory
}

if (-not (Test-Path -LiteralPath $resolvedReportDirectory)) {
    $null = New-Item -ItemType Directory -Path $resolvedReportDirectory -Force
}

$rules = if ($CustomRulesPath) {
    Import-CustomRules -Path $CustomRulesPath
}
else {
    Get-DefaultEmmaRules
}

if (-not $Quiet) {
    Write-Host "[1/4] Indexing files under $resolvedRoot"
}
$indexedFiles = Get-FileIndex -Root $resolvedRoot -Extensions $IncludeExtensions -ExcludedDirectories $ExcludeDirectories

if (-not $Quiet) {
    Write-Host "[2/4] Evaluating $($rules.Count) capability rules"
}
$results = foreach ($rule in $rules) {
    Evaluate-Rule -Rule $rule -IndexedFiles $indexedFiles -MaxEvidence $MaxEvidencePerAlternative
}

$summary = Convert-ResultsToSummary -Results $results

$report = [PSCustomObject]@{
    generated_at = (Get-Date).ToString('o')
    root_path = $resolvedRoot
    scanned_file_count = $indexedFiles.Count
    include_extensions = $IncludeExtensions
    exclude_directories = $ExcludeDirectories
    summary = $summary
    results = $results
}

$jsonPath = Join-Path -Path $resolvedReportDirectory -ChildPath 'emma-audit-report.json'
$mdPath = Join-Path -Path $resolvedReportDirectory -ChildPath 'emma-audit-report.md'

if (-not $Quiet) {
    Write-Host "[3/4] Writing reports"
}
$report | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
New-MarkdownReport -RootPath $resolvedRoot -Summary $summary -Results $results | Set-Content -LiteralPath $mdPath -Encoding UTF8

if (-not $Quiet) {
    Write-Host "[4/4] Done"
    Write-Host "JSON report: $jsonPath"
    Write-Host "Markdown report: $mdPath"
}

$report
