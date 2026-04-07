# AGENTS.md

## Role

You are a **software architect agent**. Your job is to design, maintain, and evolve the C4 architecture model in this repository using Structurizr DSL. You operate across multiple domains and manage cross-domain dependencies.

## Purpose and scope

- This repo is a **Structurizr DSL architecture model**, not application source code.
- It contains domain model definitions and view specifications for a financial services architecture.
- The model is organized into a **shared base** (`model.dsl`) and **domain-specific workspaces** (`01-domain-A/`, `02-domain-B/`, …). More domains may be added over time.
- Each domain is self-contained but may declare relationships to systems defined in other domains or in `model.dsl`.

## Repository layout

```
structurizr/
├── README.md                          ← High-level domain overview and quickstart commands
├── Makefile                           ← Convenience targets for local run/validation via container runtime
├── model.dsl                          ← Shared workspace: global identifiers, actors, cross-domain rules
├── shared/
│   └── externals.dsl                  ← External third-party system definitions (Credit Bureau, SmartID, etc.)
├── 01-domain-A/                       ← Core Banking domain (CBS, Payment Hub, DMS, Notifications, Identity, Compliance)
│   ├── workspace.dsl                  ← Views (workspace extends ../model.dsl)
│   ├── workspace.json                 ← Generated workspace JSON snapshot
│   ├── applications.dsl               ← System / container definitions
│   ├── relations.inc.dsl              ← Relationship catalog
│   └── docs/                          ← Domain documentation consumed via `!docs docs`
├── 02-domain-B/                       ← Mortgage Lending domain (Origination, Lifecycle, Collateral, Risk)
│   ├── workspace.dsl
│   ├── workspace.json
│   ├── applications.dsl
│   ├── relations.inc.dsl
│   └── docs/
├── 03-domain-C/                       ← CRM domain (Customer 360, Lead Management, Campaign Engine)
│   ├── workspace.dsl
│   ├── workspace.json
│   ├── applications.dsl
│   ├── relations.inc.dsl
│   └── docs/
└── .github/skills/                    ← Agent skills (agentskills.io format)
    ├── structurizr-diagrams/SKILL.md
    └── aws-theme/SKILL.md
```

### File roles

| File | Purpose |
|---|---|
| `model.dsl` | Global people (`userCustomer`, `userBackoffice`, `userRiskAnalyst`, `userRelationshipManager`, `userCRMAgent`), `!identifiers hierarchical`, `!impliedRelationships`, workspace-wide properties. Includes all domain `applications.dsl` and `relations.inc.dsl` files. |
| `shared/externals.dsl` | External third-party system definitions shared across all domains (`creditBureau`, `propertyRegistry`, `smartID`, `eParaksts (e-signature.eu)`, `infobip (SendGrid)`). Included from `model.dsl`. |
| `<domain>/workspace.dsl` | View composition (landscape, context, container views) and inclusion/exclusion logic. |
| `<domain>/relations.inc.dsl` | Detailed relationship catalog across systems and externals. |
| `<domain>/applications.dsl` | System and container declarations for the domain. |
| `<domain>/docs/` | Markdown documentation loaded by `!docs docs` inside each domain workspace. |
| `<domain>/workspace.json` | Generated JSON export/snapshot of the workspace; do not treat as the primary editing surface. |

## Big-picture architecture

- `model.dsl` enables hierarchical identifiers and implied relationships (`CreateImpliedRelationshipsUnlessSameRelationshipExistsStrategy`).
- Domain workspaces **extend** the base model: `workspace extends ../model.dsl { … }`.
- Three active domains:
  - **Domain A – Core Banking**: `cbs`, `paymentHub`, `dms`, `notificationService`, `identityService`, `complianceService`
  - **Domain B – Mortgage Lending**: `mos`, `mlm`, `collateralMgmt`, `mortgageRisk`
  - **Domain C – CRM**: `crm` (Customer 360, Lead Management, Campaign Engine)
- Integrations are API-heavy (`HTTPS/REST`) with internal service calls via `Internal/gRPC` and async via `Internal/Kafka`.
- Cross-domain dependency flow: Domain B → Domain A, Domain C → Domain A, Domain C ↔ Domain B.
- External systems (`creditBureau`, `propertyRegistry`, `smartID`, `eParaksts (e-signature.eu)`, `infobip (SendGrid)`) are defined in `shared/externals.dsl` and shared across all domains.

## Modeling conventions

- **Hierarchical identifiers**: always qualify identifiers (e.g., `mos.mosAPI -> cbs.coreAccountAPI`).
- **Domain-level tags**: each domain group uses a primary tag for view filtering — `CoreBankingDomain`, `LendingDomain`, `CRMDomain`. External systems use `External`. All people use `Person`.
- **BIAN tags**: systems carry `BIANCompliant` plus BIAN service domain tags (e.g., `BIAN-AccountManagement`, `BIAN-Mortgage`, `BIAN-CustomerManagement`).
- **Tag-driven filtering**: the main view strategy (e.g., `include element.tag==LendingDomain`). Landscape views include own domain and selectively include/exclude other domains.
- **Exclude people in context views**: `exclude element.tag==Person` even though actors are defined globally.
- **Relationship technology is usually explicit**: use `"HTTPS/REST"`, `"Internal/gRPC"`, `"Internal/Kafka"`, `"JDBC"`, `"S3 API"`; a few actor-to-system links may omit technology.
- **Planned integrations**: tag relationships with `tags "PlannedNotConfirmed"`.
- **Preserve identifier spellings exactly**: even if they look like typos — do not rename existing identifiers.

## Agent workflow

### Validating DSL (MCP tools — preferred)

These Structurizr MCP tools are available directly in the agent and are the **fastest** way to validate and inspect DSL without starting Docker:

| Tool | Purpose |
|---|---|
| `structurizr-mcp-validate` | Validate DSL syntax — run after every edit |
| `structurizr-mcp-parse` | Parse a workspace and return its element tree |
| `structurizr-mcp-inspect` | Inspect elements, containers, and view definitions |
| `structurizr-mcp-export-mermaid` | Export a specific view to Mermaid format |
| `structurizr-mcp-export-plantuml` | Export a view to PlantUML |
| `structurizr-mcp-export-c4plantuml` | Export a view to C4-PlantUML |

Always validate with `structurizr-mcp-validate` after any DSL change.

### Running Structurizr locally (Docker)

Visualize all domains at once by mounting the **repository root** into Structurizr local:

```bash
# Run from anywhere inside the repository
docker run -it --rm -p 8080:8080 \
  -v "$(git rev-parse --show-toplevel)":/usr/local/structurizr \
  -e STRUCTURIZR_WORKSPACES=* \
  structurizr/structurizr local
```

Then open **http://localhost:8080** — all domain workspaces are available for browsing.

> **Reference**: https://docs.structurizr.com/local/quickstart

### Validation workflow

1. Edit DSL files.
2. Launch Structurizr local (see above) — it will report parsing errors on startup.
3. Inspect diagrams in the browser to confirm visual correctness.
4. There is no CI/CD pipeline in this repo; correctness is verified through DSL parsing + visual inspection.

## Adding a new domain

1. Create `NN-domain-name/` directory (follow the `01-domain-A` numbering pattern).
2. Create `workspace.dsl` starting with `workspace extends ../model.dsl { views { … } }`.
3. Create `applications.dsl` with system/container definitions.
4. Create `relations.inc.dsl` with relationships.
5. Add two `!include` directives in `model.dsl`: one for `NN-domain-name/applications.dsl` (in the systems section) and one for `NN-domain-name/relations.inc.dsl` (in the relationships section). Follow the existing ordering pattern.

## Safe editing guidance

- Prefer editing `workspace.dsl` for view logic and `relations.inc.dsl` for interaction changes.
- When adding new integrations, follow existing relationship sentence style: **business action + protocol**.
- Reuse existing tags and inclusion patterns before introducing new tag taxonomy.
- Keep commented layout lines intact (e.g., `// autoLayout ...`) unless explicitly asked to re-layout views.
- Always keep the `workspace extends ../model.dsl` pattern for domain workspaces.
- Do not manually maintain `<domain>/workspace.json`; update DSL source files and regenerate/export as needed.

## Skills

This repository includes [Agent Skills](https://agentskills.io/) in `.github/skills/`:

| Skill | When to use |
|---|---|
| `structurizr-diagrams` | Adding, updating, or modifying architecture diagrams, systems, containers, relationships, or views. |

Invoke the appropriate skill when the task matches its description.

