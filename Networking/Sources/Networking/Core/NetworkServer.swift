import Foundation

public struct NetworkServer: Equatable {
    public enum Scheme: String, Equatable {
        case http
        case https
    }
    
    public let scheme: Scheme
    public let host: String

    public init(scheme: Scheme, host: String) {
        self.scheme = scheme
        self.host = host
    }
}
