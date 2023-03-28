import Foundation
import Common
import Domain
import Combine

// Generally, this view (as well as whole Flow) should be separated on Main and Tasks
// It may help to separate logout and tasks related stuff...
final class TaskListViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor, DimmingProcessor {
    struct CallBacks {
        var selectTask: (TodoTask) -> Void
        var createTask: () -> Void
        var finish: () -> Void
    }
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
    private let taskListRepository: TaskManagerProtocol
    private let callBacks: CallBacks
    
    private var subscriptions = Set<AnyCancellable>()
    private var started = false
    
    init(
        useCases: UseCases,
        taskListRepository: TaskManagerProtocol,
        callBacks: CallBacks
    ) {
        self.useCases = useCases
        self.taskListRepository = taskListRepository
        self.callBacks = callBacks
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
            try await self?.withDimming {
                try await self?.taskListRepository.start()
            }
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
    
    func didTapDelete(at indexes: IndexSet) {
        let ids = indexes.map { tasks[$0].id }
        
        runTask { [weak self] in
            try await self?.useCases.delete.execute(ids: ids)
        }
    }
    
    func didTapCreateTask() {
        callBacks.createTask()
    }
    
    // It would be better to work with idx (pos)
    func didSelectRow(id: TodoTask.ID) {
        if let task = taskListRepository.tasks.value.first(where: { $0.id == id }) {
            callBacks.selectTask(task)
        }
    }
    
    @MainActor
    private func logout() async throws {
        try await useCases.logout.execute()
        callBacks.finish()
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

final class DummyTaskManager: TaskManagerProtocol {
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
            taskListRepository: DummyTaskManager(),
            callBacks: .init(selectTask: { _ in }, createTask: {}, finish: {})
        )
    }
}
