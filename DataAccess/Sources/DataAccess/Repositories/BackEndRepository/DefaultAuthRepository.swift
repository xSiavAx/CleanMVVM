import Foundation
import Networking
import Domain

public final class DefaultAuthRepository: AuthRepository {
    private var requestBuilder: PreparedDataTransferCallBuilding
    
    public init(requestBuilder: PreparedDataTransferCallBuilding) {
        self.requestBuilder = requestBuilder
    }
    
    // MARK: - AuthRepository
    
    public func login(_ credentials: Credentials) async throws {
        try await requestBuilder.build(LoginCall(credentials: credentials)).perform()
    }
}
