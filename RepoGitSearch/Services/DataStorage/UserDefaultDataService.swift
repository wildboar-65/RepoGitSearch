import Foundation
import RxSwift

typealias UserDefaultDataServiceProvider = TokenDataStorageProvider &
                                           UserDataStorageProvider &
                                            ReposDataStorageProvider

final class UserDefaultDataService: UserDefaultDataServiceProvider {

    
    
    private struct Keys {
        static let isUserLogged = "isUserLogged"
        static let token = "token"
        static let userModel = "userModel"
        static let openedRepos = "openedRepos"
    }
    
    func getOpenedRepoIds() -> Observable<[String]> {
        UserDefaults.standard.rx.observe([String].self, Keys.openedRepos).compactMap { array in
            guard let array = array else {
                return []
            }
            return array
        }
    }
    
    func addOpenedRepoId(id: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            var array = UserDefaults.standard.stringArray(forKey: Keys.openedRepos) ?? []
            array.append(id)
            UserDefaults.standard.set(array, forKey: Keys.openedRepos)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func removeOpenedRepoId() -> Observable<Void> {
        return Observable<Void>.create { observer in
            UserDefaults.standard.removeObject(forKey: Keys.openedRepos)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getUser() -> Observable<UserModel> {
        UserDefaults.standard.rx.observe(Data.self, Keys.userModel)
            .compactMap { data in
                if let data = data {
                    return try JSONDecoder().decode(UserModel.self, from: data)
                } else {
                    throw RxError.noElements
                }
            }
    }
    
    func saveUser(user: UserModel) -> Observable<Void> {
        return Observable<Void>.create { observer in
            let data = try? JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: Keys.userModel)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func removeUser() -> Observable<Void> {
        return Observable<Void>.create { observer in
            print("REMOVE removeUser")
            UserDefaults.standard.removeObject(forKey: Keys.userModel)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getToken() -> Observable<String?> {
        UserDefaults.standard.rx.observe(String.self, Keys.token)
    }
    
    func saveToken(token: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            UserDefaults.standard.set(token, forKey: Keys.token)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func removeToken() -> Observable<Void> {
        return Observable<Void>.create { observer in
            print("REMOVE TOKEN")
            UserDefaults.standard.removeObject(forKey: Keys.token)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
