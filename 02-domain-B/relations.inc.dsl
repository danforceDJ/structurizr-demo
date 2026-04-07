// Domain B: Mortgage Lending – Relationships
// Covers internal Domain B wiring and cross-domain dependencies on Domain A (Core Banking) and externals.

# ── Mortgage Origination System (MOS) – internal wiring ──────────────────────

mos.mosPortal -> mos.mosAPI "Submits and tracks mortgage applications" "HTTPS/REST"
mos.mosAPI -> mos.mosWorkflow "Advances application through origination stages" "Internal/gRPC"
mos.mosWorkflow -> mos.mosDecisionEngine "Requests automated underwriting decision" "Internal/gRPC"
mos.mosWorkflow -> mos.mosDB "Persists application state and stage transitions" "JDBC"
mos.mosDecisionEngine -> mos.mosDB "Reads application data for policy evaluation" "JDBC"

# ── MOS → Domain A (Core Banking) ────────────────────────────────────────────

mos.mosAPI -> cbs.coreAccountAPI "Opens mortgage loan account on final approval" "HTTPS/REST"
mos.mosAPI -> paymentHub.paymentGateway "Initiates initial loan disbursement to borrower" "HTTPS/REST"
mos.mosAPI -> dms.documentAPI "Stores mortgage application documents and signed agreements" "HTTPS/REST"
mos.mosAPI -> notificationService.notifAPI "Sends application status notifications to applicant" "HTTPS/REST"
mos.mosAPI -> identityService.identityAPI "Requests KYC verification for mortgage applicant" "HTTPS/REST"
mos.mosAPI -> complianceService.amlEngine "Submits applicant data for AML and sanctions screening" "HTTPS/REST"

# ── MOS → Domain B (Mortgage Risk & Collateral) ──────────────────────────────

mos.mosAPI -> mortgageRisk.creditAssessmentService "Requests affordability and credit assessment" "HTTPS/REST"
mos.mosAPI -> collateralMgmt.collateralAPI "Registers subject property as loan collateral" "HTTPS/REST"

# ── MOS → Externals ───────────────────────────────────────────────────────────

mos.mosAPI -> creditBureau "Requests credit history report for affordability assessment" "HTTPS/REST"

# ── Mortgage Lifecycle Management (MLM) – internal wiring ────────────────────

mlm.mlmScheduler -> mlm.mlmDB "Reads and updates repayment schedules and arrears records" "JDBC"
mlm.mlmAPI -> mlm.mlmDB "Queries and records lifecycle events" "JDBC"
mlm.mlmReportingService -> mlm.mlmDB "Reads loan data for reporting and IFRS 9 staging" "JDBC"

# ── MLM → Domain A (Core Banking) ────────────────────────────────────────────

mlm.mlmScheduler -> paymentHub.paymentGateway "Triggers scheduled repayment debits" "HTTPS/REST"
mlm.mlmAPI -> cbs.coreAccountAPI "Queries loan account balance and posts drawdown entries" "HTTPS/REST"
mlm.mlmScheduler -> notificationService.notifAPI "Sends repayment reminders and arrears alerts to borrower" "HTTPS/REST"

# ── MLM → Domain B (Collateral & Risk) ───────────────────────────────────────

mlm.mlmAPI -> collateralMgmt.collateralAPI "Requests current LTV and triggers revaluation if breached" "HTTPS/REST"
mlm.mlmAPI -> mortgageRisk.riskModelingService "Submits loan data for ongoing PD/LGD risk monitoring" "HTTPS/REST"

# ── Collateral Management System (CMS) – internal wiring ─────────────────────

collateralMgmt.collateralPortal -> collateralMgmt.collateralAPI "Manages property records and valuation workflows" "HTTPS/REST"
collateralMgmt.collateralAPI -> collateralMgmt.valuationService "Requests automated or manual property valuation" "Internal/gRPC"
collateralMgmt.collateralAPI -> collateralMgmt.collateralDB "Stores and retrieves collateral and lien records" "JDBC"
collateralMgmt.valuationService -> collateralMgmt.collateralDB "Persists appraisal results and AVM outputs" "JDBC"

# ── CMS → Domain A ────────────────────────────────────────────────────────────

collateralMgmt.collateralAPI -> dms.documentAPI "Stores appraisal reports and property title documents" "HTTPS/REST"

# ── CMS → Externals ───────────────────────────────────────────────────────────

collateralMgmt.collateralAPI -> propertyRegistry "Verifies property ownership and registers mortgage lien" "HTTPS/REST"

# ── Mortgage Risk & Credit Assessment – internal wiring ──────────────────────

mortgageRisk.creditAssessmentService -> mortgageRisk.riskDB "Stores credit scores and affordability results" "JDBC"
mortgageRisk.riskModelingService -> mortgageRisk.riskDB "Persists PD/LGD model outputs and monitoring alerts" "JDBC"
mortgageRisk.riskDashboard -> mortgageRisk.riskDB "Queries portfolio risk metrics for visualisation" "JDBC"

# ── Mortgage Risk → Domain A ──────────────────────────────────────────────────

mortgageRisk.creditAssessmentService -> cbs.coreAccountAPI "Retrieves account transaction history for affordability analysis" "HTTPS/REST"

# ── User access ───────────────────────────────────────────────────────────────

userCustomer -> mos.mosPortal "Submits and monitors mortgage applications" "HTTPS"
userBackoffice -> mos.mosPortal "Reviews and processes mortgage applications" "HTTPS"
userBackoffice -> collateralMgmt.collateralPortal "Manages property collateral records and appraisals" "HTTPS"
userRiskAnalyst -> mortgageRisk.riskDashboard "Monitors portfolio credit risk and LTV exposure" "HTTPS"
