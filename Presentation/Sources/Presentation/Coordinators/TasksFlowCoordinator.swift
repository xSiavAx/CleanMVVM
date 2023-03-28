import Foundation
import UIKit
import SwiftUI
import Domain

public protocol TasksFlowCoordinatorDependencies {
    func makeLogoutUseCase() -> LogoutUseCase
    func makeUpgradeTaskStatusUseCase() -> UpgradeTaskStatusUseCase
    func makeDeleteTaskStatusUseCase() -> DeleteTasksUseCase
    func makeTaskListRepository() -> TaskManagerProtocol
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
            useCases: .init(
                logout: dependencies.makeLogoutUseCase(),
                upgradeTaskStatus: dependencies.makeUpgradeTaskStatusUseCase(),
                delete: dependencies.makeDeleteTaskStatusUseCase()
            ),
            taskListRepository: dependencies.makeTaskListRepository(),
            callBacks: .init(
                selectTask: { [weak self] in self?.showEditTask(task: $0) },
                createTask: { [weak self] in self?.showCreateTask() },
                finish: { [weak self] in self?.finish() }
            )
        )
        setRootView(TaskListView(viewModel: viewModel))
    }
    
    private func showCreateTask() {
        let view = EditTaskView(viewModel: .init(
            title: .edit,
            onFinish: { [weak self] in self?.navigationController.popViewController(animated: true) }
        ))
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }

    
    private func showEditTask(task: TodoTask) {
        let view = EditTaskView(viewModel: .init(
            title: .edit,
            task: task,
            onFinish: { [weak self] in self?.navigationController.popViewController(animated: true) }
        ))
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }
        
    private func setRootView<V: View>(_ view: V) {
        navigationController.viewControllers = [UIHostingController(rootView: view)]
    }
    
    private func finish() {
        defer { onFinish = nil }
        onFinish?()
    }
}
