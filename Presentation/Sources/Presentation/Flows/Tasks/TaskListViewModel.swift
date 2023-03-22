import Foundation
import Common
import Domain
import Combine

// Generally, this view (as well as whole Flow) should be separated on Main and Tasks
// It may help to separate logout and tasks related stuff...
final class TaskListViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor, DimmingProcessor {
    struct UseCases {
        let logout: LogoutUseCase
        let upgradeTaskStatus: UpgradeTaskStatusUseCase
        let delete: DeleteTasksUseCase
    }
    struct TaskRow: Identifiable {
        let id: Int
        let title: String
        let status: TodoTask.Status
    }
    @Published
    var errorAlert: ErrorAlertContext?
    
    @Published
    var isDimmed: Bool = false
    
    @Published
    var tasks: [TaskRow] = []
    
    private let useCases: UseCases
    private let taskListRepository: TaskListRepository
    private let onFinish: () -> Void
    
    private var subscriptions = Set<AnyCancellable>()
    private var started = false
    
    init(useCases: UseCases, taskListRepository: TaskListRepository, onFinish: @escaping () -> Void) {
        self.useCases = useCases
        self.taskListRepository = taskListRepository
        self.onFinish = onFinish
    }

    func start() {
        guard !started else { return }
        started = true
        
        taskListRepository
            .tasks
            .map { $0.map{ $0.asRow() } }
            .sink { self.tasks = $0 }
            .store(in: &subscriptions)
        
        runTask { [weak self] in
            try await self?.taskListRepository.start()
        }
    }
    
    func didTapLogout() {
        runTask { [weak self] in
            try await self?.withDimming {
                try await self?.logout()
            }
        }
    }
    
    func didTapStatus(taskID: TodoTask.ID, status: TodoTask.Status) {
        runTask { [weak self] in
            try await self?.withDimming {
                try await self?.useCases.upgradeTaskStatus.execute(id: taskID, oldStatus: status)
            }
        }
    }
    
    func deleteTasks(at indexes: IndexSet) {
        let ids = indexes.map { tasks[$0].id }
        
        runTask { [weak self] in
            try await self?.useCases.delete.execute(ids: ids)
        }
    }
    
    @MainActor
    private func logout() async throws {
        try await useCases.logout.execute()
        onFinish()
    }
}

fileprivate extension TodoTask {
    func asRow() -> TaskListViewModel.TaskRow {
        return .init(id: id, title: title, status: status)
    }
}

fileprivate final class DummyUseCase: LogoutUseCase, UpgradeTaskStatusUseCase, DeleteTasksUseCase {
    func execute() async throws {}
    func execute(id: TodoTask.ID, oldStatus: TodoTask.Status) async throws {}
    func execute(ids: [TodoTask.ID]) async throws {}
}

final class DummyTaskListRepository: TaskListRepository {
    var tasks = CurrentValueSubject<[TodoTask], Never>([])
    
    func start() async throws {
        tasks.send([
            TodoTask(id: 1, title: "Task #1", content: "Task to do", status: .todo),
            TodoTask(id: 2, title: "Task #2", content: "Task in progress", status: .inProgress),
            TodoTask(id: 3, title: "Task #2", content: "Task done", status: .done)
        ])
    }
}

extension TaskListViewModel {
    static func forPreview() -> Self {
        return .init(
            useCases: .init(
                logout: DummyUseCase(),
                upgradeTaskStatus: DummyUseCase(),
                delete: DummyUseCase()
            ),
            taskListRepository: DummyTaskListRepository(),
            onFinish: {}
        )
    }
}
