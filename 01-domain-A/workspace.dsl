workspace extends ../model.dsl {
    name "Domain A – Core Banking"
    description "Core Banking domain: account management, payments, document services, notifications, identity and compliance. BIAN-aligned."

    !docs docs

    views {
        properties {
            "structurizr.sort" "created"
        }

        # ── 01. System Landscape ─────────────────────────────────────────────────

        systemLandscape CoreBankingLandscape {
            title "01. Core Banking – System Landscape"
            include element.tag==CoreBankingDomain
            include element.tag==External
            exclude element.tag==LendingDomain
            exclude element.tag==CRMDomain
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        # ── 02. Core Banking System – Context & Containers ───────────────────────

        systemContext cbs CoreBankingCBSContext {
            title "02. Core Banking System – System Context"
            include *
            exclude element.tag==Person
            exclude element.tag==LendingDomain
            exclude element.tag==CRMDomain
            autoLayout tb 400 200
        }

        container cbs CoreBankingCBSContainers {
            title "02.1 Core Banking System – Container View"
            include element.parent==cbs
            include element.parent==paymentHub
            include element.parent==complianceService
            include element.parent==notificationService
            include relationship==*
            autoLayout tb 300 200
        }

        # ── 03. Payment Hub – Context & Containers ───────────────────────────────

        systemContext paymentHub CoreBankingPaymentHubContext {
            title "03. Payment Hub – System Context"
            include *
            exclude element.tag==Person
            exclude element.tag==LendingDomain
            exclude element.tag==CRMDomain
            autoLayout tb 400 200
        }

        container paymentHub CoreBankingPaymentHubContainers {
            title "03.1 Payment Hub – Container View"
            include element.parent==paymentHub
            include element.parent==cbs
            include element.parent==notificationService
            include relationship==*
            autoLayout tb 300 200
        }

        # ── 04. Identity Service – Context & Containers ──────────────────────────

        systemContext identityService CoreBankingIdentityContext {
            title "04. Identity Service – System Context"
            include *
            exclude element.tag==Person
            exclude element.tag==LendingDomain
            exclude element.tag==CRMDomain
            autoLayout tb 400 200
        }

        container identityService CoreBankingIdentityContainers {
            title "04.1 Identity Service – Container View"
            include element.parent==identityService
            include smartID
            include eParaksts
            include relationship==*
            autoLayout tb 300 200
        }

    }
}
