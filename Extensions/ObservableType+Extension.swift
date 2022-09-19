import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            print("### Driver complete with error - ", error)
            return Driver.empty()
        }
    }
}
