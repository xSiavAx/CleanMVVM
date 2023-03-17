import Foundation

protocol DimmingProcessor: AnyObject {
    var isDimmed: Bool { get set }
}

extension DimmingProcessor {
    @MainActor
    func withDimming<T>(_ task: () async throws -> T ) async rethrows -> T {
        isDimmed = true
        defer { isDimmed = false }
        return try await task()
    }
}
