//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import Foundation


public extension FileManager {
    
    func enumerator(for url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = []) throws -> AsyncDirectoryEnumerator {
        return try AsyncDirectoryEnumerator(using: self, for: url, includingPropertiesForKeys: keys, options: mask)
    }
}


public enum AsyncDirectoryEnumeratorError: Error {
    case couldNotCreateEnumerator
}


public final class AsyncDirectoryEnumerator: AsyncSequence {
    
    // MARK: Public
    
    public typealias Element = URL
    public typealias AsyncIterator = AsyncDirectoryEnumeratorIterator
    
    // MARK: Private
    
    private let enumerator: FileManager.DirectoryEnumerator
    
    // MARK: Lifecycle
    
    init(using fileManager: FileManager, for url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws {
        guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: keys, options: mask) else {
            throw AsyncDirectoryEnumeratorError.couldNotCreateEnumerator
        }
        self.enumerator = enumerator
    }
    
    // MARK: AsyncSequence
    
    public func makeAsyncIterator() -> AsyncDirectoryEnumeratorIterator {
        return AsyncDirectoryEnumeratorIterator(enumerator: enumerator)
    }
}


public final class AsyncDirectoryEnumeratorIterator: AsyncIteratorProtocol {
    
    // MARK: Public
    
    public typealias Element = URL
    
    // MARK: Private

    private let enumerator: FileManager.DirectoryEnumerator
    
    // MARK: Lifecycle

    init(enumerator: FileManager.DirectoryEnumerator) {
        self.enumerator = enumerator
    }
    
    // MARK: AsyncIteratorProtocol
    
    public func next() async -> URL? {
        return enumerator.nextObject() as? URL
    }
}
