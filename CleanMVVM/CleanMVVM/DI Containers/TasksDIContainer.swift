import Foundation
import Presentation
import DataAccess
import Networking
import Domain
import UIKit

final class TasksDIContainer {
    private let requestBuilder: PreparedDataTransferCallBuilding
    private lazy var authRepository = DefaultAuthRepository(
        requestBuilder: requestBuilder,
        authStorage: KeyValueDataManagingStorage(
            manager: UserDefaults.standard // Definitely in real app we should use other storage than UserDefaults
        )
    )
    private lazy var tasksRepository = DefaultTasksRepository(authRepository: authRepository, requestBuilder: requestBuilder)
    private lazy var taskManager = TaskManager(dataSource: tasksRepository, tasksRepository: tasksRepository)
    
    init(requestBuilder: PreparedDataTransferCallBuilding) {
        self.requestBuilder = requestBuilder
    }
    
    func makeTasksFlowCoordinator(navigationController: UINavigationController) -> TasksFlowCoordinator {
        return .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension TasksDIContainer: TasksFlowCoordinatorDependencies {
    func makeLogoutUseCase() -> LogoutUseCase {
        return DefaultLogoutUseCase(repository: authRepository)
    }
    
    func makeCreateTaskUseCase() -> EditTaskUseCase {
        return CreateTaskUseCase(taskRepo: taskManager)
    }
    
    func makeUpdateTaskUseCase() -> EditTaskUseCase {
        return UpdateTaskUseCase(taskRepo: taskManager)
    }

    func makeUpgradeTaskStatusUseCase() -> UpgradeTaskStatusUseCase {
        return DefaultUpgradeTaskStatusUseCase(
            taskStorage: taskManager,
            taskRepo: taskManager
        )
    }
    
    func makeDeleteTaskStatusUseCase() -> DeleteTasksUseCase {
        return DefaultDeleteTasksUseCase(taskRepo: taskManager)
    }
    
    func makeTaskListRepository() -> TaskManagerProtocol {
        return taskManager
    }
}
