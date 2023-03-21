import Foundation

public protocol LogoutUseCase {
    func execute() async throws
}

public class DefaultLogoutUseCase: LogoutUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute() async throws {
        // Make logout back-end call if needed
        try await repository.clearAuthToken()
    }
}
