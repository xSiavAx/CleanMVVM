import Foundation

public protocol AuthRepository {
    func login(_ credentials: Credentials) async throws -> String
    func register(_ credentials: Credentials) async throws
    func save(authToken: String) async throws
}
