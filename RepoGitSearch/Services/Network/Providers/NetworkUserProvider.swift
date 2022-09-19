import Foundation
import RxSwift

protocol NetworkUserProvider {
    func getUser(accessToken: String) -> Observable<UserResponse>
    func deleteUser(accessToken: String) -> Observable<EmptyResponse>
}
