import Foundation
import Combine

public protocol NetworkProxing: AnyObject, NetworkServitor
where ResponseResult == Mapper.ToResponse,
      Service.ResponseResult == Mapper.FromResponse {
    associatedtype Mapper: NetworkResultMapper
    associatedtype Service: NetworkServitor
    
    var mapper: Mapper { get }
    var service: Service { get }
}

public extension NetworkProxing {
    func request(_ request: URLRequest, completion: @escaping (ResponseResult) -> Void) -> URLSessionDataTask {
        mapper.prepare(request)
        return service.request(request) { [weak self] in
            if let welf = self {
                completion(welf.mapper.map($0, for: request))
            }
        }
    }
    
    func publisher(_ request: URLRequest) -> AnyPublisher<Success, Fail> {
        mapper.prepare(request)
        return service
            .publisher(request)
            .flatMap(mapper, for: request)
    }
    
    func request(_ request: URLRequest) async throws -> Success {
        do {
            let result = try await service.request(request)
            
            return try mapper.flatMap(success: result, for: request).trySuccess()
        } catch {
            if let serviceError = error as? Service.Fail {
                throw mapper.map(fail: serviceError, for: request)
            }
            throw error
        }
    }
    
    func result(_ request: URLRequest) async -> Result<Success, Fail> {
        return mapper.map(await service.result(request), for: request)
    }
}

open class NetworkProxy<Mapper: NetworkResultMapper, Service: NetworkServitor> : NetworkProxing
where Service.Success == Mapper.FromSuccess, Service.Fail == Mapper.FromFail {
    public typealias Success = Mapper.ToSuccess
    public typealias Fail = Mapper.ToFail
    
    public let mapper: Mapper
    public let service: Service
    
    public init(mapper: Mapper, service: Service) {
        self.mapper = mapper
        self.service = service
    }
}
