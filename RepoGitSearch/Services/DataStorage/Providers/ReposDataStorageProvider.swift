import Foundation
import RxSwift

protocol ReposDataStorageProvider {
    func getOpenedRepoIds() -> Observable<[String]>
    func addOpenedRepoId(id: String) -> Observable<Void>
    func removeOpenedRepoId() -> Observable<Void>
}
