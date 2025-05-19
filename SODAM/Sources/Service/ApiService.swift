//
//  APIService.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//
import Foundation

final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    
    /** 초등교육콘텐츠 목록 조회
     * - Returns: 카테고리별로 묶인 이야기 목록
     */
    func loadJSONData() -> [[DetailModel]]? {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(StoryResponse.self, from: data)
            let items = response.response.body.items.item
            
            // category가 nil이거나 빈 문자열이 아닌 경우만 필터링
            let filteredItems = items.filter {
                if let category = $0.category {
                    return !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                return false
            }
            
            // category 기준으로 그룹핑
            let grouped = Dictionary(grouping: filteredItems, by: { $0.category! })
            
            // category 오름차순 정렬 후 배열화
            let sortedGroups = grouped
                .sorted { $0.key < $1.key }
                .map { $0.value }
            
            return sortedGroups
        } catch {
            print("JSON 로딩 또는 디코딩 중 오류 발생: \(error)")
            return nil
        }
    }
    
    
    /** 관광지 기본 정보 목록 조회
     * - Parameters:
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     * - Returns: 관광지 목록
     */
    func getThemeBasedList(numOfRows: Int, pageNo: Int) async throws -> [DetailModel] {
        guard let urlString = buildThemeURL(path: APIConfig.apiUrl.themeBasedList, numOfRows: numOfRows, pageNo: pageNo) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let storyResponse: StoryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = storyResponse.response.body.items.item
        
        return items
    }
    
    /** 관광지 키워드 검색 목록 조회
     * - Parameters:
     *      - keyword: 검색할 키워드
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     * - Returns: 관광지 목록
     */
    func getThemeSearchList(keyword: String, numOfRows: Int, pageNo: Int) async throws -> [DetailModel] {
        // URL 빌드
        guard let urlString = buildThemeURL(path: APIConfig.apiUrl.themeSearchList, keyword: keyword, numOfRows: numOfRows, pageNo: pageNo) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let storyResponse: StoryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = storyResponse.response.body.items.item
        return items
    }
    
    
    /** 관광지 위치기반 정보 목록 조회
     * - Parameters:
     *      - lng: 경도 - GPS X좌표(WGS84 경도 좌표) ex) 126.615455
     *      - lat: 위도 - GPS Y좌표(WGS84 위도 좌표) ex) 34.476566
     *      - radius: 거리 반경 : 거리 반경(단위:m) ,Max값 20000m=20Km
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     * - Returns: 관광지 목록
     */
    func getThemeLocationBasedList(lng: Double, lat: Double, radius: Int, numOfRows: Int, pageNo: Int) async throws -> [DetailModel] {
        guard let urlString = buildThemeURL(path: APIConfig.apiUrl.themeLocationBasedList, numOfRows: numOfRows, pageNo: pageNo, lng: lng, lat: lat, radius: radius) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let storyResponse: StoryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = storyResponse.response.body.items.item
        return items
    }
    
    
    /** 이야기 기본 정보 목록 조회
     * - Parameters:
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     *      - tid: 관광지아이디 ( key값으로 해당정보 조회시 tlid와 동시에 입력시 조회 가능함. )
     *      - tlid: 관광지언어아이디( key값으로 해당정보 조회시 tid와 동시에 입력시 조회 가능함. )
     * - Returns: 관광지 목록
     */
    func getStoryBasedList(numOfRows: Int, pageNo: Int, tid: Int? = nil, tlid: Int? = nil) async throws -> [DetailModel] {
        guard let urlString = buildThemeURL(path: APIConfig.apiUrl.storyBasedList, numOfRows: numOfRows, pageNo: pageNo) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let storyResponse: StoryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = storyResponse.response.body.items.item
        return items
    }
    
    /** 이야기 키워드 검색 목록 조회
     * - Parameters:
     *      - keyword: 검색할 키워드
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     * - Returns: 관광지 목록
     */
    func getStorySearchList(keyword: String, numOfRows: Int, pageNo: Int) async throws -> [DetailModel] {
        guard let urlString = buildThemeURL(path: APIConfig.apiUrl.storySearchList, keyword: keyword, numOfRows: numOfRows, pageNo: pageNo) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let storyResponse: StoryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = storyResponse.response.body.items.item
        
        return items
    }
    
    /** 이야기 위치기반 정보 목록 조회
     * - Parameters:
     *      - lng: 경도 - GPS X좌표(WGS84 경도 좌표) ex) 126.615455
     *      - lat: 위도 - GPS Y좌표(WGS84 위도 좌표) ex) 34.476566
     *      - radius: 거리 반경 : 거리 반경(단위:m) ,Max값 20000m=20Km
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     * - Returns: 관광지 목록
     */
    func getStoryLocationBasedList(lng: Double, lat: Double, radius: Int, numOfRows: Int, pageNo: Int) async throws -> [DetailModel] {
        guard let urlString = buildThemeURL(path: APIConfig.apiUrl.storyLocationBasedList, numOfRows: numOfRows, pageNo: pageNo, lng: lng, lat: lat, radius: radius) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let storyResponse: StoryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = storyResponse.response.body.items.item
        return items
    }
    
    
    /** 관광사진갤러리 목록 조회
     * - Parameters:
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     * - Returns: 관광지 목록
     * - Description: 사진갤러리 목록을 조회하는 기능입니다. 제목으로 중복 콘텐츠를 제거하여 그룹화하고, 사진의 URL경로, 촬영월, 촬영장소 등의 내용을 목록으로 제공합니다.
     */
    func getGalleryList(numberOfRows: Int = 1, pageNo: Int = 1) async throws -> [GalleryItem] {
        guard let urlString = buildGalleryURL(path: APIConfig.apiUrl.galleryList1, numOfRows: 10, pageNo: 1) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let galleryResponse: GalleryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = galleryResponse.response.body.items.item
        return items
    }
    
    
    /** 관광사진갤러리 상세 목록 조회
     * - Parameters:
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     *      - title: 요청 키워드(한글 경우, URL 인코딩 필요)
     * - Returns: 관광지 목록
     * - Description: 사진갤러리 상세 목록을 조회하는 기능입니다. 사진갤러리 목록 조회를 통해 제목에 해당하는 그룹화된 목록이며, 사진의 URL경로, 촬영월, 촬영장소 등의 내용을 목록으로 제공합니다
     */
    func getGalleryDetailList(numberOfRows: Int = 1, pageNo: Int = 1, title: String) async throws -> [GalleryItem] {
        guard let urlString = buildGalleryURL(path: APIConfig.apiUrl.galleryDetailList1, numOfRows: 10, pageNo: 1, title: title) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let galleryResponse: GalleryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = galleryResponse.response.body.items.item
        return items
    }
    
    
    /** 관광사진갤러리 키워드 검색 목록 조회
     * - Parameters:
     *      - numOfRows: 한 페이지 결과 수
     *      - pageNo: 페이지 번호
     *      - keyword: 요청 키워드(한글 경우, URL 인코딩 필요)
     * - Returns: 관광지 목록
     * - Description: 키워드검색을 통해 사진갤러리 목록을 조회하는 기능입니다. 키워드검색을 통해 키워드 항목데이터와 매칭되는 정보를 목록으로 표출하며, 제목에 해당하는 그룹화된 목록을 제공합니다.
     */
    func getGallerySearchList(numberOfRows: Int = 1, pageNo: Int = 1, keyword: String) async throws -> [GalleryItem] {
        guard let urlString = buildGalleryURL(path: APIConfig.apiUrl.gallerySearchList1, keyword: keyword, numOfRows: 10, pageNo: 1) else {
            throw NetworkManager.NetworkError.invalidURL
        }
        
        let galleryResponse: GalleryResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        let items = galleryResponse.response.body.items.item
        return items
    }
    
    
    func getAddress(x: Double, y: Double) async throws -> AddressResponse? {
        guard let geocoderApiKey = Bundle.main.object(forInfoDictionaryKey: "GEOCODER_API_KEY") as? String else {
            print("GeoCoder Api Key is missing in Info.plist")
            return nil
        }
        
        let urlString = "\(APIConfig.geocoderBaseURL)?service=address&request=getAddress&version=2.0&crs=epsg:4326&point=\(x), \(y)&format=json&type=both&zipcode=true&simple=false&key=\(geocoderApiKey)"
        let addressResponse: AddressResponse = try await NetworkManager.shared.fetchItemsAsync(from: urlString, headers: ["Content-Type":"application/json"])
        return addressResponse
    }
    
    
    
    /// url query 구성 함수
    func buildThemeURL(path: APIConfig.apiUrl, keyword: String? = nil, numOfRows: Int = 10, pageNo: Int = 1, lng: Double? = nil, lat: Double? = nil, radius: Int? = nil, tid: Int? = nil, tlid: Int? = nil, langCode: String = "ko") -> String? {
        guard let tourApiKey = Bundle.main.object(forInfoDictionaryKey: "TOUR_API_KEY") as? String else {
            print("Tour Api Key is missing in Info.plist")
            return nil
        }
        
        // serviceKey는 인코딩 하면 안됨
        let baseWithKey = "\(APIConfig.audioBaseURL)/\(path)?serviceKey=\(tourApiKey)"
        
        var components = URLComponents()
        
        // 필수 queryItem
        var items: [URLQueryItem] = [
            URLQueryItem(name: "numOfRows", value: "\(numOfRows)"),
            URLQueryItem(name: "pageNo", value: "\(pageNo)"),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "langCode", value: langCode),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        // 키워드가 있을 때만 query에 추가
        if let keyword = keyword {
            items.append(URLQueryItem(name:"keyword", value: keyword))
        }
        
        // 위치기반일때만 추가
        if let lng = lng, let lat = lat, let radius = radius {
            items.append(URLQueryItem(name:"mapX", value: "\(lng)"))
            items.append(URLQueryItem(name:"mapY", value: "\(lat)"))
            items.append(URLQueryItem(name:"radius", value: "\(radius)"))
        }
        
        // 이야기 기본 정보 목록에서 사용.
        if let tid = tid, let tlid = tlid {
            items.append(URLQueryItem(name:"tid", value: "\(tid)"))
            items.append(URLQueryItem(name:"tlid", value: "\(tlid)"))
        }
        
        components.queryItems = items
        
        
        if let query = components.percentEncodedQuery {
            return baseWithKey + "&" + query
        } else {
            return nil
        }
    }
    
    
    /// url query 구성 함수
    func buildGalleryURL(path: APIConfig.apiUrl, keyword: String? = nil, numOfRows: Int = 10, pageNo: Int = 1, title: String? = nil) -> String? {
        guard let tourApiKey = Bundle.main.object(forInfoDictionaryKey: "TOUR_API_KEY") as? String else {
            print("Tour Api Key is missing in Info.plist")
            return nil
        }
        
        // serviceKey는 인코딩 하면 안됨
        let baseWithKey = "\(APIConfig.galleryBaseURL)/\(path)?serviceKey=\(tourApiKey)"
        
        var components = URLComponents()
        
        // 필수 queryItem
        var items: [URLQueryItem] = [
            URLQueryItem(name: "numOfRows", value: "\(numOfRows)"),
            URLQueryItem(name: "pageNo", value: "\(pageNo)"),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        // 키워드가 있을 때만 query에 추가
        if let keyword = keyword {
            items.append(URLQueryItem(name:"keyword", value: keyword))
        }
        
        // 타이틀이 있을 때만 query에 추가
        if let title = title {
            items.append(URLQueryItem(name:"title", value: title))
        }
        
        components.queryItems = items
        
        
        if let query = components.percentEncodedQuery {
            return baseWithKey + "&" + query
        } else {
            return nil
        }
    }
}
