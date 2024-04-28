workspace "Money.net - Payment Gateway System" {
    !docs docs

    model {
        user = person "User"
        customer = person "Customer"
        eCommerceWebsite = softwareSystem "eCommerce Website" "Online store" {
            tags "Web Browser"
        }

        eCommerceMobileApp = softwareSystem "eCommerce Mobile App" "Mobile App for online store" {
            tags "Mobile App"
        }

        paymentApp = softwareSystem "Payment Application" "Application integrates Payments Platform for payments processing" {
            tags "external"
        }
        softwareSystem = softwareSystem "Payment Gateway" "Payment Gateway for processing payments"{
            !adrs adrs 

            tags "Platform"
            paymentsApi = container "Payments API" "Provide payments capabilities for consumers" {
                tags "API"
            }

            validationApi = container "Validation API" "Validate Payment" {
                tags "API"
            }

            clearningApi = container "Clearing API" "Clearing Payment" {
                tags "API"
            }

            settlementApi = container "Settlement API" "Settlement Payment" {
                tags "API"
            }

            events = container "Payment Events Stream" "Event Stream for Payment" {
                tags "events, async"
            }

            cache = container "Cache" "Cache Layer for Payment" {
                tags "Cache"
            }

            routingApi = container "Routing API" "Routing Payment" {
                tags "API"
            }

            antiMoneyLaundry = container "Anti Money Laundry" "AML for Payment" {
                tags "AML"
            }

            fraudDetection = container "Fraud Detection" "Fraud Detection for Payment" {
                tags "Fraud Detection"
            }

            sso = container "SSO" "Single Sign On" {
                tags "SSO"
            }

            aiService = container "AI Service" "AI Service for Fraud Detection" {
                tags "AI"
            }

            ledgerDB = container "Ledger DB" "Ledger Database" {
                tags "Database"
            }

            paymentsApi -> sso "Authenticate and authorize request"
            paymentsApi -> events "Listen on Payment Events" {
                tags "async"
            }
            routingApi -> events "Listen on Payment Events" {
                tags "async"
            }
            antiMoneyLaundry -> events "Listen on Payment Events" {
                tags "async"
            }
            fraudDetection -> events "Listen on Payment Events" {
                tags "async"
            }
            clearningApi -> events "Listen on Payment Events" {
                tags "async"
            }
            settlementApi -> events "Listen on Settlement Events" {
                tags "async"
            }
            validationApi -> events "Listen on Payment Events" {
                tags "async"
            }
            antiMoneyLaundry -> cache "Cache"
            fraudDetection -> cache "Cache"
            fraudDetection -> aiService "Score transaction"
            settlementApi -> ledgerDB "Read transactions"
            routingApi -> ledgerDB "Save transactions"
        }
        paymentNetwork = softwareSystem "Payment Network" {
            tags "Network, external"
        }

        eCommerceWebsite -> softwareSystem "Uses"
        eCommerceMobileApp -> softwareSystem "Uses"
        user -> paymentApp "Uses"
        paymentApp -> paymentsApi "Process payment"
        softwareSystem -> paymentNetwork "Uses"
        routingApi -> paymentNetwork "Send transaction"
        settlementApi -> paymentNetwork "Send batch transactions"
    }

    views {
        systemContext softwareSystem "Landscape" {
            include *
        }

        container softwareSystem "Containers" {
            include *
        }

        dynamic softwareSystem "RealTimePaymentDataFlow" {
            title "Real Time Payment Data Flow"
            user -> paymentApp "Uses"
            paymentApp -> paymentsApi "Process payment"
            paymentsApi -> events "New Payment" 
            events -> validationApi "Validation Topic"
            validationApi -> events "Compliance Topic"
            events -> routingApi "Routing Topic"
            events -> antiMoneyLaundry "Compliance Topic"
            events -> fraudDetection "Compliance Topic"
            fraudDetection -> events "Clearing Topic"
            antiMoneyLaundry -> events "Clearing Topic"
            clearningApi -> events "Routing Topic"
            events -> clearningApi "Clearing Topic"
            antiMoneyLaundry -> cache "Cache"
            fraudDetection -> cache "Cache"
            routingApi -> paymentNetwork "Send to network"
            fraudDetection -> aiService "Score payment"
            routingApi -> ledgerDB "Save to Ledger"
        }

        dynamic softwareSystem "PaymentDataFlow" {
            title "Payment Data Flow"
            user -> paymentApp "Uses"
            paymentApp -> paymentsApi "Process payment"
            paymentsApi -> events "New Payment"
            events -> validationApi "Validation Topic"
            validationApi -> events "Compliance Topic"
            events -> routingApi "Routing Topic"
            events -> antiMoneyLaundry "Compliance Topic"
            events -> fraudDetection "Compliance Topic"
            fraudDetection -> events "Clearing Topic"
            antiMoneyLaundry -> events "Clearing Topic"
            fraudDetection -> aiService "Score payment"
            events -> clearningApi "Clearing Topic"
            antiMoneyLaundry -> cache "Cache"
            fraudDetection -> cache "Cache"

            routingApi -> ledgerDB "Save to Ledger"
            events -> settlementApi "Settlement Topic"
            settlementApi -> ledgerDB "Read transactions"
            settlementApi -> paymentNetwork "Send to network"
        }

        dynamic softwareSystem "RealTimePaymentNetworkFlow" {
            title "Real time Payment Network"
            user -> paymentApp "Uses"
            paymentApp -> paymentsApi "Process payment"
            paymentsApi -> events "New Payment"
            events -> validationApi "Validate Payment"
            events -> routingApi "Routing"
            events -> antiMoneyLaundry "AML check"
            events -> fraudDetection "Fraud check"
            events -> clearningApi "Clearing"
            antiMoneyLaundry -> cache "Cache"
            fraudDetection -> cache "Cache"
            routingApi -> paymentNetwork "Send to network"
            fraudDetection -> aiService "Score payment"
            routingApi -> ledgerDB "Save to Ledger"
        }

        styles {
            element "Person" {
                background #123456
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Customer" {
                background #08427b
            }
            
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Mobile App" {
                shape MobileDevicePortrait
            }
            element "Database" {
                shape Cylinder
            }

            element "Cache" {
                shape Cylinder
            }

            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }

            relationship "Relationship" {
                dashed false
            }

            relationship "async" {
                dashed true
            }

            element "external" {
                background #999999
            }

            theme default
        }
    }

    properties {
        "c4plantuml.elementProperties" "true"
        "c4plantuml.tags" "true"
        # "generatr.style.colors.primary" "#485fc7"
        # "generatr.style.colors.secondary" "#ffffff"
        # "generatr.style.faviconPath" "site/favicon.ico"
        # "generatr.style.logoPath" "site/logo.png"

        # // Absolute URL's like "https://example.com/custom.css" are also supported
        # "generatr.style.customStylesheet" "site/custom.css"

        "generatr.svglink.target" "_self"

        // Full list of available "generatr.markdown.flexmark.extensions"
        // "Abbreviation,Admonition,AnchorLink,Aside,Attributes,Autolink,Definition,Emoji,EnumeratedReference,Footnotes,GfmIssues,GfmStrikethroughSubscript,GfmTaskList,GfmUsers,GitLab,Ins,Macros,MediaTags,ResizableImage,Superscript,Tables,TableOfContents,SimulatedTableOfContents,Typographic,WikiLinks,XWikiMacro,YAMLFrontMatter,YouTubeLink"
        // see https://github.com/vsch/flexmark-java/wiki/Extensions
        // ATTENTION:
        // * "generatr.markdown.flexmark.extensions" values must be separated by comma
        // * it's not possible to use "GitLab" and "ResizableImage" extensions together
        // default behaviour, if no generatr.markdown.flexmark.extensions property is specified, is to load the Tables extension only
        "generatr.markdown.flexmark.extensions" "Abbreviation,Admonition,AnchorLink,Attributes,Autolink,Definition,Emoji,Footnotes,GfmTaskList,GitLab,MediaTags,Tables,TableOfContents,Typographic"

        "generatr.site.exporter" "c4"
        "generatr.site.externalTag" "External System"
        "generatr.site.nestGroups" "false"
    }

    configuration {
        scope softwaresystem
    }

}
