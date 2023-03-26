import Foundation

public protocol FetchTaskRepository {
    func fetch() async throws -> [TodoTask]
}

public protocol TasksRepository {
    func update(task: TodoTask) async throws
    func removeTasks(ids: [TodoTask.ID]) async throws
}

public protocol TaskSource {
    func task(id: TodoTask.ID) async throws -> TodoTask?
}

