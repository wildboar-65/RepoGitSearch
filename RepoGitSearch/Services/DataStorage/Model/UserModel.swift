import Foundation

struct UserModel: Codable {
    let nickName: String
    let name: String
    let id: Int
    
    init(from model: UserResponse) {
        self.nickName = model.login
        self.id = model.id
        self.name = model.name ?? "no name"
    }
}
