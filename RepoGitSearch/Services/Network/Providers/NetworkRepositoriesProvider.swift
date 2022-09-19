import Foundation
import RxSwift

protocol NetworkRepositoriesProvider {
    func getSearchRepos(query: String, page: Int) -> Observable<ReposSearchResponse>
}
