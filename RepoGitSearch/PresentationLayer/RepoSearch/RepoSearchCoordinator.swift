import UIKit

protocol RepoSearchCoordinatorProvider: AnyObject {
    func openWelcome()
    func openHistory()
}

final class RepoSearchCoordinator: RepoSearchCoordinatorProvider {
    private unowned let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = RepoSearchViewModel(services: RepoSearchViewModel.Services(coordinator: self,
                                                                                  dataService: UserDefaultDataService(),
                                                                                  netwoking: NetworkService()))
        let rootController = RepoSearchViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: rootController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func openWelcome() {
        let coordinator = WelcomeCoordinator(window: window)
        coordinator.start()
    }
    
    func openHistory() {
         
    }
}
