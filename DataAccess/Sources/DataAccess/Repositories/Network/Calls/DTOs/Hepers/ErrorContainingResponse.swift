import Foundation

enum CommunicationError: Error, CustomStringConvertible {
    case responseError(details: String)
    case incompleteResponse(Any)
    case unauthorized
    
    var description: String {
        switch self {
        case .responseError(let details): return details
        case .incompleteResponse(_): return "Unexpected server response"
        case .unauthorized: return "Unauthorized"
        }
    }
}

protocol ErrorContainingResponse {
    var details: String? { get }
    var detail: String? { get }
}

extension ErrorContainingResponse {
    func requireNoError() throws {
        try details.map { throw CommunicationError.responseError(details: $0) }
        try detail.map  { throw CommunicationError.responseError(details: $0) }
    }
}
