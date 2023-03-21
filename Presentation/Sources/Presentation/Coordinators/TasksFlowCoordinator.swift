import Foundation
import UIKit
import SwiftUI
import Domain

public protocol TasksFlowCoordinatorDependencies {
    func makeLogoutUseCase() -> LogoutUseCase
}

public final class TasksFlowCoordinator {
    private let navigationController: UINavigationController
    private let dependencies: TasksFlowCoordinatorDependencies
    private var onFinish: (() -> Void)?
    
    public init(
        navigationController: UINavigationController,
        dependencies: TasksFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        showTaskList()
    }
    
    private func showTaskList() {
        let viewModel = TaskListViewModel(
            logoutUseCase: dependencies.makeLogoutUseCase()
        ) { [weak self] in
            self?.finish()
        }
        setRootView(TaskListView(viewModel: viewModel))
    }
        
    private func setRootView<V: View>(_ view: V) {
        navigationController.viewControllers = [UIHostingController(rootView: view)]
    }
    
    private func finish() {
        defer { onFinish = nil }
        onFinish?()
    }
}