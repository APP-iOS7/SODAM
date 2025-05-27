import Foundation

class EducationListViewModel: ObservableObject {
//    @Published var category: String
    @Published var spots: [DetailModel]
    //TODO: 초등교육 콘텐츠 카테고리별로 불러오기
    
    init(spots: [DetailModel]) {
        self.spots = spots
    }

}
