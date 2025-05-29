import Foundation
import Combine
import SwiftData
import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {
    @Query var visitedSpots: [PlaceItem]
    @Environment(\.modelContext) private var modelContext
    
    @Published var todaySpot: DetailModel = DetailModel(tid: nil, tlid: nil, stid: nil, stlid: nil, themeCategory: nil, category: nil, addr1: "서울특별시", addr2: "종로구", title: "창덕궁", mapX: "129.331719", mapY: "35.7923277", audioTitle: "고대 중세 한국사 속으로", script: nil, playTime: nil, audioUrl: nil, langCheck: nil, langCode: nil, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", createdTime: nil, modifiedtime: nil)
    @Published var nearSpots: [DetailModel] = []
//    @Published var visitedSpots: [PlaceItem]
    @Published var isLoading: Bool = true
    @Published var playerState: Bool = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var item: GalleryItem?
    var filteredRegionList: [DetailModel] { // 데이터 필터링
        nearSpots.filter {
            $0.imageUrl != nil &&
            $0.imageUrl?.isEmpty == false &&
            $0.audioUrl != nil &&
            $0.audioUrl?.isEmpty == false
        }
    }
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        //        self.todaySpot = PlaceItem(title: "", mapX: "", mapY: "")
        //        self.nearSpots = [
        //            DetailModel(tid: nil, tlid: nil, stid: nil, stlid: nil, themeCategory: nil, category: nil, addr1: "경상북도 경주시", addr2: nil, title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", audioTitle: nil, script: nil, playTime: nil, audioUrl: nil, langCheck: nil, langCode: nil, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", createdTime: nil, modifiedtime: nil)
        //        ]
//        self.visitedSpots = [
//            PlaceItem(title: "경주 불국사", mapX: "129.331719", mapY: "35.7923277", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시"),
//            PlaceItem(title: "공주 공산성", mapX: "127.1266933", mapY: "36.4630408", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11173.jpg", addr1: "경상북도 경주시"),
//            PlaceItem(title: "재궁", mapX: "126.9946507", mapY: "37.5739916", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", addr1: "경상북도 경주시"),
//            PlaceItem(title: "공신당", mapX: "126.9940848", mapY: "37.5742758", imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/341.jpg", addr1: "경상북도 경주시")
//        ]
        fetchSpots()
        
        notificationSubject.sink {[weak self] (model, state) in
            self?.playerState = state
        }.store(in: &cancellables)
    }
    
    private func fetchSpots() {
        let userLat = UserLocation.shared.userLat
        let userLon = UserLocation.shared.userLon
        Task {
            do {
                self.isLoading = true
                let nears = try await Array(APIService.shared.getThemeLocationBasedList(lng: userLon, lat: userLat, radius: 10000, numOfRows: 100, pageNo: 1).filter {
                    $0.imageUrl != nil &&
                    $0.imageUrl?.isEmpty == false
                }.sorted(by: { GetDistance(spot: $0) ?? 0 < GetDistance(spot: $1) ?? 0}).prefix(3))
                // TODO: 오디오랑 이미지 다 있는 애가 없음.
                let today = try await APIService.shared.getThemeBasedList(numOfRows: 1000, pageNo: (1...3).randomElement() ?? 1).filter {
                    $0.imageUrl != nil &&
                    $0.imageUrl?.isEmpty == false &&
                    $0.audioUrl != nil &&
                    $0.audioUrl?.isEmpty == false
                }.randomElement() ?? todaySpot
                await self.updateProperties(nears: nears, today: today)
            } catch {
                print("getThemeLocationBasedList ERROR: ", error)
            }
        }
    }
    
    @MainActor func updateProperties(nears: [DetailModel], today: DetailModel ) {
        self.nearSpots = nears
        self.todaySpot = today
        self.isLoading = false
    }
    
    func GetPhoto(spot: DetailModel) {
        Task {
            do {
                if spot.imageUrl != nil && spot.imageUrl?.isEmpty == false {
                    self.item = try await APIService.shared.getGalleryDetailList(title: spot.title).filter{
                        $0.galWebImageUrl != nil && $0.galWebImageUrl?.isEmpty == false}.first ?? nil
                }
            } catch {
                print("getThemeLocationBasedList ERROR: ", error)
            }
        }
    }
    func GetTodaySpot() -> DetailModel{
        return todaySpot
    }
    
    func GetNearSpots() -> [DetailModel] {
        return nearSpots
    }
    func GetVisitedSpots() -> [PlaceItem] {
        return Array(visitedSpots.prefix(5))
    }
    func IsNearSpotEmpty() -> Bool {
        return nearSpots.isEmpty
    }
    func IsVisitedSpotEmpty() -> Bool {
        return visitedSpots.isEmpty
    }
}

func GetDistance(spot: DetailModel) -> Double? {
    let userLat = UserLocation.shared.userLat
    let userLon = UserLocation.shared.userLon
    return haversineDistance(lat1: userLat, lon1: userLon,
                             lat2: Double(spot.mapY) ?? 37.5, lon2: Double(spot.mapX) ?? 126.9
    )
}
