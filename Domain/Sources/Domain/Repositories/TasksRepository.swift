import Foundation
import Combine

public protocol FetchTaskRepository {
    func fetch() async throws -> [TodoTask]
}

public protocol TasksRepository {
    func update(task: TodoTask) async throws
}

// We can use observer or delegate instead
// I would go with `...Processor` suffix, but it may be unusual for others.
public protocol TaskListRepository {
    var tasks: CurrentValueSubject<[TodoTask], Never> { get }
    
    func start() async throws
}

public protocol TaskStorage {
    func task(id: TodoTask.ID) async throws -> TodoTask?
}

public final class RamTasksListRepository: TaskListRepository {
    private let dataSource: FetchTaskRepository
    private let tasksRepository: TasksRepository
    
    @Published
    public var tasks = CurrentValueSubject<[TodoTask], Never>([])
    
    public init(dataSource: FetchTaskRepository, tasksRepository: TasksRepository) {
        self.dataSource = dataSource
        self.tasksRepository = tasksRepository
    }
    
    @MainActor
    public func start() async throws {
        try await refetchTaskList()
    }
    
    private func refetchTaskList() async throws {
        let fetched = try await dataSource.fetch()
        
        tasks.send(fetched)
    }
}

extension RamTasksListRepository: TasksRepository {
    public func update(task: TodoTask) async throws {
        try await tasksRepository.update(task: task)
        try await refetchTaskList()
    }
}

extension RamTasksListRepository: TaskStorage {
    @MainActor
    public func task(id: TodoTask.ID) async throws -> TodoTask? {
        return tasks.value.first { $0.id == id }
    }
}
