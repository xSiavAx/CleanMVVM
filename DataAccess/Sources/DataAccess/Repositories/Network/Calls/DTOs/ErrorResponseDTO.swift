import Foundation

public struct ErrorResponseDTO: Codable, ErrorContainingResponse {
    var details: String?
    var detail: String?
}
