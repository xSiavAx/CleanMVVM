import Foundation
import Domain

struct CredentialsDTO: Codable {
    var email: String
    var password: String
}

extension Credentials {
    func toDTO() -> CredentialsDTO {
        return .init(email: email, password: password)
    }
}
