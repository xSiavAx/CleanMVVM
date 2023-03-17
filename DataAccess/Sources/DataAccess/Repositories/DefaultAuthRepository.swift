import Foundation
import Networking
import Domain

public final class DefaultAuthRepository: AuthRepository {
    static let key = "auth_key"
    
    private var requestBuilder: PreparedDataTransferCallBuilding
    private var authStorage: KeyValueStorage
    
    public init(requestBuilder: PreparedDataTransferCallBuilding, authStorage: KeyValueStorage) {
        self.requestBuilder = requestBuilder
        self.authStorage = authStorage
    }
    
    // MARK: - AuthRepository
    
    public func login(_ credentials: Credentials) async throws -> String {
        let response = try await requestBuilder.build(LoginCall(credentials: credentials)).perform()
        // Map errors here if needed
        return response.token
    }
    
    public func register(_ credentials: Credentials) async throws {
        // Map errors here if needed
        try await requestBuilder.build(RegisterCall(credentials: credentials)).perform()
    }
    
    public func save(authToken: String) async throws {
        try await authStorage.set(value: authToken, for: Self.key)
    }
}
