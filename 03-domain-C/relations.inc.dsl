// Domain C: CRM – Relationships
// Cross-domain dependencies on Domain A (Core Banking) and Domain B (Mortgage Lending).

# ── CRM Internal wiring ───────────────────────────────────────────────────────

crm.crmPortal -> crm.crmAPI "Performs all CRM operations via REST" "HTTPS/REST"
crm.crmAPI -> crm.customer360Service "Requests aggregated customer profile" "Internal/gRPC"
crm.crmAPI -> crm.leadManagement "Creates and progresses prospect leads" "Internal/gRPC"
crm.crmAPI -> crm.campaignEngine "Triggers and monitors marketing campaigns" "Internal/gRPC"
crm.crmAPI -> crm.crmDB "Reads and writes CRM records" "JDBC"
crm.customer360Service -> crm.crmDB "Caches and stores unified customer profile snapshots" "JDBC"
crm.leadManagement -> crm.crmDB "Persists lead pipeline state and activity history" "JDBC"
crm.campaignEngine -> crm.crmDB "Stores campaign definitions, audience segments and delivery logs" "JDBC"

# ── CRM → Domain A (Core Banking) ────────────────────────────────────────────

crm.customer360Service -> cbs.coreAccountAPI "Retrieves account balances and product holdings for 360° view" "HTTPS/REST"
crm.campaignEngine -> notificationService.notifAPI "Sends targeted marketing communications to customers" "HTTPS/REST"

# ── CRM → Domain B (Mortgage Lending) ────────────────────────────────────────

crm.leadManagement -> mos.mosAPI "Submits pre-qualified mortgage leads as applications" "HTTPS/REST"
crm.customer360Service -> mos.mosAPI "Retrieves mortgage application status for customer timeline" "HTTPS/REST"
crm.customer360Service -> mlm.mlmAPI "Retrieves active mortgage details for customer 360° view" "HTTPS/REST"

# ── Domain B back to CRM ──────────────────────────────────────────────────────

mos.mosAPI -> crm.crmAPI "Retrieves customer CRM profile for application pre-fill" "HTTPS/REST"

# ── User access ───────────────────────────────────────────────────────────────

userCRMAgent -> crm.crmPortal "Manages customer interactions, leads and service requests" "HTTPS"
userRelationshipManager -> crm.crmPortal "Manages customer relationships and mortgage lead pipeline" "HTTPS"
userCustomer -> crm.crmPortal "Self-service enquiries and interaction history" "HTTPS"
