import Foundation
import UIKit
import Presentation

final class AppFlowCoordinator {
    private let navigationController: UINavigationController
    private let appDIContainer = AppDIContainer()
    private var loginCoordinator: LoginFlowCoordinator?
    private var tasksCoordinator: TasksFlowCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginScreen()
    }
    
    private func showLoginScreen() {
        let loginDIContainer = appDIContainer.makeLoginDIContainer()
        
        loginCoordinator = loginDIContainer.makeLoginFlowCoordinator(navigationController: navigationController)
        
        loginCoordinator?.start { [weak self] in
            self?.loginCoordinator = nil
            self?.showMainScreen()
        }
    }
    
    private func showMainScreen() {
        let tasksDIContainer = appDIContainer.makeTasksDIContainer()
        
        tasksCoordinator = tasksDIContainer.makeTasksFlowCoordinator(navigationController: navigationController)
        
        tasksCoordinator?.start { [weak self] in
            self?.tasksCoordinator = nil
            self?.showLoginScreen()
        }
    }
}
