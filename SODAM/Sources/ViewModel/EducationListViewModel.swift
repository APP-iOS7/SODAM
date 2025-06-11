import Foundation

class EducationListViewModel: ObservableObject {
    @Published var spots: [DetailModel]
    var navigationTitle: String
    
    init(spots: [DetailModel], title: String) {
        self.spots = spots
        self.navigationTitle = title
        getAddress()
    }
    
    ///관광지 주소 받아오기
    func getAddress() {
        Task {
            do{
                for i in 0..<spots.count {
                    if let x = Double(spots[i].mapX), let y = Double(spots[i].mapY) {
                        let addr1 = try await APIService.shared.getAddress(x: x, y: y)?.response.result?.last?.structure?.level1
                        let addr2 = try await APIService.shared.getAddress(x: x, y: y)?.response.result?.last?.structure?.level2
                        await self.updateProperties(addr1: String(addr1 ?? ""), addr2: String(addr2 ?? ""), i: i)
                    }
                }
            } catch {
                print("get Address error: \(error)")
            }
        }
    }
    
    /// 관광지 주소 정보 업데이트
    /// - Parameters:
    ///   - addr1: 관광지의 시/도
    ///   - addr2: 관광지의 시/구/군
    ///   - i: 배열 인덱스 번호
    @MainActor func updateProperties(addr1: String, addr2: String, i: Int) {
        spots[i].addr1 = addr1
        spots[i].addr2 = addr2
    }
}
