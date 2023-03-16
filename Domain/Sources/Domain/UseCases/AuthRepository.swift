import Foundation

public protocol AuthRepository {
    func login(_ credentials: Credentials) async throws
}
