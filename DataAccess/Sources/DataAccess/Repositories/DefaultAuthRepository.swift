import Foundation
import Networking
import Domain

public final class DefaultAuthRepository: AuthRepository {
    static let key = "auth_key"
    
    private let requestBuilder: PreparedDataTransferCallBuilding
    private let authStorage: KeyValueStorage
    
    public init(requestBuilder: PreparedDataTransferCallBuilding, authStorage: KeyValueStorage) {
        self.requestBuilder = requestBuilder
        self.authStorage = authStorage
    }
    
    // MARK: - AuthRepository
    
    public func login(_ credentials: Credentials) async throws -> String {
        // Map errors to domain here if needed
        try await requestBuilder.build(LoginCall(credentials: credentials)).perform().toDomain()
    }
    
    public func register(_ credentials: Credentials) async throws {
        // Map errors to domain here if needed
        try await requestBuilder.build(RegisterCall(credentials: credentials)).perform().toDomain()
    }
    
    public func save(authToken: String) async throws {
        try await authStorage.set(value: authToken, for: Self.key)
    }
    
    public func authToken() async throws -> String? {
        return try await authStorage.value(for: Self.key)
    }
    
    public func clearAuthToken() async throws {
        try await authStorage.set(value: nil, for: Self.key)
    }
}
