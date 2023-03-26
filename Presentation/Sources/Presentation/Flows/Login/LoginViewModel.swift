import Foundation
import Common
import Domain

// If we decide to split this screen into 2 – login and register,
// we definitely can reuse view and could try to reuse view model (as far as business logic incapsulated into abstract UseCase)
final class LoginViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor, DimmingProcessor {
    @Published
    var errorAlert: ErrorAlertContext?
    
    @Published
    var isDimmed = false
    
    @Published
    var login = "mail@siava.pp.ua"
    
    @Published
    var password = "testtest"
    
    private var loginUseCase: LoginUseCase
    private var registerUseCase: RegisterUseCase
    private var onFinish: () -> Void
    
    init(
        loginUseCase: LoginUseCase,
        registerUseCase: RegisterUseCase,
        onFinish: @escaping () -> Void
    ) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.onFinish = onFinish
    }
    
    func didTapLogin() {
        runTask { [weak self] in
            try await self?.withDimming {
                try await self?.login()
            }
        }
    }
    
    func didTapRegister() {
        runTask { [weak self] in
            try await self?.withDimming {
                try await self?.register()
            }
        }
    }
    
    @MainActor
    private func login() async throws {
        try await loginUseCase.execute(credentials: .init(email: login, password: password))
        onFinish()
    }
    
    @MainActor
    private func register() async throws {
        try await registerUseCase.execute(credentials: .init(email: login, password: password))
        onFinish()
    }
}

class DummyAuthUseCase: LoginUseCase, RegisterUseCase {
    func execute(credentials: Credentials) async throws {
        throw NSError(domain: "TestDomain", code: -1)
    }
}
