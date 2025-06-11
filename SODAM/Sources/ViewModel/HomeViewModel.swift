import SwiftData
import SwiftUI
import CoreLocation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Environment(\.modelContext) private var modelContext
    
    @Published var isLoading: Bool = true
    @Published var playerState: Bool = false
    @Published var todaySpot: DetailModel? = nil
    @Published var visitedSpots: [PlaceItem] = []
    
    init() {
        fetchTodayStory()   // 오늘의 이야기
        fetchVisitedPlace() // 방문한 관광지
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var item: GalleryItem?

    func updateProperties(nears: [DetailModel], today: DetailModel ) {
        self.isLoading = false
    }
    
    func GetVisitedSpots() -> [PlaceItem] {
        return Array(visitedSpots.prefix(5))
    }
    
    func IsVisitedSpotEmpty() -> Bool {
        return visitedSpots.isEmpty
    }
    
    // TODO: 거리 계산 함수식
    func GetDistance(spot: DetailModel) -> Double? {
        let userLat = UserLocation.shared.userLat
        let userLon = UserLocation.shared.userLon
        return haversineDistance(lat1: userLat, lon1: userLon,
                                 lat2: Double(spot.mapY) ?? 37.5, lon2: Double(spot.mapX) ?? 126.9
        )
    }
    
    // TODO: 오늘의 이야기 비동기 통신 함수
    func fetchTodayStory() {
        let pageNo = Int.random(in: 1...5) // page 번호를 랜덤 난수
        print(pageNo)
        let numOfRows = 1000
        Task {
            isLoading = true
            do {
                let spots = try await APIService.shared.getStoryBasedSyncList(syncStatus: "A", numOfRows: numOfRows, pageNo: pageNo)
                
                let filteredSpots = spots.filter { spot in
                    guard let imageUrl = spot.imageUrl else { return false }
                    guard let audioUrl = spot.audioUrl else { return false }
                    
                    return !imageUrl.isEmpty && !audioUrl.isEmpty
                }
                
                if filteredSpots.count > 0 {
                    let selectedSpot = filteredSpots.randomElement()!
                    self.todaySpot = selectedSpot
                }
            } catch {
                print("리스트 불러오기 실패: \(error)")
            }
            isLoading = false
        }
    }
    
    // 방문한 관광지 가져오기
    func fetchVisitedPlace() {
        do {
            visitedSpots = try DataManager.shared.fetchPlaceItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

