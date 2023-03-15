import Foundation
import Common

protocol ErrorAlertProcessor: AnyObject {
    var errorAlert: ErrorAlertContext? { get set }
}

extension ErrorAlertProcessor {
    @MainActor
    func processAlert(error: Error, retry: @escaping () -> Void) {
        errorAlert = .init(details: "\(error)", retryAction: retry)
    }
}

extension AsyncExecutor where Self: ErrorAlertProcessor {
    func runTask(_ task: @escaping () async throws -> Void) {
        Task { [weak self] in
            do {
                try await task()
            } catch {
                await self?.processAlert(error: error) {
                    self?.runTask(task)
                }
            }
        }
    }
}
