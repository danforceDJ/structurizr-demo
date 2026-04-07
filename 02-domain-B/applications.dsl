// Domain B: Mortgage Lending Software Systems
// Scope: Mortgage loan origination and full lifecycle management with collateral.
// BIAN Service Domains: Mortgage, Consumer Loan, Mortgage Loan, Loan,
//   Collateral Asset Administration, Collateral Valuation, Credit Management, Credit Risk

group "Mortgage Lending Domain" {

    mos = softwareSystem "Mortgage Origination System" {
        description "End-to-end mortgage application platform covering intake, document collection, underwriting workflow and approval/rejection decisioning."
        tags "LendingDomain" "BIAN-Mortgage" "BIAN-ConsumerLoan" "BIANCompliant"

        mosPortal = container "Mortgage Portal" {
            description "Customer-facing web application for submitting and tracking mortgage applications."
            technology "React / TypeScript"
            tags "WebApp"
        }

        mosAPI = container "Origination API" {
            description "REST API orchestrating the mortgage application workflow and external integrations."
            technology "Java / Spring Boot"
            tags "API"
        }

        mosWorkflow = container "Workflow Engine" {
            description "BPM engine managing multi-stage origination process: intake → underwriting → approval → offer."
            technology "Camunda BPM"
            tags "Service"
        }

        mosDecisionEngine = container "Decision Engine" {
            description "Automated underwriting rules engine applying affordability, LTV and policy checks."
            technology "Drools / Java"
            tags "Service"
        }

        mosDB = container "Origination Database" {
            description "Stores mortgage applications, supporting documents references and decision audit trail."
            technology "PostgreSQL"
            tags "Database"
        }
    }

    mlm = softwareSystem "Mortgage Lifecycle Management" {
        description "Post-origination mortgage management system covering drawdown, repayment scheduling, arrears, restructuring, early settlement and maturity."
        tags "LendingDomain" "BIAN-MortgageLoan" "BIAN-Loan" "BIANCompliant"

        mlmAPI = container "Lifecycle API" {
            description "REST API exposing mortgage account operations: drawdown, repayment capture, balance enquiry, restructuring."
            technology "Java / Spring Boot"
            tags "API"
        }

        mlmScheduler = container "Repayment Scheduler" {
            description "Automated engine generating repayment schedules, processing due payments and managing arrears."
            technology "Java / Quartz Scheduler"
            tags "Service"
        }

        mlmReportingService = container "Reporting Service" {
            description "Generates regulatory loan reports, IFRS 9 staging data and borrower statements."
            technology "Python / FastAPI"
            tags "Service"
        }

        mlmDB = container "Lifecycle Database" {
            description "Stores loan schedules, repayment history, arrears records and restructuring events."
            technology "PostgreSQL"
            tags "Database"
        }
    }

    collateralMgmt = softwareSystem "Collateral Management System" {
        description "Tracks property collateral registered against mortgage loans, manages appraisals, monitors LTV ratio and handles lien registration."
        tags "LendingDomain" "BIAN-CollateralAssetAdministration" "BIAN-CollateralValuation" "BIANCompliant"

        collateralPortal = container "Collateral Portal" {
            description "Backoffice web UI for managing property records, appraisal workflows and lien status."
            technology "React / TypeScript"
            tags "WebApp"
        }

        collateralAPI = container "Collateral API" {
            description "REST API for registering collateral, submitting valuation requests and querying LTV."
            technology "Java / Spring Boot"
            tags "API"
        }

        valuationService = container "Valuation Service" {
            description "Integrates with external property appraisers and maintains automated valuation model (AVM) results."
            technology "Python / FastAPI"
            tags "Service"
        }

        collateralDB = container "Collateral Database" {
            description "Stores property records, appraisal reports, lien registrations and LTV history."
            technology "PostgreSQL"
            tags "Database"
        }
    }

    mortgageRisk = softwareSystem "Mortgage Risk & Credit Assessment" {
        description "Credit risk assessment and ongoing portfolio risk monitoring platform for mortgage lending."
        tags "LendingDomain" "BIAN-CreditManagement" "BIAN-CreditRisk" "BIANCompliant"

        creditAssessmentService = container "Credit Assessment Service" {
            description "Performs affordability analysis, debt-service coverage ratio and credit scoring on mortgage applications."
            technology "Python / FastAPI"
            tags "Service"
        }

        riskModelingService = container "Risk Modelling Service" {
            description "Runs probabilistic default and loss-given-default models for portfolio-level risk monitoring."
            technology "Python / scikit-learn"
            tags "Service"
        }

        riskDashboard = container "Risk Dashboard" {
            description "Interactive dashboard for risk analysts to monitor portfolio exposure, LTV distribution and arrears trends."
            technology "React / TypeScript"
            tags "WebApp"
        }

        riskDB = container "Risk Database" {
            description "Stores credit scores, risk model outputs, PD/LGD estimates and monitoring alerts."
            technology "PostgreSQL"
            tags "Database"
        }
    }

}
