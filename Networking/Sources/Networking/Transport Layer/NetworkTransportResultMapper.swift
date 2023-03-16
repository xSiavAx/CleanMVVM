import Foundation

public class NetworkTransportResultMapper: NetworkResultMapper {
    public typealias FromSuccess = NetworkSessionResponse
    public typealias FromFail = URLError
    public typealias ToSuccess = NetworkTransportResponse
    public typealias ToFail = URLError
    
    public init() {}
    
    public func prepare(_ request: URLRequest) {}
    
    public func map(fail: URLError, for request: URLRequest) -> URLError {
        return fail
    }
    
    public func flatMap(success: NetworkSessionResponse, for request: URLRequest) -> Result<NetworkTransportResponse, URLError> {
        guard let httpResponse = success.response as? HTTPURLResponse else {
            return .failure(.init(.badServerResponse))
        }
        return .success(.init(data: success.data, httpResponse: httpResponse))
    }
}
