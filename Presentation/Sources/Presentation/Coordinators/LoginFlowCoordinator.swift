import Foundation
import UIKit
import SwiftUI
import Domain

public protocol LoginFlowCoordinatorDependencies {
    func makeLoginUseCase() -> LoginUseCase
    func makeRegisterUseCase() -> RegisterUseCase
}

public final class LoginFlowCoordinator {
    private let navigationController: UINavigationController
    private let dependencies: LoginFlowCoordinatorDependencies
    private var onFinish: (() -> Void)?
    
    public init(
        navigationController: UINavigationController,
        dependencies: LoginFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start(onFinish: @escaping () -> Void) {
        let login = dependencies.makeLoginUseCase()
        let register = dependencies.makeRegisterUseCase()
        let view = LoginView(viewModel: .init(loginUseCase: login, registerUseCase: register, onFinish: onFinish))

        navigationController.viewControllers = [UIHostingController(rootView: view)]
    }
}
