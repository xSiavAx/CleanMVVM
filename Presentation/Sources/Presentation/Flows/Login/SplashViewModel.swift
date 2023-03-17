import Foundation
import Common
import Domain

final class SplashViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor {
    @Published
    var errorAlert: ErrorAlertContext?
    
    private var useCase: CheckAuthorizationUseCase
    private var onFinish: (_ authorized: Bool) -> Void
    
    init(
        useCase: CheckAuthorizationUseCase,
        onFinish: @escaping (_ authorized: Bool) -> Void
    ) {
        self.useCase = useCase
        self.onFinish = onFinish
    }
    
    @MainActor
    func start() {
        runTask { [weak self] in
            try await self?.checkAuthorized()
        }
    }
    
    @MainActor
    private func checkAuthorized() async throws {
        onFinish(try await useCase.execute())
    }
}

class DummyCheckAuthorizationUseCase: CheckAuthorizationUseCase {
    func execute() async throws -> Bool {
        return true
    }
}
