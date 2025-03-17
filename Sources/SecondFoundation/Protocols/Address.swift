//
//  Copyright © 2025 Hidden Spectrum, LLC.
//

import CoreLocation
import Foundation


public protocol Address {
    
    /// Street
    var thoroughfare: String? { get }
    
    /// Unit
    var subPremise: String? { get }
    
    /// Neighborhood
    var subLocality: String? { get }
    
    /// City
    var locality: String? { get }
    
    /// County
    var subAdministrativeArea: String? { get }
    
    /// City
    var administrativeArea: String? { get }
    
    var postalCode: String? { get }
    
    var country: String? { get }
}

public extension Address {
    
    // MARK: Defaults
    
    var thoroughfare: String? { nil }
    var subPremise: String? { nil }
    var subLocality: String? { nil }
    var locality: String? { nil }
    var subAdministrativeArea: String? { nil }
    var administrativeArea: String? { nil }
    var postalCode: String? { nil }
    var country: String? { nil }
}

public extension Address {
    
    // MARK: Utility
    
    var formattedAddress: String? {
        [streetWithSubPremise, cityStateZip]
            .compactMap{ $0?.trimmedNullIfEmpty }
            .joined(separator: "\n")
            .trimmedNullIfEmpty
    }
    
    var mappableAddress: String? {
        [thoroughfare, cityStateZip]
            .compactMap{ $0?.trimmedNullIfEmpty }
            .joined(separator: ", ")
            .trimmedNullIfEmpty
    }
    
    var streetWithSubPremise: String? {
        [thoroughfare, subPremise]
            .compactMap { $0?.trimmedNullIfEmpty }
            .joined(separator: " ")
            .trimmedNullIfEmpty
    }
    
    var cityState: String? {
        [locality, administrativeArea]
            .compactMap { $0?.trimmedNullIfEmpty }
            .joined(separator: ", ")
            .trimmedNullIfEmpty
    }
    
    var cityStateZip: String? {
        [cityState, postalCode]
            .compactMap { $0?.trimmedNullIfEmpty }
            .joined(separator: " ")
            .trimmedNullIfEmpty
    }
}
