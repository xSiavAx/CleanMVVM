import Foundation

public protocol LoginApi {
    func login(_ credentials: Credentials) async throws
}
