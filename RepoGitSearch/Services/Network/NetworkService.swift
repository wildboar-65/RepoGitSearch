import Foundation
import RxSwift

typealias AppNetworkProvider = OAuthAppNetworkProvider & NetworkUserProvider & NetworkRepositoriesProvider

final class NetworkService: AppNetworkProvider {
    func getSearchRepos(query: String, page: Int) -> Observable<ReposSearchResponse> {
        let request = ReposRequest(query: query, page: page)
        return URLSession.dataTast(request: request).compactMap({$0})
    }
    
    func deleteUser(accessToken: String) -> Observable<EmptyResponse> {
        let request = DeleteUserForLogoutRequest(token: accessToken)
        return URLSession.dataTast(request: request).compactMap({$0})
    }
    
    func getUser(accessToken: String) -> Observable<UserResponse> {
        let request = AuthoriseUserRequest(token: accessToken)
        return URLSession.dataTast(request: request).compactMap({$0})
    }
    
    func getAccessToken(code: String) -> Observable<TokenResponse> {
        let request = OAuthAccessTokenRequest(code: code)
        return URLSession.dataTast(request: request).compactMap({$0})
    }
}
