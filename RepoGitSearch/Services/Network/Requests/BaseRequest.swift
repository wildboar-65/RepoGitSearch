import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case DELETE = "DELETE"
    case POST = "POST"
}

protocol Requestable {
    var apiConfig: RequestConfigs {get}
    var method: HTTPMethod {get}
    var path: String {get}
    var pathParams: [String : Any] {get}
    var queryParams: [String : String] {get}
    var body: [String : Any?] {get}
    var headers: [String : String] {get}
}

enum BodyTypeEncoding {
    case stringUtf8
    case json
}

typealias Resposable = Decodable
class BaseRequest<T: Resposable>: Requestable {
    let apiConfig: RequestConfigs
    var method = HTTPMethod.GET
    var path = ""
    var pathParams = [String : Any]()
    var queryParams = [String : String]()
    var body = [String : Any?]()
    var headers = [String : String]()
    var bodyTypeEncoding: BodyTypeEncoding = .json
    
    init(apiConfig: RequestConfigs = APIConfig()) {
        self.apiConfig = apiConfig
    }
}

extension BaseRequest {
    var urlRequest: URLRequest {
        var url = apiConfig.baseURL
        url.appendPathComponent(path)
        if !queryParams.isEmpty {
            url.withQueries(queries: queryParams)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = dataBody
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    var dataBody: Data? {
        switch bodyTypeEncoding {
        case .json:
            return body.isEmpty ? nil : try? JSONSerialization.data(withJSONObject: body)
        case .stringUtf8:
            guard !body.isEmpty else {return nil}
            let string = body.map{"\($0.0)=\($0.1 ?? "null")"}.joined(separator: "&")
            return string.data(using: String.Encoding.utf8)
        }
    }
}
