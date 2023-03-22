import Foundation
import Domain
import Networking

public final class DefaultTasksRepository: FetchTaskRepository {
    private let authRepository: AuthRepository
    private let requestBuilder: PreparedDataTransferCallBuilding
    
    public init(authRepository: AuthRepository, requestBuilder: PreparedDataTransferCallBuilding) {
        self.authRepository = authRepository
        self.requestBuilder = requestBuilder
    }
    
    public func fetch() async throws -> [TodoTask] {
        let token = try await requiredToken()
        let response = try await requestBuilder.build(FetchTasksCall(token: token)).perform()
        
        return try response.toDomain()
    }
    
    private func requiredToken() async throws -> String {
        guard let token = try await authRepository.authToken() else {
            throw CommunicationError.unauthorized
        }
        return token
    }
}
