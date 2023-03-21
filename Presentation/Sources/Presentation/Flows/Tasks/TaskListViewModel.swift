import Foundation
import Common
import Domain

final class TaskListViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor, DimmingProcessor {
    @Published
    var errorAlert: ErrorAlertContext?
    
    @Published
    var isDimmed: Bool = false
    
    private var logoutUseCase: LogoutUseCase
    private var onFinish: () -> Void
    
    init(logoutUseCase: LogoutUseCase, onFinish: @escaping () -> Void) {
        self.logoutUseCase = logoutUseCase
        self.onFinish = onFinish
    }
    
    func start() {
        
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

final class DummyLogoutUseCase: LogoutUseCase {
    func execute() async throws {}
}
