import Foundation

struct LoginResponseDTO: Codable, ErrorContainingResponse, PasswordResponse {
    let details: String?
    let detail: String?
    
    let password: [String]?
    
    private let token: String?
    
    func toDomain() throws -> String {
        try requireNoError()
        try requireNoPasswordError()
        guard let token = token else { throw CommunicationError.incompleteResponse(self) }
        return token
    }
}
