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
    private lazy var taskListRepository = RamTasksListRepository(dataSource: tasksRepository)
    
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
    
    func makeTaskListRepository() -> TaskListRepository {
        return taskListRepository
    }
}
