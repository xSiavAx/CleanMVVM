import Foundation
import Networking

public extension NetworkServer {
    private static var host: String { "education.octodev.net" }
    
    static var appDefault: Self {
        return .init(
            scheme: .https,
            host: host
        )
    }
}
