//
//  NetworkManager.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingFailed(Error)
    }
}

extension NetworkManager {
    func fetchItemsAsync<T: Decodable>(
        from urlString: String,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: Data? = nil,
        decoder: JSONDecoder = JSONDecoder() ) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpMethod = method
        request.httpBody = body
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data, response)
            print(String(data: data, encoding: .utf8))
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            let decoded = try decoder.decode(T.self, from: data)
            return decoded
            //return decoded.response.body.items.item

        } catch let decodingError as DecodingError {
            throw NetworkError.decodingFailed(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
