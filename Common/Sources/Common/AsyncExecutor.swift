import Foundation

public protocol AsyncExecutor {}

extension AsyncExecutor {
    public func runTask(_ task: @escaping () async -> Void) {
        Task { await task() }
    }
}
