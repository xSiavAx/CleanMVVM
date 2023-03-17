import Foundation

extension String {
    fileprivate static let authorizationKey = "Authorization"
    fileprivate static let apiVersion = "v1"
    fileprivate static let apiPathPrefix = "/api/\(apiVersion)/"
    fileprivate static let authKeyPrefix = "Bearer "
    
    static func api(_ suffix: String) -> Self {
        return apiPathPrefix + suffix
    }
}

extension Dictionary where Key == String, Value == String {
    static func authorization(_ val: String) -> Self {
        return .init().adding(authorization: val)
    }
    
    func adding(authorization: String) -> Self {
        var result = self
        return result.add(authorization: authorization)
    }
    
    @discardableResult
    mutating func add(authorization: String) -> Self {
        self[.authorizationKey] = .authKeyPrefix + authorization
        return self
    }
}
