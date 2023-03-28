import Foundation
import Common
import Domain

final class EditTaskViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor, DimmingProcessor {
    enum Title: String {
        case edit = "Edit task"
        case create = "Create task"
    }
    
    @Published
    var errorAlert: ErrorAlertContext?
    
    @Published
    var isDimmed: Bool = false
    
    @Published
    var task: TodoTask
    
    var saveEnabled: Bool { !task.title.isEmpty }
    // Here is also shall be `&& !task.content.isEmpty`. It's intentional so, to demonstrate validation logic in UseCase
    
    var title: Title
    
    private let useCase: EditTaskUseCase
    private let onFinish: () -> Void
    
    init(title: Title, task: TodoTask = .create(), useCase: EditTaskUseCase, onFinish: @escaping () -> Void) {
        self.title = title
        self.task = task
        self.useCase = useCase
        self.onFinish = onFinish
    }
    
    func didTapSave() {
        runTask { [weak self] in
            try await self?.withDimming {
                try await self?.save()
            }
        }
    }
    
    @MainActor
    private func save() async throws {
        try await useCase.execute(task: task)
        onFinish()
    }
}

fileprivate extension TodoTask {
    static func create() -> Self {
        return .init(id: -1, title: "", content: "", status: .todo)
    }
}

final class DummyEditTaskUseCase: EditTaskUseCase {
    func execute(task: TodoTask) async throws {}
}
