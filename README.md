# FinTech C4 Architecture Demo

This repository is a demo C4 architecture model for a mid-size FinTech company, authored in Structurizr DSL. It demonstrates a BIAN-aligned architecture across three domains:

- Domain A — Core Banking (CBS, Payment Hub, DMS, Notification, Identity, Compliance)
- Domain B — Mortgage Lending (Mortgage Origination, Lifecycle Management, Collateral Management, Mortgage Risk) — mortgage-only with collateral
- Domain C — CRM (Customer 360, Lead Management, Campaign Engine)

Quickstart

- Validate DSL (MCP): `structurizr-mcp-validate`
- Run locally (multi-workspace):

  ```bash
  docker run -it --rm -p 8080:8080 \
    -v "$(pwd)":/usr/local/structurizr \
    -e STRUCTURIZR_WORKSPACES=* \
    structurizr/structurizr local
  ```

Files of interest: `model.dsl`, `shared/externals.dsl`, `01-domain-A/`, `02-domain-B/`, `03-domain-C/`.

Notes

- This is a demo model for documentation and design purposes, not production code.
- Use the Structurizr MCP tools to validate and export views programmatically.

--
Generated as part of the demo project.