# Domain A – Core Banking

## Overview

Domain A is the **Core Banking domain** of this FinTech demo. It provides the foundational financial infrastructure that all other domains depend on. The domain is modelled against BIAN (Banking Industry Architecture Network) service domains and consists of six software systems covering account management, payment processing, document storage, notifications, identity verification, and regulatory compliance.

This domain acts as the system-of-record for customer accounts, the clearing house for all payment flows, and the compliance backbone for the wider architecture.

---

## BIAN Alignment

| System | BIAN Service Domain |
|--------|---------------------|
| Core Banking System (CBS) | Account Management |
| Payment Hub | Payment Order |
| Document Management System | Document Services |
| Notification Service | Party Notifications |
| Identity Service | Party Authentication |
| Compliance Service | Regulatory Compliance |

---

## Systems

### Core Banking System (CBS)

The CBS is the central ledger of the bank. It manages the full lifecycle of customer accounts — from opening through to closure — and maintains the general ledger. All financial postings from payments, loans and other instruments are recorded here.

**Containers:**
- **Core Account API** – REST API for account lifecycle operations (open, close, balance query, statement).
- **Account Database** – Primary datastore for account records and balances (PostgreSQL).
- **General Ledger Service** – Double-entry accounting engine for posting and reconciling financial transactions.

### Payment Hub

The Payment Hub processes all inbound and outbound payments across SEPA Credit Transfer, SEPA Instant, and SWIFT rails. It validates, routes, clears, and settles payment orders, and debits/credits the underlying CBS accounts.

**Containers:**
- **Payment Gateway** – Entry point for payment instructions; validates and authorises.
- **Payment Processor** – Orchestrates routing, clearing, settlement, and exception handling (Kafka-based).
- **Payment Database** – Persistent store for payment orders and reconciliation records.

### Document Management System (DMS)

Centralised repository for all banking documents — mortgage agreements, KYC files, appraisal reports, and regulatory submissions. Provides versioning, indexing, and retrieval.

**Containers:**
- **Document API** – REST API for upload, retrieval, and lifecycle management.
- **Document Store** – Encrypted S3-compatible object storage.
- **Indexing Service** – Elasticsearch full-text search for fast discovery.

### Notification Service

Omni-channel platform for delivering transactional messages, alerts, and marketing communications to customers and staff via SMS, email, and push. Integrates with SendGrid as the downstream delivery gateway.

**Containers:**
- **Notification API** – REST API for submitting notification requests.
- **Dispatcher** – Routes notifications to the correct channel via SendGrid (Python/Celery).
- **Notification Database** – Stores templates, delivery logs, and preferences.

### Identity Service

Orchestrates customer identity verification and KYC (Know Your Customer) workflows. Integrates with SmartID for mobile authentication and e-signature.eu for qualified electronic signatures.

**Containers:**
- **Identity API** – REST API for initiating and querying KYC workflows.
- **KYC Engine** – Orchestrates checks via SmartID and e-signature.eu.
- **Identity Database** – Stores verification results and audit trail.

### Compliance Service

Provides AML (Anti-Money Laundering) transaction screening, sanctions list checking, and regulatory report generation (STR, CTR) for supervisory authorities.

**Containers:**
- **AML Engine** – Real-time screening of all financial transactions.
- **Reporting API** – Generates and submits regulatory reports.
- **Compliance Database** – Stores alerts, cases, and submission records.

---

## Architecture Diagrams

### System Landscape

The landscape view shows all Core Banking systems and their external dependencies.

![](embed:CoreBankingLandscape)

---

### Core Banking System – Context

System context for the CBS, showing all systems and externals that interact with it.

![](embed:CoreBankingCBSContext)

---

### Core Banking System – Containers

Container-level detail for the CBS and its immediate collaborators.

![](embed:CoreBankingCBSContainers)

---

### Payment Hub – Context

System context for the Payment Hub.

![](embed:CoreBankingPaymentHubContext)

---

### Payment Hub – Containers

Container-level detail for the Payment Hub.

![](embed:CoreBankingPaymentHubContainers)

---

### Identity Service – Context

System context for the Identity Service and its external verification providers.

![](embed:CoreBankingIdentityContext)

---

### Identity Service – Containers

Container-level detail for the Identity Service.

![](embed:CoreBankingIdentityContainers)

---

## Cross-Domain Dependencies

Domain A is the **provider** in all cross-domain relationships:

- **Domain B (Mortgage Lending)** depends on CBS (loan accounts), Payment Hub (disbursement & repayments), DMS (documents), Notification Service (alerts), Identity Service (KYC), and Compliance Service (AML).
- **Domain C (CRM)** depends on CBS (account balances and product holdings) and Notification Service (marketing communications).

---

## Key Design Decisions

- **BIAN compliance**: Every system is tagged with its primary BIAN Service Domain to enable governance tooling and cross-industry alignment.
- **API-first**: All cross-system communication is via REST (`HTTPS/REST`). Internal container-to-container calls use gRPC or Kafka for performance.
- **Separation of concerns**: Compliance (AML) is a dedicated system rather than embedded in CBS, enabling independent scaling and audit.
- **Shared Identity Hub**: Identity verification is centralised so Mortgage Lending can reuse the same KYC flow without duplicating integrations.
