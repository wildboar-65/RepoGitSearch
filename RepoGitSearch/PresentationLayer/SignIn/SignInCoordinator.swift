import UIKit
import RxRelay

protocol SignInCoordinatorProvider {
    func dismiss()
}

final class SignInCoordinator: SignInCoordinatorProvider {
    private weak var viewController: UIViewController?
       
    init(presented viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func start(signInDoneTrigger: PublishRelay<Bool>) {
        let viewModel = SignInViewModel(services: SignInViewModel.Services(coordinator: self,
                                                                          dataService: UserDefaultDataService(),
                                                                          networking: NetworkService()),
                                        startRequest: OAuthAuthorizationRequest().urlRequest,
                                        signInDoneTrigger: signInDoneTrigger)
        let vc = SignInViewController(viewModel: viewModel)
        let navigationVC = UINavigationController(rootViewController: vc)
        viewController?.present(navigationVC, animated: true, completion: nil)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
