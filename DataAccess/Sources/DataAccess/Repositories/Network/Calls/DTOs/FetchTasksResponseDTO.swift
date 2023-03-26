import Foundation
import Domain

struct FetchTasksResponseDTO: Codable, ErrorContainingResponse {
    enum CodingKeys: String, CodingKey {
        case details
        case detail
    }
    let details: String?
    let detail: String?
    
    private var tasks: [TodoTask]?
    
    init(from decoder: Decoder) throws {
        do {
            self.tasks = try decoder.singleValueContainer().decode([TodoTask].self)
            self.detail = nil
            self.details = nil
        } catch {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.tasks = nil
            self.details = try container.decodeIfPresent(String.self, forKey: .details)
            self.detail = try container.decodeIfPresent(String.self, forKey: .detail)
        }
    }
    
    func toDomain() throws -> [TodoTask] {
        try requireNoError()
        guard let tasks = tasks else { throw CommunicationError.incompleteResponse(self) }
        return tasks
    }
}
