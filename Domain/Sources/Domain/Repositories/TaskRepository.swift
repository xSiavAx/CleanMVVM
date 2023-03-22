import Foundation
import Combine

public protocol FetchTaskRepository {
    func fetch() async throws -> [TodoTask]
}

// We can use observer or delegate instead
// I would go with `...Processor` suffix, but it may be unusual for others.
public protocol TaskListRepository {
    var tasks: CurrentValueSubject<[TodoTask], Never> { get }
    
    func start() async throws
}

public final class RamTasksListRepository: TaskListRepository {
    private let dataSource: FetchTaskRepository
    
    @Published
    public var tasks = CurrentValueSubject<[TodoTask], Never>([])
    
    public init(dataSource: FetchTaskRepository) {
        self.dataSource = dataSource
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
