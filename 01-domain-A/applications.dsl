// Domain A: Core Banking Software Systems
// BIAN Service Domains: Account Management, Payment Order, Document Services,
//   Party Notifications, Party Authentication, Regulatory Compliance

group "Core Banking Domain" {

    cbs = softwareSystem "Core Banking System" {
        description "Central banking platform managing customer accounts, deposits, loans ledger and general ledger."
        tags "CoreBankingDomain" "BIAN-AccountManagement" "BIANCompliant"

        coreAccountAPI = container "Core Account API" {
            description "RESTful API exposing account lifecycle operations: open, close, query balance, statement."
            technology "Java / Spring Boot"
            tags "API"
        }

        accountDB = container "Account Database" {
            description "Primary datastore for customer account records and balances."
            technology "PostgreSQL"
            tags "Database"
        }

        glService = container "General Ledger Service" {
            description "Double-entry accounting engine responsible for posting and reconciling all financial transactions."
            technology "Java / Spring Boot"
            tags "Service"
        }
    }

    paymentHub = softwareSystem "Payment Hub" {
        description "Centralised payment processing platform supporting SEPA Credit Transfer, SEPA Instant and SWIFT."
        tags "CoreBankingDomain" "BIAN-PaymentOrder" "BIANCompliant"

        paymentGateway = container "Payment Gateway" {
            description "Entry point for all inbound and outbound payment instructions; validates and authorises requests."
            technology "Java / Spring Boot"
            tags "API"
        }

        paymentProcessor = container "Payment Processor" {
            description "Orchestrates payment routing, clearing, settlement and exception handling."
            technology "Java / Spring Boot"
            tags "Service"
        }

        paymentDB = container "Payment Database" {
            description "Persistent store for payment orders, transaction history and reconciliation records."
            technology "PostgreSQL"
            tags "Database"
        }
    }

    dms = softwareSystem "Document Management System" {
        description "Centralised document storage, versioning, indexing and retrieval for all banking documents."
        tags "CoreBankingDomain" "BIAN-DocumentServices" "BIANCompliant"

        documentAPI = container "Document API" {
            description "REST API for document upload, retrieval, metadata management and lifecycle control."
            technology "Node.js / Express"
            tags "API"
        }

        documentStore = container "Document Store" {
            description "Encrypted object storage for all document files (PDFs, images, contracts)."
            technology "S3-compatible Object Storage"
            tags "Storage"
        }

        indexingService = container "Indexing Service" {
            description "Full-text search and document classification engine for fast document discovery."
            technology "Elasticsearch"
            tags "Service"
        }
    }

    notificationService = softwareSystem "Notification Service" {
        description "Omni-channel notification platform delivering transactional and alert messages to customers and staff."
        tags "CoreBankingDomain" "BIAN-PartyNotifications" "BIANCompliant"

        notifAPI = container "Notification API" {
            description "REST API for submitting notification requests and managing delivery preferences."
            technology "Python / FastAPI"
            tags "API"
        }

        notifDispatcher = container "Dispatcher" {
            description "Routes notifications to the appropriate channel (email, SMS, push) via external gateways."
            technology "Python / Celery"
            tags "Service"
        }

        notifDB = container "Notification Database" {
            description "Stores notification templates, delivery logs and user channel preferences."
            technology "PostgreSQL"
            tags "Database"
        }
    }

    identityService = softwareSystem "Identity Service" {
        description "Customer identity verification, KYC orchestration and strong authentication hub."
        tags "CoreBankingDomain" "BIAN-PartyAuthentication" "BIANCompliant"

        identityAPI = container "Identity API" {
            description "REST API for initiating and querying identity verification and KYC workflows."
            technology "Java / Spring Boot"
            tags "API"
        }

        kycEngine = container "KYC Engine" {
            description "Orchestrates identity checks via SmartID, e-signature.eu and biometric verification providers."
            technology "Java / Spring Boot"
            tags "Service"
        }

        identityDB = container "Identity Database" {
            description "Stores identity verification results, KYC status and audit trail."
            technology "PostgreSQL"
            tags "Database"
        }
    }

    complianceService = softwareSystem "Compliance Service" {
        description "AML transaction screening, sanctions checking and regulatory reporting."
        tags "CoreBankingDomain" "BIAN-RegulatoryCompliance" "BIANCompliant"

        amlEngine = container "AML Engine" {
            description "Real-time anti-money laundering screening applied to all financial transactions."
            technology "Java / Spring Boot"
            tags "Service"
        }

        reportingAPI = container "Reporting API" {
            description "Generates and submits regulatory reports (STR, CTR) to relevant authorities."
            technology "Python / FastAPI"
            tags "API"
        }

        complianceDB = container "Compliance Database" {
            description "Stores AML alerts, investigation cases and regulatory submission records."
            technology "PostgreSQL"
            tags "Database"
        }
    }

}
