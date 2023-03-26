import Foundation

public struct TodoTask: Hashable, Codable, Identifiable {
    public enum Status: String, Codable {
        case todo = "to do"
        case inProgress = "in progress"
        case done = "done"
    }
    
    public let id: Int
    public let title: String
    public let content: String
    public var status: Status
    
    public init(id: Int, title: String, content: String, status: TodoTask.Status) {
        self.id = id
        self.title = title
        self.content = content
        self.status = status
    }
}
