import Foundation

extension URL {
    mutating func withQueries(queries: [String: String]){
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {return}
        components.queryItems = queries.map({ URLQueryItem(name: $0, value: $1)})
        guard let url = components.url else {
            print("URL ERROR: - parameters cound not be added")
            return
        }
        self = url
    }
}
