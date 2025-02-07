struct AdParameters {
    static let shared = AdParameters()
    
    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        
        // Device Info
        params["ad-os"] = "ios"
        params["ad-osv"] = UIDevice.current.systemVersion
        params["ad-make"] = "apple"
        params["ad-model"] = "iphone"
        params["ad-device-w"] = UIScreen.main.bounds.width * UIScreen.main.scale
        params["ad-device-h"] = UIScreen.main.bounds.height * UIScreen.main.scale
        params["ad-pxratio"] = UIScreen.main.scale
        
        // Ad dimensions
        params["ad-min-width"] = 50
        params["ad-max-width"] = UIScreen.main.bounds.width
        params["ad-min-height"] = 50
        params["ad-max-height"] = 250
        
        // Device identifiers
        if let identifierForAdvertising = ASIdentifierManager.shared().advertisingIdentifier {
            params["ad-ifa"] = identifierForAdvertising.uuidString
        }
        
        // Network info
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders?.values.first {
            params["ad-carrier"] = carrier.carrierName
            if let mcc = carrier.mobileCountryCode, let mnc = carrier.mobileNetworkCode {
                params["ad-mccmnc"] = "\(mcc)-\(mnc)"
            }
        }
        
        // Language
        params["ad-language"] = Locale.current.languageCode?.uppercased()
        
        return params
    }
}