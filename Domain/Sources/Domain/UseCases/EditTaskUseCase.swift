import Foundation

public enum EditTaskError: Error, CustomStringConvertible {
    case titleIsEmpty
    case contentIsEmpty
    
    public var description: String {
        switch self {
        case .titleIsEmpty: return "Task title is empty"
        case .contentIsEmpty: return "Task content is empty"
        }
    }
}

public protocol EditTaskUseCase {
    func execute(task: TodoTask) async throws
}

public class DefaultEditTaskUseCase {
    let taskRepo: TasksRepository
    
    public init(taskRepo: TasksRepository) {
        self.taskRepo = taskRepo
    }
    
    func validate(task: TodoTask) throws {
        guard !task.title.isEmpty else { throw EditTaskError.titleIsEmpty }
        guard !task.content.isEmpty else { throw EditTaskError.contentIsEmpty }
    }
}

public final class CreateTaskUseCase: DefaultEditTaskUseCase, EditTaskUseCase {
    public func execute(task: TodoTask) async throws {
        try validate(task: task)
        try await taskRepo.create(task: task)
    }
}

public final class UpdateTaskUseCase: DefaultEditTaskUseCase, EditTaskUseCase {
    public func execute(task: TodoTask) async throws {
        try validate(task: task)
        try await taskRepo.update(task: task)
    }
}
