# Domain B – Mortgage Lending

## Overview

Domain B is the **Mortgage Lending domain** of this FinTech demo. It covers the full lifecycle of residential mortgage products — from initial customer application through to loan maturity — with dedicated support for property collateral management and credit risk assessment.

The domain is scoped exclusively to **mortgage loans with collateral** and is modelled against BIAN service domains. It depends heavily on Domain A (Core Banking) for account management, payments, document storage, identity verification, and compliance services.

---

## BIAN Alignment

| System | BIAN Service Domain |
|--------|---------------------|
| Mortgage Origination System (MOS) | Mortgage, Consumer Loan |
| Mortgage Lifecycle Management (MLM) | Mortgage Loan, Loan |
| Collateral Management System | Collateral Asset Administration, Collateral Valuation |
| Mortgage Risk & Credit Assessment | Credit Management, Credit Risk |

---

## Systems

### Mortgage Origination System (MOS)

MOS manages the end-to-end mortgage application process: intake, document collection, automated underwriting, credit decision, and offer generation. It orchestrates all cross-domain checks (identity, AML, credit bureau, risk assessment, collateral registration) before a loan account is opened in the CBS.

**Containers:**
- **Mortgage Portal** – Customer-facing React SPA for submitting and tracking applications.
- **Origination API** – REST API orchestrating the full origination workflow.
- **Workflow Engine** – Camunda BPM engine managing multi-stage process: intake → underwriting → approval → offer.
- **Decision Engine** – Drools rules engine applying affordability, LTV, and policy checks.
- **Origination Database** – Stores applications, document references, and decision audit trail (PostgreSQL).

**Key integrations:**
- → CBS: opens loan account on approval
- → Payment Hub: initiates initial disbursement
- → DMS: stores application documents and signed agreements
- → Identity Service: KYC verification
- → Compliance Service: AML/sanctions screening
- → Mortgage Risk: affordability and credit assessment
- → Collateral Management: property collateral registration
- → Credit Bureau (external): credit history report

### Mortgage Lifecycle Management (MLM)

MLM handles all post-origination events: loan drawdown, repayment scheduling, arrears management, restructuring, early settlement, and maturity. It is the operational system for a live mortgage book.

**Containers:**
- **Lifecycle API** – REST API for drawdown, repayment capture, balance enquiry, and restructuring.
- **Repayment Scheduler** – Quartz-based engine that generates schedules, processes due payments via Payment Hub, and manages arrears.
- **Reporting Service** – Generates IFRS 9 staging data, regulatory reports, and borrower statements.
- **Lifecycle Database** – Stores loan schedules, repayment history, and restructuring events (PostgreSQL).

**Key integrations:**
- → CBS: tracks loan account balance and posts drawdown entries
- → Payment Hub: processes scheduled repayments
- → Notification Service: sends repayment reminders and arrears alerts
- → Collateral Management: monitors LTV ratio and triggers revaluation
- → Mortgage Risk: ongoing PD/LGD risk monitoring

### Collateral Management System

Tracks property collateral pledged against mortgage loans. Manages appraisal workflows (manual and AVM-based), monitors Loan-to-Value (LTV) ratios, and handles lien registration with the national property registry.

**Containers:**
- **Collateral Portal** – Backoffice React SPA for managing property records and appraisal workflows.
- **Collateral API** – REST API for registering collateral, requesting valuations, and querying LTV.
- **Valuation Service** – Integrates with external appraisers and maintains AVM outputs.
- **Collateral Database** – Stores property records, appraisal reports, and lien registrations (PostgreSQL).

**Key integrations:**
- → DMS: stores appraisal reports and property title documents
- → Property Registry (external): verifies property ownership and registers mortgage lien

### Mortgage Risk & Credit Assessment

Provides credit risk assessment at origination (affordability, DSCR, credit scoring) and ongoing portfolio risk monitoring (PD/LGD models, IFRS 9 staging). Risk analysts use the dashboard to monitor portfolio exposure.

**Containers:**
- **Credit Assessment Service** – Affordability analysis and credit scoring at origination.
- **Risk Modelling Service** – PD/LGD models for portfolio monitoring (Python/scikit-learn).
- **Risk Dashboard** – React SPA for risk analysts to monitor portfolio exposure and arrears trends.
- **Risk Database** – Stores credit scores, model outputs, and monitoring alerts (PostgreSQL).

**Key integrations:**
- → CBS: retrieves transaction history for affordability analysis

---

## Architecture Diagrams

### System Landscape

The landscape view shows all Mortgage Lending systems alongside their Core Banking dependencies and external systems.

![](embed:MortgageLandscape)

---

### Mortgage Origination System – Context

System context for MOS, showing all systems and externals involved in originating a mortgage.

![](embed:MortgageMOSContext)

---

### Mortgage Origination System – Containers

Container-level detail for MOS and its collaborators.

![](embed:MortgageMOSContainers)

---

### Mortgage Lifecycle Management – Context

System context for MLM, showing all systems involved in managing a live mortgage.

![](embed:MortgageMLMContext)

---

### Mortgage Lifecycle Management – Containers

Container-level detail for MLM and its collaborators.

![](embed:MortgageMLMContainers)

---

### Collateral Management System – Context

System context for Collateral Management, including the external Property Registry.

![](embed:MortgageCollateralContext)

---

### Collateral Management System – Containers

Container-level detail for Collateral Management.

![](embed:MortgageCollateralContainers)

---

### Mortgage Risk & Credit Assessment – Context

System context for Mortgage Risk.

![](embed:MortgageRiskContext)

---

### Mortgage Risk & Credit Assessment – Containers

Container-level detail for Mortgage Risk.

![](embed:MortgageRiskContainers)

---

## Cross-Domain Dependencies

Domain B **depends on** Domain A (Core Banking):

| Domain B System | Depends On | Purpose |
|----------------|------------|---------|
| MOS | CBS | Open loan account on approval |
| MOS | Payment Hub | Initial disbursement |
| MOS | DMS | Store application documents |
| MOS | Notification Service | Application status alerts |
| MOS | Identity Service | KYC verification |
| MOS | Compliance Service | AML/sanctions screening |
| MLM | CBS | Loan account balance tracking |
| MLM | Payment Hub | Scheduled repayments |
| MLM | Notification Service | Repayment reminders and arrears alerts |
| Collateral Mgmt | DMS | Appraisal documents |

Domain B also **feeds back into** Domain C (CRM): MOS exposes application status to the CRM's Customer 360 service, and accepts pre-qualified leads submitted by the CRM Lead Management service.

---

## Key Design Decisions

- **Mortgage-only scope**: This domain is intentionally scoped to residential mortgages with collateral — leasing, trade finance, and corporate lending are out of scope for this demo.
- **BIAN-aligned origination flow**: The origination process maps to BIAN's Mortgage and Consumer Loan service domains, enabling standard API contracts with potential third-party originators.
- **Collateral as a first-class system**: LTV monitoring and lien management are separated from origination to allow independent lifecycle management and to support future multi-collateral scenarios.
- **Embedded risk**: The Mortgage Risk system is tightly integrated into both origination (credit decision) and lifecycle (ongoing monitoring), supporting an IFRS 9 ECL staging workflow.
