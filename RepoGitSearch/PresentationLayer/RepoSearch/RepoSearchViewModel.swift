import Foundation
import RxSwift
import RxCocoa
import WebKit

typealias RepoSearchDataService = UserDataStorageProvider & TokenDataStorageProvider & ReposDataStorageProvider
typealias RepoSearchNetworkService = NetworkUserProvider & NetworkRepositoriesProvider

final class RepoSearchViewModel: AppViewModel {
    struct Input {
        let viewWillApear: Driver<Void>
        let logoutTap: Driver<Void>
        let openHistoryTap: Driver<Void>
        let searchText: Driver<String>
        let searchTap: Driver<Void>
        let loadNextTrigger: Driver<Void>
    }
    
    struct Output {
        let loadUser: Driver<UserInfoViewModel>
        let logout: Driver<Void>
        let emptyResults: Driver<Bool>
        let openHistory: Driver<Void>
        let errorHandle: Driver<Error>
        let reposResults: Driver<[RepoCellViewModel]>
    }
    
    struct Services {
        let coordinator: RepoSearchCoordinatorProvider
        let dataService: RepoSearchDataService
        let netwoking: RepoSearchNetworkService
    }
    
    private let services: Services
    
    init(services: Services) {
        self.services = services
    }
    
    func transform(from input: Input) -> Output {
        let errorHandle = ErrorHandle()
        let activity = ActivityIndicator()
        let pageDriver = Driver.just(0)
        let loadUser = input.viewWillApear
            .flatMapLatest { [unowned self] _ in
                return self.services.dataService.getUser()
                    .trackError(errorHandle)
                    .asDriverOnErrorJustComplete()
            }.map { user in
                return UserInfoViewModel(userNickName: user.nickName)
            }
        
        let openedReposIds = input.viewWillApear.flatMapLatest { [unowned self] _ in
            return self.services.dataService.getOpenedRepoIds()
                .trackActivity(activity)
                .asDriver(onErrorJustReturn: [])
        }
        
        let startSearch = input.searchTap.withLatestFrom(input.searchText)
        
        let combineSearch = Driver.combineLatest(startSearch, pageDriver)
        
        let loadRepos = combineSearch
            .filter({ searchtext, page in
                return !searchtext.isEmpty
            })
            .flatMapLatest { [unowned self] query, page in
            return self.services.netwoking.getSearchRepos(query: query, page: 1)
                .trackActivity(activity)
                .trackError(errorHandle)
                .asDriverOnErrorJustComplete()
            }.map({$0.items})

        let emptyResults = Driver.combineLatest(loadRepos.map({$0.isEmpty}), startSearch.map({$0.isEmpty}))
            .map { (isNoRepos, isClearText) in
                return isNoRepos || isClearText
            }
        
        let reposViewModel = Driver.combineLatest(loadRepos, openedReposIds)
            .filter { (repos, ids) in
                return !repos.isEmpty
            }.map { repos, ids in
                return repos.map({RepoCellViewModel(from: $0, ids: ids)})
            }
        
        let logoutProcess = input.logoutTap
            .flatMapLatest { [unowned self] _ in
                return self.services.dataService.getToken()
                    .asDriverOnErrorJustComplete()
            }.compactMap({$0})
            .flatMapLatest { [unowned self] token in
                return self.services.netwoking.deleteUser(accessToken: token)
                    .trackActivity(activity)
                    .trackError(errorHandle)
                    .asDriverOnErrorJustComplete()
            }
        
        let removeToken = logoutProcess.flatMapLatest({ [unowned self] _  in
             return self.services.dataService.removeToken()
                .asDriverOnErrorJustComplete()
        })
        
        let removeUser = logoutProcess.flatMapLatest({ [unowned self] _  in
             return self.services.dataService.removeUser()
                .asDriverOnErrorJustComplete()
        })
        
        let collection = [removeUser, removeToken]
        let logout = Driver.merge(collection)
            .skip(collection.count - 1)
            .do(onNext:{
                self.services.coordinator.openWelcome()
            })

        let openHistory = input.openHistoryTap
                .do(onNext: {
                    self.services.coordinator.openHistory()
                })
                    
            
                    
        return Output(loadUser: loadUser,
                      logout: logout,
                      emptyResults: emptyResults,
                      openHistory: openHistory,
                      errorHandle: errorHandle.asDriver(),
                      reposResults: reposViewModel)
    }
}

struct UserInfoViewModel {
    let userNickName: String
}

struct RepoCellViewModel {
    let id: Int
    let name: String
    let description: String
    let stars: Int
    let htmlUrl: String
    let language: String?
    let isOpened: Bool

    init(from response: RepoResponse, ids: [String]) {
        self.id = response.id
        self.name = response.name
        self.description = response.description ?? ""
        self.stars = response.stars
        self.htmlUrl = response.htmlUrl
        self.language = response.language
        self.isOpened = ids.contains("\(response.id)")
    }
}
