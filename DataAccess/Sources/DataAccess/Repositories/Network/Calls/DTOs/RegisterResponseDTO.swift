import Foundation

struct RegisterResponseDTO: Codable, ErrorContainingResponse, PasswordResponse {
    var details: String?
    var password: [String]?
    
    func toDomain() throws {
        try requireNoError()
        try requireNoPasswordError()
    }
}
