import Foundation
import Combine

public protocol PreparedDataTransferCallProxy {
    associatedtype Call: DataTransferResponseRequesting
    typealias Response = Call.Response
    
    typealias TaskPublisher = AnyPublisher<Response, DataTransferError>
    typealias CompletionResult = Result<Response, DataTransferError>
    typealias CompletionHandler = (CompletionResult) -> Void
    
    var service: NetworkService { get }
    var config: NetworkConfig { get }
    var call: Call { get }
}

public extension PreparedDataTransferCallProxy where Call.Response: Decodable {
    @discardableResult
    func perform(completion: @escaping CompletionHandler) -> URLSessionDataTask? {
        call.perform(service: service, config: config, completion: completion)
    }
    
    func publisher() -> TaskPublisher {
        call.publisher(service: service, config: config)
    }
    
    func perform() async throws -> Response {
        try await call.perform(service: service, config: config)
    }
    
    func result() async -> CompletionResult {
        await call.result(service: service, config: config)
    }
}

public extension PreparedDataTransferCallProxy where Call.Response == Void {
    @discardableResult
    func perform(completion: @escaping CompletionHandler) -> URLSessionDataTask? {
        call.perform(service: service, config: config, completion: completion)
    }
    
    func publisher() -> TaskPublisher {
        call.publisher(service: service, config: config)
    }
    
    func perform() async throws {
        try await call.perform(service: service, config: config)
    }
    
    func result() async -> CompletionResult {
        await call.result(service: service, config: config)
    }
}

public struct PreparedDataTransferCall<Call: DataTransferResponseRequesting>: PreparedDataTransferCallProxy {
    public typealias Response = Call.Response
    
    public let service: NetworkService
    public let config: NetworkConfig
    public let call: Call
    
    public init(service: NetworkService, config: NetworkConfig, call: Call) {
        self.service = service
        self.config = config
        self.call = call
    }
}
