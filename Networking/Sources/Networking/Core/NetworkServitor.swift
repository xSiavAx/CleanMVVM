import Foundation
import Combine

public protocol NetworkServitor {
    associatedtype Success
    associatedtype Fail: Error
    typealias ResponseResult = Result<Success, Fail>
    
    func request(_ request: URLRequest, completion: @escaping (ResponseResult) -> Void) -> URLSessionDataTask
    func publisher(_ request: URLRequest) -> AnyPublisher<Success, Fail>
    func request(_ request: URLRequest) async throws -> Success
    func result(_ request: URLRequest) async -> Result<Success, Fail>
}

public extension NetworkServitor {
    func proxy<Mapper: NetworkResultMapper>(mapper: Mapper) -> NetworkProxy<Mapper, Self>
    where Mapper.FromFail == Fail, Mapper.FromSuccess == Success {
        return NetworkProxy(mapper: mapper, service: self)
    }
}
