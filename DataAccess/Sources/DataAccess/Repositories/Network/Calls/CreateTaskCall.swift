import Foundation
import Networking
import Domain

final class CreateTaskCall: DataTransferCall<ErrorResponseDTO> {
    init(token: String, task: TodoTask) {
        super.init(
            path: .api("task"),
            method: .post,
            headers: .authorization(token),
            body: task.toCreateDTO()
        )
    }
}
