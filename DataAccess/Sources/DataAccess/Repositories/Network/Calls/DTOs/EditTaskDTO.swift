import Foundation
import Domain

struct EditTaskDTO: Codable {
    var id: Int?
    var title: String
    var content: String
    var status: String
    var deadline: String
}

extension TodoTask {
    func toCreateDTO() -> EditTaskDTO {
        return .init(
            title: title,
            content: content,
            status: status.rawValue,
            deadline: "2025-03-15 00:00:00"
        )
    }
    
    func toUpdateDTO() -> EditTaskDTO {
        return .init(
            id: id,
            title: title,
            content: content,
            status: status.rawValue,
            deadline: "2025-03-15 00:00:00"
        )
    }
}
