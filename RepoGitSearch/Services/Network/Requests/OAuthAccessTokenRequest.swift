import Foundation

class OAuthAccessTokenRequest: BaseRequest<TokenResponse> {
    init(code: String) {
        super.init(apiConfig: AuthConfig())
        self.path = "login/oauth/access_token"
        self.method = .POST
        self.bodyTypeEncoding = .stringUtf8
        self.headers = ["Accept" : "application/json"]
        self.body = ["client_id" : APIConfigKeys.CLIENT_ID,
                            "client_secret": APIConfigKeys.CLIENT_SECRET,
                            "code": code]
    }
}
