import Foundation
import Combine

// We can use observer or delegate instead
public protocol TaskManagerProtocol {
    var tasks: CurrentValueSubject<[TodoTask], Never> { get }
    
    func start() async throws
}

public final class TaskManager: TaskManagerProtocol {
    private let dataSource: FetchTaskRepository
    private let tasksRepository: TasksRepository
    
    @Published
    public var tasks = CurrentValueSubject<[TodoTask], Never>([])
    
    public init(dataSource: FetchTaskRepository, tasksRepository: TasksRepository) {
        self.dataSource = dataSource
        self.tasksRepository = tasksRepository
    }
    
    public func start() async throws {
        try await refetchTaskList()
    }
    
    @MainActor
    private func refetchTaskList() async throws {
        let fetched = try await dataSource.fetch()
        
        tasks.send(fetched)
    }
}

extension TaskManager: TasksRepository {
    public func update(task: TodoTask) async throws {
        try await tasksRepository.update(task: task)
        try await refetchTaskList()
    }
    
    public func removeTasks(ids: [TodoTask.ID]) async throws {
        try await tasksRepository.removeTasks(ids: ids)
        try await refetchTaskList()
    }
}

extension TaskManager: TaskSource {
    @MainActor
    public func task(id: TodoTask.ID) async throws -> TodoTask? {
        return tasks.value.first { $0.id == id }
    }
}
