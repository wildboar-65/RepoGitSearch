import Foundation

struct ReposSearchResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepoResponse]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decode(Int.self, forKey: .totalCount)
        incompleteResults = try values.decode(Bool.self, forKey: .incompleteResults)
        items = try values.decode([RepoResponse].self, forKey: .items)
    }
}

struct RepoResponse: Decodable {
    let id: Int
    let name: String
    let description: String?
    let stars: Int
    let htmlUrl: String
    let language: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case stars = "stargazers_count"
        case htmlUrl = "html_url"
        case language = "language"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try? values.decode(String.self, forKey: .description) 
        stars = try values.decode(Int.self, forKey: .stars)
        htmlUrl = try values.decode(String.self, forKey: .htmlUrl)
        language = try? values.decode(String.self, forKey: .language)
    }
}

