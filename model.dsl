workspace {

    !identifiers hierarchical
    !impliedRelationships com.structurizr.model.CreateImpliedRelationshipsUnlessSameRelationshipExistsStrategy

    model {

        properties {
            "structurizr.groupSeparator" "/"
        }

        # ── People ──────────────────────────────────────────────────────────────

        userCustomer = person "Customer" {
            description "A retail or mortgage customer using online banking and self-service portals."
            tags "User" "Customer" "Person"
        }

        userBackoffice = person "Backoffice User" {
            description "A bank employee operating backoffice and loan processing systems."
            tags "User" "Backoffice User" "Person"
        }

        userRiskAnalyst = person "Risk Analyst" {
            description "Analyst responsible for credit risk assessment and portfolio monitoring."
            tags "User" "Risk Analyst" "Person"
        }

        userRelationshipManager = person "Relationship Manager" {
            description "Bank staff managing customer relationships and financial product cross-selling."
            tags "User" "Relationship Manager" "Person"
        }

        userCRMAgent = person "CRM Agent" {
            description "Customer service agent using the CRM platform to manage leads and interactions."
            tags "User" "CRM Agent" "Person"
        }

        # ── External Systems ─────────────────────────────────────────────────────

        !include shared/externals.dsl

        # ── Domain A: Core Banking ───────────────────────────────────────────────

        !include 01-domain-A/applications.dsl

        # ── Domain B: Mortgage Lending ───────────────────────────────────────────

        !include 02-domain-B/applications.dsl

        # ── Domain C: CRM ────────────────────────────────────────────────────────

        !include 03-domain-C/applications.dsl

        # ── Relationships ────────────────────────────────────────────────────────

        !include 01-domain-A/relations.inc.dsl
        !include 02-domain-B/relations.inc.dsl
        !include 03-domain-C/relations.inc.dsl
    }

    views {
        styles {
            element "Element" {
                color "#ffffff"
                fontSize 22
            }

            element "Software System" {
                background "#1168bd"
            }

            element "Container" {
                background "#438dd5"
            }

            element "Person" {
                background "#08427b"
                shape Person
            }

            element "External" {
                background "#999999"
            }

            element "Database" {
                shape Cylinder
            }

            element "WebApp" {
                shape WebBrowser
            }

            element "API" {
                shape Hexagon
            }

            element "Service" {
                shape RoundedBox
            }

            element "Storage" {
                shape Folder
            }

            relationship "Relationship" {
                color "#666666"
                thickness 2
                fontSize 18
            }
        }
    }

}