import Foundation
import DataAccess
import Networking

final class AppDIContainer {
    private lazy var networkService: NetworkService = {
        let applicationMapper = NetworkApplicationResultMapper(
            acceptableStatusCodes: .init(Array(HTTPURLResponse.successStatusCodes) + [400])
        )
        let sessionManager = NetworkSessionManager()
        let transportLayer = NetworkProxy(mapper: NetworkTransportResultMapper(), service: sessionManager)
        let appLayer = NetworkProxy(mapper: applicationMapper, service: transportLayer)
        
        // Here we can add one more proxy, to for DynatraceEvent
        
        return appLayer
    }()
    private lazy var requestBuilder = PreparedDataTransferCallBuilder(service: networkService, config: .appDefault)
    
    func makeLoginDIContainer() -> LoginDIContainer {
        return .init(requestBuilder: requestBuilder)
    }
    
    func makeTasksDIContainer() -> TasksDIContainer {
        return .init(requestBuilder: requestBuilder)
    }
}
