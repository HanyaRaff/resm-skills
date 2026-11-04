param(
    [string]$ConfigRoot = "$HOME\.gemini\config",
    [string[]]$Skills = @(),
    [switch]$IncludeRules
)

$ErrorActionPreference = 'Stop'
$skillsDest = Join-Path $ConfigRoot "skills"
if (-not (Test-Path $skillsDest)) {
    New-Item -ItemType Directory -Path $skillsDest -Force | Out-Null
}

$sourceSkills = Get-ChildItem -Path (Join-Path $PSScriptRoot "skills") -Directory
if ($Skills.Count -gt 0) {
    $sourceSkills = $sourceSkills | Where-Object { $Skills -contains $_.Name }
}

foreach ($skill in $sourceSkills) {
    $dest = Join-Path $skillsDest $skill.Name
    Copy-Item -Path $skill.FullName -Destination $dest -Recurse -Force
    Write-Host "Installed skill: $($skill.Name) -> $dest"
}

if ($IncludeRules) {
    $rulesDest = Join-Path $ConfigRoot "rules"
    if (-not (Test-Path $rulesDest)) {
        New-Item -ItemType Directory -Path $rulesDest -Force | Out-Null
    }
    Copy-Item -Path (Join-Path $PSScriptRoot "rules\*") -Destination $rulesDest -Recurse -Force
    Write-Host "Installed global rules -> $rulesDest"
}
