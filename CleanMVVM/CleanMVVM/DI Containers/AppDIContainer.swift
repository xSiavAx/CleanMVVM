import Foundation
import DataAccess
import Networking

final class AppDIContainer {
    private lazy var networkService: NetworkService = {
        let sessionManager = NetworkSessionManager()
        let transportLayer = NetworkProxy(mapper: NetworkTransportResultMapper(), service: sessionManager)
        let appLayer = NetworkProxy(mapper: NetworkApplicationResultMapper(), service: transportLayer)
        
        return appLayer
    }()
    private lazy var requestBuilder = PreparedDataTransferCallBuilder(service: networkService, config: .appDefault)
    
    func makeLoginDIContainer() -> LoginDIContainer {
        return LoginDIContainer(requestBuilder: requestBuilder)
    }
}
