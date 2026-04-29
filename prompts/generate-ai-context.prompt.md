# Prompt: Generate Repository AI Context

Use this prompt from the root of the target repository.

---

You are an expert software architect, repository analyst, and automation engineer.

Your task is to implement an AI context system in this repository so future AI agents can understand the project quickly without repeatedly scanning the entire codebase.

The system must create and maintain these files:

- `project-analysis.md`
- `quick-context.md`
- `ai-entry.md`
- optional GitHub Actions workflow: `.github/workflows/ai-context.yml`
- optional helper instructions under `scripts/`

The goal is to reduce token usage, speed up future AI work, and preserve a durable project summary inside the repo.

## Primary Objective

Analyze the repository and generate a reusable project context system.

Future AI agents should be able to read `ai-entry.md` first, then `quick-context.md`, and only read `project-analysis.md` if deeper context is needed.

Do not make future agents scan the entire repository unless absolutely necessary.

## Files To Create Or Update

### 1. `project-analysis.md`

Create a deep analysis file at the repository root.

Required sections:

```md
# Project Analysis

## 1. Project Overview
## 2. Tech Stack
## 3. Repository Structure
## 4. Core Components
## 5. Data Flow
## 6. Key Patterns and Design Decisions
## 7. Configuration and Environment
## 8. Build and Execution
## 9. Integration Points
## 10. Known Limitations and Technical Debt
## 11. Extension Points
## 12. Glossary
```

Rules:

- keep it concise but information-dense
- prefer bullets and structured sections over prose
- preserve project-specific terminology
- call out gotchas, constraints, and non-obvious decisions
- do not invent unsupported details

### 2. `quick-context.md`

Create a compressed context file at the repository root derived from `project-analysis.md`.

Constraints:

- target under roughly 1,000 tokens
- keep only the highest-value operational context
- preserve architecture, entry points, rules, constraints, gotchas, and extension points
- remove repetition and long explanations

Required structure:

```md
# Quick Context

## AI Usage Instructions
## Purpose
## Core Architecture
## Key Components
## Critical Paths
## Contracts
## Rules and Constraints
## Config Essentials
## Gotchas
## Extension Points
## Glossary
```

### 3. `ai-entry.md`

Create a small root-level instruction file for future AI agents with:

- read order
- purpose of the context system
- rules for keeping the context files updated

## Optional Files

Add these only if they fit the repository:

- `.github/workflows/ai-context.yml`
- `scripts/generate-ai-context.md`

If adding a workflow, keep it safe:

- validate file existence
- do not hardcode secrets
- do not invent fake AI automation

## Implementation Rules

1. Work from the repository root.
2. Inspect the repo structure before writing the files.
3. Ignore dependency folders and generated output where practical:
   - `.git`
   - `node_modules`
   - `bin`
   - `obj`
   - `dist`
   - `build`
   - `.vs`
   - `.idea`
   - coverage folders
4. Do not expose secrets or credentials.
5. If secrets are found, mention only that secret handling should be reviewed.
6. Keep docs truthful. If something cannot be determined, say so clearly.
7. Favor accuracy over sounding complete.
8. Do not rewrite application source code unless clearly required.
9. Keep edits focused on documentation, workflow, and helper files unless there is a strong reason otherwise.

## Final Instruction

Implement the AI context system now.

Create or update the files directly in the repository.
Do not only explain what should be done.
