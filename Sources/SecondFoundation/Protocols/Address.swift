//
//  Copyright © 2025 Hidden Spectrum, LLC.
//

import Contacts
import CoreLocation
import Foundation


public protocol Address {
    
    /// Address street number
    var subThoroughfare: String? { get }
    
    /// Street or street with number
    var thoroughfare: String? { get }
    
    /// Unit / second line of address
    var subPremise: String? { get }
    
    /// Neighborhood
    var subLocality: String? { get }
    
    /// City
    var locality: String? { get }
    
    /// County
    var subAdministrativeArea: String? { get }
    
    /// City
    var administrativeArea: String? { get }
    
    /// Postal code of the address
    var postalCode: String? { get }
    
    /// Full country name of the address
    var country: String? { get }
    
    /// ISO country code of the address
    var isoCountryCode: String? { get }
}

public extension Address {
    
    // MARK: Defaults
    
    var subThoroughfare: String? { nil }
    var thoroughfare: String? { nil }
    var subPremise: String? { nil }
    var subLocality: String? { nil }
    var locality: String? { nil }
    var subAdministrativeArea: String? { nil }
    var administrativeArea: String? { nil }
    var postalCode: String? { nil }
    var country: String? { nil }
    var isoCountryCode: String? { nil }
}

public extension Address {
    
    // MARK: Utility
    
    var cnPostalAddress: CNPostalAddress {
        let address = CNMutablePostalAddress()
        address.street = fullThoroughfareWithSubPremise ?? ""
        address.subLocality = subLocality ?? ""
        address.city = locality ?? ""
        address.subAdministrativeArea = subAdministrativeArea ?? ""
        address.state = administrativeArea ?? ""
        address.postalCode = postalCode ?? ""
        address.country = country ?? ""
        address.isoCountryCode = isoCountryCode ?? ""
        return address
    }
    
    var formattedAddress: String? {
        [fullThoroughfareWithSubPremise, cityStateZip]
            .compactMap{ $0?.trimmedNullIfEmpty }
            .joined(separator: "\n")
            .trimmedNullIfEmpty
    }
    
    var mappableAddress: String? {
        [fullThoroughfare, cityStateZip]
            .compactMap{ $0?.trimmedNullIfEmpty }
            .joined(separator: ", ")
            .trimmedNullIfEmpty
    }
    
    var fullThoroughfare: String? {
        [subThoroughfare?.trimmedNullIfEmpty, thoroughfare?.trimmedNullIfEmpty]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmedNullIfEmpty
    }
    
    var fullThoroughfareWithSubPremise: String? {
        [fullThoroughfare, subPremise]
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

public extension Address {
    
    // MARK: Localized / Formatted Info
    
    var localizedCityStateZip: String? {
        let address = CNMutablePostalAddress()
        address.city = locality ?? ""
        address.state = administrativeArea ?? ""
        address.postalCode = postalCode ?? ""
        address.isoCountryCode = isoCountryCode ?? ""
        return CNPostalAddressFormatter().string(from: address).trimmedNullIfEmpty
    }
    
    var localizedCityStateZipCountry: String? {
        let address = CNMutablePostalAddress()
        address.city = locality ?? ""
        address.state = administrativeArea ?? ""
        address.postalCode = postalCode ?? ""
        address.country = country ?? ""
        address.isoCountryCode = isoCountryCode ?? ""
        return CNPostalAddressFormatter().string(from: address).trimmedNullIfEmpty
    }
    
    var localizedFormattedAddress: String? {
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: cnPostalAddress).trimmedNullIfEmpty
    }
}

extension CLPlacemark: Address {}
