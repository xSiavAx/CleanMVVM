import Foundation

public protocol LoginUseCase {
    func execute(credentials: Credentials) async throws
}
