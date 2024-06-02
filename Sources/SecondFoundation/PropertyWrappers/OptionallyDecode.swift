//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import Foundation


@propertyWrapper
public struct OptionallyDecode<Wrapped: Decodable> {
    public let wrappedValue: Wrapped?
    
    public init(wrappedValue: Wrapped?) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionallyDecode: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        wrappedValue = try? container?.decode(Wrapped.self)
    }
}

/// We need this protocol to circumvent how the Swift compiler currently handles non-existing fields for property wrappers, always failing when there is no matching key.
public protocol NullableCodable {
    associatedtype Wrapped: Decodable, ExpressibleByNilLiteral
    var wrappedValue: Wrapped { get }
    init(wrappedValue: Wrapped)
}

extension OptionallyDecode: NullableCodable {}

extension KeyedDecodingContainer {
    /// Necessary for handling non-existing fields, due to how Swift compiler currently synthesises decoders for property wrappers, always failing when there is no matching key.
    public func decode<T: NullableCodable>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        let decoded = try self.decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: nil)
        return decoded
    }
}

extension OptionallyDecode: Encodable where Wrapped: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension OptionallyDecode: Equatable where Wrapped: Equatable {}

extension OptionallyDecode: Hashable where Wrapped: Hashable {}

extension OptionallyDecode: Sendable where Wrapped: Sendable {}
