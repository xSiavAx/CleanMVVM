import Foundation
import Common
import Domain

final class TaskListViewModel: ObservableObject, AsyncExecutor, ErrorAlertProcessor {
    @Published
    var errorAlert: ErrorAlertContext?
    
    func start() {
        
    }
}


