import Foundation
import RxSwift
import RxCocoa
import WebKit

final class SignInViewModel: AppViewModel {
    struct Input {
        let viewWillApear: Driver<Void>
        let changeAccountTap: Driver<Void>
        let webViewNavigation: Driver<URLRequest>
        let dismissTap: Driver<Void>
    }
    
    struct Output {
        let startPageLoad: Driver<URLRequest>
        let signInFinish: Driver<Void>
        let signInWithAnotherAccout: Driver<Void>
        let errorHandle: Driver<Error>
        let dismiss: Driver<Void>
    }
    
    struct Services {
        let coordinator: SignInCoordinatorProvider
        let dataService: TokenDataStorageProvider
        let networking: OAuthAppNetworkProvider
    }
    
    private let services: Services
    private let startRequest: URLRequest
    private unowned let signInDoneTrigger: PublishRelay<Bool>
    
    init(services: Services, startRequest: URLRequest, signInDoneTrigger: PublishRelay<Bool>) {
        self.services = services
        self.signInDoneTrigger = signInDoneTrigger
        self.startRequest = startRequest
    }
    
    func transform(from input: Input) -> Output {
        let errorhandle = ErrorHandle()
        let startPageLoad = input.viewWillApear
            .flatMapLatest { [unowned self] () -> Driver<URLRequest> in
            return Driver.just(startRequest)
        }
        
        let parseCode = input.webViewNavigation
            .filter({ request in
                let stringURL = request.url?.absoluteString ?? ""
                return stringURL.contains(APIConfigKeys.REDIRECT_URI)
            })
            .flatMapLatest { request -> Driver<String> in
                return String.parseCode(request: request)
                        .filter({!$0.isEmpty})
                        .asDriverOnErrorJustComplete()
            }
        
        let getToken = parseCode.flatMapLatest { [unowned self]  code in
            return self.services.networking.getAccessToken(code: code)
                    .trackError(errorhandle)
                    .asDriverOnErrorJustComplete()
        }
        
        let saveToken = getToken.flatMapLatest { [unowned self] token in
            return self.services.dataService.saveToken(token: token.token)
                    .trackError(errorhandle)
                    .asDriverOnErrorJustComplete()
        }
        
        let signInFinish = saveToken.do(onNext: { [unowned self] in
            self.signInDoneTrigger.accept(true)
            self.services.coordinator.dismiss()
        })
        
        let signInWithAnotherAccout = input.changeAccountTap.do(onNext: {
            WKWebView.clean()
        })
        
        let dismiss = input.dismissTap.do(onNext: services.coordinator.dismiss)
        
        return Output(startPageLoad: startPageLoad,
                       signInFinish: signInFinish,
                       signInWithAnotherAccout: signInWithAnotherAccout,
                       errorHandle: errorhandle.asDriver(),
                       dismiss: dismiss)
    }
}
