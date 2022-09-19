import Foundation
import RxSwift

protocol TokenDataStorageProvider {
    func getToken() -> Observable<String?>
    func saveToken(token: String) -> Observable<Void>
    func removeToken() -> Observable<Void>
}
