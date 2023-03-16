import Foundation
import Networking
import Domain

public final class LoginCall: DataTransferCall<Void> {
    init(credentials: Credentials) {
        super.init(
            path: .api("auth"),
            method: .post,
            body: credentials.toDTO()
        )
    }
}
