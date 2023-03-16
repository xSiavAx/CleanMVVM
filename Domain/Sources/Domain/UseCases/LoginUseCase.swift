import Foundation

public protocol LoginUseCase {
    func execute(credentials: Credentials) async throws
}

public class DefaultLoginUseCase: LoginUseCase {
    private let loginApi: LoginApi
    
    init(loginApi: LoginApi) {
        self.loginApi = loginApi
    }
    
    public func execute(credentials: Credentials) async throws {
        try await loginApi.login(credentials)
    }
}
