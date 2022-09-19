import Foundation

class AuthoriseUserRequest: BaseRequest<UserResponse> {
    init(token: String) {
        super.init(apiConfig: APIConfig())
        self.path = "user"
        self.method = .GET
        self.headers = ["Accept" : "application/json",
                        "Authorization" : "Bearer \(token)"]
    }
}
