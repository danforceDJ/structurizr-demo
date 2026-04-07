workspace extends ../model.dsl {
    name "Domain C – CRM"
    description "Customer Relationship Management domain: customer 360 view, lead-to-mortgage pipeline, campaign management. BIAN-aligned."

    !docs docs

    views {
        properties {
            "structurizr.sort" "created"
        }

        # ── 01. System Landscape ─────────────────────────────────────────────────

        systemLandscape CRMLandscape {
            title "01. CRM – System Landscape"
            include element.tag==CRMDomain
            include element.tag==CoreBankingDomain
            include element.tag==LendingDomain
            exclude element.tag==External
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        # ── 02. CRM System – Context & Containers ────────────────────────────────

        systemContext crm CRMSystemContext {
            title "02. Customer Relationship Management – System Context"
            include *
            exclude element.tag==Person
            autoLayout tb 400 200
        }

        container crm CRMContainerView {
            title "02.1 Customer Relationship Management – Container View"
            include element.parent==crm
            include element.parent==cbs
            include element.parent==notificationService
            include element.parent==mos
            include element.parent==mlm
            include relationship==*
            autoLayout tb 300 150
        }

    }
}
