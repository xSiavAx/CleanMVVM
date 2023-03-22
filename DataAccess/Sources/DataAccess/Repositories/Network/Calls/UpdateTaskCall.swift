import Foundation
import Networking
import Domain

final class UpdateTaskCall: DataTransferCall<ErrorResponseDTO> {
    init(token: String, task: TodoTask) {
        super.init(
            path: .api("task/update"),
            method: .post,
            headers: .authorization(token),
            body: task
        )
    }
}
