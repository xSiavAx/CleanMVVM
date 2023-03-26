import Foundation
import Networking
import Domain

final class DeleteTaskCall: DataTransferCall<ErrorResponseDTO> {
    init(token: String, id: TodoTask.ID) {
        super.init(
            path: .api("task/delete"),
            method: .post,
            headers: .authorization(token),
            body: IDRequestDTO(id: id)
        )
    }
}
