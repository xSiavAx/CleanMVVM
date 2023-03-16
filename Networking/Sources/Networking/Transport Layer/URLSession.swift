import Foundation

public extension URLSession {
    func data(request: URLRequest) async throws -> (data: Data?, response: URLResponse?) {
        if #available(iOS 15.0, *) {
            return try await data(for: request)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                dataTask(with: request) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: (data: data, response: response))
                    }
                }
            }
        }
    }
}

