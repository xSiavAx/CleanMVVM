import Foundation

protocol PasswordResponse: ErrorContainingResponse {
    var password: [String]? { get }
}

extension PasswordResponse {
    func requireNoPasswordError() throws {
        try password.map { throw CommunicationError.responseError(details: "Password\n" + $0.joined(separator: "\n")) }
    }
}
