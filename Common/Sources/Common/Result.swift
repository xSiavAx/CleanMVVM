import Foundation
import Combine

public extension Result {
    func asAnyPublisher() -> AnyPublisher<Success, Failure> {
        switch self {
        case .success(let output):
            return Just(output).setFailureType(to: Failure.self).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func trySuccess() throws -> Success {
        switch self {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func asyncFlatMap<NewSuccess>(
        _ transform: (Success) async -> (Result<NewSuccess, Failure>)
    ) async -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let val):
            return await transform(val)
        case .failure(let error):
            return .failure(error)
        }
    }
}
