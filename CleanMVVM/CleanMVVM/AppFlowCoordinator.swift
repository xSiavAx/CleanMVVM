import Foundation
import UIKit
import Presentation

final class AppFlowCoordinator {
    private let navigationController: UINavigationController
    private let appDIContainer = AppDIContainer()
    private var loginCoordinator: LoginFlowCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginDIContainer = appDIContainer.makeLoginDIContainer()
        
        loginCoordinator = loginDIContainer.makeLoginFlowCoordinator(navigationController: navigationController)
        
        loginCoordinator?.start { [weak self] in
            self?.loginCoordinator = nil
            self?.showMainScreen()
        }
    }
    
    private func showMainScreen() {
        let stub = UIViewController()
        
        stub.view.backgroundColor = .orange
        
        navigationController.viewControllers = [stub]
    }
}
