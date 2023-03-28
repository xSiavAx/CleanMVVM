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
    
    var title: Title
    
    private let onFinish: () -> Void
    
    init(title: Title, task: TodoTask = .create(), onFinish: @escaping () -> Void) {
        self.title = title
        self.task = task
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

    }
}

fileprivate extension TodoTask {
    static func create() -> Self {
        return .init(id: -1, title: "", content: "", status: .todo)
    }
}
