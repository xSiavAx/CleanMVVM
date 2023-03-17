import Foundation

public protocol RegisterUseCase {
    func execute(credentials: Credentials) async throws
}

public class DefaultRegisterUseCase: RegisterUseCase {
    private let repository: AuthRepository
    private let loginUseCase: LoginUseCase
    
    public init(repository: AuthRepository, loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        self.repository = repository
    }
    
    public convenience init(repository: AuthRepository) {
        self.init(repository: repository, loginUseCase: DefaultLoginUseCase(repository: repository))
    }
    
    public func execute(credentials: Credentials) async throws {
        try await repository.register(credentials)
        try await loginUseCase.execute(credentials: credentials)
    }
}
