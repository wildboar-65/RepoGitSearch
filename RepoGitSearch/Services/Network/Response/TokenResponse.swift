import Foundation

struct TokenResponse: Decodable {
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decode(String.self, forKey: .accessToken)
    }
    
    init() {
        self.token = ""
    }
}
