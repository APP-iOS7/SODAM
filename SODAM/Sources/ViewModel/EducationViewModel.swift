import Foundation
import SwiftUICore

struct Education: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
    var imageUrl: String
    var category: String
    var lists: [DetailModel]
}

class EducationViewModel: ObservableObject {
    @Published var lists: [[DetailModel]] = []
    @Published var educations: [Education] = [
        Education(name: "교과서 속 문화 여행", color: Color.secondaryColorPurple, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", category: "C", lists: []),
        Education(name: "교과서 속 역사 여행", color: Color.secondaryColorBlue, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", category: "H", lists: []),
        Education(name: "교과서 속 인물 여행", color: Color.secondaryColorRed, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", category: "P", lists: []),
        Education(name: "교과서 속 과학 여행", color: Color.secondaryColorYellow, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg", category: "S", lists: []),
        
    ]
    
    //TODO: 초등교육 콘텐츠 카테고리별로 불러오기
    init() {
        fetchLists()
    }
    private func fetchLists() {
        lists = APIService.shared.loadJSONData() ?? []
        for i in 0...3 {
            educations[i].lists = lists[i]
        }
    }
}
