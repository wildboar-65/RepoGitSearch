import Foundation

protocol RequestConfigs {
    var baseURL: URL {get}
}

class APIConfig: RequestConfigs {
    var baseURL: URL = URL(string: "https://api.github.com/")!
}

class AuthConfig: RequestConfigs {
    var baseURL: URL = URL(string: "https://github.com/")!
}

struct APIConfigKeys {
    static let CLIENT_ID = "728ecd924a4c453dae31"
    static let CLIENT_SECRET = "9a3f37e8e1ea6ad6fa2c170f516f1f00f8145550"
    static let REDIRECT_URI = "http://example.com/path"
    static let SCOPE = "read:user,user:email"
}
