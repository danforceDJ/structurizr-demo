// Domain A: Core Banking – Internal Relationships

# CBS internal wiring
cbs.coreAccountAPI -> cbs.accountDB "Reads and writes account records" "JDBC"
cbs.glService -> cbs.accountDB "Posts and reconciles general ledger entries" "JDBC"
cbs.coreAccountAPI -> cbs.glService "Triggers GL posting on account events" "Internal/gRPC"

# Payment Hub internal wiring
paymentHub.paymentGateway -> paymentHub.paymentProcessor "Forwards validated payment orders" "Internal/Kafka"
paymentHub.paymentProcessor -> paymentHub.paymentDB "Persists payment transactions and status updates" "JDBC"

# Cross-service relationships within Domain A
paymentHub.paymentProcessor -> cbs.coreAccountAPI "Debits and credits customer accounts for payments" "HTTPS/REST"
paymentHub.paymentProcessor -> notificationService.notifAPI "Sends payment confirmation and receipt notification" "HTTPS/REST"
cbs.coreAccountAPI -> complianceService.amlEngine "Submits account transactions for AML screening" "HTTPS/REST"
notificationService.notifDispatcher -> infobip "Delivers SMS, email and push notifications via gateway" "HTTPS/REST"
dms.documentAPI -> dms.documentStore "Stores and retrieves encrypted document files" "S3 API"
dms.documentAPI -> dms.indexingService "Indexes document metadata for search" "HTTPS/REST"
identityService.kycEngine -> smartID "Requests mobile identity authentication" "HTTPS/REST"
identityService.kycEngine -> eParaksts "Requests qualified electronic signature" "HTTPS/REST"
identityService.kycEngine -> identityService.identityDB "Persists KYC results and audit trail" "JDBC"

# Backoffice user access to Core Banking
userBackoffice -> cbs "Manages customer accounts and performs backoffice operations"
userBackoffice -> complianceService "Reviews AML alerts and regulatory reports"
