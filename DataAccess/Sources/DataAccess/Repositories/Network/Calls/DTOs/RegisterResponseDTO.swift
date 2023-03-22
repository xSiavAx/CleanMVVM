import Foundation

struct RegisterResponseDTO: Codable, ErrorContainingResponse, PasswordResponse {
    let details: String?
    let detail: String?
    
    let password: [String]?
    
    func toDomain() throws {
        try requireNoError()
        try requireNoPasswordError()
    }
}
