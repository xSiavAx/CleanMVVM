import Foundation
import Domain
import Networking

public final class DefaultTasksRepository: FetchTaskRepository, TasksRepository {
    private let authRepository: AuthRepository
    private let requestBuilder: PreparedDataTransferCallBuilding
    
    public init(authRepository: AuthRepository, requestBuilder: PreparedDataTransferCallBuilding) {
        self.authRepository = authRepository
        self.requestBuilder = requestBuilder
    }
    
    public func fetch() async throws -> [TodoTask] {
        let token = try await requiredToken()
        let call = FetchTasksCall(token: token)
        let response = try await requestBuilder.build(call).perform()
        
        return try response.toDomain()
    }
    
    private func requiredToken() async throws -> String {
        guard let token = try await authRepository.authToken() else {
            throw CommunicationError.unauthorized
        }
        return token
    }
    
    public func update(task: TodoTask) async throws {
        let token = try await requiredToken()
        let call = UpdateTaskCall(token: token, task: task)
        let response = try await requestBuilder.build(call).perform()
        
        try response.requireNoError()
    }
    
    public func removeTasks(ids: [TodoTask.ID]) async throws {
        let token = try await requiredToken()
        
        for id in ids {
            let call = DeleteTaskCall(token: token, id: id)
            let response = try await requestBuilder.build(call).perform()
            
            try response.requireNoError()
        }
    }
    
}
