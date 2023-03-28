import Foundation

public protocol FetchTaskRepository {
    func fetch() async throws -> [TodoTask]
}

public protocol TasksRepository {
    func create(task: TodoTask) async throws
    func update(task: TodoTask) async throws
    func removeTasks(ids: [TodoTask.ID]) async throws
}

public protocol TaskSource {
    func task(id: TodoTask.ID) async throws -> TodoTask?
}

