import Foundation

public protocol EditTaskUseCase {
    func execute(task: TodoTask) async throws
}

public class DefaultEditTaskUseCase {
    let taskRepo: TasksRepository
    
    public init(taskRepo: TasksRepository) {
        self.taskRepo = taskRepo
    }
}

public final class CreateTaskUseCase: DefaultEditTaskUseCase, EditTaskUseCase {
    public func execute(task: TodoTask) async throws {
        try await taskRepo.create(task: task)
    }
}

public final class UpdateTaskUseCase: DefaultEditTaskUseCase, EditTaskUseCase {
    public func execute(task: TodoTask) async throws {
        try await taskRepo.update(task: task)
    }
}
