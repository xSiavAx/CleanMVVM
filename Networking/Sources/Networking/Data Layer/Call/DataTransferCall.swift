import Foundation

public protocol DataTransferResponseRequesting: NetworkRequesting {
    associatedtype Response
    var responseDecoder: DataTransferResponseDecoding { get }
}

open class DataTransferCall<Response>: DataTransferResponseRequesting {
    public typealias Method = DataTransferCallMethod
    
    public let path: String
    public let queries: Encodable?
    public let method: Method
    public let headers: [String: String]
    public let body: Encodable?
    public let cachePolicy: URLRequest.CachePolicy

    public let queryEncoder: DataTransferRequestEncoding
    public let bodyEncoder: DataTransferRequestEncoding
    public let responseDecoder: DataTransferResponseDecoding

    public init(
        path: String,
        queries: Encodable? = nil,
        method: Method,
        headers: [String: String] = .init(),
        body: Encodable? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        queryEncoder: DataTransferRequestEncoding = RequestEncoder(),
        bodyEncoder: DataTransferRequestEncoding = RequestEncoder(),
        responseDecoder: DataTransferResponseDecoding = ResponseDecoder()
    ) {
        self.path = path
        self.queries = queries
        self.method = method
        self.headers = headers
        self.body = body
        self.cachePolicy = cachePolicy
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}
