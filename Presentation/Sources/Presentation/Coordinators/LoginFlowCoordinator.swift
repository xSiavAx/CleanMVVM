import Foundation
import UIKit
import SwiftUI
import Domain

public protocol LoginFlowCoordinatorDependencies {
    func makeCheckAuthorizationUseCase() -> CheckAuthorizationUseCase
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
        self.onFinish = onFinish
        showSplashScreen()
    }
    
    private func showSplashScreen() {
        let viewModel = SplashViewModel(useCase: dependencies.makeCheckAuthorizationUseCase()) { [weak self] authorized in
            if authorized {
                self?.finish()
            } else {
                self?.showLogin()
            }
        }
        setRootView(SplashView(viewModel: viewModel))
    }
    
    private func showLogin() {
        let login = dependencies.makeLoginUseCase()
        let register = dependencies.makeRegisterUseCase()
        let viewModel = LoginViewModel(loginUseCase: login, registerUseCase: register) { [weak self] in
            self?.finish()
        }

        setRootView(LoginView(viewModel: viewModel))
    }
    
    private func setRootView<V: View>(_ view: V) {
        navigationController.viewControllers = [UIHostingController(rootView: view)]
    }
    
    private func finish() {
        defer { onFinish = nil }
        onFinish?()
    }
}
