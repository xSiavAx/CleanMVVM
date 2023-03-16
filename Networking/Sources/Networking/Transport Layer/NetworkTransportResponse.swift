import Foundation

public struct NetworkTransportResponse: Equatable {
    let data: Data?
    let httpResponse: HTTPURLResponse
}
