import Foundation
import RxSwift

extension String {
    static func parseCode(request: URLRequest) -> Observable<String> {
        return Observable<String>.create { observable in
            let requestURLString = (request.url?.absoluteString)! as String
            if requestURLString.hasPrefix(APIConfigKeys.REDIRECT_URI) {
                if requestURLString.contains("code=") {
                    if let range = requestURLString.range(of: "=") {
                        let githubCode = requestURLString[range.upperBound...]
                        if let range = githubCode.range(of: "&state=") {
                            let code = String(githubCode[..<range.lowerBound])
                            observable.onNext(code)
                            observable.onCompleted()
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}
