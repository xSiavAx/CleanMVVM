import Foundation
import Common
import Domain

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
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func didTapLogin() {
        runTask { [weak self] in
            try await self?.withDimming {
                try await self?.login()
            }
        }
    }
    
    func didTapRegister() {
        isDimmed = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.isDimmed = false
        }
    }
    
    @MainActor
    private func login() async throws {
        try await loginUseCase.execute(credentials: .init(email: login, password: password))
    }
}

class DummyLoginUseCase: LoginUseCase {
    func execute(credentials: Credentials) async throws {
        throw NSError(domain: "TestDomain", code: -1)
    }
}

