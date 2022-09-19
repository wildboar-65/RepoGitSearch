import Foundation

struct UserResponse: Decodable {
    let login: String
    let id: Int
    let name: String?
}
