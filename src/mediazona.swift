import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public class Mediazona{
    private let api_shares = "https://zona.media/_shares"
    private let api = "https://zona.media/api"
    private let api_r200 = "https://s3.zona.media"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"*/*",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    public func get_shares(url: String) async throws -> Any {
        let urlString = "\(api)?url=\(url)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func get_infographics() async throws -> Any {
        let urlString = "\(api_r200)/infographics/g200w/urls.json.gz?cachebuster=cae8add5"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func search(q: String,limit: Int = 12,page: Int = 0,sort: String = "sort") async throws -> Any {
        var components = URLComponents(string: "\(api)/search")
        var queryItems = [
        URLQueryItem(name: "q", value: q),
        URLQueryItem(name: "size", value: String(limit)),
        URLQueryItem(name: "page", value: String(page)),
        URLQueryItem(name: "sort", value: sort)
        ]
        components?.queryItems = queryItems
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
}
