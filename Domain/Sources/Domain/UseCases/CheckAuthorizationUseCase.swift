import Foundation

public protocol CheckAuthorizationUseCase {
    func execute() async throws -> Bool
}

public class DefaultCheckAuthorizationUseCase: CheckAuthorizationUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> Bool {
        // Additional network call may be performed here, to check token is still valid and clear it otherwise
        return try await repository.authToken() != nil
    }
}
