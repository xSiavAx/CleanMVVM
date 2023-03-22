import Foundation
import Networking
import Domain

final class FetchTasksCall: DataTransferCall<FetchTasksResponseDTO> {
    init(token: String) {
        super.init(
            path: .api("task/all"),
            method: .get,
            headers: .authorization(token)
        )
    }
}
