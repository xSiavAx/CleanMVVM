import Foundation
import Combine

public struct NetworkSessionResponse {
    public let data: Data?
    public let response: URLResponse?
    
    public init(data: Data?, response: URLResponse?) {
        self.data = data
        self.response = response
    }
    
    public init(_ tuple: (data: Data?, response: URLResponse?)) {
        self.data = tuple.data
        self.response = tuple.response
    }
}

public final class NetworkSessionManager: NetworkServitor {
    public typealias Success = NetworkSessionResponse
    public typealias Fail = URLError
    
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request(
        _ request: URLRequest,
        completion: @escaping (Result<Success, Fail>) -> Void
    ) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.make(with: error)))
            } else {
                completion(.success(.init(data: data, response: response)))
            }
        }
        task.resume()
        
        return task
    }
    
    public func publisher(_ request: URLRequest) -> AnyPublisher<NetworkSessionResponse, Fail> {
        return session.dataTaskPublisher(for: request)
            .map { NetworkSessionResponse(data: $0.data, response: $0.response) }
            .eraseToAnyPublisher()
    }
    
    public func request(_ request: URLRequest) async throws -> NetworkSessionResponse {
        do {
            return .init(try await session.data(request: request))
        } catch {
            throw URLError.make(with: error)
        }
    }
    
    public func result(_ request: URLRequest) async -> Result<NetworkSessionResponse, URLError> {
        do {
            return .success(.init(try await session.data(request: request)))
        } catch {
            return .failure(.make(with: error))
        }
    }
}

fileprivate extension URLError {
    static func make(with error: Error) -> URLError {
        return error as? URLError ?? .init(.unknown)
    }
}
