import Foundation
import Common

public protocol KeyValueStorage {
    func value<T>(for key: String) async throws -> T?
    func set<T>(value: T?, for key: String) async throws
}

public enum KeyValueDataManagingStorageError: Error {
    case cantCast(val: Any, to: Any.Type)
}

public final class KeyValueDataManagingStorage: KeyValueStorage {
    let manager: KeyValueDataManager
    
    public init(manager: KeyValueDataManager) {
        self.manager = manager
    }
    
    public func value<T>(for key: String) async throws -> T? {
        return try await withCheckedThrowingContinuation { [manager] continuation in
            DispatchQueue.bg.async {
                do {
                    guard let val = try manager.value(for: key) else {
                        return continuation.resume(returning: nil)
                    }
                    guard let casted = val as? T else {
                        throw KeyValueDataManagingStorageError.cantCast(val: val, to: T.self)
                    }
                    return continuation.resume(returning: casted)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func set<T>(value: T?, for key: String) async throws {
        try await withCheckedThrowingContinuation { [manager] continuation in
            DispatchQueue.bg.async {
                do {
                    try manager.set(value: value, for: key)
                    try manager.synchronize()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
