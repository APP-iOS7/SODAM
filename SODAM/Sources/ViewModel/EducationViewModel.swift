import Foundation
import SwiftUICore

/// 초등교육콘텐츠 모델
struct Education: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
    var category: String
    var lists: [DetailModel]
}

class EducationViewModel: ObservableObject {
    @Published var educations: [Education] = [
        Education(name: "교과서 속 문화 여행", color: Color.secondaryColorBlue, category: "C", lists: []),
        Education(name: "교과서 속 역사 여행", color: Color.secondaryColorPurple, category: "H", lists: []),
        Education(name: "교과서 속 인물 여행", color: Color.secondaryColorRed, category: "P", lists: []),
        Education(name: "교과서 속 과학 여행", color: Color.secondaryColorYellow, category: "S", lists: []),
    ]
    
    init() {
        fetchLists()
    }
    
    /// 초등콘텐츠 카테고리별 데이터 패치
    private func fetchLists() {
        let lists = APIService.shared.loadJSONData() ?? []
        for i in 0...3 {
            educations[i].lists = lists[i]
        }
    }
}
