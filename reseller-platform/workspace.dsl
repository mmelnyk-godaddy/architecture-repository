workspace "Reseller System" {
    !docs docs
    !adrs adrs
    
    model {
        reseller = person "Reseller"
        merchant = person "Merchant"

        customer = person "Customer"
        softwareSystem = softwareSystem "Software System"

        customer -> softwareSystem "Uses"
        reseller -> softwareSystem "Uses"
        merchant -> softwareSystem "Uses"
    }

    views {
        systemContext softwareSystem "Diagram1" {
            include *
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
            element "Bank Staff" {
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
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }
        }
        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }

    configuration {
        scope softwaresystem
    }
}
