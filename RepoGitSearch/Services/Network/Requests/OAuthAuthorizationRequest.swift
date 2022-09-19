import Foundation

class OAuthAuthorizationRequest: BaseRequest<EmptyResponse> {
    init() {
        super.init(apiConfig: AuthConfig())
        self.path = "login/oauth/authorize"
        let uuid = UUID().uuidString
        self.queryParams = ["client_id" : APIConfigKeys.CLIENT_ID,
                            "state": uuid]
    }
}
