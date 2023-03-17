import Foundation
import Combine

public protocol NetworkService {
    typealias TaskPublisher = AnyPublisher<Data?, NetworkApplicationError>
    typealias CompletionResult = Result<Data?, NetworkApplicationError>
    typealias CompletionHandler = (CompletionResult) -> Void
    
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> URLSessionDataTask
    
    func publisher(_ request: URLRequest) -> TaskPublisher
    
    func request(_ request: URLRequest) async throws -> Data?
    
    func result(_ request: URLRequest) async -> CompletionResult
}

extension NetworkProxy: NetworkService where Success == Data?, Fail == NetworkApplicationError {}
