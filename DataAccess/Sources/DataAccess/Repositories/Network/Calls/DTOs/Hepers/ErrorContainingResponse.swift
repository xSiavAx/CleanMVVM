import Foundation

enum CommunicationError: Error, CustomStringConvertible {
    case responseError(details: String)
    case incompleteResponse(Any)
    
    var description: String {
        switch self {
        case .responseError(let details): return details
        case .incompleteResponse(_): return "Unexpected server response"
        }
    }
}

protocol ErrorContainingResponse {
    var details: String? { get }
}

extension ErrorContainingResponse {
    func requireNoError() throws {
        try details.map { throw CommunicationError.responseError(details: $0) }
    }
}
