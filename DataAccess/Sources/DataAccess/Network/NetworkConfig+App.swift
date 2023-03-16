import Foundation
import Networking

public extension NetworkConfig {
    static var appDefault: Self {
        return .init(server: .appDefault)
    }
}
