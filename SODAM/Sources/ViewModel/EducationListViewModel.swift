import Foundation

class EducationListViewModel: ObservableObject {
    //    @Published var category: String
    @Published var spots: [DetailModel]
    
    init(spots: [DetailModel]) {
        self.spots = spots
        getAddress()
    }
    
    /**관광지 주소 받아오기*/
    func getAddress() {
        Task {
            do{
                for i in 0..<spots.count {
                    print("1")
                    if let x = Double(spots[i].mapX), let y = Double(spots[i].mapY) {
//                        let address = try await APIService.shared.getAddress(x: x, y: y)?.response.result?.last?.text?.split(separator: " ")
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
    
    @MainActor func updateProperties(addr1: String, addr2: String, i: Int) {
        spots[i].addr1 = addr1
        spots[i].addr2 = addr2
    }
}
