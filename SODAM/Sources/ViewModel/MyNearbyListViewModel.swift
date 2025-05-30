//
//  MyNearbyListViewModel.swift
//  SODAM
//
//  Created by 김용해 on 5/27/25.
//

import Foundation
import CoreLocation
import Combine
import SwiftUICore

class MyNearbyListViewModel: ObservableObject {
    @Published var myLocation: UserLocation
    @Published var isLoading: Bool = false
    @Published var isDataLoading: Bool = false
    @Published var isCreatedViewModel: Bool = false
    @Published var nearTourList: [DetailModel] = []
    var sortedViewModel: [DetailModel] { // 거리 필터링
        guard let location = myLocation.currentLocation else { return nearTourList }
        guard nearTourList.count == allAddress.count else { return nearTourList }
        
        return nearTourList.sorted {
            let distA = haversineDistance(
                lat1: location.coordinate.latitude,
                lon1: location.coordinate.longitude,
                lat2: Double($0.mapY)!,
                lon2: Double($0.mapX)!
            )
            let distB = haversineDistance(
                lat1: location.coordinate.latitude,
                lon1: location.coordinate.longitude,
                lat2: Double($1.mapY)!,
                lon2: Double($1.mapX)!
            )
            return distA < distB
        }
    }
    @Published var allAddress: [String : String] = .init()
    @Published var radius: Int = 10000 // default 반경
    @Published var hasError:Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(myLocation: UserLocation) {
        self.myLocation = myLocation
        // 관광지 가져오기
        nearByTourListPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    if let error = err as? URLError {
                        switch error.code {
                        case .badURL:
                            self.errorMessage = "위치 권한을 확인해주세요"
                        case .dataNotAllowed:
                            self.errorMessage = "관리자에게 문의해주세요"
                        case .badServerResponse:
                            self.errorMessage = "네크워크 연결이 불안정합니다"
                        default:
                            self.errorMessage = error.localizedDescription
                        }
                        self.hasError = true
                    }
                case .finished:
                    break
                }
                
            }, receiveValue: { [weak self] tourListValue in
                self?.nearTourList = tourListValue
                self?.getAddress(from: tourListValue)
                self?.isLoading = false
                self?.isDataLoading = true
            })
            .store(in: &cancellables)
    }
    
    // 근처 관광지 가져오는 Publisher
    func nearByTourListPublisher() -> AnyPublisher<[DetailModel],Error> {
        $radius
            .removeDuplicates()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.isDataLoading = false
            })
            .flatMap { [weak self] radius -> AnyPublisher<[DetailModel], Error> in
                guard let self = self else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
                let lat = self.myLocation.currentLocation?.coordinate.latitude ?? 0
                let lng = self.myLocation.currentLocation?.coordinate.longitude ?? 0
                return self.getStoryLocationBasedListPublisher(lng: lng, lat: lat, radius: radius, numOfRows: 100, pageNo: 1)
            }
            .map { list in
                list.filter {
                    $0.imageUrl?.isEmpty == false &&
                    $0.audioUrl?.isEmpty == false
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    ///**  url query 구성 함수
    ///**  이야기 위치기반 정보 목록 조회 ( 컴바인 )
    //    * - Parameters:
    //    *      - lng: 경도 - GPS X좌표(WGS84 경도 좌표) ex) 126.615455
    //    *      - lat: 위도 - GPS Y좌표(WGS84 위도 좌표) ex) 34.476566
    //    *      - radius: 거리 반경 : 거리 반경(단위:m) ,Max값 20000m=20Km
    //    *      - numOfRows: 한 페이지 결과 수
    //    *      - pageNo: 페이지 번호
    //    * - Returns: 관광지 목록
    //    */
    func getStoryLocationBasedListPublisher(
        lng: Double,
        lat: Double,
        radius: Int,
        numOfRows: Int,
        pageNo: Int,
        langCode: String = "ko"
    ) -> AnyPublisher<[DetailModel], Error> {
        guard let tourApiKey = Bundle.main.object(forInfoDictionaryKey: "TOUR_API_KEY") as? String else {
            print("Tour Api Key is missing in Info.plist")
            return Fail(error: URLError(.dataNotAllowed)).eraseToAnyPublisher()
        }
        
        let baseWithKey = "\(APIConfig.audioBaseURL)/\(APIConfig.apiUrl.storyLocationBasedList)?serviceKey=\(tourApiKey)"
        
        var components = URLComponents()
        
        // 필수 queryItem
        let items: [URLQueryItem] = [
            URLQueryItem(name: "serviceKey", value: tourApiKey),
            URLQueryItem(name: "numOfRows", value: "\(numOfRows)"),
            URLQueryItem(name: "pageNo", value: "\(pageNo)"),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "SODAM"),
            URLQueryItem(name: "mapX", value: "\(lng)"),
            URLQueryItem(name: "mapY", value: "\(lat)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "langCode", value: langCode),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        components.queryItems = items
        
        guard let query = components.percentEncodedQuery else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let url = URL(string: "\(baseWithKey)&\(query)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .tryMap { data in
                if let storyResponse = try? JSONDecoder().decode(StoryResponse.self, from: data) {
                    return storyResponse.response.body.items.item
                } else {
                    // 디코딩이 실패했으면 items가 string임
                    return []
                }
            }
            .eraseToAnyPublisher()
    }
    
    // 필터링 된 관관지의 각 주소 가져오는 비동기함수 ( 병렬 )
    func getAddress(from nearList: [DetailModel]) {
        Task {
            await withTaskGroup(of: (String, String)?.self) { group in
                for near in nearList {
                    // 이미 있는 주소는 skip
                    if let addr1 = near.addr1, !addr1.isEmpty,
                       let addr2 = near.addr2, !addr2.isEmpty {
                        continue
                    }
                    guard
                        let stlid = near.stlid,
                        let x = Double(near.mapX),
                        let y = Double(near.mapY)
                    else {
                        continue
                    }
                    
                    group.addTask {
                        do {
                            let address = try await APIService.shared.getAddress(x: x, y: y)
                            if let text = address?.response.result?.first?.text {
                                return (stlid,text)
                            }
                        } catch {
                            print("주소 가져오기 실패 for \(stlid): \(error)")
                        }
                        return nil
                    }
                }
                
                for await result in group {
                    if let (stlid, text) = result {
                        await MainActor.run {
                            allAddress[stlid] = text
                        }
                    }
                }
            }
        }
    }
}
