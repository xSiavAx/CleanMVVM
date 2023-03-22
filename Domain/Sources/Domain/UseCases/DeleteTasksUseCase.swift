import Foundation

public protocol DeleteTasksUseCase {
    func execute(ids: [TodoTask.ID]) async throws
}

public final class DefaultDeleteTasksUseCase: DeleteTasksUseCase {
    private let taskRepo: TasksRepository
    
    public init(taskRepo: TasksRepository) {
        self.taskRepo = taskRepo
    }
    
    public func execute(ids: [TodoTask.ID]) async throws {
        try await taskRepo.removeTasks(ids: ids)
    }
}
