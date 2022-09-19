import Foundation
import RxSwift

enum AppCoordinatorSetting {
    case logged
    case notLogged
    
    init(token: String?){
        switch token?.isEmpty {
        case false:
            self = .logged
        default :
            self = .notLogged
        }
    }
}

final class AppCoordinator {
    
    private unowned let window: UIWindow
    private let setting: AppCoordinatorSetting
    
    init(window: UIWindow, setting: AppCoordinatorSetting) {
        self.window = window
        self.setting = setting
    }
    
    func start() {
        switch setting {
        case .logged:
            openRepoSearch()
        case .notLogged:
            openWelcome()
        }
    }
    
    private func openWelcome() {
        let coodinator = WelcomeCoordinator(window: window)
        coodinator.start()
    }
    
    private func openRepoSearch() {
        let coordinator = RepoSearchCoordinator(window: window)
        coordinator.start()
    }
}
