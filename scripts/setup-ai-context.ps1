[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepoPath,

    [switch]$IncludeWorkflow,

    [switch]$IncludeGenerateInstructions,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Copy-TemplateFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,

        [Parameter(Mandatory = $true)]
        [bool]$AllowOverwrite
    )

    $destinationDirectory = Split-Path -Parent $DestinationPath
    if (-not [string]::IsNullOrWhiteSpace($destinationDirectory)) {
        New-Item -ItemType Directory -Force -Path $destinationDirectory | Out-Null
    }

    if ((Test-Path -LiteralPath $DestinationPath) -and -not $AllowOverwrite) {
        throw "Refusing to overwrite existing file: $DestinationPath. Re-run with -Force if you want to replace it."
    }

    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force:$AllowOverwrite
}

$resolvedTarget = (Resolve-Path -LiteralPath $TargetRepoPath).Path
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$templatesRoot = Join-Path $repoRoot "templates"
$promptsRoot = Join-Path $repoRoot "prompts"

if (-not (Test-Path -LiteralPath $resolvedTarget -PathType Container)) {
    throw "Target repository path does not exist or is not a directory: $TargetRepoPath"
}

$coreFiles = @(
    @{
        Source = Join-Path $templatesRoot "ai-entry.md"
        Destination = Join-Path $resolvedTarget "ai-entry.md"
    },
    @{
        Source = Join-Path $templatesRoot "quick-context.md"
        Destination = Join-Path $resolvedTarget "quick-context.md"
    },
    @{
        Source = Join-Path $templatesRoot "project-analysis.md"
        Destination = Join-Path $resolvedTarget "project-analysis.md"
    },
    @{
        Source = Join-Path $promptsRoot "generate-ai-context.prompt.md"
        Destination = Join-Path (Join-Path $resolvedTarget "prompts") "generate-ai-context.prompt.md"
    }
)

$optionalFiles = @()

$legacyPromptPath = Join-Path (Join-Path $resolvedTarget "prompts") "codex-generate-ai-context.prompt.md"

if ($IncludeWorkflow) {
    $optionalFiles += @{
        Source = Join-Path $templatesRoot ".github\workflows\ai-context.yml"
        Destination = Join-Path (Join-Path $resolvedTarget ".github\workflows") "ai-context.yml"
    }
}

if ($IncludeGenerateInstructions) {
    $optionalFiles += @{
        Source = Join-Path $templatesRoot "scripts\generate-ai-context.md"
        Destination = Join-Path (Join-Path $resolvedTarget "scripts") "generate-ai-context.md"
    }
}

$filesToCopy = $coreFiles + $optionalFiles

if (Test-Path -LiteralPath $legacyPromptPath) {
    Remove-Item -LiteralPath $legacyPromptPath -Force
}

foreach ($file in $filesToCopy) {
    Copy-TemplateFile -SourcePath $file.Source -DestinationPath $file.Destination -AllowOverwrite:$Force.IsPresent
}

Write-Host "Installed AI context kit into $resolvedTarget" -ForegroundColor Green
foreach ($file in $filesToCopy) {
    Write-Host " - $($file.Destination)"
}
