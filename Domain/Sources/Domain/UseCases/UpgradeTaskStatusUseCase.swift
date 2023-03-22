import Foundation

public protocol UpgradeTaskStatusUseCase {
    func execute(id: TodoTask.ID, oldStatus: TodoTask.Status) async throws
}

public final class DefaultUpgradeTaskStatusUseCase: UpgradeTaskStatusUseCase {
    private let taskStorage: TaskStorage
    private let taskRepo: TasksRepository
    
    public init(taskStorage: TaskStorage, taskRepo: TasksRepository) {
        self.taskStorage = taskStorage
        self.taskRepo = taskRepo
    }
    
    public func execute(id: TodoTask.ID, oldStatus: TodoTask.Status) async throws {
        if var task = try await taskStorage.task(id: id) {
            let newStatus = oldStatus.upgraded()
            
            if newStatus != task.status {
                task.status = newStatus
                try await taskRepo.update(task: task)
            }
        }
    }
}

fileprivate extension TodoTask.Status {
    func upgraded() -> Self {
        switch self {
        case .todo: return .inProgress
        case .inProgress: return .done
        case .done: return .todo
        }
    }
}
