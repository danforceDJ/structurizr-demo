workspace extends ../model.dsl {
    name "Domain B – Mortgage Lending"
    description "Mortgage Lending domain: origination, lifecycle management, collateral management and credit risk assessment. BIAN-aligned."

    !docs docs

    views {
        properties {
            "structurizr.sort" "created"
        }

        # ── 01. System Landscape ─────────────────────────────────────────────────

        systemLandscape MortgageLandscape {
            title "01. Mortgage Lending – System Landscape"
            include element.tag==LendingDomain
            include element.tag==CoreBankingDomain
            include creditBureau
            include propertyRegistry
            exclude element.tag==CRMDomain
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        # ── 02. Mortgage Origination System ──────────────────────────────────────

        systemContext mos MortgageMOSContext {
            title "02. Mortgage Origination System – System Context"
            include *
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        container mos MortgageMOSContainers {
            title "02.1 Mortgage Origination System – Container View"
            include element.parent==mos
            include element.parent==mortgageRisk
            include element.parent==collateralMgmt
            include element.parent==cbs
            include element.parent==dms
            include element.parent==notificationService
            include element.parent==identityService
            include element.parent==complianceService
            include creditBureau
            include relationship==*
//            autoLayout tb 300 150
        }

        # ── 03. Mortgage Lifecycle Management ────────────────────────────────────

        systemContext mlm MortgageMLMContext {
            title "03. Mortgage Lifecycle Management – System Context"
            include *
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        container mlm MortgageMLMContainers {
            title "03.1 Mortgage Lifecycle Management – Container View"
            include element.parent==mlm
            include element.parent==cbs
            include element.parent==paymentHub
            include element.parent==notificationService
            include element.parent==collateralMgmt
            include element.parent==mortgageRisk
            include relationship==*
            autoLayout tb 300 150
        }

        # ── 04. Collateral Management System ─────────────────────────────────────

        systemContext collateralMgmt MortgageCollateralContext {
            title "04. Collateral Management System – System Context"
            include *
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        container collateralMgmt MortgageCollateralContainers {
            title "04.1 Collateral Management System – Container View"
            include element.parent==collateralMgmt
            include element.parent==dms
            include propertyRegistry
            include relationship==*
            autoLayout tb 300 150
        }

        # ── 05. Mortgage Risk & Credit Assessment ─────────────────────────────────

        systemContext mortgageRisk MortgageRiskContext {
            title "05. Mortgage Risk & Credit Assessment – System Context"
            include *
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        container mortgageRisk MortgageRiskContainers {
            title "05.1 Mortgage Risk & Credit Assessment – Container View"
            include element.parent==mortgageRisk
            include element.parent==cbs
            include creditBureau
            include relationship==*
            autoLayout tb 300 150
        }

    }
}
