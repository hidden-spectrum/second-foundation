//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public extension FileManager {
    
    /// Grabs the contents of given directory asynchronously.
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions = []) async throws -> [URL] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let files = try self.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: mask)
                continuation.resume(returning: files)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func enumerator(for url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: DirectoryEnumerationOptions = []) async -> AsyncDirectoryEnumerator? {
        return AsyncDirectoryEnumerator(using: self, for: url, includingPropertiesForKeys: keys, options: mask)
    }
}


public final class AsyncDirectoryEnumerator: AsyncSequence {
    
    // MARK: Public
    
    public typealias Element = URL
    public typealias AsyncIterator = AsyncDirectoryEnumeratorIterator
    
    // MARK: Private
    
    private let enumerator: FileManager.DirectoryEnumerator
    
    // MARK: Lifecycle
    
    init?(using fileManager: FileManager, for url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) {
        guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: keys, options: mask) else {
            return nil
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
