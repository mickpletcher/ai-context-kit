# ai-context-kit

`ai-context-kit` is a reusable starter for adding durable AI-readable context files to an existing repository.

It is designed for teams or solo developers who use AI tools repeatedly across the same codebase and want those tools to start from curated project context instead of rediscovering the repository from scratch every time.

## What This Solves

Most AI tools are effective once they understand a repository, but that understanding is often rebuilt from zero in every new session. That creates several problems:

- repeated token and time costs spent re-analyzing the same project
- inconsistent answers because different sessions inspect different files
- slower onboarding for new contributors and future AI assistants
- loss of architectural context when decisions are only implicit in the code

`ai-context-kit` gives a repository a lightweight documentation layer specifically optimized for AI-assisted work.

## Core Idea

The kit installs three root-level context files into a target repository:

- `ai-entry.md`
- `quick-context.md`
- `project-analysis.md`

These files create a read order for AI tools:

1. Read `ai-entry.md` for usage rules.
2. Read `quick-context.md` for the fast summary.
3. Read `project-analysis.md` only when deeper architecture detail is needed.
4. Read source files only when implementation detail is required.

This structure helps future AI tools stay accurate while avoiding broad repository scans unless they are truly necessary.

## Who This Is For

This project is useful if you:

- work with AI coding assistants in the same repo repeatedly
- want to reduce prompt size and repeated repo analysis
- maintain a repo with non-obvious architecture or workflows
- want future AI tools to understand constraints before editing code
- want a repeatable pattern you can apply across multiple repositories

## What This Repository Contains

This repository is the template source, not the final installed output for a target project.

It contains:

- reusable markdown templates
- a reusable generation prompt
- an installer script
- optional workflow and helper-doc templates

## Repository Layout

```text
ai-context-kit/
├── prompts/
│   └── generate-ai-context.prompt.md
├── scripts/
│   └── setup-ai-context.ps1
├── templates/
│   ├── ai-entry.md
│   ├── project-analysis.md
│   ├── quick-context.md
│   ├── .github/
│   │   └── workflows/
│   │       └── ai-context.yml
│   └── scripts/
│       └── generate-ai-context.md
├── .gitignore
├── LICENSE
└── README.md
```

## Installed Output In A Target Repository

By default, the setup script installs:

- `ai-entry.md`
- `quick-context.md`
- `project-analysis.md`
- `prompts/generate-ai-context.prompt.md`

Optionally, it can also install:

- `.github/workflows/ai-context.yml`
- `scripts/generate-ai-context.md`

## File Purposes

### `ai-entry.md`

This is the first file an AI tool should read.

Its job is to:

- establish the intended read order
- explain that broad repository scanning should be avoided when possible
- tell future AI tools to keep context files updated when the architecture changes

### `quick-context.md`

This is the fast-load summary.

Its job is to:

- capture the highest-value project information in a compact form
- summarize architecture, entry points, constraints, gotchas, and extension points
- let an AI tool answer many common questions without opening the full repo

### `project-analysis.md`

This is the deeper reference document.

Its job is to:

- document the repository structure and major components
- describe workflows, data flow, runtime behavior, integration points, and configuration
- preserve non-obvious decisions, technical debt, and safe modification boundaries

### `prompts/generate-ai-context.prompt.md`

This is the reusable implementation prompt for the target repository.

Its job is to:

- instruct an AI tool to analyze the target repository
- define the required output structure for the context files
- keep the generated files accurate, structured, and focused

### `.github/workflows/ai-context.yml`

This is optional.

Its job is to:

- verify that the expected AI context files exist
- provide a minimal, safe GitHub Actions check
- avoid pretending to regenerate AI content automatically unless the target repo already has an approved workflow for that

### `scripts/generate-ai-context.md`

This is optional.

Its job is to:

- give maintainers a small runbook for refreshing the context files later
- keep the regeneration workflow visible in the target repository

## Requirements

Current installer requirements:

- Windows PowerShell
- a target repository directory that already exists

Important behavior:

- the installer does not create a new Git repository
- the installer copies files into an existing directory
- the installer refuses to overwrite existing files unless `-Force` is passed
- the installer removes the older legacy prompt filename if it finds it

## Quick Start

Run the installer from this repository:

```powershell
.\scripts\setup-ai-context.ps1 -TargetRepoPath "C:\path\to\existing-repo"
```

This installs the core files into the target repository.

If you also want the optional workflow and regeneration instructions:

```powershell
.\scripts\setup-ai-context.ps1 `
  -TargetRepoPath "C:\path\to\existing-repo" `
  -IncludeWorkflow `
  -IncludeGenerateInstructions
```

If the target repo already contains matching files and you intentionally want to replace them:

```powershell
.\scripts\setup-ai-context.ps1 `
  -TargetRepoPath "C:\path\to\existing-repo" `
  -IncludeWorkflow `
  -IncludeGenerateInstructions `
  -Force
```

## Recommended Adoption Flow

Use this sequence when applying the kit to a real project.

### 1. Install The Starter Files

Run the setup script against the target repository.

### 2. Open The Target Repository In Your AI Tool

Use whichever AI assistant you prefer, as long as it can:

- inspect repository structure
- read files
- write markdown files
- follow a structured prompt reliably

### 3. Use The Installed Prompt

Open:

- `prompts/generate-ai-context.prompt.md`

Use that prompt from the root of the target repository.

### 4. Let The AI Tool Populate The Context Files

The tool should analyze the actual target repository and fill in:

- `ai-entry.md`
- `quick-context.md`
- `project-analysis.md`

These files should not remain skeletal after this step.

### 5. Review Before Commit

Check the generated content for:

- factual accuracy
- missing components or workflows
- overconfident claims not supported by the codebase
- accidental inclusion of secrets or sensitive values
- unnecessary repetition

### 6. Commit The Installed Context

In most repos, the generated context files should be committed so future humans and AI tools can benefit from them.

## Example Installed Structure

After setup, a target repository may look like this:

```text
target-repo/
├── ai-entry.md
├── quick-context.md
├── project-analysis.md
├── prompts/
│   └── generate-ai-context.prompt.md
├── scripts/
│   └── generate-ai-context.md
└── .github/
    └── workflows/
        └── ai-context.yml
```

Some target repositories may omit the optional `scripts/` or `.github/` additions.

## How To Use The Installed Files In Practice

Once the target repo has real content in the context files, an effective AI workflow usually looks like this:

- read `ai-entry.md`
- read `quick-context.md`
- decide whether `project-analysis.md` is needed
- read only the source files directly relevant to the requested change
- update the context files when the architecture or workflows materially change

This is especially useful for:

- bug fixes in large repos
- repeated maintenance work
- onboarding to older projects
- repositories with multiple apps, scripts, or deployment paths

## Guidance For Maintaining Context Files

The installed context files are only valuable if they stay current.

Refresh them when:

- the repo structure changes significantly
- major dependencies or frameworks change
- build or run commands change
- integration points change
- new architectural constraints are introduced
- important workflows are renamed or replaced

At minimum, keep these areas synchronized with reality:

- entry points
- execution commands
- key components
- configuration requirements
- deployment assumptions
- known gotchas and safe extension points

## What Good AI Context Looks Like

A strong set of context files should help an AI tool answer these questions quickly:

- What does this project do?
- How is the repository organized?
- What are the main entry points?
- What should be read or modified for common changes?
- What patterns and constraints should be preserved?
- What external systems or configuration matter?
- What areas are fragile or should not be changed casually?

If the installed files cannot answer those questions well, they should be improved.

## Scope And Safety Rules

This kit is intentionally conservative.

It is meant to support documentation and context generation, not speculative automation.

The included prompt and templates are designed to encourage these behaviors:

- prefer truthful summaries over guessed completeness
- avoid exposing secrets or credentials
- avoid scanning generated or irrelevant folders when possible
- avoid modifying application source code unless clearly required
- prefer targeted repository reads over broad indiscriminate analysis

## Current Limitations

- The installer is PowerShell-only today.
- The kit does not yet generate repository-specific content by itself.
- The quality of the final context still depends on the AI tool and the quality of the review step.
- The optional workflow validates file presence only; it does not judge content quality.

## Local-Only Planning File

`future-upgrades.md` in this template repository is intentionally local-only planning material.

It is ignored through `.gitignore` and is not intended to be pushed as part of the reusable kit.

## Troubleshooting

### The script says the target path cannot be resolved

Make sure the directory already exists before running the installer.

### The script refuses to overwrite files

That is expected behavior. Re-run with `-Force` only if you want to replace the existing installed files.

### The target repository already has an older prompt filename

The installer removes the old legacy prompt path `prompts/codex-generate-ai-context.prompt.md` automatically.

### The AI tool generates vague or low-value context

Review the generated files and tighten them around:

- real entry points
- concrete commands
- actual repo structure
- important constraints
- non-obvious gotchas

## Development And Verification

You can test the installer against a scratch directory like this:

```powershell
$tempRepo = Join-Path $env:TEMP "ai-context-kit-test"
New-Item -ItemType Directory -Force -Path $tempRepo | Out-Null
.\scripts\setup-ai-context.ps1 `
  -TargetRepoPath $tempRepo `
  -IncludeWorkflow `
  -IncludeGenerateInstructions `
  -Force
Get-ChildItem -Recurse $tempRepo
```

This is useful when changing:

- installer behavior
- template locations
- prompt filenames
- optional asset handling

## Summary

Use `ai-context-kit` when you want a repeatable way to install AI-readable repository context into existing projects. The kit gives you a structure, an installer, and a generation prompt, while leaving the actual repository analysis grounded in the target codebase rather than in canned template text.
