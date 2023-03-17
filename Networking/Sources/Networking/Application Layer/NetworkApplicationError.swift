import Foundation

public enum NetworkApplicationError: Error, Equatable {
    case transportFailure(URLError)
    case http(statusCode: Int, data: Data?)
}
