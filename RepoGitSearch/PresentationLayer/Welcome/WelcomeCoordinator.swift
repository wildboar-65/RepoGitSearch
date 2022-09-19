import UIKit
import RxCocoa

protocol WelcomeCoordinatorProvider: AnyObject {
    func openGitSignIn(signInFinishTrigger: PublishRelay<Bool>)
    func openSearch()
}

final class WelcomeCoordinator: WelcomeCoordinatorProvider {
    
    private unowned let window: UIWindow
    private weak var rootViewController: UIViewController?
       
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        print("Welcome start")
        let viewModel = WelcomeViewModel(services: WelcomeViewModel.Services(coordinator: self,
                                                                            dataManager: UserDefaultDataService(),
                                                                            networking: NetworkService()))
        let vc = WelcomeViewController(viewModel: viewModel)
        rootViewController = vc
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func openGitSignIn(signInFinishTrigger: PublishRelay<Bool>) {
         let coordinator = SignInCoordinator(presented: rootViewController)
        coordinator.start(signInDoneTrigger: signInFinishTrigger)
    }
    
    func openSearch() {
        let coordinator = RepoSearchCoordinator(window: window)
        coordinator.start()
    }
}
