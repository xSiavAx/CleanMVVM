import Foundation
import Presentation
import DataAccess
import Networking
import Domain
import UIKit

final class LoginDIContainer {
    private let requestBuilder: PreparedDataTransferCallBuilding
    private lazy var repository = DefaultAuthRepository(
        requestBuilder: requestBuilder,
        authStorage: KeyValueDataManagingStorage(
            manager: UserDefaults.standard // Definitely in real app we should use other storage than UserDefaults
        )
    )
    
    init(requestBuilder: PreparedDataTransferCallBuilding) {
        self.requestBuilder = requestBuilder
    }
    
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        return .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension LoginDIContainer: LoginFlowCoordinatorDependencies {
    func makeLoginUseCase() -> LoginUseCase {
        return DefaultLoginUseCase(repository: repository)
    }
    
    func makeRegisterUseCase() -> RegisterUseCase {
        return DefaultRegisterUseCase(repository: repository)
    }
}
