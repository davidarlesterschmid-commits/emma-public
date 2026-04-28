param(
  [switch]$RunDartTest = $false,
  [string[]]$ExcludeDirs = @(".git", ".dart_tool", "build", "node_modules", ".idea", ".vscode")
)

$ErrorActionPreference = "Stop"

function Write-Result([string]$Name, [bool]$Ok, [string]$Details = "") {
  $status = if ($Ok) { "PASS" } else { "FAIL" }
  if ($Details -and $Details.Trim().Length -gt 0) {
    Write-Host ("[{0}] {1} - {2}" -f $status, $Name, $Details)
  } else {
    Write-Host ("[{0}] {1}" -f $status, $Name)
  }
}

function Find-PythonCommand {
  foreach ($c in @("python", "py", "python3")) {
    $cmd = Get-Command $c -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
  }
  $windowsAppsPy = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps\python.exe"
  if (Test-Path $windowsAppsPy) { return $windowsAppsPy }
  return $null
}

function Get-Files([string[]]$Patterns) {
  $root = Get-Location
  $all = Get-ChildItem -Path $root -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
      $p = $_.FullName.Substring($root.Path.Length).TrimStart("\","/")
      foreach ($ex in $ExcludeDirs) {
        if ($p -like "$ex\*" -or $p -like "$ex/*") { return $false }
      }
      return $true
    }

  $matches = New-Object System.Collections.Generic.List[System.IO.FileInfo]
  foreach ($f in $all) {
    foreach ($pat in $Patterns) {
      if ($f.Name -like $pat) { $matches.Add($f); break }
    }
  }
  return $matches
}

$hadFailure = $false

Write-Host "emma repo health check"
Write-Host ("Root: {0}" -f (Get-Location))
Write-Host ""

# --- YAML/YML parse (PyYAML) ---
$py = Find-PythonCommand
$yamlFiles = Get-Files -Patterns @("*.yml", "*.yaml")
if (-not $py) {
  Write-Result "YAML parse (PyYAML) - python not found" $false "Install Python 3 + PyYAML (pip install pyyaml)."
  $hadFailure = $true
} elseif ($yamlFiles.Count -eq 0) {
  Write-Result "YAML parse (PyYAML)" $true "No YAML files found (skipped)."
} else {
  $pyScriptPath = Join-Path $env:TEMP ("emma_repo_health_yaml_{0}.py" -f ([guid]::NewGuid().ToString("N")))
  @'
import sys
try:
  import yaml
except Exception as e:
  print("PYYAML_MISSING:", e)
  sys.exit(3)

paths = sys.argv[1:]
bad = 0
checked = 0
for p in paths:
  checked += 1
  try:
    with open(p, "rb") as f:
      list(yaml.safe_load_all(f))
  except Exception as e:
    bad += 1
    print(f"YAML_FAIL {p}: {e}")

if bad:
  print(f"YAML_SUMMARY checked={checked} failed={bad}")
  sys.exit(1)
print(f"YAML_SUMMARY checked={checked} failed=0")
'@ | Set-Content -Path $pyScriptPath -Encoding UTF8

  $yamlArgs = @()
  foreach ($f in $yamlFiles) { $yamlArgs += $f.FullName }

  $out = & $py $pyScriptPath @yamlArgs 2>&1
  $exit = $LASTEXITCODE
  if ($exit -eq 0) {
    Write-Result "YAML parse (PyYAML)" $true ($out | Select-Object -Last 1)
    Write-Result "YAML parse (PyYAML) - at least 1 file checked" $true ("checked={0}" -f $yamlFiles.Count)
  } elseif ($exit -eq 3) {
    Write-Result "YAML parse (PyYAML) - PyYAML missing" $false ($out -join " ")
    $hadFailure = $true
  } else {
    Write-Result "YAML parse (PyYAML)" $false "See YAML_FAIL lines above."
    Write-Host ($out -join "`n")
    $hadFailure = $true
  }

  Remove-Item -Force -ErrorAction SilentlyContinue $pyScriptPath
}

Write-Host ""

# --- JSON validate ---
$jsonFiles = Get-Files -Patterns @("*.json")
if (-not $py) {
  Write-Result "JSON validate - python not found" $false "Install Python 3 to validate JSON strictly."
  $hadFailure = $true
} elseif ($jsonFiles.Count -eq 0) {
  Write-Result "JSON validate" $true "No JSON files found (skipped)."
} else {
  $pyScriptPath = Join-Path $env:TEMP ("emma_repo_health_json_{0}.py" -f ([guid]::NewGuid().ToString("N")))
  @'
import sys, json
paths = sys.argv[1:]
bad = 0
checked = 0
for p in paths:
  checked += 1
  try:
    with open(p, "rb") as f:
      json.load(f)
  except Exception as e:
    bad += 1
    print(f"JSON_FAIL {p}: {e}")
if bad:
  print(f"JSON_SUMMARY checked={checked} failed={bad}")
  sys.exit(1)
print(f"JSON_SUMMARY checked={checked} failed=0")
'@ | Set-Content -Path $pyScriptPath -Encoding UTF8

  $jsonArgs = @()
  foreach ($f in $jsonFiles) { $jsonArgs += $f.FullName }

  $out = & $py $pyScriptPath @jsonArgs 2>&1
  $exit = $LASTEXITCODE
  if ($exit -eq 0) {
    Write-Result "JSON validate" $true ($out | Select-Object -Last 1)
  } else {
    Write-Result "JSON validate" $false "See JSON_FAIL lines above."
    Write-Host ($out -join "`n")
    $hadFailure = $true
  }

  Remove-Item -Force -ErrorAction SilentlyContinue $pyScriptPath
}

Write-Host ""

# --- Python tooling tests (tools/tests) ---
$toolsTestsDir = Join-Path (Get-Location) "tools/tests"
if (-not (Test-Path $toolsTestsDir)) {
  Write-Result "python tooling tests" $true "No tools/tests directory (skipped)."
} elseif (-not $py) {
  Write-Result "python tooling tests - python not found" $false "Install Python 3 to run tools/tests."
  $hadFailure = $true
} else {
  Write-Host ("Running: python -m unittest discover -s tools/tests -p test_*.py (cwd: {0})" -f (Get-Location))
  $p = Start-Process -FilePath $py -ArgumentList @("-m", "unittest", "discover", "-s", "tools/tests", "-p", "test_*.py", "-v") -WorkingDirectory (Get-Location) -NoNewWindow -PassThru -Wait
  if ($p.ExitCode -eq 0) {
    Write-Result "python tooling tests" $true
  } else {
    Write-Result "python tooling tests" $false ("exit={0}" -f $p.ExitCode)
    $hadFailure = $true
  }
}

Write-Host ""

# --- flutter analyze ---
try {
  $flutter = (Get-Command flutter -ErrorAction SilentlyContinue).Source
  if (-not $flutter) { throw "flutter not found in PATH" }

  $analyzeCwd = Join-Path (Get-Location) "apps/emma_app"
  if (-not (Test-Path $analyzeCwd)) { $analyzeCwd = (Get-Location).Path }

  Write-Host ("Running: flutter analyze (cwd: {0})" -f $analyzeCwd)
  $p = Start-Process -FilePath $flutter -ArgumentList @("analyze") -WorkingDirectory $analyzeCwd -NoNewWindow -PassThru -Wait
  if ($p.ExitCode -eq 0) {
    Write-Result "flutter analyze" $true
  } else {
    Write-Result "flutter analyze" $false ("exit={0}" -f $p.ExitCode)
    $hadFailure = $true
  }
} catch {
  Write-Result "flutter analyze" $false $_.Exception.Message
  $hadFailure = $true
}

Write-Host ""

# --- optional dart test ---
if ($RunDartTest) {
  try {
    $testCwd = Join-Path (Get-Location) "apps/emma_app"
    $hasTestDir = Test-Path (Join-Path $testCwd "test")
    if (-not $hasTestDir) {
      Write-Result "dart test" $true "No apps/emma_app/test directory (skipped)."
    } else {
      $pubspec = Join-Path $testCwd "pubspec.yaml"
      $isFlutterPackage = $false
      if (Test-Path $pubspec) {
        $isFlutterPackage = (Select-String -Path $pubspec -SimpleMatch "sdk: flutter" -Quiet) -or
                            (Select-String -Path $pubspec -SimpleMatch "flutter:" -Quiet)
      }

      if ($isFlutterPackage) {
        $flutter = (Get-Command flutter -ErrorAction SilentlyContinue).Source
        if (-not $flutter) { throw "flutter not found in PATH (required for flutter test)" }

        Write-Host ("Running: flutter test (cwd: {0})" -f $testCwd)
        $p = Start-Process -FilePath $flutter -ArgumentList @("test") -WorkingDirectory $testCwd -NoNewWindow -PassThru -Wait
        if ($p.ExitCode -eq 0) {
          Write-Result "flutter test" $true
        } else {
          Write-Result "flutter test" $false ("exit={0}" -f $p.ExitCode)
          $hadFailure = $true
        }
      } else {
        $dart = (Get-Command dart -ErrorAction SilentlyContinue).Source
        if (-not $dart) { throw "dart not found in PATH" }

        Write-Host ("Running: dart test (cwd: {0})" -f $testCwd)
        $p = Start-Process -FilePath $dart -ArgumentList @("test") -WorkingDirectory $testCwd -NoNewWindow -PassThru -Wait
        if ($p.ExitCode -eq 0) {
          Write-Result "dart test" $true
        } else {
          Write-Result "dart test" $false ("exit={0}" -f $p.ExitCode)
          $hadFailure = $true
        }
      }
    }
  } catch {
    Write-Result "tests" $false $_.Exception.Message
    $hadFailure = $true
  }
}

Write-Host ""

if ($hadFailure) {
  Write-Host "Overall: FAIL"
  exit 1
}

Write-Host "Overall: PASS"
exit 0

