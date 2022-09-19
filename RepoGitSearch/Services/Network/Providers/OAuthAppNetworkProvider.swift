import Foundation
import RxSwift

protocol OAuthAppNetworkProvider {
    func getAccessToken(code: String) -> Observable<TokenResponse>
}
