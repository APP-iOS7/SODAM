//
//  NetworkManager.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//
//  네트워크 통신 모듈

import Foundation

final class NetworkManager {
    // 싱글톤으로 설계
    static let shared = NetworkManager()
    private init() {}

    // 네트워크 통신을 하며 발생할 수 있는 오류 정의
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingFailed(Error)
    }
}

extension NetworkManager {
    
    /** 비동기 네트워크 요청을 통해 데이터를 가져오고 디코딩합니다.
     * - Parameters:
     *      - urlString: 요청을 보낼 URL 문자열
     *      - method: HTTP 요청 메서드 (기본값은 "GET")
     *      - headers: 요청에 사용할 HTTP 헤더 (선택 사항)
     *      - body: 요청에 포함할 HTTP 바디 데이터 (선택 사항)
     *      - decoder: 응답 데이터를 디코딩할 `JSONDecoder` (기본값은 `JSONDecoder()`)
     * - Returns: 디코딩된 제네릭 타입 `T`의 객체
     * - Throws: NetworkError  (네트워크 또는 디코딩 오류)
     * - Note:
     * 관광사진갤러리 키워드 검색 API와 같은 RESTful API 호출에 사용할 수 있으며,
     *  응답 데이터를 제네릭 타입으로 디코딩하여 재사용성을 높였습니다.
     *  keyword는 URL 인코딩 후 전달해야 합니다.
     */
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
            
            // MARK: 네트워크 응답 데이터를 보려면 아래 주석을 풀어주세요.
            // print(data, response)
            // print(String(data: data, encoding: .utf8))
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            let decoded = try decoder.decode(T.self, from: data)
            return decoded

        } catch let decodingError as DecodingError {
            throw NetworkError.decodingFailed(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
