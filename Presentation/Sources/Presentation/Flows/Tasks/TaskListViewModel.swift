import Foundation
import Common
import Domain
import Combine

// Generally, this view (as well as whole Flow) should be separated on Main and Tasks
// It may help to separate logout and tasks related stuff...
final class TaskListViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor, DimmingProcessor {
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
    
    private let logoutUseCase: LogoutUseCase
    private let taskListRepository: TaskListRepository
    private let onFinish: () -> Void
    
    private var subscriptions = Set<AnyCancellable>()
    private var started = false
    
    init(logoutUseCase: LogoutUseCase, taskListRepository: TaskListRepository, onFinish: @escaping () -> Void) {
        self.logoutUseCase = logoutUseCase
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
    
    @MainActor
    private func logout() async throws {
        try await logoutUseCase.execute()
        onFinish()
    }
}

fileprivate extension TodoTask {
    func asRow() -> TaskListViewModel.TaskRow {
        return .init(id: id, title: title, status: status)
    }
}

final class DummyLogoutUseCase: LogoutUseCase {
    func execute() async throws {}
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
