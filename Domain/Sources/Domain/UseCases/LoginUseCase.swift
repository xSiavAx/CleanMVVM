import Foundation

public protocol LoginUseCase {
    func execute(credentials: Credentials) async throws
}

public class DefaultLoginUseCase: LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(credentials: Credentials) async throws {
        try await repository.login(credentials)
    }
}
