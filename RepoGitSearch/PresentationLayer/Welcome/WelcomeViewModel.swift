import Foundation
import RxSwift
import RxCocoa

final class WelcomeViewModel: AppViewModel {
    struct Input {
        let signInTap: Driver<Void>
    }
    
    struct Output {
        let signInStart: Driver<Void>
        let signUpDone: Driver<Void>
        let errorHandle: Driver<Error>
    }
    
    struct Services {
        let coordinator: WelcomeCoordinatorProvider
        let dataManager: UserDefaultDataServiceProvider
        let networking: NetworkUserProvider
    }
    
    private let services: Services
    
    init(services: Services) {
        self.services = services
    }
    
    func transform(from input: Input) -> Output {
        let signInFinishTrigger = PublishRelay<Bool>()
        let errorHandle = ErrorHandle()
        let acivityIndicator = ActivityIndicator()
        let signInStart = input.signInTap
            .do(onNext: { [unowned self] _ in
                self.services.coordinator.openGitSignIn(signInFinishTrigger: signInFinishTrigger)
            })
        
        let signUpDone = signInFinishTrigger.asObservable()
                            .filter({$0 == true})
                            .map({ _ -> Void in})
                            .asDriverOnErrorJustComplete()
                

        let tokenDriver = signUpDone.flatMapLatest { [unowned self] in
            return self.services.dataManager.getToken()
                .trackError(errorHandle)
                .asDriverOnErrorJustComplete()
        }
                
        let getUser = tokenDriver.flatMapLatest { [unowned self]  token in
            return self.services.networking.getUser(accessToken: token ?? "")
                .trackActivity(acivityIndicator)
                .trackError(errorHandle)
                .asDriverOnErrorJustComplete()
        }
                
        let saveUser = getUser.flatMapLatest { [unowned self] user in
            return self.services.dataManager.saveUser(user: UserModel(from: user))
                        .trackError(errorHandle)
                        .asDriverOnErrorJustComplete()
        }
                
        let searchStart = saveUser.do(onNext: { [unowned self] userResponse in
            return self.services.coordinator.openSearch()
        }).map({_ in})
            
        return Output(signInStart: signInStart,
                      signUpDone: searchStart,
                      errorHandle: errorHandle.asDriver())
    }
}
