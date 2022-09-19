import Foundation

class ReposRequest: BaseRequest<ReposSearchResponse> {
    init(query: String, page: Int) {
        super.init(apiConfig: APIConfig())
        self.path = "search/repositories"
        self.method = .GET
        self.headers = ["Accept": "application/vnd.github+json"]
        self.queryParams = ["q" : query,
                            "sort": "stars",
                            "per_page": "15",
                            "page" : "\(page)"]
    }
}
