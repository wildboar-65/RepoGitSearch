import Foundation

protocol AppViewModel {
    associatedtype Input
    associatedtype Output
    associatedtype Services
    
    func transform(from input: Input) -> Output
}
