import Foundation
import Presentation
import DataAccess
import Networking
import Domain
import UIKit

final class LoginDIContainer {
    private let requestBuilder: PreparedDataTransferCallBuilding
    
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
        let repository = DefaultAuthRepository(requestBuilder: requestBuilder)
        return DefaultLoginUseCase(repository: repository)
    }
}
