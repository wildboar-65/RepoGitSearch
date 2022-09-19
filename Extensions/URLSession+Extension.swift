import Foundation
import RxSwift
import RxCocoa

enum TestError: Swift.Error {
    case test
}

extension TestError {
    var description: String {
        switch self {
        case .test:
            return "Ful shit"
        }
    }
}

extension URLSession {
    static func dataTast<T : Decodable>(request: BaseRequest<T>) -> Observable<T?> {
        return Observable.just(request.urlRequest)
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T? in
                if 200..<300 ~= response.statusCode {
                    print("Data task success", response.statusCode)
                    guard let final = try? JSONDecoder().decode(T.self, from: data) else {
                        print("Empty response")
                        throw TestError.test
                    }
                    return final
                } else {
                    print("Data task fail", response.statusCode)
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }
}
