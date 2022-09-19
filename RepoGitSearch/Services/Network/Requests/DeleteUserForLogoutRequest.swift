import Foundation

class DeleteUserForLogoutRequest: BaseRequest<EmptyResponse> {
    init(token: String) {
        super.init(apiConfig: APIConfig())
        let username = APIConfigKeys.CLIENT_ID
        let password = APIConfigKeys.CLIENT_SECRET
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        self.path = "applications/\(APIConfigKeys.CLIENT_ID)/grant"
        self.method = .DELETE
        self.headers = ["Authorization": "Basic \(base64LoginString)"]
        self.body = ["access_token" : token]
    }
}
