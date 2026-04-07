---
name: structurizr-diagrams
description: Expert guide for writing and editing Structurizr C4 architecture diagrams in this multi-domain repository. Use this skill whenever asked to add, update, or modify any architecture diagram, software system, container, relationship, or view. Supports cross-domain dependencies and the shared-model pattern with workspace extends.
---

# Structurizr Diagrams Skill

You are an expert in Structurizr DSL and C4 model diagrams. This repository uses a shared-model, multi-domain pattern. Follow every rule below precisely.

---

## Repository Structure

```
structurizr/
├── model.dsl                      ← Root workspace: global identifiers, actors, cross-domain rules, shared C4 styles
├── shared/externals.dsl           ← Shared third-party systems
├── 01-domain-A/
│   ├── workspace.dsl              ← Views (workspace extends ../model.dsl)
│   ├── applications.dsl           ← softwareSystem + container definitions
│   └── relations.inc.dsl          ← Relationship catalog
├── 02-domain-B/
│   └── ...                        ← Same three-file pattern
├── 03-domain-C/
│   └── ...                        ← Same pattern (+ docs + workspace.json per domain)
└── .github/skills/                ← Agent skills
```

Each domain follows the **same core three-file pattern**: applications → relations → workspace.
New domains use the numbering convention `NN-domain-name/`.

---

## Critical Rules

1. **`model.dsl` uses `!identifiers hierarchical`** — all container identifiers are qualified as `softwareSystem.container` (e.g. `mos.mosAPI`, `cbs.coreAccountAPI`).
2. **Load order matters**: `applications.dsl` must be included in `model.dsl` before any `relations.inc.dsl`, because relations reference identifiers defined in applications.
3. **Always add an explicit view key** to every view you create — auto-generated keys are unstable.
4. **Relations go in `relations.inc.dsl`**, never inside the `views` block or `workspace.dsl`.
5. **Views go in `workspace.dsl`** using `workspace extends ../model.dsl { views { ... } }`.
6. **Preserve existing identifier spellings exactly** — do not rename identifiers to "clean up" naming.
7. **Shared styles are defined in `model.dsl`** (`workspace { views { styles { ... } } }`) and inherited by all domain workspaces.

---

## Element Definitions (`applications.dsl`)

### softwareSystem

```dsl
group "DomainName" {
    mySystem = softwareSystem "Display Name" {
        description "What this system does"
        tags "DomainTag"

        myContainer = container "Container Name" {
            description "What this container does"
            technology "Java"
            tags "DomainTag"
        }
    }
}
```

- Tags are used by views to filter which systems to show. Use the existing domain tags consistently: `"CoreBankingDomain"`, `"LendingDomain"`, `"CRMDomain"`.
- Tags are also used for shared styling. Reuse existing style-driving tags first: `Person`, `External`, `Database`, `WebApp`, `API`, `Service`, `Storage`.
- The identifier (left of `=`) must be unique across **all** files in the repo, since all domains share `model.dsl`.

---

## Relationships (`relations.inc.dsl`)

```dsl
# Section comment
source -> destination "Relationship description" "Technology"

# With hierarchical identifiers
mySystem.myContainer -> otherSystem "Does something" "REST API"
otherSystem -> mySystem.myContainer "Responds" "Kafka"
```

- Use `#` comments to group relations by system or topic.
- Technology is optional but recommended: `"REST API"`, `"Kafka"`, `"gRPC"`, `"HTTPS/REST"`, `"AWS SDK"` etc.
- Never duplicate a relationship that already exists — check `relations.inc.dsl` first.
- Relations are usually unidirectional unless there are separate business cases or different channels.
- Planned integrations: tag with `tags "PlannedNotConfirmed"`.

### Cross-domain identifiers

Systems defined in one domain can be referenced from another, e.g. `mos.mosAPI -> cbs.coreAccountAPI`, `crm.leadManagement -> mos.mosAPI`.

---

## Views (`workspace.dsl`)

Every domain `workspace.dsl` has this structure:

```dsl
workspace extends ../model.dsl {
    name "Domain Name"
    description "Optional description"

    views {
        // views go here
    }
}
```

### systemLandscape view

```dsl
systemLandscape "my-landscape-key" "Optional description" {
    title "Domain Name / Landscape Diagram"
    include element.tag==DomainTag
    autolayout tb
}
```

### systemContext view

```dsl
systemContext mySystem "my-context-key" {
    title "Domain Name / My System Context"
    include *?
    exclude element.tag==Person
    autolayout tb
}
```

Use `*?` (reluctant wildcard) to keep diagrams focused.

### Shared styles (inherited from `model.dsl`)

- Domain workspaces inherit base styles from `model.dsl`; do not duplicate a full `styles` block in every `workspace.dsl`.
- When introducing a new visual category, prefer adding one new tag + one shared style in `model.dsl` rather than per-view overrides.

```dsl
workspace {
    views {
        styles {
            element "Queue" {
                shape Pipe
                background "#7f3fbf"
            }
        }
    }
}
```

### container view

```dsl
container mySystem "my-container-key" {
    title "Domain Name / My System Containers"
    include element.parent==mySystem
    include element.parent==System2
    include element.parent==System3
    include relationship==*
    autolayout tb
}
```

### dynamic view

```dsl
dynamic mySystem "my-dynamic-key" "Flow name" {
    title "Domain Name / Authentication Flow"
    mySystem.frontend -> mySystem.backend "1. Request"
    mySystem.backend -> cbs "2. Fetch data"
    autolayout
}
```

---

## include / exclude Expressions

| Expression | Meaning |
|---|---|
| `*` | Wildcard (all elements) |
| `*?` | Reluctant wildcard — only directly connected elements |
| `element.tag==TagName` | All elements with the given tag |
| `element.tag!=TagName` | All elements without the tag |
| `element.type==SoftwareSystem` | By C4 type |
| `element.parent==identifier` | All children of the element |
| `->identifier->` | Element + all inbound and outbound connections |
| `relationship==*` | All relationships in the view |
| `relationship.tag==TagName` | Relationships with a given tag |

Expressions with spaces **must be quoted**: `include "element.tag==My Tag"`.

Combine with `&&` or `||`:
```dsl
include "element.type==Container && element.parent==mySystem"
```

---

## autoLayout

```dsl
autolayout tb              // top-to-bottom (default)
autolayout lr              // left-to-right
autoLayout tb 500 250      // with custom rank/node spacing
```

Remove `autolayout` to preserve manual positioning. Keep commented layout lines intact (`// autoLayout ...`) unless asked to change.

---

## Validation and Running

### MCP tools (preferred — no Docker needed)

Use these tools directly to validate and inspect DSL:

```
structurizr-mcp-validate   → validate DSL syntax after every edit
structurizr-mcp-parse      → parse workspace, inspect element tree
structurizr-mcp-inspect    → inspect views and elements
structurizr-mcp-export-mermaid   → export a view to Mermaid
structurizr-mcp-export-c4plantuml → export a view to C4-PlantUML
```

Always call `structurizr-mcp-validate` after making changes to any DSL file.

### Structurizr local (Docker — for visual inspection)

Use Docker to run Structurizr local, mounting the **repository root** to browse all domains at once:

```bash
# Run from the repository root — all domains visible at http://localhost:8080
docker run -it --rm -p 8080:8080 \
  -v "$(git rev-parse --show-toplevel)":/usr/local/structurizr \
  -e STRUCTURIZR_WORKSPACES=* \
  structurizr/structurizr local
```

Structurizr will report parsing errors on startup. Open http://localhost:8080 to inspect all domain workspaces.

---

## Adding a New Domain

1. Create `NN-domain-name/` directory (follow the numbering convention).
2. Create `workspace.dsl` with `workspace extends ../model.dsl { views { … } }`.
3. Create `applications.dsl` with system/container definitions.
4. Create `relations.inc.dsl` with relationship definitions.
5. If the new domain's systems are needed by other domains, add `!include` directives in `model.dsl`.

---

## Common Mistakes to Avoid

- **Missing view key**: Always use `container mySystem "unique-key" { ... }`.
- **Wrong identifier**: In hierarchical mode, use `mos.mosAPI`, not `mosAPI` alone.
- **Relations in wrong file**: Relations belong in `relations.inc.dsl`, not in `workspace.dsl`.
- **Duplicate relations**: Check existing `relations.inc.dsl` before adding.
- **Renaming existing identifiers**: Preserve spellings exactly, even if they look like typos.
