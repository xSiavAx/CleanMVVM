import Foundation
import Networking
import Domain

final class RegisterCall: DataTransferCall<Void> {
    init(credentials: Credentials) {
        super.init(
            path: .api("register"),
            method: .post,
            body: credentials.toDTO()
        )
    }
}
