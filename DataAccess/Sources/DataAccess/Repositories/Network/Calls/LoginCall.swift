import Foundation
import Networking
import Domain

final class LoginCall: DataTransferCall<LoginResponseDTO> {
    init(credentials: Credentials) {
        super.init(
            path: .api("auth"),
            method: .post,
            body: credentials.toDTO()
        )
    }
}
