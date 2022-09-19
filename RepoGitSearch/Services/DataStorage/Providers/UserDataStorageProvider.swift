import Foundation
import RxSwift

protocol UserDataStorageProvider {
    func getUser() -> Observable<UserModel>
    func saveUser(user: UserModel) -> Observable<Void>
    func removeUser() -> Observable<Void>
}
