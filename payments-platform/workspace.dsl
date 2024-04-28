workspace {

    model {
        user = person "User"
        customer = person "Customer"
        paymentApp = softwareSystem "Payment Application" "Application integrates Payments Platform for payments processing" {
            tags "external"
        }
        softwareSystem = softwareSystem "Payment Platform" {
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
                tags "events"
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
            paymentsApi -> events "Listen on Payment Events"
            routingApi -> events "Listen on Payment Events"
            antiMoneyLaundry -> events "Listen on Payment Events"
            fraudDetection -> events "Listen on Payment Events"
            clearningApi -> events "Listen on Payment Events"
            settlementApi -> events "Listen on Settlement Events"
            validationApi -> events "Listen on Payment Events"
            antiMoneyLaundry -> cache "Cache"
            fraudDetection -> cache "Cache"
            fraudDetection -> aiService "Score transaction"
            settlementApi -> ledgerDB "Read transactions"
            routingApi -> ledgerDB "Save transactions"
        }
        paymentNetwork = softwareSystem "Payment Network" {
            tags "Network, external"
        }

        customer -> softwareSystem "Uses"
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
            element "external" {
                background #999999
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
                shape MobileDeviceLandscape
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
        }
    }

    configuration {
        scope softwaresystem
    }

}
