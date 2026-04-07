// Domain C: CRM – Software Systems
// Custom-built CRM platform for a mid-size FinTech.
// BIAN Service Domains: Customer Management, Prospect Management, Campaign Management

group "CRM Domain" {

    crm = softwareSystem "Customer Relationship Management" {
        description "Custom-built CRM platform providing a unified 360° customer view, lead management, marketing campaign automation and customer service tooling."
        tags "CRMDomain" "BIAN-CustomerManagement" "BIAN-ProspectManagement" "BIAN-CampaignManagement" "BIANCompliant"

        crmPortal = container "CRM Portal" {
            description "Web application used by CRM agents and relationship managers to manage customer interactions, leads and service requests."
            technology "React / TypeScript"
            tags "WebApp"
        }

        crmAPI = container "CRM API" {
            description "REST API gateway orchestrating all CRM business operations and external data fetching."
            technology "Java / Spring Boot"
            tags "API"
        }

        customer360Service = container "Customer 360 Service" {
            description "Aggregates customer profile data from Core Banking and Lending domains into a unified view."
            technology "Python / FastAPI"
            tags "Service"
        }

        campaignEngine = container "Campaign Engine" {
            description "Marketing automation engine for creating, scheduling and tracking customer-targeted campaigns across email and SMS."
            technology "Python / Celery"
            tags "Service"
        }

        leadManagement = container "Lead Management Service" {
            description "Manages prospect pipelines from initial lead capture through qualification to product application hand-off."
            technology "Java / Spring Boot"
            tags "Service"
        }

        crmDB = container "CRM Database" {
            description "Stores CRM records: customer interactions, leads, campaigns, service requests and notes."
            technology "PostgreSQL"
            tags "Database"
        }
    }

}
